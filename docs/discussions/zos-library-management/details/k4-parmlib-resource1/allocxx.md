# ALLOCxx

**アロケーション デフォルト**

*§K-4. PARMLIB 標準メンバ網羅 (4)  (2/10)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | DD ステートメントのデフォルト値 (UNIT, SPACE, EATTR 等)。ALLOCATION SETALLOC のシステムデフォルト |
| **主要パラメータ** | SYSTEM IEFBR14_DELMIGDS(LEGACY) / SYSTEM TAPELIB_PREF(BYDEVN) / VERIFY UNCATALOG ON |
| **影響範囲** | SET ALLOC=xx で動的反映可 |
| **関連メンバ** | DEVSUPxx, IGDSMSxx |
| **注意点** | デフォルト変更で既存 JCL の挙動が変わるリスク。EATTR (Extended Attribute) 関連は要慎重 |

---

[← IEAOPTxx](ieaoptxx.md) / [↑ §K-4. PARMLIB 標準メンバ網羅 (4)](../section-k4-parmlib-resource1.md) / [GRSCNFxx →](grscnfxx.md)
