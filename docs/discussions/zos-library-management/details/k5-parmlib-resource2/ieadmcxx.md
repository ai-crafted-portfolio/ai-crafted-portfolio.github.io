# IEADMCxx

**ダンプ コマンド事前定義**

*§K-5. PARMLIB 標準メンバ網羅 (5)  (2/9)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | DUMP コマンドのテンプレ定義。よくダンプを取る対象を事前登録 |
| **主要パラメータ** | DUMP TITLE='IRLM dump',JOBNAME=IRLMPROC,DSPNAME=('IRLMPROC'.*) |
| **影響範囲** | SET DAE=xx 等でなく、DUMP COMM=(xx) で参照 |
| **関連メンバ** | IEADMPxx, IEADMR00 |
| **注意点** | ダンプ取得忘れの予防。サイト独自の障害解析テンプレを蓄積する場所 |

---

[← IXBRPRxx](ixbrprxx.md) / [↑ §K-5. PARMLIB 標準メンバ網羅 (5)](../section-k5-parmlib-resource2.md) / [IEADMPxx →](ieadmpxx.md)
