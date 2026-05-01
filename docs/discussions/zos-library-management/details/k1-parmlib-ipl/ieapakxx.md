# IEAPAKxx

**LPA pack list**

*§K-1. PARMLIB 標準メンバ網羅 (1)  (5/12)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | LPA に積むモジュールの順序を指定。アクセス頻度の高いモジュールを連続配置 |
| **主要パラメータ** | PAK MEM=(MOD1,MOD2,MOD3) — 一塊として配置するモジュール群 |
| **影響範囲** | CLPA 時に有効化 (= IPL with CLPA か COLD START)。動的反映不可 |
| **関連メンバ** | LPALSTxx (LPA データセット連結), IEALPAxx (動的 LPA) |
| **注意点** | ほとんどのサイトでデフォルトのまま。チューニング目的以外は触らない |

---

[← NUCLSTxx](nuclstxx.md) / [↑ §K-1. PARMLIB 標準メンバ網羅 (1)](../section-k1-parmlib-ipl.md) / [IEALPAxx →](iealpaxx.md)
