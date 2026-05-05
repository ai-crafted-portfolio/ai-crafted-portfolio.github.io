# プレイブック

> 「どんな状況で / どの作業を / どの習熟度で実施するか」を **シーン × 習熟度** マトリクスで早見化。各セルから [13. ユースケース集](12-use-cases.md) / [09. 設定手順](08-config-procedures.md) / [10. 障害対応手順](09-incident-procedures.md) へリンク。

7 シーン × 3 習熟度（**初級** = 単純実行、**中級** = パラメータ調整、**上級** = 設計判断）= **21 セル**。

| シーン \ 習熟度 | **初級** | **中級** | **上級** |
|---|---|---|---|
| **(1) 新規 LFA 導入** | [uc-agent-install](12-use-cases.md#uc-agent-install)（1 ホストに `lo` 配備） | [uc-tems-connect](12-use-cases.md#uc-tems-connect)（itmcmd config -A lo）+ [uc-itmcmd-config](12-use-cases.md#uc-itmcmd-config) | [scn-new-deployment](11-scenarios.md#scn-new-deployment) — 全体俯瞰 |
| **(2) 監視対象設計** | [uc-syslog-monitor](12-use-cases.md#uc-syslog-monitor)（/var/log/messages） | [uc-app-log-monitor](12-use-cases.md#uc-app-log-monitor)（複数アプリログ）+ [uc-rotating-log](12-use-cases.md#uc-rotating-log) | [uc-pipe-source](12-use-cases.md#uc-pipe-source) — UnixCommand / Pipe ソース |
| **(3) `.fmt` / `.conf` 設計** | [uc-fmt-write](12-use-cases.md#uc-fmt-write)（雛形利用） | [uc-multiline](12-use-cases.md#uc-multiline)（NewLinePattern）+ [uc-attribute-map](12-use-cases.md#uc-attribute-map) | [uc-summary-event](12-use-cases.md#uc-summary-event)（EventFloodThreshold + EventSummaryInterval） |
| **(4) サブノード / 複数監視** | [uc-subnode-create](12-use-cases.md#uc-subnode-create) | [uc-subnode-distribute](12-use-cases.md#uc-subnode-distribute)（Managed System List）+ [uc-multi-os](12-use-cases.md#uc-multi-os) | [scn-multi-subnode](11-scenarios.md#scn-multi-subnode) — N subnode 設計 |
| **(5) Netcool / EIF 連携** | [uc-eif-target](12-use-cases.md#uc-eif-target)（EIFServer / EIFPort） | [uc-eif-fanout](12-use-cases.md#uc-eif-fanout)（複数 EIF receiver） | [scn-eif-to-netcool](11-scenarios.md#scn-eif-to-netcool) — 全体パイプライン |
| **(6) TEP 監視統合** | [uc-tep-situation](12-use-cases.md#uc-tep-situation)（雛形 situation 作成） | [uc-tep-workspace](12-use-cases.md#uc-tep-workspace) + [uc-historical-data](12-use-cases.md#uc-historical-data) | [scn-tep-monitoring](11-scenarios.md#scn-tep-monitoring) — Hub TEMS 統合 |
| **(7) 障害対応** | [inc-agent-down](09-incident-procedures.md#inc-agent-down) | [inc-tems-conn-fail](09-incident-procedures.md#inc-tems-conn-fail) + [inc-events-not-captured](09-incident-procedures.md#inc-events-not-captured) | [inc-event-flood](09-incident-procedures.md#inc-event-flood) + [inc-eif-not-delivered](09-incident-procedures.md#inc-eif-not-delivered) — A/B/C 仮説分岐で診断 |

## 使い方

1. 「いま自分が何をしようとしているか」のシーンを縦軸で選ぶ
2. 自分の習熟度（あるいはチームメンバへの指示の粒度）を横軸で選ぶ
3. セル内のリンクから具体的な手順 / ユースケース / 障害対応へジャンプ

「このセルが空欄」 = LFA 6.3 の標準的な公式手順では推奨フローが薄い領域（要設計判断 / 個別案件依存）。

---

## 補足：3 大日常タスク

LFA 運用者が **毎週・毎日** 必ず触る 3 つの領域：

1. **エージェント健全性チェック** — TEP の Log File Agent ナビゲーションで全 subnode が緑であること、`itmcmd agent status lo` が `running` であること、`$CANDLEHOME/logs/<host>_lo_*.log` の最新 200 行に `ERROR` / `FATAL` が出ていないこと。
2. **イベント流量レビュー** — TEP の `LogfileEvents` 履歴ワークスペース、または Netcool 側 `alerts.status` で LFA 経由イベントの件数推移。`EventFloodThreshold` 動作の有無確認。
3. **`.fmt` / `.conf` 改修サイクル** — 監視対象アプリのログフォーマット変更追従。改修時は **テストホスト 1 台で実機確認 → 全台展開** が定石。

これらは「シーン」マトリクスに含まないが、すべてのシーンの前提として常時稼働している必要がある。

---

## 視点別の最初の一歩

**新規導入（PoC / 検証）**：「とりあえず 1 台で動くものを見たい」 → [scn-new-deployment](11-scenarios.md#scn-new-deployment) の Phase 1-3 だけまず通す。

**既存 ITM 環境への追加**：「Hub TEMS / TEPS は稼働中、LFA だけ追加」 → [uc-agent-install](12-use-cases.md#uc-agent-install) → [uc-tems-connect](12-use-cases.md#uc-tems-connect) → [uc-conf-write](12-use-cases.md#uc-conf-write) の順。

**Netcool 連携前提**：「TEP は使わず Netcool で見る」 → [scn-eif-to-netcool](11-scenarios.md#scn-eif-to-netcool) の Phase 1 から。Netcool 側受信器の設定は本サイトの [Netcool/OMNIbus 8.1 / 09. cfg-probe-config](../netcool-omnibus-8-1/08-config-procedures.md) 周辺を併読。

**性能トラブル対応**：「`MaxEventQueueDepth` 警告 / EIF キャッシュ肥大」 → [inc-event-flood](09-incident-procedures.md#inc-event-flood) → [cfg-flood-threshold](08-config-procedures.md#cfg-flood-threshold) の順。

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
