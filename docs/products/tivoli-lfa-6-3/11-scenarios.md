# シナリオ別ガイド

> 業務全体のイメージから入りたい読者向け。各シナリオは典型的な業務状況と、関連するユースケース・手順への組み合わせ案内。

**他章との関係**:

- **本章（11. シナリオ別ガイド）**: meta レベル、業務全体の俯瞰
- **[13. ユースケース集](12-use-cases.md)**: 各ユースケースは独立完結、拾い読み可能
- 1 シナリオから複数ユースケースへリンク（1:N）

**収録シナリオ**: 6 本

| ID | タイトル | 概要 |
|---|---|---|
| [scn-new-deployment](#scn-new-deployment) | 新規 LFA 導入 | 1 ホスト + 1 監視対象から始めて TEP に届くまでの最短経路 |
| [scn-multi-subnode](#scn-multi-subnode) | 1 ホスト多 subnode 設計 | syslog / アプリログ / DB ログ等を独立 subnode で並行監視 |
| [scn-eif-to-netcool](#scn-eif-to-netcool) | LFA → Netcool/OMNIbus EIF パイプライン | TEP を経由せず Netcool で集約する構成 |
| [scn-tep-monitoring](#scn-tep-monitoring) | Hub TEMS / TEP 統合監視 | Situation + Workspace + History を含む TEP フル活用 |
| [scn-cluster-monitoring](#scn-cluster-monitoring) | クラスタ環境（HACMP / MSCS）への配置 | フェイルオーバ時のイベント欠損を抑える設計 |
| [scn-troubleshoot-flow](#scn-troubleshoot-flow) | 障害切り分けフロー | RAS1 → pdcollect → IBM サポート連携の標準フロー |

!!! info "本章の品質方針"
    全シナリオは LFA 6.3 公式マニュアル（S1, S3, S5）と ITM 6.3 関連ドキュメント記載の事実・手順のみで構成。AI が苦手な定性的判断（ベストプラクティス、経験則、サイジング目安）は範囲外（[10. 対象外項目](10-out-of-scope.md) 参照）。

---

## 新規 LFA 導入 { #scn-new-deployment }

**概要**: 1 ホスト / 1 監視対象（例：Linux の syslog）から始めて、TEP の `LogfileEvents` ワークスペースで行が見えることを確認するまでの最短経路。Netcool 連携 / 多 subnode は次のシナリオへ。

### シナリオの状況

新しい監視チームが立ち上がった、または検証 / PoC 用に LFA を初めて立ち上げる状況。Linux サーバ 1 台で `/var/log/messages` を監視し、最初のイベントが TEP に届くのがゴール。Hub TEMS / TEPS は既に稼働している前提。

### 推奨フロー（参照ユースケース）

#### Phase 1: agent インストール
1. **LFA agent の新規インストール** → [uc-agent-install](12-use-cases.md#uc-agent-install)

#### Phase 2: TEMS 接続
2. **`itmcmd config -A lo` で TEMS に接続** → [uc-tems-connect](12-use-cases.md#uc-tems-connect)

#### Phase 3: 設定ファイル作成
3. **`.conf` を syslog 用に作成** → [uc-conf-write](12-use-cases.md#uc-conf-write)
4. **`.fmt` を syslog 用に作成** → [uc-fmt-write](12-use-cases.md#uc-fmt-write)

#### Phase 4: agent 起動 + 疎通
5. **agent 起動と TEP での確認** → [uc-itmcmd-config](12-use-cases.md#uc-itmcmd-config)
6. **`/var/log/messages` に 1 行追記して `LogfileEvents` で見えることを確認**

#### Phase 5: 最初の Situation
7. **Severity 4 以上で発火する Situation を作成** → [uc-tep-situation](12-use-cases.md#uc-tep-situation)

### 本記事の範囲

**本記事の範囲**：1 ホスト + 1 監視対象 + 1 雛形 Situation で TEP 表示まで。Netcool 連携や多 subnode は別シナリオ。

AI が苦手な定性的判断（業務 SLA に応じた Severity マッピング、Situation 閾値）は範囲外。経験ある SME か IBM サポートに確認推奨。

---

## 1 ホスト多 subnode 設計 { #scn-multi-subnode }

**概要**: 1 ホスト上で複数のログ群を **subnode** として独立管理する構成。例：1 つの WebSphere サーバで `/var/log/messages`（syslog）+ `/opt/IBM/WebSphere/.../SystemOut.log`（WAS）+ `/home/db2inst1/sqllib/db2dump/db2diag.log`（Db2）を 3 subnode で並行監視。

### シナリオの状況

「1 ホストに複数の監視対象がある」「Situation を `業務単位` で別管理にしたい」「`MaxEventQueueDepth` をログ群ごとに分けたい」状況。subnode を使うと TEP 側で `host01:syslog-LO` / `host01:websphere-LO` / `host01:db2diag-LO` のように見え、Situation の MSL 振り分けも独立に行える。

### 推奨フロー（参照ユースケース）

#### Phase 1: subnode 別 `.conf` / `.fmt` を準備
1. **subnode 別の `.conf`（syslog.conf / websphere.conf / db2diag.conf）作成** → [uc-conf-write](12-use-cases.md#uc-conf-write)
2. **対応する `.fmt` 作成** → [uc-fmt-write](12-use-cases.md#uc-fmt-write)

#### Phase 2: subnode 登録
3. **`itmcmd config -S` で subnode 登録** → [uc-subnode-create](12-use-cases.md#uc-subnode-create)
4. **`kfaenv` で `CTIRA_SUBSYSTEM_ID` 等を subnode 別に設定** → [uc-subnode-create](12-use-cases.md#uc-subnode-create)

#### Phase 3: TEP / MSL 設計
5. **subnode を MSL に振り分け** → [uc-subnode-distribute](12-use-cases.md#uc-subnode-distribute)
6. **MSL 単位で Situation 配信** → [uc-tep-situation](12-use-cases.md#uc-tep-situation)

#### Phase 4: 動作検証
7. 各監視対象に 1 行追記して、対応 subnode の `LogfileEvents` だけに反映されること、他 subnode に漏れないことを確認

### 本記事の範囲

**本記事の範囲**：subnode 設計 + MSL 振り分け + Situation 配信。

**範囲外**：subnode 数の業務的妥当値、`MaxEventQueueDepth` の subnode 別最適値（[10. 対象外項目](10-out-of-scope.md)）。

---

## LFA → Netcool/OMNIbus EIF パイプライン { #scn-eif-to-netcool }

**概要**: TEP を主に使わず、LFA から **EIF** で Netcool/OMNIbus に直接イベントを集約する構成。Netcool で全社的なイベントトリアージを実施している既存環境への LFA 統合に最適。

### シナリオの状況

「Netcool/OMNIbus を中央コンソールとして既に運用」「ログイベントも Netcool で見たい」「TEP は使うが Situation 多用は避けたい」状況。LFA は `EIFServer` / `EIFPort` を `.conf` に書くだけで TEMS 経路と並行して Netcool に送れる。

### 推奨フロー（参照ユースケース）

#### Phase 1: Netcool 側の受信器準備
1. **Netcool 側で `nco_p_tivoli_eif` Probe を起動** → 本サイト [Netcool/OMNIbus 8.1 / 09. cfg-probe-config](../netcool-omnibus-8-1/08-config-procedures.md)
2. **`tivoli_eif.rules` で alerts.status マッピング設計** → 本サイト [Netcool/OMNIbus 8.1 / 03 用語集（Probe / Rules）](../netcool-omnibus-8-1/03-glossary.md)

#### Phase 2: LFA 側の EIF 設定
3. **LFA の `.conf` に `EIFServer` / `EIFPort` / `EIFCachePath` 追加** → [uc-eif-target](12-use-cases.md#uc-eif-target)
4. **`FQDomain=yes` で hostname を FQDN 化、Netcool dedup 設計と整合** → [uc-fqdomain](12-use-cases.md#uc-fqdomain)

#### Phase 3: 疎通テスト
5. **LFA ホストから `telnet <eif_host> 5529` 疎通**
6. **テストログを書き込み、Netcool 側 `nco_sql` で alerts.status 着信確認**

#### Phase 4: 多 EIF receiver 化（任意）
7. **2 系統の EIF receiver に並行送信** → [uc-eif-fanout](12-use-cases.md#uc-eif-fanout)（高可用構成）

#### Phase 5: 受信側ルール調整
8. Netcool 側 `tivoli_eif.rules` で AlertGroup / Severity / Identifier の整形 → 本サイト [Netcool/OMNIbus 8.1 / 09. cfg-rules-build](../netcool-omnibus-8-1/08-config-procedures.md)

### 本記事の範囲

**本記事の範囲**：LFA 側の EIF 送信設定と疎通確認。

**範囲外**：Netcool 側 alerts.status のカラム設計 / `tivoli_eif.rules` の業務ロジック詳細（[Netcool/OMNIbus 8.1](../netcool-omnibus-8-1/) 側で扱う）、SOC のチケット連携設計。

---

## Hub TEMS / TEP 統合監視 { #scn-tep-monitoring }

**概要**: TEP をフロントエンドとして Situation + Workspace + Historical Data を統合活用する構成。LFA 単体の運用では TEP が標準フロントエンド。

### シナリオの状況

「Netcool は使わず ITM 系で完結」「複数 LFA agent を 1 つの TEP で集中管理」「履歴グラフで傾向分析したい」状況。

### 推奨フロー

#### Phase 1: 複数 LFA の Hub TEMS 集約
1. **既存 LFA をすべて同じ Hub TEMS に向ける** → [uc-tems-connect](12-use-cases.md#uc-tems-connect)
2. **Managed System List で業務別グループ化** → [uc-subnode-distribute](12-use-cases.md#uc-subnode-distribute)

#### Phase 2: Situation 配備
3. **重要度別 Situation テンプレ作成（Severity 4 / 3 / 2）** → [uc-tep-situation](12-use-cases.md#uc-tep-situation)
4. **MSL に Situation 配信**

#### Phase 3: Workspace 整備
5. **業務単位の Workspace を作成（テーブル / Bar Chart / Trend）** → [uc-tep-workspace](12-use-cases.md#uc-tep-workspace)

#### Phase 4: Historical Data 収集
6. **`LogfileEvents` 属性グループの History Collection を有効化** → [uc-historical-data](12-use-cases.md#uc-historical-data)
7. **Tivoli Data Warehouse 連携（長期保持）**：[10. 対象外](10-out-of-scope.md)（個別案件）

#### Phase 5: Self-monitoring Situation
8. **`MS_Offline` / `LogfileMonitor` で agent 自己監視** → [uc-self-monitor](12-use-cases.md#uc-self-monitor)

### 本記事の範囲

**本記事の範囲**：TEP の standard 機能を使う範囲。

**範囲外**：TEP UI のカスタムテーマ、Tivoli Data Warehouse 設計、Netcool との二重監視運用設計（[10. 対象外項目](10-out-of-scope.md)）。

---

## クラスタ環境（HACMP / MSCS）への配置 { #scn-cluster-monitoring }

**概要**: クラスタ active-passive 環境で LFA を一意に動かしつつ、フェイルオーバ時の監視欠損を最小化。

### シナリオの状況

「DB クラスタ（HACMP / MSCS / Pacemaker / VCS）の active node 上のログだけ監視したい」「フェイルオーバ後も同じ subnode 名で TEP に出続けたい」状況。

### 推奨フロー

#### Phase 1: 配置方式選択
1. **共有 CANDLEHOME 方式 vs 個別 CANDLEHOME 方式の選定** → [cfg-cluster-failover](08-config-procedures.md#cfg-cluster-failover)
2. クラスタ resource group の hostname / VIP を確認

#### Phase 2: agent 配置
3. **共有 CANDLEHOME 方式の場合**：共有 FS に CANDLEHOME を置き、両ノードで installer 実行（`tacmd createNode` の `--noprompt` で省力化）
4. **個別 CANDLEHOME 方式の場合**：両ノードに独立配置 → [uc-cluster-deploy](12-use-cases.md#uc-cluster-deploy)

#### Phase 3: クラスタ resource 統合
5. **start/stop スクリプトに `itmcmd agent start lo` / `itmcmd agent stop lo` を組み込む**
6. **`CTIRA_HOSTNAME` を VIP / cluster name に固定**（subnode 名統一）

#### Phase 4: フェイルオーバテスト
7. 計画停止 → フェイルオーバ → 切替後 1-2 分以内に subnode 緑表示 → イベント取得再開を確認

### 本記事の範囲

**本記事の範囲**：LFA 側の起動 / 停止フックとホスト名設計。

**範囲外**：HACMP / MSCS / VCS / Pacemaker の cluster 設計、共有 FS の I/O 設計、resource group 依存関係（[10. 対象外項目](10-out-of-scope.md)）。

---

## 障害切り分けフロー（RAS1 → pdcollect → IBM サポート） { #scn-troubleshoot-flow }

**概要**: 既存稼働中の LFA に問題が出たときの定石フロー。SLA / 緊急度に応じて 3 段階で深掘り。

### シナリオの状況

「TEP / Netcool で異常が見えたが原因不明」「IBM サポートに上げる前に十分な情報を集めたい」「再現可能な手順で診断したい」状況。

### 推奨フロー

#### Phase 1: 初動（1 hour）
1. **症状確定**：[06. トラブル早見表](05-troubleshooting.md) で症状起点の早見
2. **基本情報収集**：
    - `tail -200 $CANDLEHOME/logs/<host>_lo_*.log`
    - `itmcmd agent status lo`
    - `tacmd listsystems -t lo`
    - `.conf` / `.fmt` の現物保管
3. **A/B/C 仮説設定**：[10. 障害対応手順](09-incident-procedures.md) の S 級項目を参照

#### Phase 2: 仮説検証（2-4 hours）
4. **`KBB_RAS1` を一段上げる**：`ERROR (UNIT:logfile_agent STATE)` 程度 → [cfg-trace-ras1](08-config-procedures.md#cfg-trace-ras1)
5. **agent restart して再現**
6. **agent log を再収集** → 仮説が見えてきたら [10. 障害対応手順](09-incident-procedures.md) の対応で解消試行

#### Phase 3: 解消できない / IBM サポート連携（半日-）
7. **`KBB_RAS1=ERROR (UNIT:logfile_agent ALL)` に昇格** → 短時間だけ
8. **`pdcollect` で診断アーカイブ取得** → [pdcollect](01-commands.md#pdcollect)
9. **IBM サポートにチケット起票**：症状サマリ + agent log + `pdcollect` アーカイブ
10. **`KBB_RAS1` を既定に戻す** → [inc-disk-fill-trace](09-incident-procedures.md#inc-disk-fill-trace) 防止

### 本記事の範囲

**本記事の範囲**：LFA 単体の標準切り分けフロー。

**範囲外**：IBM サポート契約の手続き、SLA 別エスカレーション、障害分析レポート様式（業務固有）。

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
