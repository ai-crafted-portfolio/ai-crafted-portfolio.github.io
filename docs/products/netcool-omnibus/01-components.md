# Netcool OMNIbus V8.1 — 構成要素

Netcool/OMNIbus V8.1 — 構成要素（コンポーネント・機能ブロック）

各コンポーネント記述の末尾「出典」列に [SX] 形式の出典 ID（06_出典一覧 参照）。

| コンポーネント名 | 役割 | 主要機能・既定構成 | 関連サブシステム | 出典 |
|---|---|---|---|---|
| ObjectServer (nco_objserv) | イベント蓄積・正規化・自動化を行うインメモリ DB サーバ | alerts.status / alerts.details / alerts.journal の三大テーブルを保持。SQL interactive interface (nco_sql) で操作。Probe・Gateway からのイベントを INSERT、Web GUI/AEL から SELECT。deduplication / 自動化（trigger / signal / external procedure） / IDUC によるクライアント配信を担う | Process Agent / Probe / Gateway / Web GUI | S1, S4 |
| Probe (nco_p_*) | 外部イベントソースを ObjectServer 用イベントに変換するゲートウェイプロセス | rules file（@manager/@Severity 等への代入）でイベント変換。代表 Probe: nco_p_syslog (Syslog), nco_p_mttrapd (SNMP Trap), nco_p_tivoli_eif (Tivoli EIF)。Probe HTTP コマンドインターフェースから reload・Probe ステータス制御可 | rules file / ObjectServer | S1, S2 |
| Gateway (nco_g_*) | ObjectServer 間 / 外部システム間でのイベント複製・連携 | ObjectServer Gateway（nco_g_objserv 系）はキャッシュを持ち、bidirectional 同期で Backup/Aggregation 層を構成。マッピング定義で source/target ObjectServer のフィールド対応とテーブル複製対象を指定 | ObjectServer / 多段構成 | S1 |
| Process Agent (nco_pad) | OMNIbus 関連プロセスの起動/監視/再起動を行う管理デーモン | nco_pad を起動しておくと nco_pa_start / nco_pa_stop / nco_pa_status コマンドからプロセス制御が可能。PA.Username / PA.Password で認証。複数の Probe・Gateway をまとめて管理する基盤 | ObjectServer / Probe / Gateway | S1, S4 |
| Proxy Server (nco_proxyserv) | Probe と ObjectServer 間の中継・接続集約 | 多数の Probe を 1 接続にまとめて ObjectServer 側の接続スケーリング負荷を低減。SecureMode プロパティ / -secure オプションで認証付き運用可。firewall bridge server（SQL コマンドインターフェース）と組み合わせ DMZ 越しの Probe 接続を実現 | Probe / firewall | S1 |
| Web GUI（DASH 上） | ブラウザベースのオペレータ／管理 UI | Active Event List (AEL) / Event Viewer / Gauges ウィジェット / Tools メニュー / WAAPI を提供。Jazz for Service Management の DASH（WebSphere Application Server 上）にデプロイ。IDUC を通じて ObjectServer から Real-time にイベント配信 | DASH / WAS / IDUC | S1, S5 |
| Netcool/OMNIbus Administrator | サーバ／ユーザ／トリガを編集する Java デスクトップ管理 GUI | Server Editor で omni.dat / interfaces 編集、SQL 編集ウィンドウでトリガ／自動化 SQL の構文ハイライト編集、ユーザ・グループ・ロール管理。Java Runtime Environment (JRE) が必要 | JRE / omni.dat | S1 |
| Accelerated Event Notification (AEN / nco_aen) | 重大イベントを Web GUI クライアントに低レイテンシで通知 | ObjectServer 側でフラグ付けされたイベントを通常 IDUC より高頻度で配信。Probe の rules file 内で acceleration 用のフラグカラムをセット | IDUC / Web GUI | S1 |
| Netcool MIB Manager | SNMP MIB を解析して Probe 用 rules file を生成する Eclipse ベース GUI | 旧 mib2rules ユーティリティの後継。Generating SNMP traps 機能で Number of Traps を指定可能 | SNMP Probe / rules file | S1 |
| WAAPI (Web GUI Administration API) | Web GUI 設定変更をスクリプトで自動化する SOAP/HTTP API | runwaapi コマンド + XML リクエストファイルで起動。$WEBGUI_HOME/waapi/bin/runwaapi.cmd（Windows） または $WEBGUI_HOME/waapi/bin/runwaapi（UNIX）。ユーザ/グループ/ロール/フィルタ/ビュー/ツール定義を一括投入可能<br>[要確認:/bin/runwaapi.cmd] | Web GUI / DASH | S5 |
| EIF (Event Integration Facility) ライブラリ | 外部アプリ／IBM 製品からの EIF イベント送受信ライブラリ | Probe for Tivoli EIF (nco_p_tivoli_eif) で受信、または C/Java EIF アプリから送出。eif_default.rules / tivoli_eif.rules で ObjectServer フィールドへマッピング。GSKit ($NCHOME/bin) 経由で SSL 接続、predictive event 受信もサポート | Probe / GSKit / IBM Tivoli Monitoring | S2, S3 |
| ITM Agent for OMNIbus | ObjectServer の health/performance を IBM Tivoli Monitoring に渡す監視エージェント | Tivoli Enterprise Monitoring Server (TEMS) 経由で Tivoli Enterprise Portal にメトリクス可視化。Predictive Event 機能では Tivoli EIF + ObjectServer 拡張カラムを使い、predictive_event.rules で alerts.status へマッピング | TEMS / Tivoli Enterprise Portal | S3 |
| ObjectServer HTTP Interface (libnhttpd / nhttpd) | ObjectServer に対する REST/HTTP コマンド／GET/POST 受付 | NHttpd.EnableHTTP / NHttpd.AuthenticationDomain / NHttpd.DocumentRoot / NHttpd.ConfigFile で挙動制御。既定設定ファイル $OMNIHOME/etc/libnhttpd.json。POST で alerts.status にイベント挿入も可能 | ObjectServer / SSL | S1, S5 |
| automation.sql / 標準トリガ | OMNIbus が出荷する標準ハウスキーピング自動化 | $NCHOME/omnibus/etc/automation.sql に generic_clear / delete_clears / hk_set_expiretime / hk_de_escalate_events 等を定義。master.properties テーブルで既定値を保持 | trigger group / signal | S1 |
| Multitiered Architecture（多段構成） | Collection / Aggregation / Display ObjectServer の役割分離 | Collection 層が Probe を受け、Aggregation 層が deduplication と高可用化、Display 層がユーザ問い合わせを引き受ける。Aggregation 層の Backup ObjectServer + bidirectional gateway で fail-over を組む | ObjectServer / Gateway | S1 |
| nco_xigen (Server Editor) | サーバ間通信情報の生成ツール | omni.dat（接続定義）から interfaces ファイルを生成。IPv6 対応では omni.dat に Primary 行を IPv6 アドレスで記述するとデュアルスタックで listen 可能 | omni.dat / interfaces | S1 |
| nco_confpack | ObjectServer 設定の export/import パッケージツール | $NCHOME/omnibus/extensions/ 配下の .jar/.zip パッケージをインポートして拡張機能（仮想化用 ShowRootCauseTool 等）を組み込む。-import -server -user -password オプションを使用 | ObjectServer / 拡張機能 | S1 |

