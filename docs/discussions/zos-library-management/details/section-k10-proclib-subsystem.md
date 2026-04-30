# §K-10. PROCLIB 標準 PROC 網羅 (3) — サブシステム起動

T30.2 のサブシステム PROC を網羅する。

| # | PROC 名 | 役割 |
|---|---|---|
| 26 | CICS / CICS* | CICS リージョン (TOR/AOR/FOR、サイト命名 例: CICSPROD) |
| 27 | DB2MSTR | Db2 Master Address Space (サブシステム制御) |
| 28 | DB2DBM1 | Db2 Database Manager |
| 29 | DB2DIST | Db2 Distributed Data Facility (DDF) |
| 30 | DB2SPAS | Db2 Stored Procedure Address Space |
| 31 | DB2WLM | Db2 WLM 管理 |
| 32 | IMSCTL / IMS* | IMS Control Region (サイト命名) |
| 33 | IRLM / IRLMPROC | Internal Resource Lock Manager (Db2/IMS 共用) |
| 34 | MQM / MQMSER | WebSphere MQ キュー マネージャ (サイト命名) |
| 35 | DFHSM / HSM | Hierarchical Storage Manager (DFSMShsm) |
| 36 | DFRMM | Removable Media Manager |
| 37 | LDAP | LDAP サーバ |
| 38 | HZSPROC | Health Checker (started task) |
| 39 | OAM | Object Access Method (DFSMSdfp) |

!!! warning "管理運用上の留意点 (T47)"
    CICS/Db2/IMS/MQ は OS 担当・サブシステム担当・アプリ担当の境界が曖昧。サブシステム別の責任マトリクスを明文化すること。

---

次ページ → [§K-11 PROCLIB 運用 + 監視・通知](section-k11-proclib-ops.md)
