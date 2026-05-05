# マニュアル参照マップ

> LFA 6.3 の公式マニュアル群と、本サイト各章とのマッピング。テーマから「次に読むべき公式ドキュメント」を引く目的。**18 テーマ**。

## マッピングの主軸

LFA 6.3 の公式ドキュメントは大きく 3 系統：

1. **Tivoli Log File Agent Version 6.3 User's Guide（S3、SC14-7484-04）** — LFA 固有の `.conf` / `.fmt` 構文・属性グループ・サブノード・EIF 設定の根拠。**最重要**。
2. **IBM Tivoli Monitoring 6.3 本体ドキュメント（S_ITM_*）** — TEMS / TEPS / agent 共通の運用、`itmcmd` / `tacmd` リファレンス、Historical Data Collection、Remote Deploy、Troubleshooting Guide。
3. **Netcool/OMNIbus 8.1 ドキュメント（S_NCO_*）** — EIF 受信側（Probe for Tivoli EIF）の設定とルールファイル。

本ページではテーマ別に：

- **本サイトの該当章**
- **対応する公式ドキュメントセクション**
- **読み始めの推奨章**

をマッピング。

| # | テーマ | 本サイト章 | 公式ドキュメント該当セクション | 出典 ID |
|---|---|---|---|---|
| 1 | 製品アーキテクチャ全体像 | [index.md](index.md) | LFA User's Guide / Chapter 1 Overview / Components of the IBM Tivoli Monitoring environment | S3, S1 |
| 2 | 対応 OS / 前提条件 | [index.md](index.md) | LFA User's Guide / Compatibility report for the Log File agent / Prerequisites | S3 |
| 3 | エージェントインストール | [09. cfg-agent-install](08-config-procedures.md#cfg-agent-install) | ITM 6.3 Installation and Setup Guide / Installing monitoring agents / LFA section | S2, S_ITM_INSTALL |
| 4 | TEMS 接続設定（itmcmd config） | [09. cfg-tems-connect](08-config-procedures.md#cfg-tems-connect) | ITM 6.3 Installation and Setup Guide / Configuring connections / itmcmd config -A | S2, S_ITM_CMD |
| 5 | 設定ファイル（.conf）構文 | [02. 設定値一覧](02-settings.md), [09. cfg-conf-create](08-config-procedures.md#cfg-conf-create) | LFA User's Guide / Chapter 3 Configuration file | S3 |
| 6 | フォーマットファイル（.fmt）構文 | [03. Format File](03-glossary.md#format-file), [09. cfg-fmt-create](08-config-procedures.md#cfg-fmt-create) | LFA User's Guide / Chapter 4 Format file / Value specifiers / REGEX | S3 |
| 7 | 属性グループ（LogfileEvents 等） | [03. LogfileEvents](03-glossary.md#logfileevents) | LFA User's Guide / Chapter 7 Attribute groups for the Log File Agent / LogfileEvents / LogfileRegexStatistics / LogfileMonitor | S3 |
| 8 | サブノード設計 | [03. Subnode](03-glossary.md#subnode), [09. cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi) | LFA User's Guide / Chapter 5 Customizing the agent / Configuring multiple instances | S3 |
| 9 | 多行イベント / NewLinePattern | [09. cfg-multiline-newline](08-config-procedures.md#cfg-multiline-newline) | LFA User's Guide / Chapter 4 Format file / NewLinePattern / Multi-line records | S3 |
| 10 | EventFloodThreshold（イベント流量制御） | [09. cfg-flood-threshold](08-config-procedures.md#cfg-flood-threshold) | LFA User's Guide / Chapter 3 Configuration file / EventFloodThreshold / EventSummaryInterval | S3 |
| 11 | EIF 連携（Netcool 中継） | [09. cfg-eif-target](08-config-procedures.md#cfg-eif-target), [12. scn-eif-to-netcool](11-scenarios.md#scn-eif-to-netcool) | LFA User's Guide / Chapter 6 Sending events / EIF outputs。Netcool/OMNIbus / Probe for Tivoli EIF | S3, S_NCO_EIF, S_NCO_BP |
| 12 | Windows Event Log 監視 | [09. cfg-windows-eventlog](08-config-procedures.md#cfg-windows-eventlog) | LFA User's Guide / Chapter 5 Customizing / Windows event logs / WINEVENTLOGS | S3 |
| 13 | TEP situation / workspace | [09. cfg-tep-situation](08-config-procedures.md#cfg-tep-situation), [09. cfg-tep-workspace](08-config-procedures.md#cfg-tep-workspace) | ITM 6.3 Administrator's Guide / Situations / Workspaces。TEP User's Guide | S_ITM_ADMIN |
| 14 | 履歴データ収集 | [09. cfg-tep-workspace](08-config-procedures.md#cfg-tep-workspace) | ITM 6.3 Historical Data Collection Guide | S_ITM_HD |
| 15 | トレース（KBB_RAS1） | [09. cfg-trace-ras1](08-config-procedures.md#cfg-trace-ras1) | LFA User's Guide / Chapter 8 Troubleshooting / RAS1 trace。ITM Tech Note「Agent trace logs」 | S3, S_ITM_AGT_TRC, S5 |
| 16 | エージェント遠隔配信 | [09. cfg-tacmd-deploy](08-config-procedures.md#cfg-tacmd-deploy) | ITM 6.3 Remote Deploy / `tacmd addBundles` / `tacmd createNode` / `tacmd configureSystem` | S_ITM_DPLY, S_ITM_CMD |
| 17 | クラスタ構成 | [09. cfg-cluster-failover](08-config-procedures.md#cfg-cluster-failover) | LFA User's Guide / Cluster considerations。ITM 6.3 / High availability with HACMP/MSCS | S3, S_ITM_INSTALL |
| 18 | 障害対応 / 診断アーカイブ | [10. 障害対応手順](09-incident-procedures.md), [02. pdcollect](01-commands.md#pdcollect) | LFA User's Guide / Chapter 8 Troubleshooting。ITM 6.3 Troubleshooting Guide / pdcollect | S3, S5, S_ITM_TROUBLE |

## 用途別の読み順

**新規導入チーム（ITM 経験ゼロから LFA を立ち上げる）**：
（1）→（2）→（3）→（4）→（5）→（6）→（13）

**既存 ITM 環境に LFA を追加するチーム**：
（3）→（4）→（5）→（6）→（8）→（13）→（14）

**Netcool 連携設計チーム**：
（11）→（10）→ Netcool 側の [`nco_p_tivoli_eif`](../netcool-omnibus-8-1/01-commands.md) 関連トピック → 本サイト [Netcool/OMNIbus 8.1](../netcool-omnibus-8-1/index.md)

**性能トラブル対応チーム**：
（10）→（15）→（18）→ 障害手順（[10. inc-event-flood](09-incident-procedures.md#inc-event-flood) / [10. inc-disk-fill-trace](09-incident-procedures.md#inc-disk-fill-trace)）

**Windows ログ監視チーム**：
（12）→（5）→（6）→（13）

## 公式マニュアルの章構成（参考、LFA User's Guide 6.3）

| Chapter / Section | テーマ | 本サイト主対応章 |
|---|---|---|
| Chapter 1 Overview of the Log File Agent | 製品概要 | index.md |
| Chapter 2 Requirements for the monitoring agent | 前提 / 互換性 | index.md, 11 対象外 |
| Chapter 3 Configuration file | `.conf` ディレクティブ | 02 設定値, 09 cfg-conf-create |
| Chapter 4 Format file | `.fmt` 構文・REGEX・value specifier | 02 設定値, 09 cfg-fmt-create |
| Chapter 5 Customizing the monitoring agent | サブノード / 多インスタンス / Windows Event Log / カスタム source | 09 cfg-subnode-multi, 09 cfg-windows-eventlog |
| Chapter 6 Sending events to a receiver | EIF 出力 / Netcool 連携 | 09 cfg-eif-target |
| Chapter 7 Attribute groups for the Log File Agent | LogfileEvents / LogfileRegexStatistics / LogfileProfileEvents / LogfileMonitor 等 | 03 用語集（属性系） |
| Chapter 8 Troubleshooting | RAS1 / agent log / pdcollect / 既知の問題 | 06 トラブル早見表, 10 障害対応 |
| Appendix A Documentation library | 関連ドキュメント | 07 出典一覧 |

詳細出典は [07. 出典一覧](07-sources.md)。

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
