# MSGFLDxx

**メッセージ flooding 制御**

*§K-2. PARMLIB 標準メンバ網羅 (2)  (6/9)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | 同一メッセージが大量発生した場合の表示制御 (flood 検知と抑止) |
| **主要パラメータ** | MSGFLD ID(msgID) THRESH(10) INTERVAL(5) |
| **影響範囲** | SET MSGFLD=xx で動的反映可 |
| **関連メンバ** | MPFLSTxx |
| **注意点** | 閾値が高すぎると flood 抑止が機能せず、低すぎると正常メッセージも抑止される。チューニング必要 |

---

[← CNGRPxx](cngrpxx.md) / [↑ §K-2. PARMLIB 標準メンバ網羅 (2)](../section-k2-parmlib-console.md) / [MMSLSTxx →](mmslstxx.md)
