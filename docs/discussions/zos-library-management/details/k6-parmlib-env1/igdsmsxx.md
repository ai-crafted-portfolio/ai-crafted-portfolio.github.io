# IGDSMSxx

**DFSMS 構成**

*§K-6. PARMLIB 標準メンバ網羅 (6)  (1/13)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | DFSMS Storage Class / Management Class / Data Class / Storage Group の有効化と SMS 関連デフォルト |
| **主要パラメータ** | ACDS(SYS1.DFSMS.ACDS) / COMMDS(SYS1.DFSMS.COMMDS) / SMS ACTIVE / TRACE(ON) SIZE(128K) |
| **影響範囲** | SET SMS=xx で動的反映可。SETSMS コマンドで個別変更も可能 |
| **関連メンバ** | ALLOCxx, DEVSUPxx |
| **注意点** | ACDS の切替は慎重に。SMS 構成定義変更は DFSMS 管理者の責任範囲 |

---

[↑ §K-6. PARMLIB 標準メンバ網羅 (6)](../section-k6-parmlib-env1.md) / [IKJTSOxx →](ikjtsoxx.md)
