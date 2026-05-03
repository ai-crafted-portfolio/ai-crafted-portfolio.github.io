# IBM Guardium Data Protection 12.x — 関連製品連携

IBM Guardium Data Protection 12.x — 関連製品連携 / 依存関係

| 連携先製品 | 連携の種類 | 設定要点 | 出典 |
|---|---|---|---|
| IBM Db2 (LUW / z/OS) 12.1 / 11.5 等 | 監視対象 DB | Linux/UNIX/Windows S-TAP の Inspection Engine で Db2 protocol を選択。z/OS は S-TAP for DB2 on z/OS（024）。VA は Db2 12.1 をサポート（12.2.2）。Db2 for z/OS JDBC driver は 12.2 で 4.33.x 化（要 license 確認） | S24, S2, S29 |
| Oracle Database / Oracle ASO | 監視対象 DB | Oracle 監視は標準 S-TAP で対応。Oracle Advance Security Option (ASO) の暗号化トラフィックは A-TAP で復号取得、aso_enabled パラメータで複数 Collector 分散。VA で Oracle 19c STIG benchmark 対応（12.1）。Oracle Unified Auditing は Record Empty Sessions が非対応 | S2, S84 |
| Microsoft SQL Server / Azure SQL DB | 監視対象 DB | 標準 S-TAP で対応。VA で CIS MSSQL 2022 1.0 対応（12.1）、Microsoft Entra ID 認証（Azure SQL）対応（12.2.2）。Microsoft SQL Server on AWS / Azure 用 Universal Connector JDBC コネクタ提供（12.2.1） | S2 |
| Splunk / SIEM 全般（Syslog / CEF / Custom export） | ログ転送・SIEM 連携 | Audit Process の export 機能で Syslog / CSV / CEF / external feed 形式で外部出力。Policy の Alert action と組み合わせ Splunk / QRadar / ArcSight 等へ転送可。Predefined common reports や Threshold Alerter Status を Custom Report として export することで SIEM 側ダッシュボード化が可能 | S17, S18, S89, S22 |
| ServiceNow / IT Service Management | チケット連携・SOX reconciliation | Audit Process の receivers として ticket を選択可（External ticketing system 設定が前提）。12.2 で SOX ticket reconciliation（生成 AI による change ticket と user activity log の自動突合）対応 | S89, S2 |
| AWS / Azure / GCP / OpenShift / K3s | クラウド展開・コンテナ化 | Edge Gateway 2.1 を AWS EKS / OpenShift / K3s 上に Terraform で展開可。VA Scanner も Kubernetes 上 Helm Chart 化。Red Hat OpenShift Virtualization 上の Guardium 仮想アプライアンス展開対応（12.2）。AWS / Azure 上 DB streaming を Edge Gateway で処理 | S2 |
| S3 互換オブジェクトストレージ（AWS S3 / 互換ストレージ） | アーカイブ／バックアップ／長期保持 | 12.2.1 で archive / backup / restore が S3 互換に対応（旧 Amazon ECS は S3 Compatible へ改名）。CyberArk と組み合わせ S3 アクセスのテンポラリクレデンシャル運用可 | S2 |
| CyberArk | シークレット管理 | Backup / Archive 時の S3 アクセスにテンポラリクレデンシャルを利用、master secret の漏洩を防止 | S2 |
| Active Directory / LDAP | 認証連携 | Guardium UI / API 認証を AD/LDAP に委任。Access Manager（12.2.2 で再設計）でユーザ・ロール・アプリの集中管理。Multi-factor authentication 対応 | S55, S2, S19, S20, S56 |
| MongoDB / EDB PostgreSQL / Postgres / MariaDB / Yugabyte / Redis / SAP HANA / Sybase / Snowflake / AlloyDB / Milvus / Singlestore / Teradata | 監視対象 DB / Universal Connector | 12.2.x で各 DB の S-TAP・VA 対応バージョンが拡充。Universal Connector のプリインストールプラグインで AlloyDB / Milvus / Singlestore / Sybase / Snowflake / SAP HANA / Teradata 等へ JDBC / Kafka / CloudWatch ベースで接続 | S2, S36 |
| Hadoop / Big Data / Cloudera / Hortonworks Atlas | 監視対象 Big Data 基盤 | Ranger HDFS for Hortonworks/Cloudera 7 が Atlas service と統合（12.1）。Hadoop integration では log records affected 機能は非対応 | S2, S84 |
| IBM Guardium Data Security Center (SaaS) | 上位 SaaS 連携 | Edge Gateway 経由で Data Security Center SaaS へ送信、long-term retention や中央化された脅威分析を SaaS 側で利用可 | S2 |
| Unified Discovery and Classification (UDC) | 発見・分類の統合 | UDC v1.1 (12.2.2) は GDP 12.0 以降と組合せ可。SaaS / オンプレ / クラウドアプリの機密データ自動発見と分類を提供（GDP ライセンスに同梱） | S2, S47 |
| Risk Spotter | リスクユーザ評価 | Active Threat Analytics ダッシュボードに統合され、リスクユーザの特定と調査を支援（12.2） | S48, S2 |

