# §C-T9. 対象指定 / 保護管理 (4 機能)

Change Tracker (S15) の PROTECT / EXPLICIT / PATTERN / EXCLUDE 4 機能。

---

## 論点

対象 DSN・パターン・除外指定を Excel ワークシートで等価実装可能か。

## 個別判定

| # | 機能 | 判定 | 実装方法 / 割切理由 |
|---|---|---|---|
| 1 | PROTECT (保護対象指定) | 採用 | Excel の対象 DSN 列に明示。VBA で対象判定 |
| 2 | EXPLICIT (明示的対象指定) | 採用 | PROTECT と同列で実装 |
| 3 | PATTERN (パターン指定) | 採用 | Excel ワイルドカード列を追加 |
| 4 | EXCLUDE (除外指定) | 採用 | Excel 除外列を追加 |

!!! success "T9 の判定結果"
    **4 機能すべて採用。** Excel ワークシートに対象 DSN・パターン・除外列を設計。

---

次ページ → [§C-T10 バックアップ / 世代管理](section-c-t10.md)
