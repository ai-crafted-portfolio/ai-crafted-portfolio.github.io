# NUCLSTxx

**Nucleus inclusion list**

*§K-1. PARMLIB 標準メンバ網羅 (1)  (4/12)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | IPL 時にロードする nucleus モジュール一覧。標準 nucleus + サイト追加モジュール を指定 |
| **主要パラメータ** | INCLUDE NUCMOD(IGC0001A) / EXCLUDE NUCMOD(IGC0002B) |
| **影響範囲** | IPL 必須・動的反映不可 |
| **関連メンバ** | LOADxx (NUCLST=xx で選択) |
| **注意点** | nucleus モジュールの追加は z/OS の最も内部レベルの変更。サイト独自カスタマイズはほぼ非推奨 |

---

[← IEASYMxx](ieasymxx.md) / [↑ §K-1. PARMLIB 標準メンバ網羅 (1)](../section-k1-parmlib-ipl.md) / [IEAPAKxx →](ieapakxx.md)
