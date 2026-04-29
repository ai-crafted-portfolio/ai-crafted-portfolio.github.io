# §C-T12. ロック / Check-in/out (5 機能)

Change Tracker (S15) のロック / Check-in/out 5 機能。

---

## 論点

同時編集事故の防止という運用要件を、z/OS 側強制力なしでどう満たすか。

## 個別判定

| # | 機能 | 判定 | 実装方法 / 割切理由 |
|---|---|---|---|
| 1 | CHECKOUT (チェックアウト) | 採用 | Excel ワークシートに擬似フラグ |
| 2 | CHECKIN (チェックイン) | 採用 | Excel ワークシートで戻し操作 |
| 3 | FORCED CHECKIN (強制リリース) | 採用 | Excel 管理者ボタン |
| 4 | RESERVED (予約状態) | 採用 | Excel ステータス列 |
| 5 | z/OS 側 ENQ ロック | 割切 | z/OS 内部のため z/OS 外から制御不能 |

!!! success "T12 の判定結果"
    **5 機能のうち 4 機能採用。** z/OS 側 ENQ ロックは技術的に z/OS 外から制御不能のため割切。

---

次ページ → [§C-T13 リカバリ](section-c-t13.md)
