# PROGxx

**APF/LNKLST/LPA/Exit 動的更新の中核**

*§K-1. PARMLIB 標準メンバ網羅 (1)  (11/12)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | APF 認可、LNKLST 連結、LPA、System Exit の動的更新を一元管理。最重要メンバ |
| **主要パラメータ** | APF ADD DSNAME(...) / LNKLST DEFINE NAME(LNKxx) / LPA ADD MODULES(...) / EXIT ADD EXITNAME(...) |
| **影響範囲** | SETPROG コマンドで動的反映可 (IPL 不要) |
| **関連メンバ** | IEAAPFxx (旧 APF), LNKLSTxx (旧 LNKLST), LPALSTxx (旧 LPA), IEALPAxx |
| **注意点** | z/OS 運用の中核。変更は SOX 監査対象で必ず承認 + ログ取得。誤変更は特権実行のセキュリティ事故に直結 |

---

[← IEAAPFxx](ieaapfxx.md) / [↑ §K-1. PARMLIB 標準メンバ網羅 (1)](../section-k1-parmlib-ipl.md) / [IEABLDxx →](ieabldxx.md)
