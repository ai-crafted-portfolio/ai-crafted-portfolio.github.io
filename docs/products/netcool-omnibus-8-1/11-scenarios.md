# シナリオ別ガイド

> 業務全体のイメージから入りたい読者向け。各シナリオは典型的な業務状況と、関連するユースケース・手順への組み合わせ案内。

**他章との関係**:

- **本章（11. シナリオ別ガイド）**: meta レベル、業務全体の俯瞰
- **[13. ユースケース集](12-use-cases.md)**: 各ユースケースは独立完結、拾い読み可能
- 1 シナリオから複数ユースケースへリンク（1:N）

**収録シナリオ**: 6 本

| ID | タイトル | 概要 |
|---|---|---|
| [scn-new-deployment](#scn-new-deployment) | 新規 OMNIbus 環境の構築 | 単体構成 → SMAC 化までの導入の全体俯瞰 |
| [scn-smac-build](#scn-smac-build) | SMAC（標準多段構成）化 | Collection / Aggregation / Display 3 層構築の流れ |
| [scn-failover-build](#scn-failover-build) | failover / controlled failback の整備 | Aggregation 層二重化 + AGG_GATE + Probe 側自動 failback の取扱い |
| [scn-perf-tuning](#scn-perf-tuning) | 性能チューニングと容量増設 | profiling 起点の高コスト trigger 改善、Probe / Gateway スケーリング、capacity planning |
| [scn-eif-integration](#scn-eif-integration) | ITM / EIF 連携と Predictive Event 取込 | Tivoli EIF Probe 配置 + tivoli_eif.rules チューニング |
| [scn-disaster-recovery](#scn-disaster-recovery) | 災害復旧（DR）演習・準備 | Best Practices Guide v1.3 Chapter 11 ベースの backup / restore / DR 切替手順 |

!!! info "本章の品質方針"
    全シナリオは IBM Netcool/OMNIbus 8.1 公式マニュアル + Best Practices Guide v1.3 記載の事実・手順のみで構成。AI が苦手な定性的判断（ベストプラクティス、経験則、サイジング目安）は範囲外（[10. 対象外項目](10-out-of-scope.md) 参照）。

---

## 新規 OMNIbus 環境の構築 { #scn-new-deployment }

**概要**: 1 ホスト / 単体 ObjectServer から始めて、Probe を 1 つ繋いで動作確認するまでの最短経路。本番運用前提の SMAC 化は次のシナリオへ。

### シナリオの状況

新しい監視チームが立ち上がった、または検証 / PoC 用に OMNIbus を初めて立ち上げる状況。Probe（例：Syslog）を 1 つ繋いでイベントが alerts.status に流れることを確認するのがゴール。

### 推奨フロー（参照ユースケース）

#### Phase 1: ホスト準備
1. **OMNIbus 本体 IM インストール** → [uc-im-install](12-use-cases.md#uc-im-install)
2. **netcool ユーザ作成** → [uc-netcool-user-create](12-use-cases.md#uc-netcool-user-create)

#### Phase 2: ObjectServer 起動準備
3. **omni.dat 編集** → [uc-omni-dat-edit](12-use-cases.md#uc-omni-dat-edit)
4. **ObjectServer 作成** → [uc-objserv-create](12-use-cases.md#uc-objserv-create)
5. **interfaces 生成** → [uc-omni-dat-edit](12-use-cases.md#uc-omni-dat-edit)（同じユースケースの末尾）
6. **Process Agent 配置** → [uc-pa-deploy](12-use-cases.md#uc-pa-deploy)

#### Phase 3: 起動と確認
7. **ObjectServer 起動** → [uc-objserv-create](12-use-cases.md#uc-objserv-create) Phase 末尾
8. **状態確認（DISPLAY 系）** → [uc-display-status](12-use-cases.md#uc-display-status)

#### Phase 4: 標準 trigger 確認
9. **trigger group の状態確認** → [uc-trigger-tune](12-use-cases.md#uc-trigger-tune)

#### Phase 5: Probe 配置
10. **Syslog Probe 配置** → [uc-probe-syslog](12-use-cases.md#uc-probe-syslog)
11. **rules 編集** → [uc-rules-edit](12-use-cases.md#uc-rules-edit)
12. **テストイベント注入** → `nco_postmsg` または `logger` で確認

#### Phase 6: Web GUI 接続
13. **Web GUI のデータソース登録** → [uc-webgui-datasource](12-use-cases.md#uc-webgui-datasource)

### 本記事の範囲

**本記事の範囲**：単体構成での新規構築、Probe 1 つでイベント疎通確認まで。本番展開での **二重化（[scn-failover-build](#scn-failover-build)）** や **多段化（[scn-smac-build](#scn-smac-build)）** は別シナリオ。SSL/TLS（FIPS）は [uc-ssl-objserv](12-use-cases.md#uc-ssl-objserv) を別途参照。

AI が苦手な定性的判断（業務 SLA に応じた構成サイジング、Severity マッピング設計）は範囲外。経験ある SME か IBM サポートに確認推奨。

---

## SMAC（標準多段構成）化 { #scn-smac-build }

**概要**: 単体構成から Collection / Aggregation / Display の 3 層 + uni-directional Gateway 群へ拡張する。Best Practices Guide v1.3 Chapter 7 の「Anatomy of the standard multitier architecture configuration」が中核根拠。

### シナリオの状況

PoC が終わって本番展開する、または既存の単体構成で性能・可用性が足りなくなってきた状況。Probe を Collection に集約してイベント流入を分離し、Aggregation で deduplication / 高可用化、Display で UI 負荷を逃がす設計を導入する。

### 推奨フロー（参照ユースケース）

#### Phase 1: Collection 層
1. **COL_P_1 / COL_B_1 ObjectServer 作成** → [uc-objserv-create](12-use-cases.md#uc-objserv-create)
2. **collection.sql 投入（col_expire 等）** → [uc-confpack-import](12-use-cases.md#uc-confpack-import)
3. **C→A uni Gateway 配置** → [uc-smac-collection](12-use-cases.md#uc-smac-collection)

#### Phase 2: Aggregation 層
4. **AGG_P / AGG_B ObjectServer 作成** → [uc-objserv-create](12-use-cases.md#uc-objserv-create)
5. **aggregation.sql 投入** → [uc-smac-aggregation](12-use-cases.md#uc-smac-aggregation)
6. **AGG_GATE bidirectional Gateway 配置** → [uc-failover-pair](12-use-cases.md#uc-failover-pair)

#### Phase 3: Display 層
7. **DSP_P / DSP_B ObjectServer 作成** → [uc-objserv-create](12-use-cases.md#uc-objserv-create)
8. **display.sql 投入** → [uc-confpack-import](12-use-cases.md#uc-confpack-import)
9. **A→D uni Gateway 配置** → [uc-smac-display](12-use-cases.md#uc-smac-display)

#### Phase 4: AEN 有効化
10. **accelerated_inserts trigger group enabled + nco_aen 配置** → [uc-aen-enable](12-use-cases.md#uc-aen-enable)

#### Phase 5: クライアント切替
11. **Probe Server プロパティを virtual 名（COL_V_1 等）へ** → [uc-virtual-server-name](12-use-cases.md#uc-virtual-server-name)
12. **Web GUI データソースを DSP_V へ** → [uc-webgui-datasource](12-use-cases.md#uc-webgui-datasource)

### 本記事の範囲

**本記事の範囲**：標準的な SMAC 構成（3 層 + uni Gateway 群 + AGG_GATE）の構築。Best Practices Guide v1.3 の同梱 SQL（collection.sql / aggregation.sql / display.sql）を出発点として使用。WAN を跨ぐマルチサイト構成、DMZ Proxy 配置（[uc-proxy-deploy](12-use-cases.md#uc-proxy-deploy)）は別途参照。

サイト規模に応じた COL / AGG / DSP の物理サーバ台数決定は定性的判断、Best Practices Guide v1.3 Chapter 2（Planning）の provisioning guidelines（Probe あたり 100 events/sec、ObjectServer の小・中・大の目安 10K / 50K / 50K+ 行）を参考に経験 SME と相談。

---

## failover / controlled failback の整備 { #scn-failover-build }

**概要**: Aggregation 層二重化（AGG_P + AGG_B）と AGG_GATE bidirectional Gateway の構成、controlled failback の動作確認、Probe / Gateway 側の自動 failback を意図的に disable する Best Practices v1.3 推奨フローの整備。

### シナリオの状況

SMAC 化済の環境で、SLA 上の高可用性を担保したい / 障害時の切替を演習したい状況。

### 推奨フロー（参照ユースケース）

#### Phase 1: AGG_GATE 配置と検証
1. **AGG_GATE プロパティ準備（Resync.LockType=PARTIAL）** → [uc-failover-pair](12-use-cases.md#uc-failover-pair)
2. **mapping table 定義** → [uc-failover-pair](12-use-cases.md#uc-failover-pair)
3. **virtual 名（AGG_V）の omni.dat 登録** → [uc-virtual-server-name](12-use-cases.md#uc-virtual-server-name)

#### Phase 2: Probe / Gateway 側設定
4. **Probe Server プロパティを virtual 名へ** → [uc-virtual-server-name](12-use-cases.md#uc-virtual-server-name)
5. **Probe / Gateway の自動 failback を disable**（controlled failback 推奨フロー）

#### Phase 3: failover / failback 演習
6. **AGG_P 計画停止 → Probe / Gateway / Web GUI が AGG_B へ切替** → [uc-display-status](12-use-cases.md#uc-display-status) で `count(*)` 移動確認
7. **AGG_P 再起動 → AGG_GATE resync 完了確認 → クライアント順次 failback**
8. **resync_complete signal の確認**（synthetic event 生成）

### 本記事の範囲

**本記事の範囲**：標準的な Aggregation 二重化と AGG_GATE bidirectional の動作確認まで。Multi-site DR、Active-Active マルチサイト、コンテナ移行は範囲外（[10. 対象外項目](10-out-of-scope.md)）。

業務影響を伴う本番 failover 演習の計画は [10. 対象外項目](10-out-of-scope.md) D「運用ナレッジ・サイト固有」に該当、別途 BCP / DR 計画として整備。

---

## 性能チューニングと容量増設 { #scn-perf-tuning }

**概要**: 応答遅延 / 肥大化が見えてきた環境での切り分け（profiling）と改善（trigger / Probe 配置 / Gateway バッファ）。

### シナリオの状況

数か月運用してきて Web GUI が重い、SQL レイテンシが伸びている、alerts.status が想定の桁外れに肥大している状況。

### 推奨フロー（参照ユースケース）

#### Phase 1: 現状把握
1. **行数 / Severity 分布の取得** → [uc-display-status](12-use-cases.md#uc-display-status)
2. **trigger 状態確認** → [uc-trigger-tune](12-use-cases.md#uc-trigger-tune)
3. **profiling 起動 → 1 時間 → 停止** → [uc-trigger-tune](12-use-cases.md#uc-trigger-tune) Phase 末尾

#### Phase 2: 改善
4. **alerts.status 肥大の根本対処** → [inc-alerts-status-bloat](09-incident-procedures.md#inc-alerts-status-bloat)（housekeeping enable / Identifier 設計 / DisableDetails）
5. **高コスト trigger を IF-ELSEIF 形式に統合** → Best Practices v1.3 Chapter 4 推奨パターン
6. **Impact ポリシーが過剰問い合わせていないか確認** → Impact 側 service log

#### Phase 3: 容量増設（必要なら）
7. **Probe 増設**（capacity planning：100 events/sec / single-thread Probe、200 events/sec / multi-thread Probe）
8. **Collection ObjectServer 増設**（地理 / NW セグメント別に）
9. **DSP 層を追加**（Web GUI クライアント分離）

### 本記事の範囲

**本記事の範囲**：profiling 起点の trigger 改善、Probe スケールアウト、Gateway BufferSize 調整。Aggregation の物理サーバアップグレード判断、ストレージ I/O ボトルネック対処は別領域（OS / ストレージ ベンダ ドキュメント参照）。

業務的に Severity マッピング / ExpireTime 値を再設計する判断は定性的領域、業務 SLA・SME 判断による（[10. 対象外項目](10-out-of-scope.md)）。

---

## ITM / EIF 連携と Predictive Event 取込 { #scn-eif-integration }

**概要**: IBM Tivoli Monitoring（TEMS）からの EIF イベント、特に Predictive Event を OMNIbus に取り込み、AEL で可視化する一連の流れ。

### シナリオの状況

ITM が既に動いていて状況通知を OMNIbus に統合したい、または ITM の予兆イベント（Predictive）を運用センターに集約したい状況。

### 推奨フロー（参照ユースケース）

#### Phase 1: EIF Probe 配置
1. **nco_p_tivoli_eif の配置** → [uc-probe-eif](12-use-cases.md#uc-probe-eif)
2. **tivoli_eif.props 設定（Server / RulesFile / NetworkPort）** → [uc-probe-eif](12-use-cases.md#uc-probe-eif)
3. **tivoli_eif.rules で predictive_event.rules の include コメントアウト解除** → [uc-rules-edit](12-use-cases.md#uc-rules-edit)

#### Phase 2: ITM 側設定
4. **ITM Situation の EIF 送信先を OMNIbus Probe に設定**
5. **Predictive Situation 生成有効化**（ITM 管理 GUI で）
6. **GSKit で SSL 接続する場合の env 設定**：`LIBPATH` / `LD_LIBRARY_PATH` に GSKit パス

#### Phase 3: ObjectServer スキーマ拡張（必要なら）
7. **Predictive Event 用列追加**（alerts.status 拡張）
8. **predictive_event.rules で alerts.status マッピング**

#### Phase 4: Web GUI 設定
9. **predictive_event.elf フィルタ + predictive_event.elv ビューを Web GUI に Load** → [uc-webgui-load-views](12-use-cases.md#uc-webgui-load-views)

### 本記事の範囲

**本記事の範囲**：EIF Probe の配置と Predictive Event 取込までの一連の設定。ITM 側の Situation 設計、Predictive Situation の業務閾値設計は ITM 領域（[10. 対象外項目](10-out-of-scope.md)）。

---

## 災害復旧（DR）演習・準備 { #scn-disaster-recovery }

**概要**: Best Practices Guide v1.3 Chapter 11（Backups and disaster recovery）の手順をベースに、backup の取得・restore・DR 切替を演習する。

### シナリオの状況

主拠点と DR 拠点があり、両方で OMNIbus が動いている。または DR 拠点での restore リハーサルを実施する。

### 推奨フロー（参照ユースケース）

#### Phase 1: backup 取得
1. **ObjectServer バックアップ**：`nco_sql -output` で全 trigger / procedure / table を export
2. **omni.dat / interfaces / props ファイルの構成 backup** → [uc-config-backup](12-use-cases.md#uc-config-backup)
3. **Probe / Gateway / Web GUI の WAAPI / 設定 export** → [uc-config-backup](12-use-cases.md#uc-config-backup)

#### Phase 2: DR 拠点での restore
4. **DR 拠点で OMNIbus IM インストール**
5. **構成 restore（omni.dat / props / kdb 等）**
6. **`nco_sql -input` で trigger / procedure import**

#### Phase 3: 切替
7. **Probe Server プロパティを DR 拠点 ObjectServer 名へ** または DNS 切替
8. **Web GUI データソースを DR 拠点へ**
9. **DR 拠点で alerts.status にイベント流入を確認**

### 本記事の範囲

**本記事の範囲**：標準的な backup / restore / DR 切替の手順。RTO / RPO の業務目標決定、マルチサイト Active-Active、地理冗長設計は範囲外（業務 BCP 領域、[10. 対象外項目](10-out-of-scope.md)）。

DR 切替後の事業継続的判断（戻すタイミング、業務影響評価）は SME / 経営判断領域。

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
