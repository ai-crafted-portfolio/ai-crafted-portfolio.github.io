# IBM Workload Automation — 関連製品連携

IBM Workload Automation — 関連製品連携と公式統合

| 連携先製品 | 区分 | 連携内容 | 提供形態 | 備考 | 出典 |
|---|---|---|---|---|---|
| IBM Z Workload Scheduler (Controller / Tracker) | コア製品ファミリ | z/OS スケジューラと distributed IWS の E2E (Fault Tolerance / z-centric) 連携 | Z Workload Scheduler Connector + Z Workload Scheduler Agent | Memo to Users / Customization and Tuning / E2E ガイド・WAPL ガイドが詳細 | S16, S18, S23, S24, S25 |
| WebSphere Application Server Liberty Base | ランタイム | MDM/DWC のアプリケーションサーバ。継続デリバリで月次更新 | 同梱 | 25.0.0.6+ 必須。24.0.0.8+ では verifyHostname=false 等の設定回避策あり | S32, S33 |
| IBM Db2 / Oracle / Microsoft SQL Server | DB | MDM / DWC のリポジトリ DB | 外部 DB | Db2 transaction log full / Oracle 切替後の Dynamic Workload Broker 未起動など固有の障害ノウハウあり | S9, S15, S13 |
| Azure SQL Database | DB (Cloud) | V9.5 FP4 以降で公式サポート | 外部 DB (Cloud) | Cloud-managed のため backup/restore 戦略が異なる | S1 |
| Google Cloud SQL for SQL Server | DB (Cloud) | V10.1.0 で正式サポート | 外部 DB (Cloud) | Multi-region / read replica 構成は別途要設計 | S33, S1 |
| OneDB (HCL OneDB) | DB | HCL OneDB を MDM/DWC のリポジトリとして利用可能 (V9.5 FP4+) | 外部 DB | HCL 共同サポート対象 | S1 |
| AI Data Advisor (AIDA) | AI 拡張 | KPI 異常検知。MDM/DDM/DWC 各 V10.1 と組合せ。別パッケージ | 別配布 (download page) | 互換は同 V10.1 のみ。compatibility table を要確認 | S4, S33 |
| IBM Automation Hub プラグイン | プラグイン | 100+ プラグイン (SAP / Salesforce / Oracle EBS / Sterling Connect:Direct / WebSphere MQ / RESTful 等) | Hub からダウンロード | V10.1 から default インストール除外。Apache Spark / Cloudant / MQTT / Oozie / IBM i など多数 | S1, S33, S34, S5 |
| ServiceNow | ITSM | Event-driven workload automation でインシデント自動起票 | プラグイン | back-level switcheventprocessor 環境では発火停止する既知問題 | S1, S33 |
| PowerHA SystemMirror / HACMP (AIX) | HA 統合 | MDM / Agent を HACMP リソースグループに組み込んで standby/takeover | HA Cluster Environments ガイド | Shared disk + Service IP 構成。physical components of an HACMP cluster セクション | S14 |
| Microsoft Cluster Service (MSCS) | HA 統合 | Windows 上で MSCS と Cluster Enabler 連携 | Cluster Enabler + twsClusterAdm | Resource Dependencies tab / Cluster Administrator 拡張 | S14 |
| Red Hat OpenShift / Docker / Kubernetes | コンテナ | Workload Automation Agent / MDM のコンテナ配備 | Helm / docker-compose / Operator | V10.1.0 で AWS EKS / Azure AKS / IBM Cloud Private 上の正式サポート文書化 | S33, S1 |
| Amazon ECS / AWS EKS / Azure AKS / IBM Cloud Private | コンテナ (Cloud) | コンテナ実行基盤での MDM/DWC ホスティング | 公式コンテナイメージ | AWS ECS は V10.1 から support statement 追加。各 Cloud 固有の network/storage 設定が必要 | S33 |
| OpenID Connect Provider | 認証 | DWC の Identity Provider として OIDC 利用 (V9.5 FP1+) | 標準 OIDC 設定 | Liberty の OIDC feature を利用 | S1, S33, S29, S30, S31 |
| Prometheus / Grafana | 監視 | WS パフォーマンスメトリクスを Prometheus でスクレイプ、Grafana でダッシュボード化 | 公式 endpoint + テンプレ | V9.5 FP3 で導入 | S1 |
| IBM UrbanCode Deploy | DevOps | アプリ配備パイプライン中で IWS ジョブ実行をオーケストレーション | プラグイン | V9.5 系で連携機能追加 | S1 |
| BigFix / Fixlet (廃止) | 従来連携 (廃止) | BigFix 用 Fixlets は V10.1 で除外、サンプルは GitHub にあり | — | IWS 自体に同梱されていた連携は廃止 → GitHub サンプル参照 | S33 |
| IBM Tivoli Monitoring 系 (廃止) | 従来連携 (廃止) | ITM/ITNM/TBSM/NetView/TSM/Service Desk/TSAMP/TPM 等の統合は V10.1 で削除 | — | OSLC, SOAP Web Services, Remote EJB も同時廃止 (REST に置換) | S33 |

