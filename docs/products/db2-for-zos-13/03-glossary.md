# 用語集

> 掲載：**80 件（関連用語クロスリンク + Db2 v13 固有を含む）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## サブシステム / アドレス空間（10 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="db2-subsystem">**Db2 サブシステム**</span> | z/OS の subsystem として登録される RDBMS インスタンス。SSID（Subsystem ID）= 4 文字（例: DB2A）で識別。 | [SSID](#ssid), [DSNZPARM](#dsnzparm), [DB2MSTR](#db2mstr) | [cfg-db2-startup](08-config-procedures.md#cfg-db2-startup) |
| <span id="ssid">**SSID**</span> | Db2 Subsystem Identifier。z/OS の IEFSSNxx で登録、コマンドプレフィックス（`-DSN1` 等）と紐付け。 | [Db2 サブシステム](#db2-subsystem), Command Prefix |  |
| <span id="db2mstr">**DB2MSTR**</span> | Master Address Space。Db2 全体の制御、ロガ、IRLM 連携、ユーティリティ受付。`-START DB2` で起動。 | [DBM1](#dbm1), [IRLM](#irlm), [DDF](#ddf) | [cfg-db2-startup](08-config-procedures.md#cfg-db2-startup) |
| <span id="dbm1">**DB2DBM1（DBM1）**</span> | Database Services Address Space。バッファプール・EDM プール・SQL 実行エンジンが動作する主アドレス空間。 | [DB2MSTR](#db2mstr), [Buffer Pool](#buffer-pool), [EDM Pool](#edm-pool) | [cfg-bufferpool-tune](08-config-procedures.md#cfg-bufferpool-tune) |
| <span id="ddf">**DDF（DB2DIST）**</span> | Distributed Data Facility。DRDA プロトコルによる remote 接続を扱うアドレス空間。`-DISPLAY DDF`、TCP port 446（既定）。 | [DRDA](#drda), [DBAT](#dbat), [Location](#location) | [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup) |
| <span id="db2spas">**DB2SPAS**</span> | Stored Procedure Address Space。ストアド プロシージャ実行を WLM 管理 SPAS で動的起動。 | [WLM](#wlm), [Stored Procedure](#stored-procedure) | [cfg-stored-proc-setup](08-config-procedures.md#cfg-stored-proc-setup) |
| <span id="irlm">**IRLM**</span> | Internal Resource Lock Manager。Db2 と連携する別 STC として稼働、テーブル空間・行・index ロックを管理。データ共用環境では CF にロック構造を持つ。 | [Lock](#lock), [DEADLOK](#deadlok), [IRLMRWT](#irlmrwt) | [inc-deadlock](09-incident-procedures.md#inc-deadlock) |
| <span id="dsnzparm">**DSNZPARM**</span> | Db2 サブシステムパラメータの集約ロードモジュール。DSN6SYSP / DSN6SPRM / DSN6FAC / DSN6LOGP / DSN6ARVP / DSN6GRP の 6 マクロを assemble して合成。 | [DSN6SYSP](#dsn6sysp), [DSN6SPRM](#dsn6sprm), [DSN6FAC](#dsn6fac), [DSN6LOGP](#dsn6logp), [DSN6ARVP](#dsn6arvp), [DSN6GRP](#dsn6grp) | [cfg-dsnzparm-update](08-config-procedures.md#cfg-dsnzparm-update) |
| <span id="dsn6sysp">**DSN6SYSP**</span> | システム関連マクロ（CTHREAD, CONDBAT, MAXDBAT, IDFORE, IDBACK 等）。DSNZPARM の中核。 | [DSNZPARM](#dsnzparm) | [cfg-dsnzparm-update](08-config-procedures.md#cfg-dsnzparm-update) |
| <span id="dsn6sprm">**DSN6SPRM**</span> | 処理関連マクロ（NUMLKTS, NUMLKUS, IRLMRWT, AUTHCACH 等）。 | [DSNZPARM](#dsnzparm) | [cfg-dsnzparm-update](08-config-procedures.md#cfg-dsnzparm-update) |

## カタログ / ディレクトリ（8 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="catalog">**Catalog（DSNDB06）**</span> | Db2 のメタデータ表群（SYSIBM.SYSTABLES、SYSIBM.SYSCOLUMNS、SYSIBM.SYSPACKAGE 等）を含む system database。SQL でアクセス可能。 | [SYSIBM](#sysibm), [Directory](#directory) | [cfg-catalog-maintenance](08-config-procedures.md#cfg-catalog-maintenance) |
| <span id="directory">**Directory（DSNDB01）**</span> | Db2 内部利用のメタデータ（SCT02, SPT01, SYSLGRNX, SYSUTILX, DBD01）。SQL アクセス不可、内部用。 | [Catalog](#catalog), [DBD](#dbd) |  |
| <span id="sysibm">**SYSIBM**</span> | Catalog の標準 schema 名。`SYSIBM.SYSTABLES` 等で参照。 | [Catalog](#catalog) |  |
| <span id="dbd">**DBD**</span> | Database Descriptor。データベース内の object 定義キャッシュ（DBD01 directory に格納）。`-DISPLAY DATABASE` で長さ表示。 | [Directory](#directory), [Catalog](#catalog) |  |
| <span id="syscopy">**SYSCOPY**</span> | SYSIBM.SYSCOPY。イメージコピーや LOG QUIESCE / LOAD 等の履歴を持つ catalog 表。RECOVER 計画に必須。 | [Catalog](#catalog), [Image Copy](#image-copy) | [inc-tablespace-corrupt](09-incident-procedures.md#inc-tablespace-corrupt) |
| <span id="syslgrnx">**SYSLGRNX**</span> | SYSIBM.SYSLGRNX 相当（directory 側）。テーブル空間の log range を記録、RECOVER の対象 archive log 特定に使う。 | [Directory](#directory), [Archive Log](#archive-log) |  |
| <span id="sysutilx">**SYSUTILX**</span> | 実行中ユーティリティの状態管理表（directory）。`-DISPLAY UTILITY` の元情報。 | [Directory](#directory), [Utility](#utility) | [inc-utility-stuck](09-incident-procedures.md#inc-utility-stuck) |
| <span id="catmaint">**CATMAINT**</span> | カタログ・directory の構造を新しい Function Level / Catalog Level に upgrade するユーティリティ。Db2 13 移行時に実行。 | [Function Level](#function-level), [Catalog Level](#catalog-level) | [cfg-functionlevel-activate](08-config-procedures.md#cfg-functionlevel-activate) |

## オブジェクト（10 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="database">**Database**</span> | Db2 のオブジェクト集約単位。STOGROUP 既定、テーブル空間と索引空間を含む。`-DISPLAY DATABASE` で状態表示。 | [Tablespace](#tablespace), [Stogroup](#stogroup) | [cfg-tablespace-create](08-config-procedures.md#cfg-tablespace-create) |
| <span id="tablespace">**Tablespace**</span> | テーブルを格納する物理単位。タイプ：UTS-PBR (Partition By Range)、UTS-PBG (Partition By Growth)、Segmented、Simple（廃止予定）、LOB、XML。 | [Database](#database), [UTS-PBR](#uts-pbr), [UTS-PBG](#uts-pbg), [Segmented Tablespace](#segmented-tablespace) | [cfg-tablespace-create](08-config-procedures.md#cfg-tablespace-create) |
| <span id="uts-pbr">**UTS-PBR**</span> | Universal Tablespace - Partition By Range。範囲分割方式、partition 単位ユーティリティ実行可。新規作成は UTS が必須（v12 以降）。 | [Tablespace](#tablespace), [Partition](#partition) | [cfg-tablespace-create](08-config-procedures.md#cfg-tablespace-create) |
| <span id="uts-pbg">**UTS-PBG**</span> | Universal Tablespace - Partition By Growth。1 partition から成長に伴い自動 partition 追加。Db2 13 で online → PBR 変換可能。 | [Tablespace](#tablespace), [Partition](#partition) |  |
| <span id="segmented-tablespace">**Segmented Tablespace**</span> | 古いタイプ、複数表を 1 TS に格納可。Universal Tablespace への移行推奨。 | [Tablespace](#tablespace) |  |
| <span id="indexspace">**Indexspace**</span> | 索引を格納する物理単位。索引作成時に自動生成、論理名は `index name`。 | [Tablespace](#tablespace), [Index](#index) |  |
| <span id="stogroup">**Stogroup**</span> | テーブル空間・索引空間の DASD volume 集合定義。`CREATE STOGROUP` で定義、TS / IS が VCAT/VSAM で割り当てられる。 | [Database](#database), [Tablespace](#tablespace) |  |
| <span id="schema">**Schema**</span> | object qualifier。`CREATE SCHEMA` で明示作成 or implicit に user の auth ID 配下に作られる。 | [SQLID](#sqlid) |  |
| <span id="plan">**Plan**</span> | バッチ・TSO アプリ実行のセキュリティ・コミット範囲単位。v8 以降は package list を持つ単なる「コンテナ」役割が主。 | [Package](#package), [BIND PLAN](#bind-plan-cmd) | [cfg-bind-package](08-config-procedures.md#cfg-bind-package) |
| <span id="package">**Package**</span> | コンパイル済 SQL の単位。`COLLECTION.NAME[.VERSION]` で識別。`-DISPLAY` で動作確認。BIND/REBIND の対象。 | [Plan](#plan), [Collection](#collection), [APPLCOMPAT](#applcompat) | [cfg-bind-package](08-config-procedures.md#cfg-bind-package) |

## バッファプール / メモリ（8 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="buffer-pool">**Buffer Pool**</span> | DB2DBM1 アドレス空間内のページキャッシュ。BP0–BP49（4KB）、BP8K0–9（8KB）、BP16K0–9、BP32K–32K9（32KB）の 60 個。 | [Getpage](#getpage), [VPSIZE](#vpsize), [PGSTEAL](#pgsteal) | [cfg-bufferpool-tune](08-config-procedures.md#cfg-bufferpool-tune) |
| <span id="getpage">**Getpage**</span> | バッファプールへのページ要求。RANDOM / SEQUENTIAL の比率で hit ratio 計算。 | [Buffer Pool](#buffer-pool) |  |
| <span id="vpsize">**VPSIZE**</span> | Virtual Pool Size。バッファプールに割り当てるページ数。`-ALTER BUFFERPOOL VPSIZE(...)` で変更。 | [Buffer Pool](#buffer-pool) | [cfg-bufferpool-tune](08-config-procedures.md#cfg-bufferpool-tune) |
| <span id="pgsteal">**PGSTEAL**</span> | バッファプールページ置換アルゴリズム。LRU（既定）/ FIFO（速いが hit ratio 低下）/ NONE（固定常駐 = page-fix in memory）。 | [Buffer Pool](#buffer-pool) |  |
| <span id="vpseqt">**VPSEQT**</span> | Virtual Pool Sequential Threshold。シーケンシャルアクセス用 buffer 比率（%、既定 80）。 | [Buffer Pool](#buffer-pool) |  |
| <span id="dwqt">**DWQT**</span> | Deferred Write Queue Threshold。bufferpool 全体の書出 trigger（%、既定 30）。 | [Buffer Pool](#buffer-pool), [Deferred Write](#deferred-write) |  |
| <span id="edm-pool">**EDM Pool**</span> | Environmental Descriptor Manager Pool。DBD / SKCT（PLAN）/ SKPT（PACKAGE）/ DSC（dynamic SQL cache）等を保持する DBM1 内 storage。 | [DBD](#dbd), [Plan](#plan), [Package](#package), [DSC](#dsc) |  |
| <span id="dsc">**DSC（Dynamic Statement Cache）**</span> | EDM Pool 内の動的 SQL キャッシュ。`KEEPDYNAMIC YES` BIND の package で使用、再 prepare 削減。 | [EDM Pool](#edm-pool), [MAXKEEPD](#maxkeepd) |  |

## ロック / 並行性（10 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="lock">**Lock**</span> | データに対する排他制御。Db2 では IRLM が管理、ロック種類は IS/IX/S/U/X/SIX。 | [IRLM](#irlm), [Isolation Level](#isolation-level), [Lock Granularity](#lock-granularity) | [inc-lock-timeout](09-incident-procedures.md#inc-lock-timeout) |
| <span id="lock-granularity">**Lock Granularity**</span> | ロック粒度。tablespace / partition / page / row / LOB / XML。`LOCKSIZE` 句で指定。 | [Lock](#lock), [LOCKSIZE](#locksize) |  |
| <span id="locksize">**LOCKSIZE**</span> | テーブル空間の lock 粒度設定（ANY / TABLESPACE / TABLE / PAGE / ROW / LOB）。`ALTER TABLESPACE LOCKSIZE` で変更。ANY = Db2 が判断。 | [Lock](#lock), [Lock Granularity](#lock-granularity) |  |
| <span id="isolation-level">**Isolation Level**</span> | トランザクション分離レベル。CS（Cursor Stability、既定）、RR（Repeatable Read）、RS（Read Stability）、UR（Uncommitted Read）。BIND 時 `ISOLATION` 句または SQL の `WITH UR/CS/RR/RS`。 | [Lock](#lock), [UR](#ur) | [cfg-bind-package](08-config-procedures.md#cfg-bind-package) |
| <span id="ur">**UR（Uncommitted Read）**</span> | 未コミットのデータも読む dirty read。レポート系で使用、整合性は犠牲。 | [Isolation Level](#isolation-level) |  |
| <span id="lock-escalation">**Lock Escalation**</span> | 行/ページロックが NUMLKTS 超で TS lock に昇格。並行性低下の元、適切な閾値設定が肝要。 | [NUMLKTS](#numlkts), [NUMLKUS](#numlkus) | [inc-lock-escalation](09-incident-procedures.md#inc-lock-escalation) |
| <span id="numlkts">**NUMLKTS**</span> | DSN6SPRM のパラメータ。1 トランザクションが 1 TS で取得できる最大ロック数。超過で escalation。 | [Lock Escalation](#lock-escalation), [DSN6SPRM](#dsn6sprm) |  |
| <span id="numlkus">**NUMLKUS**</span> | DSN6SPRM のパラメータ。1 user の全 TS 合計の最大ロック数。超過で SQLCODE -904。 | [Lock Escalation](#lock-escalation), [DSN6SPRM](#dsn6sprm) |  |
| <span id="deadlok">**DEADLOK**</span> | DSN6SPRM。デッドロック検出間隔（local ms、global iteration 数）。 | [IRLM](#irlm), [Deadlock](#deadlock) | [inc-deadlock](09-incident-procedures.md#inc-deadlock) |
| <span id="irlmrwt">**IRLMRWT**</span> | DSN6SPRM。ロック待ち timeout（秒、既定 30）。SQLCODE -911（victim）/-913（caller）の元。 | [IRLM](#irlm), [Lock](#lock) | [inc-lock-timeout](09-incident-procedures.md#inc-lock-timeout) |

### 関連用語

<span id="deadlock">**Deadlock**</span> = 互いに相手のロックを待ち合うサイクル。IRLM が検出して victim を選ぶ（SQLCODE -911）。

## ログ / リカバリ（8 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="active-log">**Active Log**</span> | 直近のログを書き込む VSAM データセット（LOGCOPY1 / LOGCOPY2 の二重化推奨）。`-DISPLAY LOG` で使用率確認。 | [Archive Log](#archive-log), [BSDS](#bsds), [RBA](#rba) | [cfg-log-archive](08-config-procedures.md#cfg-log-archive) |
| <span id="archive-log">**Archive Log**</span> | アクティブログがフルになると自動的にオフロードされる log データセット（DASD or TAPE）。RECOVER の入力。 | [Active Log](#active-log), [BSDS](#bsds), [DSN6ARVP](#dsn6arvp) | [cfg-log-archive](08-config-procedures.md#cfg-log-archive) |
| <span id="bsds">**BSDS**</span> | Boot Strap Data Set。Db2 起動時の log 構成読み出し元、active/archive log エントリと checkpoint 情報を持つ。二重化必須相当。 | [Active Log](#active-log), [Archive Log](#archive-log) | [inc-bsds-corrupt](09-incident-procedures.md#inc-bsds-corrupt) |
| <span id="rba">**RBA**</span> | Relative Byte Address。non-data-sharing 環境のログ位置。recovery 時点指定に使う。 | [LRSN](#lrsn), [Active Log](#active-log) |  |
| <span id="lrsn">**LRSN**</span> | Log Record Sequence Number。data-sharing 環境のグローバルログ位置（STCK ベース）。 | [RBA](#rba), [Data Sharing Group](#data-sharing-group) |  |
| <span id="checkpoint">**Checkpoint**</span> | dirty buffer flush + UR 状態記録のポイント。CHECKFREQ で間隔制御、recovery の起点。 | [CHECKFREQ](#checkfreq), [Active Log](#active-log) |  |
| <span id="image-copy">**Image Copy**</span> | テーブル空間・索引空間の物理 backup。COPY ユーティリティで取得、SYSCOPY に履歴。FULL / INCREMENTAL の 2 種。 | [SYSCOPY](#syscopy), [RECOVER](#recover-cmd) | [cfg-image-copy](08-config-procedures.md#cfg-image-copy) |
| <span id="quiesce-point">**QUIESCE Point**</span> | QUIESCE ユーティリティで全 in-flight UR を強制 commit/abort 後に取得した一貫点。RECOVER TOLOGPOINT の入力に使用。 | [Image Copy](#image-copy), [RECOVER](#recover-cmd) |  |

## ユーティリティ（6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="utility">**Utility**</span> | DSNUTILB プログラムで実行する batch 系 DBA ツール（COPY, LOAD, REORG, RUNSTATS, RECOVER 等）。 | [DSNUTILB](#dsnutilb), [SHRLEVEL](#shrlevel) |  |
| <span id="dsnutilb">**DSNUTILB**</span> | ユーティリティ実行用の IBM 提供 batch program。JCL の `EXEC PGM=DSNUTILB,PARM='SSID,UTILID'` で呼出。 | [Utility](#utility) |  |
| <span id="shrlevel">**SHRLEVEL**</span> | ユーティリティ実行中の業務並行性レベル。NONE = 排他、REFERENCE = 読取可、CHANGE = 更新可（online utility）。 | [Utility](#utility), [REORG](#reorg) | [cfg-reorg-online](08-config-procedures.md#cfg-reorg-online) |
| <span id="reorg">**REORG**</span> | テーブル空間・索引の再編成ユーティリティ。free space 回復、cluster 改善、partition rotate。 | [Utility](#utility), [SHRLEVEL](#shrlevel), [Cluster Ratio](#cluster-ratio) | [cfg-reorg-online](08-config-procedures.md#cfg-reorg-online) |
| <span id="utility-phase">**Utility Phase**</span> | ユーティリティの内部フェーズ（UTILINIT, UNLOAD, RELOAD, SORT, BUILD, SWITCH, SORTBLD, LOG, UTILTERM 等）。`-DISPLAY UTILITY` で表示。 | [Utility](#utility) |  |
| <span id="cluster-ratio">**Cluster Ratio**</span> | テーブルの物理順と clustering index の論理順の一致度。低いと REORG で改善余地あり。SYSIBM.SYSINDEXES.CLUSTERRATIOF。 | [REORG](#reorg) |  |

## DDF / 分散（6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="drda">**DRDA**</span> | Distributed Relational Database Architecture。IBM 系 RDB（Db2 / DB2 LUW / Informix）間の SQL プロトコル。Db2 z/OS は DRDA AS（application server）/AR（application requester）両対応。 | [DDF](#ddf), [Location](#location) |  |
| <span id="dbat">**DBAT**</span> | Database Access Thread。DDF 経由のリモート接続を実行する Db2 内 thread。MAXDBAT で上限制御。CMTSTAT=INACTIVE なら commit 後 pool に戻る。 | [DDF](#ddf), [MAXDBAT](#maxdbat) | [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup) |
| <span id="location">**Location**</span> | Db2 ノードの論理名。DDF 接続先指定で使う（`CONNECT TO <location>`）。サーバ側は `-DISPLAY DDF` で表示、SYSIBM.LOCATIONS にも登録。 | [DDF](#ddf), [DRDA](#drda) | [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup) |
| <span id="luwid">**LUWID**</span> | Logical Unit of Work Identifier。分散トランザクション識別子（NETID.LUNAME.uniqueid.commit-count）。indoubt thread 解決時の照合に使う。 | [Indoubt Thread](#indoubt-thread), [DDF](#ddf) | [inc-indoubt-thread](09-incident-procedures.md#inc-indoubt-thread) |
| <span id="indoubt-thread">**Indoubt Thread**</span> | 2-phase commit で coordinator から最終決定（COMMIT/ABORT）を受け取る前に Db2 が異常終了したスレッド。`-RECOVER INDOUBT` で解決。 | [LUWID](#luwid), [DDF](#ddf) | [inc-indoubt-thread](09-incident-procedures.md#inc-indoubt-thread) |
| <span id="trusted-context">**Trusted Context / Role**</span> | 接続元（IP / job / authid）の組合せに対し信頼関係を定義し、追加権限（ROLE）を付与する仕組み。3-tier アプリのアカウント代理に有用。 | [DDF](#ddf), [Authid](#authid) | [cfg-trusted-context](08-config-procedures.md#cfg-trusted-context) |

## データ共用 / Function Level（6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="data-sharing-group">**Data Sharing Group**</span> | 複数 Db2 サブシステム（最大 32）が同一カタログ・データを CF（Coupling Facility）経由で共有する Sysplex 機能。 | [GBP](#gbp), [LOCK1](#lock1), [SCA](#sca), [Function Level](#function-level) | [cfg-datasharing-add-member](08-config-procedures.md#cfg-datasharing-add-member) |
| <span id="gbp">**GBP（Group Buffer Pool）**</span> | データ共用環境のグローバルバッファプール、CF cache structure 上に常駐。各メンバの local BP との連携で page 整合性を保つ。 | [Data Sharing Group](#data-sharing-group), [Buffer Pool](#buffer-pool) |  |
| <span id="lock1">**LOCK1**</span> | データ共用環境のロック構造（CF lock structure）。IRLM が管理。 | [Data Sharing Group](#data-sharing-group), [IRLM](#irlm) |  |
| <span id="sca">**SCA（Shared Communications Area）**</span> | データ共用環境の共有制御 area（CF list structure）。各メンバの状態・カタログ更新通知用。 | [Data Sharing Group](#data-sharing-group) |  |
| <span id="function-level">**Function Level**</span> | Db2 13 の Continuous Delivery で機能を段階適用する単位。FL500 / FL501 / FL502... と進化。`-ACTIVATE FUNCTION LEVEL(...)` で適用、`CATMAINT` で catalog level も連動。 | [Catalog Level](#catalog-level), [Application Compatibility](#applcompat), [CATMAINT](#catmaint) | [cfg-functionlevel-activate](08-config-procedures.md#cfg-functionlevel-activate) |
| <span id="catalog-level">**Catalog Level**</span> | カタログ構造のバージョン。Function Level の前提条件、CATMAINT で更新。 | [Function Level](#function-level), [CATMAINT](#catmaint) | [cfg-functionlevel-activate](08-config-procedures.md#cfg-functionlevel-activate) |

## アプリ / アクセスパス（8 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="thread">**Thread**</span> | Db2 内のトランザクション実行単位。各 thread は plan/package・isolation level・auth context を持つ。`-DISPLAY THREAD` で確認。 | [Plan](#plan), [Package](#package), [DBAT](#dbat) |  |
| <span id="applcompat">**Application Compatibility（APPLCOMPAT）**</span> | アプリレベルでサポートする SQL 機能セット（V11R1 / V12R1 / V13R1 / V13R1M501 等）。BIND の `APPLCOMPAT` 句、または動的 SQL の `SET CURRENT APPLICATION COMPATIBILITY` で指定。Function Level と独立に制御可。 | [Function Level](#function-level), [Package](#package) | [cfg-applcompat-set](08-config-procedures.md#cfg-applcompat-set) |
| <span id="access-path">**Access Path**</span> | Optimizer が選んだ SQL の実行戦略（index scan / table scan / merge join / nested loop / hash join 等）。EXPLAIN で確認。 | [EXPLAIN](#explain), [PLAN_TABLE](#plan-table), [Catalog Statistics](#catalog-statistics) |  |
| <span id="explain">**EXPLAIN**</span> | SQL の access path を PLAN_TABLE 等に書出すコマンド。性能チューニングの第一手。 | [Access Path](#access-path), [PLAN_TABLE](#plan-table) |  |
| <span id="plan-table">**PLAN_TABLE**</span> | EXPLAIN の出力先表（`<userid>.PLAN_TABLE`）。METHOD / ACCESSTYPE / ACCESSNAME / MATCHCOLS 等を持つ。 | [EXPLAIN](#explain), [Access Path](#access-path) |  |
| <span id="catalog-statistics">**Catalog Statistics**</span> | テーブル / 索引の統計情報（CARDF, NACTIVE, NLEAF, FIRSTKEYCARDF 等）。RUNSTATS で更新、Optimizer が参照。 | [RUNSTATS](#runstats-cmd), [Access Path](#access-path) | [cfg-runstats-schedule](08-config-procedures.md#cfg-runstats-schedule) |
| <span id="apreuse">**APREUSE**</span> | REBIND 時に既存 access path を温存するオプション（NONE / WARN / ERROR）。RUNSTATS 後の意図しない access path 変更を回避。 | [Access Path](#access-path), [REBIND PACKAGE](#rebind-package-cmd) |  |
| <span id="sqlid">**SQLID（CURRENT SQLID）**</span> | SQL の object qualifier。明示しない場合は user の primary auth ID。`SET CURRENT SQLID` で変更可（権限あれば）。 | [Authid](#authid), [Schema](#schema) |  |

## セキュリティ（6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="authid">**Authid（Authorization ID）**</span> | Db2 の権限主体。RACF user ID と通常一致。primary / secondary（group ID）の区別あり。 | [SQLID](#sqlid), [Trusted Context](#trusted-context) |  |
| <span id="grant-revoke">**GRANT / REVOKE**</span> | 権限付与・取消の SQL ステートメント。表・package・system 権限など細分化。 | [Authid](#authid), [Privilege](#privilege) | [cfg-grant-permission](08-config-procedures.md#cfg-grant-permission) |
| <span id="privilege">**Privilege**</span> | 権限の単位（SELECT/INSERT/UPDATE/DELETE on TABLE、EXECUTE on PACKAGE、BIND など）。 | [GRANT / REVOKE](#grant-revoke) |  |
| <span id="racf-acm">**RACF Access Control Module**</span> | DSNX@XAC により Db2 の権限チェックを RACF にオフロードする仕組み。auth は SAF クラス（DSNADM, DSNDB, DSNTB 等）で集中管理。 | [Authid](#authid), [Privilege](#privilege) | [cfg-racf-acm-setup](08-config-procedures.md#cfg-racf-acm-setup) |
| <span id="rcac">**RCAC（Row and Column Access Control）**</span> | 行レベル・列レベルのアクセス制御。`CREATE PERMISSION` / `CREATE MASK` で定義。GDPR / 個人情報マスキング向け。 | [Privilege](#privilege) |  |
| <span id="audit">**AUDIT TRACE**</span> | 監査用トレース。SMF type 102 として記録、CLASS 1〜10 で対象選択。 | [SMF](#smf), [Trace](#trace) | [cfg-audit-trace](08-config-procedures.md#cfg-audit-trace) |

## v13 新機能（4 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="sqldi">**SQL Data Insights（SQL DI）**</span> | Db2 13 の AI 統合機能（FL501）。表データを自動学習し、`AI_SIMILARITY`、`AI_SEMANTIC_CLUSTER`、`AI_ANALOGY` の組込関数で意味的クエリを実現。 | [Function Level](#function-level), [AI_SIMILARITY](#ai-similarity) | [cfg-sqldi-enable](08-config-procedures.md#cfg-sqldi-enable) |
| <span id="ai-similarity">**AI_SIMILARITY**</span> | SQL DI の組込関数。2 つの値の意味的類似度を 0〜1 で返す。 | [SQL DI](#sqldi) |  |
| <span id="continuous-availability">**Continuous Availability 強化**</span> | Db2 13 の online schema change 拡張、UTS-PBG → UTS-PBR の online conversion、retained-lock 削減等。 | [UTS-PBG](#uts-pbg), [UTS-PBR](#uts-pbr) |  |
| <span id="continuous-delivery">**Continuous Delivery（CD）**</span> | Db2 12 以降のリリースモデル。マイナー機能を Function Level として継続追加（FL500 / FL501 / FL502 ...）。 | [Function Level](#function-level), [APPLCOMPAT](#applcompat) |  |

## 補助（4 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="trace">**Trace**</span> | パフォーマンス・監査・統計用のトレース機構。`-START TRACE`/`-STOP TRACE`、CLASS と IFCID で対象細分化。 | [SMF](#smf), [AUDIT TRACE](#audit) |  |
| <span id="smf">**SMF**</span> | z/OS System Management Facility。Db2 のトレース出力先（type 100/101/102）。 | [Trace](#trace), [AUDIT TRACE](#audit) |  |
| <span id="wlm">**WLM**</span> | z/OS Workload Manager。Db2 の DDF や stored procedure を WLM 制御 SPAS で動かす。 | [DB2SPAS](#db2spas), [DDF](#ddf) |  |
| <span id="collection">**Collection**</span> | PACKAGE の qualifier 第 1 階層。同一業務 PACKAGE をグルーピング、PKLIST で plan に組み込む。 | [Package](#package), [Plan](#plan) |  |

### 補助用語

<span id="recover-cmd">**RECOVER（コマンド）**</span> = [01 章 RECOVER](01-commands.md#recover) を参照。
<span id="bind-plan-cmd">**BIND PLAN（コマンド）**</span> = [01 章 BIND PLAN](01-commands.md#bind-plan) を参照。
<span id="rebind-package-cmd">**REBIND PACKAGE（コマンド）**</span> = [01 章 REBIND PACKAGE](01-commands.md#rebind-package) を参照。
<span id="runstats-cmd">**RUNSTATS（コマンド）**</span> = [01 章 RUNSTATS](01-commands.md#runstats) を参照。
<span id="dsn6fac">**DSN6FAC**</span> = [02 章 DSN6FAC](02-settings.md) を参照（DDF 関連マクロ）。
<span id="dsn6logp">**DSN6LOGP**</span> = [02 章 DSN6LOGP](02-settings.md) を参照（active log マクロ）。
<span id="dsn6arvp">**DSN6ARVP**</span> = [02 章 DSN6ARVP](02-settings.md) を参照（archive log マクロ）。
<span id="dsn6grp">**DSN6GRP**</span> = [02 章 DSN6GRP](02-settings.md) を参照（data sharing マクロ）。
<span id="checkfreq">**CHECKFREQ**</span> = [02 章 CHECKFREQ](02-settings.md) を参照。
<span id="maxkeepd">**MAXKEEPD**</span> = [02 章 MAXKEEPD](02-settings.md) を参照。
<span id="maxdbat">**MAXDBAT**</span> = [02 章 MAXDBAT](02-settings.md) を参照。
<span id="partition">**Partition**</span> = テーブル空間・索引空間の物理分割単位（UTS-PBR で範囲、UTS-PBG で成長指向）。
<span id="restrictive-state">**Restrictive State**</span> = テーブル空間の異常状態（RESTP / CHKP / RECP / COPY / STOP 等）。`-DISPLAY DATABASE RESTRICT` で抽出可能。
<span id="chkp">**CHKP（CHECK pending）**</span> = LOAD / RECOVER 後の整合性未確認状態。`CHECK DATA` で解除。
<span id="index">**Index**</span> = テーブルへのアクセス経路。`CREATE INDEX` で作成、clustering / non-clustering、unique / non-unique、partitioned / non-partitioned の区別あり。

<span id="stored-procedure">**Stored Procedure**</span> = サーバ側で実行する手続き。SQL/PL（native）または COBOL/Java（external）で記述。`CREATE PROCEDURE` で定義。

<span id="deferred-write">**Deferred Write**</span> = バッファプール書出を遅延し、まとめて書く処理。DWQT/VDWQT で trigger 制御。

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
