# MMSLSTxx

**MVS Message Service — 多言語メッセージ**

*§K-2. PARMLIB 標準メンバ網羅 (2)  (7/9)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | メッセージの言語別ルックアップ表。日本語・英語等のメッセージ翻訳 |
| **主要パラメータ** | LANGCODE(JPN) MEM(IGCJPN) / LANGCODE(ENU) MEM(IGCENU) |
| **影響範囲** | SET MMS=xx で動的反映可 |
| **関連メンバ** | CONSOLxx (LANG 属性) |
| **注意点** | MMS 表が壊れるとメッセージ表示が破綻。デフォルト英語で運用するサイトが多い |

---

[← MSGFLDxx](msgfldxx.md) / [↑ §K-2. PARMLIB 標準メンバ網羅 (2)](../section-k2-parmlib-console.md) / [PFKTABxx →](pfktabxx.md)
