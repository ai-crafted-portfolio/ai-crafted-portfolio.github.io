# IEFOPZxx

**Operator Auto-Reply 自動応答ルール**

*§K-2. PARMLIB 標準メンバ網羅 (2)  (9/9)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | WTOR (Write To Operator with Reply) に対する自動応答ルール |
| **主要パラメータ** | AUTOR MSGID(IEF881D) REPLY('U') DELAY(60) |
| **影響範囲** | SET OPT=xx で動的反映可 |
| **関連メンバ** | MPFLSTxx, COMMNDxx |
| **注意点** | 誤った自動応答ルールでオペレータ判断が必要なメッセージにも自動 U 応答してしまうリスク。ルールの監査必須 |

---

[← PFKTABxx](pfktabxx.md) / [↑ §K-2. PARMLIB 標準メンバ網羅 (2)](../section-k2-parmlib-console.md) / [次セクション: §K-3 PARMLIB サブシステム認可 →](../section-k3-parmlib-subsystem.md)
