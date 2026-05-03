# IBM Workload Automation — 概要

IBM Workload Automation (TWS) — 製品概要

ChromaDB 投入済みの IBM Workload Automation V10 系マニュアル (28,951 chunks / 34 sources、PDF 28本 + Web 6本) から構造化抽出した製品サマリ。 各記述末尾の [SX] は出典 ID (06_出典一覧 を参照)。

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM Workload Automation (旧 Tivoli Workload Scheduler / TWS)  [S1, S6] | S1, S6 |
| 製品ファミリ | IBM Workload Scheduler (distributed: MDM + 各種 Agent) / IBM Z Workload Scheduler (z/OS 系) / Dynamic Workload Console (Web UI) / AI Data Advisor (AIDA) / Workload Automation Programming Language (WAPL) で構成される統合ワークロード自動化スイート。  [S1, S25, S4, S3] | S1, S25, S4, S3 |
| ベンダ | IBM Corporation (V10 系 IWS は HCL Technologies が共同開発・サポート)  [S11, S32] | S11, S32 |
| プログラム番号 | 5698-T09 (IBM Workload Automation V10)  [S1, S11, S26] | S1, S11, S26 |
| 対象バージョン (本資料) | V10.1 Fix Pack 6 (PDF) + V10.1.0 / V10.2.0 / V10.2.1 / V10.2.5 (Web Release Notes)  [S1, S33, S34, S32, S31] | S1, S33, S34, S32, S31 |
| 製品の役割 | エンタープライズ向け統合ジョブスケジューラ。事前定義した Job / Job Stream を Symphony ファイル (Production Plan) ベースで日次実行・依存解決・リトライ・通知制御し、 AIX/Linux/Windows/IBM i/z/OS 等の混在環境を Master Domain Manager (MDM) 中心の 階層型ネットワーク + Dynamic Agent プールで一元運用する。  [S1, S6, S11] | S1, S6, S11 |
| 主要コンポーネント (一言) | Master Domain Manager / Backup Master / Dynamic / Backup Dynamic Domain Manager / Fault-Tolerant Agent (FTA) / Dynamic Agent (DA) / Z Workload Scheduler Agent / Dynamic Workload Console (DWC) / AIDA / WebSphere Application Server Liberty。  [S33, S1, S14] | S33, S1, S14 |
| 想定読者 | バッチ運用設計者、ジョブネット管理者、DevOps エンジニア、 z/OS バッチを保有する金融・製造系ミッションクリティカル運用担当者、AIOps 担当者 (AIDA 利用想定)。  [S1, S11, S4, S26] | S1, S11, S4, S26 |
| 対応 OS (MDM/DWC) | Linux (RHEL/SLES/Ubuntu)、Windows、AIX (V10.2.3 以降は AIX 上の MDM/DWC は非サポート)、z/OS。 Agent は IBM i, HP-UX, Solaris SPARC など追加 OS をサポート。  [S34, S32, S33] | S34, S32, S33 |
| アプリケーションサーバ | WebSphere Application Server Liberty Base 25.0.0.6 以上 (z/OS DWC は 25.0.0.3 以上)。継続デリバリモデル。  [S32] | S32 |
| 暗号化通信 | V10.1 以降 TLS 1.0/1.1 廃止、TLS 1.2 のみ既定有効。 V10.1.0 で fault-tolerant agent の Automatic SSL configuration、 Automatic encryption at rest (鍵製品ファイルの自動暗号化) が導入。  [S33, S1, S11] | S33, S1, S11 |
| 主要 Java 前提 | Java 11 (V10.1 以降 Java 8 → Java 11 へ変更。HP-UX / Solaris SPARC は OS 提供 Java を利用)。  [S33] | S33 |
| DB 前提 | DB2 / Oracle / MS SQL Server / Azure SQL / Google Cloud SQL for SQL Server / OneDB (V9.5 FP4 以降で Azure SQL、V10.1 で Google Cloud SQL を追加)。  [S1, S33] | S1, S33 |
| プラグイン拡張 | V10.1 で 80+、V10.2 で 100+ プラグインが Automation Hub から提供。 既定インストールから多くを除外、必要なものを Hub からダウンロードする方式へ変更。  [S33, S34] | S33, S34 |
| REST API / 開発者向け | REST API V2 (V10.1.0 で導入), Orchestration CLI, Orchestration Query Language (OQL), API Keys / JSON Web Token (JWT) 認証, Driving IWA / Extending IWA ガイドあり。 SOAP Web Services および Remote EJB は V10.1 で REST へ置換され廃止。  [S1, S26, S28, S33] | S1, S26, S28, S33 |
| AI 機能 | AI Data Advisor (AIDA): KPI ベースで異常検知 (Anomaly Detection) を行いダッシュボード表示。 MDM/DDM/DWC 各 V10.1 と組み合わせて利用、別パッケージで配布。  [S4, S33, S1, S29, S30] | S4, S33, S1, S29, S30 |
| コンテナ / クラウド対応 | Docker compose / Red Hat OpenShift / Amazon ECS / AWS EKS / Azure AKS / IBM Cloud Private。 V10.1 で AWS ECS 上の IWS コンテナサポート文書化。  [S33, S34, S1] | S33, S34, S1 |
| V10.1 で削除された機能 | Extended Agent for MVS / Application Lab / Option Editor / IBM Tivoli Monitoring 系統合 (ITM, ITNM, TBSM, NetView, TSM, Service Desk, TSAMP, TPM) / BigFix Fixlets / OSLC / SOAP / Remote EJB / Job Duration Prediction プラグイン 他。  [S33] | S33 |
| ライセンスモデル | perServer (既定) / perJob などの licenseType / defaultWksLicenseType を optman で選択。 変更前に IBM 営業 (sales representative) と要相談。  [S11] | S11 |
| ドキュメント形態 | 公式 IBM Docs Web + PDF。本 Excel では英語 PDF 28 本 + Web Release Notes 6 本を出典として参照。  [S1, S33, S34, S5, S7, S8, S13] | S1, S33, S34, S5, S7, S8, S13 |
| 関連製品 (密結合) | IBM Z Workload Scheduler (z/OS 側 Controller / Tracker), WebSphere Application Server Liberty, Db2 / Oracle / MS SQL, AI Data Advisor, IBM Automation Hub プラグイン群。  [S1, S11, S4] | S1, S11, S4 |

