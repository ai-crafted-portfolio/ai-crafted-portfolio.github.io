# IRLM / IRLMPROC

**Internal Resource Lock Manager**

*§K-10. PROCLIB 標準 PROC 網羅 (3)  (8/14)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | Db2/IMS の内部ロックマネージャ。シスプレックス対応の分散ロック |
| **主要パラメータ** | PARM='SCOPE=GLOBAL,LOCKTABL=...' / IRLM 起動オプション |
| **影響範囲** | STOP IRLM で停止 (= Db2/IMS 影響) |
| **関連メンバ** | DB2MSTR, IMSCTL |
| **注意点** | Db2 と IMS が IRLM を共有するケース。バージョン整合性必須 |

---

[← IMSCTL / IMS*](imsctl-ims.md) / [↑ §K-10. PROCLIB 標準 PROC 網羅 (3)](../section-k10-proclib-subsystem.md) / [MQM / MQMSER →](mqm-mqmser.md)
