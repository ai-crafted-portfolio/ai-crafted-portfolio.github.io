# VTAM

**SNA ネットワーク主タスク**

*§K-8. PROCLIB 標準 PROC 網羅 (1)  (3/17)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | VTAM (Virtual Telecommunications Access Method) の主タスク。SNA/APPN ネットワーク全般 |
| **主要パラメータ** | PARM='LIST=00' (ATCSTRxx 起動メンバ) / VTAMLST データセット連結 |
| **影響範囲** | F VTAM,HALT で停止 (= 全 SNA セッション断) |
| **関連メンバ** | ATCSTRxx (VTAMLST), TCPIP (相互依存) |
| **注意点** | 停止すると 3270 接続・LU2 アプリ・メインフレーム間 SNA 通信 全停止 |

---

[← JES3](jes3.md) / [↑ §K-8. PROCLIB 標準 PROC 網羅 (1)](../section-k8-proclib-ipl.md) / [TCPIP →](tcpip.md)
