# 障害対応手順

> 掲載：**18 件（S/A/B/C × 用途、S 級は A/B/C 仮説分岐付き）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## 重要度 × 用途 マトリクス

<div class="md-typeset__scrollwrap" markdown="1">

| 重要度＼用途 | ロック | アクセス | カタログ | DDF | ログ | バインド | パフォーマンス | リソース | ユーティリティ |
|---|---|---|---|---|---|---|---|---|---|
| **S** | [inc-lock-timeout](#inc-lock-timeout)<br>[inc-deadlock](#inc-deadlock)<br>[inc-lock-escalation](#inc-lock-escalation) | [inc-tablespace-corrupt](#inc-tablespace-corrupt) | [inc-bsds-corrupt](#inc-bsds-corrupt) | [inc-ddf-down](#inc-ddf-down)<br>[inc-indoubt-thread](#inc-indoubt-thread) | [inc-log-archive-fail](#inc-log-archive-fail) | [inc-package-notfound](#inc-package-notfound) | — | — | [inc-utility-stuck](#inc-utility-stuck) |
| **A** | — | [inc-restp-recovery](#inc-restp-recovery) | [inc-catalog-inconsistency](#inc-catalog-inconsistency) | [inc-ddf-dbat-shortage](#inc-ddf-dbat-shortage) | — | — | [inc-bp-shortage](#inc-bp-shortage) | [inc-storage-shortage](#inc-storage-shortage) | — |
| **B** | — | — | — | — | — | [inc-rebind-needed](#inc-rebind-needed) | — | — | [inc-utility-abend](#inc-utility-abend) |
| **C** | — | — | — | — | — | — | — | [inc-irlm-stop](#inc-irlm-stop) | — |

</div>

---

## 詳細手順

### inc-lock-timeout: ロックタイムアウト（SQLCODE -911 / -913） { #inc-lock-timeout }

**重要度**: `S` / **用途**: ロック

**目的**: IRLM の lock timeout（IRLMRWT 超過）で被害アプリが SQLCODE -911（victim、auto-rollback）/ -913（caller、no rollback）を受けた場合の切り分け。

**前提**: SQL モニタ、IRLMRWT 値把握、`-DISPLAY THREAD` 権限。

**仮説分岐（切り分けの第一歩）**:

_トリガ事象_: アプリで SQLCODE -911 / -913 多発、SQL diagnostic に reason code（00C9009E = timeout）

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | 長時間 hold アプリ（commit 不足）の被害 | `-DISPLAY THREAD(*) DETAIL` で長時間 active のスレッド特定、業務 commit 頻度確認 | アプリの commit 周期見直し（数千行〜数万行/commit）、`HOLD CURSOR` 使用見直し |
| **B** | バッチ × オンライン同時稼働の競合 | スケジュール上の重なり、対象 TS が同じ | スケジュール調整、または lock granularity（LOCKSIZE PAGE/ROW）見直し |
| **C** | 巨大トランザクションの lock escalation | NUMLKTS 超過の警告、lock 数が多い | NUMLKTS 拡大、または LOCKSIZE 調整、必要なら `LOCK TABLE` 句で意図的な粗粒度化 |

_共通の最初の動作_: SQLCODE と reason code（00C9009E など）を必ず保存。`-DISPLAY THREAD(*) DETAIL` を timeout 直後に取得。

**手順（共通）**:

1. SQLCODE / reason code 取得（00C9009E = timeout、00C90088 = deadlock）
2. `-DISPLAY THREAD(*) DETAIL` で active スレッド一覧
3. IRLM `F IRLMPROC,STATUS,ALLI` でロック数確認
4. 該当アプリのロック範囲・isolation level を SYSPACKAGE / SYSPLAN で確認
5. 必要なら IRLMRWT を `F IRLMPROC,SET,TIMEOUT=(<dbssn>,<seconds>)` で動的調整

**期待出力**:

```
SQL diagnostic:
SQLCODE = -911
SQLSTATE = 40001
reason code = 00C9009E (timeout)
```

**検証**: 同条件で再発しないこと、`-DISPLAY THREAD` で hold thread 解消

**ロールバック**: IRLMRWT 動的変更は `F IRLMPROC,SET,TIMEOUT=(...)` で旧値に

**関連**: [inc-deadlock](#inc-deadlock), [inc-lock-escalation](#inc-lock-escalation)

**出典**: S_DB2_Codes, S_DB2_Admin

---

### inc-deadlock: デッドロック（SQLCODE -911 reason 00C90088） { #inc-deadlock }

**重要度**: `S` / **用途**: ロック

**目的**: IRLM が検出したデッドロックで victim（SQLCODE -911、auto-rollback）になったアプリの根本対処。

**仮説分岐**:

_トリガ事象_: SQLCODE -911 + reason 00C90088、複数アプリで同時発生

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | アプリの SQL 順序違い（A→B vs B→A） | アプリログで失敗時刻に複数アプリが同じ TS にアクセス、IRLM diag で cycle 確認 | アプリ側でアクセス順序を統一（昇順 etc）、`LOCK TABLE` で先取り |
| **B** | 索引なしテーブル走査による粗ロック | EXPLAIN で対象 SQL の access path = R（table scan）、PK/UK index 不在 | 索引追加、SQL 見直し（WHERE 条件で index 使えるよう） |
| **C** | catalog deadlock（DDL 競合） | DBA 操作と業務 DDL/DML 競合、SYSCOPY 等の catalog 表で発生 | DDL は業務時間外に集約、`-DISPLAY THREAD` で catalog access のスレッド確認 |

_共通の最初の動作_: `F IRLMPROC,DIAG,DEADLOCK` で deadlock dump 取得（victim 選定の経緯記録）。

**手順（共通）**:

1. SQLCODE -911 + reason 00C90088 確認
2. `F IRLMPROC,DIAG,DEADLOCK` で IRLM SYSPRINT に detail 出力
3. SYSPRINT から cycle 構成スレッド・holder 特定
4. EXPLAIN で対象 SQL の access path 検証
5. 解消方針決定（順序統一 / 索引追加 / 分離レベル調整）

**期待出力**:

```
DXR165I IRLMA DEADLOCK
DEADLOCK DUMP REPORT:
   1 RESOURCE = TABLESPACE PRODDB.TS01
   2 INTERESTED PARTIES:
     PARTY 1 = WORK UNIT A   STATUS = WAITING
     PARTY 2 = WORK UNIT B   STATUS = HOLDING / WAITING
   VICTIM SELECTED = WORK UNIT B
```

**検証**: アプリ修正後の再現テストで -911/00C90088 ゼロ

**関連**: [inc-lock-timeout](#inc-lock-timeout), [cfg-bind-package](08-config-procedures.md#cfg-bind-package)

**出典**: S_DB2_Admin, S_DB2_Codes

---

### inc-lock-escalation: ロックエスカレーション → SQLCODE -904 { #inc-lock-escalation }

**重要度**: `S` / **用途**: ロック

**目的**: NUMLKTS / NUMLKUS 超過によるエスカレーションや SQLCODE -904（resource unavailable）の対処。

**仮説分岐**:

_トリガ事象_: SQLCODE -904 / DSNT408I、または `-DISPLAY THREAD` で escalated lock

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | NUMLKTS 超過で TS lock 昇格 | reason code 00C90096、IFCID 196 で escalation 記録 | NUMLKTS 拡大（DSN6SPRM）、または LOCKMAX で TS 単位制御 |
| **B** | NUMLKUS 超過で SQLCODE -904 | reason 00C90088 系、ユーザ全 TS 合計 lock 大量 | NUMLKUS 拡大、長時間 commit なし batch の commit 頻度見直し |
| **C** | CF lock structure 枯渇（データ共用） | DSNB325I 系、LOCK1 structure 容量不足 | CFRM policy で LOCK1 拡大、`SETXCF START,POL` で活性化 |

_共通の最初の動作_: SQLCODE -904 のとき必ず reason code 取得（IFCID 196 / 313 等のトレースで詳細）。

**手順（共通）**:

1. SQLCODE -904 + reason code 確認
2. NUMLKTS / NUMLKUS の現値確認（DSNZPARM の DSN6SPRM）
3. `-DISPLAY THREAD(*) DETAIL` で待ち先 / lock holder 特定
4. 拡大か LOCKSIZE 変更か LOCK TABLE 化を判断
5. DSNZPARM 更新 → 再起動 or LOCKSIZE は ALTER TABLESPACE で動的（一部）

**期待出力**:

```
DSNT408I SQLCODE = -904, ERROR: UNSUCCESSFUL EXECUTION CAUSED BY 
         AN UNAVAILABLE RESOURCE.  REASON 00C90096, TYPE 00000300, 
         AND RESOURCE NAME PRODDB.TS01
```

**検証**: 修正後の再現テストで -904 ゼロ

**関連**: [cfg-dsnzparm-update](08-config-procedures.md#cfg-dsnzparm-update), [inc-lock-timeout](#inc-lock-timeout)

**出典**: S_DB2_Codes

---

### inc-tablespace-corrupt: テーブル空間損傷 → RECOVER { #inc-tablespace-corrupt }

**重要度**: `S` / **用途**: アクセス

**目的**: I/O エラー / catalog inconsistency / power loss 後の不整合で `DSNI031I` 等のエラーが出た TS の復旧。

**仮説分岐**:

_トリガ事象_: SQL 実行で DSNI012I / DSNI031I / DSNT408I が出る、あるいは `-DISPLAY DATABASE RESTRICT` で異常状態

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | 物理 I/O エラー（DASD 故障） | IEA424W / IOS001E などの hardware エラーが SYSLOG にある | DASD 修復後、最新 image copy + log で `RECOVER TOLOGPOINT` |
| **B** | catalog 不整合（前回 DDL 中断後等） | SYSCOPY / SYSTABLESPACE の不整合、`SELECT * FROM SYSCOPY` で破綻 | REPAIR CATALOG、あるいは catalog から手動修復後 RECOVER |
| **C** | アプリ層の論理破壊（`UPDATE` 巨大化等） | I/O エラーなし、データ的に矛盾 | QUIESCE point があれば `RECOVER TOLOGPOINT <pre-incident LRSN>`、なければ FULL RECOVER |

_共通の最初の動作_: 直近の SYSCOPY 履歴を保存（`SELECT * FROM SYSIBM.SYSCOPY WHERE DBNAME=...`）、archive log の存在確認。

**手順（共通）**:

1. `-DISPLAY DATABASE(<db>) SPACENAM(<ts>) RESTRICT` で状態確認
2. SYSCOPY から最新使用可能 image copy 特定
3. `RECOVER TABLESPACE <db>.<ts> TOLOGPOINT <LRSN>` または `TOCOPY <dsn>` 実行
4. CHECK DATA で整合性確認、CHKP 解除
5. 業務再開、必要に応じてアプリ整合性チェック

**期待出力**:

```
DSNU500I  DSNUGUTC - RECOVER TABLESPACE PRODDB.TS01 PROCESSED
DSNU555I  DSNURPTB - START OF RECOVER PHASE
DSNU400I  DSNURPLG - RECOVER PROCESSED, NUMBER OF PAGES = 12345, 
                    APPLIED LOG RECORDS = 567890
DSNU010I  DSNUGBAC - UTILITY EXECUTION COMPLETE, HIGHEST RETURN CODE=0
```

**検証**: SQL で SELECT 可能、CHECK DATA RC=0

**関連**: [cfg-image-copy](08-config-procedures.md#cfg-image-copy), [inc-restp-recovery](#inc-restp-recovery)

**出典**: S_DB2_Util, S_DB2_Codes

---

### inc-bsds-corrupt: BSDS 損傷（DSNJ100I / DSNJ107I） { #inc-bsds-corrupt }

**重要度**: `S` / **用途**: カタログ

**目的**: BSDS（Boot Strap Data Set）損傷時の復旧。Db2 起動不能の致命的状態。

**仮説分岐**:

_トリガ事象_: 起動時に DSNJ100I / DSNJ107I、または BSDS 内容に不整合

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | dual BSDS の片方破損 | DSNJ107I で片方 only error、もう一方は健全 | DSNJU003 (CHANGE LOG INVENTORY) で生きた BSDS から重ね作り直し、または DSNJU004 (PRINT LOG MAP) で内容確認後手動修復 |
| **B** | 両方破損（hardware、誤操作） | 両 BSDS とも DSNJ107I | 直近 BSDS バックアップ（image copy 取得時等に取られているもの）から restore、archive log で BSDS recovery |
| **C** | catalog inconsistency（BSDS と SYSCOPY 不整合） | BSDS は読めるが SYSCOPY との archive 範囲不整合 | DSNJU003 で archive entry を BSDS に再登録、SYSCOPY と照合 |

_共通の最初の動作_: Db2 を起動しないこと（追加損傷防止）。バックアップ BSDS の有無確認。

**手順（共通）**:

1. SYSLOG で DSNJ100I / DSNJ107I 確認
2. DSNJU004 で生きた BSDS の内容 print（できれば両方）
3. dual BSDS で片方生きていれば、stop 中に IDCAMS REPRO で重ね作り直し
4. 両方 NG なら直近 BSDS image copy + archive log から DSNJU003 で再構築
5. Db2 起動、`-DISPLAY LOG`、`-DISPLAY ARCHIVE` で確認

**期待出力**:

```
DSNJU004 PRINT LOG MAP UTILITY 出力例:
ACTIVE LOG COPY 1 DATA SETS
START RBA/TIME      END RBA/TIME       DATE     LTIME    DATA SET INFORMATION
000000123456789ABC  ... 
```

**検証**: Db2 正常起動、`-DISPLAY LOG`/`ARCHIVE` で BSDS 整合

**関連**: [cfg-log-archive](08-config-procedures.md#cfg-log-archive)

**出典**: S_DB2_Admin, S_DB2_Diag

---

### inc-ddf-down: DDF 通信不能 { #inc-ddf-down }

**重要度**: `S` / **用途**: DDF

**目的**: remote から CONNECT 失敗、SQL30081N 等が発生した DDF 障害の切り分け。

**仮説分岐**:

_トリガ事象_: アプリ側で SQL30081N、サーバ側で `-DISPLAY DDF` が STOPDD / ERROR

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | DDF stopped（手動 / 異常停止） | `-DISPLAY DDF` で STATUS=STOPDD | `-START DDF` で起動、停止理由を MSTR ログで調査 |
| **B** | TCP layer 問題（port 競合 / firewall） | `D TCPIP,,N,STATS` で port 446 listen なし、netstat で接続拒否 | port 競合解消、firewall 開放、TCPIP STC 再起動検討 |
| **C** | DRDA レベル不一致（DSNL090I の PROTOCOL） | `-DISPLAY LOCATION` で remote PRDID と current 不整合、SQL30081N reason code 0008（version 不一致） | client / server の DRDA レベル統一、必要なら DDF restart |

_共通の最初の動作_: `-DISPLAY DDF DETAIL` を最初に取得、STATUS と TCPPORT/IPADDR をチェック。

**手順（共通）**:

1. `-DISPLAY DDF DETAIL` で STATUS / TCP port / IPADDR
2. STATUS=STOPDD なら `-START DDF`
3. TCP layer は `D TCPIP,,N,SOCKETS` で listen 状況確認
4. remote 側で `db2 connect to <loc>` 等で疎通テスト
5. 復旧後 `-DISPLAY THREAD(*) TYPE(ACTIVE)` で接続復元確認

**期待出力**:

```
DSNL080I  -DB2A DSNLTDDF DISPLAY DDF REPORT FOLLOWS:
DSNL081I  STATUS=STARTD
...（[01 章 -DISPLAY DDF](01-commands.md#display-ddf) 参照）
```

**検証**: remote から CONNECT 成功、`-DISPLAY THREAD` で接続表示

**関連**: [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup), [inc-ddf-dbat-shortage](#inc-ddf-dbat-shortage)

**出典**: S_DB2_DDF

---

### inc-indoubt-thread: indoubt thread の解決 { #inc-indoubt-thread }

**重要度**: `S` / **用途**: DDF

**目的**: 2-phase commit で coordinator との通信断中に Db2 が再起動した結果、indoubt 状態のスレッドが残った場合の解決。

**仮説分岐**:

_トリガ事象_: `-DISPLAY THREAD(*) TYPE(INDOUBT)` で残存、DSNL435I / DSNL437I 等

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | coordinator との通信復旧で自動解決待ち | DSNL437I「INDOUBT THREAD WILL BE RESOLVED」、自動再同期間隔（RESYNC_INTERVAL）で解決見込 | 数分〜十数分待つ（自動）、必要なら coordinator 側のログも確認 |
| **B** | 手動解決必要（coordinator 不能） | 自動再同期が試行中エラー、または coordinator が永続的に消失 | LUWID で coordinator 側の決定を確認後、`-RECOVER INDOUBT(<luwid>) ACTION(COMMIT|ABORT)` |
| **C** | 内部エラーで thread 状態異常 | DSNL439I 等の error メッセージ、自動再同期が成功も失敗もしない | IBM サポート、必要なら `-RESET INDOUBT` で thread 履歴を catalog から削除 |

_共通の最初の動作_: indoubt 残置中はリソース（lock）が解放されない。被害が広がる前に対処。

**手順（共通）**:

1. `-DISPLAY THREAD(*) TYPE(INDOUBT)` で LUWID 取得
2. LUWID から coordinator（CICS / IMS / 他 Db2）側のログ確認、最終決定（COMMIT or ABORT）特定
3. `-RECOVER INDOUBT(<luwid>) ACTION(COMMIT)` または `ACTION(ABORT)`
4. 完了後 `-DISPLAY THREAD(*) TYPE(INDOUBT)` で消滅確認
5. 再発防止: RESYNC_INTERVAL 短縮、coordinator 安定性改善

**期待出力**:

```
-DISPLAY THREAD(*) TYPE(INDOUBT)
DSNV437I -DB2A INDOUBT THREADS -
COORDINATOR     STATUS  RESET URE INFO  
DB2A.LUWID01    RESYNC          1234   
DSNV435I  -DB2A NO MORE INDOUBT THREADS

-RECOVER INDOUBT(LUWID01) ACTION(COMMIT)
DSNV414I  -DB2A LUWID01 IS RESOLVED COMMITTED
```

**検証**: indoubt thread が消える、対応 lock が解放される

**関連**: [inc-ddf-down](#inc-ddf-down)

**出典**: S_DB2_Admin, S_DB2_Msgs

---

### inc-log-archive-fail: アクティブログ満杯・archive 失敗 { #inc-log-archive-fail }

**重要度**: `S` / **用途**: ログ

**目的**: DSNJ110E / DSNJ111E 等の archive 関連エラーで commit が遅延・停止する状態の対処。

**仮説分岐**:

_トリガ事象_: DSNJ110E（archive log allocation error）/ DSNJ111E（archive log offload failed）/ DSNJ139I（offload task ended）

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | archive 媒体の空き不足（DASD/TAPE） | DSNJ103I（allocation error）が直前にある、DASD 空き残量小、TAPE drive 不足 | 空き DASD 拡張、TAPE drive 増設、`-ARCHIVE LOG` で待機中 offload 強制 |
| **B** | DSN6ARVP の UNIT/PFX 不正 | DSNJ103I で specified UNIT が見つからない、ARCPFX1/2 が catalog 外 | DSNZPARM 修正、再起動、または `-SET ARCHIVE` で動的調整（一部） |
| **C** | active log データセット容量自体不足 | アクティブログ % FULL が 99% でも DSNJ100I 系出ない（offload completed なのに log が拡張されない） | active log dataset 追加（DSNJU003 NEWLOG）、Db2 cycling |

_共通の最初の動作_: `-DISPLAY LOG`、`-DISPLAY ARCHIVE`、archive 媒体空き状況を最初に取得。

**手順（共通）**:

1. `-DISPLAY LOG` で active log % FULL、`-DISPLAY ARCHIVE` で offload 状態
2. SYSLOG で DSNJ系メッセージ系列を時系列で確認
3. archive 媒体の空き / TAPE drive 確保
4. `-ARCHIVE LOG` コマンドで強制 offload（業務影響あり）
5. 復旧後 archive 周期と容量計画見直し

**期待出力**:

```
-DISPLAY LOG
DSNJ370I -DB2A DSNJC00A LOG DISPLAY
CURRENT COPY1 LOG = DB2A.LOGCOPY1.DS01 IS 95% FULL
FULL LOGS TO OFFLOAD = 5 OF 6
OFFLOAD TASK IS (BUSY)

-ARCHIVE LOG
DSNJ139I  -DB2A LOG OFFLOAD TASK ENDED
DSNJ370I  -DB2A DSNJC00A LOG DISPLAY
CURRENT COPY1 LOG = DB2A.LOGCOPY1.DS01 IS 5% FULL
```

**検証**: archive entry が SYSCOPY 様な BSDS に追加、active log % が下がる

**関連**: [cfg-log-archive](08-config-procedures.md#cfg-log-archive), [inc-bsds-corrupt](#inc-bsds-corrupt)

**出典**: S_DB2_Admin, S_DB2_Msgs

---

### inc-package-notfound: SQLCODE -805 / -204 { #inc-package-notfound }

**重要度**: `S` / **用途**: バインド

**目的**: アプリ実行で `SQLCODE -805 (DBRM/package not found in plan)` または `-204 (object not found)` の対処。

**仮説分岐**:

_トリガ事象_: `-805` reason code（01 = no package found、02 = package list not in plan、03 = consistency token mismatch、04 = location not in PKLIST）

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | PACKAGE 不在 / 古い version | reason 01、SYSPACKAGE で対象 collection / name に該当行なし | BIND PACKAGE で再 BIND、必要なら DBRM lib 確認 |
| **B** | PLAN の PKLIST に該当 collection 漏れ | reason 02、SYSPLAN.PKLIST に該当 collection なし | BIND PLAN PKLIST(<coll>.*) を追加して再 BIND |
| **C** | consistency token 不一致（再 compile 漏れ） | reason 03、SYSPACKAGE.CONTOKEN と DBRM 内 consistency token 不一致 | プログラム再 precompile + 再 BIND PACKAGE で同期 |

_共通の最初の動作_: reason code を必ず確認、SYSPACKAGE / SYSPLAN を SQL で確認。

**手順（共通）**:

1. `SQLCODE -805` 出力ログから collection.name と reason code 取得
2. `SELECT * FROM SYSIBM.SYSPACKAGE WHERE COLLID='..' AND NAME='..'` で存在確認
3. `SELECT * FROM SYSIBM.SYSPLAN WHERE NAME='<plan>'` と SYSPACKLIST で PKLIST 確認
4. 不足分を BIND PACKAGE / BIND PLAN で補正
5. アプリ再実行

**期待出力**:

```
DSNT408I SQLCODE = -805, ERROR: DBRM OR PACKAGE NAME LOC1.COLL.PKG.18A2B30C0E000001
NOT FOUND IN PLAN APPPLAN. REASON 03
```

**検証**: 再実行で SQLCODE 0、SYSPACKAGE.LASTUSED 更新

**関連**: [cfg-bind-package](08-config-procedures.md#cfg-bind-package)

**出典**: S_DB2_Codes

---

### inc-utility-stuck: ユーティリティが進まない { #inc-utility-stuck }

**重要度**: `S` / **用途**: ユーティリティ

**目的**: `-DISPLAY UTILITY` で長時間 PHASE が同じ・COUNT が増えないユーティリティの切り分け。

**仮説分岐**:

_トリガ事象_: `-DISPLAY UTILITY` で PHASE が長時間動かない、COUNT 停滞

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | drain 待ち（SHRLEVEL CHANGE のみ） | PHASE=LOG / SWITCH、`-DISPLAY THREAD` で対象 TS にアクセス中の業務スレッド存在 | 業務スレッドの commit 促進、または `-CANCEL THREAD(...)` で強制（影響大）、MAXRO/RETRY 拡大 |
| **B** | 資源不足（log / DASD / sort work） | COUNT 0 で進まない、SYSLOG にアロケーション error | SORT WORK 容量拡張、log offload 確保、または -TERM UTILITY で停止後 RESTART |
| **C** | IRLM デッドロックや内部問題 | SYSLOG に DXR系 / DSNT系 error、`-DISPLAY THREAD` で utility thread 自体が WAITING | IRLM diag、必要なら `-TERM UTILITY` 後 IBM サポート |

_共通の最初の動作_: `-DISPLAY UTILITY` を 1 分間隔で複数回取得して COUNT 推移確認、SYSLOG / SDSF MSG を関連時刻で精査。

**手順（共通）**:

1. `-DISPLAY UTILITY(<utilid>)` で PHASE / COUNT 確認
2. PHASE=DRAIN/LOG/SWITCH なら `-DISPLAY THREAD(*) TYPE(ACTIVE)` で待ち先確認
3. 短時間で進む見込みなら待機、長期なら `-TERM UTILITY` で中止 → 後で RESTART
4. RESTART は UTPROC=RESTART(PHASE)/RESTART(CURRENT) で適切に
5. SYSCOPY / SYSUTILX で履歴整合確認

**期待出力**:

```
-DISPLAY UTILITY(REORGTS01)
DSNU100I  -DB2A DSNUGDIS - USERID = USER1
        UTILID = REORGTS01
PROCESSING UTILITY STATEMENT 1
COMMAND = REORG TABLESPACE  PHASE = LOG  COUNT = 1234567
NUMBER OF OBJECTS IN LIST = 1
LAST OBJECT STARTED       = 1
STATUS = ACTIVE
```

**検証**: PHASE 進展、最終的 RC=0

**関連**: [cfg-reorg-online](08-config-procedures.md#cfg-reorg-online)

**出典**: S_DB2_Util

---

### inc-restp-recovery: RESTP / CHKP / COPY pending 解除 { #inc-restp-recovery }

**重要度**: `A` / **用途**: アクセス

**目的**: ユーティリティ中断・LOAD 後・RECOVER 後の `RESTP`（REORG pending）/ `CHKP`（CHECK pending）/ `COPY`（COPY pending）状態の解除。

**手順**:

1. `-DISPLAY DATABASE(<db>) RESTRICT` で対象 TS と pending 状態確認
2. RESTP → REORG TABLESPACE
3. CHKP → CHECK DATA、または RECOVER で解除
4. COPY → COPY TABLESPACE FULL
5. RECP → RECOVER または REBUILD INDEX
6. 再 `-DISPLAY DATABASE RESTRICT` で消滅確認

**注意点**: `START DATABASE ACCESS(FORCE)` は最終手段。データ不整合のリスクがあるため、原因解消後の使用に限定。

**関連手順**: [inc-tablespace-corrupt](#inc-tablespace-corrupt), [cfg-image-copy](08-config-procedures.md#cfg-image-copy)

**出典**: S_DB2_Admin

---

### inc-catalog-inconsistency: カタログ不整合 { #inc-catalog-inconsistency }

**重要度**: `A` / **用途**: カタログ

**目的**: catalog の論理整合性が壊れた状態（CATMAINT 中断後、誤操作後等）の対処。

**手順**:

1. `REPAIR CATALOG TEST` で問題箇所スキャン
2. `REPAIR CATALOG` で自動修復（軽微な不整合）
3. 重度の場合は SYSCOPY からの catalog RECOVER（catalog 全体は IBM サポート要）
4. 修復後 `RUNSTATS TABLESPACE DSNDB06.* TABLE(ALL)` で統計再取得

**注意点**: catalog 修復はリスクが大きい。事前に SYSCOPY / DSN1COPY で catalog backup 必須。

**関連手順**: [inc-bsds-corrupt](#inc-bsds-corrupt), [cfg-catalog-maintenance](08-config-procedures.md#cfg-catalog-maintenance)

**出典**: S_DB2_Util

---

### inc-ddf-dbat-shortage: DBAT 枯渇 { #inc-ddf-dbat-shortage }

**重要度**: `A` / **用途**: DDF

**目的**: `-DISPLAY DDF DETAIL` で QUEDBAT が貯まり remote 接続が応答低下する状態への対処。

**手順**:

1. `-DISPLAY DDF DETAIL` で MDBAT、ADBAT、QUEDBAT、INADBAT 確認
2. CMTSTAT を INACTIVE 化（既に INACTIVE なら IDTHTOIN 短縮で disconnect 促進）
3. MAXDBAT 拡大検討（DSN6SYSP）
4. アプリ側の長時間 connection 保持の見直し
5. コネクションプール（client 側）の sizing チェック

**注意点**: MAXDBAT 拡大は仮想記憶を消費。CTHREAD/CONDBAT との合計から DBM1 region 計算（[Db2 Installation Guide p.46] の計算式参照）。

**関連手順**: [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup)

**出典**: S_DB2_DDF, S_DB2_Install

---

### inc-bp-shortage: バッファプール容量不足 { #inc-bp-shortage }

**重要度**: `A` / **用途**: パフォーマンス

**目的**: hit ratio 低下、Sync I/O 急増などの BP shortage への対処。

**手順**:

1. `-DISPLAY BUFFERPOOL(*) DETAIL(*)` で BP 別 hit ratio 算出
2. 過大消費の BP 特定（VPSIZE / 使用ページ比率）
3. `-ALTER BUFFERPOOL VPSIZE(...)` で増量（DBM1 region に余裕あれば）
4. 余裕ない場合は別 BP に oversize オブジェクトを退避（ALTER TABLESPACE BUFFERPOOL ...）
5. 長期的に BP 設計見直し（OLTP / バッチ / 索引で BP 分離）

**関連手順**: [cfg-bufferpool-tune](08-config-procedures.md#cfg-bufferpool-tune)

**出典**: S_DB2_Perf

---

### inc-storage-shortage: 仮想記憶不足 { #inc-storage-shortage }

**重要度**: `A` / **用途**: リソース

**目的**: DB2MSTR / DBM1 / DDF の region size 不足、SQLCODE -904 reason 00C90080 等の対処。

**手順**:

1. SDSF DA で各 STC の REGION 使用率確認
2. JCL の REGION= 拡大（4G / 6G / 8G 程度）、IEFUSI exit でも調整
3. EDM Pool / Buffer Pool / DSC のサイズ見直し（DSN6SYSP）
4. 必要に応じ STC 再起動

**関連手順**: [cfg-bufferpool-tune](08-config-procedures.md#cfg-bufferpool-tune)

**出典**: S_DB2_Perf

---

### inc-rebind-needed: REBIND が必要な状態 { #inc-rebind-needed }

**重要度**: `B` / **用途**: バインド

**目的**: SYSPACKAGE.LASTUSED が古すぎ、または structural change 後に REBIND を促す（Db2 12+ で 1 年 / 1.5 年経過 PACKAGE は invalidated 扱い）。

**手順**:

1. `SELECT COLLID,NAME,LASTUSED FROM SYSIBM.SYSPACKAGE WHERE LASTUSED<CURRENT_DATE-365 DAYS`
2. 対象 PACKAGE を REBIND（APREUSE(WARN) で access path 検証）
3. アプリテスト実行

**関連手順**: [cfg-bind-package](08-config-procedures.md#cfg-bind-package)

**出典**: S_DB2_AppPgm

---

### inc-utility-abend: ユーティリティ ABEND { #inc-utility-abend }

**重要度**: `B` / **用途**: ユーティリティ

**目的**: ユーティリティが SYSPRINT で error / abend で終了したケースの再開（RESTART）または完全再実行。

**手順**:

1. SYSPRINT の DSNUxxxxI / DSNUxxxxE メッセージを時系列で確認
2. SYSUTILX を `SELECT * FROM SYSIBM.SYSUTILX` で確認、UTILID と PHASE 確認
3. 軽微なエラー（容量不足等）は資源確保後 UTPROC=RESTART(CURRENT/PHASE) で再開
4. 重大エラーは `-TERM UTILITY` 後完全再実行

**関連手順**: [inc-utility-stuck](#inc-utility-stuck)

**出典**: S_DB2_Util

---

### inc-irlm-stop: IRLM 異常停止 { #inc-irlm-stop }

**重要度**: `C` / **用途**: リソース

**目的**: IRLM が DXR系 メッセージで停止し、Db2 が連動して `-STOP DB2 MODE(FORCE)` 状態になった場合の復旧。

**手順**:

1. SYSLOG で DXR メッセージを確認、停止理由特定
2. IRLM 再起動: `S IRLMPROC` （PROC は dataset で確認）
3. Db2 起動: `-START DB2`
4. `F IRLMPROC,STATUS` で connected DB2 確認

**関連手順**: [cfg-db2-startup](08-config-procedures.md#cfg-db2-startup)

**出典**: S_DB2_Admin

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
