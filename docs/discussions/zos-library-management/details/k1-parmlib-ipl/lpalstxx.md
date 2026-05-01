# LPALSTxx

**LPA データセット連結**

*§K-1. PARMLIB 標準メンバ網羅 (1)  (8/12)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | LPA に追加するデータセット連結を定義 (SYS1.LPALIB の他にカスタム LPA ライブラリを連結) |
| **主要パラメータ** | SYS1.LPALIB / USER.LPALIB / VENDOR.LPALIB |
| **影響範囲** | CLPA 時に有効化 (= IPL with CLPA)。SETPROG LPA で動的追加は可能 |
| **関連メンバ** | LNKLSTxx, PROGxx (LPA 文移行), IEAPAKxx |
| **注意点** | PROGxx LPA 文への移行が推奨されている。並行管理は混乱のもと |

---

[← IEAFIXxx](ieafixxx.md) / [↑ §K-1. PARMLIB 標準メンバ網羅 (1)](../section-k1-parmlib-ipl.md) / [LNKLSTxx →](lnklstxx.md)
