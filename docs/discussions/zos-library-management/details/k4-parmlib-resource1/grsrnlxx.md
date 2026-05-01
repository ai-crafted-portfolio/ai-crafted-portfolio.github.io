# GRSRNLxx

**GRS Resource Name List**

*§K-4. PARMLIB 標準メンバ網羅 (4)  (4/10)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | GRS のスコープ別リソース名分類 (SYSTEM/SYSTEMS/EXCLUSION)。データセット ENQ の対象範囲 |
| **主要パラメータ** | RNLDEF RNL(INCL) TYPE(GENERIC) QNAME(SYSDSN) / RNLDEF RNL(EXCL) TYPE(GENERIC) QNAME(SYSDSN) RNAME(SYS1.LINKLIB) |
| **影響範囲** | SET GRSRNL=xx で動的反映可 |
| **関連メンバ** | GRSCNFxx |
| **注意点** | ENQ 競合時の挙動を決める核。誤分類でデータセット排他制御が破綻するリスク |

---

[← GRSCNFxx](grscnfxx.md) / [↑ §K-4. PARMLIB 標準メンバ網羅 (4)](../section-k4-parmlib-resource1.md) / [SMFPRMxx →](smfprmxx.md)
