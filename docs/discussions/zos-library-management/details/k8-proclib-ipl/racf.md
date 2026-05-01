# RACF

**RACF サブシステム (オプショナル)**

*§K-8. PROCLIB 標準 PROC 網羅 (1)  (5/17)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | RACF コマンド処理用のサブシステム (RACF サブシステム)。RACF 機能本体は必須ではない |
| **主要パラメータ** | PARM='SUBSYS=RACF' |
| **影響範囲** | P RACF で停止可。ただし RACF 認証本体は影響なし |
| **関連メンバ** | IRRPRMxx (RACF DB) |
| **注意点** | RACF サブシステム停止しても認証は継続。RVARY コマンドの利用に必要 |

---

[← TCPIP](tcpip.md) / [↑ §K-8. PROCLIB 標準 PROC 網羅 (1)](../section-k8-proclib-ipl.md) / [WLM →](wlm.md)
