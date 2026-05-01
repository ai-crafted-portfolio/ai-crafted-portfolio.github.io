# MPFLSTxx

**Message Processing Facility — メッセージ抑止**

*§K-2. PARMLIB 標準メンバ網羅 (2)  (3/9)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | コンソールへ表示するメッセージのフィルタリング (抑止 / 強調 / 自動応答) |
| **主要パラメータ** | .MSGS COMPLEVEL(MASTER) / msgID,SUP(YES),AUTO(NO) — 抑止指定 |
| **影響範囲** | SET MPF=xx で動的反映可 |
| **関連メンバ** | CONSOLxx, MSGFLDxx |
| **注意点** | 重要メッセージを誤って抑止すると障害検知遅延。抑止リストのレビューを定期実施 |

---

[← COMMNDxx](commndxx.md) / [↑ §K-2. PARMLIB 標準メンバ網羅 (2)](../section-k2-parmlib-console.md) / [IEACMD00 →](ieacmd00.md)
