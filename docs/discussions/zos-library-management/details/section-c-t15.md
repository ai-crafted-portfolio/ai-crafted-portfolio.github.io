# §C-T15. レポート / 監査 (6 機能)

Change Tracker (S15) のレポート / 監査 6 機能。

---

## 論点

Administrator/Auditor のロール分離を z/OS 外でどう扱うか。

## 個別判定

| # | 機能 | 判定 | 実装方法 / 割切理由 |
|---|---|---|---|
| 1 | SHOW=UNIVERSE (全保護対象) | 採用 | Excel ピボット |
| 2 | SHOW=HISTORY (変更履歴) | 採用 | Excel 履歴シート |
| 3 | ORPHANBACKUP (孤児バックアップ) | 採用 | VBA で残骸検出 |
| 4 | SHOW=ACTIVITY (活動概要) | 採用 | Excel 集計シート |
| 5 | AUDIT EXPORT (監査用エクスポート) | 採用 | CSV エクスポート |
| 6 | ロール分離 (Administrator/Auditor) | 割切 | OS 側のアクセス権 (NTFS / 共有フォルダ ACL) に委ねる |

!!! success "T15 の判定結果"
    **6 機能のうち 5 機能採用。** ロール分離のみ割切 (OS 側 ACL に委ねる)。

---

次ページ → [§C-T16 運用 / 管理](section-c-t16.md)
