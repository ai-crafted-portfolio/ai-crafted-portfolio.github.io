# IEAFIXxx

**Fixed ストレージ常駐モジュール**

*§K-1. PARMLIB 標準メンバ網羅 (1)  (7/12)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | IPL 時にストレージ FIX (常駐) するモジュールリスト |
| **主要パラメータ** | INCLUDE LIBRARY(SYS1.LINKLIB) MODULES(MOD1,MOD2) |
| **影響範囲** | IPL 必須・動的反映不可 |
| **関連メンバ** | IEAPAKxx (pack list), LPALSTxx |
| **注意点** | FIX しすぎると有効ストレージ減少。性能要件の根拠が無いなら追加しない |

---

[← IEALPAxx](iealpaxx.md) / [↑ §K-1. PARMLIB 標準メンバ網羅 (1)](../section-k1-parmlib-ipl.md) / [LPALSTxx →](lpalstxx.md)
