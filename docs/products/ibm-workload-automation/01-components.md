# IBM Workload Automation — 構成要素

IBM Workload Automation — 構成要素 (コンポーネント・機能ブロック)

各コンポーネント記述の末尾「出典」列に [SX] 形式の出典 ID (06_出典一覧 参照)。

| コンポーネント名 | 種別 | 役割 | 主要機能 / 配置プロセス | 関連サブシステム | 出典 |
|---|---|---|---|---|---|
| Master Domain Manager (MDM) | 管理ノード (1台) | ネットワーク全体の管理ハブ。データベース更新、Plan 生成、各 Domain Manager への伝搬 | JnextPlan で日次 Symphony を生成、netman/mailman/batchman/jobman を起動。WebSphere Application Server Liberty Base 上で REST API を提供 | Symphony, optman, JnextPlan | S6, S11, S33 |
| Backup Master Domain Manager | 管理ノード (バックアップ) | MDM の代替を担う full-status / fault-tolerant Agent。Automatic Failover の対象 | enAutomaticFailover=yes 時に MDM 障害で自動昇格。workstationMasterListInAutomaticFailover で候補指定 | Symphony, RSCT 不要 (TWS 独自) | S6, S11, S14 |
| Domain Manager (DM) | 中継ノード | 下位ドメインのエージェントとの全通信を中継するハブ | 階層型ネットワークの非ルートドメインに配置。MDM ← DM ← FTA/DA という階層を構成 | Fault-tolerant Agent (full status) | S6, S14 |
| Dynamic Domain Manager (DDM) | Dynamic 中継ノード | Dynamic Agent ネットワークの管理ハブ | MDM と Dynamic Agent の中間に配置。Backup Dynamic Domain Manager と組み合わせ可。Dynamic Workload Broker を内包 | Dynamic Workload Broker, Resource Advisor | S6, S11 |
| Fault-Tolerant Agent (FTA) | 実行ノード (FT) | Symphony を保有しオフライン時もスケジュール継続実行できる耐障害性エージェント | batchman (依存解決) / jobman (ジョブ起動) / mailman (連絡) / writer (受信) / netman (常駐) を実装。pobox 既定 10MB | Symphony, conman | S6, S11, S15 |
| Dynamic Agent (DA) | 実行ノード (動的) | Symphony を保有せず、Resource Advisor 経由で MDM/DDM の指示を受け Pool/Dynamic Pool で動的にジョブ実行 | プールでの動的選択、JSDL ベースのジョブ定義に対応。enAddWorkstation=yes で Symphony 自動追加 | Dynamic Workload Broker, JSDL | S6, S11, S33 |
| Z Workload Scheduler Agent (ZWS Agent) | 実行ノード (z/OS) | z/OS 上で動作し JES/JES2/JES3 ジョブを発行・追跡するエージェント | Started Task として稼働。EELUX000/EELUX002 等の exit 利用、SMF パラメータ要更新、SYS1.PROCLIB 配置 | JES2/JES3, RACF, SMF | S12, S24, S27 |
| Z Workload Scheduler Controller / Tracker | z/OS 側スケジューラ | z/OS ネイティブのスケジューラ。E2E (Fault Tolerance / z-centric) で IWS と連携 | Programming Language WAPL でジョブストリーム自動生成、Memo to Users / Customization and Tuning に運用詳細 | JES, RACF, optional Connector | S16, S18, S23, S19, S20, S21, S22 |
| Dynamic Workload Console (DWC) | Web UI | 全体運用 GUI。Plan / Object 管理、Self-Service Catalog、Workload Designer、Workload Dashboard | WebSphere Liberty Base 25.0.0.6 以上で稼働。REST API V2 を内部利用。OpenID Connect 認証可 | REST API, Liberty, LDAP/SSO | S3, S32, S33 |
| AI Data Advisor (AIDA) | AI 異常検知 | Workload Scheduler の KPI を継続学習し anomaly を可視化 | AIDA Detailed System Requirements に従い別パッケージ配布。MDM/DDM/DWC V10.1 以降と互換 | DWC ダッシュボード | S4, S33 |
| Symphony / Sinfonia ファイル | プランデータ | 日次の production plan を保持するワークステーション間で配布される実行計画 | JnextPlan が DB から生成 → Sinfonia 経由で各 Agent へ配布。corruption 時は MDM 側コピーで上書き復旧 | JnextPlan, stageman, mailman | S11, S15, S6 |
| プロセス: netman | デーモン (常駐) | TCP/IP 接続を待ち受け mailman/writer をフォーク | nm port (default 31111) で待機。conman shut;wait → StartUp で再起動 (localopts 反映条件) | TCP/IP, conman, StartUp | S11, S15 |
| プロセス: mailman | デーモン | ネットワーク間メッセージ送受信、リンク管理 | mm response / mm cache mailbox / autostart monman で挙動制御 | pobox, batchman | S11 |
| プロセス: batchman | デーモン | 依存関係を解決して jobman に起動指示 | bm check file / bm look / bm read / bm check until / bm check deadline で評価周期を決定 | Symphony, jobman | S11 |
| プロセス: jobman | デーモン | 実ジョブを起動・監視し終了コードを batchman へ報告 | jm load user profile / jm nice / jm promoted nice / jm no root などで挙動制御 | Symphony, OS スケジューラ | S11 |
| プロセス: writer | デーモン | リモート mailman からのメッセージを書き込み | wr read / wr unlink / wr enable compression。圧縮機能で回線負荷を低減 | mailman, pobox | S11 |
| Composer | CLI | DB 上のオブジェクト (Workstation/Job/Job Stream/Calendar/Resource 等) を管理する CLI | composer add / replace / display / li ws @;showid / delete。V10.1 から folder 構造をサポート | REST API (内部呼出) | S11, S6, S15 |
| Conman | CLI | Plan (Symphony) を操作する CLI。状態確認、リトライ、cancel、submit、link/unlink | conman shut;wait;StartUp で TWS デーモン再起動。switch sym prompt 等のプロンプト設定可 | Symphony, netman | S11, S15 |
| Planman | CLI | preproduction plan の操作、event rule deploy | planman deploy / planman showinfo。deployment frequency は globalopt で 0-60 分指定 | preproduction plan, event rules | S11, S15 |
| Optman | CLI | global options (DB 内設定) の参照・変更 | optman ls / optman show <short> / optman chg <name> <value>。auditStore 等のキー変更で挙動切替 | DB (TWS schema) | S11 |
| JnextPlan | コマンド (バッチ) | preproduction plan から新しい Symphony (production plan) を作成 | MakePlan/CreatePostReports/Updatestats/rep8 を内部実行。pobox サイズ・DB 容量・Java メモリ要件あり | stageman, Symphony | S11, S15 |
| Stageman | コマンド | 新旧 Symphony をマージし carry-forward を制御 | stageman -carryforward オプションが enCarryForward を上書き。USERJOBS clean up 機能 (V9.5 FP6) と連動 | Symphony, USERJOBS, enCarryForward | S11, S1 |
| Event Processor / Event Rules | イベント駆動エンジン | ファイル監視・ジョブ完了などをトリガに自動アクションを発火 | filemonitor、startCondition、condition-based workflow automation。switcheventprocessor で MDM 障害時の引継ぎ | deploymentFrequency, planman deploy | S11, S33, S1 |
| Self-Service Catalog / Self-Service Dashboard | Web UI 拡張 | 業務担当が GUI でジョブ依頼・状況確認 | Self-Service Catalog enhancements (V10.1.0 FP2)、Workload Dashboard | DWC, Liberty | S1, S3, S33 |
| Workload Designer | Web UI 拡張 | ジョブストリーム/ワークフローのグラフィカル設計 | V10.1.0 で導入。Plan View 連動、Critical Path 表示 | DWC, REST API | S1, S33 |
| Mobile Applications | iOS/Android アプリ | 外出先からのワークロード状況確認・操作 | DWC と REST API 経由で連携 | DWC, REST API | S2 |
| WAPL (Workload Automation Programming Language) | DSL | z/OS 系で job stream 定義を高水準に記述・自動生成 | WAPL ファイルから IWS 定義を生成。CI/CD パイプラインから利用可能 | Z Workload Scheduler | S25 |
| Cluster Enabler (Windows) | HA 統合 | Microsoft Cluster Service (MSCS) と連携した Windows ノード HA | twsClusterAdm コマンドで構成。Cluster Administrator 拡張に IWS リソースタイプ追加 | MSCS, Windows Service | S14 |
| HACMP / PowerHA SystemMirror 連携 | HA 統合 | AIX 上の HACMP/PowerHA に IWS リソースを組み込む standby/takeover 構成 | Shared disk + Service IP のリソースグループ。physical components of an HACMP cluster セクション参照 | PowerHA, AIX | S14 |

