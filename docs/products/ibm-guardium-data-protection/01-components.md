# IBM Guardium Data Protection 12.x — 構成要素

IBM Guardium Data Protection 12.x — 構成要素（コンポーネント・機能ブロック）

各コンポーネント記述の末尾「出典」列に [SX] 形式の出典 ID（06_出典一覧 参照）。

| コンポーネント名 | 役割 | 主要機能 | 関連サブシステム | 出典 |
|---|---|---|---|---|
| Collector | DB トラフィックを直接受信して解析・ログ化する基本アプライアンス | S-TAP からの DB セッション／SQL 受信、Inspection Engine による SQL 構文解析、リアルタイムポリシー評価、内部 DB へ監査データ書き込み（既定容量 Collector = 15 日推奨）。最大 50 Inspection Engine を搭載可能 | S-TAP / Sniffer / Inspection Engine / Internal DB | S4, S84, S81, S92 |
| Aggregator | 複数 Collector の監査データを集約しレポートする統合ノード | 各 Collector からの daily import を受け、長期保持／レポート／監査プロセス実行を担う。Guardium 12.2.1 で Parallel Query option（partition-aware routing と temporary staging table）による並列クエリ高速化対応。S3 互換ストレージへのバックアップ／アーカイブ対応 | Collector / Central Manager / S3 互換 | S43, S2, S81, S75 |
| Central Manager (CM) | Guardium 環境全体の集中管理点 | Managed Unit に対する patch / 証明書配布、ポリシー一括配布、ユーザ・ロール・グループ管理。Inspection Engine は CM 上では作成・実行不可（Collector からのみ実行）。Enterprise Hub（旧 Cross-CM Health View）で複数 CM を横断管理可 | Aggregator / Collector / Patch Mgmt | S43, S84, S2, S90 |
| S-TAP（Software TAP / DB エージェント） | DB サーバ上で DB トラフィックをキャプチャし Collector へ転送するエージェント | Linux/UNIX / Windows / IBM i / z/OS（DB2 / IMS / Datasets）に対応。K-TAP（Kernel TAP）でカーネルレベル取得、A-TAP は SSL/TLS 暗号化済トラフィック復号取得（Oracle ASO / Redis 対応）。collaborate_kerberos_enabled / aso_enabled / VERDICT_RESUME_DELAY / PCRE_REGEX_ENABLED 等のパラメータあり | K-TAP / A-TAP / GIM / Collector | S24, S35, S2 |
| External S-TAP | コンテナ／クラウド向けの外部 S-TAP（DB サーバ非変更型） | DB サーバへエージェントを入れずプロキシ的にトラフィックを取得。Edge Gateway 2.1 と組み合わせ Windows S-TAP / External S-TAP からのストリーミングに対応 | Edge Gateway / Collector | S2 |
| GIM (Guardium Installation Manager) | S-TAP／CAS／関連エージェントの集中インストール／更新／監視 | DB サーバに guard_gimd（perl 駆動の常駐デーモン）として動作。consolidated_installer.sh で GIM client + S-TAP を一括導入。SHA1 / SHA256 証明書での GIM 通信もサポート（GIM 12.2 系） | S-TAP / consolidated_installer / 証明書 | S34, S35, S2 |
| Sniffer / Inspection Engine | ネットワークパケットから SQL を抽出し Parse Tree を生成 | Sentence／Request／Command／Object／Field を識別し内部 DB へログ。ポリシ評価のリアルタイムフロント。DB Client IP/Mask / DB Server IP/Mask / Port を engine 単位で定義。Buffer Free（％）モニタ、records affected の閾値（store max_results_set_size / max_result_set_packet_size / max_tds_response_packets）あり | Collector / Internal DB | S84, S76, S8, S39 |
| Discovery（Sensitive Data Discovery / Classification） | DB 内の機密データを発見・分類するコンポーネント | DB を走査し、PCI / SOX / HIPAA 等で対象となる機密項目（カード番号、SSN、Canadian SIN 等の特殊パターン）を検出。Unified Discovery and Classification は Guardium Data Protection 12.0 以降で利用可（独立コンポーネント、Data Protection ライセンスに同梱） | Classification / Policy / VA | S46, S47, S2 |
| Vulnerability Assessment (VA) / VA Scanner | DB の脆弱性・構成不備の評価 | MongoDB Atlas 8.0 / MarkLogic 11/12 / EDB PostgreSQL 17.5 / Db2 (LUW) 12.1 / Oracle MySQL 8.4 等を 12.2.2 でサポート。Microsoft Entra ID 認証 (Azure SQL DB) 対応。VA Scanner は AWS EKS 上で Helm Chart によるコンテナ展開可（12.2.1 以降） | Classification / Policy | S28, S29, S2 |
| Active Threat Analytics (ATA) | 監査データから異常を検出するアナリティクス | 12.2 で case 一括クローズ／除外リスト対応。12.2.1 で list_ata_case_severity / list_ata_threat_category / update_ata_case_status API。ポリシールール／閾値アラートから脅威カテゴリ作成可。Risk Spotter 連携でリスクユーザ識別 | Investigation Dashboard / Policy | S48, S2 |
| CAS (Configuration Auditing System) | DB 構成（パラメータ、ファイル、権限）の変更監査 | CAS Agent を DB サーバに導入し、テンプレートに沿って構成変化を継続監視。CAS-based のテストは VA レポートでフィルタ可 | S-TAP / VA / Compliance | S59, S2 |
| Edge Gateway 2.x | Kubernetes ベースの新世代モニタリングパイプライン | Aggregator / Data Security Center SaaS / Long-term retention に統合可。AWS EKS / OpenShift / K3s に Terraform で展開、外部レジストリ対応（air-gapped）。S-TAP からの直接ストリーミング、AWS / Azure 上の DB streaming 処理対応 | S-TAP / Aggregator / Long-term retention | S2 |
| Universal Connector (UC) | ログベースで DB／クラウドサービスから監査データを取り込むコネクタ | AlloyDB / Milvus / Singlestore / Sybase / Snowflake / SAP HANA / Teradata 等のプリインストールプラグインを提供。CloudWatch / JDBC / Kafka source による接続、CSV bulk upload 対応。CM から一元設定可 | Edge Gateway / Aggregator | S2 |
| Audit Process Builder | コンプライアンス監査プロセスの自動化 | Comply > Tools and Views > Audit Process Builder。Receivers／レビュー／署名／配信／スケジュール／アーカイブを 1 つに集約。CSV / CEF / Syslog / 外部 feed への export 対応、12.1 で custom email template 対応。store save_result_fetch_size CLI で remote source 結果上限変更可 | Compliance / Reports | S17, S89 |
| Internal Database / Internal Load Balancer (ILB) | 監査データ格納用内部 DB と内部 LB | ディスク使用率 90% で nanny プロセスがサービス停止（auto_stop_services_when_full）。ILB は Managed Unit の負荷を予測し session を分散、データ損失を低減。/var パーティションが既定の格納先 | Collector / Aggregator / nanny | S79, S2 |
| GuardAPI / REST API | Guardium 操作の API 入口 | get_certificates / update_engine_config / change_cli_password / list_ata_case_severity 等多数。12.2 で Guardium API 専用ユーザ（UI 不可）作成対応。configure_complete_cold_storage（long-term retention）等あり | CLI / Audit Process / VA | S72, S2, S64, S65, S44, S67, S70, S71 |
| Guardium Cryptography Manager (GCM) | 証明書／暗号鍵管理 | 12.2.1 で get_certificates GuardAPI 追加。show certificate stored / show certificate exceptions CLI、proxy CA 証明書 import 対応（store certificate keystore trusted console） | Certificate / CLI | S2, S83, S37 |
| Investigation Dashboard / Executive Dashboard | セキュリティ責任者向けダッシュボード | Executive dashboard は Today/Last 3/7/14 days のフィルタ、USD ベース cost saving、ROI 計算式の透明化、appliance / S-TAP の健全性可視化を提供。Investigation Dashboard はフィルタ保存に対応 | ATA / Reports | S2, S77, S7, S6 |

