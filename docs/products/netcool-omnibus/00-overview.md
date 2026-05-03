# Netcool OMNIbus V8.1 — 概要

Netcool/OMNIbus V8.1 — 製品概要

本シートは ChromaDB 投入済みの IBM Tivoli Netcool/OMNIbus V8.1 ドキュメント群（2,848 chunks / 5 sources）から構造化抽出した製品サマリ。 各記述末尾の [SX] は出典 ID（06_出典一覧 を参照）。

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM Tivoli Netcool/OMNIbus V8.1  [S4, S1] | S4, S1 |
| ベンダ | IBM Corporation  [S4] | S4 |
| 対象バージョン | OMNIbus 8.1.0 / 8.1.x（本文ドキュメントは 8.1.0 系をベースにした最終更新 2026-01-08 反映）  [S1] | S1 |
| 製品の役割 | ネットワーク機器・サーバ・アプリケーションから発生したイベント（アラート）を ObjectServer（インメモリ DB）に集約し、deduplication（重複排除）・ 自動相関・通知・運用可視化までを行うエンタープライズ向け事象管理基盤。 IBM Netcool ファミリの中核製品で、Tivoli Enterprise Portal 等の上位監視 製品から下位の Probe/Gateway 群を通じて広範な機器をサポートする。  [S1, S4] | S1, S4 |
| 想定読者 | Netcool/OMNIbus 管理者、運用設計者、イベント自動化担当者、Probe/Gateway 開発者、Web GUI 管理者  [S1, S5] | S1, S5 |
| 代表的な利用シーン | NW/サーバ運用センターでの障害イベント集約、複数ベンダ機器の統合監視、 IBM Tivoli Monitoring と連携した Predictive Event 配信、Netcool/Impact による イベントエンリッチメント、PowerHA／Tivoli Enterprise Portal との障害連携。  [S1, S3] | S1, S3 |
| 中核アーキテクチャ | ObjectServer（インメモリ DB） + Probe（イベント取り込み） + Gateway（複製/連携） + Process Agent（プロセス管理 nco_pad） + Web GUI（DASH 上で稼働、AEL 提供） + Proxy Server。 多段構成（multitiered）として Collection / Aggregation / Display ObjectServer 層を組める。  [S1, S4] | S1, S4 |
| 主たるイベントテーブル | alerts.status（イベント本体） / alerts.details（詳細属性 KV ペア） / alerts.journal（オペレータ追記）  [S1, S5] | S1, S5 |
| 主要環境変数 | $NCHOME（製品ルート、UNIX 例: /opt/IBM/tivoli/netcool） / $OMNIHOME（OMNIbus サブディレクトリ）  [S1] | S1 |
| 通信ポート（既定） | ObjectServer ポート（既定 NCOMS=4100、QuickStart の例では 9000 や 8002 を使用）。Iduc.ListeningPort で IDUC 通信ポート設定  [S1, S4] | S1, S4 |
| 管理 GUI | Netcool/OMNIbus Administrator（旧 nco_config 系 Java GUI） + Web GUI（DASH 上、AEL/Event Viewer/Gauges 提供）  [S1, S5] | S1, S5 |
| 管理 CLI / API | SQL interactive interface（nco_sql）、WAAPI（runwaapi コマンド + XML リクエスト）、ObjectServer HTTP Interface（libnhttpd / NHttpd.EnableHTTP プロパティ）  [S5, S1] | S5, S1 |
| セキュリティ機能 | ユーザ/グループ/ロール（Default groups: Probe/Gateway 等、Default roles: CatalogUser/AlertsUser/AlertsProbe/RegisterProbe/ChannelUser）、SSL/TLS、FIPS 140-2 モード、SecureMode、LDAP 認証、監査  [S1] | S1 |
| 高可用性 | Backup ObjectServer + bidirectional ObjectServer Gateway による fail-over、multitier の Aggregation 層で冗長化  [S1] | S1 |
| EIF 連携 | Tivoli EIF プロトコルで多製品（IBM Tivoli Monitoring 等）からイベントを受信。Probe for Tivoli EIF (nco_p_tivoli_eif) と eif_default.rules / tivoli_eif.rules を使用  [S2, S3] | S2, S3 |
| ドキュメント形態 | 公式 IBM Knowledge Center Web ドキュメント（OMNIbus 8.1.0）。本 Excel では 5 source（BP / EIF / ITM Agent / QSG / WAAPI）を引用  [S1] | S1 |
| 関連製品（密結合） | Netcool/Impact（イベントエンリッチメント）、IBM Tivoli Monitoring (TEMS)、Tivoli Enterprise Portal、Jazz for Service Management / DASH、WebSphere Application Server、Netcool MIB Manager  [S1, S3] | S1, S3 |

