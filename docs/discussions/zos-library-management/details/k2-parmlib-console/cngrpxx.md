# CNGRPxx

**コンソール グループ定義**

*§K-2. PARMLIB 標準メンバ網羅 (2)  (5/9)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | Alternate console グループの定義。マスターコンソール障害時の自動切替先指定 |
| **主要パラメータ** | GROUP NAME(MASTGRP) MEMBER(CON1,CON2,CON3) |
| **影響範囲** | SET CNGRP=xx で動的反映可 |
| **関連メンバ** | CONSOLxx (alternate 指定の参照先) |
| **注意点** | AUTOSWITCH 設定とセットで運用。グループに有効コンソールが残らないと運用不能 |

---

[← IEACMD00](ieacmd00.md) / [↑ §K-2. PARMLIB 標準メンバ網羅 (2)](../section-k2-parmlib-console.md) / [MSGFLDxx →](msgfldxx.md)
