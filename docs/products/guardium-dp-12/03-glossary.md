# 用語集

> 掲載：**78 件（GDP 固有 + 周辺・連携）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## アーキテクチャ階層 / 中核コンポーネント（12 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="collector">**Collector**</span> | DB トラフィックを直接受信して解析・ログ化する基本アプライアンス。S-TAP からの DB セッション / SQL を受信、Inspection Engine による SQL 構文解析、リアルタイムポリシ評価、内部 DB へ監査データ書き込み（既定容量保持 15 日推奨）。最大 50 Inspection Engine を搭載可能 | [Sniffer](#sniffer), [Inspection Engine](#inspection-engine), [Internal DB](#internal-db), [S-TAP](#s-tap) | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) |
| <span id="aggregator">**Aggregator**</span> | 複数 Collector の監査データを集約しレポートする統合ノード。各 Collector からの daily import を受け、長期保持・レポート・監査プロセス実行を担う。12.2.1 で **Parallel Query option**（partition-aware routing と temporary staging table）による並列クエリ高速化対応 | [Collector](#collector), [Long-term retention](#long-term-retention), [Daily Import](#daily-import) | [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge) |
| <span id="central-manager">**Central Manager (CM)**</span> | Guardium 環境全体の集中管理点。**Managed Unit** に対する patch / 証明書配布、ポリシー一括配布、ユーザ・ロール・グループ管理。Inspection Engine は CM 上では作成・実行不可（Collector からのみ実行）。**Enterprise Hub**（旧 Cross-CM Health View）で複数 CM を横断管理可 | [Aggregator](#aggregator), [Managed Unit](#managed-unit), [Distribution Profile](#distribution-profile) | [cfg-cm-managed-unit](08-config-procedures.md#cfg-cm-managed-unit) |
| <span id="managed-unit">**Managed Unit (MU)**</span> | CM 配下に登録された Collector / Aggregator の論理単位。CM から patch / 証明書 / Policy / Audit Process を MU 単位で配布。CM ↔ MU 間は 8444 / 8445 で SSL 通信 | [Central Manager](#central-manager), [Distribution Profile](#distribution-profile) | [cfg-cm-managed-unit](08-config-procedures.md#cfg-cm-managed-unit) |
| <span id="s-tap">**S-TAP（Software TAP / DB エージェント）**</span> | DB サーバ上で DB トラフィックをキャプチャし Collector へ転送するエージェント。Linux / UNIX / Windows / IBM i / z/OS（DB2 / IMS / Datasets）に対応。**K-TAP**（Kernel TAP）でカーネルレベル取得、**A-TAP** は SSL/TLS 暗号化済トラフィック復号取得（Oracle ASO / Redis 対応） | [K-TAP](#k-tap), [A-TAP](#a-tap), [GIM](#gim), [guard_tap.ini](#guard-tap-ini) | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) |
| <span id="external-stap">**External S-TAP**</span> | コンテナ / クラウド向けの **DB サーバ非変更型** 外部 S-TAP。DB サーバへエージェントを入れずプロキシ的にトラフィックを取得。**Edge Gateway 2.x** と組み合わせ Windows S-TAP / External S-TAP からのストリーミングに対応 | [Edge Gateway](#edge-gateway), [Universal Connector](#universal-connector) | [cfg-cloud-monitoring](08-config-procedures.md#cfg-cloud-monitoring) |
| <span id="gim">**GIM（Guardium Installation Manager）**</span> | S-TAP / CAS / 関連エージェントの集中インストール / 更新 / 監視。DB サーバ上で `guard_gimd`（perl 駆動の常駐デーモン）として動作。`consolidated_installer.sh` で GIM client + S-TAP を一括導入。**SHA1 / SHA256 証明書**での GIM 通信もサポート（GIM 12.2 系） | [S-TAP](#s-tap), [consolidated_installer](#consolidated-installer) | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) |
| <span id="sniffer">**Sniffer**</span> | Collector 上のキャプチャプロセス。S-TAP からの DB トラフィックを受信して **Inspection Engine** に流す。CPU / メモリの主消費源、性能の中核 | [Inspection Engine](#inspection-engine), [Buffer Free](#buffer-free) | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) |
| <span id="inspection-engine">**Inspection Engine**</span> | ネットワークパケットから SQL を抽出し Parse Tree を生成。**Sentence / Request / Command / Object / Field** を識別し内部 DB へログ。ポリシ評価のリアルタイムフロント。DB Client IP / Mask / DB Server IP / Mask / Port を engine 単位で定義。Collector 1 台に最大 50 engine | [Sniffer](#sniffer), [Parse Tree](#parse-tree), [Policy](#policy) | [cfg-inspection-engine](08-config-procedures.md#cfg-inspection-engine) |
| <span id="internal-db">**Internal Database**</span> | 監査データ格納用の Collector / Aggregator 内部 MySQL ベース DB。`/var` パーティションが既定の格納先。ディスク使用率 90% で **nanny** プロセスがサービス停止（auto_stop_services_when_full） | [nanny](#nanny), [Daily Archive](#daily-archive) | [inc-disk-full](09-incident-procedures.md#inc-disk-full) |
| <span id="ilb">**ILB（Internal Load Balancer）**</span> | Managed Unit の負荷を予測し session を分散、データ損失を低減する内部 LB。S-TAP の Failover Collector 設定と組合せ | [Failover Collector](#failover-collector) | [cfg-stap-failover](08-config-procedures.md#cfg-stap-failover) |
| <span id="edge-gateway">**Edge Gateway 2.x**</span> | Kubernetes ベースの新世代モニタリングパイプライン。Aggregator / Data Security Center SaaS / Long-term retention に統合可。AWS EKS / OpenShift / K3s に Terraform で展開、外部レジストリ対応（air-gapped） | [External S-TAP](#external-stap), [Universal Connector](#universal-connector) | [cfg-cloud-monitoring](08-config-procedures.md#cfg-cloud-monitoring) |

## S-TAP / TAP 系（10 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="k-tap">**K-TAP（Kernel TAP）**</span> | Linux/UNIX カーネルモジュールとしてロードされる S-TAP の中核。`/var/log/messages` / `dmesg` でモジュール状態確認可能。`--ktap_allow_module_combos` でカーネル互換問題を回避 | [S-TAP](#s-tap), [consolidated_installer](#consolidated-installer) | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) |
| <span id="a-tap">**A-TAP（Application TAP）**</span> | 暗号化済（SSL/TLS、Oracle ASO 等）の DB トラフィックを **DB サーバ側で復号後に取得**するモジュール。Oracle ASO / Redis 対応 | [S-TAP](#s-tap), [aso_enabled](#aso-enabled) | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) |
| <span id="guard-stap">**guard_stap（プロセス）**</span> | DB サーバ上の S-TAP 常駐プロセス本体。`ps -ef \| grep -i tap` で確認 | [S-TAP](#s-tap), [guard_gimd](#guard-gimd) | [inc-stap-down](09-incident-procedures.md#inc-stap-down) |
| <span id="guard-gimd">**guard_gimd（プロセス）**</span> | DB サーバ上の GIM 常駐 perl デーモン。CM からの patch / 設定配布を受ける | [GIM](#gim) | — |
| <span id="guard-discovery">**guard_discovery**</span> | DB サーバ上で DB instance を自動検出するプロセス。`--use_discovery 1` で起動 | [Discovery](#discovery) | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) |
| <span id="guard-tap-ini">**guard_tap.ini**</span> | S-TAP の設定ファイル（DB サーバ側）。Collector 接続先 / プロパティを定義。CM の S-TAP Configuration UI からも集中管理可能 | [S-TAP](#s-tap) | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) |
| <span id="failover-collector">**Failover Collector**</span> | プライマリ Collector が応答しない場合の切替先。`--failover_sqlguardip` で設定。ILB と組合せでデータ損失を低減 | [ILB](#ilb), [S-TAP](#s-tap) | [cfg-stap-failover](08-config-procedures.md#cfg-stap-failover) |
| <span id="aso-enabled">**aso_enabled**</span> | Oracle Advance Security Option (ASO) A-TAP トラフィックを複数 Collector に分散するフラグ | [A-TAP](#a-tap) | — |
| <span id="verdict-resume-delay">**VERDICT_RESUME_DELAY**</span> | Windows S-TAP firewall モードで全 Collector ダウン時に DB セッションを通過させるための待機時間（12.2 導入） | [S-GATE](#s-gate) | [inc-stap-conn-fail](09-incident-procedures.md#inc-stap-conn-fail) |
| <span id="pcre-regex-enabled">**PCRE_REGEX_ENABLED**</span> | Windows S-TAP で PCRE 正規表現を有効化するフラグ（12.2 導入） | — | — |

## ポリシ / ルール系（12 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="policy">**Policy**</span> | 監査・アラート・ブロッキングのルール集合。**Access** / **Extrusion** / **Session-level** / **Selective Audit** の 4 type。Policy Builder UI または grdapi で作成。**Policy Installation tool** で配備（保存だけでは反映されない） | [Policy Installation](#policy-installation), [Rule Action](#rule-action) | [cfg-policy-build](08-config-procedures.md#cfg-policy-build) |
| <span id="policy-installation">**Policy Installation**</span> | Policy を Inspection Engine に配備する操作。Policy Builder で保存しても install していなければ評価されない。複数 Policy をスタック順序付きで install 可能 | [Policy](#policy), [grdapi install_policy](01-commands.md#grdapi-install-policy) | [cfg-policy-build](08-config-procedures.md#cfg-policy-build) |
| <span id="access-policy">**Access Policy**</span> | DB アクセス（SELECT / INSERT / UPDATE / DELETE / DDL）のリアルタイム評価ルール。標準 type | [Policy](#policy) | [cfg-policy-build](08-config-procedures.md#cfg-policy-build) |
| <span id="extrusion-policy">**Extrusion Policy**</span> | DB から **返却される行データ** を評価するルール（漏洩監視）。`Inspect Returned Data` 必須 | [Policy](#policy) | [cfg-extrusion-policy](08-config-procedures.md#cfg-extrusion-policy) |
| <span id="session-level-policy">**Session-level Policy**</span> | セッション単位の属性（DB user / OS user / 時刻 / source program）で全件評価。IGNORE SESSION / SOFT DISCARD SESSION による sniffer 過負荷対策の中核 | [Policy](#policy), [IGNORE SESSION](#ignore-session) | [cfg-policy-session](08-config-procedures.md#cfg-policy-session) |
| <span id="selective-audit">**Selective Audit Policy**</span> | 特定対象のみログる Policy。フル監査が重い環境で代替策として使用 | [Policy](#policy) | — |
| <span id="rule-action">**Rule Action**</span> | Policy ルール一致時の動作。**ブロッキング系**（S-TAP TERMINATE / S-GATE TERMINATE / DROP / QUARANTINE）/ **アラート系**（Alert Per Match / Alert Daily / Alert Once Per Session） / **ロギング系**（Log Full Details / Log Masked Details / Audit Only / Skip Logging）/ **セッション系**（IGNORE SESSION / SOFT DISCARD / SELECT SESSION）/ **マスク系**（TRANSFORM SOURCE PROGRAM NAME / SET CHARACTER SET / Mask / Replace） | [Policy](#policy), [S-GATE](#s-gate) | [cfg-policy-blocking](08-config-procedures.md#cfg-policy-blocking) |
| <span id="s-gate">**S-GATE**</span> | DB トラフィックを **インライン** で評価し違反時にセッション切断する仕組み。S-TAP 内で動作。**S-GATE TERMINATE** Rule Action と対 | [S-TAP](#s-tap), [Rule Action](#rule-action) | [cfg-policy-blocking](08-config-procedures.md#cfg-policy-blocking) |
| <span id="ignore-session">**IGNORE SESSION**</span> | Session-level Policy の Rule Action。指定セッションを **完全に sniffer から外す**。信頼アプリ / バックアップ / Zabbix 等の除外で sniffer 負荷激減 | [Session-level Policy](#session-level-policy) | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) |
| <span id="quarantine">**QUARANTINE**</span> | 違反ユーザを一定時間隔離（後続接続を弾く）Rule Action。`Quarantine for failed logins` Policy で標準活用 | [Rule Action](#rule-action) | — |
| <span id="policy-analyzer">**Policy Analyzer**</span> | Policy のルール衝突 / 重複 / 評価順問題を解析するツール（Setup > Tools and Views > Policy Analyzer） | [Policy](#policy) | [cfg-policy-build](08-config-procedures.md#cfg-policy-build) |
| <span id="tag-import">**Tag-based Rule Import**</span> | Policy ルールを **tag** で分類して再利用する仕組み。複数 Policy 間でルールセット共有 | [Policy](#policy), [Group](#group) | [cfg-group-define](08-config-procedures.md#cfg-group-define) |

## レポート / 監査プロセス（10 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="audit-process">**Audit Process**</span> | コンプライアンス監査プロセスの自動化単位。Comply > Tools and Views > Audit Process Builder。**Receivers / レビュー / 署名 / 配信 / スケジュール / アーカイブ** を 1 つに集約。CSV / CEF / Syslog / 外部 feed への export 対応 | [Receivers](#receivers), [Compliance Workflow](#compliance-workflow) | [cfg-audit-process](08-config-procedures.md#cfg-audit-process) |
| <span id="receivers">**Receivers**</span> | Audit Process の配信先（個人 / グループ / role / email / ticket）と review/sign 責任設定。**Continuous flag** で順序制御 | [Audit Process](#audit-process) | [cfg-audit-process](08-config-procedures.md#cfg-audit-process) |
| <span id="compliance-workflow">**Compliance Workflow**</span> | 複数 Audit Process を 1 つの workflow にまとめる仕組み。Comply > Tools and Views > Compliance Workflow Automation | [Audit Process](#audit-process), [Distribution Profile](#distribution-profile) | [cfg-compliance-template](08-config-procedures.md#cfg-compliance-template) |
| <span id="smart-assistant">**Smart assistant for compliance monitoring**</span> | PCI-DSS / SOX / HIPAA / NIST / NERC / DORA / NYDFS テンプレートから Policy + Group + Audit Process + Alert + VA を一括生成（12.2 拡張） | [Audit Process](#audit-process), [VA](#va) | [cfg-compliance-template](08-config-procedures.md#cfg-compliance-template) |
| <span id="report-builder">**Query-Report Builder**</span> | 任意の監査データをクエリしてレポートとして登録するビルダ。Predefined common reports / user reports / admin reports をベースにカスタマイズ可能 | [Predefined Reports](#predefined-reports) | — |
| <span id="predefined-reports">**Predefined Reports**</span> | IBM 提供の標準レポート群（user / admin / common）。新規環境構築時の出発点として活用 | [Report Builder](#report-builder) | — |
| <span id="data-compliance-control">**Data Compliance Control**</span> | 12.2 で導入された統合的なコンプライアンス制御単位。複数規制を 1 つの control で管理 | [Smart assistant](#smart-assistant) | [cfg-compliance-template](08-config-procedures.md#cfg-compliance-template) |
| <span id="distribution-profile">**Distribution Profile**</span> | CM から複数 MU へ Audit Process / Policy / 設定を一括配信するプロファイル | [Central Manager](#central-manager) | [cfg-compliance-template](08-config-procedures.md#cfg-compliance-template) |
| <span id="data-lake-reports">**Data Lake Reports**</span> | 12.2.2 で追加された Long-term retention / Data Lake 連携レポート。S3 上のデータをクエリ | [Long-term retention](#long-term-retention) | — |
| <span id="custom-domain">**Custom Domain / Custom Query**</span> | Quick Search / Quick Reports の基盤。任意の表 / 列をドメインとして登録し UI から検索可能に | [Report Builder](#report-builder) | — |

## VA / Discovery / ATA（8 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="va">**VA（Vulnerability Assessment）**</span> | DB の脆弱性 / 構成不備の評価。CIS / STIG / 独自テンプレート対応。12.2.2 で MongoDB Atlas 8.0 / MarkLogic 11/12 / EDB PostgreSQL 17.5 / Db2 (LUW) 12.1 / Oracle MySQL 8.4 等サポート。Microsoft Entra ID 認証（Azure SQL DB）対応 | [VA Scanner](#va-scanner), [CAS](#cas) | [cfg-va-scan](08-config-procedures.md#cfg-va-scan) |
| <span id="va-scanner">**VA Scanner**</span> | VA を実行するワーカ。AWS EKS 上で **Helm Chart** によるコンテナ展開可（12.2.1 以降）。Vulnerability management hub（12.2.1 新 UI）で統合管理 | [VA](#va) | [cfg-va-scan](08-config-procedures.md#cfg-va-scan) |
| <span id="cas">**CAS（Configuration Auditing System）**</span> | DB 構成（パラメータ、ファイル、権限）の変更監査。CAS Agent を DB サーバに導入し、テンプレートに沿って構成変化を継続監視。CAS-based のテストは VA レポートでフィルタ可 | [VA](#va), [S-TAP](#s-tap) | — |
| <span id="discovery">**Sensitive Data Discovery / Classification**</span> | DB 内の機密データを発見・分類。PCI / SOX / HIPAA 等で対象となる機密項目（カード番号、SSN、Canadian SIN 等の特殊パターン）を検出 | [Privacy Set](#privacy-set), [Unified D&C](#unified-dc) | [cfg-discovery-classify](08-config-procedures.md#cfg-discovery-classify) |
| <span id="unified-dc">**Unified Discovery and Classification**</span> | GDP 12.0 以降で利用可能な独立コンポーネント（Data Protection ライセンスに同梱）。従来の Database Discovery と Sensitive Data Discovery を統合 | [Discovery](#discovery) | [cfg-discovery-classify](08-config-procedures.md#cfg-discovery-classify) |
| <span id="privacy-set">**Privacy Set**</span> | Discovery / Classification の結果を保存した集合。Audit Process / Policy で参照可能 | [Discovery](#discovery), [Audit Process](#audit-process) | — |
| <span id="ata">**ATA（Active Threat Analytics）**</span> | 監査データから異常を検出するアナリティクス。12.2 で case 一括クローズ・除外リスト対応。12.2.1 で `list_ata_case_severity` / `list_ata_threat_category` / `update_ata_case_status` API。ポリシールール / 閾値アラートから脅威カテゴリ作成可。**Risk Spotter** 連携でリスクユーザ識別 | [Outliers Mining](#outliers-mining), [Risk Spotter](#risk-spotter) | [cfg-ata-tune](08-config-procedures.md#cfg-ata-tune) |
| <span id="outliers-mining">**Outliers Mining / Behavioral Analytics**</span> | 機械学習ベースの異常検知。通常パターンから外れる DB アクセスを検出 | [ATA](#ata) | [cfg-ata-tune](08-config-procedures.md#cfg-ata-tune) |

## アーカイブ / 保持（6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="daily-archive">**Daily Archive**</span> | Collector の日次アーカイブ（incremental）+ 月初の full archive。**Daily Import → Daily Archive → Daily Purge の順** が重要、順序違反でデータ欠損リスク | [Daily Import](#daily-import), [Daily Purge](#daily-purge) | [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge) |
| <span id="daily-import">**Daily Import**</span> | Aggregator が複数 Collector から daily archive を import する操作。順序は Archive → Import → Purge | [Daily Archive](#daily-archive), [Aggregator](#aggregator) | [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge) |
| <span id="daily-purge">**Daily Purge**</span> | 保持期間（既定 Collector=15 日 / Aggregator=30 日）超過データを削除。**Archive 完了 + Aggregator Import 完了の確認後に Purge** が原則 | [Daily Archive](#daily-archive) | [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge) |
| <span id="long-term-retention">**Long-term retention**</span> | S3 互換オブジェクトストレージへの cold storage。`grdapi configure_complete_cold_storage` で構成。12.2 統合 API | [Daily Archive](#daily-archive), [Edge Gateway](#edge-gateway) | [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge) |
| <span id="data-export">**Data Export**</span> | Aggregator が Collector / 他 Aggregator から static + dynamic データを export する操作。Aggregator archive は Collector へ復元 **不可**（逆は可） | [Daily Archive](#daily-archive) | [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge) |
| <span id="nanny">**nanny**</span> | 内部 DB / `/var` の使用率を監視し 90% 超でサービス停止する保護プロセス。`auto_stop_services_when_full` で挙動制御 | [Internal DB](#internal-db), [auto_stop_services_when_full](#auto-stop) | [inc-disk-full](09-incident-procedures.md#inc-disk-full) |

## アクセス制御 / ユーザ管理（6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="access-manager">**Access Manager**</span> | UI / API の権限管理。Setup > Tools and Views > Access Management（12.2.2 で再設計、tab レイアウト）。Roles / Groups / Users / Default roles | [Default Roles](#default-roles), [LEGACY_ACCESSMGR_ENABLED](#legacy-accessmgr) | [cfg-rbac-design](08-config-procedures.md#cfg-rbac-design) |
| <span id="default-roles">**Default Roles**</span> | admin / inv / user / cli / accessmgr / dbaccess 等の標準ロール。「Access for default roles and applications」で標準権限定義 | [Access Manager](#access-manager) | [cfg-rbac-design](08-config-procedures.md#cfg-rbac-design) |
| <span id="legacy-accessmgr">**LEGACY_ACCESSMGR_ENABLED**</span> | 12.2.2 で旧 Access Manager UI に戻す GUARD_PARAM。`grdapi MODIFY_GUARD_PARAM paramName=LEGACY_ACCESSMGR_ENABLED paramValue=1` | [Access Manager](#access-manager) | [cfg-rbac-design](08-config-procedures.md#cfg-rbac-design) |
| <span id="api-only-user">**API-only User**</span> | 12.2 で導入された UI ログイン不可・GuardAPI のみ可能なユーザ種別。自動化スクリプトの最小権限実装に活用 | [Access Manager](#access-manager) | — |
| <span id="group">**Group**</span> | Policy / Audit Process / Group が参照する IP / User / Object / Command 等のセット。**populate**（クエリベース自動更新）と **manual**（手動）の 2 種 | [Policy](#policy), [Audit Process](#audit-process) | [cfg-group-define](08-config-procedures.md#cfg-group-define) |
| <span id="datasource">**Datasource**</span> | VA / Audit Process / Classification が参照する DB 接続定義。`grdapi create_datasource` または UI で登録 | [VA](#va), [Audit Process](#audit-process) | [cfg-datasource-register](08-config-procedures.md#cfg-datasource-register) |

## 連携 / 外部接続（6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="universal-connector">**Universal Connector (UC)**</span> | ログベースで DB / クラウドサービスから監査データを取り込むコネクタ。AlloyDB / Milvus / Singlestore / Sybase / Snowflake / SAP HANA / Teradata 等のプリインストールプラグイン。CloudWatch / JDBC / Kafka source、CSV bulk upload 対応 | [Edge Gateway](#edge-gateway) | [cfg-cloud-monitoring](08-config-procedures.md#cfg-cloud-monitoring) |
| <span id="qradar-cef">**QRadar / SIEM 連携（CEF / LEEF / Syslog）**</span> | アラートを CEF / LEEF / Syslog で外部 SIEM（QRadar、Splunk）へ転送する仕組み | [Audit Process](#audit-process) | [cfg-alert-route](08-config-procedures.md#cfg-alert-route) |
| <span id="guardium-insights">**Guardium Insights**</span> | クラウド側で DGM / Reports / Long-term retention を統合管理する SaaS 製品。GDP との接続経路は Edge Gateway / Aggregator → Insights Cloud | [Long-term retention](#long-term-retention), [Edge Gateway](#edge-gateway) | — |
| <span id="risk-spotter">**Risk Spotter**</span> | リスクユーザ / DB 識別。ATA と連携してリスクの高い DB / ユーザを優先表示 | [ATA](#ata) | — |
| <span id="executive-dashboard">**Investigation Dashboard / Executive Dashboard**</span> | セキュリティ責任者向けダッシュボード。Executive dashboard は Today/Last 3/7/14 days のフィルタ、USD ベース cost saving、ROI 計算式の透明化、appliance / S-TAP の健全性可視化を提供。Investigation Dashboard はフィルタ保存に対応 | [ATA](#ata), [Reports](#predefined-reports) | — |
| <span id="gcm">**GCM（Guardium Cryptography Manager）**</span> | 証明書 / 暗号鍵管理。12.2.1 で `get_certificates` GuardAPI 追加。`show certificate stored` / `show certificate exceptions` CLI、proxy CA 証明書 import 対応（`store certificate keystore trusted console`） | [Certificate](#certificate) | [cfg-cert-rotation](08-config-procedures.md#cfg-cert-rotation) |

## 性能 / 障害対応（8 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="buffer-free">**Buffer Free (%)**</span> | Inspection Engine / Sniffer のバッファ空き率。低下は sniffer overload の早期警報 | [Sniffer](#sniffer), [Inspection Engine](#inspection-engine) | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) |
| <span id="sniffer-overload">**Sniffer Overload**</span> | Sniffer が S-TAP からの流量を捌ききれず buffer 満杯 → restart ループに陥る状態。**IGNORE SESSION** で信頼アプリを除外、`Ignored Ports List` でポート除外、`Log Records Affected` 無効化が定石 | [Sniffer](#sniffer), [IGNORE SESSION](#ignore-session) | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) |
| <span id="auto-stop">**auto_stop_services_when_full**</span> | 内部 DB / `/var` 使用率 90% 超で nanny がサービス停止する保護機構。CLI: `store auto_stop_services_when_full <on/off>` | [nanny](#nanny), [Internal DB](#internal-db) | [inc-disk-full](09-incident-procedures.md#inc-disk-full) |
| <span id="must-gather">**must_gather**</span> | IBM サポート提出用の付属情報一括収集。`support must_gather full` で `/var/log/guard/` 配下に tar.gz | [fileserver](#fileserver) | [inc-stap-conn-fail](09-incident-procedures.md#inc-stap-conn-fail) |
| <span id="fileserver">**fileserver**</span> | appliance に対して時間制限付き HTTPS ファイルサーバを開いてパッチ / 証明書 / must_gather 出力を授受する CLI。`fileserver 30 10.0.0.0/24` で 30 分開く | [must_gather](#must-gather) | [cfg-patch-install](08-config-procedures.md#cfg-patch-install) |
| <span id="parse-tree">**Parse Tree**</span> | Inspection Engine が SQL を分解した構文木。**Sentence / Request / Command / Object / Field** に展開され、Policy 評価の対象 | [Inspection Engine](#inspection-engine) | — |
| <span id="consolidated-installer">**consolidated_installer.sh**</span> | DB サーバ側で S-TAP + GIM client をワンショットでインストールするスクリプト | [S-TAP](#s-tap), [GIM](#gim) | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) |
| <span id="certificate">**証明書（Trusted / Appliance / Web）**</span> | appliance / CM / S-TAP 間の SSL 通信に使う証明書。GCM で管理、`get_certificates` で一覧、proxy CA は `store certificate keystore trusted console` で import | [GCM](#gcm) | [cfg-cert-rotation](08-config-procedures.md#cfg-cert-rotation) |

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
