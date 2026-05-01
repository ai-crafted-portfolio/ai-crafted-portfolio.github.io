# FXEPRMxx

**PFA (Predictive Failure Analysis) 設定**

*§K-6. PARMLIB 標準メンバ網羅 (6)  (11/13)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | z/OS の予兆検知機能 (PFA) のチェック有効化 |
| **主要パラメータ** | PFA CHECK(SMF_ARRIVAL_RATE,...) ACTIVE / INACTIVE |
| **影響範囲** | SET PFA=xx で動的反映可 |
| **関連メンバ** | HZSPRMxx |
| **注意点** | PFA は学習に時間がかかる (通常 6 時間〜)。安定運用後の有効化が前提 |

---

[← GTZPRMxx](gtzprmxx.md) / [↑ §K-6. PARMLIB 標準メンバ網羅 (6)](../section-k6-parmlib-env1.md) / [BPXPRMxx →](bpxprmxx.md)
