# 全体観: 運用資材領域には公式の管理体系が無い

既存ツールはいずれも運用資材のメンバ単位差分を体系的に追跡しない。

---

| 既存ツール | 本来の管轄 | 運用資材領域への適用上の限界 |
|---|---|---|
| SMP/E | IBM 保守領域 | 運用資材は SMP/E の対象範囲外 |
| SCM (SCLM/Endevor/Git) | アプリソース領域 | アプリ部門の管轄。運用資材まで全面拡張する案は別検討 |
| RACF / SMF | アクセス監査 | 「誰が・いつ」までは追えるが「中身が何に変わったか」は追えない |
| ISPF スタッツ | メンバ単位の更新追跡 | RECFM=U には付かない / Reset Statistics で改竄可能 |
| z/OS Change Tracker (V2R5+) | 公式の唯一の解 | STC 常駐 + VSAM repository + RACF プロファイル設計 + priced feature。小規模現場では導入要件を満たせない |

---

!!! warning "帰結"
    運用資材領域は公式管理空白。Change Tracker のみが公式の解だが、小規模現場では導入要件 (priced feature・STC 常駐・RACF プロファイル) を満たせない。

    → **Change Tracker を導入できない現場のための、軽量な代替手段が必要。**

---

次ページ → [本ツールの位置づけ — Change Tracker との関係](04-positioning.md)
