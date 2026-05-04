# マニュアル参照マップ

> Netcool/OMNIbus 8.1 の公式マニュアル群と、本サイト各章とのマッピング。テーマから「次に読むべき公式ドキュメント」を引く目的。**22 テーマ**。

## マッピングの主軸

OMNIbus 8.1 の公式ドキュメントは IBM Documentation（旧 Knowledge Center）の「IBM Tivoli Netcool/OMNIbus 8.1.0」配下、および IBM Best Practices Guide v1.3（PDF 198 ページ）を中心に構成される。本ページではテーマ別に：

- **本サイトの該当章**
- **対応する公式ドキュメントセクション**
- **読み始めの推奨章**

をマッピング。

| # | テーマ | 本サイト章 | 公式ドキュメント該当セクション | 出典 ID |
|---|---|---|---|---|
| 1 | 製品アーキテクチャ全体像 | [index.md](index.md) | OMNIbus 8.1 Installation and Deployment Guide / Best Practices Guide v1.3 Chapter 1 | S_OMN_BP, S_OMN_DEPLOY |
| 2 | 計画 / 容量見積 | [02. 設定値](02-settings.md), [11. シナリオ](11-scenarios.md#scn-perf-tuning) | Best Practices Guide v1.3 Chapter 2 (Planning) | S_OMN_BP |
| 3 | インストール（OMNIbus 本体） | [01. コマンド](01-commands.md#im) | Installation and Deployment Guide / IBM Installation Manager | S_OMN_DEPLOY |
| 4 | インストール（Probe / Gateway） | [01. コマンド > Probe 関連](01-commands.md#nco-p-syslog) | 各 Probe / Gateway の install.txt（同梱） | S_OMN_PROBE_GW |
| 5 | ObjectServer 起動・停止 | [08. cfg-objserv-create](08-config-procedures.md#cfg-objserv-create) | Administration Guide Chapter 1 / Best Practices Guide v1.3 Chapter 4 | S_OMN_ADMIN, S_OMN_BP |
| 6 | omni.dat / interfaces / nco_xigen | [03. omni.dat](03-glossary.md#omni-dat) | Administration Guide Appendix C / Best Practices Guide v1.3 | S_OMN_ADMIN, S_OMN_BP |
| 7 | trigger / procedure / signal | [03. Trigger](03-glossary.md#trigger), [09. cfg-trigger-deploy](08-config-procedures.md#cfg-trigger-deploy) | SQL Reference / Best Practices Guide v1.3 Chapter 4 | S_OMN_SQL_REF, S_OMN_BP |
| 8 | alerts.status スキーマ | [02. alerts.status](02-settings.md), [03. alerts.status](03-glossary.md#alerts-status) | SQL Reference Chapter 3 / Administration Guide | S_OMN_SQL_REF, S_OMN_ADMIN |
| 9 | housekeeping（自動削除 / de-escalation） | [03. housekeeping](03-glossary.md#housekeeping-group) | Best Practices Guide v1.3 Chapter 4 (ObjectServers) | S_OMN_BP |
| 10 | SMAC（多段構成） | [03. SMAC](03-glossary.md#smac), [08. cfg-smac-aggregation](08-config-procedures.md#cfg-smac-aggregation) | Best Practices Guide v1.3 Chapter 6 + 7 (Standard Multitier Architecture) | S_OMN_BP |
| 11 | failover / controlled failback | [03. AGG_GATE](03-glossary.md#agg-gate), [08. cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) | Best Practices Guide v1.3 Chapter 7 / Administration Guide | S_OMN_BP, S_OMN_ADMIN |
| 12 | AEN | [03. AEN](03-glossary.md#aen), [08. cfg-aen-enable](08-config-procedures.md#cfg-aen-enable) | Administration Guide Chapter 6 (Configuring AEN) / Best Practices Guide v1.3 Chapter 4 | S_OMN_ADMIN, S_OMN_BP |
| 13 | Probe rules file 構文 | [03. Rules File](03-glossary.md#rules-file), [08. cfg-probe-syslog](08-config-procedures.md#cfg-probe-syslog) | Probe and Gateway Guide / Best Practices Guide v1.3 Chapter 5 | S_OMN_PROBE_GW, S_OMN_BP |
| 14 | Process Agent | [03. Process Agent](03-glossary.md#process-agent), [08. cfg-pa-deploy](08-config-procedures.md#cfg-pa-deploy) | Administration Guide / Best Practices Guide v1.3 Chapter 10 | S_OMN_ADMIN, S_OMN_BP |
| 15 | Web GUI（DASH 上） | [03. Web GUI](03-glossary.md#web-gui), [08. cfg-webgui-waapi](08-config-procedures.md#cfg-webgui-waapi) | Web GUI User's Guide / Web GUI Administration Guide | S_OMN_WEBGUI |
| 16 | WAAPI | [03. WAAPI](03-glossary.md#waapi), [01. runwaapi](01-commands.md#runwaapi) | Web GUI WAAPI User's Guide | S_OMN_WAAPI |
| 17 | EIF（Event Integration Facility） | [03. EIF](03-glossary.md#eif), [08. cfg-probe-eif](08-config-procedures.md#cfg-probe-eif) | EIF Reference / Tivoli EIF Probe Guide | S_OMN_EIF |
| 18 | ITM（IBM Tivoli Monitoring）連携 | [03. ITM](03-glossary.md#itm) | ITM Agent for OMNIbus User's Guide | S_OMN_ITM |
| 19 | SSL/TLS / FIPS / GSKit | [03. SecureMode](03-glossary.md#securemode), [08. cfg-ssl-objserv](08-config-procedures.md#cfg-ssl-objserv) | Administration Guide Security chapters / GSKit User's Guide | S_OMN_ADMIN, S_GSKIT |
| 20 | Operations Analytics（SCALA）連携 | [08. cfg-scala-link](08-config-procedures.md#cfg-scala-link) | Operations Analytics Log Analysis 連携ガイド | S_OMN_SCALA |
| 21 | NOI Event Analytics | [03. NOI](03-glossary.md#noi) | NOI 8.1 製品ドキュメント | S_NOI |
| 22 | Best Practices 全般 | 全章 | IBM Netcool/OMNIbus 8.1 Best Practices Guide v1.3（PDF） | S_OMN_BP |

## 用途別の読み順

**新規構築チーム（DBA / 監視運用 / SRE 入門者）**：
（1）→（5）→（13）→（10）→（11）→（19）→（22）

**性能トラブル対応チーム**：
（22 Chapter 4 全体）→（9）→（22 Chapter 5 Probes）→（10）→（11）

**EIF / ITM 連携チーム**：
（17）→（18）→（13）→（22 Chapter 5）

**Web GUI / WAAPI 自動化チーム**：
（15）→（16）→（22 Chapter 8 Web GUI considerations）

## Best Practices Guide v1.3 の章構成（参考）

| Chapter | テーマ | 本サイト主対応章 |
|---|---|---|
| 1 | Introduction | index.md |
| 2 | Planning | 02-settings + 11 scn-perf-tuning |
| 3 | Component requirements | 03-glossary |
| 4 | ObjectServers | 03 / 08 / 09 全般 |
| 5 | Probes | 01 / 03 / 08 (cfg-probe-*) |
| 6 | Configuring accelerated event notification | 08 cfg-aen-enable |
| 7 | Anatomy of the standard multitier architecture configuration | 08 cfg-smac-* / 09 inc-failover-resync-fail |
| 8 | Web GUI considerations | 08 cfg-webgui-waapi |
| 9 | Maintenance | 09 incident procedures |
| 10 | The Netcool Process Agent and machine start-up | 03 / 08 cfg-pa-deploy |
| 11 | Backups and disaster recovery | 11 scn-disaster-recovery |
| 12 | Other considerations | 10 out-of-scope |

詳細出典は [07. 出典一覧](07-sources.md)。
