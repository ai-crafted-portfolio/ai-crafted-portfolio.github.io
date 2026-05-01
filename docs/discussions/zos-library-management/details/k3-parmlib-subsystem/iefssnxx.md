# IEFSSNxx

**サブシステム定義**

*§K-3. PARMLIB 標準メンバ網羅 (3)  (1/7)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | JES2/JES3, Db2, MQ, CICS, RACF 等の z/OS サブシステムを登録。各サブシステムの初期化ルーチン (Initialization routine) と起動オプションを指定 |
| **主要パラメータ** | SUBSYS SUBNAME(JES2) PRIMARY(YES) START(YES) / SUBSYS SUBNAME(DB2A) INITRTN(DSN3INI) INITPARM('SSN=DB2A') |
| **影響範囲** | IPL 必須 (PRIMARY サブシステム = JES の指定)。動的追加は SETSSI ADD で可能 |
| **関連メンバ** | COMMNDxx (S サブシステム), PROGxx |
| **注意点** | PRIMARY (JES) のミスマッチで TSO/バッチが動かない。サブシステム順序依存性に注意 |

---

[↑ §K-3. PARMLIB 標準メンバ網羅 (3)](../section-k3-parmlib-subsystem.md) / [IFAPRDxx →](ifaprdxx.md)
