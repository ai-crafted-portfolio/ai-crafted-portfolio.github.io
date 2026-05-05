# マニュアル参照マップ

> GDP 12.x の公式マニュアル群と、本サイト各章とのマッピング。テーマから「次に読むべき公式ドキュメント」を引く目的。**22 テーマ**。

## マッピングの主軸

GDP 12.x の公式ドキュメントは IBM Documentation（旧 Knowledge Center）の **「IBM Guardium Data Protection 12.x」** 配下に Web 形式で整理されている（一部 PDF も提供）。本サイトの 96 source（[07. 出典一覧](07-sources.md) S1-S96）は ChromaDB に投入済の Web ベースで、12.x 系を網羅。本ページではテーマ別に：

- **本サイトの該当章**
- **対応する公式ドキュメントセクション**
- **読み始めの推奨章**

をマッピング。

| # | テーマ | 本サイト章 | 公式ドキュメント該当セクション | 出典 ID |
|---|---|---|---|---|
| 1 | 製品アーキテクチャ全体像 | [index.md](index.md) | IBM Guardium Data Protection / Components and topology / Getting started with UI | S1, S4, S5, S7 |
| 2 | What's new / リリース情報 | [02. コマンド](01-commands.md), [03. 設定値](02-settings.md) | What's new in this release / Release information | S2, S3 |
| 3 | アプライアンスインストール（Collector/Aggregator/CM） | [09. cfg-appliance-deploy](08-config-procedures.md#cfg-appliance-deploy) | Installing your Guardium system / Installing patches / Upgrading Guardium | S30, S31, S32 |
| 4 | S-TAP / GIM インストール | [09. cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) | GIM overview / Installing GIM client and S-TAP / S-TAP for Linux/UNIX/Windows | S34, S35 |
| 5 | S-TAP for z/OS（DB2 / IMS / Datasets） | [09. cfg-stap-zos](08-config-procedures.md#cfg-stap-zos) | S-TAP for DB2 on z/OS / IMS on z/OS / Data Sets on z/OS / z/OS S-TAP troubleshooting | S24, S25, S26, S27 |
| 6 | Inspection Engine | [03. Inspection Engine](03-glossary.md#inspection-engine), [09. cfg-inspection-engine](08-config-procedures.md#cfg-inspection-engine) | Configuring inspection engines / Buffer usage monitor / Self monitoring | S84, S39, S40 |
| 7 | Policy / Rule 設計 | [03. Policy](03-glossary.md#policy), [09. cfg-policy-build](08-config-procedures.md#cfg-policy-build) | Policies and rules / Rule actions / Policy rule actions / Managing policies / Policies overview | S9, S10, S11, S49, S85 |
| 8 | Policy Installation / Analyzer | [03. Policy Installation](03-glossary.md#policy-installation) | Policy installation / Using the Policy Installation tool / Running policy analyzer | S12, S50, S51 |
| 9 | Group / Tag / Values | [03. Group](03-glossary.md#group), [09. cfg-group-define](08-config-procedures.md#cfg-group-define) | Groups / Groups overview / Values and groups in rules / Importing rules by tag | S21, S58, S52, S53 |
| 10 | Audit Process / Compliance Workflow | [03. Audit Process](03-glossary.md#audit-process), [09. cfg-audit-process](08-config-procedures.md#cfg-audit-process) | Audit process / Compliance workflow automation / Building audit processes | S17, S18, S89 |
| 11 | Smart assistant / Compliance Templates | [09. cfg-compliance-template](08-config-procedures.md#cfg-compliance-template) | Smart assistant for compliance monitoring / Smart assistant for monitoring / Centralize compliance monitoring / Creating data compliance control | S61, S88, S62, S63 |
| 12 | Reports / Query-Report Builder | [03. Predefined Reports](03-glossary.md#predefined-reports) | Queries and reports / Predefined user reports / Predefined admin reports / Predefined common reports / Report building / Queries and reports overview | S13, S14, S15, S54, S16, S86 |
| 13 | Alerts / Threshold | [09. cfg-alert-route](08-config-procedures.md#cfg-alert-route) | Alerts / Predefined alerts | S22, S23 |
| 14 | Active Threat Analytics（ATA） | [03. ATA](03-glossary.md#ata), [09. cfg-ata-tune](08-config-procedures.md#cfg-ata-tune) | Active Threat Analytics / Identifying and investigating risks | S48, S6 |
| 15 | Vulnerability Assessment（VA） | [03. VA](03-glossary.md#va), [09. cfg-va-scan](08-config-procedures.md#cfg-va-scan) | Introducing Guardium VA / VA database privileges | S28, S29 |
| 16 | Discovery / Classification | [03. Discovery](03-glossary.md#discovery), [09. cfg-discovery-classify](08-config-procedures.md#cfg-discovery-classify) | Classification / Sensitive data discovery | S46, S47 |
| 17 | Access Management / Roles | [03. Access Manager](03-glossary.md#access-manager), [09. cfg-rbac-design](08-config-procedures.md#cfg-rbac-design) | Access management / User roles / Managing access to Guardium / Access for default roles and applications / Creating a role with minimal access | S19, S20, S55, S56, S57 |
| 18 | CAS / 構成監査 | [03. CAS](03-glossary.md#cas) | Configuration Auditing System (CAS) | S59 |
| 19 | Datasource / DB 構成 | [03. Datasource](03-glossary.md#datasource), [09. cfg-datasource-register](08-config-procedures.md#cfg-datasource-register) | Datasource definitions / Configure database auditing | S36, S60 |
| 20 | CLI（appliance） | [02. コマンド](01-commands.md) | CLI reference / CLI Commands overview / Using the CLI / System CLI commands / Configuration and control CLI / File handling CLI commands / Support CLI commands / Network configuration CLI / User account and authentication CLI | S44, S64, S65, S66, S67, S68, S69, S70, S71 |
| 21 | GuardAPI / REST API | [02. コマンド > grdapi](01-commands.md) | GuardAPI and REST API commands | S72 |
| 22 | Archive / Purge / Long-term retention / Backup | [09. cfg-archive-purge](08-config-procedures.md#cfg-archive-purge) | Backup and restore / Data archive and purge / Scheduling / Central Manager and Aggregator / Managing data: archive, restore, aggregation / Planning archiving and scheduling / Exporting data (aggregation) / Purging data to resolve full disk | S33, S41, S42, S43, S80, S81, S82, S79 |

## 用途別の読み順

**新規構築チーム（DBA / セキュリティ運用 / SRE 入門者）**：
（1）→（3）→（4）→（6）→（7）→（10）→（17）→（22）

**Compliance 自動化チーム**：
（10）→（11）→（12）→（13）→（22）

**性能トラブル対応チーム**：
（6）→（20）→（22）→ Sniffer overload / Disk full の障害手順（[10. inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload)）

**Cloud DB / コンテナ DB 監視チーム**：
External S-TAP / Edge Gateway 2.x / Universal Connector → 12.x の What's new セクション（S2）

**Web GUI / API 自動化チーム**：
（20）→（21）→ GuardAPI のサンプルは IBM Docs Web の grdapi リファレンスで確認

## 公式マニュアルの章構成（参考、12.x 系）

| Chapter / Section | テーマ | 本サイト主対応章 |
|---|---|---|
| Overview | 製品概要 | index.md |
| What's new in this release | リリース変更点 | 01 / 02 全般 |
| Components and topology | アーキテクチャ | index.md / 03-glossary |
| Getting started with UI / System view | UI 入門 | 04-playbook |
| Data activity monitoring | 監査の中核 | 03 / 09 / 12 |
| Policies and rules | Policy 設計 | 03 / 09 / 12 |
| Queries and reports | レポート | 03 / 12 |
| Audit process | 監査プロセス | 03 / 09 / 12 |
| Alerts | 通知設定 | 09 / 12 |
| Active Threat Analytics | 高度脅威検知 | 03 / 09 |
| Access management | RBAC | 03 / 09 |
| S-TAP for z/OS | メインフレーム監視 | 09 (cfg-stap-zos) |
| Vulnerability Assessment | 脆弱性評価 | 03 / 09 / 12 |
| Installing / Upgrading | 設置 / 更新 | 09 |
| Backup and restore / Archive / Purge | データ保持 | 09 / 12 |
| GIM overview / Installing GIM client and S-TAP | GIM | 09 / 12 |
| Datasource definitions | DB 接続定義 | 09 / 12 |
| Certificate management | 証明書 | 09 |
| System performance and monitoring / Buffer usage monitor / Self monitoring | 自己監視 | 10 |
| CLI reference / GuardAPI and REST API commands | CLI / API | 02 |
| Troubleshooting / Aggregation / Sniffer overload / Investigation dashboard | 障害対応 | 10 |
| Smart assistant / Centralize compliance monitoring / Creating data compliance control | コンプライアンス自動化 | 09 / 11 (シナリオ) |

詳細出典は [07. 出典一覧](07-sources.md)。

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
