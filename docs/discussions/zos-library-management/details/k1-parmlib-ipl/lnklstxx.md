# LNKLSTxx

**LNKLST 連結 (旧形式)**

*§K-1. PARMLIB 標準メンバ網羅 (1)  (9/12)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | LNKLST (システム検索パスの LINKLIB) のデータセット連結 |
| **主要パラメータ** | SYS1.LINKLIB / SYS1.MIGLIB / USER.LOADLIB |
| **影響範囲** | IPL 必須 (旧形式)。PROGxx LNKLST 文だと SETPROG LNKLST で動的反映可 |
| **関連メンバ** | PROGxx (LNKLST 文への移行が推奨), LPALSTxx, IEAAPFxx |
| **注意点** | 旧形式。新規サイトは PROGxx LNKLST DEFINE/ACTIVATE 構文を使うこと。順序依存性に注意 |

---

[← LPALSTxx](lpalstxx.md) / [↑ §K-1. PARMLIB 標準メンバ網羅 (1)](../section-k1-parmlib-ipl.md) / [IEAAPFxx →](ieaapfxx.md)
