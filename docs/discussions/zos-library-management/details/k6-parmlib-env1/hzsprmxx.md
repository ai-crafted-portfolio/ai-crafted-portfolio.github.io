# HZSPRMxx

**Health Checker 設定**

*§K-6. PARMLIB 標準メンバ網羅 (6)  (9/13)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | IBM Health Checker のチェック実行スケジュール、出力先、Exception 処理 |
| **主要パラメータ** | POLICY ADD CHECK(IBMUSS,USS_FILESYS_FREESPACE) ACTIVE(NO) — 個別チェック制御 |
| **影響範囲** | SET HZS=xx 等で動的反映可、F HZSPROC コマンドでも変更可 |
| **関連メンバ** | HZSPROC (PROC) |
| **注意点** | Exception 多発時の通知ルール設計。サイトに合わない Check は無効化 |

---

[← VATLSTxx](vatlstxx.md) / [↑ §K-6. PARMLIB 標準メンバ網羅 (6)](../section-k6-parmlib-env1.md) / [GTZPRMxx →](gtzprmxx.md)
