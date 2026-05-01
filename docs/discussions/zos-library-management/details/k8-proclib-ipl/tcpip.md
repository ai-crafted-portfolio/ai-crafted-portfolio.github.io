# TCPIP

**TCP/IP スタック**

*§K-8. PROCLIB 標準 PROC 網羅 (1)  (4/17)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | TCP/IP プロトコルスタック本体 (z/OS Communications Server) |
| **主要パラメータ** | PARM='CTRACE(CTIEZB00),IDS=IDS' / PROFILE データセット (PROFILE.TCPIP) |
| **影響範囲** | P TCPIP で停止 (= 全 TCP/IP 通信断) |
| **関連メンバ** | VTAM (依存), RESOLVER (DNS), OMPROUTE (ルーティング) |
| **注意点** | 停止で RACF 認証・3270 emulator・FTP 全停止。設定変更は VARY TCPIP コマンドで動的に |

---

[← VTAM](vtam.md) / [↑ §K-8. PROCLIB 標準 PROC 網羅 (1)](../section-k8-proclib-ipl.md) / [RACF →](racf.md)
