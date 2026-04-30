# §K-9. PROCLIB 標準 PROC 網羅 (2) — ネットワーク + TSO 系

T30.1 ネットワーク + T30.3 TSO 系の PROC を網羅する。

| # | PROC 名 | 役割 |
|---|---|---|
| 14 | FTPD | FTP daemon |
| 15 | INETD | Internet daemon (USS 不在時はほぼ使われない) |
| 16 | TN3270 | Telnet 3270 サーバ |
| 17 | OMPROUTE | OSPF/RIP 動的経路 daemon |
| 18 | OSNMPD | SNMP daemon |
| 19 | PORTMAP | RPC Portmapper |
| 20 | RESOLVER | DNS リゾルバ |
| 21 | TCAS | TSO Cas (TSO サブシステム本体) |
| 22 | TSO | TSO ログオン PROC |
| 23 | TSOLOGON | TSO ログオン (サイトカスタム名で運用されるケース多) |
| 24 | IKJ* | TSO 関連バッチ呼出 (PROC ではないが慣習で記載) |
| 25 | ISPF* | ISPF カスタム (サイト命名) |

!!! warning "管理運用上の留意点 (T48)"
    TSO/TSOLOGON/IKJ* 変更は全利用者に影響。利用者向けリリースノートを同時発行し、RACF 認可整合性チェックを行うこと。

---

次ページ → [§K-10 PROCLIB サブシステム起動](section-k10-proclib-subsystem.md)
