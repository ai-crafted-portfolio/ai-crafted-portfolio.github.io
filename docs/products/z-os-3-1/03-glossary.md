# 用語集

> 掲載：**78 件（関連用語クロスリンク + 仮想記憶カテゴリ追加）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## コア OS（10 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="z-os">**z/OS**</span> | IBM Z メインフレームの 64-bit エンタープライズ OS。MVS を起源とし、JES2/JCL/SMS/RACF/USS 等を統合。 | [MVS](#mvs), IBM Z, LPAR |  |
| <span id="mvs">**MVS**</span> | Multiple Virtual Storage。z/OS の前身、現在も内部呼称として使われる（MVS データセット、MVS コマンド等）。 | [z/OS](#z-os), [BCP](#bcp) |  |
| <span id="bcp">**BCP**</span> | Base Control Program。z/OS のカーネル相当。スーパーバイザ・ディスパッチャ・I/O サブシステム等を含む。 | [MVS](#mvs), [z/OS](#z-os) |  |
| <span id="ipl">**IPL**</span> | Initial Program Load。z/OS の起動プロセス。SYSRES からブート、NIP, MVS startup を経て multi-user 状態に。 | [NIP](#nip), SYSRES, [LOADxx](#loadxx) | [inc-ipl-fail](09-incident-procedures.md#inc-ipl-fail) |
| <span id="nip">**NIP**</span> | Nucleus Initialization Program。IPL 中に PARMLIB を読み、システム構成を初期化するプログラム。 | [IPL](#ipl), [PARMLIB](#parmlib) | [inc-ipl-fail](09-incident-procedures.md#inc-ipl-fail) |
| <span id="address-space">**Address Space**</span> | z/OS のプロセス相当。各ジョブ・STC・TSO ユーザに 1 つ割り当てられる 64-bit 仮想アドレス空間。 | [ASID](#asid), [STC](#stc), TSO |  |
| <span id="asid">**ASID**</span> | Address Space ID。各 Address Space を識別する 16-bit 番号（最大 65535）。 | [Address Space](#address-space) |  |
| <span id="stc">**STC**</span> | Started Task。S コマンドで起動するシステムサービス。PROCLIB 配下の <name>.proc を実行。 | [PROCLIB](#proclib), [Address Space](#address-space) | [cfg-stc-startup](08-config-procedures.md#cfg-stc-startup) |
| <span id="tso-e">**TSO/E**</span> | Time Sharing Option / Extensions。z/OS の対話型ユーザインターフェース。LOGON で開始、ISPF が標準シェル。 | [ISPF](#ispf), LOGON, [REXX](#rexx) | [cfg-tso-logon](08-config-procedures.md#cfg-tso-logon) |
| <span id="batch">**Batch**</span> | JCL を介したバッチジョブ実行。JES2 が SUBMIT を受け付け、INITDECK で定義された initiator が実行。 | [JCL](#jcl), [JES2](#jes2), [Initiator](#jes2-initiator) | `cfg-job-submit` |

## JES2 / JCL（8 件）


![SSI Directed/Broadcast Request](images/v02_jes_p0036_img1.jpeg)

*図: z/OS Subsystem Interface のリクエスト経路 （出典: ABCs of z/OS Vol.02 (SG24-7977) p.36）*


![JES2 概要](images/v02_jes_p0017_img1.jpeg)

*図: JES2 の役割（Job Entry / Initiation / Output Processing） （出典: ABCs of z/OS Vol.02 (SG24-7977) p.17）*

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="jes2">**JES2**</span> | Job Entry Subsystem 2。z/OS のジョブ管理サブシステム。JCL 受付、初期化、出力管理を担当。JES3 もあるが JES2 が主流。 | [JCL](#jcl), [SPOOL](#jes2-spool), [Initiator](#jes2-initiator), [NJE](#nje) | [cfg-jes2-init](08-config-procedures.md#cfg-jes2-init) |
| <span id="jcl">**JCL**</span> | Job Control Language。z/OS バッチジョブを記述する言語。JOB / EXEC / DD ステートメントが主要構造。 | [JES2](#jes2), EXEC, DD | `cfg-job-submit` |
| <span id="jes2-spool">**JES2 SPOOL**</span> | JES2 が使用する共有 DASD スプール。ジョブ JCL/SYSOUT/SYSIN 等を一時保管。複数 spool volume で構成。 | [JES2](#jes2), SPOOL Volume | [inc-jes2-spool-full](09-incident-procedures.md#inc-jes2-spool-full) |
| <span id="jes2-initiator">**JES2 Initiator**</span> | JES2 イニシエータ。ジョブクラスからジョブを取り出して実行する機構。INITDECK で定義、$DA/$DI で表示。 | [JES2](#jes2), [JES2 Class](#jes2-class), INITDECK | [cfg-jes2-init](08-config-procedures.md#cfg-jes2-init) |
| <span id="jes2-class">**JES2 Class**</span> | JCL の CLASS= で指定する 1 文字（A-Z, 0-9）。Initiator の受け持ちクラスと一致したジョブが実行される。 | [JES2 Initiator](#jes2-initiator), JOBCLASS | [cfg-jes2-init](08-config-procedures.md#cfg-jes2-init) |
| <span id="proclib">**PROCLIB**</span> | JCL Procedure Library。catalogued procedure を格納する PDS。SYS1.PROCLIB 等が標準。 | [JCL](#jcl), EXEC, PROC | [cfg-stc-startup](08-config-procedures.md#cfg-stc-startup) |
| <span id="nje">**NJE**</span> | Network Job Entry。JES2 ノード間でジョブ・SYSOUT を転送する機構。NETSRV で定義。 | [JES2](#jes2) | [cfg-jes2-nje](08-config-procedures.md#cfg-jes2-nje) |
| <span id="sysout">**SYSOUT**</span> | ジョブの出力データセット。CLASS で出力先・後処理（HOLD/PRINT/PURGE）を制御。 | [JES2](#jes2), MSGCLASS | `cfg-job-submit` |

## PARMLIB / 設定（8 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="parmlib">**PARMLIB**</span> | SYS1.PARMLIB（および concatenation chain）。z/OS の主要設定ファイル群を格納する PDS。 | [LOADxx](#loadxx), [IEASYSxx](#ieasysxx), [BPXPRMxx](#bpxprmxx) | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) |
| <span id="loadxx">**LOADxx**</span> | PARMLIB 内の起点メンバ。IODF / IEASYS suffix / PARMLIB チェーン等を定義。IPL 時に LOADxx → IEASYS の順で読まれる。 | [PARMLIB](#parmlib), IEASYS | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) |
| <span id="ieasysxx">**IEASYSxx**</span> | システム初期化パラメータメンバ。SQA, GRSCNF, SCH, CLPA 等の主要パラメータを集約。 | [PARMLIB](#parmlib), [LOADxx](#loadxx) | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) |
| <span id="iefssnxx">**IEFSSNxx**</span> | サブシステム定義メンバ。JES2, RACF, SMF, OMVS 等のサブシステムを登録。IPL 時に順序通り起動。 | [PARMLIB](#parmlib), [JES2](#jes2), [RACF](#racf) | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) |
| <span id="bpxprmxx">**BPXPRMxx**</span> | USS（OMVS）の構成メンバ。MAXASSIZE, MAXFILEPROC, ROOT FILESYSTEM 等を定義。 | [USS](#uss), [OMVS](#omvs), [HFS](#hfs), [zFS](#zfs) | [cfg-uss-fs](08-config-procedures.md#cfg-uss-fs) |
| <span id="smfprmxx">**SMFPRMxx**</span> | SMF 設定メンバ。記録対象 type、出力先データセット、バッファ等を定義。 | [SMF](#smf), [PARMLIB](#parmlib) | [cfg-smf-collect](08-config-procedures.md#cfg-smf-collect) |
| <span id="consolxx">**CONSOLxx**</span> | コンソール定義メンバ。MCS / EMCS コンソール、HARDCOPY、AUTH 等を定義。 | [Console](#console), MCS | [cfg-console-add](08-config-procedures.md#cfg-console-add) |
| <span id="clpa">**CLPA**</span> | Create Link Pack Area。LPALIB から LPA を再作成する IPL オプション。常駐モジュール変更時に必要。 | [LPA](#lpa), LLA, IEASYS | [cfg-clpa-ipl](08-config-procedures.md#cfg-clpa-ipl) |

## Storage / DFSMS（8 件）


![DFSMS 概要](images/v03_dfsms_p0019_img1.jpeg)

*図: DFSMS の構成（DFSMSdfp / dss / hsm / rmm） （出典: ABCs of z/OS Vol.03 (SG24-7978) p.19）*


![SMS Storage Groups](images/v03_dfsms_p0111_img1.jpeg)

*図: SMS Storage Groups の分類 （出典: ABCs of z/OS Vol.03 (SG24-7978) p.111）*

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="dasd">**DASD**</span> | Direct Access Storage Device。z/OS のディスク（3390 互換）。VOLSER で識別。 | Volume, UCB, [VOLSER](#volser) | `cfg-device-vary` |
| <span id="volser">**VOLSER**</span> | Volume Serial Number。DASD volume を一意識別する 6 文字。例: USR000, SYSRES。 | [DASD](#dasd), Volume |  |
| <span id="dataset">**Dataset**</span> | z/OS のファイル相当。DSORG（PS/PO/VS）、RECFM、LRECL、BLKSIZE 等の DCB 属性を持つ。 | DSORG, DCB, PDS, [VSAM](#vsam) | [cfg-dataset-mgmt](08-config-procedures.md#cfg-dataset-mgmt) |
| <span id="catalog">**Catalog**</span> | データセット名→VOLSER のマッピングを保持する VSAM。Master Catalog + 複数 User Catalog。 | [Dataset](#dataset), ICF Catalog | [cfg-dataset-mgmt](08-config-procedures.md#cfg-dataset-mgmt) |
| <span id="vsam">**VSAM**</span> | Virtual Storage Access Method。インデックス付きデータセット形式（KSDS/ESDS/RRDS/LDS）。 | KSDS, ESDS, RRDS | [cfg-dataset-mgmt](08-config-procedures.md#cfg-dataset-mgmt) |
| <span id="dfsms">**DFSMS**</span> | Data Facility Storage Management Subsystem。SMS-managed データセット、HSM、DFDSS 等を含む統合ストレージ管理。 | [SMS](#sms), [HSM](#hsm), ACS | [cfg-sms-class](08-config-procedures.md#cfg-sms-class) |
| <span id="sms">**SMS**</span> | Storage Management Subsystem。Storage Class / Data Class / Management Class / Storage Group で動的にデータセット配置を制御。 | [DFSMS](#dfsms), ACS Routine | [cfg-sms-class](08-config-procedures.md#cfg-sms-class) |
| <span id="hsm">**HSM**</span> | Hierarchical Storage Manager。データセットの自動マイグレ（DASD→Tape）・回復管理。Migration Level 1/2、Backup。 | [DFSMS](#dfsms) |  |

## セキュリティ（5 件）


![RACF Database 管理者](images/v06_racf_p0137_img1.jpeg)

*図: RACF Database 管理者（ADMINA）の概念 （出典: ABCs of z/OS Vol.06 (SG24-7981) p.137）*


![RACF Profile 階層](images/v06_racf_p0137_img2.jpeg)

*図: RACF プロファイル階層の概念 （出典: ABCs of z/OS Vol.06 (SG24-7981) p.137）*

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="racf">**RACF**</span> | Resource Access Control Facility。z/OS の標準セキュリティ製品。ユーザ認証、リソース保護、監査を統合。 | USERID, [Profile](#racf-profile), Permit | [cfg-racf-permit](08-config-procedures.md#cfg-racf-permit) |
| <span id="racf-profile">**RACF Profile**</span> | RACF で保護するリソース定義。DATASET / GENERAL / USER / GROUP の 4 大プロファイルクラス。 | [RACF](#racf), [PERMIT](#permit), [ACCESS](#access-level) | [cfg-racf-permit](08-config-procedures.md#cfg-racf-permit) |
| <span id="permit">**PERMIT**</span> | RACF の権限付与コマンド。ID（ユーザ・グループ）に対し ACCESS（READ/UPDATE/CONTROL/ALTER）を割り当てる。 | [RACF](#racf), [Profile](#racf-profile), [ACCESS](#access-level) | [cfg-racf-permit](08-config-procedures.md#cfg-racf-permit) |
| <span id="access-level">**ACCESS Level**</span> | READ < UPDATE < CONTROL < ALTER の階層的権限レベル。NONE は明示拒否。 | [RACF](#racf), [PERMIT](#permit) | [cfg-racf-permit](08-config-procedures.md#cfg-racf-permit) |
| <span id="omvs-segment">**OMVS Segment**</span> | RACF USERID の OMVS セグメント。USS で使う UID/GID/HOME/PROGRAM を定義。 | [RACF](#racf), [USS](#uss), UID | `cfg-uss-setup` |

## Sysplex / GRS（5 件）


![Parallel Sysplex 構成](images/v05_sysplex_p0018_img1.png)

*図: Parallel Sysplex（CF + XCF + CDS）の構成 （出典: ABCs of z/OS Vol.05 (SG24-7980) p.18）*

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="sysplex">**Sysplex**</span> | Systems Complex。複数 z/OS システムを XCF/CF で連携させたクラスタ。Parallel Sysplex は CF（Coupling Facility）必須。 | [XCF](#xcf), [CF](#cf), [Parallel Sysplex](#parallel-sysplex) | [cfg-sysplex-define](08-config-procedures.md#cfg-sysplex-define) |
| <span id="parallel-sysplex">**Parallel Sysplex**</span> | Coupling Facility を介した z/OS 複数システムのデータシェア環境。Db2 Data Sharing、IMS Data Sharing 等で使用。 | [Sysplex](#sysplex), [CF](#cf), [XCF](#xcf) | [cfg-sysplex-define](08-config-procedures.md#cfg-sysplex-define) |
| <span id="xcf">**XCF**</span> | Cross-System Coupling Facility。Sysplex メンバ間の通信機構。COUPLExx で設定。 | [Sysplex](#sysplex), COUPLExx | [cfg-sysplex-define](08-config-procedures.md#cfg-sysplex-define) |
| <span id="cf">**CF**</span> | Coupling Facility。複数 z/OS 間で Lock/Cache/List を共有する専用 LPAR。Db2 Group Buffer Pool 等で利用。 | [Sysplex](#sysplex), [Parallel Sysplex](#parallel-sysplex), CFRM | [cfg-sysplex-define](08-config-procedures.md#cfg-sysplex-define) |
| <span id="grs">**GRS**</span> | Global Resource Serialization。データセット排他制御。GRS NONE / RING / STAR モード。Sysplex で STAR 必須。 | [Sysplex](#sysplex), ENQ, GRSRNLxx | [cfg-grs-setup](08-config-procedures.md#cfg-grs-setup) |

## WLM / SMF（5 件）


![WLM Service Class](images/v12_wlm2_p0137_img1.jpeg)

*図: WLM External / Internal Service Class （出典: ABCs of z/OS Vol.12 (SG24-7987) p.137）*


![WLM Service Class の構造](images/v11_wlm_p0049_img1.png)

*図: WLM Service Class とトランザクション関係 （出典: ABCs of z/OS Vol.11 (SG24-7986) p.49）*

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="wlm">**WLM**</span> | Workload Manager。サービスクラス（response time goal / velocity）でアドレス空間に CPU・I/O 優先度を動的割り当て。 | [Service Class](#service-class), Goal, IEAOPT | [cfg-wlm-policy](08-config-procedures.md#cfg-wlm-policy) |
| <span id="service-class">**Service Class**</span> | WLM のワークロード分類単位。Velocity / Response Time / Discretionary の goal タイプ。 | [WLM](#wlm), Period | [cfg-wlm-policy](08-config-procedures.md#cfg-wlm-policy) |
| <span id="smf">**SMF**</span> | System Management Facilities。z/OS の運用統計記録機構。Type X 番号で記録種別管理。SMFPRMxx で構成。 | [SMFPRMxx](#smfprmxx), [RMF](#rmf) | [cfg-smf-collect](08-config-procedures.md#cfg-smf-collect) |
| <span id="smf-type-30">**SMF Type 30**</span> | ジョブ・STC・TSO セッション情報。CPU 時間、I/O カウント、終了 RC を記録。最も使用される SMF type。 | [SMF](#smf) | [cfg-smf-collect](08-config-procedures.md#cfg-smf-collect) |
| <span id="rmf">**RMF**</span> | Resource Measurement Facility。リアルタイム性能監視（Monitor I/II/III）と Postprocessor レポート。 | [SMF](#smf), [WLM](#wlm) |  |

## USS（5 件）


![USS / OMVS 構造](images/v09_uss_p0239_img1.jpeg)

*図: USS（OMVS）と MVS Address Space の関係 （出典: ABCs of z/OS Vol.09 (SG24-7984) p.239）*

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="uss">**USS**</span> | UNIX System Services。z/OS 内の POSIX 互換 UNIX 環境。HFS/zFS ファイルシステム、シェル、コマンド群を提供。 | [OMVS](#omvs), [HFS](#hfs), [zFS](#zfs), [BPXPRMxx](#bpxprmxx) | `cfg-uss-setup` |
| <span id="omvs">**OMVS**</span> | USS の対話シェル名・サブシステム名。TSO> OMVS で USS シェルに移行。 | [USS](#uss) | `cfg-uss-setup` |
| <span id="hfs">**HFS**</span> | Hierarchical File System。USS の旧 FS 形式。新規は zFS 推奨だが互換のため残存。 | [USS](#uss), [zFS](#zfs) | [cfg-uss-fs](08-config-procedures.md#cfg-uss-fs) |
| <span id="zfs">**zFS**</span> | z/OS File System。USS の標準 FS。VSAM Linear DS をベースに zFS aggregate を構成。HFS の後継。 | [USS](#uss), [HFS](#hfs), [BPXPRMxx](#bpxprmxx) | [cfg-uss-fs](08-config-procedures.md#cfg-uss-fs) |
| <span id="bpxbatch">**BPXBATCH**</span> | USS シェルスクリプトを JES2 バッチジョブとして実行する MVS プログラム。 | [USS](#uss), [JCL](#jcl) | `cfg-uss-batch` |

## ネットワーク（4 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="tcp-ip（z-os）">**TCP/IP（z/OS）**</span> | Communications Server TCP/IP。z/OS のネットワークスタック。TCPIP STC、PROFILE.TCPIP で構成。 | [VTAM](#vtam), [OSA](#osa), FTP | [cfg-tcpip-profile](08-config-procedures.md#cfg-tcpip-profile) |
| <span id="vtam">**VTAM**</span> | Virtual Telecommunications Access Method。SNA プロトコルスタック。TN3270/CICS/IMS 等で使用。 | TCP/IP, SNA | `cfg-vtam-startup` |
| <span id="ftp（z-os）">**FTP（z/OS）**</span> | z/OS 同梱の FTP サーバ／クライアント。MVS データセット⇄ファイル変換に対応。 | TCP/IP |  |
| <span id="osa">**OSA**</span> | Open Systems Adapter。z/OS 用ネットワークアダプタ。OSA-Express。 | TCP/IP, [VTAM](#vtam) |  |

## 管理ツール（10 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="ispf">**ISPF**</span> | Interactive System Productivity Facility。z/OS で最も使われる対話ツール。3270 ベース、メニュー駆動、PDS 編集が中心。 | [TSO/E](#tso-e), PDF | [cfg-tso-logon](08-config-procedures.md#cfg-tso-logon) |
| <span id="sdsf">**SDSF**</span> | System Display and Search Facility。JES2 ジョブ、ログ、コンソール表示の対話ツール。DA/ST/LOG/JOB/OUT が主要パネル。 | [JES2](#jes2), [ISPF](#ispf) |  |
| <span id="rexx">**REXX**</span> | Restructured Extended Executor。z/OS の標準スクリプト言語。TSO REXX / USS REXX / NetView REXX 等。 | [TSO/E](#tso-e), [CLIST](#clist) | [cfg-rexx-script](08-config-procedures.md#cfg-rexx-script) |
| <span id="clist">**CLIST**</span> | Command List。TSO の旧スクリプト言語。REXX 推奨。 | [REXX](#rexx), [TSO/E](#tso-e) |  |
| <span id="smp-e">**SMP/E**</span> | System Modification Program / Extended。z/OS のソフトウェアパッケージ管理。FUNCTION/PTF/APAR/USERMOD の SYSMOD 適用。 | [PTF](#ptf), [SYSMOD](#sysmod), [APAR](#apar) | `cfg-smpe-apply` |
| <span id="ptf">**PTF**</span> | Program Temporary Fix。IBM 提供の修正パッケージ。SMP/E APPLY で適用。 | [SMP/E](#smp-e), [SYSMOD](#sysmod), HOLDDATA | `cfg-smpe-apply` |
| <span id="sysmod">**SYSMOD**</span> | System Modification。SMP/E が管理する変更単位。FUNCTION/PTF/APAR/USERMOD の総称。 | [PTF](#ptf), [APAR](#apar), [SMP/E](#smp-e) | `cfg-smpe-apply` |
| <span id="apar">**APAR**</span> | Authorized Program Analysis Report。IBM が認識した不具合報告。修正は PTF として提供される。 | [PTF](#ptf), [SMP/E](#smp-e) |  |
| <span id="hcd">**HCD**</span> | Hardware Configuration Definition。z/OS の I/O 構成定義ツール。IODF を作成。 | [IODF](#iodf), IOCDS | `cfg-hcd-iodf` |
| <span id="iodf">**IODF**</span> | I/O Definition File。HCD で生成、IPL 時に読み込まれる I/O 構成データ。 | [HCD](#hcd), IOCDS | `cfg-hcd-iodf` |

## コンソール（2 件）


![z/OS コンソール概念](images/v01_intro_p0091_img1.jpeg)

*図: MCS / EMCS / SMCS コンソールの関係 （出典: ABCs of z/OS Vol.01 (SG24-7976) p.91）*

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="wtor">**WTOR**</span> | Write to Operator with Reply。応答待ちオペレータメッセージ。R <id>,<reply> で応答するまで処理が進まない。 | [Console](#console), MCS | [inc-wtor-response](09-incident-procedures.md#inc-wtor-response) |
| <span id="console">**Console**</span> | z/OS のシステムコンソール。MCS（Multiple Console Support）/ EMCS / SMCS の 3 種。 | MCS, EMCS, [CONSOLxx](#consolxx) | [cfg-console-add](08-config-procedures.md#cfg-console-add) |

## 仮想記憶（8 件）


![z/OS 仮想記憶レイアウト](images/v01_intro_p0029_img1.jpeg)

*図: z/OS 64-bit Address Space の仮想記憶レイアウト（Common / Private） （出典: ABCs of z/OS Vol.01 (SG24-7976) p.29）*

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="psa">**PSA**</span> | Prefixed Save Area。各 CPU 専用の最下位 8KB 仮想記憶領域（CPU ごとにプレフィックスレジスタで区別）。割込処理用 PSW・レジスタ保管域、CVT へのポインタ等を含む。 | [CVT](#cvt), [SQA](#sqa), [ASID](#asid) |  |
| <span id="csa">**CSA**</span> | Common Service Area。全 Address Space で共有される 16MB 境界より下の仮想記憶。サブシステム間共有データに使用。IEASYSxx の CSA= で 1 番目に指定。 | [ECSA](#ecsa), [SQA](#sqa), [IEASYSxx](#ieasysxx) | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) |
| <span id="ecsa">**ECSA**</span> | Extended Common Service Area。16MB 境界より上の CSA。Db2/CICS/MQ 等のサブシステムが多く消費。IEASYSxx の CSA= で 2 番目に指定。 | [CSA](#csa), [ESQA](#esqa), [IEASYSxx](#ieasysxx) | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) |
| <span id="sqa">**SQA**</span> | System Queue Area。z/OS カーネルが使う共有制御ブロック領域（16MB 境界より下）。枯渇すると IPL 失敗・システム停止リスク。IEASYSxx の SQA= で指定。 | [ESQA](#esqa), [CSA](#csa), [IEASYSxx](#ieasysxx) | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) |
| <span id="esqa">**ESQA**</span> | Extended SQA。16MB 境界より上の SQA。Address Space 数増加・Sysplex/Db2 規模拡大とともに増量必要。 | [SQA](#sqa), [ECSA](#ecsa), [IEASYSxx](#ieasysxx) | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) |
| <span id="lpa">**LPA**</span> | Link Pack Area。z/OS 共通の常駐モジュール領域。PLPA/MLPA/FLPA の 3 種に分類。CLPA で再構築。LPALSTxx でデータセット連結を定義。 | [CLPA](#clpa), LPALSTxx | [cfg-clpa-ipl](08-config-procedures.md#cfg-clpa-ipl) |
| <span id="svc">**SVC**</span> | Supervisor Call。問題プログラムから z/OS カーネルサービスを呼び出す機械命令（SVC 番号で識別）。SVC dump, SVC table 等の用語にも登場。SVC dump = SVC 命令で取得するメモリダンプ。 | MAXSPACE, SVC dump | `inc-svc-dump` |
| <span id="cvt">**CVT**</span> | Communication Vector Table。z/OS の中核制御ブロック。各種制御ブロック・テーブルへのポインタを集約。PSA 内のオフセットからアクセス可能。 | [PSA](#psa), JESCT, SSCVT |  |



### 仮想記憶用語の独立 anchor（v4 追加）

用語集テーブル参照に加え、本サイト内 / 外部からの直接リンク用に独立 anchor を提供。

#### SVC { #svc }

Supervisor Call。問題プログラムからカーネルへのシステムコール命令。SVC dump 等の派生語あり。

用語集の詳細セクションも参照（仮想記憶カテゴリ）。

#### PSA { #psa }

Prefixed Save Area。各 CPU 専用最下位 8KB 領域。割込処理 PSW・CVT ポインタを含む。

用語集の詳細セクションも参照（仮想記憶カテゴリ）。

#### CSA { #csa }

Common Service Area。16MB 境界より下の全 Address Space 共有領域。

用語集の詳細セクションも参照（仮想記憶カテゴリ）。

#### ECSA { #ecsa }

Extended CSA。16MB 境界より上。Db2/CICS/MQ 等が消費。

用語集の詳細セクションも参照（仮想記憶カテゴリ）。

#### ESQA { #esqa }

Extended SQA。16MB 境界より上のシステムキュー領域。

用語集の詳細セクションも参照（仮想記憶カテゴリ）。

#### CVT { #cvt }

Communication Vector Table。z/OS 中核制御ブロック。各種テーブルへのポインタ集約。

用語集の詳細セクションも参照（仮想記憶カテゴリ）。


---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
