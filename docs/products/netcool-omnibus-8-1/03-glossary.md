# 用語集

> 掲載：**78 件（OMNIbus 固有 + 周辺・連携）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## サブシステム / 中核プロセス（10 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="objectserver">**ObjectServer**</span> | OMNIbus の中核となるインメモリ DB サーバ。alerts.status / alerts.details / alerts.journal の 3 表 + master.* / catalog.* を保持。`nco_objserv -name <name>` で起動。1 ホストに複数 ObjectServer をホストできる。 | [SMAC](#smac), [alerts.status](#alerts-status), [Trigger](#trigger) | [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create) |
| <span id="probe">**Probe**</span> | 外部イベントソース（Syslog、SNMP Trap、EIF、ログファイル、Kafka、AWS CloudWatch 等）を ObjectServer 用イベントに変換するゲートウェイプロセス。`nco_p_<source>` の名前で配布。 | [Rules File](#rules-file), [Probe HTTP Interface](#probe-http-interface) | [cfg-probe-syslog](08-config-procedures.md#cfg-probe-syslog) |
| <span id="gateway">**Gateway**</span> | ObjectServer 間 / 外部システム間でのイベント複製・連携プロセス。uni-directional（一方向）と bi-directional（双方向）の 2 種。SMAC では Collection→Aggregation, Aggregation↔Aggregation, Aggregation→Display で使用。 | [SMAC](#smac), [AGG_GATE](#agg-gate), [Controlled Failback](#controlled-failback) | [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) |
| <span id="process-agent">**Process Agent（nco_pad）**</span> | OMNIbus 関連プロセス（ObjectServer / Probe / Gateway / Proxy）の起動・監視・自動再起動デーモン。OS の systemd / SRC から nco_pad を起こせば配下を一括管理。 | [nco_pa_status](#nco-pa-status), [PAM](#pam) | [cfg-pa-deploy](08-config-procedures.md#cfg-pa-deploy) |
| <span id="proxy-server">**Proxy Server（nco_proxyserv）**</span> | 多数の Probe を 1 接続にまとめ、ObjectServer 側の接続スケーリングを軽減。DMZ → core 間の firewall bridge にも使用。`SecureMode=TRUE` 必須。 | [SecureMode](#securemode), [DMZ](#dmz) | [cfg-proxy-deploy](08-config-procedures.md#cfg-proxy-deploy) |
| <span id="aen">**AEN（Accelerated Event Notification）**</span> | 高優先イベントを通常 IDUC（Granularity 60 秒）を待たず Web GUI / desktop client へ即時配信する機能。ObjectServer 側の `accelerated_inserts` トリガと `nco_aen` プロセス、Probe rules 内のフラグ列で制御。 | [IDUC](#iduc), [accelerated_inserts](#accelerated-inserts) | [cfg-aen-enable](08-config-procedures.md#cfg-aen-enable) |
| <span id="iduc">**IDUC（Insert / Delete / Update / Control）**</span> | ObjectServer がクライアント（Web GUI / Impact / native client）に変更通知をプッシュするためのプロトコル。`Iduc.ListeningPort` でリッスン、`Granularity` で配信間隔（既定 60 秒）。 | [AEN](#aen), [Granularity](#granularity) | [inc-iduc-stuck](09-incident-procedures.md#inc-iduc-stuck) |
| <span id="web-gui">**Web GUI（旧 Webtop）**</span> | Jazz for Service Management（DASH）上の WebSphere Application Server で稼働する Web 管理 UI。AEL / Event Viewer / Gauges / Tools メニュー / WAAPI を提供。 | [DASH](#dash), [WAAPI](#waapi), [AEL](#ael) | [cfg-webgui-waapi](08-config-procedures.md#cfg-webgui-waapi) |
| <span id="ncomns-administrator">**Netcool/OMNIbus Administrator**</span> | Java デスクトップ管理 GUI。Server Editor で omni.dat 編集、SQL 編集ウィンドウ、ユーザ・グループ・ロール管理。JRE 必須。 | [omni.dat](#omni-dat) | — |
| <span id="nco-aen">**nco_aen**</span> | AEN を担うプロセス。`accelerated_inserts` トリガが立てたイベントを Display 層クライアントへ即時配信。 | [AEN](#aen) | [cfg-aen-enable](08-config-procedures.md#cfg-aen-enable) |

## アーキテクチャ / 階層（8 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="smac">**SMAC（Standard Multitier Architecture Configuration）**</span> | OMNIbus の **公式推奨多段構成**：**Collection 層**（Probe 受け）→ **Aggregation 層**（deduplication / 高可用化）→ **Display 層**（ユーザクライアント）。`$OMNIHOME/extensions/multitier/` 配下に role 別 SQL（collection.sql / aggregation.sql / display.sql）が同梱。 | [Collection Layer](#collection-layer), [Aggregation Layer](#aggregation-layer), [Display Layer](#display-layer) | [cfg-smac-aggregation](08-config-procedures.md#cfg-smac-aggregation) |
| <span id="collection-layer">**Collection Layer**</span> | SMAC の最下層。Probe を直接受ける ObjectServer 群。`col_expire` トリガで「Aggregation に転送済かつ 30 秒経過」のイベントを reap。alerts.status を肥大化させない設計。 | [SMAC](#smac), [col_expire](#col-expire) | [cfg-smac-collection](08-config-procedures.md#cfg-smac-collection) |
| <span id="aggregation-layer">**Aggregation Layer**</span> | SMAC の中段。Primary / Backup の **二重化必須相当**、bi-directional Gateway `AGG_GATE` で相互複製。OMNIbus 全体の SLA を決める層。 | [SMAC](#smac), [AGG_GATE](#agg-gate), [Controlled Failback](#controlled-failback) | [cfg-smac-aggregation](08-config-procedures.md#cfg-smac-aggregation) |
| <span id="display-layer">**Display Layer**</span> | SMAC の最上層。Web GUI / Impact / native client の問い合わせを引き受ける。Aggregation 層の負荷を逃がす役。`dsd_triggers` グループで動作。 | [SMAC](#smac), [dsd_triggers](#dsd-triggers) | [cfg-smac-display](08-config-procedures.md#cfg-smac-display) |
| <span id="agg-gate">**AGG_GATE**</span> | SMAC で Aggregation Primary ↔ Backup を bi-directional 同期する標準 Gateway 名。`nco_g_objserv_bi` で稼働、`Resync.LockType=PARTIAL` が標準。 | [Gateway](#gateway), [Controlled Failback](#controlled-failback) | [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) |
| <span id="controlled-failback">**Controlled Failback**</span> | Primary 復旧時に AGG_GATE が resync 完了してから、Probe / Gateway / Web GUI クライアントが順次 primary へ戻る Best Practices v1.3 推奨フロー。Probe / Gateway の自動 failback は **disable** にする。 | [AGG_GATE](#agg-gate), [Failback](#failback) | [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) |
| <span id="failover">**Failover**</span> | Primary 障害時に Backup へ切替。Probe は `Server` / `ServerBackup` を参照、または virtual 名（COL_V_1 等）経由。 | [Failback](#failback), [Backup ObjectServer](#backup-objectserver) | [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) |
| <span id="failback">**Failback**</span> | Primary 復旧後、Backup → Primary へ運用を戻す動作。Aggregation 層では **controlled failback**、Collection 層では各クライアントの自動失敗復帰で行う。 | [Failover](#failover), [Controlled Failback](#controlled-failback) | [inc-failover-resync-fail](09-incident-procedures.md#inc-failover-resync-fail) |

## トリガ / 自動化（10 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="trigger">**Trigger**</span> | ObjectServer 内の自動化ルール。**database trigger**（INSERT / UPDATE / DELETE 検出）、**temporal trigger**（時間ベース）、**signal trigger**（signal 受信）の 3 種。 | [Signal](#signal), [Trigger Group](#trigger-group), [Procedure](#procedure) | [cfg-trigger-deploy](08-config-procedures.md#cfg-trigger-deploy) |
| <span id="trigger-group">**Trigger Group**</span> | 複数の trigger をまとめて enabled / disabled できるグループ。標準：`default_triggers` / `housekeeping` / `dsd_triggers` / `scala_triggers` / `accelerated_inserts`。 | [Trigger](#trigger) | [inc-alerts-status-bloat](09-incident-procedures.md#inc-alerts-status-bloat) |
| <span id="signal">**Signal**</span> | ObjectServer 内のイベント。`raise signal <name> <param>;` で発火、signal trigger でハンドル。custom signal にパラメータを持たせて分岐するのが Best Practices v1.3 推奨。 | [Trigger](#trigger), [event_storm_signal](#event-storm-signal) | — |
| <span id="procedure">**Procedure**</span> | ObjectServer 内の SQL 手続き。**internal procedure**（trigger から呼ばれる）と **external procedure**（外部スクリプト起動、`send_email` 等）の 2 種。 | [send_email](#send-email), [nco_mail](#nco-mail) | — |
| <span id="generic-clear">**generic_clear**</span> | 標準トリガ。`Severity = 0`（Clear）のイベントが届いたら、対応する障害行（同 Identifier）の Severity を 0 に更新。auto-resolution（自動解消）の中核。 | [delete_clears](#delete-clears), [Severity](#severity) | — |
| <span id="delete-clears">**delete_clears**</span> | 標準トリガ。`Severity=0` かつ `StateChange < now-120` のイベントを delete。Collection / Aggregation 層で enabled。 | [generic_clear](#generic-clear), [housekeeping](#housekeeping-group) | [inc-alerts-status-bloat](09-incident-procedures.md#inc-alerts-status-bloat) |
| <span id="hk-set-expiretime">**hk_set_expiretime**</span> | 標準 housekeeping トリガ。`ExpireTime` 未設定の行に既定値（`master.properties` から）を設定。Severity 別に時間差設定（Critical 3 日 / Major 2 日 / Warning 1 日 等）。 | [hk_de_escalate_events](#hk-de-escalate), [ExpireTime](#expiretime) | — |
| <span id="hk-de-escalate">**hk_de_escalate_events**</span> | 標準 housekeeping トリガ。時間経過で Severity を段階的に下げる（5→4→3→...→0）。一度の FOR EACH ROW で複数条件を IF-ELSEIF でまとめるのが Best Practices v1.3 推奨。 | [hk_set_expiretime](#hk-set-expiretime), [Severity](#severity) | — |
| <span id="col-expire">**col_expire**</span> | SMAC の Collection 層に追加されるトリガ。「Aggregation に転送済 + 30 秒経過」のイベントを reap。Collection 層が肥大化しない仕組みの中核。 | [SMAC](#smac), [Collection Layer](#collection-layer) | — |
| <span id="accelerated-inserts">**accelerated_inserts**</span> | AEN を有効化するトリガ。`accelerated_events` 列が 1 のイベントを Display 層へ即時転送。既定で disabled、有効化必須。 | [AEN](#aen), [nco_aen](#nco-aen) | [cfg-aen-enable](08-config-procedures.md#cfg-aen-enable) |

## イベント / スキーマ（10 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="alerts-status">**alerts.status**</span> | OMNIbus の **イベント本体**を保持する標準テーブル。Probe からの INSERT、Gateway での UPDATE、Web GUI からの SELECT が集中する。 | [alerts.details](#alerts-details), [Identifier](#identifier), [Severity](#severity) | [inc-alerts-status-bloat](09-incident-procedures.md#inc-alerts-status-bloat) |
| <span id="alerts-details">**alerts.details**</span> | alerts.status の各行に紐づく追加属性 KV ペア。Web GUI の Details タブに表示。`DisableDetails=1` で Probe 側から書き込みを止められる。 | [alerts.status](#alerts-status), [DisableDetails](#disabledetails) | [inc-alerts-status-bloat](09-incident-procedures.md#inc-alerts-status-bloat) |
| <span id="alerts-journal">**alerts.journal**</span> | alerts.status の各行へのオペレータ追記（コメント）テーブル。Web GUI から Insert Journal で追加。 | [alerts.status](#alerts-status) | — |
| <span id="identifier">**Identifier**</span> | alerts.status の **deduplication 主キー**。Probe rules 内で `@Identifier = ...` として組成。同一 Identifier の重複 INSERT は LastOccurrence 更新と Tally インクリメントに変換される。 | [Tally](#tally), [Probe](#probe), [Rules File](#rules-file) | — |
| <span id="severity">**Severity**</span> | イベント深刻度。0=Clear, 1=Indeterminate, 2=Warning, 3=Minor, 4=Major, 5=Critical。0 は `delete_clears` が 120 秒後に削除。 | [generic_clear](#generic-clear), [delete_clears](#delete-clears) | — |
| <span id="tally">**Tally**</span> | 重複回数。同一 Identifier の INSERT が来るたび +1。 | [Identifier](#identifier) | — |
| <span id="firstoccurrence">**FirstOccurrence / LastOccurrence**</span> | 初発・最新発生時刻（UTC）。deduplication で LastOccurrence のみ更新。 | [Identifier](#identifier) | — |
| <span id="expiretime">**ExpireTime**</span> | 期限切れまでの秒数。0 = 無期限（避けるべき）。`hk_set_expiretime` で既定値を設定するのが Best Practices v1.3 推奨。 | [hk_set_expiretime](#hk-set-expiretime), [housekeeping](#housekeeping-group) | — |
| <span id="alertgroup">**AlertGroup / AlertKey**</span> | イベントの機能カテゴリ（Network / OS / DB ...）と補助キー。Identifier 組成や restriction filter の主軸。 | [Identifier](#identifier) | — |
| <span id="statechange">**StateChange**</span> | 状態変更時刻。`delete_clears` の 120 秒判定基準。 | [delete_clears](#delete-clears) | — |

## Probe 関連（8 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="rules-file">**Rules File**</span> | Probe のイベント変換ルール。Tcl 風構文。`@Identifier = $X + "_" + $Y;` のように `@<カラム>` への代入で alerts.status へ書き込む。`include "..."` で他 rules を取り込み。 | [Probe](#probe), [Identifier](#identifier) | [cfg-probe-syslog](08-config-procedures.md#cfg-probe-syslog) |
| <span id="snmp-probe">**SNMP Probe（nco_p_mttrapd）**</span> | UDP 162 で SNMP Trap 受信、multi-threaded。**200 events/sec 想定**（Best Practices v1.3）。 | [Probe](#probe), [MIB Manager](#mib-manager) | [cfg-probe-snmp](08-config-procedures.md#cfg-probe-snmp) |
| <span id="syslog-probe">**Syslog Probe（nco_p_syslog）**</span> | UNIX/Linux syslog 受信、single-threaded。**100 events/sec 想定**。 | [Probe](#probe) | [cfg-probe-syslog](08-config-procedures.md#cfg-probe-syslog) |
| <span id="glf-probe">**GLF Probe（nco_p_logfile）**</span> | Generic Log File。任意ログを正規表現でパース。1 ホストで複数インスタンス起動が標準。 | [Probe](#probe) | [cfg-probe-glf](08-config-procedures.md#cfg-probe-glf) |
| <span id="eif-probe">**EIF Probe（nco_p_tivoli_eif）**</span> | IBM Tivoli Monitoring 等の EIF 送信元から受信。`tivoli_eif.rules` / `eif_default.rules` でクラス → カラム変換。 | [EIF](#eif), [Predictive Event](#predictive-event) | [cfg-probe-eif](08-config-procedures.md#cfg-probe-eif) |
| <span id="probe-http-interface">**Probe HTTP Interface**</span> | Probe の REST/HTTP コマンドインタフェース。`reload`（rules 再読込）、`getstatus`（統計取得）等。`EnableHTTP=TRUE` + 認証で有効化。 | [Probe](#probe) | [cfg-probe-http-cmd](08-config-procedures.md#cfg-probe-http-cmd) |
| <span id="dumpprops">**dumpprops オプション**</span> | Probe を `-dumpprops` 付きで実行すると現在の有効プロパティ全件を標準出力。トラブル時の定番。 | [Probe](#probe) | [inc-probe-conn-fail](09-incident-procedures.md#inc-probe-conn-fail) |
| <span id="event-storm">**Event Storm**</span> | 短時間に大量イベントが発生する状況。Probe レベルで低 severity 廃棄、`event_storm_signal` で administrator に通知するのが対策。 | [Signal](#signal), [event_storm_signal](#event-storm-signal) | [inc-event-flood](09-incident-procedures.md#inc-event-flood) |

## 接続 / 通信（6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="omni-dat">**omni.dat**</span> | ObjectServer / Process Agent / Proxy の接続定義テキスト。`$NCHOME/etc/omni.dat`。`nco_xigen` で interfaces ファイル（バイナリ）に変換。IPv6 対応では Primary 行に `[::1]` 等を記述。 | [interfaces](#interfaces), [nco_xigen](#nco-xigen) | [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create) |
| <span id="interfaces">**interfaces ファイル**</span> | omni.dat から生成される接続情報のバイナリファイル。Probe / Gateway / nco_sql / Web GUI が参照。 | [omni.dat](#omni-dat) | [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create) |
| <span id="nco-xigen">**nco_xigen**</span> | omni.dat → interfaces 生成ツール。omni.dat 編集後は必ず実行。 | [omni.dat](#omni-dat), [interfaces](#interfaces) | — |
| <span id="virtual-objectserver-name">**Virtual ObjectServer 名**</span> | `COL_V_1`（COL_P_1 + COL_B_1 で構成）のように、Primary / Backup ペアを 1 つの仮想名で表現。Probe `Server` プロパティに virtual 名を指定すると Probe 側から自動 failover が動く。 | [Failover](#failover) | [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) |
| <span id="nhttpd">**NHttpd（libnhttpd）**</span> | ObjectServer の HTTP/REST インタフェース実装。`NHttpd.EnableHTTP=TRUE` で有効化、`NHttpd.ConfigFile` に詳細。 | [NHttpd.EnableHTTP](02-settings.md) | [cfg-objserv-http](08-config-procedures.md#cfg-objserv-http) |
| <span id="dmz">**DMZ（DeMilitarized Zone）**</span> | 内部 / 外部 NW の中間隔離領域。OMNIbus の Proxy Server を置いて firewall 越しに Probe を集約するのが定番。 | [Proxy Server](#proxy-server), [SecureMode](#securemode) | [cfg-proxy-deploy](08-config-procedures.md#cfg-proxy-deploy) |

## セキュリティ（6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="securemode">**SecureMode**</span> | ObjectServer / Probe / Gateway / Process Agent / Proxy の SSL/TLS 認証モード。`TRUE` で SSL 必須、`-secure` オプションでも有効化可。 | [GSKit](#gskit), [FIPS](#fips) | [cfg-ssl-objserv](08-config-procedures.md#cfg-ssl-objserv) |
| <span id="fips">**FIPS 140-2 Mode**</span> | FIPS 準拠暗号モジュール限定モード。利用可能アルゴリズムが厳格化。政府系 / 金融案件で必要。 | [GSKit](#gskit), [SecureMode](#securemode) | [cfg-ssl-objserv](08-config-procedures.md#cfg-ssl-objserv) |
| <span id="gskit">**GSKit（IBM Global Security Kit）**</span> | IBM 製 SSL/TLS 暗号モジュール。`$NCHOME/bin` に同梱、`nc_gskcmd` で `.kdb`（鍵 DB）操作。 | [SecureMode](#securemode), [FIPS](#fips), [nc_gskcmd](#nc-gskcmd) | [cfg-ssl-objserv](08-config-procedures.md#cfg-ssl-objserv) |
| <span id="pam">**PAM（Pluggable Authentication Modules）**</span> | UNIX/Linux の認証フレームワーク。Process Agent の `-authenticate PAM` で OS ユーザを使った認証が可能。 | [Process Agent](#process-agent) | [cfg-pa-deploy](08-config-procedures.md#cfg-pa-deploy) |
| <span id="default-roles">**Default Roles**</span> | OMNIbus 標準ロール：`CatalogUser` / `AlertsUser` / `AlertsProbe` / `RegisterProbe` / `ChannelUser`。 | [Default Groups](#default-groups) | — |
| <span id="default-groups">**Default Groups**</span> | OMNIbus 標準グループ：`Probe`（CatalogUser, AlertsUser, AlertsProbe, RegisterProbe）、`Gateway`（CatalogUser 系）等。 | [Default Roles](#default-roles) | — |

## 連携・周辺（10 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="eif">**EIF（Event Integration Facility）**</span> | IBM Tivoli イベント送信プロトコル / ライブラリ。OMNIbus は `nco_p_tivoli_eif` で EIF 受信。 | [EIF Probe](#eif-probe), [ITM](#itm) | [cfg-probe-eif](08-config-procedures.md#cfg-probe-eif) |
| <span id="itm">**IBM Tivoli Monitoring（ITM / TEMS）**</span> | エージェント型監視製品。EIF 経由で OMNIbus と連携、`ITM Agent for OMNIbus` で双方向。 | [Predictive Event](#predictive-event), [TEMS](#tems) | — |
| <span id="tems">**TEMS（Tivoli Enterprise Monitoring Server）**</span> | ITM の中核サーバ。Tivoli Enterprise Portal で可視化。 | [ITM](#itm), [TEP](#tep) | — |
| <span id="tep">**Tivoli Enterprise Portal（TEP）**</span> | ITM のデスクトップ / Web GUI。 | [ITM](#itm) | — |
| <span id="predictive-event">**Predictive Event**</span> | ITM の予兆イベント。`predictive_event.rules` を `tivoli_eif.rules` に include して有効化。 | [EIF Probe](#eif-probe), [ITM](#itm) | [cfg-probe-eif](08-config-procedures.md#cfg-probe-eif) |
| <span id="impact">**Netcool/Impact**</span> | OMNIbus と連携するイベント処理エンジン。SQL ポリシーで alerts.status を enrich / 自動アクション。 | [Trigger](#trigger), [Procedure](#procedure) | — |
| <span id="dash">**Jazz for Service Management（DASH）**</span> | WebSphere Application Server 上の dashboard 基盤。Web GUI のホスト。 | [Web GUI](#web-gui), [WAS](#was) | — |
| <span id="was">**WebSphere Application Server（WAS）**</span> | Web GUI / DASH の実行基盤。 | [DASH](#dash) | — |
| <span id="scala">**IBM Operations Analytics - Log Analysis（SCALA）**</span> | ログ分析製品。`scala_triggers` グループで OMNIbus → SCALA へイベント送出。 | [Trigger Group](#trigger-group) | [cfg-scala-link](08-config-procedures.md#cfg-scala-link) |
| <span id="noi">**Netcool Operations Insight（NOI）Event Analytics**</span> | OMNIbus 上で動作する イベント解析製品。scope-based event grouping で関連イベントを自動グループ化。 | [Scope](#scope) | — |

## ツール / API（6 件）

| 用語 | 定義 | 関連用語 |
|---|---|---|
| <span id="waapi">**WAAPI（Web GUI Administration API）**</span> | Web GUI 設定変更用 SOAP/HTTP API。`runwaapi` コマンド + XML リクエスト。 | [Web GUI](#web-gui) |
| <span id="ael">**AEL（Active Event List）**</span> | Web GUI の主表示。alerts.status の rows を IDUC で受けてリアルタイム描画。 | [IDUC](#iduc), [Web GUI](#web-gui) |
| <span id="mib-manager">**Netcool MIB Manager**</span> | Eclipse ベース GUI、SNMP MIB → Probe rules 変換。`Generating SNMP traps` の Number of Traps を必要数に。 | [SNMP Probe](#snmp-probe) |
| <span id="im">**IBM Installation Manager（IM）**</span> | OMNIbus 本体・Web GUI のインストール / fix pack 適用ツール。Probe / Gateway は IM では入らない（個別 install.txt）。 | — |
| <span id="nco-pa-status">**nco_pa_status**</span> | Process Agent 配下プロセスの稼働状況一覧コマンド。**最頻用の運用コマンド**。 | [Process Agent](#process-agent) |
| <span id="nc-gskcmd">**nc_gskcmd**</span> | GSKit の証明書 / 鍵 DB 操作コマンド。`-keydb -create` / `-cert -create` 等。 | [GSKit](#gskit) |

## その他（4 件）

| 用語 | 定義 | 関連用語 |
|---|---|---|
| <span id="granularity">**Granularity**</span> | IDUC の配信間隔（秒、既定 60）。短くすると Web GUI 反応性 ↑、ObjectServer 負荷 ↑。 | [IDUC](#iduc), [AEN](#aen) |
| <span id="event-storm-signal">**event_storm_signal**</span> | Best Practices v1.3 推奨の custom signal 例。`STORM` / `NORMAL` のパラメータを取り、外部メール送信 procedure と連動。 | [Signal](#signal), [send_email](#send-email) |
| <span id="send-email">**send_email procedure**</span> | OMNIbus 標準 external procedure。実体は `nco_mail` シェルスクリプト。 | [nco_mail](#nco-mail), [Procedure](#procedure) |
| <span id="nco-mail">**nco_mail**</span> | OMNIbus 同梱のメール送信スクリプト。`send_email` から呼ばれる。 | [send_email](#send-email) |

### 関連用語

<span id="housekeeping-group">**housekeeping group**</span> = 標準 trigger group の 1 つ。`hk_set_expiretime`、`hk_de_escalate_events`、`expire`（旧 default 系の expire 系トリガ）等を含む。

<span id="dsd-triggers">**dsd_triggers**</span> = Display 層 ObjectServer の標準 trigger group。`clean_details_table` / `clean_journal_table` 等。

<span id="clean-details-table">**clean_details_table / clean_journal_table**</span> = alerts.status に対応行が無い alerts.details / alerts.journal を削除する標準トリガ。**全 ObjectServer で常時 enabled** が Best Practices v1.3 推奨。

<span id="backup-objectserver">**Backup ObjectServer**</span> = SMAC の Aggregation 層で Primary と pair を組む二重化 ObjectServer。`AGG_B` 等の名前が標準。

<span id="scope">**Scope**</span> = alerts.status 拡張カラム。同一 scope のイベントを NOI Event Analytics で自動グループ化。

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
