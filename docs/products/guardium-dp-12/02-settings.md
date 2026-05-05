# 設定値一覧

> 掲載：**Inspection Engine プロパティ 18 件 + S-TAP / Policy / Aggregator / Central Manager 関連 20 件 = 38 件**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

GDP 12.x の挙動は次の 5 系統のプロパティで決まる：

1. **Inspection Engine プロパティ** — Manage > Activity Monitoring > Inspection Engines（UI）または `grdapi update_engine_config`。Collector / Managed Unit 上で作成・実行（CM では作成不可）。
2. **S-TAP プロパティ** — `guard_tap.ini`（DB サーバ側）、または CM の S-TAP Configuration UI から集中管理。
3. **Policy ルール属性** — Policy Builder UI（Setup > Tools and Views > Policy Builder）。Access / Extrusion / Session-level / Selective Audit の 4 type。
4. **Aggregator / Central Manager プロパティ** — Daily Archive / Daily Import / Backup / Patch スケジュール、Long-term retention、distribution profile。
5. **Appliance グローバル設定** — `store / show` 系 CLI（auto_stop_services_when_full、max_results_set_size、save_result_fetch_size 等）。

## Inspection Engine プロパティ（18 件）

**種別の凡例**: フィルタ = 監視対象絞込、性能 = sniffer 負荷影響、機能 = ルール / レポート展開、運用ポリシー = ロギング粒度。

<div class="md-typeset__scrollwrap" markdown="1">

| パラメータ名 | 種別 | 既定値 | 取り得る値 | 反映タイミング | 関連手順 | 注意点 |
|---|---|---|---|---|---|---|
| `Name` | フィルタ | —（必須） | appliance 内ユニーク英数字（特殊文字不可） | Engine 停止後の Add で固定 | [cfg-inspection-engine](08-config-procedures.md#cfg-inspection-engine) | UI / grdapi の参照キー。CM 上では作成不可。 |
| `Protocol` | フィルタ | —（必須） | Oracle / Db2 / SQL Server / MySQL / PostgreSQL / Sybase / HTTP / Cassandra / MongoDB / Hadoop 等 | Engine 再起動 | [cfg-inspection-engine](08-config-procedures.md#cfg-inspection-engine) | DB 種別を間違えると Parse Tree が作れず policy 評価不能。 |
| `DB Client IP/Mask` | フィルタ | 全て（0.0.0.0/0） | IP / mask の組合せリスト、Exclude DB Client IP との組合せ可 | 再起動不要、順序変更即時反映 | [cfg-inspection-engine](08-config-procedures.md#cfg-inspection-engine) | 信頼アプリの除外で sniffer 負荷を下げる典型パターン。 |
| `DB Server IP/Mask` | フィルタ | DB サーバ自身 | IP / mask の組合せリスト | Engine 再起動 | [cfg-inspection-engine](08-config-procedures.md#cfg-inspection-engine) | RAC など複数 listener IP を持つ場合は複数行で記述。 |
| `Port` | フィルタ | DB 標準ポート | 単一 / 複数（範囲指定は性能低下要注意） | Engine 再起動 | [cfg-inspection-engine](08-config-procedures.md#cfg-inspection-engine) | 単一ポートが基本。範囲は trace ポートも拾うため負荷大。 |
| `Active on startup` | 運用ポリシー | 未選択 | checkbox | 起動時 | [cfg-inspection-engine](08-config-procedures.md#cfg-inspection-engine) | Collector 再起動後に Engine が黙って停止していたという事故防止に必須。 |
| `Default Capture Value` | 機能 | false | true / false | Engine 再起動 | [cfg-replay](08-config-procedures.md#cfg-replay) | Replay 機能で prepared statement の bind 値を補足する用途。 |
| `Default Mark Auto Commit` | 機能 | true | true / false | Engine 再起動 | — | true で Db2 / Informix / Oracle の commit/rollback を無視（性能優先）。 |
| `Log Records Affected` | 性能 | FALSE (0) | true / false | Engine 再起動 | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) | AWS / Couchbase / Hadoop / Db2 streaming は非対応。**buffer 消費激増、性能影響大**。 |
| `Compute Avg Response Time` | 機能 | 未指定 | checkbox | Engine 再起動 | — | 12.1 以降、35 分（200 万 ms）超の応答は -1 表示。 |
| `Inspect Returned Data` | 機能 | 未指定 | checkbox | Engine 再起動 | [cfg-extrusion-policy](08-config-procedures.md#cfg-extrusion-policy) | Extrusion ルール（漏洩監視）を使う場合は必須。 |
| `Logging Granularity (分)` | 運用ポリシー | 未指定（時刻記録なし） | 1 / 2 / 5 / 10 / 15 / 30 / 60 | Engine 再起動 | — | レポート集約単位。**Real-time alert は granularity に依らず正確時刻で発火**。 |
| `Ignored Ports List` | 性能 | 空 | カンマ区切り（例: 101,105,110-223） | 再起動不要 | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) | DB サーバ上の非 DB トラフィック除外で sniffer 負荷大幅低減。 |
| `Restart Inspection Engines` | 運用ポリシー | — | ボタン操作 | global 設定変更時に必須 | [cfg-inspection-engine](08-config-procedures.md#cfg-inspection-engine) | 個別 Engine の属性変更は即時反映、global は要 Restart。 |
| `Exclude DB Client IP` | フィルタ | 空 | IP / mask | 再起動不要 | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) | 信頼アプリ（バックアップ、監視 Zabbix 等）を除外する標準手段。 |
| `Buffer Free (%)` | 性能（モニタ） | 観測のみ | percent | 動的 | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) | sniffer overload の早期警報。10% 切ったら IGNORE SESSION 検討。 |
| `Sniffer Restart Threshold` | 性能 | 内部既定 | 件数 | 動的 | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) | overload 検出時に sniffer 自動再起動。再起動連発は要根本対応。 |
| `KTAP / A-TAP Active` | フィルタ | true | true / false | Engine 再起動 | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) | A-TAP は Oracle ASO / Redis 暗号化トラフィック復号取得に必須。 |

</div>

## S-TAP プロパティ（汎用、12 件）

<div class="md-typeset__scrollwrap" markdown="1">

| パラメータ名 / 設定項目 | 設定ファイル / コマンド | 既定値 / 推奨値 | 取り得る値 | 反映タイミング | 関連手順 | 出典 |
|---|---|---|---|---|---|---|
| `--installdir` | consolidated_installer.sh | /usr/local/guardium | DB サーバ上の任意絶対パス | 新規インストール時のみ | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) | S35 |
| `--tapip` (S-TAP の DB サーバ IP/ホスト名) | consolidated_installer.sh | DB サーバ自身のホスト名 | IP アドレスまたは FQDN | インストール時 | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) | S35 |
| `--gim_sqlguardip` (GIM 通信先) | consolidated_installer.sh | CM/Collector | Collector の IP / FQDN | インストール時 | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) | S35 |
| `--stap_sqlguardip` (プライマリ Collector) | consolidated_installer.sh | プライマリ Collector | Collector の IP / FQDN | インストール時 | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) | S35 |
| `--failover_sqlguardip` (Failover Collector) | consolidated_installer.sh | 未指定 | Backup Collector の IP / FQDN | インストール時 | [cfg-stap-failover](08-config-procedures.md#cfg-stap-failover) | S35, S2 |
| `--ktap_allow_module_combos` | consolidated_installer.sh | 未指定（フラグ） | 指定 / 非指定 | インストール時 | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) | S35 |
| `--use_discovery` | consolidated_installer.sh | 1（有効） | 0 / 1 | インストール時 | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) | guard_discovery プロセス制御。S35 |
| `collaborate_kerberos_enabled` (Linux/UNIX) | guard_tap.ini / CM UI | 未設定 | yes / no | S-TAP 再起動 | [cfg-policy-session](08-config-procedures.md#cfg-policy-session) | Kerberos セッションを Unix S-TAP と協調 → DB_user ベースのセッションレベルポリシ即時発火。S2 |
| `aso_enabled` (Oracle ASO) | guard_tap.ini / CM UI | 未設定 | yes / no | S-TAP 再起動 | [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) | Oracle ASO A-TAP を複数 Collector に分散。S2 |
| `VERDICT_RESUME_DELAY` (Windows S-TAP firewall) | guard_tap.ini | 12.2 で導入 | 数値（待機時間） | S-TAP 再起動 | [inc-stap-conn-fail](09-incident-procedures.md#inc-stap-conn-fail) | 全 Collector ダウン時の DB セッション通過待機。S2 |
| `PCRE_REGEX_ENABLED` (Windows S-TAP) | guard_tap.ini | 12.2 で導入 | 0 / 1 | S-TAP 再起動 | — | Windows S-TAP で PCRE 正規表現を有効化。S2 |
| `Server List` (S-TAP のリッスン Collector) | guard_tap.ini | プライマリ Collector | カンマ区切り | S-TAP 再起動 | [cfg-stap-failover](08-config-procedures.md#cfg-stap-failover) | ILB 利用時は ILB の virtual IP を指定。S2 |

</div>

## Policy プロパティ（8 件）

<div class="md-typeset__scrollwrap" markdown="1">

| パラメータ名 / 設定項目 | 既定値 | 取り得る値 | 用途 | 関連手順 |
|---|---|---|---|---|
| `Policy Type` | Access | Access / Extrusion / Session-level / Selective Audit | Policy の型を決定。Access が標準、漏洩検出は Extrusion、セッション全体評価は Session-level、特定対象だけログる場合は Selective Audit | [cfg-policy-build](08-config-procedures.md#cfg-policy-build) |
| `Rule Action（ブロッキング系）` | — | S-TAP TERMINATE / S-GATE TERMINATE / DROP / QUARANTINE | ルール一致時にセッション切断 | [cfg-policy-blocking](08-config-procedures.md#cfg-policy-blocking) |
| `Rule Action（アラート系）` | — | Alert Per Match / Alert Daily / Alert Once Per Session / Alert Per Time Granularity | 受信者（メール / SNMP / Syslog / Custom）に通知 | [cfg-alert-route](08-config-procedures.md#cfg-alert-route) |
| `Rule Action（ロギング系）` | — | Log Full Details / Log Masked Details / Audit Only / Skip Logging / Log Only | 観測トラフィックのログ粒度 | [cfg-policy-build](08-config-procedures.md#cfg-policy-build) |
| `Rule Action（セッション無視）` | — | IGNORE SESSION / SOFT DISCARD SESSION / SELECT SESSION | sniffer 過負荷対策（信頼アプリ除外） | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) |
| `Rule Action（マスク / 改変）` | — | TRANSFORM SOURCE PROGRAM NAME / SET CHARACTER SET / Mask / Replace | ソースプログラム名・文字セット変換、マスキング | [cfg-extrusion-policy](08-config-procedures.md#cfg-extrusion-policy) |
| `Quarantine for failed logins` | 12.1 で導入 | 閾値（n 回連続） | n 回失敗ユーザを一定時間隔離 | [cfg-policy-build](08-config-procedures.md#cfg-policy-build) |
| `Group / Tag based rule import` | — | tag に紐付くルールセット | ポリシ展開時のメンテナンス性向上 | [cfg-group-define](08-config-procedures.md#cfg-group-define) |

</div>

## Aggregator / Central Manager / appliance グローバル（10 件）

<div class="md-typeset__scrollwrap" markdown="1">

| パラメータ / 設定項目 | 設定経路 | 既定値 | 取り得る値 | 用途 / 反映 | 関連手順 |
|---|---|---|---|---|---|
| `auto_stop_services_when_full` | CLI: `store auto_stop_services_when_full` | on | on / off | 内部 DB / `/var` 90% 超で nanny がサービス停止 | [inc-disk-full](09-incident-procedures.md#inc-disk-full) |
| `max_results_set_size` | CLI: `store max_results_set_size` | 内部既定 | bytes | Log Records Affected 有効時のログ量上限 | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) |
| `max_result_set_packet_size` | CLI: `store max_result_set_packet_size` | 内部既定 | bytes | パケット単位の records affected 上限 | — |
| `max_tds_response_packets` | CLI: `store max_tds_response_packets` | 内部既定 | 数値 | TDS（MS SQL/Sybase）応答パケット数上限 | — |
| `save_result_fetch_size` | CLI: `store save_result_fetch_size` | 100,000 | 数値 | Audit Process の remote source 結果上限 | [cfg-audit-process](08-config-procedures.md#cfg-audit-process) |
| Daily Archive 保持 | UI: Comply > Tools and Views > Data Archive | Collector=15 日 / Aggregator=30 日 | 日数 | 推奨保持。Daily Archive → Daily Import → Daily Purge の順 | [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge) |
| Daily Archive スケジュール | UI: Schedule | 毎日 | cron 表記 | データ送信タイミング | [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge) |
| Long-term retention | grdapi: `configure_complete_cold_storage` | 未構成 | endpoint / bucket / retention | S3 互換オブジェクトストレージへ cold storage | [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge) |
| Aggregator Parallel Query option | Aggregator UI（12.2.1） | 未指定 | enabled / disabled | partition-aware routing で並列クエリ高速化 | — |
| Distribution Profile | UI: Comply > Tools and Views > Distribution Profile | — | profile name | CM から複数 MU へ Audit Process / Policy 一括配信 | [cfg-compliance-template](08-config-procedures.md#cfg-compliance-template) |

</div>

## Web Console グローバル（参考、4 件）

| 項目 | 設定経路 | 用途 |
|---|---|---|
| Access Manager UI | Setup > Tools and Views > Access Management | ユーザ / ロール / グループ管理。12.2.2 で再設計、tab レイアウト |
| LEGACY_ACCESSMGR_ENABLED | grdapi: `MODIFY_GUARD_PARAM` | 旧 Access Manager UI に戻す（12.2.2 暫定対応） |
| Smart assistant for compliance monitoring | Comply > Tools and Views > Smart assistant | regulation policy + alert + VA 一括生成 |
| Investigation / Executive Dashboard | Investigate / Reports | フィルタ保存、Today/Last 3/7/14 days、ROI / cost saving |

---

!!! info "本章の品質方針"
    全パラメータは IBM Docs Web の Inspection Engine / S-TAP / Policy / Audit Process / Archive 関連章（S35, S84, S9, S17, S81 等）と What's new in this release（S2）からの抜粋。**業務上の妥当値**（業務 SLA に応じた granularity、retention 日数）は環境依存のため [11. 対象外項目](10-out-of-scope.md) に逃がす。

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
