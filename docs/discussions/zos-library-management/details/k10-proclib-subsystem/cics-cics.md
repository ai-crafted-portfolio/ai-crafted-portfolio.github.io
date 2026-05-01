# CICS / CICS*

**CICS リージョン**

*§K-10. PROCLIB 標準 PROC 網羅 (3)  (1/14)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | CICS (Customer Information Control System) のリージョン起動 PROC。TOR/AOR/FOR 等の役割別リージョン |
| **主要パラメータ** | DFHSIT=xx (システム初期化テーブル) / SYSIN DSN(...) / DFHRPL データセット連結 |
| **影響範囲** | CEMT P SHUT で停止 (= CICS 業務影響) |
| **関連メンバ** | Db2 (CICS-DB2 連携), MQ (CICS-MQ) |
| **注意点** | 本番 CICS の停止は業務直結。サブシステム別責任マトリクス必須 (T47) |

---

[↑ §K-10. PROCLIB 標準 PROC 網羅 (3)](../section-k10-proclib-subsystem.md) / [DB2MSTR →](db2mstr.md)
