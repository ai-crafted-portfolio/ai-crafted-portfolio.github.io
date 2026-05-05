# IBM Guardium Data Protection 12.x

!!! info "本ページの位置付け / 関連ページ"
    本ページは **IBM Guardium Data Protection 12.x（以下 GDP 12.x）公式マニュアル系の運用リファレンス**（13 章）。日々の運用で「どの grdapi を叩くか」「どの S-TAP / Inspection Engine プロパティを変えるか」「Collector / Aggregator / Central Manager の障害時切り分け」を引く用途に最適化。

    GDP 関連の他資料：
    - **[IBM Guardium Data Protection 12.x（旧 7 シート）](../ibm-guardium-data-protection/)** — ChromaDB 投入済みドキュメント（IBM Docs Web S1-S96）から抽出した俯瞰サマリ（7 シート）。本ページの前身、概要把握用。
    - 本ページは旧 7 シート版の上位互換（13 章 + S 級 A/B/C 仮説分岐 + 期待出力サンプル）。

> IBM の DB アクティビティ監視・監査プラットフォーム。**S-TAP**（DB エージェント）→ **Collector**（受信・解析・ポリシ評価・内部 DB 格納）→ **Aggregator**（集約・長期保持・レポート）→ **Central Manager**（全体管理）の 4 階層構成。リアルタイムポリシ・監査プロセス自動化（PCI / SOX / HIPAA / DORA / NYDFS）・Vulnerability Assessment・Active Threat Analytics・Sensitive Data Discovery を 1 製品で提供。**13 章構成** で staple な grdapi / CLI コマンド・Inspection Engine / S-TAP プロパティ・用語・手順 + シナリオ別ガイド + ユースケース集を整理。**v1（GDP 12.0 / 12.1 / 12.2 系、IBM Docs 12.x ベース）に対応**。

**カテゴリ**: セキュリティ・監査 系 / DB アクティビティ監視・監査基盤

## 構成（13 章）

| セクション | 内容 |
|---|---|
| **01. 製品概要** | 製品の役割（本ページ下部） |
| [02. コマンド一覧](01-commands.md) | grdapi / CLI（System / File handling / Support / Network / User / Configuration）/ S-TAP / GIM **45 件** |
| [03. 設定値一覧](02-settings.md) | Inspection Engine **18 件** + S-TAP / Policy / Aggregator / Central Manager **20 件** |
| [04. 用語集](03-glossary.md) | GDP 固有 **78 件**（S-TAP / K-TAP / A-TAP / GIM / Policy Group / Custom Domain / VA / ATA / Outliers 等） |
| [05. プレイブック](04-playbook.md) | 7 シーン × 3 習熟度 = **21 セル** |
| [06. トラブル早見表](05-troubleshooting.md) | 症状起点の早見 **20 件** |
| [07. マニュアル参照マップ](06-manual-map.md) | **22 テーマ** |
| [08. 出典一覧](07-sources.md) | **40 件**（IBM Docs Web 25 + Tech Notes / Redbook + 補完 14） |
| [09. 設定手順](08-config-procedures.md) | **18 件** + S 級は実機期待出力サンプル付き |
| [10. 障害対応手順](09-incident-procedures.md) | **18 件** + S 級は A/B/C 仮説分岐付き |
| [11. 対象外項目](10-out-of-scope.md) | カテゴリ別整合（30 ユースケース + 6 シナリオに対応） |
| [12. シナリオ別ガイド](11-scenarios.md) | **6 本**（新規構築 / SMAC 階層化 / Aggregator 集約 / Compliance 自動化 / Cloud DB 監視 / DR） |
| [13. ユースケース集](12-use-cases.md) | **30 件**（独立タスク粒度） |

各章の関連エントリには、設定手順 / 障害対応手順 / 用語 / ユースケースへの双方向リンクを付与。

---

## 01. 製品概要

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM Guardium Data Protection 12.x（旧 InfoSphere Guardium） | S1, S2 |
| 最新バージョン | 12.0 / 12.1 / 12.1.1 / 12.2 / 12.2.1 / 12.2.2（What's new in this release で随時追記） | S2, S3 |
| ベンダ | IBM Corporation | S1 |
| 対応 OS | アプライアンス: Red Hat Enterprise Linux ベース（IBM 提供 ISO）。S-TAP: Linux / UNIX（AIX、HP-UX、Solaris）/ Windows / IBM i / z/OS（DB2 / IMS / Datasets） | S4, S30 |
| 想定読者 | DB セキュリティ管理者、コンプライアンス担当、DBA、SOC / SRE、監査人、Guardium 運用者 | S1, S55 |
| 中核アーキテクチャ | **S-TAP（DB エージェント）**→ **Collector（解析 + 内部 DB）**→ **Aggregator（集約 + レポート）**→ **Central Manager（全体管理）**の 4 階層。Collector は最大 50 Inspection Engine を搭載。Aggregator は複数 Collector の monthly / daily import を集約、長期保持と全体レポートを担う。Central Manager は patch / 証明書 / ポリシを Managed Unit へ一括配布 | S4, S43, S90 |
| 主要監視テーブル / モデル | Sentence / Request / Command / Object / Field（Inspection Engine の Parse Tree が分解する SQL の構成要素）、内部 DB（MySQL ベース）に Activity Monitor / Reports が格納 | S8, S84 |
| 主要環境変数 / パス | S-TAP インストールルート（既定 `/usr/local/guardium`）、`guard_tap.ini`（S-TAP 設定）、`/var/log/guard`（ログ）、内部 DB は `/var` 配下 | S35 |
| 通信ポート（既定） | S-TAP→Collector: TCP 16016 / 16017（SSL）、GIM→Collector: TCP 8444 / 8445、Web UI: HTTPS 8443、SSH: 22 | S35, S37, S70 |
| 管理 GUI | Guardium UI（HTTPS Web Console、HTML5）。主要メニュー: Setup / Manage / Discover / Harden / Comply / Investigate / Reports | S5, S7 |
| 管理 CLI / API | `cli`（appliance CLI: store / show / restart / support / fileserver 系）、**GuardAPI**（grdapi、約 700+ コマンド、Policy / Datasource / Group / Audit Process の自動化）、REST API（12.2 以降強化） | S44, S64, S72 |
| セキュリティ | ロールベース UI 権限（admin / inv / user / cli / accessmgr / dbaccess 等）、Access Manager UI、Active Directory / LDAP / SAML / Radius、MFA、FIPS 140-2/140-3 (S/MIME)、証明書管理（Guardium Cryptography Manager、12.2.1 以降強化） | S19, S20, S55, S83 |
| 高可用性 | S-TAP の Primary / Failover Collector 指定、ILB（Internal Load Balancer）による Collector 間負荷分散。Aggregator の冗長は通常 active-active ではなく **Aggregation の責務分散 + Backup 戦略**（Daily Archive + Restore 経路） | S2, S33, S43 |
| Compliance 連携 | PCI-DSS / SOX / HIPAA / NIST / NERC CIP / DORA / NYDFS の Smart assistant、Audit Process Builder、Data Compliance Control（12.2 拡張） | S17, S18, S61, S62, S63 |
| ドキュメント形態 | IBM Documentation（旧 Knowledge Center）「IBM Guardium Data Protection 12.x」配下、Web 形式中心（PDF も提供される章あり） | S1, S2 |
| 関連製品（密結合） | IBM Guardium Insights（クラウドダッシュボード / Long-term retention）、IBM Security Guardium Vulnerability Assessment、IBM QRadar / Splunk / Syslog（CEF / LEEF 出力連携）、Edge Gateway 2.x、Universal Connector | S2, S48 |

!!! note "v1 の特徴"
    **z/OS 3.1 v4 / Db2 13 v1 / Netcool 8.1 v1 と同一の 13 章フレームワーク** で書き起こした初版。本サイトの旧 7 シート版（[../ibm-guardium-data-protection/](../ibm-guardium-data-protection/)）が概要俯瞰で停まっていた領域を、**S 級 18 件の設定手順 + S 級 18 件の障害対応 + 30 件の独立ユースケース** で深掘り。GDP 12.x 公式マニュアル（IBM Docs Web の 96 source、S1-S96）からの引用根拠が中心、`Inspection Engine` / `S-TAP` / `K-TAP` / `A-TAP` / `Policy Installation` / `Audit Process` / `VA` / `ATA` / `Sniffer overload` / `auto_stop_services_when_full` / `Daily Archive + Purge 順序` 等の運用メカニズム解説に重点。

!!! warning "AI 生成と人手の併用"
    本ページは公式マニュアル等の公開情報のみを根拠に整理した二次資料。AI 生成と人手の併用で作成しているため、情報の正確性は保証しない。実装・適用前には公式情報での再確認を推奨。

!!! info "v1 の図表方針"
    本サイト v1 は「テキスト網羅優先」で、IBM Docs / Redbook 由来の図表埋込は v2 以降に拡張する方針。各章の章末注に出典 ID を記載しているため、必要に応じて元 Web ドキュメント（リンクは [08. 出典一覧](07-sources.md) 参照）の図を直接参照可能。

---

## 用途別の入り口

- **「これから新規に Guardium を構築したい」** → [11. シナリオ別ガイド > scn-new-deployment](11-scenarios.md#scn-new-deployment)
- **「S-TAP を新しい DB サーバに入れたい」** → [09. cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy) + [13. uc-stap-install](12-use-cases.md#uc-stap-install)
- **「Compliance Audit Process を組みたい」** → [13. uc-audit-process](12-use-cases.md#uc-audit-process) + [11. scn-compliance-automation](11-scenarios.md#scn-compliance-automation)
- **「Sniffer / Inspection Engine がオーバーロード」** → [10. inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload)
- **「内部 DB が満杯（auto_stop_services_when_full）」** → [10. inc-disk-full](09-incident-procedures.md#inc-disk-full)
- **「S-TAP が Collector に接続しない」** → [10. inc-stap-conn-fail](09-incident-procedures.md#inc-stap-conn-fail)
- **「Aggregator への import が失敗する」** → [10. inc-aggregator-import-fail](09-incident-procedures.md#inc-aggregator-import-fail)
- **「特定の単発タスクだけやりたい（拾い読み）」** → [13. ユースケース集](12-use-cases.md)

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
