# 対象外項目

> 本サイトでは扱わない領域を明示。30 件のユースケース + 6 シナリオが「公式マニュアル記載の事実・手順のみ」で構成されているため、定性的判断・経験則・サイト固有のノウハウが必要な領域は範囲外とする。

## カテゴリ別

### A. 製品 / コンポーネント領域外

| 項目 | 理由 | 推奨参照先 |
|---|---|---|
| LFA 6.3 以外のバージョン（6.2 系、Cloud APM の Log File Agent、ITM 7.x へのリブランディング後製品） | 本サイトは 6.3 固定 | IBM Documentation の各バージョンページ |
| IBM Tivoli Monitoring 6.3 本体（TEMS / TEPS / TEP）の単体運用 | LFA との接点のみ言及、ITM 本体は別製品 | ITM 6.3 Installation and Setup Guide / Administrator's Guide |
| IBM Cloud APM / Cloud Pak for Watson AIOps の Log File Agent | 後継製品、別アーキテクチャ | Cloud APM / Cloud Pak ドキュメント |
| Netcool/OMNIbus 8.1 単体の運用 | EIF 受信側として連携箇所のみ言及 | 本サイトの [Netcool/OMNIbus 8.1](../netcool-omnibus-8-1/) を参照 |
| IBM Operations Analytics - Log Analysis（SCALA）/ Netcool Operations Insight（NOI） | 上位製品、別ライセンス | 各製品ドキュメント |
| Tivoli Universal Agent（旧、ITM 6.2 系で deprecated） | LFA 6.3 ではなく旧 UA は対象外 | ITM 6.2 ドキュメント（参考） |
| Agent Builder で作るカスタムエージェント | 開発領域、LFA とは別パイプライン | ITM 6.3 Agent Builder User's Guide |

### B. 設計判断・経験則

| 項目 | 理由 |
|---|---|
| 1 ホストあたりの subnode 数の業務的妥当値 | ホスト性能 / 監視ログ量 / イベント発生頻度依存、定性的判断 |
| `EventFloodThreshold` の業務的閾値（`send_first 100` 等の数値選定） | 業務 SLA / 上位 Netcool 容量依存 |
| `MaxEventQueueDepth` の業務的妥当値 | エージェント停止時の許容滞留時間依存 |
| `NumEventsToCatchUp` の起動時挙動選択 | 業務的「過去ログを取り込むか / 捨てるか」の判断 |
| Severity マッピング設計（regex 抽出値 → severity 1-5） | 業務 SLA / 運用ポリシー依存 |
| カスタム属性の業務マッピング（`-myattr REGEX(.*)` 等） | 業務固有、定性的 |
| Situation 閾値（5 分間に 10 件で警告 等）の業務的設計 | 業務 SLA 依存 |
| TEP workspace のレイアウト・色設計 | 業務 / オペレータ嗜好依存 |
| EIF 中継先 Netcool 側 `tivoli_eif.rules` の業務ルール（カスタムフィールドマッピング） | Netcool 側設計領域、本サイトの [Netcool/OMNIbus 8.1](../netcool-omnibus-8-1/) と業務側で分担 |

### C. インフラ・OS 周辺（依存関係はあるが本ページ範囲外）

| 項目 | 理由 | 推奨参照先 |
|---|---|---|
| Linux / AIX / Solaris / HP-UX / Windows の OS 設定 | OS 別ドキュメントへ | 各 OS ベンダドキュメント、本サイトの [AIX 7.3](../aix-7-3/index.md) 等 |
| ログローテータ（logrotate / Windows Event Log の Archive）の OS 側設計 | OS / アプリ領域 | logrotate ドキュメント、各 OS ドキュメント |
| syslogd / rsyslog / systemd-journald の OS 側設定 | OS 領域 | 各 syslog 実装ドキュメント |
| ファイルパーミッション / ACL / SELinux | OS / セキュリティ領域 | 各 OS ドキュメント |
| HACMP / Microsoft Cluster Service / VCS / Pacemaker の Cluster 設計 | クラスタソフト領域 | 各クラスタ製品ドキュメント |
| ファイルシステム選定（JFS2 / XFS / NTFS / ZFS） | ストレージ領域 | 各 FS ドキュメント |
| ネットワーク FW / NAT / プロキシ設計（TEMS / EIF 通信路） | NW セキュリティ領域 | ベンダドキュメント |
| 文字エンコーディング / locale / NLS 環境 | OS 領域、`-utf8` 指定や locale 環境変数の妥当値は環境依存 | 各 OS ドキュメント |
| z/OS の SYSLOG / OPERLOG / SMF レコード | LFA 6.3 はテキストファイルのみ対応で z/OS のシステムログを直接読まない | 本サイトの [z/OS 3.1](../z-os-3-1/index.md) |

### D. 運用ナレッジ・サイト固有

| 項目 | 理由 |
|---|---|
| 既存 LFA 6.2 / Tivoli Universal Agent からのマイグレーション手順 | 旧構成依存、案件ごと |
| 大規模災害時の人的運用手順 | 業務 BCP 領域 |
| カスタム regex の業務マッピング辞書（製品ログ別の typical pattern 集） | 業務固有 |
| TEP のカスタムテーマ / ブランディング | 業務固有 |
| Netcool 側 alerts.status カラム設計（カスタムフィールド追加） | Netcool 側設計領域 |
| Compliance / Audit としてのログ保全（WORM / S3 immutability 連携） | 別領域、LFA はリアルタイム監視で長期保全は別アーキテクチャ |

### E. 開発 / API 系

| 項目 | 理由 |
|---|---|
| Agent Builder で作るカスタムエージェント | 別エージェント、LFA とは別パイプライン |
| カスタム属性グループの新規定義 | Agent Builder 領域 |
| カスタム value specifier の追加（Java / C++ で拡張） | 開発領域、IBM サポート連携 |
| `runwaapi` 等 Netcool 側 API 自動化（LFA で発生したイベント側からトリガする WAAPI 呼び出し） | Netcool 側 API 領域、本サイトの [Netcool/OMNIbus 8.1 / 02 コマンド](../netcool-omnibus-8-1/01-commands.md) |
| ChatOps（Slack / Teams）通知の自動化 | 個別案件、Netcool / 上位製品の領域 |

### F. ライセンス / 課金

| 項目 | 理由 |
|---|---|
| ITM 6.3 / LFA / TEP のライセンス計算 | 商用契約領域 |
| Tivoli ライセンスから Cloud Pak ライセンスへの移行 | 営業 / 契約領域 |
| Per-MSU / Per-Endpoint / Per-Server 課金モデルの選択 | 営業 / 契約領域 |

### G. 高可用 / DR の高度設計

| 項目 | 理由 |
|---|---|
| マルチサイト DR（複数地理拠点で Hub TEMS を冗長化、TEP との切替） | 案件・NW 設計依存 |
| Active-Active マルチサイト構成（Hot Standby Hub TEMS） | 案件依存 |
| EIF キャッシュ（`EIFCachePath`）のクラスタ間共有設計 | 案件依存、要 IBM サポート相談 |
| RTO / RPO の業務目標定義 | 業務 BCP 領域 |
| 監査ログとしての改ざん防止保全（WORM / Immutable Storage） | 別領域 |

### H. その他（LFA 範囲外）

| 項目 | 理由 |
|---|---|
| ログ集約・解析プラットフォーム単体（Splunk / Elastic / Loki / Datadog） | 別エコシステム |
| SIEM 統合（QRadar / Splunk ES）単体運用 | 別製品領域、Netcool 経由連携箇所のみ言及 |
| アプリケーション側のログ出力設計（log4j / log4net / java.util.logging のレイアウト指定） | 各アプリ / フレームワーク側領域 |
| Grafana / Prometheus / Datadog への metric 連携 | 個別カスタム |

---

## 範囲内 / 範囲外の判定基準

**本サイトは範囲内**：

- IBM 公式ドキュメント（特に Tivoli Log File Agent 6.3 User's Guide / S3）に **明示的に書かれている事実・手順**
- 標準 `.conf` ディレクティブ / `.fmt` 構文 / 属性グループの用法
- TEMS 接続・EIF 中継の標準フロー
- ITM 6.3 共通の `itmcmd` / `tacmd` コマンドの LFA に関連する範囲

**本サイトは範囲外**：

- 設計判断（A vs B のどちらが業務に合うか）の助言
- AI が苦手な定性的「これくらいが目安」「ベテラン判断」
- 個別案件のサイジング・コスト試算
- 公式ドキュメントに無いノウハウ・経験則
- 別製品（ITM 本体 / Netcool / SIEM / 後継 Cloud Pak）の単体運用

範囲外の項目に踏み込みたい場合：

- IBM サポート / SME（Subject Matter Expert）に相談
- IBM Redbooks / Redpapers の関連書籍（IBM Tivoli Monitoring Implementation 等）
- 外部コミュニティ（IBM Community / Stack Overflow / Tivoli User Group）

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
