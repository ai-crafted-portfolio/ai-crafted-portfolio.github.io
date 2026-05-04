# コマンド一覧

> 掲載：**47 件（DB2 オペレータ / DSN サブコマンド / ユーティリティ / SQL 運用クエリ / IRLM）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

Db2 13 for z/OS の DBA / オペレータ / アプリ開発者が日常的に使う定番コマンドを厳選。MVS コンソールで `-` プレフィックス（コマンドプレフィックス）が付くもの、`DSN` プロセッサで実行するもの、ユーティリティ JCL で実行するもの、SQL で発行するもの、の 5 系統に分類。

## 目次

- **DB2 オペレータコマンド（コマンドプレフィックス系）**（18 件）: [`-DISPLAY THREAD`](#display-thread), [`-DISPLAY DATABASE`](#display-database), [`-DISPLAY BUFFERPOOL`](#display-bufferpool), [`-DISPLAY GROUP`](#display-group), [`-DISPLAY UTILITY`](#display-utility), [`-DISPLAY DDF`](#display-ddf), [`-DISPLAY LOG`](#display-log), [`-DISPLAY ARCHIVE`](#display-archive), [`-DISPLAY LOCATION`](#display-location), [`-START DB2`](#start-db2), [`-STOP DB2`](#stop-db2), [`-START DDF`](#start-ddf), [`-STOP DDF`](#stop-ddf), [`-START DATABASE`](#start-database), [`-STOP DATABASE`](#stop-database), [`-ALTER BUFFERPOOL`](#alter-bufferpool), [`-RECOVER INDOUBT`](#recover-indoubt), [`-TERM UTILITY`](#term-utility)
- **DSN サブコマンド**（6 件）: [`DSN`](#dsn), [`BIND PLAN`](#bind-plan), [`BIND PACKAGE`](#bind-package), [`REBIND PACKAGE`](#rebind-package), [`FREE PLAN / PACKAGE`](#free-plan---package), [`RUN PROGRAM`](#run-program)
- **ユーティリティ（DSNUTILB）**（10 件）: [`COPY`](#copy), [`LOAD`](#load), [`UNLOAD`](#unload), [`REORG TABLESPACE`](#reorg-tablespace), [`REORG INDEX`](#reorg-index), [`RUNSTATS`](#runstats), [`CHECK DATA`](#check-data), [`RECOVER`](#recover), [`QUIESCE`](#quiesce), [`REPAIR`](#repair)
- **SQL 運用クエリ**（8 件）: [`SELECT FROM SYSIBM.SYSTABLES`](#select-systables), [`SELECT FROM SYSIBM.SYSCOPY`](#select-syscopy), [`SELECT FROM SYSIBM.SYSPACKAGE`](#select-syspackage), [`EXPLAIN`](#explain), [`SET CURRENT SQLID`](#set-current-sqlid), [`SET CURRENT APPLICATION COMPATIBILITY`](#set-applcompat), [`COMMIT / ROLLBACK`](#commit--rollback), [`LOCK TABLE`](#lock-table)
- **IRLM**（3 件）: [`MODIFY irlmproc,STATUS`](#modify-irlm-status), [`MODIFY irlmproc,DIAG`](#modify-irlm-diag), [`MODIFY irlmproc,SET`](#modify-irlm-set)
- **DSNTEP2 / DSNTIAUL（バッチ実行系）**（2 件）: [`DSNTEP2`](#dsntep2), [`DSNTIAUL`](#dsntiaul)

---

## DB2 オペレータコマンド（コマンドプレフィックス系）

`-` で始まる例は z/OS コンソールで `-DSN1 DISPLAY ...` のように **コマンドプレフィックス**（既定では `-DSN1` だがサイトで変更可）を頭に付けて発行する。本ページでは慣例どおり `-DISPLAY ...` と先頭プレフィックスを省略表記。

### `-DISPLAY THREAD` { #display-thread }

**用途**: アクティブなスレッド（接続中の TSO/Batch/DDF/CICS/IMS など）を表示。

**構文**:

```
-DISPLAY THREAD(*) [TYPE(ACTIVE|INDOUBT|INACTIVE|POSTPONED)] [LOCATION(...)] [DETAIL]
```

**典型例**:

```
-DISPLAY THREAD(*) DETAIL
（出力）DSNV401I - DISPLAY THREAD REPORT FOLLOWS -
DSNV402I - ACTIVE THREADS -
NAME     ST A   REQ ID         AUTHID   PLAN     ASID TOKEN
TSO      T  *    21 USER1      USER1    DSNTIB71 0050    35
DB2CALL  T  *    14 BATCH001   USER2    DSNUTIL  0078    42
DSNV434I - NO POSTPONED ABORT THREADS FOUND
DSNV437I - NO INDOUBT THREADS FOUND
```

**注意点**: `TYPE(INDOUBT)` は 2-phase commit 中断スレッドを表示。これらは `-RECOVER INDOUBT` で解決必要。`LOCATION(...)` は DDF 経由で接続している remote location を絞り込む。

**関連手順**: [inc-indoubt-thread](09-incident-procedures.md#inc-indoubt-thread), [inc-lock-timeout](09-incident-procedures.md#inc-lock-timeout)

**関連用語**: [Thread](03-glossary.md#thread), [DDF](03-glossary.md#ddf), [Plan](03-glossary.md#plan)

**出典**: S_DB2_Cmds

---

### `-DISPLAY DATABASE` { #display-database }

**用途**: データベース・テーブル空間・索引空間の状態（RW / UT / RO / STOP / RESTP / CHKP / COPY / RECP / GBPDEP 等）を表示。

**構文**:

```
-DISPLAY DATABASE(<dbname>) [SPACENAM(<tsname>)] [USE | LOCKS | CLAIMERS | LIMIT | RESTRICT]
```

**典型例**:

```
-DISPLAY DATABASE(PRODDB) SPACENAM(TS01) RESTRICT
（出力）DSNT360I - **********************************
DSNT361I - * DISPLAY DATABASE SUMMARY
        *  RESTRICT
DSNT360I - **********************************
DSNT362I - DATABASE = PRODDB STATUS = RW
DBD LENGTH = 4028
DSNT397I - 
NAME    TYPE PART STATUS              PHYERRLO PHYERRHI CATALOG  PIECE
-------- ---- ---- ------------------ -------- -------- -------- -----
TS01     TS    1   COPY                                                    
TS01     TS    2   RW                                                       
```

**注意点**: STATUS の値は最重要：`COPY` = COPY ペンディング（イメージコピー必要）、`RECP` = RECOVER ペンディング、`CHKP` = CHECK ペンディング、`RESTP` = REORG ペンディング、`STOP` = 停止中。`RESTRICT` 指定で異常状態のオブジェクトのみフィルタ表示できるため、運用早見に頻用。

**関連手順**: [cfg-tablespace-create](08-config-procedures.md#cfg-tablespace-create), [inc-restp-recovery](09-incident-procedures.md#inc-restp-recovery)

**関連用語**: [Tablespace](03-glossary.md#tablespace), [DBD](03-glossary.md#dbd), [Restrictive State](03-glossary.md#restrictive-state)

**出典**: S_DB2_Cmds

---

### `-DISPLAY BUFFERPOOL` { #display-bufferpool }

**用途**: バッファプールの構成（VPSIZE/VPSEQT 等）と使用統計（getpages, sync read, async read, prefetch, write 等）を表示。

**構文**:

```
-DISPLAY BUFFERPOOL(<bpname>|*) [LIST|DBLIST] [DETAIL[(*|INTERVAL)]]
```

**典型例**:

```
-DISPLAY BUFFERPOOL(BP0) DETAIL(*)
（出力）DSNB401I - BUFFERPOOL NAME BP0, BUFFERPOOL ID 0, USE COUNT 12
DSNB402I - VIRTUAL BUFFERPOOL SIZE = 20000 BUFFERS
  ALLOCATED        = 20000   TO BE DELETED  = 0
  IN-USE/UPDATED   =   123
DSNB406I - VIRTUAL BUFFERPOOL SEQUENTIAL THRESHOLD = 80
  HORIZONTAL DEFERRED WRITE THRESHOLD = 30
  VERTICAL DEFERRED WRITE THRESHOLD   = 5,0
DSNB420I - SYNC READ I/O (SINGLE) - 1234567
  SYNC READ I/O (SEQUENTIAL) - 8901
DSNB421I - GETPAGE REQUEST = 9876543
  SYNCHRONOUS WRITES = 12345
```

**注意点**: `DETAIL(INTERVAL)` で interval 統計をリセットせず累積で表示。`DETAIL(*)` は前回 DISPLAY 以降のデルタ。`DSNB411I` の `RANDOM GETPAGE` と `SYNC READ I/O` の比率（hit ratio）が性能指標：90% 超を目安。

**関連手順**: [cfg-bufferpool-tune](08-config-procedures.md#cfg-bufferpool-tune)

**関連用語**: [Buffer Pool](03-glossary.md#buffer-pool), [Getpage](03-glossary.md#getpage), [VPSIZE](03-glossary.md#vpsize)

**出典**: S_DB2_Cmds

---

### `-DISPLAY GROUP` { #display-group }

**用途**: データ共用（Data Sharing）グループの構成と各メンバの状態、Function Level、Application Compatibility を表示。

**構文**:

```
-DISPLAY GROUP [DETAIL]
```

**典型例**:

```
-DISPLAY GROUP DETAIL
（出力）DSN7100I - DSN7GCMD
*** BEGIN DISPLAY OF GROUP(DSNGRP01)  CATALOG LEVEL(V13R1M501)
                  CURRENT FUNCTION LEVEL(V13R1M501)
                  HIGHEST ACTIVATED FUNCTION LEVEL(V13R1M501)
                  HIGHEST POSSIBLE FUNCTION LEVEL(V13R1M502)
DB2     SYSTEM       MEMBER       STATUS    DB2  PROTOCOL
MEMBER  NAME         ID           LVL  LVL
DB2A    SY01         1            ACTIVE     V13R1   PRIVATE
DB2B    SY02         2            ACTIVE     V13R1   PRIVATE
*** END DISPLAY OF GROUP
```

**注意点**: データ共用環境では必ず確認。`HIGHEST POSSIBLE FUNCTION LEVEL` が `CURRENT` を上回る場合、`-ACTIVATE FUNCTION LEVEL(...)` で機能拡張可能。Catalog Level と Function Level の関係は `S_DB2_FuncLevels` 参照。

**関連手順**: [cfg-functionlevel-activate](08-config-procedures.md#cfg-functionlevel-activate)

**関連用語**: [Data Sharing Group](03-glossary.md#data-sharing-group), [Function Level](03-glossary.md#function-level), [Catalog Level](03-glossary.md#catalog-level)

**出典**: S_DB2_DataSharing

---

### `-DISPLAY UTILITY` { #display-utility }

**用途**: 実行中ユーティリティの phase / 進捗 / count を表示。

**構文**:

```
-DISPLAY UTILITY(<utilid>|*)
```

**典型例**:

```
-DISPLAY UTILITY(*)
（出力）DSNU100I - DSNUGDIS - USERID = USER1
        MEMBER = DB2A
        UTILID = REORGTS01
        PROCESSING UTILITY STATEMENT 1
COMMAND = REORG
PHASE = RELOAD     COUNT = 1234567
NUMBER OF OBJECTS IN LIST = 1
LAST OBJECT STARTED       = 1
STATUS = ACTIVE
```

**注意点**: phase は `UTILINIT → UNLOAD → RELOAD → SORT → BUILD → SWITCH → SORTBLD → LOG → UTILTERM` 等。`COUNT` は phase 内処理件数。phase 移行が長時間進まない場合は資源待ち（lock / log / disk）を疑う。

**関連手順**: [inc-utility-stuck](09-incident-procedures.md#inc-utility-stuck)

**関連用語**: [Utility](03-glossary.md#utility), [Utility Phase](03-glossary.md#utility-phase), [SHRLEVEL](03-glossary.md#shrlevel)

**出典**: S_DB2_Util

---

### `-DISPLAY DDF` { #display-ddf }

**用途**: DDF（分散データ機能）の状態、IP/PORT、active/inactive thread、location 等を表示。

**構文**:

```
-DISPLAY DDF [DETAIL]
```

**典型例**:

```
-DISPLAY DDF DETAIL
（出力）DSNL080I - DSNLTDDF DISPLAY DDF REPORT FOLLOWS:
DSNL081I  STATUS=STARTD
DSNL082I  LOCATION   LUNAME            GENERICLU
DSNL083I  LOC1       NETLU.DB2A        NETLU.DB2GEN
DSNL084I  TCPPORT=446 SECPORT=448 RESPORT=5001 IPNAME=-NONE
DSNL085I  IPADDR=::ffff:10.1.1.10
DSNL086I  SQL    DOMAIN=db2a.example.com
DSNL087I  ALIAS  PORT  SECPORT IPNAME       STATUS
DSNL089I MEMBER IPADDR=::ffff:10.1.1.10
DSNL090I DT=I  CONDBAT=10000 MDBAT=2000
DSNL092I  ADBAT=15  QUEDBAT=0  INADBAT=2  CONQUED=0
DSNL093I  DSCDBAT=3  INACONN=0
DSNL099I DSNLTDDF DISPLAY DDF REPORT COMPLETE
```

**注意点**: `STATUS=STARTD` (active)、`STARTI` (inactive ready)、`STOPDT` (stopping)。`ADBAT` (active DBAT)、`QUEDBAT`（待ち DBAT）が貯まると同時接続枯渇のサイン。`MDBAT`（最大 DBAT）の調整は DSN6FAC マクロ。

**関連手順**: [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup), [inc-ddf-down](09-incident-procedures.md#inc-ddf-down)

**関連用語**: [DDF](03-glossary.md#ddf), [DBAT](03-glossary.md#dbat), [DRDA](03-glossary.md#drda)

**出典**: S_DB2_DDF

---

### `-DISPLAY LOG` { #display-log }

**用途**: アクティブログ・アーカイブ状態、checkpoint 情報、現在書き込み位置（RBA / LRSN）を表示。

**構文**:

```
-DISPLAY LOG
```

**典型例**:

```
-DISPLAY LOG
（出力）DSNJ370I - DSNJC00A LOG DISPLAY
CURRENT COPY1 LOG = DB2A.LOGCOPY1.DS01 IS 23% FULL
CURRENT COPY2 LOG = DB2A.LOGCOPY2.DS01 IS 23% FULL
H/W RBA = 000000123456789ABC
H/O RBA = 0000001234567880CD
FULL LOGS TO OFFLOAD = 0 OF 6
OFFLOAD TASK IS (AVAILABLE)
DSNJ371I - DB2 RESTARTED 2026-04-12 12:34:56
DSNJ376I - LOG RECORD = 14:25:30 LSN=000000ABCDEF
```

**注意点**: アクティブログが 90% を超えると新規 commit が遅延しはじめる。FULL LOGS TO OFFLOAD が貯まると `DSNJ110E` などの WTOR が出る。アーカイブ宛先（DSN6ARVP）と空き容量を必ず合わせて確認。

**関連手順**: [cfg-log-archive](08-config-procedures.md#cfg-log-archive), [inc-log-archive-fail](09-incident-procedures.md#inc-log-archive-fail)

**関連用語**: [Active Log](03-glossary.md#active-log), [Archive Log](03-glossary.md#archive-log), [BSDS](03-glossary.md#bsds), [RBA](03-glossary.md#rba), [LRSN](03-glossary.md#lrsn)

**出典**: S_DB2_Cmds

---

### `-DISPLAY ARCHIVE` { #display-archive }

**用途**: アーカイブログのオフロード状況、archive log データセット名、媒体（DASD / TAPE）を表示。

**構文**:

```
-DISPLAY ARCHIVE
```

**典型例**:

```
-DISPLAY ARCHIVE
（出力）DSNJ322I - DISPLAY ARCHIVE REPORT FOLLOWS-
COUNT TIME              STARTRBA            ENDRBA      UNIT
   1  2026-04-12.09.30  000000123456000     0000001234567FFF DASD
   2  2026-04-12.10.30  000000123457800     000000123459FFF  DASD
   3  2026-04-12.11.30  00000012345A000     00000012345BFFF  DASD
DSNJ323I - DSNJC00A DISPLAY ARCHIVE REPORT COMPLETE
```

**注意点**: アーカイブ媒体（DASD/TAPE）と保管期限は DSN6ARVP の `UNIT` / `ARCRETN` で制御。RECOVER 用にアーカイブが必要な期間（最古点まで）が生きていることを定期確認。

**関連手順**: [cfg-log-archive](08-config-procedures.md#cfg-log-archive)

**関連用語**: [Archive Log](03-glossary.md#archive-log), [BSDS](03-glossary.md#bsds)

**出典**: S_DB2_Cmds

---

### `-DISPLAY LOCATION` { #display-location }

**用途**: DDF 経由で接続中・接続実績のある remote location 一覧を表示。

**構文**:

```
-DISPLAY LOCATION(*|<locname>) [DETAIL]
```

**典型例**:

```
-DISPLAY LOCATION(*)
（出力）DSNL200I - DISPLAY LOCATION REPORT FOLLOWS-
LOCATION    PRDID    T     ATT        CONNS
LOC2        DSN13015 V     1          12
LOC3        DSN12015 V     2          5
DSNL202I - LOC2 IPADDR=10.10.20.30
DSNL203I - LOC2 PRDID=DSN13015 LEVEL=V13R1
DSNL299I - DSNLTDDF DISPLAY LOCATION REPORT COMPLETE
```

**注意点**: 互換確認に有用。`PRDID` で相手 Db2 のレベルを把握できる。`CONNS` が大きいまま動かない remote location はネットワーク切断疑い。

**関連手順**: [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup)

**関連用語**: [DDF](03-glossary.md#ddf), [Location](03-glossary.md#location)

**出典**: S_DB2_DDF

---

### `-START DB2` { #start-db2 }

**用途**: Db2 サブシステム（DB2MSTR/DBM1/DDF/IRLM/DB2SPAS）を起動。

**構文**:

```
-START DB2 [PARM(<DSNZPARM 名>)] [ACCESS(MAINT|*)]
```

**典型例**:

```
-START DB2
（出力）DSNZ002I - SUBSYS DB2A SYSTEM PARAMETERS LOAD MODULE NAME DSNZPRM1
DSN9022I - DSNYASCP 'START DB2' NORMAL COMPLETION
```

**注意点**: `ACCESS(MAINT)` でメンテモード起動（installation SYSADM のみ接続可）。`PARM(...)` で異なる DSNZPARM ロードモジュールを使い分け（テスト切替に便利）。IRLM が事前に動いていない場合は自動起動される（IRLMRWT/IRLMSWT 設定に従う）。

**関連手順**: [cfg-db2-startup](08-config-procedures.md#cfg-db2-startup)

**関連用語**: [DSNZPARM](03-glossary.md#dsnzparm), [IRLM](03-glossary.md#irlm)

**出典**: S_DB2_Cmds

---

### `-STOP DB2` { #stop-db2 }

**用途**: Db2 サブシステムを停止。`MODE(QUIESCE)` で in-flight thread の commit/abort を待つ、`MODE(FORCE)` で強制停止。

**構文**:

```
-STOP DB2 [MODE(QUIESCE|FORCE)]
```

**典型例**:

```
-STOP DB2 MODE(QUIESCE)
（出力）DSN9022I - DSNYASCP 'STOP DB2' NORMAL COMPLETION
```

**注意点**: `MODE(QUIESCE)` が default。長時間 hold スレッドがあると停止が進まない場合あり。緊急時は `MODE(FORCE)`、ただし indoubt thread を発生させる可能性あり（再起動時に `-RECOVER INDOUBT` で対応）。

**関連手順**: [cfg-db2-startup](08-config-procedures.md#cfg-db2-startup), [inc-indoubt-thread](09-incident-procedures.md#inc-indoubt-thread)

**関連用語**: [Indoubt Thread](03-glossary.md#indoubt-thread)

**出典**: S_DB2_Cmds

---

### `-START DDF` { #start-ddf }

**用途**: DDF（DB2DIST アドレス空間）を起動。

**構文**:

```
-START DDF
```

**注意点**: DDF が STATUS=STOPDD のときに発行。`-DISPLAY DDF` で STARTD 確認。

**関連手順**: [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup)

**関連用語**: [DDF](03-glossary.md#ddf)

**出典**: S_DB2_DDF

---

### `-STOP DDF` { #stop-ddf }

**用途**: DDF を停止。`MODE(SUSPEND)` で新規接続を拒否しつつ既存スレッドは継続、`MODE(FORCE)` で強制停止。

**構文**:

```
-STOP DDF [MODE(QUIESCE|FORCE|SUSPEND)] [WAIT(YES|NO)]
```

**注意点**: メンテナンス時は `MODE(SUSPEND)` で remote 接続をドレインしてから停止すると安全。

**関連手順**: [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup)

**関連用語**: [DDF](03-glossary.md#ddf)

**出典**: S_DB2_DDF

---

### `-START DATABASE` { #start-database }

**用途**: データベース・テーブル空間を `RW`（読み書き）または `RO`（読取専用）で開始。

**構文**:

```
-START DATABASE(<dbname>) [SPACENAM(<tsname>) [PART(<n>)]] [ACCESS(RW|RO|FORCE|UT)]
```

**典型例**:

```
-START DATABASE(PRODDB) SPACENAM(TS01) ACCESS(RW)
（出力）DSN9022I - DSNTDDIS 'START DATABASE' NORMAL COMPLETION
```

**注意点**: `ACCESS(UT)` はユーティリティ専用モード。`ACCESS(FORCE)` は STOP 状態を強制解除（オブジェクトに矛盾の可能性あり、注意）。

**関連手順**: [inc-restp-recovery](09-incident-procedures.md#inc-restp-recovery)

**関連用語**: [Tablespace](03-glossary.md#tablespace), [Restrictive State](03-glossary.md#restrictive-state)

**出典**: S_DB2_Cmds

---

### `-STOP DATABASE` { #stop-database }

**用途**: データベース・テーブル空間を停止。

**構文**:

```
-STOP DATABASE(<dbname>) [SPACENAM(<tsname>) [PART(<n>)]] [AT(COMMIT|UNCOND)]
```

**注意点**: `AT(UNCOND)` は in-progress 業務を強制中断。RECOVER 等の前処理として使用、業務時間外推奨。

**関連手順**: [cfg-tablespace-create](08-config-procedures.md#cfg-tablespace-create)

**出典**: S_DB2_Cmds

---

### `-ALTER BUFFERPOOL` { #alter-bufferpool }

**用途**: バッファプールサイズ・閾値を動的変更。

**構文**:

```
-ALTER BUFFERPOOL(<bpname>) [VPSIZE(<n>)] [VPSEQT(<n>)] [DWQT(<n>)] [VDWQT(<n>,<n>)] [PGSTEAL(LRU|FIFO|NONE)]
```

**典型例**:

```
-ALTER BUFFERPOOL(BP1) VPSIZE(50000) VPSEQT(40)
（出力）DSNB511I - DSNB1CMA ALTER BUFFERPOOL FOR BP1 SUCCESSFUL
```

**注意点**: VPSIZE は次回 DB2 再起動 or `-ALTER BUFFERPOOL` 即時反映（縮小は in-use 解放を待つ）。`PGSTEAL(NONE)` は固定常駐（メモリで全件保持、Db2 v11 以降）— 適切なオブジェクトのみ指定（過大設定は仮想記憶を圧迫）。

**関連手順**: [cfg-bufferpool-tune](08-config-procedures.md#cfg-bufferpool-tune)

**関連用語**: [Buffer Pool](03-glossary.md#buffer-pool), [PGSTEAL](03-glossary.md#pgsteal)

**出典**: S_DB2_Cmds

---

### `-RECOVER INDOUBT` { #recover-indoubt }

**用途**: 2-phase commit で COMMIT or ABORT が確定せず宙ぶらりんになっている indoubt thread を解決。

**構文**:

```
-RECOVER INDOUBT [(<corr_id>|*)] ACTION(COMMIT|ABORT)
```

**典型例**:

```
-DISPLAY THREAD(*) TYPE(INDOUBT)
（出力に表示された LUWID をコピー）
-RECOVER INDOUBT(USER1) ACTION(COMMIT)
```

**注意点**: 必ず CICS / IMS / 他 Db2 / RM 側のログと突合してから ACTION(COMMIT) or ACTION(ABORT) を決定。誤判断はデータ整合性破壊の元凶。

**関連手順**: [inc-indoubt-thread](09-incident-procedures.md#inc-indoubt-thread)

**関連用語**: [Indoubt Thread](03-glossary.md#indoubt-thread), [LUWID](03-glossary.md#luwid)

**出典**: S_DB2_Admin

---

### `-TERM UTILITY` { #term-utility }

**用途**: hung または不要になったユーティリティジョブを終了。

**構文**:

```
-TERM UTILITY(<utilid>|*)
```

**注意点**: in-flight ユーティリティを止めても、対象オブジェクトが pending 状態（`STARTED` など）に残る場合あり。`-DISPLAY DATABASE RESTRICT` で残存 pending を確認、必要なら `START DATABASE ACCESS(FORCE)` か該当ユーティリティの `RESTART` で復旧。

**関連手順**: [inc-utility-stuck](09-incident-procedures.md#inc-utility-stuck)

**出典**: S_DB2_Cmds

---

## DSN サブコマンド

`DSN` プロセッサ（TSO foreground または batch JCL の `IKJEFT01`）配下で動作。

### `DSN` { #dsn }

**用途**: DSN コマンドプロセッサ起動。BIND/REBIND/RUN 等のサブコマンドの入口。

**構文**:

```
DSN SYSTEM(<ssid>)
```

**典型例**:

```
TSO READY モードで:
DSN SYSTEM(DB2A)
DSN
RUN PROGRAM(DSNTEP2) PLAN(DSNTEP71) -
    LIB('DSN.V13R1.RUNLIB.LOAD')
END
```

**注意点**: バッチで使うときは IKJEFT01 を STEPLIB に DSN.V13R1.LOAD を入れて実行。

**関連手順**: [cfg-bind-package](08-config-procedures.md#cfg-bind-package)

**出典**: S_DB2_Cmds

---

### `BIND PLAN` { #bind-plan }

**用途**: PLAN（v8 以降は package list を参照する PLAN がメイン）を作成。

**構文**:

```
BIND PLAN(<planname>) PKLIST(<collection>.*) -
     OWNER(<authid>) QUALIFIER(<authid>) -
     ISOLATION(CS|RR|RS|UR) ACQUIRE(USE|ALLOCATE) RELEASE(COMMIT|DEALLOCATE)
```

**注意点**: `RELEASE(DEALLOCATE)` は long-running batch の lock 取得回数削減に有効。`ISOLATION(CS)` がデフォ、`UR` は uncommitted read（dirty read 許容）。

**関連手順**: [cfg-bind-package](08-config-procedures.md#cfg-bind-package)

**関連用語**: [Plan](03-glossary.md#plan), [Package](03-glossary.md#package), [Isolation Level](03-glossary.md#isolation-level)

**出典**: S_DB2_Cmds

---

### `BIND PACKAGE` { #bind-package }

**用途**: PACKAGE（コンパイル済 SQL の単位）を作成。

**構文**:

```
BIND PACKAGE(<collection>) MEMBER(<dbrm>) -
     LIBRARY('<dbrm.lib>') -
     ACTION(REPLACE) APPLCOMPAT(V13R1)
```

**注意点**: `APPLCOMPAT(V13R1)` で適用する SQL 言語仕様レベルを指定。Function Level に依存して使える機能が変わるため、移行時要確認。

**関連手順**: [cfg-bind-package](08-config-procedures.md#cfg-bind-package), [cfg-applcompat-set](08-config-procedures.md#cfg-applcompat-set)

**関連用語**: [Package](03-glossary.md#package), [Application Compatibility](03-glossary.md#applcompat)

**出典**: S_DB2_Cmds

---

### `REBIND PACKAGE` { #rebind-package }

**用途**: 既存 PACKAGE を再 BIND（access path 再選択、APPLCOMPAT 変更等）。

**構文**:

```
REBIND PACKAGE(<coll.pkg>) [APREUSE(NONE|ERROR|WARN)] [APCOMPARE(NONE|ERROR|WARN)]
```

**注意点**: `APREUSE` は旧 access path を温存。`APCOMPARE` で旧 access path との差異検出。RUNSTATS 後の REBIND は計画的に。

**関連手順**: [cfg-bind-package](08-config-procedures.md#cfg-bind-package)

**関連用語**: [Access Path](03-glossary.md#access-path), [APREUSE](03-glossary.md#apreuse)

**出典**: S_DB2_Cmds

---

### `FREE PLAN / PACKAGE` { #free-plan---package }

**用途**: 不要 PLAN / PACKAGE をカタログから削除。

**構文**:

```
FREE PLAN(<planname>)
FREE PACKAGE(<coll>.<pkg>)
```

**注意点**: 同一 PLAN/PACKAGE 配下で参照する依存オブジェクト（VIEW 等）が drop された後の cleanup によく使う。

**出典**: S_DB2_Cmds

---

### `RUN PROGRAM` { #run-program }

**用途**: PLAN を持つ Db2 アプリケーションプログラムを実行（DSNTEP2 / DSNTIAUL / 業務 PGM 等）。

**構文**:

```
RUN PROGRAM(<pgm>) PLAN(<planname>) [PARMS('...')] LIB('<load.lib>')
```

**注意点**: `PARMS` は SYSIN または PARM= で渡す。

**出典**: S_DB2_Cmds

---

## ユーティリティ（DSNUTILB）

ユーティリティは JCL の EXEC PGM=DSNUTILB（`SYSPRINT`/`UTPRINT`/`SYSIN` 必須）で実行。`UTPROC=` で RESTART モード制御。

### `COPY` { #copy }

**用途**: テーブル空間・索引空間のイメージコピー（フル / インクリメンタル）取得。

**構文**:

```
COPY TABLESPACE <db>.<ts> [PART(<n>)] [SHRLEVEL CHANGE|REFERENCE] -
     COPYDDN(<full>,<incr>) [FULL YES|NO] [DSNUM ALL]
```

**典型例**:

```
COPY TABLESPACE PRODDB.TS01 SHRLEVEL CHANGE COPYDDN(SYSCOPY1)
```

**注意点**: `SHRLEVEL CHANGE` で業務継続中 copy。`FULL NO` でインクリメンタル（前 full からの変更ページのみ）。`MERGECOPY` で full + incr → new full 統合。

**関連手順**: [cfg-image-copy](08-config-procedures.md#cfg-image-copy)

**関連用語**: [Image Copy](03-glossary.md#image-copy), [SYSCOPY](03-glossary.md#syscopy)

**出典**: S_DB2_Util

---

### `LOAD` { #load }

**用途**: フラットファイル/カーソルからテーブルへ大量データロード。

**構文**:

```
LOAD DATA INDDN <ddname> INTO TABLE <schema>.<tab> -
     [RESUME YES|NO] [SHRLEVEL NONE|CHANGE] [LOG YES|NO]
```

**注意点**: `LOG NO` は速いが、再 LOG 取り（COPY YES + COPY 取得）必須。`SHRLEVEL CHANGE` は v12 以降の online LOAD（partition 単位）。`RESUME YES` で既存行に追加 LOAD。

**関連手順**: [cfg-load-flat](08-config-procedures.md#cfg-load-flat)

**関連用語**: [Utility](03-glossary.md#utility)

**出典**: S_DB2_Util

---

### `UNLOAD` { #unload }

**用途**: テーブルから外部ファイルへの行 unload。LOAD 互換フォーマット出力可能。

**構文**:

```
UNLOAD TABLESPACE <db>.<ts> [FROM TABLE <schema>.<tab>] -
       PUNCHDDN <ddname> UNLDDN <ddname>
```

**注意点**: `PUNCHDDN` に LOAD 用制御文を出力、`UNLDDN` にデータ。LOAD 互換性が高い。

**出典**: S_DB2_Util

---

### `REORG TABLESPACE` { #reorg-tablespace }

**用途**: テーブル空間の物理再編成（free space 回復、cluster ratio 改善、partition rotation 等）。

**構文**:

```
REORG TABLESPACE <db>.<ts> [PART(<n>)] [SHRLEVEL NONE|REFERENCE|CHANGE] -
      [SORTDATA] [LOG NO COPYDDN(...)]
```

**注意点**: `SHRLEVEL CHANGE` でオンライン REORG（shadow dataset で reload、SWITCH phase で切替）。SWITCH 中の業務影響は短時間だが zero-downtime ではない。`MAXRO` / `DRAIN_WAIT` 等の調整余地あり。

**関連手順**: [cfg-reorg-online](08-config-procedures.md#cfg-reorg-online)

**関連用語**: [REORG](03-glossary.md#reorg), [SHRLEVEL](03-glossary.md#shrlevel), [Cluster Ratio](03-glossary.md#cluster-ratio)

**出典**: S_DB2_Util

---

### `REORG INDEX` { #reorg-index }

**用途**: 索引の再編成。leaf split で歪んだ index を整理。

**構文**:

```
REORG INDEX <schema>.<idx> [SHRLEVEL NONE|REFERENCE|CHANGE]
```

**出典**: S_DB2_Util

---

### `RUNSTATS` { #runstats }

**用途**: テーブル・索引のカタログ統計（CARDF, NACTIVE, NLEAF 等）を更新。Optimizer の access path 選択に使う。

**構文**:

```
RUNSTATS TABLESPACE <db>.<ts> TABLE(ALL) INDEX(ALL) [SHRLEVEL CHANGE]
```

**注意点**: 大量データ更新後・索引追加後に必須。古い統計は不適切な access path を生む。`HISTORY` 句で履歴記録、`PROFILE` 機能で統計の対象を pre-defined テンプレ化（Db2 12 以降）。

**関連手順**: [cfg-runstats-schedule](08-config-procedures.md#cfg-runstats-schedule)

**関連用語**: [Catalog Statistics](03-glossary.md#catalog-statistics), [Access Path](03-glossary.md#access-path)

**出典**: S_DB2_Util

---

### `CHECK DATA` { #check-data }

**用途**: 外部キー整合性、CHECK 制約整合性、テーブル空間とインデックスの内部整合性チェック。

**構文**:

```
CHECK DATA TABLESPACE <db>.<ts> [SCOPE PENDING|ALL] [DELETE YES|NO]
```

**注意点**: LOAD 後 / RECOVER 後に CHKP（CHECK ペンディング）状態が立つことあり、`CHECK DATA` で解除。`DELETE YES` で違反行を例外表に移動。

**関連手順**: [inc-restp-recovery](09-incident-procedures.md#inc-restp-recovery)

**関連用語**: [CHKP](03-glossary.md#chkp)

**出典**: S_DB2_Util

---

### `RECOVER` { #recover }

**用途**: テーブル空間・索引の復旧（ログ + イメージコピーから時点復旧）。

**構文**:

```
RECOVER TABLESPACE <db>.<ts> [TOLOGPOINT <RBA/LRSN>] [TORBA <RBA>] [TOCOPY <dsn>]
```

**注意点**: TOLOGPOINT は LRSN (data sharing) または RBA (non-DS) を指定。`TOCOPY` で指定 copy 時点に復旧（ログ未適用）。`TORBA` 後は QUIESCE 取得点を境界に。

**関連手順**: [inc-tablespace-corrupt](09-incident-procedures.md#inc-tablespace-corrupt)

**関連用語**: [LRSN](03-glossary.md#lrsn), [RBA](03-glossary.md#rba), [Image Copy](03-glossary.md#image-copy)

**出典**: S_DB2_Util

---

### `QUIESCE` { #quiesce }

**用途**: 一貫性ある回復ポイント（QUIESCE point = 全 in-flight UR を強制 commit/abort 後の点）を取得。

**構文**:

```
QUIESCE TABLESPACESET TABLESPACE <db>.<ts1>, TABLESPACE <db>.<ts2>
```

**注意点**: TABLESPACESET で複数 TS 同時に QUIESCE point を取ると関連 TS 群を同時に時点復旧可能。RECOVER の事前準備として頻用。

**関連用語**: [QUIESCE](03-glossary.md#quiesce-point)

**出典**: S_DB2_Util

---

### `REPAIR` { #repair }

**用途**: ヘッダ修正、ページ修正、テーブル空間 STATUS フラグの強制 reset 等の低レベル修復。

**構文**:

```
REPAIR OBJECT TABLESPACE <db>.<ts> RESET <state> -- e.g. RESET COPY/CHECK/etc
```

**注意点**: 強力すぎるためデータ破壊リスクあり。最後の手段、IBM サポートと相談しつつ実行推奨。

**関連手順**: [inc-tablespace-corrupt](09-incident-procedures.md#inc-tablespace-corrupt)

**出典**: S_DB2_Util

---

## SQL 運用クエリ

### `SELECT FROM SYSIBM.SYSTABLES` { #select-systables }

**用途**: カタログから表定義を取得。

**典型例**:

```sql
SELECT NAME, CREATOR, DBNAME, TSNAME, TYPE
FROM SYSIBM.SYSTABLES
WHERE CREATOR='PRODSCH' AND TYPE='T';
```

**関連用語**: [Catalog](03-glossary.md#catalog), [SYSIBM](03-glossary.md#sysibm)

**出典**: S_DB2_SQLRef

---

### `SELECT FROM SYSIBM.SYSCOPY` { #select-syscopy }

**用途**: イメージコピー履歴取得。RECOVER 計画の入力に使う。

**典型例**:

```sql
SELECT DBNAME, TSNAME, ICTYPE, START_RBA, TIMESTAMP
FROM SYSIBM.SYSCOPY
WHERE DBNAME='PRODDB'
ORDER BY TIMESTAMP DESC
FETCH FIRST 20 ROWS ONLY;
```

**関連用語**: [SYSCOPY](03-glossary.md#syscopy)

**出典**: S_DB2_SQLRef

---

### `SELECT FROM SYSIBM.SYSPACKAGE` { #select-syspackage }

**用途**: PACKAGE 一覧と APPLCOMPAT、bind 時刻を取得。

**典型例**:

```sql
SELECT COLLID, NAME, VERSION, BINDTIME, APPLCOMPAT
FROM SYSIBM.SYSPACKAGE
WHERE COLLID='PROD'
ORDER BY BINDTIME DESC;
```

**関連用語**: [Package](03-glossary.md#package), [Application Compatibility](03-glossary.md#applcompat)

**出典**: S_DB2_SQLRef

---

### `EXPLAIN` { #explain }

**用途**: SQL の access path を PLAN_TABLE / DSN_STATEMNT_TABLE 等に記録。

**典型例**:

```sql
EXPLAIN PLAN SET QUERYNO=1 FOR
  SELECT C1, C2 FROM PRODSCH.TAB WHERE C1=1;

SELECT QUERYNO, METHOD, ACCESSTYPE, ACCESSNAME, MATCHCOLS
FROM PLAN_TABLE WHERE QUERYNO=1;
```

**注意点**: PLAN_TABLE の事前作成が必要（DSNTESC サンプル参照）。`ACCESSTYPE='I'`（index scan）/`'R'`（table scan）/`'M'`（multiindex）/`'I1'`（one-fetch）等。

**関連用語**: [EXPLAIN](03-glossary.md#explain), [Access Path](03-glossary.md#access-path), [PLAN_TABLE](03-glossary.md#plan-table)

**出典**: S_DB2_AppPgm

---

### `SET CURRENT SQLID` { #set-current-sqlid }

**用途**: 現セッションの SQL ID（オブジェクト qualifier）を変更。

**典型例**:

```sql
SET CURRENT SQLID = 'PRODSCH';
SELECT * FROM TAB;  -- = PRODSCH.TAB
```

**関連用語**: [SQLID](03-glossary.md#sqlid)

**出典**: S_DB2_SQLRef

---

### `SET CURRENT APPLICATION COMPATIBILITY` { #set-applcompat }

**用途**: 動的 SQL の適用 APPLCOMPAT を変更。

**典型例**:

```sql
SET CURRENT APPLICATION COMPATIBILITY = 'V13R1';
```

**関連用語**: [Application Compatibility](03-glossary.md#applcompat), [Function Level](03-glossary.md#function-level)

**関連手順**: [cfg-applcompat-set](08-config-procedures.md#cfg-applcompat-set)

**出典**: S_DB2_SQLRef

---

### `COMMIT / ROLLBACK` { #commit--rollback }

**用途**: トランザクションの確定 / 取消。

**注意点**: long-running batch では適切な COMMIT 頻度（数千行ごと等）でロック保持時間を抑制。COMMIT で lock release されるため、COMMIT 直後に他スレッドが進める。

**関連用語**: [UR](03-glossary.md#ur), [Lock](03-glossary.md#lock)

**出典**: S_DB2_SQLRef

---

### `LOCK TABLE` { #lock-table }

**用途**: テーブル全体に対するロック取得（SHARE/EXCLUSIVE）。バッチで row lock 取得回数を削減する常套手段。

**構文**:

```sql
LOCK TABLE <schema>.<tab> IN SHARE MODE;
LOCK TABLE <schema>.<tab> IN EXCLUSIVE MODE;
```

**注意点**: 並列性が大幅低下するため business window と要相談。`PARTITION` 句で partition 単位ロックも可。

**関連用語**: [Lock](03-glossary.md#lock), [Lock Granularity](03-glossary.md#lock-granularity)

**出典**: S_DB2_SQLRef

---

## IRLM

IRLM は別 STC として動作し、DB2 と通信しロックを管理。

### `MODIFY irlmproc,STATUS` { #modify-irlm-status }

**用途**: IRLM の状態（ロック構造、メモリ、connected DB2 サブシステム）を表示。

**構文**:

```
F <irlmproc>,STATUS,<resource_type>
```

**典型例**:

```
F IRLMPROC,STATUS,ALLD
（出力）DXR105I IRLMPROC STATUS - ID 1
  IRLMID = 1   IRLMNM = IRLMA
  CONNECTED DB2 SUBSYSTEMS:
   DB2 NAME      STATUS
   DB2A          UP
```

**関連用語**: [IRLM](03-glossary.md#irlm)

**出典**: S_DB2_Admin

---

### `MODIFY irlmproc,DIAG` { #modify-irlm-diag }

**用途**: IRLM のデッドロック診断ダンプ取得。

**構文**:

```
F <irlmproc>,DIAG,DEADLOCK
```

**注意点**: deadlock 時の問題判別に強力。出力は IRLM の SYSPRINT 相当に出る。

**関連手順**: [inc-deadlock](09-incident-procedures.md#inc-deadlock)

**出典**: S_DB2_Admin

---

### `MODIFY irlmproc,SET` { #modify-irlm-set }

**用途**: IRLM チューニングパラメータ（DEADLOK / TIMEOUT 等）を動的変更。

**構文**:

```
F <irlmproc>,SET,DEADLOK=(<localdsec>,<global>) 
F <irlmproc>,SET,TIMEOUT=(<dbssn>,<seconds>)
```

**注意点**: DEADLOK 検出間隔と TIMEOUT 値は性能とのトレードオフ。default は IRLMPROC PROC で指定。

**関連用語**: [IRLM](03-glossary.md#irlm), [DEADLOK](03-glossary.md#deadlok), [IRLMRWT](03-glossary.md#irlmrwt)

**出典**: S_DB2_Admin

---

## DSNTEP2 / DSNTIAUL（バッチ実行系）

### `DSNTEP2` { #dsntep2 }

**用途**: SYSIN にある SQL を順次実行する IBM 提供サンプル PGM。任意 DDL/DML を batch で流すのに便利。

**典型例（JCL）**:

```jcl
//STEP1 EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSTSIN DD *
DSN SYSTEM(DB2A)
RUN PROGRAM(DSNTEP2) PLAN(DSNTEP71) -
    LIB('DSN.V13R1.RUNLIB.LOAD')
END
//SYSIN DD *
SELECT * FROM SYSIBM.SYSTABLES FETCH FIRST 5 ROWS ONLY;
/*
```

**注意点**: DSNTEP4 / DSNTEP71 はそれぞれ Db2 バージョン別 PLAN。Db2 13 の場合は `DSNTEP71` が事前 BIND 済（PRODUCED PLAN）として提供。

**出典**: S_DB2_Cmds

---

### `DSNTIAUL` { #dsntiaul }

**用途**: SYSIN に書いた SELECT の結果を flat ファイルに UNLOAD。簡易バックアップ・移行用。

**典型例（JCL）**:

```jcl
//SYSTSIN DD *
DSN SYSTEM(DB2A)
RUN PROGRAM(DSNTIAUL) PLAN(DSNTIB71)
END
//SYSREC00 DD DSN=USER1.UNLOAD.DAT,DISP=(NEW,CATLG)
//SYSPUNCH DD DSN=USER1.UNLOAD.CTL,DISP=(NEW,CATLG)
//SYSIN DD *
PRODSCH.TAB
```

**注意点**: SYSPUNCH に LOAD 互換制御文が出力される。UNLOAD ユーティリティのほうが新しい・速い・partition 並列等に対応するため、現代では UNLOAD 推奨。DSNTIAUL は legacy 互換用。

**出典**: S_DB2_Cmds

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
