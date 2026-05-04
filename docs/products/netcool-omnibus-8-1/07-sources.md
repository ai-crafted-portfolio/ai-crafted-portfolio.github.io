# 出典一覧

> 本サイトで参照する公式マニュアル・PDF・補完資料の出典 ID 表。**40 件**（公式 25 + Best Practices Guide v1.3 + 補完 14）。

## 出典 ID 命名規則

- `S_OMN_*` : OMNIbus 8.1 公式ドキュメント
- `S_OMN_BP` : Best Practices Guide v1.3（**本サイトの中核出典**）
- `S_OMN_PROBE_*` : 個別 Probe / Gateway ドキュメント
- `S_NOI` / `S_ITM` / `S_DASH` 等 : 周辺・連携製品
- `S_GSKIT` / `S_PAM` 等 : 横断技術

## 主要出典（OMNIbus 公式）

| 出典 ID | ドキュメント名 | 形態 | 主に参照する章 |
|---|---|---|---|
| **S_OMN_BP** | IBM Tivoli Netcool/OMNIbus 8.1 Best Practices Guide v1.3（2024 改訂） | PDF（198p） | 全章中核 |
| S_OMN_QSG | IBM Tivoli Netcool/OMNIbus 8.1 Quick Start Guide | Web | index, 01, 02 |
| S_OMN_DEPLOY | OMNIbus 8.1 Installation and Deployment Guide | Web | 06 manual-map, 08 cfg-* |
| S_OMN_ADMIN | OMNIbus 8.1 Administration Guide | Web | 02, 03, 08 全般 |
| S_OMN_SQL_REF | OMNIbus 8.1 SQL Reference | Web | 01 SQL コマンド, 02, 03 |
| S_OMN_PROBE_GW | OMNIbus 8.1 Probe and Gateway Guide | Web | 01 Probe, 08 cfg-probe-* |
| S_OMN_WEBGUI | OMNIbus 8.1 Web GUI User's Guide / Administration Guide | Web | 03 Web GUI, 08 cfg-webgui-waapi |
| S_OMN_WAAPI | OMNIbus 8.1 Web GUI Administration API（WAAPI）User's Guide | Web | 01 runwaapi, 08 cfg-webgui-waapi |
| S_OMN_EIF | IBM Tivoli Event Integration Facility（EIF）Reference for OMNIbus 8.1 | Web | 03 EIF, 08 cfg-probe-eif |
| S_OMN_ITM | IBM Tivoli Monitoring Agent for Netcool/OMNIbus User's Guide | Web | 03 ITM, 08 cfg-probe-eif |
| S_OMN_MIB_MGR | Netcool MIB Manager User's Guide | Web | 03 MIB Manager, 08 cfg-probe-snmp |
| S_OMN_PROBE_SYSLOG | Probe for Syslog 8.x Reference Guide | Web | 08 cfg-probe-syslog |
| S_OMN_PROBE_MTTRAPD | Probe for SNMP（MTTrapd）8.x Reference Guide | Web | 08 cfg-probe-snmp |
| S_OMN_PROBE_GLF | Generic Log File Probe Reference Guide | Web | 08 cfg-probe-glf |
| S_OMN_GW_OBJSERV | ObjectServer Gateway Reference Guide（uni / bi） | Web | 01 nco_g_objserv_*, 08 cfg-failover-pair |
| S_OMN_PROXY | Proxy Server Reference | Web | 01 nco_proxyserv, 08 cfg-proxy-deploy |
| S_OMN_PA | Process Agent Reference | Web | 03 Process Agent, 08 cfg-pa-deploy |
| S_OMN_AEN | OMNIbus Administration Guide Chapter 6 (Configuring AEN) | Web | 03 AEN, 08 cfg-aen-enable |
| S_OMN_HOUSEKEEPING | Best Practices Guide v1.3 Chapter 4 (ObjectServers) | PDF | 03 housekeeping, 09 inc-alerts-status-bloat |
| S_OMN_SMAC | Best Practices Guide v1.3 Chapter 7 (Anatomy of the standard multitier architecture configuration) | PDF | 03 SMAC, 08 cfg-smac-* |
| S_OMN_FAILOVER | Best Practices Guide v1.3 Chapter 7 (Failover and failback) | PDF | 03 Controlled Failback, 08 cfg-failover-pair, 09 inc-failover-resync-fail |
| S_OMN_PLANNING | Best Practices Guide v1.3 Chapter 2 (Planning) | PDF | 11 scn-perf-tuning |
| S_OMN_DR | Best Practices Guide v1.3 Chapter 11 (Backups and disaster recovery) | PDF | 11 scn-disaster-recovery |
| S_OMN_MAINT | Best Practices Guide v1.3 Chapter 9 (Maintenance) | PDF | 09 全般 |
| S_OMN_NHTTPD | OMNIbus 8.1 Administration Guide HTTP Interface section | Web | 02 NHttpd.*, 08 cfg-objserv-http |

## 周辺・連携製品

| 出典 ID | ドキュメント名 | 形態 | 主に参照する章 |
|---|---|---|---|
| S_NOI | IBM Netcool Operations Insight 製品ドキュメント | Web | 03 NOI |
| S_ITM | IBM Tivoli Monitoring 製品ドキュメント | Web | 03 ITM |
| S_DASH | Jazz for Service Management（DASH）ドキュメント | Web | 03 DASH |
| S_WAS | WebSphere Application Server ドキュメント | Web | 03 WAS |
| S_OMN_SCALA | Operations Analytics - Log Analysis 連携セクション | Web | 08 cfg-scala-link |
| S_IMPACT | Netcool/Impact 製品ドキュメント | Web | 03 Impact |
| S_GSKIT | IBM Global Security Kit User's Guide | Web | 03 GSKit, 08 cfg-ssl-objserv |
| S_INSTALL_MANAGER | IBM Installation Manager Documentation | Web | 03 IM |

## 補完（横断技術）

| 出典 ID | ドキュメント名 | 形態 | 主に参照する章 |
|---|---|---|---|
| S_PAM | Linux PAM Documentation | Web | 03 PAM, 08 cfg-pa-deploy |
| S_SYSTEMD | systemd Documentation | Web | 08 cfg-pa-deploy |
| S_SRC | AIX SRC（System Resource Controller）Documentation | Web | 08 cfg-pa-deploy |
| S_REGEX_TCL | Tcl 8.x Documentation（Probe rules 構文の祖系） | Web | 03 Rules File, 08 cfg-probe-syslog |
| S_TLS_RFC | RFC 8446（TLS 1.3）/ RFC 5246（TLS 1.2） | Web | 03 SecureMode |
| S_FIPS_140 | NIST FIPS 140-2 Documentation | Web | 03 FIPS, 08 cfg-ssl-objserv |
| S_LDAP | LDAP（OpenLDAP / Microsoft AD）Documentation | Web | 10 out-of-scope（LDAP 統合） |

---

## 参照ポリシー

- **Best Practices Guide v1.3（S_OMN_BP）が中核**：本サイトの推奨パラメータ・推奨設計判断はすべて本書に根拠を置く。
- 公式 Web ドキュメント（IBM Documentation）は **OMNIbus 8.1.0** ベースを優先。8.1.x の Fix Pack 単位の差分は各ドキュメント内の "What's new" セクション参照。
- **本サイトでカバーしない領域**（[10. 対象外項目](10-out-of-scope.md)）はそれぞれの公式ドキュメントへの直接参照を推奨。

## 引用方針

- 本サイトの記述末尾には `S_*` 出典 ID を列挙
- 引用は事実・手順の根拠提示のみ（コピペは Best Practices Guide v1.3 の趣旨と本サイトの趣旨が同じ場合に限り、表現を再構成して掲載）
- 公式ドキュメントの URL は IBM 側の改訂で頻繁に変わるため、本ページでは固定 URL を載せず、上記の出典 ID 名で IBM Documentation 内検索を推奨
