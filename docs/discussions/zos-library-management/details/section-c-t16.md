# §C-T16. 運用 / 管理 (8 機能)

Change Tracker (S15) の運用 / 管理 8 機能。

---

## 論点

z/OS 上の運用基盤 (STC・WLM・SMP/E・z/OSMF・VSAM repository) をどう扱うか。

## 個別判定

| # | 機能 | 判定 | 実装方法 / 割切理由 |
|---|---|---|---|
| 1 | STC (常駐タスク) | 割切 | z/OS 側不設置 (SSOT ①) |
| 2 | WLM 連携 | 割切 | z/OS 側不設置 (SSOT ①) |
| 3 | SMP/E 配布 | 割切 | z/OS 側不設置 (SSOT ①) |
| 4 | z/OSMF GUI | 割切 | z/OS 側不設置 (SSOT ①) |
| 5 | VSAM repository | 割切 | z/OS 側不設置 (SSOT ①) |
| 6 | RACF プロファイル設計 | 割切 | z/OS 側不設置 (SSOT ①) |
| 7 | JES2 連携 | 割切 | z/OS 側不設置 (SSOT ①) |
| 8 | ENVIRONMENT ファイル管理 | 採用 | Excel 設定シート |

!!! success "T16 の判定結果"
    **8 機能のうち 1 機能採用。** z/OS 上の運用基盤はすべて割切 (本ツールの根本設計と相反)。

---

次ページ → [§D 技術実現性](section-d-tech.md)
