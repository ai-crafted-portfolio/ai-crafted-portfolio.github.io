# 設定手順

> 掲載：**18 件（S/A/B/C × 用途、S 級は期待出力サンプル付き）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## 重要度 × 用途 マトリクス

<div class="md-typeset__scrollwrap" markdown="1">

| 重要度＼用途 | DSNZPARM | バッファプール | ログ | DDF | データ共用 | バインド | ユーティリティ | セキュリティ | SQL DI | スキーマ |
|---|---|---|---|---|---|---|---|---|---|---|
| **S** | [cfg-dsnzparm-update](#cfg-dsnzparm-update)<br>[cfg-db2-startup](#cfg-db2-startup) | [cfg-bufferpool-tune](#cfg-bufferpool-tune) | [cfg-log-archive](#cfg-log-archive) | [cfg-ddf-setup](#cfg-ddf-setup) | [cfg-datasharing-add-member](#cfg-datasharing-add-member) | [cfg-bind-package](#cfg-bind-package) | [cfg-image-copy](#cfg-image-copy) | [cfg-racf-acm-setup](#cfg-racf-acm-setup) | — | [cfg-tablespace-create](#cfg-tablespace-create) |
| **A** | [cfg-functionlevel-activate](#cfg-functionlevel-activate)<br>[cfg-applcompat-set](#cfg-applcompat-set) | — | — | [cfg-trusted-context](#cfg-trusted-context) | — | — | [cfg-reorg-online](#cfg-reorg-online)<br>[cfg-runstats-schedule](#cfg-runstats-schedule) | [cfg-grant-permission](#cfg-grant-permission)<br>[cfg-audit-trace](#cfg-audit-trace) | [cfg-sqldi-enable](#cfg-sqldi-enable) | — |
| **B** | — | — | — | — | — | — | [cfg-load-flat](#cfg-load-flat) | — | — | [cfg-stored-proc-setup](#cfg-stored-proc-setup) |
| **C** | — | — | — | — | — | — | [cfg-catalog-maintenance](#cfg-catalog-maintenance) | — | — | — |

</div>

---

## 詳細手順

### cfg-dsnzparm-update: DSNZPARM の更新と反映 { #cfg-dsnzparm-update }

**重要度**: `S` / **用途**: DSNZPARM

**目的**: サブシステムパラメータ（CTHREAD, CONDBAT, IRLMRWT 等）の安全な変更フロー。

**前提**: SDSNSAMP 編集権限、DB2 再起動の業務時間枠調整。

**手順**:

1. `DSN.V13R1.SDSNSAMP(DSNTIJUZ)` を ISPF EDIT で開いてバックアップコピー作成（同一 PDS 内に DSNTIJUZ.OLD 等）
2. DSN6SYSP / DSN6SPRM / DSN6FAC / DSN6LOGP / DSN6ARVP / DSN6GRP の各マクロセクションのパラメータを更新
3. DSNTIJUZ をサブミット（ASMA90 でアセンブル → IEWL でリンク → load module 出力）
4. `-STOP DB2 MODE(QUIESCE)` で停止
5. `-START DB2 PARM(DSNZPARM)` で起動（PARM= で新 load module 名指定）
6. `-DISPLAY ARCHIVE` 等の関連 DISPLAY コマンドで値が反映されたか確認

**期待出力（実機サンプル）**:

DSNTIJUZ サブミット成功時 SYSPRINT:
```
ASMA000I END OF EXTERNAL SYMBOL DICTIONARY
ASMA060I LINKING IS COMPLETE
DSNUTILU UTILITY EXECUTION COMPLETE,  HIGHEST RETURN CODE=0
```
`-START DB2` 成功時:
```
DSNZ002I  -DB2A SUBSYS DB2A SYSTEM PARAMETERS LOAD MODULE NAME DSNZPARM
DSN9022I  -DB2A DSNYASCP 'START DB2' NORMAL COMPLETION
```
失敗時に出る代表メッセージ:
- DSNZ012I（DSNZPARM が見つからない）
- DSN3100I + reason code（パラメータ整合性エラー）

**検証**: `-DISPLAY GROUP DETAIL`、`-DISPLAY ARCHIVE`、各マクロ関連 DISPLAY で値確認

**ロールバック**: 旧 DSNZPARM load module を `-START DB2 PARM(DSNZPARM_OLD)` 等で指定し再起動

**関連**: [cfg-db2-startup](#cfg-db2-startup), [inc-lock-timeout](09-incident-procedures.md#inc-lock-timeout)

**出典**: S_DB2_Install

---

### cfg-db2-startup: Db2 サブシステムの起動と停止 { #cfg-db2-startup }

**重要度**: `S` / **用途**: DSNZPARM

**目的**: Db2 サブシステム（DB2MSTR / DBM1 / DDF / IRLM / DB2SPAS）の安全な起動・停止。

**前提**: SYS コマンド権限、または RACF 経由 DB2.SYSOPR 等の権限。

**手順**:

1. 起動: `-START DB2 [ACCESS(MAINT)] [PARM(DSNZPARM)]`
2. 停止: `-STOP DB2 MODE(QUIESCE)` （長時間 hold thread あれば `MODE(FORCE)`、indoubt 残るリスクあり）
3. STC 停止: IRLM が併走している場合、Db2 停止後に `P IRLMPROC` も必要に応じ実施
4. 起動後 `-DISPLAY THREAD(*)`、`-DISPLAY DDF`、`-DISPLAY GROUP DETAIL` で正常確認

**期待出力（実機サンプル）**:

`-START DB2` 成功時:
```
DSNZ002I  -DB2A SUBSYS DB2A SYSTEM PARAMETERS LOAD MODULE NAME DSNZPARM
DSNL002I  -DB2A DSNJW001 SUBSYSTEM PARAMETERS HAVE BEEN INSTALLED
DSN9022I  -DB2A DSNYASCP 'START DB2' NORMAL COMPLETION
DSNJ099I  -DB2A LOG RECORDING TO BEGIN WITH STARTRBA=000000123456789ABC
```
`-STOP DB2` 成功時:
```
DSN9022I  -DB2A DSNYASCP 'STOP DB2' NORMAL COMPLETION
```
失敗時に出る代表メッセージ:
- DSNX991I（DBM1 起動失敗）
- DSNJ099I + DSNJ002I（log データセット問題）

**検証**: `-DISPLAY THREAD(*)`、`-DISPLAY DDF`、`-DISPLAY DATABASE(*) RESTRICT` で異常状態がないこと

**ロールバック**: 起動失敗時は SYSLOG・MSTR ログ確認後に DSNZPARM ロールバック

**関連**: [cfg-dsnzparm-update](#cfg-dsnzparm-update)

**出典**: S_DB2_Cmds, S_DB2_Admin

---

### cfg-bufferpool-tune: バッファプールの作成・サイズ変更 { #cfg-bufferpool-tune }

**重要度**: `S` / **用途**: バッファプール

**目的**: BP の VPSIZE / VPSEQT / DWQT / VDWQT / PGSTEAL を業務特性に合わせて調整、hit ratio 改善。

**前提**: 仮想記憶（DBM1 region）の余裕、過去の `-DISPLAY BUFFERPOOL DETAIL` 統計。

**手順**:

1. ベースライン取得: `-DISPLAY BUFFERPOOL(*) DETAIL(*)` を 24h 間隔で 1〜2 週間
2. hit ratio 計算: `1 - (SYNC READ + ASYNC READ) / GETPAGE` を BP 別に算出
3. サイジング決定: hit ratio 90%+ を目標に VPSIZE 調整（一般に getpage 数 / 200 程度のバッファ数）
4. 動的反映: `-ALTER BUFFERPOOL(BP1) VPSIZE(50000) VPSEQT(40)`
5. 永続化: DSN6SPRM の対応マクロ更新は不要（catalog の SYSIBM.SYSBPSTATS 等に保持される）。次回 DB2 再起動時に自動 restore

**期待出力（実機サンプル）**:

`-ALTER BUFFERPOOL` 成功時:
```
DSNB511I -DB2A DSNB1CMA  ALTER BUFFERPOOL FOR BP1 SUCCESSFUL
DSNB001I -DB2A DSNB1CMA  BUFFERPOOL  BP1
                        VPSIZE = 50000, VPSEQT = 40, DWQT = 30, VDWQT = 5,0
DSN9022I -DB2A DSNB1CMA 'ALTER BUFFERPOOL' NORMAL COMPLETION
```
`-DISPLAY BUFFERPOOL DETAIL` 抜粋:
```
DSNB401I  -DB2A BUFFERPOOL NAME BP1, BUFFERPOOL ID 1, USE COUNT 28
DSNB402I  -DB2A VIRTUAL BUFFERPOOL SIZE = 50000 BUFFERS
DSNB420I  -DB2A SYNC READ I/O (SINGLE) - 12345
DSNB421I  -DB2A GETPAGE REQUEST = 9876543
```
失敗時に出る代表メッセージ:
- DSNB502I（VPSIZE 不正値）
- DSNB604I（仮想記憶不足）

**検証**: 1〜2 日後に `-DISPLAY BUFFERPOOL DETAIL` で hit ratio 改善確認

**ロールバック**: `-ALTER BUFFERPOOL VPSIZE(<旧値>)` で即時ロールバック

**関連**: [inc-lock-escalation](09-incident-procedures.md#inc-lock-escalation), [cfg-runstats-schedule](#cfg-runstats-schedule)

**出典**: S_DB2_Perf, S_DB2_RB_BPTune

---

### cfg-log-archive: アクティブログ・アーカイブログの構成 { #cfg-log-archive }

**重要度**: `S` / **用途**: ログ

**目的**: 二重ログ（TWOACTV/TWOARCH）、archive 媒体（DASD/TAPE）、ARCRETN を業務 RPO に合わせて設計。

**前提**: 業務 RPO・RTO 要件、archive 媒体の容量計画。

**手順**:

1. DSN6LOGP のパラメータ更新: TWOACTV=YES、TWOARCH=YES、OUTBUFF=4000、CHECKFREQ=5（分）、MAXARCH=1000
2. DSN6ARVP のパラメータ更新: UNIT（DASD or TAPE）、ARCRETN（保管日数 = 復旧最古点 + マージン）、ARCWTOR=NO（自動マウント環境）
3. DSNTIJUZ アセンブル → load module 更新
4. DB2 再起動: `-STOP DB2` → `-START DB2 PARM(DSNZPARM)`
5. `-DISPLAY LOG`、`-DISPLAY ARCHIVE` で構成確認

**期待出力（実機サンプル）**:

`-DISPLAY LOG` 成功時:
```
DSNJ370I -DB2A DSNJC00A LOG DISPLAY
CURRENT COPY1 LOG = DB2A.LOGCOPY1.DS01 IS 23% FULL
CURRENT COPY2 LOG = DB2A.LOGCOPY2.DS01 IS 23% FULL
H/W RBA = 000000123456789ABC
H/O RBA = 0000001234567880CD
FULL LOGS TO OFFLOAD = 0 OF 6
OFFLOAD TASK IS (AVAILABLE)
DSNJ371I -DB2A DB2 RESTARTED 2026-04-12 12:34:56
```
`-DISPLAY ARCHIVE`:
```
DSNJ322I -DB2A DISPLAY ARCHIVE REPORT FOLLOWS-
COUNT TIME              STARTRBA            ENDRBA
   1  2026-04-12.09.30  000000123456000     0000001234567FFF
   2  2026-04-12.10.30  000000123457800     000000123459FFF
DSNJ323I -DB2A DSNJC00A DISPLAY ARCHIVE REPORT COMPLETE
```
失敗時に出る代表メッセージ:
- DSNJ100I（BSDS 損傷）
- DSNJ110E / DSNJ111E（archive log 媒体不足）

**検証**: 1 日後 `-DISPLAY ARCHIVE`、SYSCOPY 履歴と整合確認

**ロールバック**: 旧 DSNZPARM に戻す

**関連**: [inc-log-archive-fail](09-incident-procedures.md#inc-log-archive-fail), [inc-bsds-corrupt](09-incident-procedures.md#inc-bsds-corrupt)

**出典**: S_DB2_Admin

---

### cfg-ddf-setup: DDF（分散データ）構成 { #cfg-ddf-setup }

**重要度**: `S` / **用途**: DDF

**目的**: DDF を介した remote 接続を有効化、CMTSTAT=INACTIVE で DBAT pooling。

**前提**: TCP/IP 構成、TCP port（既定 446）の予約、DSN6FAC マクロ更新権限。

**手順**:

1. PROFILE.TCPIP に DRDA port を予約: `PORT 446 TCP DB2DIST`
2. BSDS の DDF レコード設定: `DSNJU003 DDF` で LOCATION/IPNAME/PORT を登録
3. DSN6FAC の更新: CMTSTAT=INACTIVE、IDTHTOIN=120、CONDBAT=10000、MAXDBAT=200（DSN6SYSP）
4. DSNTIJUZ サブミット → load module 更新
5. `-STOP DDF` → DB2 再起動 or `-START DDF`
6. `-DISPLAY DDF DETAIL` で確認、remote から CONNECT で疎通テスト

**期待出力（実機サンプル）**:

`-DISPLAY DDF DETAIL` 成功時:
```
DSNL080I -DB2A DSNLTDDF DISPLAY DDF REPORT FOLLOWS:
DSNL081I  STATUS=STARTD
DSNL082I  LOCATION   LUNAME            GENERICLU
DSNL083I  LOC1       NETLU.DB2A        NETLU.DB2GEN
DSNL084I  TCPPORT=446 SECPORT=448 RESPORT=5001 IPNAME=-NONE
DSNL085I  IPADDR=::ffff:10.1.1.10
DSNL090I  DT=I  CONDBAT=10000 MDBAT=200
DSNL092I  ADBAT=15  QUEDBAT=0  INADBAT=2  CONQUED=0
DSNL099I  DSNLTDDF DISPLAY DDF REPORT COMPLETE
```
失敗時に出る代表メッセージ:
- DSNL004I（DDF 起動失敗）
- DSNL031I（DBAT 枯渇）

**検証**: 1 週間 `-DISPLAY DDF DETAIL` で QUEDBAT/INADBAT 推移確認

**ロールバック**: 旧 DSN6FAC で再アセンブル

**関連**: [inc-ddf-down](09-incident-procedures.md#inc-ddf-down), [cfg-trusted-context](#cfg-trusted-context)

**出典**: S_DB2_DDF

---

### cfg-datasharing-add-member: データ共用グループへのメンバ追加 { #cfg-datasharing-add-member }

**重要度**: `S` / **用途**: データ共用

**目的**: 既存データ共用グループに新規メンバ（n+1 番目）を追加し scaling。

**前提**: CFRM policy、SCA / LOCK1 / GBP の CF structure、MVS Sysplex メンバ追加済。

**手順**:

1. 新メンバ用 SDSNSAMP コピー作成、DSN6GRP の MEMBNAME を新値に
2. CFRM policy に新メンバ用 GBP/SCA/LOCK1 のサイズ拡張を反映、`SETXCF START,POL` で活性化
3. 既存メンバの SYSCOPY / catalog バックアップ取得（保険）
4. 新メンバの DSNTIJUZ → DSNTIJIN（initialize）→ 起動 `-START DB2` で group join
5. `-DISPLAY GROUP DETAIL` で全メンバ ACTIVE、Function Level 整合を確認

**期待出力（実機サンプル）**:

`-DISPLAY GROUP DETAIL` 成功時:
```
DSN7100I  -DB2C DSN7GCMD
*** BEGIN DISPLAY OF GROUP(DSNGRP01)  CATALOG LEVEL(V13R1M501)
                  CURRENT FUNCTION LEVEL(V13R1M501)
DB2     SYSTEM       MEMBER       STATUS    DB2  PROTOCOL
MEMBER  NAME         ID           LVL  LVL
DB2A    SY01         1            ACTIVE     V13R1   PRIVATE
DB2B    SY02         2            ACTIVE     V13R1   PRIVATE
DB2C    SY03         3            ACTIVE     V13R1   PRIVATE   <-- new member
*** END DISPLAY OF GROUP
```
失敗時に出る代表メッセージ:
- DSN7501I（group join 失敗）
- DSNB319I（GBP connect 失敗）

**検証**: 数日 `-DISPLAY GROUPBUFFERPOOL`、`-DISPLAY GROUP DETAIL` で安定確認

**ロールバック**: 新メンバ `-STOP DB2 MODE(QUIESCE)` → CFRM 元に戻す

**関連**: [cfg-functionlevel-activate](#cfg-functionlevel-activate)

**出典**: S_DB2_DataSharing, S_DB2_RB_DSPlan

---

### cfg-bind-package: PACKAGE / PLAN の BIND { #cfg-bind-package }

**重要度**: `S` / **用途**: バインド

**目的**: 業務アプリの SQL を Db2 上で実行可能な形にコンパイル（package）し、plan 経由で実行可能にする。

**前提**: DBRM ライブラリ、collection 名、適用 APPLCOMPAT 決定。

**手順**:

1. プリコンパイラまたは coprocessor で source → DBRM 出力
2. DBRM ライブラリを DSN.V13R1 配下にコピー
3. `BIND PACKAGE(<coll>) MEMBER(<dbrm>) ACTION(REPLACE) APPLCOMPAT(V13R1) ISOLATION(CS)` 実行
4. 必要なら `BIND PLAN(<plan>) PKLIST(<coll>.*)` で plan に組み込み
5. `SELECT * FROM SYSIBM.SYSPACKAGE WHERE COLLID='<coll>'` で確認
6. `RUN PROGRAM(<pgm>) PLAN(<plan>)` でテスト

**期待出力（実機サンプル）**:

BIND PACKAGE 成功時 SYSTSPRT:
```
DSNT200I -DB2A BIND OPTIONS FOR PACKAGE = COLL.PKG.V1
DSNT232I -DB2A SUCCESSFUL BIND FOR
        PACKAGE = COLL.PKG.V1
DSNT236I -DB2A BIND PACKAGE SUMMARY:
        SUCCESSFUL: 1, FAILED: 0
```
失敗時に出る代表メッセージ:
- DSNT220I（DBRM not found）
- DSNT225I（SQLCODE -727、APPLCOMPAT 不整合）

**検証**: `RUN PROGRAM` でテスト実行、EXPLAIN で access path 確認

**ロールバック**: `BIND PACKAGE ACTION(REPLACE)` で旧 version に戻す

**関連**: [cfg-applcompat-set](#cfg-applcompat-set), [inc-package-notfound](09-incident-procedures.md#inc-package-notfound)

**出典**: S_DB2_AppPgm, S_DB2_Cmds

---

### cfg-image-copy: イメージコピー戦略 { #cfg-image-copy }

**重要度**: `S` / **用途**: ユーティリティ

**目的**: 復旧基点を計画的に取得（FULL + INCREMENTAL の組合せ）、SYSCOPY 履歴を健全に保つ。

**前提**: COPY ジョブの実行枠、DASD/TAPE 媒体。

**手順**:

1. COPY 戦略決定: 例 = 週末 FULL、平日深夜 INCREMENTAL
2. JCL 作成: `COPY TABLESPACE <db>.<ts> SHRLEVEL CHANGE COPYDDN(SYSCOPY1,SYSCOPY2) FULL YES`（FULL 用）/ `FULL NO`（INCR 用）
3. 月次で `MERGECOPY` を回し incremental を full に統合
4. `SELECT * FROM SYSIBM.SYSCOPY ORDER BY TIMESTAMP DESC FETCH FIRST 30 ROWS ONLY` で履歴確認
5. 古い COPY 媒体の expiration を確認、ARCRETN との整合

**期待出力（実機サンプル）**:

COPY 成功時 SYSPRINT:
```
DSNU000I  DSNUGUTC - OUTPUT START FOR UTILITY, UTILID = COPY01
DSNU050I  DSNUGUTC - COPY TABLESPACE PRODDB.TS01 SHRLEVEL CHANGE COPYDDN(SYSCOPY1)
DSNU400I  DSNUBBID - COPY PROCESSED FOR TABLESPACE PRODDB.TS01
                    NUMBER OF PAGES=12345
                    AVERAGE PERCENT FREE SPACE PER PAGE = 5.00
DSNU010I  DSNUGBAC - UTILITY EXECUTION COMPLETE, HIGHEST RETURN CODE=0
```
失敗時に出る代表メッセージ:
- DSNU401I（COPY pending 解除失敗）
- DSNU110I（TS open 失敗）

**検証**: SYSCOPY に新エントリ追加、対応 image copy データセットが catalog 済

**ロールバック**: 不要（COPY は読取専用）

**関連**: [inc-tablespace-corrupt](09-incident-procedures.md#inc-tablespace-corrupt), [cfg-log-archive](#cfg-log-archive)

**出典**: S_DB2_Util

---

### cfg-racf-acm-setup: RACF Access Control Module の有効化 { #cfg-racf-acm-setup }

**重要度**: `S` / **用途**: セキュリティ

**目的**: Db2 の権限チェックを RACF にオフロード、auth を SAF クラスで集中管理。

**前提**: RACF 管理権限、DSNX@XAC 提供（SDSNSAMP）。

**手順**:

1. RACF クラス活性化: `SETROPTS CLASSACT(DSNADM,DSNDB,DSNTB,DSNCL,DSNSP,...)`
2. DSNX@XAC（提供サンプル）を assemble、DSN.V13R1.SDSNEXIT 等に link
3. profile 定義: `RDEFINE DSNDB DB2A.PRODDB UACC(NONE)` 等
4. PERMIT: `PERMIT DB2A.PRODDB CLASS(DSNDB) ID(<grp>) ACCESS(READ)`
5. DB2 再起動で DSNX@XAC が有効化
6. `-START TRACE(AUDIT) CLASS(*)` で監査トレース併用推奨

**期待出力**:
```
ICH02000I PROFILE DSNDB.PRODDB DEFINED IN CLASS DSNDB
DSNX@XAC IS ACTIVE  (Db2 START 時の MSTR メッセージ)
```

**検証**: 既存業務の影響なし、`-DISPLAY GRANT`（参考）/ SYSIBM.SYSTABAUTH と RACF profile の整合

**ロールバック**: DSNX@XAC を元の sample（no-op）に戻して再アセンブル → DB2 再起動

**関連**: [cfg-grant-permission](#cfg-grant-permission)

**出典**: S_DB2_RACF, S_DB2_Sec

---

### cfg-tablespace-create: テーブル空間の作成 { #cfg-tablespace-create }

**重要度**: `S` / **用途**: スキーマ

**目的**: 業務テーブル用の Universal Tablespace（UTS-PBR / UTS-PBG）を新規作成。

**前提**: STOGROUP 定義、buffer pool 選定。

**手順**:

1. STOGROUP 確認: `SELECT * FROM SYSIBM.SYSSTOGROUP`
2. CREATE TABLESPACE 実行（PBG の例）:
   ```sql
   CREATE TABLESPACE TS01 IN PRODDB
     USING STOGROUP STO1
     PRIQTY 7200 SECQTY 7200
     BUFFERPOOL BP4
     LOCKSIZE ANY  LOCKMAX SYSTEM
     PCTFREE 5  FREEPAGE 0
     COMPRESS YES
     MAXPARTITIONS 256;  -- PBG
   ```
3. CREATE TABLE で表追加
4. CREATE INDEX で索引追加
5. `-DISPLAY DATABASE(PRODDB) SPACENAM(TS01)` で `RW` 確認

**注意点**: Db2 13 では partition by range（PBR）の online conversion がサポートされた。新規は将来の拡張性を考慮し PBG 開始 → 必要時 PBR 化が現代的。

**検証**: SYSIBM.SYSTABLESPACE に登録、既存業務の SQL から SELECT 可能

**ロールバック**: `DROP TABLESPACE PRODDB.TS01`（依存 object 全 drop 後）

**関連**: [cfg-bind-package](#cfg-bind-package)

**出典**: S_DB2_Admin, S_DB2_SQLRef

---

### cfg-functionlevel-activate: Function Level の活性化 { #cfg-functionlevel-activate }

**重要度**: `A` / **用途**: DSNZPARM

**目的**: 新 Function Level（FL501 / FL502 等）の機能を有効化。

**前提**: CATMAINT 完了、Catalog Level が新 FL の前提を満たす。

**手順**:

1. `-DISPLAY GROUP DETAIL` で `HIGHEST POSSIBLE FUNCTION LEVEL` 確認（適用可能なら表示される）
2. 必要なら CATMAINT で catalog upgrade: `EXEC PGM=DSNUTILB ... CATMAINT UPDATE LEVEL V13R1M501`
3. `-ACTIVATE FUNCTION LEVEL(V13R1M501)` で活性化
4. `-DISPLAY GROUP DETAIL` で `CURRENT FUNCTION LEVEL` が更新されたことを確認
5. APPLCOMPAT を新 FL に対応する値で BIND（必要なアプリのみ）

**注意点**: 活性化後の retrofit は基本不可（fallback 機能あるが慎重に）。データ共用環境では全メンバの DB2 13 移行完了が前提。

**検証**: 新機能（FL501 なら SQL DI、FL502 以降なら其々）が利用可能

**ロールバック**: `-ACTIVATE FUNCTION LEVEL(V13R1M500)` 等で旧レベルに（catalog level は戻せない場合あり）

**関連**: [cfg-applcompat-set](#cfg-applcompat-set), [cfg-sqldi-enable](#cfg-sqldi-enable)

**出典**: S_DB2_FuncLevels, S_DB2_Install

---

### cfg-applcompat-set: Application Compatibility の切替 { #cfg-applcompat-set }

**重要度**: `A` / **用途**: DSNZPARM

**目的**: 個別アプリの SQL 機能セットを段階的に新 FL に追従。

**前提**: BIND/REBIND 権限、影響範囲調査。

**手順**:

1. 既存 PACKAGE の APPLCOMPAT 一覧: `SELECT COLLID,NAME,APPLCOMPAT FROM SYSIBM.SYSPACKAGE`
2. 対象 PACKAGE 群を選定（例: 業務 A の collection）
3. `REBIND PACKAGE(<coll>.*) APPLCOMPAT(V13R1) APREUSE(WARN)` で再 BIND
4. テスト実行 → 既存 access path 維持確認
5. 動的 SQL は `SET CURRENT APPLICATION COMPATIBILITY = 'V13R1'` でセッション制御も可能

**注意点**: 新 APPLCOMPAT で deprecated になった機能（v11/12 で動いていた古い構文）が SQLCODE -8001/-20354 等になる可能性あり。先に SQL DI（仮想実行）で互換性確認推奨。

**検証**: SYSIBM.SYSPACKAGE.APPLCOMPAT 反映、業務テスト pass

**ロールバック**: `REBIND PACKAGE APPLCOMPAT(<旧値>)`

**関連**: [cfg-bind-package](#cfg-bind-package), [cfg-functionlevel-activate](#cfg-functionlevel-activate)

**出典**: S_DB2_AppPgm

---

### cfg-trusted-context: Trusted Context / Role の設定 { #cfg-trusted-context }

**重要度**: `A` / **用途**: DDF

**目的**: 3-tier アプリの代理アカウントに対し、IP/jobname 制限つきで追加権限（ROLE）を付与。

**前提**: アプリ側の接続 IP / jobname が固定。

**手順**:

1. ROLE 作成: `CREATE ROLE APPROLE1`
2. ROLE への権限付与: `GRANT SELECT ON PRODSCH.TAB TO ROLE APPROLE1`
3. TRUSTED CONTEXT 作成:
   ```sql
   CREATE TRUSTED CONTEXT APPCTX1
     BASED UPON CONNECTION USING SYSTEM AUTHID 'APPUSER'
     ATTRIBUTES (ADDRESS '10.20.30.40')
     DEFAULT ROLE APPROLE1
     ENABLE;
   ```
4. アプリから接続して権限が ROLE 経由で使えるか確認

**注意点**: Trusted Context は `ATTRIBUTES` 句で IP / DOMAIN / JOBNAME 等の条件を細かく定義可能。条件外の接続は default role を使えない。

**検証**: `SELECT * FROM SYSIBM.SYSCONTEXT`、`SELECT * FROM SYSIBM.SYSCTXTROLE`

**ロールバック**: `DROP TRUSTED CONTEXT APPCTX1`

**関連**: [cfg-grant-permission](#cfg-grant-permission)

**出典**: S_DB2_Sec, S_DB2_DDF

---

### cfg-reorg-online: オンライン REORG（SHRLEVEL CHANGE） { #cfg-reorg-online }

**重要度**: `A` / **用途**: ユーティリティ

**目的**: 業務継続中にテーブル空間 REORG を実行、free space 回復・cluster ratio 改善。

**前提**: shadow dataset 用容量（元 TS と同じくらい）、業務時間枠の SWITCH phase 余裕。

**手順**:

1. REORG JCL: `REORG TABLESPACE PRODDB.TS01 SHRLEVEL CHANGE LOG NO COPYDDN(...) MAXRO 600 DRAIN_WAIT 60 RETRY 3`
2. サブミット → `-DISPLAY UTILITY(REORGTS01)` で phase 監視
3. RELOAD phase で shadow に書込、SWITCH phase で原 dataset と差替
4. SWITCH 中の業務影響：60 秒程度の drain（業務 timeout 注意）
5. 完了後 `-DISPLAY DATABASE RESTRICT` で pending なし確認

**注意点**: `MAXRO`（最終 LOG iteration の最大時間）と `DRAIN_WAIT` のチューニングが重要。`DEADLINE` 句で打ち切り時刻も指定可能。

**検証**: SYSIBM.SYSTABLESPACE.PCTROWCOMP 等の改善確認

**ロールバック**: 失敗時はオリジナル dataset に切り戻り（自動）。COPYDDN 取得していれば RECOVER も可能。

**関連**: [cfg-image-copy](#cfg-image-copy), [inc-utility-stuck](09-incident-procedures.md#inc-utility-stuck)

**出典**: S_DB2_Util, S_DB2_RB_Db213Perf

---

### cfg-runstats-schedule: RUNSTATS の自動化 { #cfg-runstats-schedule }

**重要度**: `A` / **用途**: ユーティリティ

**目的**: 定期 RUNSTATS でカタログ統計を最新化、Optimizer の access path 適切化。

**前提**: 業務時間外の実行枠。

**手順**:

1. 対象 TS リスト作成（更新頻度高いもの優先）
2. JCL: `RUNSTATS TABLESPACE PRODDB.TS01 TABLE(ALL) INDEX(ALL) SHRLEVEL CHANGE HISTORY ALL`
3. 週次・月次など頻度別にバッチ化、IBM Workload Automation 等で schedule
4. STATISTICS PROFILE を使うと再現性高い `RUNSTATS USE PROFILE` 利用可能（Db2 12 以降）
5. 完了後 SYSIBM.SYSTABLES、SYSIBM.SYSINDEXES の STATSTIME を確認

**注意点**: RUNSTATS 後に access path 劣化があれば REBIND で APREUSE 等を活用、または STATISTICS PROFILE で stable 統計を強制。

**検証**: SYSIBM.SYSCOLDIST 等の更新確認、業務 SQL の応答時間モニタリング

**ロールバック**: `RUNSTATS RESET ACCESSPATH` で統計クリア（極力使わない）

**関連**: [cfg-bufferpool-tune](#cfg-bufferpool-tune)

**出典**: S_DB2_Util, S_DB2_Perf

---

### cfg-grant-permission: GRANT / REVOKE の運用 { #cfg-grant-permission }

**重要度**: `A` / **用途**: セキュリティ

**目的**: 業務 user / group に最小権限の GRANT。

**手順**:

1. 業務要件から必要権限を整理（SELECT/INSERT/UPDATE/DELETE on テーブル、EXECUTE on package など）
2. グループ単位で GRANT: `GRANT SELECT,INSERT ON PRODSCH.TAB TO PRODGRP`
3. 権限委譲が必要なら `WITH GRANT OPTION` 付与
4. SYSIBM.SYSTABAUTH / SYSIBM.SYSPACKAUTH 等で確認

**注意点**: RACF Access Control Module 有効環境では Db2 自体ではなく RACF 側の PERMIT が主。Db2 GRANT は記録される（catalog）が実権限は RACF。

**検証**: 対象 user の RUN PROGRAM や SELECT で SQLCODE -551 等が出ないこと

**ロールバック**: `REVOKE SELECT ON PRODSCH.TAB FROM PRODGRP`

**関連**: [cfg-racf-acm-setup](#cfg-racf-acm-setup)

**出典**: S_DB2_Sec

---

### cfg-audit-trace: AUDIT TRACE の設定 { #cfg-audit-trace }

**重要度**: `A` / **用途**: セキュリティ

**目的**: SOX / 個人情報保護等の監査要件に応える、SMF type 102 を集める。

**手順**:

1. SMFPRMxx で type 102 を記録対象に: `TYPE(0,30,42,...,100,101,102)`
2. `-START TRACE(AUDIT) DEST(SMF) CLASS(1,2,3,4,5,6,7,8,10) ACCTG(*)` （CLASS 別に: 1=AUTHFAIL, 2=GRANT, 3=DDL, 4=DML対SENSITIVE等, 5=BIND, 6=ASSIST, 7=SET CURRENT, 8=UTILITY, 10=TRUSTED CONTEXT）
3. SMF 102 のレコード抽出: `IFASMFDP` で type 102 を unload、専用 reporting tool で集計
4. `-DISPLAY TRACE(AUDIT)` で active trace 確認

**注意点**: CLASS 4（DML on AUDIT 対象表）は対象表に `AUDIT CHANGES` 句が必要。CLASS 1 / 2 は Db2 全体に効く。

**検証**: SMF 102 レコードが SMF データセットに記録されている

**ロールバック**: `-STOP TRACE(AUDIT)`

**関連**: [cfg-grant-permission](#cfg-grant-permission)

**出典**: S_DB2_Sec, S_ZOS_SMF

---

### cfg-sqldi-enable: SQL Data Insights の有効化 { #cfg-sqldi-enable }

**重要度**: `A` / **用途**: SQL DI

**目的**: Db2 13 FL501 の AI 関数（AI_SIMILARITY 等）を業務表に対して使えるようにする。

**前提**: Function Level 501 以上、SQL DI 用 z/OS Container Extensions（zCX）または専用環境、対象表のメタデータ。

**手順**:

1. FL501 以上に活性化: [cfg-functionlevel-activate](#cfg-functionlevel-activate) で FL501+
2. SQL DI ユーザインターフェース（Db2 Admin Tool / Web UI）で対象表を選択
3. モデル学習: 内部的に z/OS 上で表データから embedding 生成
4. SYSAIDB / SYSAIOBJECTS catalog 表に model 状態が反映される
5. SQL で `AI_SIMILARITY(col1, col2)` 等の組込関数を使う

**注意点**: SQL DI のセットアップは別 Redbook（SQL Data Insights）参照。学習対象表のサイズと CPU 消費は比例、本番影響を考慮した時間枠で実施。

**検証**: `SELECT AI_SIMILARITY(c1, c2) FROM TAB FETCH FIRST 1 ROW ONLY` が成功

**ロールバック**: model 削除（SQL DI UI から）、FL retrofit は限定的

**関連**: [cfg-functionlevel-activate](#cfg-functionlevel-activate)

**出典**: S_DB2_SQLDI

---

### cfg-load-flat: フラットファイルからの LOAD { #cfg-load-flat }

**重要度**: `B` / **用途**: ユーティリティ

**目的**: 大量データを外部ファイルから一括投入。

**手順**:

1. データファイル準備（固定長 / 区切り）
2. JCL: `LOAD DATA INDDN INFILE INTO TABLE PRODSCH.TAB RESUME YES`
3. 完了後 SYSCOPY に LOAD 履歴記録（COPY YES の場合は image copy も同時取得）
4. `-DISPLAY DATABASE RESTRICT` で COPY pending 等の解除確認

**注意点**: `LOG NO` は速いが COPY YES 必須（または事後 COPY）。`SHRLEVEL CHANGE` は v12 以降の online LOAD（partition 単位）。

**ロールバック**: 投入分の DELETE、または事前イメージコピーから RECOVER

**関連**: [cfg-image-copy](#cfg-image-copy), [inc-restp-recovery](09-incident-procedures.md#inc-restp-recovery)

**出典**: S_DB2_Util

---

### cfg-stored-proc-setup: ストアドプロシージャ環境セットアップ { #cfg-stored-proc-setup }

**重要度**: `B` / **用途**: スキーマ

**目的**: WLM 制御の SPAS（DB2SPAS）を業務種別ごとに用意し、stored procedure を実行可能にする。

**手順**:

1. WLM Application Environment 作成（ISPF WLM パネル）: `DB2APP1`
2. SPAS PROC 作成 / 修正（DSN.V13R1.SDSNSAMP の DSNTPSMP 等参考）
3. WLM POLICY ACTIVATE
4. CREATE PROCEDURE: `CREATE PROCEDURE PRODSCH.PROC1 LANGUAGE SQL ... WLM ENVIRONMENT DB2APP1`
5. `CALL PRODSCH.PROC1(...)` でテスト

**注意点**: native SQL/PL は SPAS 不要（Db2 内部で動作）。external（COBOL/Java/C）は SPAS 必須。

**ロールバック**: `DROP PROCEDURE PRODSCH.PROC1`

**関連**: [cfg-bind-package](#cfg-bind-package)

**出典**: S_DB2_AppPgm

---

### cfg-catalog-maintenance: カタログメンテナンス { #cfg-catalog-maintenance }

**重要度**: `C` / **用途**: ユーティリティ

**目的**: catalog テーブル空間の REORG、RUNSTATS、image copy 取得。

**手順**:

1. REORG: `REORG TABLESPACE DSNDB06.* SHRLEVEL CHANGE`（並列で複数 TS）
2. RUNSTATS: `RUNSTATS TABLESPACE DSNDB06.* TABLE(ALL) INDEX(ALL)`
3. COPY: `COPY TABLESPACE DSNDB06.* SHRLEVEL CHANGE`
4. directory（DSNDB01）も同様に対応（一部は専用 utility が必要）

**注意点**: catalog は Db2 自身が使うため、メンテ中はサブシステム全体の応答に影響。短時間枠で実施推奨。

**ロールバック**: 不要（読取専用 utility）または事前 COPY から RECOVER

**関連**: [cfg-image-copy](#cfg-image-copy), [cfg-runstats-schedule](#cfg-runstats-schedule)

**出典**: S_DB2_Admin, S_DB2_Util

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
