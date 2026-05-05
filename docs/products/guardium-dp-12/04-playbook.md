# プレイブック

> 「どんな状況で / どの作業を / どの習熟度で実施するか」を **シーン × 習熟度** マトリクスで早見化。各セルから [13. ユースケース集](12-use-cases.md) / [09. 設定手順](08-config-procedures.md) / [10. 障害対応手順](09-incident-procedures.md) へリンク。

7 シーン × 3 習熟度（**初級** = 単純実行、**中級** = パラメータ調整、**上級** = 設計判断）= **21 セル**。

| シーン \ 習熟度 | **初級** | **中級** | **上級** |
|---|---|---|---|
| **(1) 新規 Guardium 構築** | [uc-appliance-deploy](12-use-cases.md#uc-appliance-deploy)（Collector 1 台） | [uc-cm-managed-unit](12-use-cases.md#uc-cm-managed-unit)（CM 配下化）+ [uc-stap-install](12-use-cases.md#uc-stap-install) | [scn-new-deployment](11-scenarios.md#scn-new-deployment) — 全体俯瞰 |
| **(2) S-TAP 配備 / DB 監視追加** | [uc-stap-install](12-use-cases.md#uc-stap-install) | [uc-stap-failover-pair](12-use-cases.md#uc-stap-failover-pair)（failover_sqlguardip）+ [uc-inspection-engine](12-use-cases.md#uc-inspection-engine) | [scn-smac-build](11-scenarios.md#scn-smac-build) — Aggregator 集約設計 |
| **(3) Compliance 自動化** | [uc-smart-assistant](12-use-cases.md#uc-smart-assistant)（テンプレート生成） | [uc-audit-process](12-use-cases.md#uc-audit-process)（Receivers / Schedule）+ [uc-policy-build](12-use-cases.md#uc-policy-build) | [scn-compliance-automation](11-scenarios.md#scn-compliance-automation) — 規制横断展開 |
| **(4) Policy / Rule 設計** | [uc-policy-build](12-use-cases.md#uc-policy-build)（雛形修正） | [uc-policy-blocking](12-use-cases.md#uc-policy-blocking)（S-GATE TERMINATE）+ [uc-policy-extrusion](12-use-cases.md#uc-policy-extrusion) | [uc-policy-session-tune](12-use-cases.md#uc-policy-session-tune) — IGNORE SESSION 設計 |
| **(5) 性能 / 容量** | [uc-buffer-monitor](12-use-cases.md#uc-buffer-monitor)（Buffer Free 確認） | [uc-policy-session-tune](12-use-cases.md#uc-policy-session-tune)（IGNORE SESSION）+ [uc-archive-purge](12-use-cases.md#uc-archive-purge) | [scn-perf-tuning](11-scenarios.md#scn-perf-tuning) — capacity planning |
| **(6) セキュリティ / 監査** | [uc-rbac-design](12-use-cases.md#uc-rbac-design)（最小権限ロール） | [uc-cert-rotation](12-use-cases.md#uc-cert-rotation)（証明書）+ [uc-fips-mode](12-use-cases.md#uc-fips-mode) | LDAP / SAML 統合（個別案件、本ドキュメント範囲外） |
| **(7) 障害対応** | [inc-stap-down](09-incident-procedures.md#inc-stap-down) | [inc-stap-conn-fail](09-incident-procedures.md#inc-stap-conn-fail) + [inc-policy-not-active](09-incident-procedures.md#inc-policy-not-active) | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) + [inc-disk-full](09-incident-procedures.md#inc-disk-full) — A/B/C 仮説分岐で診断 |

## 使い方

1. 「いま自分が何をしようとしているか」のシーンを縦軸で選ぶ
2. 自分の習熟度（あるいはチームメンバへの指示の粒度）を横軸で選ぶ
3. セル内のリンクから具体的な手順 / ユースケース / 障害対応へジャンプ

「このセルが空欄」 = GDP の標準的な公式手順では推奨フローが薄い領域（要設計判断 / 個別案件依存）。

---

## 補足：3 大日常タスク

GDP 運用者が **毎週・毎日** 必ず触る 3 つの領域：

1. **監査結果のレビュー** — Audit Process の Receivers / Sign-off。Comply > Tools and Views > Audit Process Reviewer から。
2. **アラートの確認** — Reports > Threshold Alerter Status、ATA case の severity 別件数 (`grdapi list_ata_case_severity`)。
3. **アプライアンス健全性チェック** — Executive Dashboard、Buffer Free %、`/var` 使用率、`show certificate exceptions`。

これらは「シーン」マトリクスに含まないが、すべてのシーンの前提として常時稼働している必要がある。

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
