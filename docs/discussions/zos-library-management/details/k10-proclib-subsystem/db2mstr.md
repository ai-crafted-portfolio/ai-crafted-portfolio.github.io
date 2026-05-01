# DB2MSTR

**Db2 Master Address Space**

*§K-10. PROCLIB 標準 PROC 網羅 (3)  (2/14)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | Db2 サブシステム制御の主タスク。Db2 全体のシステム制御 |
| **主要パラメータ** | PARM='ssn,opt' (サブシステム名と起動オプション) |
| **影響範囲** | STOP DB2 で停止 (= Db2 業務影響) |
| **関連メンバ** | DB2DBM1, DB2DIST, DB2SPAS, IRLM |
| **注意点** | Db2 サブシステム停止は SYSPLEX 内 DDF 接続にも影響 |

---

[← CICS / CICS*](cics-cics.md) / [↑ §K-10. PROCLIB 標準 PROC 網羅 (3)](../section-k10-proclib-subsystem.md) / [DB2DBM1 →](db2dbm1.md)
