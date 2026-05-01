# JES2

**JES2 サブシステム本体**

*§K-8. PROCLIB 標準 PROC 網羅 (1)  (1/17)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | JES2 (Job Entry Subsystem 2) の主タスク。バッチジョブの入力・実行・出力管理の中核 |
| **主要パラメータ** | PARM='WARM,NOREQ' (起動モード) / HASPLIST=DD (PARMLIB から JES2 の HASPPARM を読む) / SPOOL データセット定義 |
| **影響範囲** | $P JES2 で停止、$S JES2 で開始。停止すると全バッチ・TSO 影響 |
| **関連メンバ** | IEFSSNxx (PRIMARY=JES2), HASPPARM (JES2 設定) |
| **注意点** | JES2 起動時のオプション (HOT/WARM/COLD) によりリカバリ動作が異なる。COLD START はスプール初期化 |

---

[↑ §K-8. PROCLIB 標準 PROC 網羅 (1)](../section-k8-proclib-ipl.md) / [JES3 →](jes3.md)
