# CSVLLAxx

**LLA (Library Lookaside) 設定**

*§K-7. PARMLIB 標準メンバ網羅 (7)  (4/14)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | LLA キャッシュするデータセット定義 |
| **主要パラメータ** | LIBRARIES(SYS1.LINKLIB,SYS1.LPALIB,...) / FREEZE(SYS1.LINKLIB) |
| **影響範囲** | F LLA,UPDATE=xx で動的反映可 |
| **関連メンバ** | LLA PROC, COFVLFxx |
| **注意点** | LLA キャッシュ対象が多すぎると仮想記憶圧迫、少なすぎると I/O 増 |

---

[← CTncccxx](ctncccxx.md) / [↑ §K-7. PARMLIB 標準メンバ網羅 (7)](../section-k7-parmlib-env2.md) / [CUNUNIxx →](cununixx.md)
