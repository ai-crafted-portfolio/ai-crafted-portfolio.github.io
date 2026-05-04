# コマンド一覧

> 掲載：**45 件（オペレータ/JES2/TSO/SDSF/JCL/USS/SMP/E）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

z/OS 管理者・オペレータが日常的に使う定番コマンドを厳選。

## 目次

- **オペレータ**（10 件）: [`D A,L`](#d-al), [`D R`](#d-r), [`D IPLINFO`](#d-iplinfo), [`D PARMLIB`](#d-parmlib), [`D ASM`](#d-asm), [`D U,,,nnnn,n`](#d-unnnnn), [`V ONLINE / V OFFLINE`](#v-online---v-offline), [`S <procname>`](#s-procname), [`P <jobname> / C <jobname>`](#p-jobname---c-jobname), [`F <jobname>,<modify cmd>`](#f-jobnamemodify-cmd)
- **JES2**（8 件）: [`$D ACTIVE`](#d-active), [`$D Q`](#d-q), [`$D SPL`](#d-spl), [`$P J<n>`](#p-jn), [`$T A<initiator>`](#t-ainitiator), [`$D INITS`](#d-inits), [`$T NODE`](#t-node), [`$E J<n>`](#e-jn)
- **TSO/E**（8 件）: [`LOGON`](#logon), [`LISTC / LISTCAT`](#listc---listcat), [`LISTD / LISTDS`](#listd---listds), [`ALLOCATE / ALLOC`](#allocate---alloc), [`SUBMIT`](#submit), [`ISPF / PDF`](#ispf---pdf), [`EXEC <rexx>`](#exec-rexx), [`RECEIVE`](#receive)
- **SDSF**（5 件）: [`SDSF DA`](#sdsf-da), [`SDSF ST`](#sdsf-st), [`SDSF LOG`](#sdsf-log), [`SDSF /<command>`](#sdsf--command), [`SDSF SE / SDSF JC`](#sdsf-se---sdsf-jc)
- **JCL**（5 件）: [`JOB statement`](#job-statement), [`EXEC statement`](#exec-statement), [`DD statement`](#dd-statement), [`JES2 control card`](#jes2-control-card), [`INCLUDE statement`](#include-statement)
- **USS**（5 件）: [`OMVS`](#omvs), [`ls / cp / mv / rm（USS）`](#ls---cp---mv---rm（uss）), [`bpxbatch / bpxbatsl`](#bpxbatch---bpxbatsl), [`su / id（USS）`](#su---id（uss）), [`df / mount（USS）`](#df---mount（uss）)
- **SMP/E**（4 件）: [`SMP/E APPLY`](#smp-e-apply), [`SMP/E ACCEPT`](#smp-e-accept), [`SMP/E RESTORE`](#smp-e-restore), [`SMP/E LIST`](#smp-e-list)

---

## オペレータ（10 件）

### `D A,L` { #d-al }

**用途**: アクティブな全アドレス空間（ジョブ・STC・TSU）を表示。

**構文**:

```
D A,L  または  DISPLAY A,LIST
```

**典型例**:

```
D A,L
（出力）IEE114I 12.30.45 ACTIVITY 999
 JOBS    M/S    TS USERS    SYSAS   INITS   ACTIVE/MAX
   45    103         12       30      18      45/200
```

**注意点**: システムの稼働状況把握の基本コマンド。SDSF DA パネルでも同等情報が見られる。

**関連手順**: [inc-system-hung](09-incident-procedures.md#inc-system-hung)

**関連用語**: Address Space, STC

**出典**: S_ZOS_MVS_Cmds

---

### `D R` { #d-r }

**用途**: 未応答の WTOR メッセージ一覧を表示。

**構文**:

```
D R[,L]  または  DISPLAY R
```

**典型例**:

```
D R,L
（出力）IEE112I 12.30.50 PENDING REQUESTS 999
 RM=0      IM=0      CEM=0     EM=2     RU=0
  ID:0001  R, IEC502E REPLY ...
```

**注意点**: WTOR は応答するまでシステムが特定処理で待ち状態になる。R 0001,U 等で応答。

**関連手順**: [inc-wtor-response](09-incident-procedures.md#inc-wtor-response)

**関連用語**: WTOR

**出典**: S_ZOS_MVS_Cmds

---

### `D IPLINFO` { #d-iplinfo }

**用途**: IPL 関連情報（IPL 日時、IODF、PARMLIB SUFFIX 等）を表示。

**構文**:

```
D IPLINFO
```

**典型例**:

```
D IPLINFO
（出力）IEE254I 12.31.00 IPLINFO DISPLAY 999
 SYSTEM IPLED AT 06.30.15 ON 05/04/2026
 RELEASE z/OS 03.01.00 ...
```

**注意点**: システムの起動時刻、IODF、SYSRES、PARMLIB 構成を一目で確認。

**関連手順**: [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update)

**関連用語**: IPL, NIP

**出典**: S_ZOS_MVS_Cmds

---

### `D PARMLIB` { #d-parmlib }

**用途**: 現在使用中の PARMLIB データセットチェーンを表示。

**構文**:

```
D PARMLIB
```

**典型例**:

```
D PARMLIB
（出力）IEE251I 12.32.00 PARMLIB DISPLAY 999
 PARMLIB DATA SETS
  ENTRY FLAGS  VOLUME  DATA SET
   1     S     SYSRES  SYS1.PARMLIB
```

**注意点**: LOADxx で定義された PARMLIB チェーンの順序確認。

**関連手順**: [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update)

**関連用語**: PARMLIB, LOADxx

**出典**: S_ZOS_MVS_Cmds

---

### `D ASM` { #d-asm }

**用途**: ページデータセット（PLPA, COMMON, LOCAL）の使用率表示。

**構文**:

```
D ASM
```

**典型例**:

```
D ASM
（出力）IEE200I 12.32.30
 TYPE     FULL  STAT  DEV   DATASET NAME
 PLPA      30%  OK   1234  SYS1.PLPA.PAGE
```

**注意点**: 85%超でページング枯渇近、要拡張または LOCAL 追加。

**関連手順**: [inc-paging-shortage](09-incident-procedures.md#inc-paging-shortage)

**関連用語**: Auxiliary Storage, PLPA

**出典**: S_ZOS_MVS_Cmds

---

### `D U,,,nnnn,n` { #d-unnnnn }

**用途**: デバイス（DASD/Tape/UR）の状態表示。

**構文**:

```
D U,,,<addr>,<count>  または  D U,DASD,ONLINE
```

**典型例**:

```
D U,,,8000,4
（出力）UNIT TYPE STATUS    VOLSER  VOLSTATE   SS
 8000 3390 O          USR000  PRIV/RSDNT   0
```

**注意点**: オフライン化や VARY 前後の状態確認に使用。

**関連手順**: `cfg-device-vary`

**関連用語**: DASD, UCB

**出典**: S_ZOS_MVS_Cmds

---

### `V ONLINE / V OFFLINE` { #v-online---v-offline }

**用途**: デバイスをオンライン/オフライン化。

**構文**:

```
V <addr>,ONLINE / V <addr>,OFFLINE
```

**典型例**:

```
V 8001,OFFLINE
（応答）IEE302I 8001  OFFLINE
```

**注意点**: DASD オフライン化はマウント済データセット使用中のジョブに影響。事前に DC で確認。

**関連手順**: `cfg-device-vary`

**関連用語**: DASD

**出典**: S_ZOS_MVS_Cmds

---

### `S <procname>` { #s-procname }

**用途**: Started Task（STC）を起動。

**構文**:

```
S <procname>[,JOBNAME=<name>][,parm=value]
```

**典型例**:

```
S TCPIP
（応答）$HASP100 TCPIP   ON STCINRDR
        IEF695I  START TCPIP   WITH JOBNAME TCPIP IS ASSIGNED ...
```

**注意点**: PROCLIB 配下の <procname>.proc を実行。サブシステム起動の標準操作。

**関連手順**: [cfg-stc-startup](08-config-procedures.md#cfg-stc-startup)

**関連用語**: STC, PROCLIB

**出典**: S_ZOS_MVS_Cmds

---

### `P <jobname> / C <jobname>` { #p-jobname---c-jobname }

**用途**: STC を停止（P=正常、C=強制キャンセル）。

**構文**:

```
P <jobname>  または  C <jobname>[,DUMP][,A=<asid>]
```

**典型例**:

```
P TCPIP
（応答）$HASP200 TCPIP    ENDED
        IEF404I TCPIP    - ENDED
```

**注意点**: P で正常終了試行、効かなければ C で強制。-DUMP で SVC dump 取得。

**関連手順**: [inc-stc-hung](09-incident-procedures.md#inc-stc-hung)

**関連用語**: STC

**出典**: S_ZOS_MVS_Cmds

---

### `F <jobname>,<modify cmd>` { #f-jobnamemodify-cmd }

**用途**: STC に modify コマンドを送る（実行時パラメータ変更）。

**構文**:

```
F <jobname>,<modify cmd>
```

**典型例**:

```
F TCPIP,REFRESH
F JES2,$DI
```

**注意点**: サブシステム独自の modify コマンドを送信。製品ごとに対応コマンド異なる。

**関連手順**: [cfg-stc-startup](08-config-procedures.md#cfg-stc-startup)

**関連用語**: STC

**出典**: S_ZOS_MVS_Cmds

---

## JES2（8 件）

### `$D ACTIVE` { #d-active }

**用途**: JES2 のアクティブジョブ一覧を表示。

**構文**:

```
$D A[CTIVE]  または  $DA
```

**典型例**:

```
$DA
（出力）$HASP608 JOB123    EXECUTING WITH HASP MEMBER=...
```

**注意点**: JES2 環境での実行中ジョブ確認。SDSF DA パネルがより便利。

**関連手順**: [inc-jes2-spool-full](09-incident-procedures.md#inc-jes2-spool-full)

**関連用語**: JES2

**出典**: S_ZOS_JES2_Cmds

---

### `$D Q` { #d-q }

**用途**: JES2 ジョブキューの状態（INPUT, EXEC, OUTPUT, HARDCOPY）表示。

**構文**:

```
$D Q[,<class>]
```

**典型例**:

```
$D Q
（出力）$HASP893 SPOOL   N=4   T=DASD   ALLOCATED
        $HASP646 23.4 PERCENT SPOOL UTILIZATION
```

**注意点**: スプール使用率 %SPOOL を確認。85%超で警戒、95%超で SHORT。

**関連手順**: [inc-jes2-spool-full](09-incident-procedures.md#inc-jes2-spool-full)

**関連用語**: JES2 SPOOL

**出典**: S_ZOS_JES2_Cmds

---

### `$D SPL` { #d-spl }

**用途**: JES2 スプールデータセット使用率表示。

**構文**:

```
$D SPL[,<volser>]
```

**典型例**:

```
$D SPL
（出力）$HASP893 VOLUME(SPOOL1) STATUS=ACTIVE,PERCENT=23
```

**注意点**: $D Q より詳細な volser 別使用率。

**関連手順**: [inc-jes2-spool-full](09-incident-procedures.md#inc-jes2-spool-full)

**関連用語**: JES2 SPOOL

**出典**: S_ZOS_JES2_Cmds

---

### `$P J<n>` { #p-jn }

**用途**: ジョブを JES2 から削除（パージ）。

**構文**:

```
$P J<jobnum>  または  $PJ<jobnum>
```

**典型例**:

```
$P J12345
（応答）$HASP890 JOB(JOB12345) PURGED
```

**注意点**: 実行中ジョブには $C J<n> で先にキャンセル。

**関連手順**: [inc-jes2-spool-full](09-incident-procedures.md#inc-jes2-spool-full)

**関連用語**: JES2

**出典**: S_ZOS_JES2_Cmds

---

### `$T A<initiator>` { #t-ainitiator }

**用途**: JES2 イニシエータの定義変更（CLASS 等）。

**構文**:

```
$T A<n>,CLASS=<classes>
```

**典型例**:

```
$T A1,CLASS=AB
（応答）$HASP880 A1 ACTIVE A=12345 ...
```

**注意点**: 起動済イニシエータのジョブクラス変更。$DA で現状確認。

**関連手順**: [cfg-jes2-init](08-config-procedures.md#cfg-jes2-init)

**関連用語**: JES2 Initiator

**出典**: S_ZOS_JES2_Cmds

---

### `$D INITS` { #d-inits }

**用途**: JES2 イニシエータ一覧表示。

**構文**:

```
$D INITS  または  $DI
```

**典型例**:

```
$DI
（出力）$HASP800 INIT(1) STATUS=ACTIVE,CLASS=A,JOBNAME=PROD1
```

**注意点**: 各イニシエータの状態・受け持ちクラス・現ジョブ確認。

**関連手順**: [cfg-jes2-init](08-config-procedures.md#cfg-jes2-init)

**関連用語**: JES2 Initiator

**出典**: S_ZOS_JES2_Cmds

---

### `$T NODE` { #t-node }

**用途**: NJE（Network Job Entry）ノード定義変更。

**構文**:

```
$T NODE(<node>),<parm>=<value>
```

**典型例**:

```
$T NODE(N5),NETSRV=NETSRV1
```

**注意点**: NJE で他システムへジョブ転送するための設定。

**関連手順**: [cfg-jes2-nje](08-config-procedures.md#cfg-jes2-nje)

**関連用語**: NJE

**出典**: S_ZOS_JES2_Cmds

---

### `$E J<n>` { #e-jn }

**用途**: ジョブを再起動（restart）する。

**構文**:

```
$E J<jobnum>
```

**典型例**:

```
$E J12345
（応答）$HASP890 JOB(JOB12345) RESTARTING ...
```

**注意点**: Failed/canceled ジョブの再投入。CKPT がある場合はそこから再開。

**関連手順**: [inc-job-fail](09-incident-procedures.md#inc-job-fail)

**関連用語**: JES2

**出典**: S_ZOS_JES2_Cmds

---

## TSO/E（8 件）

### `LOGON` { #logon }

**用途**: TSO/E にログオン。

**構文**:

```
LOGON <userid>[/<password>][/NEW_PWD][PROC(<proc>)]
```

**典型例**:

```
LOGON USER01
（応答）IKJ56455I USER01  LOGON IN PROGRESS AT 12.40.00 ON 05/04/2026
```

**注意点**: VTAM 経由 / TN3270 経由でアクセス。LOGON PROC で初期化スクリプト実行。

**関連手順**: [cfg-tso-logon](08-config-procedures.md#cfg-tso-logon)

**関連用語**: TSO/E, LOGON

**出典**: S_ZOS_TSO_Cmds

---

### `LISTC / LISTCAT` { #listc---listcat }

**用途**: カタログ内のデータセット一覧を表示。

**構文**:

```
LISTC LEVEL(<hlq>) [ALL | ENTRIES(<dsn>)]
```

**典型例**:

```
LISTC LEVEL(USER01) ALL
（出力）IDC0010I LISTCAT COMMAND IS COMPLETE
         (各データセットの詳細)
```

**注意点**: LEVEL でデータセット名階層プレフィックス指定。VSAM の場合は CLUSTER 構造表示。

**関連手順**: [cfg-dataset-mgmt](08-config-procedures.md#cfg-dataset-mgmt)

**関連用語**: Catalog, Dataset

**出典**: S_ZOS_TSO_Cmds

---

### `LISTD / LISTDS` { #listd---listds }

**用途**: データセット属性表示（DCB、SMS Class 等）。

**構文**:

```
LISTDS <dsn> [HISTORY | LABEL | ALL]
```

**典型例**:

```
LISTDS 'USER01.JCL.LIB' ALL
（出力）DSORG=PO RECFM=FB LRECL=80 BLKSIZE=27920
```

**注意点**: クォート無しは USERID 補完、クォート有りは絶対指定。

**関連手順**: [cfg-dataset-mgmt](08-config-procedures.md#cfg-dataset-mgmt)

**関連用語**: Dataset, DCB

**出典**: S_ZOS_TSO_Cmds

---

### `ALLOCATE / ALLOC` { #allocate---alloc }

**用途**: データセットを動的アロケーションで割り当て。

**構文**:

```
ALLOC F(<ddname>) DA(<dsn>) [NEW|OLD|SHR|MOD] [SP(<n>) ...]
```

**典型例**:

```
ALLOC F(SYSPRINT) DA(*)
ALLOC F(SYSIN) DA('USER01.JCL(JOB1)') SHR
```

**注意点**: TSO セッション中の動的割り当て。バッチ JCL の DD 文相当。

**関連手順**: [cfg-dataset-mgmt](08-config-procedures.md#cfg-dataset-mgmt)

**関連用語**: Dynamic Allocation

**出典**: S_ZOS_TSO_Cmds

---

### `SUBMIT` { #submit }

**用途**: JCL をサブミット（バッチジョブ実行）。

**構文**:

```
SUB '<dsn>'[(<member>)]  または  SUB *
```

**典型例**:

```
SUB 'USER01.JCL(JOB1)'
（応答）IKJ56250I JOB JOB1(JOB12345) SUBMITTED
```

**注意点**: ISPF EDIT で SUB コマンドも同等。実行状況は SDSF ST で確認。

**関連手順**: `cfg-job-submit`

**関連用語**: JCL, JES2

**出典**: S_ZOS_TSO_Cmds

---

### `ISPF / PDF` { #ispf---pdf }

**用途**: ISPF（PDF: Program Development Facility）を起動。

**構文**:

```
ISPF  または  PDF
```

**典型例**:

```
ISPF
（ISPF パネルが起動、メニュー: 0=Settings, 1=View, 2=Edit, 3=Utilities, ...）
```

**注意点**: z/OS で最も使われる対話型インターフェース。LOGON PROC で自動起動の場合多い。

**関連手順**: [cfg-tso-logon](08-config-procedures.md#cfg-tso-logon)

**関連用語**: ISPF

**出典**: S_ZOS_TSO_Cmds

---

### `EXEC <rexx>` { #exec-rexx }

**用途**: REXX または CLIST を実行。

**構文**:

```
EXEC '<dsn>(<member>)' '<args>'  または  %<rexx>
```

**典型例**:

```
%MYREXX
EXEC 'USER01.REXX(MYREXX)' 'ARG1 ARG2'
```

**注意点**: % プレフィックスで SYSEXEC/SYSPROC 検索。',' で複数引数渡し可。

**関連手順**: [cfg-rexx-script](08-config-procedures.md#cfg-rexx-script)

**関連用語**: REXX, CLIST

**出典**: S_ZOS_TSO_Cmds

---

### `RECEIVE` { #receive }

**用途**: 他ユーザから送信された受信箱（INMRC1 等）データセットを取り込み。

**構文**:

```
RECEIVE
```

**典型例**:

```
RECEIVE
（応答）INMR901I Dataset 'USER02.SOMEDATA' from USER02 on SYSA
INMR906A Enter restore parameters or DELETE or END +
```

**注意点**: TSO TRANSMIT で送られたファイルの取り込み。

**関連用語**: TRANSMIT, RECEIVE

**出典**: S_ZOS_TSO_Cmds

---

## SDSF（5 件）

### `SDSF DA` { #sdsf-da }

**用途**: Display Active = アクティブな全アドレス空間表示パネル。

**構文**:

```
DA  （SDSF 内コマンド）
```

**典型例**:

```
==> DA
（パネル）NP   JOBNAME  StepName  ProcStep  JobID    Owner   ...
     PROD1    STEP01    PROC1     JOB12345 USER01
```

**注意点**: z/OS オペレータ・運用者の最頻使用パネル。プレフィックス S（select）でジョブ詳細。

**関連手順**: [inc-system-hung](09-incident-procedures.md#inc-system-hung)

**関連用語**: SDSF

**出典**: S_ZOS_SDSF

---

### `SDSF ST` { #sdsf-st }

**用途**: Status of jobs = JES2 キュー上の全ジョブ表示。

**構文**:

```
ST  （SDSF 内コマンド）
```

**典型例**:

```
==> ST
（パネル）NP   JOBNAME  JobID    Owner    Prty Queue   ...
     PROD1    JOB12345 USER01    8   ACTIVE
```

**注意点**: ジョブ状態（ACTIVE/INPUT/OUTPUT/HARDCOPY）を一覧。Q カラムで PURGE などコマンド入力可。

**関連手順**: [inc-job-fail](09-incident-procedures.md#inc-job-fail)

**関連用語**: SDSF, JES2

**出典**: S_ZOS_SDSF

---

### `SDSF LOG` { #sdsf-log }

**用途**: SYSLOG / OPERLOG の表示。

**構文**:

```
LOG  または  LOG O  （O = OPERLOG）
```

**典型例**:

```
==> LOG
（パネル）SYSLOG  --  CONSOLE STATUS--  ROW 1
IEE612I CN=SDSFA   DEVNUM=...
```

**注意点**: SDSF 経由でシステムメッセージ閲覧。FIND コマンドで検索。

**関連手順**: [inc-syslog-investigation](09-incident-procedures.md#inc-syslog-investigation)

**関連用語**: SYSLOG, OPERLOG

**出典**: S_ZOS_SDSF

---

### `SDSF /<command>` { #sdsf--command }

**用途**: オペレータコマンド発行（権限あれば）。

**構文**:

```
/<MVS command>  （SDSF 内）
```

**典型例**:

```
==> /D A,L
（応答）IEE114I 13.00.00 ACTIVITY 999 ...
```

**注意点**: SDSF コマンド行で / プレフィックスで MVS コマンド発行。RACF 権限要。

**関連用語**: SDSF

**出典**: S_ZOS_SDSF

---

### `SDSF SE / SDSF JC` { #sdsf-se---sdsf-jc }

**用途**: SE = Scheduler Environment, JC = Job Class 表示。

**構文**:

```
SE / JC  （SDSF 内コマンド）
```

**典型例**:

```
==> JC
（パネル）JOBCLASS  HOLD  RESTART  WLMSCHENV  MAXJOB ...
```

**注意点**: JES2 ジョブクラス・スケジューラ環境の状態確認。

**関連手順**: [cfg-jes2-init](08-config-procedures.md#cfg-jes2-init)

**関連用語**: JES2 Class, WLM SCHENV

**出典**: S_ZOS_SDSF

---

## JCL（5 件）

### `JOB statement` { #job-statement }

**用途**: ジョブの開始・属性指定。

**構文**:

```
//<jobname> JOB <accounting>,'<programmer>',<options>
```

**典型例**:

```
//PROD1    JOB (ACCT01),'USER01',
//             CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1),NOTIFY=&SYSUID
```

**注意点**: CLASS=ジョブクラス（JES2 INITDECK 定義）、MSGCLASS=出力クラス（X=HOLD）、NOTIFY=完了通知先。

**関連手順**: `cfg-job-submit`

**関連用語**: JCL, JES2 Class

**出典**: S_ZOS_JCL_Ref

---

### `EXEC statement` { #exec-statement }

**用途**: 実行プログラム or PROCの指定。

**構文**:

```
//<stepname> EXEC PGM=<program>[,PARM='<parm>'][,COND=...]
//<stepname> EXEC <procname>
```

**典型例**:

```
//STEP01   EXEC PGM=IEFBR14
//STEP02   EXEC PROC=MYPROC,PARM='HELLO'
```

**注意点**: PGM=直接プログラム実行 or PROC=PROCLIB 内 catalogued procedure 呼び出し。

**関連手順**: `cfg-job-submit`

**関連用語**: JCL, PROCLIB

**出典**: S_ZOS_JCL_Ref

---

### `DD statement` { #dd-statement }

**用途**: データセット定義（割り当て）。

**構文**:

```
//<ddname> DD DSN=<dsn>,DISP=(<status>,<normal>,<abnormal>),...
```

**典型例**:

```
//SYSIN    DD *
INPUT DATA
/*
//SYSOUT   DD SYSOUT=*
//OUTFILE  DD DSN=USER01.OUTPUT,DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(10,5)),DCB=(RECFM=FB,LRECL=80,BLKSIZE=27920)
```

**注意点**: z/OS で最重要・最頻出 JCL ステートメント。DISP=(現状,正常時,異常時) の 3 タプル。

**関連手順**: [cfg-dataset-mgmt](08-config-procedures.md#cfg-dataset-mgmt)

**関連用語**: Dataset, DCB, SMS

**出典**: S_ZOS_JCL_Ref

---

### `JES2 control card` { #jes2-control-card }

**用途**: JES2 への指示（ROUTE/JOBPARM/OUTPUT 等）。

**構文**:

```
/*<command> <parameters>
```

**典型例**:

```
/*JOBPARM SYSAFF=SY1
/*ROUTE PRINT NODE1.PRT01
/*XEQ SY2
```

**注意点**: ジョブを特定システムで実行 (SYSAFF/XEQ)、出力先制御 (ROUTE)。

**関連手順**: `cfg-job-submit`

**関連用語**: JES2

**出典**: S_ZOS_JCL_Ref

---

### `INCLUDE statement` { #include-statement }

**用途**: JCL の一部を別データセットからインクルード。

**構文**:

```
//<name> INCLUDE MEMBER=<member>
```

**典型例**:

```
//STDLIB   JCLLIB ORDER=(USER01.PROCLIB)
//         INCLUDE MEMBER=COMMONDD
```

**注意点**: JCLLIB で検索パス指定後、INCLUDE で再利用可能 JCL 部品を取り込み。

**関連手順**: `cfg-job-submit`

**関連用語**: JCL

**出典**: S_ZOS_JCL_Ref

---

## USS（5 件）

### `OMVS` { #omvs }

**用途**: TSO から USS シェル（OMVS）に入る。

**構文**:

```
OMVS
```

**典型例**:

```
TSO> OMVS
（USS シェルプロンプトに切り替わる）
$ uname -a
z/OS USERX01 03.01 03 00 8561
```

**注意点**: Ctrl+T で TSO/USS 切替（事前に TSO の SET PROFILE 設定必要）。EXIT で TSO に戻る。

**関連手順**: `cfg-uss-setup`

**関連用語**: USS, OMVS

**出典**: S_ZOS_USS

---

### `ls / cp / mv / rm（USS）` { #ls---cp---mv---rm（uss） }

**用途**: USS の標準 UNIX コマンド（POSIX 互換）。

**構文**:

```
ls -la
cp <src> <dest>
mv <src> <dest>
rm <file>
```

**典型例**:

```
$ ls -la /etc
$ cp /tmp/file1 /u/user01/file1
$ rm /tmp/temp.txt
```

**注意点**: z/OS USS は POSIX 準拠の UNIX 環境。Linux/AIX 同等のシェル操作可能。

**関連手順**: `cfg-uss-setup`

**関連用語**: USS, HFS, zFS

**出典**: S_ZOS_USS

---

### `bpxbatch / bpxbatsl` { #bpxbatch---bpxbatsl }

**用途**: USS シェルスクリプトを JES2 バッチジョブとして実行。

**構文**:

```
//<step> EXEC PGM=BPXBATCH,PARM='SH /u/user01/script.sh'
```

**典型例**:

```
//STEP1 EXEC PGM=BPXBATCH,PARM='SH /usr/lpp/myapp/run.sh'
//STDOUT DD SYSOUT=*
//STDERR DD SYSOUT=*
```

**注意点**: BPXBATCH は SH or PGM サブモードで USS から起動。STDOUT/STDERR の DD 必要。

**関連手順**: `cfg-uss-batch`

**関連用語**: USS, BPXBATCH

**出典**: S_ZOS_USS

---

### `su / id（USS）` { #su---id（uss） }

**用途**: ユーザ切替・ID 確認。

**構文**:

```
su  または  su -  または  id
```

**典型例**:

```
$ id
uid=500(USER01) gid=10(STAFF) groups=10(STAFF),100(GRP1)
$ su -
# id
uid=0(BPXROOT) gid=0(SYS1)
```

**注意点**: USS の uid/gid は RACF OMVS セグメントから取得。su には RACF SURROGAT 権限要。

**関連手順**: `cfg-uss-setup`

**関連用語**: USS, OMVS Segment

**出典**: S_ZOS_USS

---

### `df / mount（USS）` { #df---mount（uss） }

**用途**: USS ファイルシステム使用率・マウント表示。

**構文**:

```
df -k  または  /usr/sbin/mount
```

**典型例**:

```
$ df -k
Mounted on Filesystem      Avail/Total  Files  Status
/         OMVS.ROOT.ZFS    100000/200000   ...   Available
```

**注意点**: HFS / zFS / NFS マウント表示。BPXPRMxx 設定との連動。

**関連手順**: [cfg-uss-fs](08-config-procedures.md#cfg-uss-fs)

**関連用語**: HFS, zFS, BPXPRMxx

**出典**: S_ZOS_USS

---

## SMP/E（4 件）

### `SMP/E APPLY` { #smp-e-apply }

**用途**: PTF を適用（apply）。SMP/E メンテナンスの中核操作。

**構文**:

```
//STEP EXEC PGM=GIMSMP
//SMPCNTL DD *
SET BDY(<target zone>).
APPLY S(<sysmod>) [CHECK].
```

**典型例**:

```
SET BDY(MVST100). APPLY S(UA12345,UA12346) BYPASS(HOLDSYS) CHECK.
```

**注意点**: CHECK で事前検証、削除して本適用。BYPASS(HOLDSYS) は ++HOLD 警告無視（要慎重判断）。

**関連手順**: `cfg-smpe-apply`

**関連用語**: SMP/E, PTF, SYSMOD

**出典**: S_ZOS_SMPE

---

### `SMP/E ACCEPT` { #smp-e-accept }

**用途**: 適用済 PTF を確定（distribution lib に反映）。

**構文**:

```
SET BDY(<dlib zone>). ACCEPT S(<sysmod>).
```

**典型例**:

```
SET BDY(MVSDLB). ACCEPT S(UA12345) CHECK.
```

**注意点**: ACCEPT 後は RESTORE 不可（distribution に反映済）。一定期間運用後に実施。

**関連手順**: `cfg-smpe-apply`

**関連用語**: SMP/E

**出典**: S_ZOS_SMPE

---

### `SMP/E RESTORE` { #smp-e-restore }

**用途**: applied 状態の PTF を取り消し（target zone から削除）。

**構文**:

```
SET BDY(<target zone>). RESTORE S(<sysmod>).
```

**典型例**:

```
SET BDY(MVST100). RESTORE S(UA12345).
```

**注意点**: ACCEPT 前のみ RESTORE 可能。問題発生時の rollback。

**関連手順**: `cfg-smpe-apply`

**関連用語**: SMP/E

**出典**: S_ZOS_SMPE

---

### `SMP/E LIST` { #smp-e-list }

**用途**: SMP/E の登録情報（PTF/HOLD/ZONE 等）を表示。

**構文**:

```
SET BDY(<zone>). LIST <type>.
```

**典型例**:

```
SET BDY(MVST100). LIST SYSMOD(UA12345).
SET BDY(MVST100). LIST FUNCTION.
```

**注意点**: PTF 状態確認、product 構成確認、HOLDDATA 確認等で使用。

**関連手順**: `cfg-smpe-apply`

**関連用語**: SMP/E

**出典**: S_ZOS_SMPE

---


*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
