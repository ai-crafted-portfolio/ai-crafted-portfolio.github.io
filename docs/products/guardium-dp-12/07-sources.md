# 出典一覧

> 本サイトで参照する公式マニュアル・PDF・補完資料の出典 ID 表。**40 件**（IBM Docs Web 25 + 主要拡張章 + 補完 14）。詳細な 96 source の全件リスト（S1-S96）は本サイトの旧 7 シート版 [`ibm-guardium-data-protection/06-sources.md`](../ibm-guardium-data-protection/06-sources.md) と一致。

## 出典 ID 命名規則

- `S1`-`S96`：旧 7 シート版から継承した IBM Docs Web ベースの自動採番（各 source の正規 URL は `https://www.ibm.com/docs/en/gdp/12.x?topic=...`）
- `S_GIM_*` / `S_STAP_*`：S-TAP / GIM 個別ドキュメント
- `S_GI_*`：Guardium Insights / Edge Gateway 関連
- `S_RBC_*`：Redbook / Redpaper（補完）
- `S_*_RFC`：横断技術（PCI-DSS / FIPS / TLS RFC 等）

## 主要出典（GDP 公式 IBM Docs Web）

| 出典 ID | ドキュメント名 | 形態 | 主に参照する章 |
|---|---|---|---|
| **S1** | IBM Guardium 製品概要（ja） | Web | index, 03 用語集 |
| **S2** | What's new in this release（**12.0/12.1/12.1.1/12.2/12.2.1/12.2.2 統合**） | Web | 01, 02, 03 全章 |
| S3 | Release information | Web | index |
| S4 | Components and topology | Web | index, 03 アーキテクチャ |
| S5 | Getting started with UI | Web | 04 playbook |
| S6 | Identifying and investigating risks | Web | 03 ATA, 09 cfg-ata-tune |
| S7 | System view | Web | index, 04 |
| S8 | Data activity monitoring | Web | 03, 09, 12 |
| S9 | Policies and rules | Web | 03 Policy, 09 cfg-policy-build |
| S10 | Rule actions | Web | 02, 03, 09 |
| S11 | Managing policies | Web | 09 cfg-policy-build |
| S12 | Policy installation | Web | 03 Policy Installation, 09 全般 |
| S13 | Queries and reports | Web | 12 |
| S14 | Predefined user reports | Web | 12 |
| S15 | Predefined admin reports | Web | 12 |
| S16 | Report building | Web | 12 |
| S17 | Audit process | Web | 03 Audit Process, 09 cfg-audit-process |
| S18 | Compliance workflow automation | Web | 03 Compliance Workflow |
| S19 | Access management | Web | 03 Access Manager, 09 cfg-rbac-design |
| S20 | User roles | Web | 09 cfg-rbac-design |
| S21 | Groups | Web | 03 Group, 09 cfg-group-define |
| S22 | Alerts | Web | 09 cfg-alert-route, 12 |
| S23 | Predefined alerts | Web | 12 |
| S28 | Introducing Guardium VA | Web | 03 VA, 09 cfg-va-scan |
| S29 | VA database privileges | Web | 09 cfg-va-scan |

## S-TAP / GIM / インストール

| 出典 ID | ドキュメント名 | 形態 | 主に参照する章 |
|---|---|---|---|
| S24 | S-TAP for DB2 on z/OS | Web | 09 cfg-stap-zos |
| S25 | S-TAP for IMS on z/OS | Web | 09 cfg-stap-zos |
| S26 | S-TAP for Data Sets on z/OS | Web | 09 cfg-stap-zos |
| S27 | z/OS S-TAP troubleshooting | Web | 10 inc-stap-conn-fail |
| S30 | Installing your Guardium system | Web | 09 cfg-appliance-deploy |
| S31 | Installing patches | Web | 09 cfg-patch-install |
| S32 | Upgrading Guardium | Web | 09 cfg-upgrade |
| S33 | Backup and restore | Web | 09 cfg-archive-purge |
| S34 | GIM overview | Web | 03 GIM, 09 cfg-stap-deploy |
| S35 | Installing GIM client and S-TAP | Web | 09 cfg-stap-deploy |
| S36 | Datasource definitions | Web | 09 cfg-datasource-register |
| S37 | Certificate management | Web | 09 cfg-cert-rotation |

## CLI / API / Troubleshooting / Archive / Purge

| 出典 ID | ドキュメント名 | 形態 | 主に参照する章 |
|---|---|---|---|
| S39 | Buffer usage monitor | Web | 02 設定値, 10 inc-sniffer-overload |
| S40 | Self monitoring | Web | 10 inc-sniffer-overload |
| S41 | Data archive and purge | Web | 09 cfg-archive-purge |
| S42 | Scheduling | Web | 02 設定値 |
| S43 | Central Manager and Aggregator | Web | index, 03, 09 cfg-cm-managed-unit |
| S44 | CLI reference | Web | 01 コマンド |
| S45 | Troubleshooting | Web | 10 全章 |
| S46 | Classification | Web | 03 Discovery, 09 cfg-discovery-classify |
| S47 | Sensitive data discovery | Web | 09 cfg-discovery-classify |
| S48 | Active Threat Analytics | Web | 03 ATA, 09 cfg-ata-tune |
| S49 | Policy rule actions | Web | 03 Rule Action, 09 cfg-policy-blocking |
| S50 | Using the Policy Installation tool | Web | 09 cfg-policy-build |
| S51 | Running policy analyzer | Web | 09 cfg-policy-build |
| S52 | Values and groups in rules | Web | 09 cfg-group-define |
| S53 | Importing rules by tag | Web | 09 cfg-group-define |
| S54 | Predefined common reports | Web | 12 |
| S55 | Managing access to Guardium | Web | 09 cfg-rbac-design |
| S56 | Access for default roles and applications | Web | 09 cfg-rbac-design |
| S57 | Creating a role with minimal access | Web | 09 cfg-rbac-design |
| S58 | Groups overview | Web | 09 cfg-group-define |
| S59 | Configuration Auditing System (CAS) | Web | 03 CAS |
| S60 | Configure database auditing | Web | 09 cfg-datasource-register |
| S61 | Smart assistant for compliance monitoring | Web | 09 cfg-compliance-template |
| S62 | Centralize compliance monitoring | Web | 09 cfg-compliance-template |
| S63 | Creating data compliance control | Web | 09 cfg-compliance-template |
| S64 | CLI Commands overview | Web | 01 コマンド |
| S65 | Using the CLI | Web | 01 コマンド |
| S66 | System CLI commands | Web | 01 コマンド |
| S67 | Configuration and control CLI | Web | 01 コマンド |
| S68 | File handling CLI commands | Web | 01 cfg-fileserver |
| S69 | Support CLI commands | Web | 01 support, 10 全章 |
| S70 | Network configuration CLI | Web | 01 network |
| S71 | User account and authentication CLI | Web | 01 user |
| S72 | GuardAPI and REST API commands | Web | 01 grdapi |
| S73 | Techniques for troubleshooting | Web | 10 全章 |
| S74 | Configuring Guardium system troubleshooting | Web | 10 全章 |
| S75 | Aggregation troubleshooting | Web | 10 inc-aggregator-import-fail |
| S76 | Sniffer overload issues | Web | 10 inc-sniffer-overload |
| S77 | Troubleshooting investigation dashboard | Web | 10 inc-web-ui-slow |
| S78 | Getting fixes from Fix Central | Web | 09 cfg-patch-install |
| S79 | Purging data to resolve full disk | Web | 10 inc-disk-full |
| S80 | Managing data: archive, restore, aggregation | Web | 09 cfg-archive-purge |
| S81 | Planning archiving and scheduling | Web | 09 cfg-archive-purge |
| S82 | Exporting data (aggregation) | Web | 09 cfg-archive-purge |
| S83 | Certificates management | Web | 09 cfg-cert-rotation |
| S84 | Configuring inspection engines | Web | 02 設定値, 09 cfg-inspection-engine |
| S85 | Policies overview | Web | 03 Policy |
| S87 | Session-level policies | Web | 09 cfg-policy-session |
| S88 | Smart assistant for monitoring | Web | 09 cfg-compliance-template |
| S89 | Building audit processes | Web | 09 cfg-audit-process |
| S90 | Central management overview | Web | 09 cfg-cm-managed-unit |
| S92 | Collectors overview | Web | index, 03 |
| S94 | Session-level policies (dup) | Web | 09 cfg-policy-session |

## 補完（横断技術 / 関連製品）

| 出典 ID | ドキュメント名 | 形態 | 主に参照する章 |
|---|---|---|---|
| S_GI_INSIGHTS | IBM Guardium Insights ドキュメント（クラウド側） | Web | 03 Guardium Insights |
| S_GI_EDGE_GW | Edge Gateway 2.x（Kubernetes ベース）リファレンス | Web | 03 Edge Gateway, 09 cfg-cloud-monitoring |
| S_RBC_DAM | IBM Redbooks - Database Activity Monitoring with Guardium | Redbook | 03 全般（補完） |
| S_PCI_DSS | PCI Security Standards Council - PCI DSS 4.0 | Web | 09 cfg-compliance-template |
| S_HIPAA | HHS HIPAA Security Rule | Web | 09 cfg-compliance-template |
| S_SOX | Sarbanes-Oxley Act / PCAOB Auditing Standards | Web | 09 cfg-compliance-template |
| S_DORA | EU Digital Operational Resilience Act | Web | 09 cfg-compliance-template |
| S_NYDFS | NY DFS 23 NYCRR 500 | Web | 09 cfg-compliance-template |
| S_NIST_800_53 | NIST SP 800-53 | Web | 09 cfg-compliance-template |
| S_NERC_CIP | NERC CIP-005 / 011 | Web | 09 cfg-compliance-template |
| S_TLS_RFC | RFC 8446（TLS 1.3）/ RFC 5246（TLS 1.2） | Web | 03 SSL/TLS |
| S_FIPS_140 | NIST FIPS 140-2 / 140-3 | Web | 03 FIPS |
| S_S3_API | AWS S3 API（互換オブジェクトストレージ） | Web | 09 cfg-archive-purge |
| S_HELM_VA | Helm Charts for VA Scanner（IBM Charts） | Web | 09 cfg-va-scan |

---

## 参照ポリシー

- **IBM Docs Web の 12.x ベース** が中核：本サイトの記述の根拠は IBM Documentation の Guardium Data Protection 12.x 配下のページ。固定 URL ではなく **出典 ID と Topic 名** で IBM Documentation 内検索を推奨（IBM 側の URL 構造変更に追随）。
- **What's new in this release（S2）が動的中核**：12.0 → 12.2.2 までの新機能追加（ATA case 一括クローズ、API-only User、cold storage 統合 API、VA Scanner 対応 DB 拡張、Smart assistant 統合等）の根拠はすべて S2。
- **本サイトでカバーしない領域**（[11. 対象外項目](10-out-of-scope.md)）はそれぞれの公式ドキュメントへの直接参照を推奨。

## 引用方針

- 本サイトの記述末尾には `S*` 出典 ID を列挙
- 引用は事実・手順の根拠提示のみ（コピペは原則行わず、IBM Docs の趣旨を再構成して掲載）
- 公式ドキュメントの URL は IBM 側の改訂で頻繁に変わるため、本ページでは固定 URL を載せず、上記の出典 ID と Topic 名で IBM Documentation 内検索を推奨

---

*v1 では IBM Docs Web 96 source（S1-S96）すべてを ChromaDB の `manual_docs` collection 投入対象とし、`mcp__education-rag__search_manual` から横断検索可能にする方針。投入用スクリプトはリポジトリルートの `ingest_guardium_concurrent.py`（PowerShell 別ウィンドウから `RUN_guardium_ingest.bat` で起動、Cowork 停止不要、retry+backoff 内蔵）を参照。*
