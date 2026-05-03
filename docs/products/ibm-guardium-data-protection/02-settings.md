# IBM Guardium Data Protection 12.x — 主要設定項目

IBM Guardium Data Protection 12.x — 主要設定項目

S-TAP インストール、Inspection Engine 設定、ポリシー設定の代表的なパラメータ。

| パラメータ名 / 設定項目 | 設定ファイル / コマンド | 既定値 / 推奨値 | 取り得る値 | 適用範囲・反映タイミング | 関連項目 | 出典 |
|---|---|---|---|---|---|---|
| --installdir (S-TAP インストール先) | consolidated_installer.sh | /usr/local/guardium（例） | DB サーバ上の任意絶対パス | 新規インストール時のみ | GIM / S-TAP | S35 |
| --tapip (S-TAP の DB サーバ IP/ホスト名) | consolidated_installer.sh | DB サーバ自身のホスト名（例: db2server.gdemo.com） | IP アドレスまたは FQDN | インストール時設定 | guard_tap.ini | S35 |
| --gim_sqlguardip (GIM 通信先 Collector) | consolidated_installer.sh | Collector ホスト名（例: guardcollector.gdemo.com） | Collector の IP アドレスまたは FQDN | インストール時設定 | GIM | S35 |
| --stap_sqlguardip (S-TAP のプライマリ Collector) | consolidated_installer.sh | プライマリ Collector ホスト名 | Collector の IP アドレスまたは FQDN | インストール時設定 | S-TAP | S35 |
| --failover_sqlguardip (フェイルオーバ先 Collector) | consolidated_installer.sh | 未指定（オプション） | セカンダリ Collector の IP/FQDN | インストール時設定。ILB と組合せでデータ損失低減 | ILB / Load Balancer | S35, S2 |
| --ktap_allow_module_combos | consolidated_installer.sh | 未指定（フラグ） | 指定／非指定 | K-TAP モジュール組合せ許可（カーネル互換問題回避） | K-TAP | S35 |
| --use_discovery | consolidated_installer.sh | 1（有効） | 0 / 1 | guard_discovery プロセス起動制御 | Discovery / S-TAP | S35 |
| collaborate_kerberos_enabled (Linux/UNIX S-TAP) | S-TAP パラメータ（CM の Configuration UI） | 未設定（既定無効） | yes / no | Kerberos セッションを Unix S-TAP と協調 → DB_user ベースのセッションレベルポリシ即時発火 | Kerberos / Session policy | S2 |
| aso_enabled (Oracle ASO 用) | S-TAP パラメータ | 未設定（無効） | yes / no | Oracle Advance Security Option (ASO) A-TAP トラフィックを複数 Collector に分散 | A-TAP / Oracle | S2 |
| VERDICT_RESUME_DELAY (Windows S-TAP firewall) | Windows S-TAP パラメータ | 12.2 で導入 | 数値（待ち時間） | 全 Collector ダウン時に DB セッションを通過させるための待機 | Windows S-TAP firewall | S2 |
| PCRE_REGEX_ENABLED (Windows S-TAP) | Windows S-TAP パラメータ | 12.2 で導入 | 0 / 1 | Windows S-TAP で PCRE 正規表現を有効化 | Pattern matching | S2 |
| Name (Inspection Engine 名) | Manage > Activity Monitoring > Inspection Engines | ユーザ指定（appliance 内ユニーク） | 英数字（特殊文字不可） | Inspection Engine 単位、停止後の Add で反映 | Inspection Engine | S84 |
| Protocol | Inspection Engines UI / update_engine_config API | 監視対象 DB プロトコル | Oracle / Db2 / SQL Server / MySQL / PostgreSQL / Sybase / HTTP 等 | Inspection Engine 単位、再起動で反映 | DB プロトコル | S84 |
| DB Client IP/Mask | Inspection Engines UI | 監視対象クライアント IP リスト（マスク併記） | IP/Mask 併記、Exclude DB Client IP との組合せで除外モード化 | Inspection Engine 単位、再起動不要で順序変更即時反映 | Filtering | S84 |
| DB Server IP/Mask | Inspection Engines UI | 監視対象 DB サーバ IP リスト | IP/Mask 併記 | Inspection Engine 単位 | Filtering | S84 |
| Port (DB Port) | Inspection Engines UI | DB ポート（通常 1 ポート） | 単一ポートまたは範囲（範囲指定は性能低下注意） | Inspection Engine 単位 | Filtering / Sniffer load | S84 |
| Active on startup | Inspection Engines UI | 未選択 | checkbox | Engine 起動時の自動開始 | Inspection Engine | S84 |
| Default Capture Value | Inspection Engine settings | false | true / false | Replay 機能で prepared statement の値補足 | Replay | S84 |
| Default Mark Auto Commit | Inspection Engine settings | true | true / false | true の場合 Db2 / Informix / Oracle で commit/rollback を無視 | Replay | S84 |
| Log Records Affected | Inspection Engine settings | FALSE (0) | true / false | AWS / Couchbase / Hadoop / Db2 streaming は非対応。バッファ消費・性能影響あり | store max_results_set_size / store max_result_set_packet_size / store max_tds_response_packets | S84 |
| Compute Avg Response Time | Inspection Engine settings | 未指定 | checkbox | 12.1 以降、35 分（200 万 ms）超の応答は -1 表示 | Reports | S84 |
| Inspect Returned Data | Inspection Engine settings | 未指定 | checkbox | Extrusion ルールを使う場合は必須 | Extrusion / Policy | S84 |
| Logging Granularity (分) | Inspection Engine settings | 未指定（時刻記録なし） | 1 / 2 / 5 / 10 / 15 / 30 / 60 | レポート集約単位。Real-time alert は granularity に依らず正確時刻で発火 | Reports / Real-time alerts | S84 |
| Ignored Ports List | Inspection Engine settings | 空 | カンマ区切り（例: 101,105,110-223） | DB サーバ上の非 DB トラフィックを除外し sniffer 負荷低減 | Sniffer load | S84 |
| Restart Inspection Engines | Inspection Engines UI / Apply | — | ボタン操作 | global 設定（Apply）反映に必須。個別 Engine 属性（順序・除外）は即時反映 | Inspection Engine | S84 |
| Policy Type | Policy Builder UI | Access policy（標準） | Access / Extrusion / Session-level / Selective Audit | Policy 単位 | Rule actions | S9, S85, S11, S51, S52 |
| Rule Action（ブロッキング系） | Policy rule actions | — | S-TAP TERMINATE / S-GATE TERMINATE / DROP / QUARANTINE | ルール一致時にセッション切断 | S-TAP / S-GATE | S10, S49 |
| Rule Action（アラート系） | Policy rule actions | — | Alert Per Match / Alert Daily / Alert Once Per Session / Alert Per Time Granularity | 受信者（メール / SNMP / Syslog / Custom）に通知 | Alerts / Threshold | S10, S22 |
| Rule Action（ロギング系） | Policy rule actions | — | Log Full Details / Log Masked Details / Audit Only / Skip Logging / Log Only | 観測トラフィックのログ粒度を制御 | Reports / Audit | S10, S49 |
| Rule Action（セッション無視） | Session-level policy | — | IGNORE SESSION / SOFT DISCARD SESSION / SELECT SESSION | Sniffer 過負荷対策（信頼アプリ／統計サービス／Zabbix 等を除外） | Sniffer overload | S76, S87, S94 |
| Rule Action（マスク／改変） | Policy rule actions | — | TRANSFORM SOURCE PROGRAM NAME / SET CHARACTER SET / Mask / Replace | ソースプログラム名・文字セット変換、マスキング | Extrusion / Privacy | S10, S49 |
| Quarantine for failed logins | Security incident policy | 12.1 で追加 | 閾値（n 回連続） | n 回失敗ユーザを一定時間隔離 | Auth / RBAC | S2 |
| Group / Tag based rule import | Importing rules by tag | — | tag に紐付くルールセット | ポリシ展開時のメンテナンス性向上 | Groups | S53 |
| Policy Installation | Policy Installation tool | — | Collector または CM 経由で配布 | 保存だけではダウンロード反映されない、Install 操作が必要 | Inspection Engine 再起動不要だが内部にロード | S12, S50 |
| auto_stop_services_when_full | store / show auto_stop_services_when_full (CLI) | on（既定） | on / off | DB または /var が 90% 超で nanny がサービス停止。off は緊急時の一時的措置のみ | Internal DB / Disk Full | S79 |
| Default purge / archive 推奨保持 | Data Management Schedule | Collector=15 日 / Aggregator=30 日 | 日数（運用要件に応じ可変） | Daily Archive 後に Purge を実行（順序が重要） | Archive / Purge | S81 |

