# z/OS システムプログラミング (ABCs) — 主要設定項目

Sysprog が扱う主要設定領域 — ABCs シリーズでの扱い

Sysprog が日常的に編集する代表的な設定オブジェクト（PARMLIB メンバ、PROCLIB、 RACF Profile、TCP/IP プロファイル等）について、各 ABCs Vol 内での扱われ方 （概念紹介の有無 / 例題の充実度 / 公式マニュアルへの導線）を整理。 パラメータの網羅・最新仕様の正確性は z/OS 3.1 公式マニュアル構造化タスク側を参照。

| 設定領域 | 主要オブジェクト | ABCs での扱い方 | 主担当 Vol | 出典 |
|---|---|---|---|---|
| システム IPL 制御 | SYS1.PARMLIB 全般 (IEASYSxx, IEASYMxx, LOADxx) | Vol 2 Ch1（z/OS implementation and daily maintenance）で IPL シーケンスと PARMLIB の役割を概観。具体的 keyword（CLPA, CLOCK= 等）の詳細記述は限定的で、公式 SA22-7592 への参照誘導が中心。 | Vol 2 | S2 |
| サブシステム定義 | IEFSSNxx, JES2/JES3 PARMLIB, MSTRJCL | Vol 2 Ch2（Subsystems and subsystem interface）で SSI の概念と Master/Subsystem 関係を解説。JES2 init 文・JES3 INISH デッキ例は Vol 2 Ch3 で簡略提示。 | Vol 2 | S2 |
| ライブラリ連結 | LPALSTxx, LNKLSTxx, IEAAPFxx, PROGxx | Vol 2 Ch4（LPA, LNKLST, and authorized libraries）でモジュールサーチオーダ（LPA → LNKLST → JOBLIB/STEPLIB）と認可ライブラリの考え方を整理。動的 LPA/LNKLST の運用例も提示。 | Vol 2 | S2 |
| PTF 適用・SMP/E | GLOBAL/TARGET/DLIB ZONE, RECEIVE/APPLY/ACCEPT, HOLDDATA | Vol 2 Ch5（SMP/E for z/OS）で全体ワークフロー（RECEIVE→APPLY CHECK→APPLY→ACCEPT）と SMPNTS の使い方を実例提示。Internet Service Retrieval（IsR）の章もあり。 | Vol 2 | S2 |
| ストレージ管理 | SMS Constructs (SC/MC/DC/SG/AC), ACS Routine, IGDSMSxx | Vol 3 Ch4（Storage management software）と Ch5（System-managed storage）で ACS routine と SMS Construct の関係を視覚的に解説。EAV (Vol 3 Ch3) は Sysprog 移行作業で頻出。 | Vol 3 | S3 |
| カタログ運用 | ICF Master/User Catalog, Catalog Address Space (CAS), CSI | Vol 3 Ch6（Catalogs）で BCS/VVDS の関係、Master/User Catalog の役割分担、CAS 監視（F CATALOG コマンド）を網羅。 | Vol 3 | S3 |
| TCP/IP プロファイル | TCP/IP PROFILE.TCPIP, IPCONFIG/TCPCONFIG/UDPCONFIG, RESOLVER | Vol 4 Ch3（TCP/IP stack）で stack 起動・config 編集の基本形を解説。AT-TLS / Policy Agent などのセキュリティ寄り構成は Vol 6 Ch4（Integrated Security Services）と組み合わせて参照。 | Vol 4 / Vol 6 | S4, S6 |
| VTAM 構成 | VTAMLST (ATCSTRxx, ATCCONxx), Major Node 定義 | Vol 4 Ch2（VTAM concepts for SNA networks）で APPN/HPR/EE の前提と Major Node の階層を整理。SNA→EE 移行の Sysprog 観点が記述。 | Vol 4 | S4 |
| Sysplex 関連 PARMLIB | COUPLExx, GRSCNFxx/GRSRNLxx, IXGCNFxx, IEAOPTxx (WLM) | Vol 5 Ch1 (Parallel Sysplex), Ch2 (System Logger), Ch4 (GRS) でそれぞれ COUPLExx の CF/CFRM/SFM 構造、Logger STAGING/Offload DS、GRS Star/Ring の構成を解説。 | Vol 5 | S5 |
| RACF Class/Profile | RACF Database, FACILITY/UNIXPRIV/STARTED Class, RACDCERT | Vol 6 Ch3（IBM z/OS Security Server RACF）でクラス活性化（SETROPTS）、Profile 定義（RDEFINE/PERMIT）、デジタル証明書管理（RACDCERT）の流れを実例付きで解説。 | Vol 6 | S6 |
| ICSF / 暗号化 | CKDS/PKDS/TKDS, CSFPRMxx, CCA Master Key, ICSF startup | Vol 6 Ch5（Cryptographic Services）で CCA/PKCS#11 の鍵リポジトリ構造、CSFPRMxx の最小設定、Master Key Loading の手順（Pass Phrase Init / TKE）を整理。 | Vol 6 | S6 |
| Infoprint Server 構成 | AOPSTART, AOPCONF, IP PrintWay, NetSpool, OUTPUT JCL | Vol 7 Ch3（Infoprint Server customization）で AOPCONF の最小構成、Vol 7 Ch5/Ch6 で IP PrintWay/NetSpool の役割分担を解説。USS 前提のため Vol 9 と組み合わせ参照。 | Vol 7 / Vol 9 | S7, S9 |
| ダンプ / IPCS | BLSCECT, IEADMRxx, SVC dump / SYSMDUMP / Stand-Alone Dump | Vol 8 Ch4（Dump processing）で SVC/SYSMDUMP/SYSABEND/SADUMP のダンプ種別ごとの取得経路、Vol 8 Ch6（IPCS dump debugging）で IPCS 起動・主要コマンド（VERBX, ANALYZE）を整理。 | Vol 8 | S8 |
| USS / zFS | BPXPRMxx, FILESYSTYPE/MOUNT, zFS aggregate, OMVS segment | Vol 9 Ch9（Managing file systems）で BPXPRMxx の MOUNT/AUTOMOUNT、Vol 9 Ch6（Security customization）で OMVS segment と UNIXPRIV の関係を解説。 | Vol 9 | S9 |
| HCD / IODF | HCD ダイアログ, IODFxx, IOCDS, OSA-Express/FICON/FCP 定義 | Vol 10 Ch3（IBM Z connectivity）と Ch4（PR/SM concepts）で HCD ダイアログ起点の I/O 定義、IOCDS の活性化、CSS/MIF の概念を解説。 | Vol 10 | S10 |
| WLM Policy | WLM ISPF, Service Class / Report Class / Goal, IEAOPTxx | Vol 11 Ch2（Performance management）で WLM 概論、Vol 12 全章で ISPF パネル単位の Service Class 設計、Goal/Importance/Velocity の使い分けを実例で解説。 | Vol 11 / Vol 12 | S11, S12 |
| RMF / SMF | ERBRMFxx, SMF Type 70-79, SMF buffer / SMFPRMxx | Vol 11 Ch3（Resource Measurement Facility）で RMF Mon I/II/III の使い分けと出力読み方、SMF Type 別の関連性を解説。 | Vol 11 | S11 |

