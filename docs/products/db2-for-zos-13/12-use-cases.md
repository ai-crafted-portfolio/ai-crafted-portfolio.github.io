# ユースケース集

> 特定の作業の手順だけ知りたい読者向け。各ユースケースは独立完結、他に依存せず拾い読み可能。

**収録ユースケース**: 30 件

## カテゴリ別目次

- **DSNZPARM / 起動停止**（4 件）: [uc-dsnzparm-edit](#uc-dsnzparm-edit), [uc-iefssnxx-db2-add](#uc-iefssnxx-db2-add), [uc-irlm-proc-deploy](#uc-irlm-proc-deploy), [uc-db2-startup](#uc-db2-startup)
- **バッファプール / 性能**（4 件）: [uc-bufferpool-monitor](#uc-bufferpool-monitor), [uc-bufferpool-resize](#uc-bufferpool-resize), [uc-explain-analyze](#uc-explain-analyze), [uc-runstats-initial](#uc-runstats-initial)
- **ログ / アーカイブ**（3 件）: [uc-log-active-create](#uc-log-active-create), [uc-log-archive-config](#uc-log-archive-config), [uc-bsds-create](#uc-bsds-create)
- **DDF / 分散**（3 件）: [uc-ddf-enable](#uc-ddf-enable), [uc-ddf-trusted-context-create](#uc-ddf-trusted-context-create), [uc-display-status-check](#uc-display-status-check)
- **データ共用**（2 件）: [uc-cfrm-policy-update](#uc-cfrm-policy-update), [uc-functionlevel-activate](#uc-functionlevel-activate)
- **バインド / アプリ**（3 件）: [uc-bind-package-app](#uc-bind-package-app), [uc-applcompat-update](#uc-applcompat-update), [uc-installation-prereq](#uc-installation-prereq)
- **ユーティリティ**（6 件）: [uc-imagecopy-full](#uc-imagecopy-full), [uc-load-flatfile](#uc-load-flatfile), [uc-reorg-tablespace](#uc-reorg-tablespace), [uc-tablespace-recover](#uc-tablespace-recover), [uc-quiesce-point](#uc-quiesce-point), [uc-check-data](#uc-check-data)
- **セキュリティ**（3 件）: [uc-grant-roles](#uc-grant-roles), [uc-racf-acm-link](#uc-racf-acm-link), [uc-audit-trace-start](#uc-audit-trace-start)
- **スキーマ / オブジェクト**（2 件）: [uc-stogroup-create](#uc-stogroup-create), [uc-tablespace-pbg-create](#uc-tablespace-pbg-create), [uc-table-create](#uc-table-create), [uc-index-create](#uc-index-create), [uc-sqldi-model-train](#uc-sqldi-model-train)

!!! info "本章の品質方針"
    全ユースケースは IBM Db2 13 for z/OS 公式マニュアル記載の事実・手順のみで構成。

---

## DSNZPARM / 起動停止

### DSNZPARM の編集と適用 { #uc-dsnzparm-edit }

**ID**: `uc-dsnzparm-edit` / **カテゴリ**: DSNZPARM

#### 想定状況

CTHREAD / CONDBAT / IRLMRWT などのサブシステムパラメータを変更したい。

#### 前提条件

- SDSNSAMP の編集権限
- DB2 サブシステム再起動の業務時間枠

#### 詳細手順

1. **DSNTIJUZ をバックアップコピー**
   ```
   ISPF 3.4 → DSN.V13R1.SDSNSAMP → DSNTIJUZ → C で複製 → DSNTIJUZ.OLD
   ```
2. **対象マクロセクション編集**
   ```
   DSN6SYSP CTHREAD=400, CONDBAT=20000, MAXDBAT=400
   DSN6SPRM IRLMRWT=60, NUMLKTS=4000
   ```
3. **DSNTIJUZ サブミット**
   ```
   ASMA90 → IEWL → load module 出力（DSN.V13R1.SDSNEXIT(DSNZPARM)）
   ```
4. **再起動**
   ```
   -STOP DB2 MODE(QUIESCE)
   -START DB2 PARM(DSNZPARM)
   ```
5. **確認**
   ```
   -DISPLAY ARCHIVE
   ```

#### 検証

`-DISPLAY GROUP DETAIL` で起動状態 ACTIVE、関連 DISPLAY コマンドで反映確認。

#### バリエーション

緊急時は旧 DSNZPARM ロードモジュール名を `-START DB2 PARM(DSNZPARM_OLD)` で指定し、即時ロールバック。

#### 注意点

DSNZPARM の多くは再起動必須。一部（DSN6FAC 系）は `-STOP DDF` → DSN6FAC 再アセンブル → `-START DDF` で部分反映可能。

#### 関連ユースケース

[uc-db2-startup](#uc-db2-startup), [uc-functionlevel-activate](#uc-functionlevel-activate)

**出典**: S_DB2_Install

---

### IEFSSNxx に Db2 サブシステムを追加 { #uc-iefssnxx-db2-add }

**ID**: `uc-iefssnxx-db2-add` / **カテゴリ**: DSNZPARM

#### 想定状況

z/OS の IEFSSNxx に Db2 サブシステム（SSID と command prefix）を登録する。

#### 詳細手順

1. **IEFSSNxx を ISPF EDIT**
   ```
   SUBSYS SUBNAME(DB2A)
          INITRTN(DSN3INI)
          INITPARM('DSN3EPX,-DSN1,S')
   ```
2. **IPL または `SETSSI ADD,SUBNAME=DB2A,INITRTN=DSN3INI,INITPARM='DSN3EPX,-DSN1,S'` で動的反映**
3. **`D SSI,ALL` で確認**

#### 検証

`D SSI,ALL` 出力に DB2A 表示。

#### 注意点

command prefix（例: `-DSN1`）は他サブシステムと重複しないよう設計。

#### 関連ユースケース

[uc-irlm-proc-deploy](#uc-irlm-proc-deploy), [uc-db2-startup](#uc-db2-startup)

**出典**: S_DB2_Install, S_ZOS_MVS_Cmds

---

### IRLM PROC のデプロイ { #uc-irlm-proc-deploy }

**ID**: `uc-irlm-proc-deploy` / **カテゴリ**: DSNZPARM

#### 想定状況

新規 Db2 サブシステム用に IRLM (Internal Resource Lock Manager) STC を起動可能にする。

#### 詳細手順

1. **DSN.V13R1.SDSNSAMP の DSNTIRLM サンプルを SYS1.PROCLIB（または site PROCLIB）にコピー**
2. **PROC のパラメータ調整**
   ```
   IRLMNM=IRLMA      // IRLM 名
   IRLMID=1          // group 内 ID
   SCOPE=GLOBAL      // データ共用なら GLOBAL、単独なら LOCAL
   IRLMGRP=DSNGRP01  // データ共用 group 名
   MAXCSA=...        // CSA 上限
   ```
3. **`S IRLMPROC` で起動**
4. **`F IRLMPROC,STATUS` で確認**

#### 検証

`F IRLMPROC,STATUS` で connected DB2 の有無、状態 UP。

#### 関連ユースケース

[uc-db2-startup](#uc-db2-startup)

**出典**: S_DB2_Install

---

### Db2 サブシステム起動 / 停止 { #uc-db2-startup }

**ID**: `uc-db2-startup` / **カテゴリ**: DSNZPARM

#### 想定状況

Db2 サブシステムを正規手順で起動・停止する。

#### 詳細手順

1. **起動**
   ```
   -START DB2
   ```
2. **メンテモード起動（特殊運用）**
   ```
   -START DB2 ACCESS(MAINT)
   ```
3. **停止**
   ```
   -STOP DB2 MODE(QUIESCE)
   ```
4. **強制停止（緊急時のみ）**
   ```
   -STOP DB2 MODE(FORCE)
   ```

#### 検証

起動後 `-DISPLAY THREAD(*)`、`-DISPLAY DDF`、`-DISPLAY DATABASE(*) RESTRICT` で異常なし。

#### 注意点

`MODE(FORCE)` は indoubt thread を発生させる可能性あり、再起動時に `-RECOVER INDOUBT` が必要となる場合がある。

#### 関連ユースケース

[uc-display-status-check](#uc-display-status-check)

**出典**: S_DB2_Cmds

---

## バッファプール / 性能

### バッファプール監視 { #uc-bufferpool-monitor }

**ID**: `uc-bufferpool-monitor` / **カテゴリ**: バッファプール

#### 想定状況

性能チューニングのため BP の statistics を取得・観察したい。

#### 詳細手順

1. **DETAIL モードで取得**
   ```
   -DISPLAY BUFFERPOOL(*) DETAIL(*)
   ```
2. **interval モード**
   ```
   -DISPLAY BUFFERPOOL(*) DETAIL(INTERVAL)
   ```
3. **hit ratio 算出**
   - hit_ratio = `1 - (SYNC READ I/O + ASYNC READ I/O) / GETPAGE`
   - 目標 90% 以上

#### 検証

DSNB401I / DSNB420I / DSNB421I の値で BP 別状態確認。

#### 関連ユースケース

[uc-bufferpool-resize](#uc-bufferpool-resize)

**出典**: S_DB2_Cmds, S_DB2_Perf

---

### バッファプール拡張 { #uc-bufferpool-resize }

**ID**: `uc-bufferpool-resize` / **カテゴリ**: バッファプール

#### 想定状況

hit ratio 低下を受け、BP1 の VPSIZE を 20000 → 50000 に拡張したい。

#### 詳細手順

1. **動的変更**
   ```
   -ALTER BUFFERPOOL(BP1) VPSIZE(50000) VPSEQT(40)
   ```
2. **確認**
   ```
   -DISPLAY BUFFERPOOL(BP1) DETAIL
   ```

#### 検証

数日後 hit ratio 改善を確認。

#### 注意点

VPSIZE は DBM1 region 容量を消費。`D ASM` 等で仮想記憶状況確認。

#### 関連ユースケース

[uc-bufferpool-monitor](#uc-bufferpool-monitor)

**出典**: S_DB2_Cmds

---

### EXPLAIN によるアクセスパス分析 { #uc-explain-analyze }

**ID**: `uc-explain-analyze` / **カテゴリ**: 性能

#### 想定状況

性能劣化した SQL の access path を確認、optimizer の判断を理解する。

#### 前提条件

- PLAN_TABLE が存在（DSN.V13R1.SDSNSAMP の DSNTESC でひな形）

#### 詳細手順

1. **EXPLAIN 実行**
   ```sql
   EXPLAIN PLAN SET QUERYNO=100 FOR
     SELECT C1, C2 FROM PRODSCH.TAB1 WHERE C1=1 AND C3>100;
   ```
2. **結果取得**
   ```sql
   SELECT QUERYNO, METHOD, ACCESSTYPE, ACCESSNAME, MATCHCOLS, INDEXONLY
   FROM PLAN_TABLE WHERE QUERYNO=100
   ORDER BY QBLOCKNO, PLANNO, MIXOPSEQ;
   ```
3. **判読**
   - ACCESSTYPE: I=index、R=tablespace scan、IN=in-list index access、M=multi-index、I1=one-fetch index
   - MATCHCOLS: index 利用カラム数（多いほど selective）
   - INDEXONLY=Y: data page アクセス不要（理想形）

#### 検証

PLAN_TABLE の行が問題 SQL の戦略を反映していることを確認。

#### 関連ユースケース

[uc-runstats-initial](#uc-runstats-initial), [uc-index-create](#uc-index-create)

**出典**: S_DB2_AppPgm, S_DB2_Perf

---

### 初回 RUNSTATS { #uc-runstats-initial }

**ID**: `uc-runstats-initial` / **カテゴリ**: 性能

#### 想定状況

新規ロード or 大量更新後の表に RUNSTATS で統計取得する。

#### 詳細手順

1. **JCL 例**
   ```jcl
   //RUNSTATS EXEC PGM=DSNUTILB,PARM='DB2A,RUNST01'
   //SYSPRINT DD SYSOUT=*
   //SYSIN DD *
   RUNSTATS TABLESPACE PRODDB.TS01
            TABLE(ALL) INDEX(ALL)
            SHRLEVEL CHANGE
            HISTORY ALL
   ```
2. **実行・完了確認**
3. **統計確認**
   ```sql
   SELECT NAME, CARDF, NPAGES, NACTIVE, STATSTIME
   FROM SYSIBM.SYSTABLES WHERE NAME='TAB1';
   ```

#### 検証

STATSTIME が直近時刻、CARDF / NACTIVE が現実値に近い。

#### バリエーション

定期化は IBM Workload Automation 等でスケジュール。STATISTICS PROFILE で再現性確保（v12+）。

#### 関連ユースケース

[uc-explain-analyze](#uc-explain-analyze)

**出典**: S_DB2_Util

---

## ログ / アーカイブ

### アクティブログ作成 { #uc-log-active-create }

**ID**: `uc-log-active-create` / **カテゴリ**: ログ

#### 詳細手順

1. **IDCAMS で VSAM linear dataset 作成（COPY1, COPY2 二重化）**
   ```
   DEFINE CLUSTER (NAME(DB2A.LOGCOPY1.DS01) LINEAR
                   VOLUMES(SYSDA1) RECORDS(8000 800) -
                   SHAREOPTIONS(2 3) -
                   CISZ(4096))
          DATA   (NAME(DB2A.LOGCOPY1.DS01.DATA))
   ```
2. **DSNJU003 (CHANGE LOG INVENTORY) で BSDS に登録**
   ```
   NEWLOG DSNAME=DB2A.LOGCOPY1.DS01,COPY1
   NEWLOG DSNAME=DB2A.LOGCOPY2.DS01,COPY2
   ```
3. **DB2 起動 → `-DISPLAY LOG` で確認**

#### 関連ユースケース

[uc-log-archive-config](#uc-log-archive-config), [uc-bsds-create](#uc-bsds-create)

**出典**: S_DB2_Admin

---

### アーカイブログ設定 { #uc-log-archive-config }

**ID**: `uc-log-archive-config` / **カテゴリ**: ログ

#### 詳細手順

1. **DSN6ARVP マクロ更新**
   ```
   DSN6ARVP UNIT=SYSDA, ARCRETN=90, ARCWTOR=NO,
            BLKSIZE=24576, ARCPFX1=DB2A.ARCLG1, ARCPFX2=DB2A.ARCLG2,
            COMPRESS_LOG=YES
   ```
2. **DSNTIJUZ アセンブル → load 出力**
3. **DB2 再起動**
4. **確認: `-DISPLAY ARCHIVE`**

#### 検証

archive log 切替時に対象 dataset が DSN6ARVP で指定した PFX で作成。

#### 関連ユースケース

[uc-log-active-create](#uc-log-active-create), [cfg-log-archive](08-config-procedures.md#cfg-log-archive)

**出典**: S_DB2_Admin

---

### BSDS 作成・二重化 { #uc-bsds-create }

**ID**: `uc-bsds-create` / **カテゴリ**: ログ

#### 詳細手順

1. **IDCAMS で VSAM KSDS 2 つ作成**
   ```
   DEFINE CLUSTER (NAME(DB2A.BSDS01) ...)
   DEFINE CLUSTER (NAME(DB2A.BSDS02) ...)
   ```
2. **DSNJU003 で初期化（CRESTART）**
3. **DSNTIJUZ の MSTR PROC の BSDS DD カードで両方指定**
4. **DB2 起動**

#### 検証

DSNJU004（PRINT LOG MAP）両 BSDS で同一内容。

#### 関連ユースケース

[uc-log-active-create](#uc-log-active-create), [inc-bsds-corrupt](09-incident-procedures.md#inc-bsds-corrupt)

**出典**: S_DB2_Admin

---

## DDF / 分散

### DDF 有効化 { #uc-ddf-enable }

**ID**: `uc-ddf-enable` / **カテゴリ**: DDF

#### 詳細手順

1. **PROFILE.TCPIP に PORT 予約**
   ```
   PORT 446 TCP DB2DIST
   ```
2. **DSNJU003 で BSDS の DDF 設定**
   ```
   DDF LOCATION=LOC1,IPNAME=DB2GEN,PORT=446
   ```
3. **DSN6FAC で CMTSTAT=INACTIVE、IDTHTOIN=120**
4. **DSNTIJUZ → load**
5. **`-START DDF`、`-DISPLAY DDF DETAIL` で確認**

#### 関連ユースケース

[uc-ddf-trusted-context-create](#uc-ddf-trusted-context-create)

**出典**: S_DB2_DDF

---

### Trusted Context / Role の作成 { #uc-ddf-trusted-context-create }

**ID**: `uc-ddf-trusted-context-create` / **カテゴリ**: DDF

#### 詳細手順

1. **ROLE 作成**
   ```sql
   CREATE ROLE APPROLE1;
   GRANT SELECT ON PRODSCH.TAB TO ROLE APPROLE1;
   ```
2. **TRUSTED CONTEXT 作成**
   ```sql
   CREATE TRUSTED CONTEXT APPCTX1
     BASED UPON CONNECTION USING SYSTEM AUTHID 'APPUSER'
     ATTRIBUTES (ADDRESS '10.20.30.40')
     DEFAULT ROLE APPROLE1
     ENABLE;
   ```
3. **検証: 想定 IP からの接続で ROLE が effective**

#### 関連ユースケース

[uc-grant-roles](#uc-grant-roles)

**出典**: S_DB2_Sec

---

### サブシステム状態確認の定型 { #uc-display-status-check }

**ID**: `uc-display-status-check` / **カテゴリ**: DDF

#### 詳細手順

1. **基本状態**
   ```
   -DISPLAY THREAD(*)
   -DISPLAY DDF DETAIL
   -DISPLAY GROUP DETAIL
   -DISPLAY LOG
   -DISPLAY ARCHIVE
   ```
2. **データベース状態**
   ```
   -DISPLAY DATABASE(*) SPACENAM(*) RESTRICT
   ```
3. **バッファプール**
   ```
   -DISPLAY BUFFERPOOL(*)
   ```
4. **ユーティリティ**
   ```
   -DISPLAY UTILITY(*)
   ```

#### 検証

異常状態（RESTP/CHKP/COPY pending、QUEDBAT 増、active log >80%）が出ていない。

#### 関連ユースケース

[uc-db2-startup](#uc-db2-startup)

**出典**: S_DB2_Cmds

---

## データ共用

### CFRM Policy の更新 { #uc-cfrm-policy-update }

**ID**: `uc-cfrm-policy-update` / **カテゴリ**: データ共用

#### 詳細手順

1. **既存 policy 取得**
   ```
   //ADMINPOL EXEC PGM=IXCMIAPU
   DATA TYPE(CFRM) REPORT(YES)
   DEFINE POLICY NAME(POL01) REPLACE(YES)
     ...（GBP、SCA、LOCK1 の SIZE 等）
   ```
2. **policy 更新（GBP サイズ拡張等）**
3. **policy 活性化**
   ```
   SETXCF START,POL,TYPE=CFRM,POLNAME=POL01
   ```
4. **rebuild が必要なら**
   ```
   SETXCF START,REBUILD,STRNAME=DSNDB0G_GBP0
   ```

#### 関連ユースケース

[cfg-datasharing-add-member](08-config-procedures.md#cfg-datasharing-add-member)

**出典**: S_DB2_DataSharing, S_ZOS_Sysplex

---

### Function Level の活性化 { #uc-functionlevel-activate }

**ID**: `uc-functionlevel-activate` / **カテゴリ**: データ共用

#### 詳細手順

1. **現状確認**
   ```
   -DISPLAY GROUP DETAIL
   ```
2. **CATMAINT で catalog level 上昇（必要な場合）**
   ```jcl
   //CATMAINT EXEC PGM=DSNUTILB,PARM='DB2A,CATM01'
   //SYSIN DD *
   CATMAINT UPDATE LEVEL V13R1M501
   ```
3. **Function Level activation**
   ```
   -ACTIVATE FUNCTION LEVEL(V13R1M501)
   ```
4. **確認**
   ```
   -DISPLAY GROUP DETAIL
   ```

#### 注意点

FL500 activate 後は Db2 12 への fallback 不可。事前 image copy + DR 計画必須。

#### 関連ユースケース

[uc-applcompat-update](#uc-applcompat-update)

**出典**: S_DB2_FuncLevels, S_DB2_WhatsNew

---

## バインド / アプリ

### 業務 PACKAGE の BIND { #uc-bind-package-app }

**ID**: `uc-bind-package-app` / **カテゴリ**: バインド

#### 詳細手順

1. **DBRM lib 確認**
2. **BIND PACKAGE**
   ```
   BIND PACKAGE(PRODCOL) MEMBER(APPPGM01)
        LIBRARY('DSN.V13R1.DBRMLIB')
        ACTION(REPLACE) APPLCOMPAT(V13R1)
        ISOLATION(CS) RELEASE(COMMIT)
   ```
3. **必要なら BIND PLAN**
   ```
   BIND PLAN(APPPLAN) PKLIST(PRODCOL.*)
        OWNER(APPADM) QUALIFIER(PRODSCH)
   ```
4. **確認**
   ```sql
   SELECT * FROM SYSIBM.SYSPACKAGE WHERE COLLID='PRODCOL';
   ```

#### 関連ユースケース

[uc-applcompat-update](#uc-applcompat-update)

**出典**: S_DB2_Cmds, S_DB2_AppPgm

---

### APPLCOMPAT 更新 { #uc-applcompat-update }

**ID**: `uc-applcompat-update` / **カテゴリ**: バインド

#### 詳細手順

1. **対象 PACKAGE リスト**
   ```sql
   SELECT COLLID, NAME, APPLCOMPAT FROM SYSIBM.SYSPACKAGE
   WHERE APPLCOMPAT='V12R1';
   ```
2. **REBIND**
   ```
   REBIND PACKAGE(PRODCOL.*)
          APPLCOMPAT(V13R1)
          APREUSE(WARN) APCOMPARE(WARN)
   ```
3. **テスト実行**

#### 注意点

新 APPLCOMPAT で deprecated 機能（旧構文）の SQL があると BIND 時に SQLCODE -8001 等で警告。テストで早期検出。

#### 関連ユースケース

[uc-functionlevel-activate](#uc-functionlevel-activate), [uc-bind-package-app](#uc-bind-package-app)

**出典**: S_DB2_AppPgm

---

### 移行 prerequisite チェック { #uc-installation-prereq }

**ID**: `uc-installation-prereq` / **カテゴリ**: バインド

#### 詳細手順

1. **z/OS バージョン確認**
   ```
   D IPLINFO
   ```
   Db2 13 は z/OS 2.4 以降必須。
2. **Db2 12 の到達 FL 確認**
   ```
   -DISPLAY GROUP DETAIL  （Db2 12 側）
   ```
   M510 到達済みが Db2 13 移行の前提。
3. **prerequisite product（RACF, Language Environment 等）の APAR / PTF 充当**
4. **SMP/E APPLY/ACCEPT 完了**

#### 関連ユースケース

[uc-functionlevel-activate](#uc-functionlevel-activate)

**出典**: S_DB2_Install, S_DB2_Migrate12to13

---

## ユーティリティ

### イメージコピー（FULL） { #uc-imagecopy-full }

**ID**: `uc-imagecopy-full` / **カテゴリ**: ユーティリティ

#### 詳細手順

```jcl
//COPY EXEC PGM=DSNUTILB,PARM='DB2A,COPY01'
//SYSPRINT DD SYSOUT=*
//SYSCOPY1 DD DSN=DB2A.IC.PRODDB.TS01,DISP=(NEW,CATLG),
//             SPACE=(CYL,(100,50))
//SYSIN DD *
COPY TABLESPACE PRODDB.TS01
     SHRLEVEL CHANGE
     COPYDDN(SYSCOPY1)
     FULL YES
```

#### 検証

SYSCOPY 行追加、ICTYPE='F'、DSNAME=image copy データセット。

#### 関連ユースケース

[uc-tablespace-recover](#uc-tablespace-recover), [uc-quiesce-point](#uc-quiesce-point)

**出典**: S_DB2_Util

---

### フラットファイルからの LOAD { #uc-load-flatfile }

**ID**: `uc-load-flatfile` / **カテゴリ**: ユーティリティ

#### 詳細手順

```jcl
//LOAD EXEC PGM=DSNUTILB,PARM='DB2A,LOAD01'
//INFILE DD DSN=USER1.DATA.TXT,DISP=SHR
//SYSIN DD *
LOAD DATA INDDN INFILE
     INTO TABLE PRODSCH.TAB1
     RESUME YES
     LOG NO
     SHRLEVEL NONE
     COPYDDN(SYSCOPY1)
```

**入力ファイルフォーマット**: 列定義に従って固定長 or `POSITION(...) ...` で詳細指定可能。

#### 注意点

`LOG NO` は速いが COPY YES（または事後 COPY）必須、さもなければ TS が COPY pending。

#### 関連ユースケース

[uc-imagecopy-full](#uc-imagecopy-full)

**出典**: S_DB2_Util

---

### REORG TABLESPACE（オンライン） { #uc-reorg-tablespace }

**ID**: `uc-reorg-tablespace` / **カテゴリ**: ユーティリティ

#### 詳細手順

```jcl
//REORG EXEC PGM=DSNUTILB,PARM='DB2A,REORG01'
//SYSIN DD *
REORG TABLESPACE PRODDB.TS01
     SHRLEVEL CHANGE
     LOG NO
     COPYDDN(SYSCOPY1)
     MAXRO 600
     DRAIN_WAIT 60
     RETRY 3
     RETRY_DELAY 30
```

#### 検証

REORG 後 SYSIBM.SYSTABLESPACE.AVGROWLEN / NACTIVE / DBSCANSEQ 改善、PCTFREE 回復。

#### 関連ユースケース

[uc-runstats-initial](#uc-runstats-initial)

**出典**: S_DB2_Util

---

### テーブル空間の RECOVER（時点復旧） { #uc-tablespace-recover }

**ID**: `uc-tablespace-recover` / **カテゴリ**: ユーティリティ

#### 詳細手順

1. **回復点（LRSN or RBA）特定**
   ```sql
   SELECT * FROM SYSIBM.SYSCOPY
   WHERE DBNAME='PRODDB' AND TSNAME='TS01'
   ORDER BY TIMESTAMP DESC FETCH FIRST 5 ROWS ONLY;
   ```
2. **RECOVER JCL**
   ```jcl
   //RECOVER EXEC PGM=DSNUTILB,PARM='DB2A,REC01'
   //SYSIN DD *
   RECOVER TABLESPACE PRODDB.TS01
           TOLOGPOINT X'00000123456789ABCDEF'
   ```
3. **CHECK DATA で整合性検証**
4. **REBUILD INDEX（RECOVER 後 index は REBUILD pending になる）**
   ```
   REBUILD INDEX (ALL) TABLESPACE PRODDB.TS01
   ```

#### 関連ユースケース

[uc-imagecopy-full](#uc-imagecopy-full), [uc-quiesce-point](#uc-quiesce-point), [uc-check-data](#uc-check-data)

**出典**: S_DB2_Util

---

### QUIESCE 取得 { #uc-quiesce-point }

**ID**: `uc-quiesce-point` / **カテゴリ**: ユーティリティ

#### 詳細手順

```jcl
//QUIESCE EXEC PGM=DSNUTILB,PARM='DB2A,QUIESCE01'
//SYSIN DD *
QUIESCE TABLESPACESET
        TABLESPACE PRODDB.TS01
        TABLESPACE PRODDB.TS02
        WRITE YES
```

#### 検証

SYSCOPY に ICTYPE='Q'（QUIESCE point）行が追加。

#### 関連ユースケース

[uc-tablespace-recover](#uc-tablespace-recover)

**出典**: S_DB2_Util

---

### CHECK DATA { #uc-check-data }

**ID**: `uc-check-data` / **カテゴリ**: ユーティリティ

#### 詳細手順

```jcl
//CHKDATA EXEC PGM=DSNUTILB,PARM='DB2A,CHK01'
//SYSIN DD *
CHECK DATA TABLESPACE PRODDB.TS01
           SCOPE PENDING
           DELETE YES FOR EXCEPTION IN PRODSCH.TAB1
                                     USE PRODSCH.TAB1_EXC
```

#### 検証

CHKP 解除、例外行は EXCEPTION TABLE に移動。

#### 関連ユースケース

[uc-tablespace-recover](#uc-tablespace-recover)

**出典**: S_DB2_Util

---

## セキュリティ

### GRANT による権限付与 { #uc-grant-roles }

**ID**: `uc-grant-roles` / **カテゴリ**: セキュリティ

#### 詳細手順

```sql
-- グループ単位で SELECT/INSERT 付与
GRANT SELECT, INSERT ON TABLE PRODSCH.TAB1 TO PRODGRP;

-- パッケージ実行権限
GRANT EXECUTE ON PACKAGE PRODCOL.* TO PRODGRP;

-- 確認
SELECT GRANTEE, GRANTEETYPE, AUTHHOWGOT, ALTERAUTH, DELETEAUTH, INDEXAUTH,
       INSERTAUTH, SELECTAUTH, UPDATEAUTH
FROM SYSIBM.SYSTABAUTH
WHERE TBCREATOR='PRODSCH' AND TTNAME='TAB1';
```

#### 関連ユースケース

[uc-racf-acm-link](#uc-racf-acm-link), [uc-ddf-trusted-context-create](#uc-ddf-trusted-context-create)

**出典**: S_DB2_Sec, S_DB2_SQLRef

---

### RACF Access Control Module 連携 { #uc-racf-acm-link }

**ID**: `uc-racf-acm-link` / **カテゴリ**: セキュリティ

#### 詳細手順

1. **RACF クラス活性化**
   ```
   SETROPTS CLASSACT(DSNADM,DSNDB,DSNTB,DSNCL,DSNSP,DSNSC)
   SETROPTS RACLIST(DSNADM,DSNDB) GENERIC(DSNADM,DSNDB)
   ```
2. **profile 定義**
   ```
   RDEFINE DSNDB DB2A.PRODDB UACC(NONE)
   PERMIT DB2A.PRODDB CLASS(DSNDB) ID(PRODGRP) ACCESS(READ)
   ```
3. **DSNX@XAC を assemble**（DSN.V13R1.SDSNSAMP の DSNXRXAC）
4. **DB2 再起動**

#### 検証

`-DISPLAY` などで authorization が RACF 経由になっている（外部から見ると透過的、Db2 内部で auth check 委譲）。

#### 関連ユースケース

[uc-grant-roles](#uc-grant-roles)

**出典**: S_DB2_RACF, S_DB2_Sec

---

### AUDIT TRACE 起動 { #uc-audit-trace-start }

**ID**: `uc-audit-trace-start` / **カテゴリ**: セキュリティ

#### 詳細手順

1. **対象表に AUDIT 句**
   ```sql
   ALTER TABLE PRODSCH.PERSONAL AUDIT ALL;
   ```
2. **AUDIT TRACE 起動**
   ```
   -START TRACE(AUDIT) DEST(SMF) CLASS(1,2,3,4,5,6,7,8,10)
   ```
3. **`-DISPLAY TRACE(AUDIT)` で active 確認**
4. **SMFPRMxx で type 102 記録対象に**
5. **必要なら DB2 再起動で恒久化（DSNZPARM の DEFAULT TRACE）**

#### 検証

SMF 102 レコードが SMF データセットに蓄積、reporting tool で集計可能。

#### 関連ユースケース

[uc-grant-roles](#uc-grant-roles)

**出典**: S_DB2_Sec

---

## スキーマ / オブジェクト

### STOGROUP 作成 { #uc-stogroup-create }

**ID**: `uc-stogroup-create` / **カテゴリ**: スキーマ

#### 詳細手順

```sql
CREATE STOGROUP STO1
  VOLUMES('SMS')        -- SMS-managed
  VCAT DB2VCAT;
```

または DASD volume 列挙:

```sql
CREATE STOGROUP STO1
  VOLUMES('PROD01','PROD02','PROD03')
  VCAT DB2VCAT;
```

#### 関連ユースケース

[uc-tablespace-pbg-create](#uc-tablespace-pbg-create)

**出典**: S_DB2_SQLRef

---

### UTS-PBG テーブル空間作成 { #uc-tablespace-pbg-create }

**ID**: `uc-tablespace-pbg-create` / **カテゴリ**: スキーマ

#### 詳細手順

```sql
CREATE DATABASE PRODDB STOGROUP STO1 BUFFERPOOL BP4;

CREATE TABLESPACE TS01 IN PRODDB
  USING STOGROUP STO1
  PRIQTY 7200 SECQTY 7200
  BUFFERPOOL BP4
  LOCKSIZE ANY  LOCKMAX SYSTEM
  PCTFREE 5  FREEPAGE 0
  COMPRESS YES
  MAXPARTITIONS 256;  -- UTS-PBG (Partition By Growth)
```

#### 関連ユースケース

[uc-stogroup-create](#uc-stogroup-create), [uc-table-create](#uc-table-create)

**出典**: S_DB2_Admin, S_DB2_SQLRef

---

### テーブル作成 { #uc-table-create }

**ID**: `uc-table-create` / **カテゴリ**: スキーマ

#### 詳細手順

```sql
CREATE TABLE PRODSCH.TAB1 (
  C1 INTEGER NOT NULL,
  C2 VARCHAR(50) NOT NULL,
  C3 DECIMAL(15,2),
  C4 TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (C1)
) IN PRODDB.TS01;
```

#### 関連ユースケース

[uc-tablespace-pbg-create](#uc-tablespace-pbg-create), [uc-index-create](#uc-index-create)

**出典**: S_DB2_SQLRef

---

### 索引作成 { #uc-index-create }

**ID**: `uc-index-create` / **カテゴリ**: スキーマ

#### 詳細手順

```sql
CREATE INDEX PRODSCH.IX_TAB1_C2
  ON PRODSCH.TAB1 (C2 ASC)
  USING STOGROUP STO1
  PRIQTY 720 SECQTY 720
  BUFFERPOOL BP3;
```

#### 検証

```sql
SELECT NAME, TBNAME, UNIQUERULE, COLCOUNT, FIRSTKEYCARDF
FROM SYSIBM.SYSINDEXES
WHERE TBNAME='TAB1';
```

#### 注意点

clustering index（先に CREATE した unique index、または `CLUSTER` 句指定の index）が物理順を決定。

#### 関連ユースケース

[uc-runstats-initial](#uc-runstats-initial), [uc-explain-analyze](#uc-explain-analyze)

**出典**: S_DB2_SQLRef

---

### SQL DI モデル学習 { #uc-sqldi-model-train }

**ID**: `uc-sqldi-model-train` / **カテゴリ**: スキーマ

#### 想定状況

Db2 13 FL501 で SQL Data Insights を有効化、業務表 PRODSCH.CUSTOMER に対して semantic similarity モデルを学習させる。

#### 前提条件

- Function Level 501 以上活性
- SQL DI 用環境（Db2 Admin Tool / Web UI）
- 対象表に学習対象列の存在

#### 詳細手順

1. **FL501 活性確認**
   ```
   -DISPLAY GROUP DETAIL
   ```
2. **SQL DI UI で対象表選択 → 学習対象列指定**
3. **学習開始（裏で SYSAIDB / SYSAIOBJECTS 表が更新される）**
4. **モデル状態確認**
   ```sql
   SELECT * FROM SYSIBM.SYSAIOBJECTS WHERE SCHEMA='PRODSCH' AND NAME='CUSTOMER';
   ```
5. **AI 関数で動作確認**
   ```sql
   SELECT NAME, AI_SIMILARITY(CITY, 'TOKYO') AS SIM
   FROM PRODSCH.CUSTOMER
   ORDER BY SIM DESC FETCH FIRST 10 ROWS ONLY;
   ```

#### 検証

`AI_SIMILARITY` が SQLCODE 0 で結果を返す（-20471 / -20472 が出たらモデル未準備）。

#### 注意点

学習は CPU 集約的、本番影響を考慮した時間枠で実施。

#### 関連ユースケース

[uc-functionlevel-activate](#uc-functionlevel-activate)

**出典**: S_DB2_SQLDI

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
