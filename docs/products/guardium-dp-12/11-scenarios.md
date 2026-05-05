# シナリオ別ガイド

> 業務全体のイメージから入りたい読者向け。各シナリオは典型的な業務状況と、関連するユースケース・手順への組み合わせ案内。

**他章との関係**:

- **本章（11. シナリオ別ガイド）**: meta レベル、業務全体の俯瞰
- **[13. ユースケース集](12-use-cases.md)**: 各ユースケースは独立完結、拾い読み可能
- 1 シナリオから複数ユースケースへリンク（1:N）

**収録シナリオ**: 6 本

| ID | タイトル | 概要 |
|---|---|---|
| [scn-new-deployment](#scn-new-deployment) | 新規 Guardium 環境の構築 | Collector 1 台 → CM 配下 → S-TAP 配備 → 初期 Policy までの全体俯瞰 |
| [scn-smac-build](#scn-smac-build) | Aggregator 集約 / 多階層化 | Collector 群 → Aggregator 集約 → CM 一元管理 + Long-term retention の組立 |
| [scn-compliance-automation](#scn-compliance-automation) | Compliance 自動化（PCI / SOX / HIPAA / DORA / NYDFS） | Smart assistant + Audit Process + Distribution Profile による規制横断展開 |
| [scn-perf-tuning](#scn-perf-tuning) | 性能チューニングと容量増設 | Buffer overload 起点の IGNORE SESSION 設計、Inspection Engine 分割、Daily Purge 確実化 |
| [scn-cloud-monitoring](#scn-cloud-monitoring) | クラウド DB 監視（External S-TAP / Edge Gateway / UC） | エージェント設置不可な AWS RDS / Azure SQL DB / Snowflake / SAP HANA への対応 |
| [scn-disaster-recovery](#scn-disaster-recovery) | 災害復旧（DR）演習・準備 | Backup and restore（S33）+ Daily Archive + Long-term retention の組合せでの DR 設計 |

!!! info "本章の品質方針"
    全シナリオは GDP 12.x 公式マニュアル（IBM Docs Web S1-S96）記載の事実・手順のみで構成。AI が苦手な定性的判断（ベストプラクティス、経験則、サイジング目安）は範囲外（[10. 対象外項目](10-out-of-scope.md) 参照）。

---

## 新規 Guardium 環境の構築 { #scn-new-deployment }

**概要**: 1 ホスト / Standalone Collector から始めて、S-TAP を 1 つ繋いで Activity Monitor で SQL が見えることを確認するまでの最短経路。本番運用前提の CM 配下化 / Aggregator 集約 / SMAC 化は次のシナリオへ。

### シナリオの状況

新しい DB セキュリティチームが立ち上がった、または検証 / PoC 用に Guardium を初めて立ち上げる状況。S-TAP（例：Db2）を 1 つ繋いで監査ログが流れることを確認するのがゴール。

### 推奨フロー（参照ユースケース）

#### Phase 1: アプライアンス準備
1. **Collector 1 台のデプロイ + 初期構成 + ライセンス投入** → [uc-appliance-deploy](12-use-cases.md#uc-appliance-deploy)

#### Phase 2: アクセス管理初期化
2. **最小権限ロール作成（admin / inv / dba_view）** → [uc-rbac-design](12-use-cases.md#uc-rbac-design)

#### Phase 3: S-TAP 投入
3. **Db2 サーバへ GIM + S-TAP 配備** → [uc-stap-install](12-use-cases.md#uc-stap-install)
4. **Inspection Engine 作成** → [uc-inspection-engine](12-use-cases.md#uc-inspection-engine)
5. **Buffer Free 健全性確認** → [uc-buffer-monitor](12-use-cases.md#uc-buffer-monitor)

#### Phase 4: 標準レポート確認
6. **Predefined Reports での監査ログ確認** → [uc-predefined-reports](12-use-cases.md#uc-predefined-reports)

#### Phase 5: 初期 Policy
7. **Policy Builder で雛形 Policy 作成 + 配備** → [uc-policy-build](12-use-cases.md#uc-policy-build)
8. **アラート配信先（SMTP）設定** → [uc-alert-route](12-use-cases.md#uc-alert-route)

### 本記事の範囲

**本記事の範囲**：Standalone Collector 1 台 + S-TAP 1 つ + 雛形 Policy で監査ログ疎通確認まで。本番展開での **CM 配下化（[scn-smac-build](#scn-smac-build)）** や **Compliance 自動化（[scn-compliance-automation](#scn-compliance-automation)）** は別シナリオ。

AI が苦手な定性的判断（業務 SLA に応じた構成サイジング、Severity マッピング設計）は範囲外。経験ある SME か IBM サポートに確認推奨。

---

## Aggregator 集約 / 多階層化 { #scn-smac-build }

**概要**: 単体 Collector から Collector 群 + Aggregator + CM の 3 階層構造へ拡張する。Long-term retention（S3 互換）を加えて長期保持も整備。

### シナリオの状況

PoC が終わって本番展開する、または既存の単体構成で容量・レポート性能・複数チームの管理境界が足りなくなってきた状況。Collector の役割を「監査受信 + 直近 15 日保持」に絞り、Aggregator で全体集約とレポート、CM で全体管理、cold storage で長期保持を切り分ける。

### 推奨フロー（参照ユースケース）

#### Phase 1: Aggregator デプロイ
1. **Aggregator アプライアンスを追加デプロイ** → [uc-appliance-deploy](12-use-cases.md#uc-appliance-deploy)（Aggregator type）

#### Phase 2: CM デプロイ + MU 登録
2. **CM アプライアンスをデプロイ** → [uc-appliance-deploy](12-use-cases.md#uc-appliance-deploy)（CM type）
3. **既存 Collector / Aggregator を CM 配下の MU として登録** → [uc-cm-managed-unit](12-use-cases.md#uc-cm-managed-unit)

#### Phase 3: Daily Archive / Daily Import / Daily Purge
4. **Collector 側 Daily Archive 設定** → [uc-archive-purge](12-use-cases.md#uc-archive-purge)
5. **Aggregator 側 Daily Import 設定（順序遵守）** → [uc-archive-purge](12-use-cases.md#uc-archive-purge)
6. **Collector / Aggregator 両側 Daily Purge** → [uc-archive-purge](12-use-cases.md#uc-archive-purge)

#### Phase 4: Long-term retention（任意）
7. **S3 互換 cold storage 構成** → [uc-cold-storage](12-use-cases.md#uc-cold-storage)

#### Phase 5: Distribution Profile
8. **CM の Distribution Profile を作成して MU 群に配布できる状態に** → [uc-cm-managed-unit](12-use-cases.md#uc-cm-managed-unit)

### 本記事の範囲

**本記事の範囲**：CM + Aggregator + Collector の 3 階層、Long-term retention まで。マルチサイト DR / Active-Active / Aggregator 二重化は **個別案件依存** で範囲外（[10. 対象外項目](10-out-of-scope.md) G カテゴリ）。

---

## Compliance 自動化（PCI / SOX / HIPAA / DORA / NYDFS） { #scn-compliance-automation }

**概要**: Smart assistant for compliance monitoring から規制テンプレートを生成し、Audit Process Builder で月次レビューを自動化、CM 経由で複数 Collector / Aggregator に配布する流れ。

### シナリオの状況

法務 / 監査部門から「PCI-DSS / SOX / HIPAA / DORA / NYDFS の証跡を月次でレビューしたい」と要件が来ている。Smart assistant で雛形を作って、Audit Process Builder で Receivers / Sign-off / 配信 / アーカイブを組み、CM の Distribution Profile で複数地域の MU に配布する。

### 推奨フロー（参照ユースケース）

#### Phase 1: 規制テンプレート展開
1. **Smart assistant で PCI-DSS テンプレート展開** → [uc-smart-assistant](12-use-cases.md#uc-smart-assistant)
2. **生成された Policy / Group / Audit Process を環境に合わせ調整** → [uc-policy-build](12-use-cases.md#uc-policy-build), [uc-group-define](12-use-cases.md#uc-group-define)

#### Phase 2: Audit Process 整備
3. **Audit Process Builder で Receivers / Sign-off / Schedule 設定** → [uc-audit-process](12-use-cases.md#uc-audit-process)
4. **Custom email template の作成（12.1+）** → [uc-audit-process](12-use-cases.md#uc-audit-process)

#### Phase 3: VA / Discovery 連動
5. **Sensitive Data Discovery で対象 Privacy Set を生成** → [uc-discovery-classify](12-use-cases.md#uc-discovery-classify)
6. **対象 DB の VA scan を Audit Process タスクに組込** → [uc-va-run](12-use-cases.md#uc-va-run)

#### Phase 4: アラート連携（SIEM）
7. **CEF / LEEF / Syslog で QRadar / Splunk へ転送** → [uc-alert-route](12-use-cases.md#uc-alert-route)

#### Phase 5: 複数 MU 配布
8. **CM の Distribution Profile で配下 MU に Audit Process / Policy を一括配信** → [uc-cm-managed-unit](12-use-cases.md#uc-cm-managed-unit)

#### Phase 6: 動作確認
9. **Run once now → Audit Process Log の正常完了 / Receivers 通知到達確認** → [uc-audit-process](12-use-cases.md#uc-audit-process)

### 本記事の範囲

**本記事の範囲**：Smart assistant 経由のテンプレート展開 + Audit Process + Distribution Profile。社内 carve-out / 適用除外の規制設計は **業務固有** で範囲外。

---

## 性能チューニングと容量増設 { #scn-perf-tuning }

**概要**: Buffer overload 起点で IGNORE SESSION 設計、Inspection Engine 分割、Logging Granularity 調整、Daily Purge 確実化を実施。capacity planning の起点として活用。

### シナリオの状況

Sniffer の Buffer Free が 10% 切る、または Daily Purge 失敗で `/var` が 80% 超える状況。緊急対応 + 根本対応の両面で構成変更が必要。

### 推奨フロー

#### Phase 1: 緊急回復
1. **Sniffer overload の即時対応** → [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload)
2. **Disk full の緊急 Purge** → [inc-disk-full](09-incident-procedures.md#inc-disk-full)

#### Phase 2: 信頼アプリ除外
3. **Session-level Policy で IGNORE SESSION 設計** → [uc-policy-session-tune](12-use-cases.md#uc-policy-session-tune)

#### Phase 3: Engine 分割
4. **DB ごとの Inspection Engine に分割し、流量分散** → [uc-inspection-engine](12-use-cases.md#uc-inspection-engine)
5. **Ignored Ports List で監視対象外ポート除外** → [uc-inspection-engine](12-use-cases.md#uc-inspection-engine)

#### Phase 4: ロギング粒度調整
6. **Log Records Affected / Inspect Returned Data の必要性再検討** → [uc-policy-extrusion](12-use-cases.md#uc-policy-extrusion)
7. **Logging Granularity を 5 分 / 15 分に粗化** → [uc-inspection-engine](12-use-cases.md#uc-inspection-engine)

#### Phase 5: Archive / Purge 確実化
8. **Daily Archive → Daily Import → Daily Purge の Schedule 順序見直し** → [uc-archive-purge](12-use-cases.md#uc-archive-purge)
9. **Long-term retention で内部 DB を軽く保つ** → [uc-cold-storage](12-use-cases.md#uc-cold-storage)

#### Phase 6: capacity planning
10. **Buffer Free / Sessions / `/var` 使用率の定期監視を Predefined Reports で可視化** → [uc-buffer-monitor](12-use-cases.md#uc-buffer-monitor)

### 本記事の範囲

**本記事の範囲**：標準的な overload / disk full への対応 + 構成見直し。**業務 SLA に応じたサイジング** は環境依存のため [10. 対象外項目](10-out-of-scope.md) B カテゴリで除外。

---

## クラウド DB 監視（External S-TAP / Edge Gateway / Universal Connector） { #scn-cloud-monitoring }

**概要**: AWS RDS / Azure SQL DB / GCP Cloud SQL / Snowflake / SAP HANA / Teradata 等、エージェント設置不可な DB 群を Guardium の監視対象に組み込む。

### シナリオの状況

オンプレ DB は S-TAP で監視できているが、クラウドへ移行が進み、エージェント設置不可なマネージド DB が増えている状況。External S-TAP（プロキシ型）または Edge Gateway 2.x（K8s）または Universal Connector（ログベース）で対応。

### 推奨フロー

#### Phase 1: 監視対象の方式選定
1. **エージェント可（Linux/Windows VM 上の自前 DB）** → 通常 S-TAP（[scn-new-deployment](#scn-new-deployment) と同じ）
2. **エージェント不可（マネージド RDB / Snowflake / SAP HANA / Teradata）** → External S-TAP / UC 検討
3. **コンテナ DB（K8s 上の MongoDB / PostgreSQL）** → Edge Gateway 2.x（K8s）

#### Phase 2: External S-TAP / Edge Gateway 配備
4. **External S-TAP / Edge Gateway を AWS EKS / OpenShift / K3s に Helm で展開** → [uc-cloud-monitoring](12-use-cases.md#uc-cloud-monitoring)

#### Phase 3: Universal Connector 構成
5. **UC のプリインストールプラグイン（Snowflake / SAP HANA / Teradata 等）を有効化** → [uc-cloud-monitoring](12-use-cases.md#uc-cloud-monitoring)
6. **CloudWatch / JDBC / Kafka source で監査ログ取り込み** → [uc-cloud-monitoring](12-use-cases.md#uc-cloud-monitoring)

#### Phase 4: Inspection Engine / Policy 構成
7. **Collector 側で Engine を作成（Protocol を UC 用に設定）** → [uc-inspection-engine](12-use-cases.md#uc-inspection-engine)
8. **Policy で マネージド DB 用ルール設計** → [uc-policy-build](12-use-cases.md#uc-policy-build)

#### Phase 5: VA / Smart assistant 連動
9. **マネージド DB 向け VA テンプレート（MongoDB Atlas 8.0 / EDB PG 17.5 / Oracle MySQL 8.4 等、12.2.2 拡張）** → [uc-va-run](12-use-cases.md#uc-va-run)

### 本記事の範囲

**本記事の範囲**：External S-TAP / Edge Gateway / UC の配備と Guardium 内構成。**EKS / OpenShift / K3s 自体の運用 / IAM / VPC 設計** は範囲外（[10. 対象外項目](10-out-of-scope.md) C カテゴリ）。

---

## 災害復旧（DR）演習・準備 { #scn-disaster-recovery }

**概要**: Backup and restore（S33）+ Daily Archive + Long-term retention の組合せで DR を設計し、年次演習を実施できる体制を整える。

### シナリオの状況

監査要件 / SLA で「Guardium が 24h 内に別サイトで稼働再開できること」「監査データが N 日まで遡って復元できること」を要求されている。

### 推奨フロー

#### Phase 1: バックアップ戦略
1. **`backup system` で appliance 全体のバックアップ取得** → [uc-archive-purge](12-use-cases.md#uc-archive-purge)
2. **Daily Archive で監査データを外部ストレージへ** → [uc-archive-purge](12-use-cases.md#uc-archive-purge)
3. **Long-term retention（S3 互換）で長期保持** → [uc-cold-storage](12-use-cases.md#uc-cold-storage)

#### Phase 2: 別サイト準備
4. **DR サイトに Cold Standby の appliance を準備（OFF 状態でライセンスアサイン）**
5. **DR サイト appliance に最新の `backup system` 出力を restore する手順を整備** → [uc-archive-purge](12-use-cases.md#uc-archive-purge)

#### Phase 3: 演習計画
6. **年次の DR 演習計画（停電 / 災害想定）を作成、人的役割と切替手順を文書化（業務 BCP 領域）**
7. **Aggregator archive の復元戦略**：Aggregator archive は Collector に **復元不可**（一方向）。Collector のリストアは Backup 経由が原則。

#### Phase 4: 監視
8. **Daily Archive / Long-term retention の最終成功時刻を Audit Process タスクで月次レビュー** → [uc-audit-process](12-use-cases.md#uc-audit-process)

### 本記事の範囲

**本記事の範囲**：標準的な Backup and restore + Daily Archive + Long-term retention の組合せ。**RTO / RPO の業務目標定義 / 年次演習スケジュール / 多サイト Active-Active 設計** は業務 BCP 領域 / 案件依存で範囲外（[10. 対象外項目](10-out-of-scope.md) G カテゴリ）。

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
