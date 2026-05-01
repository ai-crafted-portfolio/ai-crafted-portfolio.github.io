# DB2DIST

**Db2 Distributed Data Facility (DDF)**

*§K-10. PROCLIB 標準 PROC 網羅 (3)  (4/14)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | Db2 の分散接続 (DRDA / TCP/IP 経由の Db2 アクセス) |
| **主要パラメータ** | (DB2MSTR から自動起動 or START DDF) |
| **影響範囲** | STOP DDF で停止 (= リモート Db2 接続断) |
| **関連メンバ** | DB2MSTR, TCPIP |
| **注意点** | DDF 停止で Web/分散アプリの Db2 接続全断 |

---

[← DB2DBM1](db2dbm1.md) / [↑ §K-10. PROCLIB 標準 PROC 網羅 (3)](../section-k10-proclib-subsystem.md) / [DB2SPAS →](db2spas.md)
