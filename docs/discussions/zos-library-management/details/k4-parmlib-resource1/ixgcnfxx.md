# IXGCNFxx

**System Logger 構成**

*§K-4. PARMLIB 標準メンバ網羅 (4)  (10/10)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | System Logger (Log Stream マネージャ) の構成。CF Structure 利用と DASD ステージング設定 |
| **主要パラメータ** | STAGING DSN PREFIX(LOGR) / CFLOG STREAMSIZE(1024) |
| **影響範囲** | SET IXG=xx で動的反映可 |
| **関連メンバ** | COUPLExx (Logger CDS) |
| **注意点** | Logger 容量計画が誤ると重要ログ (RACF, OPERLOG, LOGREC) のロスト。スステージング指定が重要 |

---

[← COUPLExx](couplexx.md) / [↑ §K-4. PARMLIB 標準メンバ網羅 (4)](../section-k4-parmlib-resource1.md) / [次セクション: §K-5 PARMLIB リソース管理 後半 →](../section-k5-parmlib-resource2.md)
