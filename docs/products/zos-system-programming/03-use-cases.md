# z/OS システムプログラミング (ABCs) — 典型ユースケース

Sysprog 典型業務シナリオ × ABCs Vol 対応

Sysprog の代表的な業務シナリオ（IPL、保守、障害対応、性能管理、Sysplex 運用等）と 参照すべき ABCs Vol/章をマッピング。実作業に必要な手順は ABCs では概観に留まる ことが多いため、参照すべき公式マニュアル系統も併記。

| ユースケース | 業務フェーズ | ABCs 内の参照章 | 公式マニュアル参照 | Sysprog 観点の要点 | 出典 |
|---|---|---|---|---|---|
| 新規 z/OS の IPL までの実装 | システム導入 | Vol 2 Ch1 / Vol 2 Ch4 (LPA/LNKLST/APF) | z/OS Initialization and Tuning (SA23-1379), MVS System Codes (SA38-0668) | PARMLIB の最小セット（IEASYS00, IEASYM00, COUPLE00, GRSCNF00 など）と Master Catalog 定義の順序、CLPA/CLOCK 設定の影響を理解する。 | S2 |
| PTF / RSU 適用ワークフロー | 日常保守 | Vol 2 Ch5（SMP/E for z/OS） | SMP/E for z/OS User's Guide (SA23-2277), HOLDDATA Reference | RECEIVE → APPLY CHECK → APPLY → ACCEPT のサイクル。HOLDDATA の種類（HIPER/PE/ERROR）と無視可否判定が肝。 | S2 |
| JES2 起動・運用 | サブシステム運用 | Vol 2 Ch3（Job management） | JES2 Initialization and Tuning Guide/Reference (SA32-0991/0992) | JES2 init deck の主要 statement（NJEDEF, MASDEF, CKPTDEF, SPOOLDEF, INITDEF）を理解。Single→Multi-system Spool 構成の前提を Vol 2 で押さえる。 | S2 |
| DASD 拡張・データセット移動 | ストレージ運用 | Vol 3 Ch2 / Ch3 (EAV) / Ch4-5 (SMS) / Ch6 (Catalog) | DFSMS Implementing System-Managed Storage (SC23-6849), DFSMSdss Storage Administration (SC23-6868) | EAV 移行は Multi-Cyl Unit 境界と DSCB type 8/9 を意識。SMS ACS routine の Storage Class/Storage Group 選定ロジックは Vol 3 で要確認。 | S3 |
| Sysplex / Coupling Facility 構築 | 可用性設計 | Vol 5 Ch1 / Ch2 (Logger) / Ch4 (GRS) / Ch7 (GDPS) | MVS Setting Up a Sysplex (SA23-1399), CFRM Sizer Tool, Sysplex Tuning | CFRM Policy の Structure 配置、Logger STAGING DS の冗長性、GRS Star→Ring フェイルバック挙動を Sysprog として理解しておく。 | S5 |
| Logger CF Structure 障害対応 | 障害復旧 | Vol 5 Ch2（System Logger）+ Vol 8 Ch4 (Dump processing) | MVS System Logger (SA23-1378), MVS System Messages IXG* | IXG/IXG2xx メッセージの読み解き、Offload DS への退避、staging-only / DS-only 構成への手動切替手順は Vol 5 で概観のみ → 公式必読。 | S5, S8 |
| RACF クラス追加・新規 Profile 設計 | セキュリティ運用 | Vol 6 Ch3（RACF） | Security Server RACF Security Administrator's Guide (SA23-2289), RACF Command Language Reference | 新規クラス（FACILITY/UNIXPRIV）は SETROPTS CLASSACT/RACLIST が前提。プロファイル粒度（Discrete vs Generic）と DEFAULTUSER の取り扱いに注意。 | S6 |
| ICSF Master Key 切替 | 鍵更新 | Vol 6 Ch5（Cryptographic Services） | ICSF Administrator's Guide (SC14-7506), TKE Workstation User's Guide | AES/DES/RSA Master Key の Re-Encipher → Change MK の 2 段手順、CKDS/PKDS の同時再暗号化、Coexistence Mode の存在を Sysprog として理解。 | S6 |
| 印刷経路設計 | 出力サブシステム | Vol 7 Ch3-Ch7（Infoprint Server / IP PrintWay / NetSpool） | z/OS Infoprint Server Customization (SA38-0691), z/OS Infoprint Server Operation and Administration (SA38-0693) | JES Spool→Infoprint Server→AFP/PCL の経路と、SAP/IDS 系の NetSpool 経路の使い分け。USS aopstart 起動依存に注意。 | S7 |
| ABEND ダンプ採取・解析 | 障害診断 | Vol 8 Ch3 / Ch4 / Ch6 / Ch9（SDSF and RMF） | MVS IPCS User's Guide (SA23-1382), MVS IPCS Commands | ABEND→SLIP/CHNGDUMP→SVC Dump 採取→IPCS 解析の流れ。SDSF DA/DSPRINT/H 画面でダンプ DS 確認。 | S8 |
| USS / zFS 拡張・SHARE 化 | USS 運用 | Vol 9 Ch8 (File sharing in a sysplex) / Ch9 (Managing file systems) | z/OS UNIX System Services Planning (GA32-0884), zFS Administration (SC23-6887) | zFS aggregate の Grow / shrink、Sysplex-aware mount、zfsadm コマンド、BPXPRMxx の SYSPLEX 設定を押さえる。 | S9 |
| I/O 構成変更（HCD / Activate） | ハードウェア構成 | Vol 10 Ch3-Ch4（IBM Z connectivity / PR/SM） | z/OS HCD User's Guide (SC34-2669), HCM User's Guide | HCD ダイアログ→IODF Build→IOCDS Write→Dynamic Activate の流れ。CSS/MIF/MCSS の概念は Vol 10 で必須。 | S10 |
| WLM Service Class 設計 | 性能設計 | Vol 11 Ch2 + Vol 12 Ch1-Ch4 | z/OS MVS Planning: Workload Management (SA23-1391), MVS Programming: Workload Management Services | Goal Mode（Velocity / Response Time / Discretionary）の選択、Importance Level、Period 構造、IRD/Group Capacity の使い分け。 | S11, S12 |
| 性能データ収集とレポート | 性能監視 | Vol 11 Ch3（RMF） | z/OS RMF User's Guide (SC34-2664), z/OS RMF Report Analysis (SC34-2665) | RMF Monitor I（バッチ後処理 SMF Type 70-79）/ Monitor II（オンライン詳細）/ Monitor III（短期サンプリング・Sysplex 集約）の役割分担。 | S11 |
| TCP/IP スタック起動・移行 | ネットワーク運用 | Vol 4 Ch3（TCP/IP stack） | z/OS Communications Server: IP Configuration Reference (SC27-3651), IP Configuration Guide | PROFILE.TCPIP の最小定義（HOME/PORT/DEVICE/LINK/ROUTE）、Resolver 構成、AT-TLS の Policy Agent 連携の前提。 | S4 |

