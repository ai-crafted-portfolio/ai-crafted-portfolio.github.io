# 対象外項目

> 本サイトでは扱わない領域を明示。30 件のユースケース + 6 シナリオが「公式マニュアル記載の事実・手順のみ」で構成されているため、定性的判断・経験則・サイト固有のノウハウが必要な領域は範囲外とする。

## カテゴリ別

### A. 製品 / コンポーネント領域外

| 項目 | 理由 | 推奨参照先 |
|---|---|---|
| OMNIbus 8.1 以外のバージョン（v7.x、v9 系の新機能） | 本サイトは 8.1.0 / 8.1.x 固定 | IBM Documentation の各バージョンページ |
| Netcool/Impact 単体の運用 | OMNIbus との連携箇所のみ言及、Impact 自体は別製品 | Netcool/Impact 製品ドキュメント |
| Netcool Operations Insight（NOI）Event Analytics 単体 | 連携で言及するが NOI 自体は別製品 | NOI 8.1 製品ドキュメント |
| IBM Tivoli Monitoring（ITM / TEMS）単体 | EIF Probe 経由の OMNIbus 連携のみ言及 | ITM 製品ドキュメント |
| Tivoli Enterprise Portal | OMNIbus と連携する可視化 UI、本サイト範囲外 | Tivoli Enterprise Portal ドキュメント |
| Cloud-native Netcool Operations Insight on Red Hat OpenShift | コンテナ版は別製品扱い | NOI on OpenShift ドキュメント |

### B. 設計判断・経験則

| 項目 | 理由 |
|---|---|
| ObjectServer のメモリサイジング目安（X 万行で Y GB） | 環境・rules 設計・hardware 依存、定性的判断 |
| 業務上の Severity マッピング設計 | 業務 SLA / 運用ポリシー依存 |
| Probe 多重化の物理サーバ配置設計 | NW トポロジ・SLA 依存 |
| 適切な Granularity 値の決定 | UI 反応性 / ObjectServer 負荷の trade-off、案件依存 |
| ExpireTime の業務的妥当値 | 業務上の保全期間 / コンプライアンス依存 |
| custom trigger の業務ロジック設計 | 業務固有、定性的 |
| Web GUI のフィルタ / ビュー命名・分類体系 | チーム運用ナレッジ依存 |

### C. インフラ・OS 周辺（依存関係はあるが本ページ範囲外）

| 項目 | 理由 | 推奨参照先 |
|---|---|---|
| AIX / Linux / Solaris / Windows の OS 設定 | OS 別ドキュメントへ | 各 OS ベンダドキュメント、本サイトの [AIX 7.3](../aix-7-3/index.md) 等 |
| systemd unit の詳細設計 | systemd の領域 | systemd Documentation |
| SAN / NAS の I/O 設計 | ストレージベンダ領域 | ストレージベンダドキュメント |
| WebSphere Application Server / DASH の運用 | 別製品 | WAS / DASH ドキュメント |
| Java JRE のチューニング | Java 領域 | Java vendor ドキュメント |
| LDAP / Active Directory 統合の詳細 | 認証基盤領域 | 各 LDAP ドキュメント |
| ファイアウォール ACL / NAT 設計 | NW セキュリティ領域 | ベンダドキュメント |
| ロードバランサ / VIP 構成 | 個別案件依存 | ベンダドキュメント |

### D. 運用ナレッジ・サイト固有

| 項目 | 理由 |
|---|---|
| 既存 OMNIbus からのマイグレーション手順 | 旧構成依存、案件ごと |
| OMNIbus 7.x → 8.1 の同居運用（クラスタ移行戦略） | 案件依存 |
| 大規模災害時の人的運用手順 | 業務 BCP 領域 |
| カスタム rules の業務マッピング辞書 | 業務固有 |
| Web GUI のカスタムテーマ / ブランディング | 業務固有 |
| カスタムレポートの帳票デザイン | 業務固有 |

### E. 開発 / API 系

| 項目 | 理由 |
|---|---|
| C-based EIF アプリ開発 | 開発領域、API リファレンス参照 |
| Java EIF アプリ開発 | 開発領域 |
| WAAPI 自作スクリプトの XML 詳細仕様 | 個別案件依存、WAAPI Reference 参照 |
| ObjectServer HTTP REST API の詳細スキーマ | 個別開発依存、libnhttpd リファレンス参照 |
| カスタム Probe 開発（Probe SDK） | 開発領域 |

### F. ライセンス / 課金

| 項目 | 理由 |
|---|---|
| OMNIbus / Probe / Gateway / Web GUI のライセンス計算 | 商用契約領域 |
| ETP（Entitled Tag Processor）の運用 | ライセンス計測領域 |
| IBM Cloud Pak for Watson AIOps へのバンドル価格 | 営業 / 契約領域 |

### G. 高可用 / DR の高度設計

| 項目 | 理由 |
|---|---|
| マルチサイト DR（複数地理拠点間でのレプリ） | 案件・NW 設計依存、Best Practices Guide v1.3 Chapter 11 を参照 |
| Active-Active マルチサイト構成 | 案件依存 |
| Backup 取得頻度・retention の業務 SLA | 業務 BCP 領域 |
| RTO / RPO の業務目標定義 | 業務 BCP 領域 |

### H. その他（OMNIbus 範囲外）

| 項目 | 理由 |
|---|---|
| Kafka / RabbitMQ 等のメッセージブローカ統合 | 個別カスタム連携、Probe SDK 領域 |
| Splunk / Elastic への raw event 転送 | 個別カスタム、scala_triggers / 自作 procedure 領域 |
| Grafana / Prometheus への metric 連携 | 個別カスタム |
| ChatOps（Slack / Teams）への通知統合 | 個別案件、external procedure / Impact 経由 |

---

## 範囲内 / 範囲外の判定基準

**本サイトは範囲内**：

- IBM 公式ドキュメント（特に Best Practices Guide v1.3）に **明示的に書かれている事実・手順**
- 標準コンポーネント / 標準プロパティ / 標準 trigger group の用法
- 公式 nco_* / ObjectServer SQL コマンドの書き方

**本サイトは範囲外**：

- 設計判断（A vs B のどちらが業務に合うか）の助言
- AI が苦手な定性的「これくらいが目安」「ベテラン判断」
- 個別案件のサイジング・コスト試算
- 公式ドキュメントに無いノウハウ・経験則
- 別製品（Impact / ITM / NOI / Cloud Pak）の単体運用

範囲外の項目に踏み込みたい場合：

- IBM サポート / SME（Subject Matter Expert）に相談
- IBM Redbooks / Redpapers の関連書籍
- 外部コミュニティ（Stack Overflow / IBM Community）

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
