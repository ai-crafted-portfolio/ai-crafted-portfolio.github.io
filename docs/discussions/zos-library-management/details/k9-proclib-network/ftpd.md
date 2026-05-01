# FTPD

**FTP daemon**

*§K-9. PROCLIB 標準 PROC 網羅 (2)  (1/12)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | FTP サーバ (TCP/IP daemon)。z/OS から/への FTP アクセス |
| **主要パラメータ** | PARM='POSIX(ON) ALL31(ON) ENVAR("_BPX_JOBNAME=FTPD")' / FTP.DATA 設定ファイル |
| **影響範囲** | P FTPD で停止可。本番では UNIX-style daemon として稼働 |
| **関連メンバ** | TCPIP, RESOLVER |
| **注意点** | FTP セキュリティ (TLS, IP アクセス制限) の設定必須。本ツールでは PCOMM IND$FILE 採用のため利用しない |

---

[↑ §K-9. PROCLIB 標準 PROC 網羅 (2)](../section-k9-proclib-network.md) / [INETD →](inetd.md)
