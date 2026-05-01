# IEALPAxx

**動的 LPA 追加**

*§K-1. PARMLIB 標準メンバ網羅 (1)  (6/12)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | SETPROG LPA コマンドや IPL 時に動的に LPA 追加するモジュール |
| **主要パラメータ** | MODULES (MOD1,MOD2) DSNAME(SYS1.LINKLIB) |
| **影響範囲** | 動的反映可 (SETPROG LPA で更新)。IPL 不要 |
| **関連メンバ** | PROGxx (LPA 文への移行が推奨), LPALSTxx |
| **注意点** | 動的 LPA は仮想記憶を消費。長期間運用で LPA 圧迫、計画的な PLPA 再構築が必要 |

---

[← IEAPAKxx](ieapakxx.md) / [↑ §K-1. PARMLIB 標準メンバ網羅 (1)](../section-k1-parmlib-ipl.md) / [IEAFIXxx →](ieafixxx.md)
