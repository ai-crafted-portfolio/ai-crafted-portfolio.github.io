# プレイブック

> 「どんな状況で / どの作業を / どの習熟度で実施するか」を **シーン × 習熟度** マトリクスで早見化。各セルから [13. ユースケース集](12-use-cases.md) / [09. 設定手順](08-config-procedures.md) / [10. 障害対応手順](09-incident-procedures.md) へリンク。

7 シーン × 3 習熟度（**初級** = 単純実行、**中級** = パラメータ調整、**上級** = 設計判断）= **21 セル**。

| シーン \ 習熟度 | **初級** | **中級** | **上級** |
|---|---|---|---|
| **(1) 新規 OMNIbus 構築** | [uc-objserv-create](12-use-cases.md#uc-objserv-create)（NCOMS 単体） | [uc-pa-deploy](12-use-cases.md#uc-pa-deploy)（PA 配下化） + [uc-omni-dat-edit](12-use-cases.md#uc-omni-dat-edit) | [scn-new-deployment](11-scenarios.md#scn-new-deployment) 全体俯瞰 |
| **(2) SMAC 多段化** | [uc-confpack-import](12-use-cases.md#uc-confpack-import)（aggregation.sql 投入） | [uc-smac-aggregation](12-use-cases.md#uc-smac-aggregation) + [uc-smac-collection](12-use-cases.md#uc-smac-collection) | [scn-smac-build](11-scenarios.md#scn-smac-build) — 規模・WAN・DMZ 分離設計 |
| **(3) failover / 高可用** | [uc-virtual-server-name](12-use-cases.md#uc-virtual-server-name) | [uc-failover-pair](12-use-cases.md#uc-failover-pair)（AGG_GATE 構成） | [scn-failover-build](11-scenarios.md#scn-failover-build) — controlled failback 含む |
| **(4) Probe 投入** | [uc-probe-syslog](12-use-cases.md#uc-probe-syslog)（既定 rules で起動） | [uc-rules-edit](12-use-cases.md#uc-rules-edit)（Identifier 設計）+ [uc-probe-snmp](12-use-cases.md#uc-probe-snmp) | [scn-eif-integration](11-scenarios.md#scn-eif-integration) — 大規模 Probe 集約 |
| **(5) 性能 / 容量** | [uc-display-status](12-use-cases.md#uc-display-status)（行数・Severity 分布確認） | [uc-trigger-tune](12-use-cases.md#uc-trigger-tune)（profiling）+ [uc-disable-details](12-use-cases.md#uc-disable-details) | [scn-perf-tuning](11-scenarios.md#scn-perf-tuning) — capacity planning |
| **(6) セキュリティ** | [uc-user-create](12-use-cases.md#uc-user-create) | [uc-ssl-objserv](12-use-cases.md#uc-ssl-objserv)（SecureMode）+ [uc-fips-mode](12-use-cases.md#uc-fips-mode) | LDAP 統合 / 監査トレース設計（個別案件依存、本ドキュメント範囲外） |
| **(7) 障害対応** | [inc-pa-process-down](09-incident-procedures.md#inc-pa-process-down) | [inc-probe-conn-fail](09-incident-procedures.md#inc-probe-conn-fail) + [inc-iduc-stuck](09-incident-procedures.md#inc-iduc-stuck) | [inc-objserv-hang](09-incident-procedures.md#inc-objserv-hang) + [inc-failover-resync-fail](09-incident-procedures.md#inc-failover-resync-fail) — A/B/C 仮説分岐で診断 |

## 使い方

1. 「いま自分が何をしようとしているか」のシーンを縦軸で選ぶ
2. 自分の習熟度（あるいはチームメンバへの指示の粒度）を横軸で選ぶ
3. セル内のリンクから具体的な手順 / ユースケース / 障害対応へジャンプ

「このセルが空欄」 = OMNIbus の標準的な公式手順では推奨フローが薄い領域（要設計判断 / 個別案件依存）。

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
