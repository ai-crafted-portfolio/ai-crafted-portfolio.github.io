# 対象外項目

> 本サイトでは扱わない領域を明示。30 件のユースケース + 6 シナリオが「公式マニュアル記載の事実・手順のみ」で構成されているため、定性的判断・経験則・サイト固有のノウハウが必要な領域は範囲外とする。

## カテゴリ別

### A. 製品 / コンポーネント領域外

| 項目 | 理由 | 推奨参照先 |
|---|---|---|
| GDP 12.x 以外のバージョン（11.x、10.x） | 本サイトは 12.x 固定 | IBM Documentation の各バージョンページ |
| IBM Guardium Insights（クラウド側 SaaS）単体 | GDP との連携箇所のみ言及、Insights 自体は別製品 | Guardium Insights 製品ドキュメント |
| IBM Security Guardium Vulnerability Assessment（独立製品としての側面） | GDP に同梱の VA 機能のみ言及、独立製品としての利用は別 | Guardium VA 製品ドキュメント |
| QRadar / Splunk / Elastic 単体の運用 | アラート連携箇所のみ言及、SIEM 自体は別製品 | 各 SIEM ベンダドキュメント |
| Edge Gateway 2.x / Universal Connector の Kubernetes 運用詳細 | Helm Chart / Terraform / EKS / OpenShift / K3s の詳細運用は別製品領域 | Edge Gateway / K8s ベンダドキュメント |
| Cloud-native Guardium on OpenShift（Cloud Pak for Security 統合版） | コンテナ版 Guardium は別製品 | Cloud Pak for Security ドキュメント |

### B. 設計判断・経験則

| 項目 | 理由 |
|---|---|
| Collector のサイジング目安（X DB / Y events/sec で Z GB） | 環境・rules 設計・hardware 依存、定性的判断 |
| 業務上の Severity マッピング設計 | 業務 SLA / 運用ポリシー依存 |
| Inspection Engine 配置設計（1 Collector に何 Engine） | DB トラフィック特性 / 性能要件 / 法令要件依存 |
| Daily Archive 保持期間の業務的妥当値 | 業務上の保全期間 / コンプライアンス依存（PCI-DSS / SOX で要件異なる） |
| custom Policy / Rule の業務ロジック設計 | 業務固有、定性的 |
| Group の populate query の業務マッピング | 業務固有 |
| ATA / Outliers Mining のベースライン期間調整 | 業務サイクル依存 |
| VA テンプレートの業務カスタマイズ | 業務 / 規制依存 |

### C. インフラ・OS 周辺（依存関係はあるが本ページ範囲外）

| 項目 | 理由 | 推奨参照先 |
|---|---|---|
| Linux / AIX / Windows の OS 設定 | OS 別ドキュメントへ | 各 OS ベンダドキュメント、本サイトの [AIX 7.3](../aix-7-3/index.md) 等 |
| z/OS の Db2 / IMS / RACF 設定詳細 | z/OS / Db2 領域 | 本サイトの [z/OS 3.1](../z-os-3-1/index.md), [Db2 for z/OS 13](../db2-for-zos-13/index.md) |
| K-TAP のカーネルモジュール署名 / Secure Boot | OS / カーネル領域 | 各 Linux ディストリビューションドキュメント |
| SAN / NAS の I/O 設計（`/var` パーティション） | ストレージベンダ領域 | ストレージベンダドキュメント |
| AWS S3 / Azure Blob / GCS の bucket / IAM 設計 | クラウドベンダ領域 | 各クラウドベンダドキュメント |
| EKS / OpenShift / K3s 上の Edge Gateway / VA Scanner 運用 | Kubernetes 領域 | 各 K8s プラットフォームドキュメント |
| LDAP / Active Directory / SAML / Radius 統合の詳細設計 | 認証基盤領域 | 各認証基盤ドキュメント |
| ファイアウォール ACL / NAT / VPC 設計 | NW セキュリティ領域 | ベンダドキュメント |
| Aggregator のデータ複製 / DR 用ストレージ設計 | ストレージ / 個別案件依存 | ベンダドキュメント |

### D. 運用ナレッジ・サイト固有

| 項目 | 理由 |
|---|---|
| 既存 GDP 11.x / 10.x からのマイグレーション手順 | 旧構成依存、案件ごと |
| 大規模災害時の人的運用手順 | 業務 BCP 領域 |
| カスタム Policy の業務マッピング辞書 | 業務固有 |
| Web Console のカスタムテーマ / ブランディング | 業務固有 |
| カスタム Audit Process の帳票デザイン（Custom email template の HTML 詳細） | 業務固有 |
| Compliance テンプレートの社内 carve-out / 適用除外設計 | 規制 / 業務固有 |

### E. 開発 / API 系

| 項目 | 理由 |
|---|---|
| 自作 Probe（カスタム Inspection Engine）開発 | 開発領域 |
| 自作 Policy External Procedure（外部スクリプト連携） | 開発領域 |
| 自作 Audit Process Receiver（カスタム feed） | 開発領域 |
| GuardAPI を多用した社内自動化フレームワーク設計 | 開発 / 案件依存 |
| Custom Class（カスタム DB Protocol 解析） | 開発 / IBM サポート連携 |

### F. ライセンス / 課金

| 項目 | 理由 |
|---|---|
| GDP / S-TAP / VA / ATA のライセンス計算 | 商用契約領域 |
| Trial license 90 日 + 延長 1 回 90 日の運用ノウハウ | 営業 / 契約領域 |
| IBM Cloud Pak for Security へのバンドル価格 | 営業 / 契約領域 |
| Per-DB / Per-CPU / Per-MSU 課金モデルの選択 | 営業 / 契約領域 |

### G. 高可用 / DR の高度設計

| 項目 | 理由 |
|---|---|
| マルチサイト DR（複数地理拠点間でのレプリ） | 案件・NW 設計依存 |
| Active-Active マルチサイト構成 | 案件依存 |
| Backup 取得頻度・retention の業務 SLA | 業務 BCP 領域 |
| RTO / RPO の業務目標定義 | 業務 BCP 領域 |
| Aggregator 復元戦略（archive 互換性、Backup and restore の運用） | 案件 / IBM サポート連携 |

### H. その他（GDP 範囲外）

| 項目 | 理由 |
|---|---|
| DLP（Data Loss Prevention）製品との連携詳細 | 別製品領域 |
| Database Encryption 製品との連携詳細 | 別製品領域 |
| Privileged Access Management（PAM）製品との連携詳細 | 別製品領域 |
| ChatOps（Slack / Teams）通知の自動化テンプレート | 個別案件、external procedure / Audit Process Receiver の自作領域 |
| Grafana / Prometheus / Datadog への metric 連携 | 個別カスタム |

---

## 範囲内 / 範囲外の判定基準

**本サイトは範囲内**：

- IBM 公式ドキュメント（特に IBM Docs Web S1-S96）に **明示的に書かれている事実・手順**
- 標準 Policy / Inspection Engine / Audit Process / VA / Smart assistant / GuardAPI / CLI の用法
- Daily Archive / Daily Import / Daily Purge の標準フロー

**本サイトは範囲外**：

- 設計判断（A vs B のどちらが業務に合うか）の助言
- AI が苦手な定性的「これくらいが目安」「ベテラン判断」
- 個別案件のサイジング・コスト試算
- 公式ドキュメントに無いノウハウ・経験則
- 別製品（Insights / VA 単独 / SIEM / DLP / PAM）の単体運用

範囲外の項目に踏み込みたい場合：

- IBM サポート / SME（Subject Matter Expert）に相談
- IBM Redbooks / Redpapers の関連書籍（Database Activity Monitoring with Guardium 等）
- 外部コミュニティ（IBM Community / Stack Overflow）

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
