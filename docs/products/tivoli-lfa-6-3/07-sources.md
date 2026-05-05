# 出典一覧

> 本サイトで参照する公式マニュアル・PDF・補完資料の出典 ID 表。**24 件**（IBM Docs / User's Guide PDF 7 + ITM 6.3 関連 9 + Netcool 連携 5 + 横断補完 3）。

## 出典 ID 命名規則

- `S1`-`S7`：Tivoli Log File Agent 6.3 の中核公式ドキュメント（User's Guide / Install / Admin / Release Notes / Fix Pack ドキュメント）
- `S_ITM_*`：IBM Tivoli Monitoring 6.3 本体側（TEMS / TEPS / 共通エージェント運用）
- `S_NCO_*`：Netcool/OMNIbus 連携（EIF Probe / Best Practices Guide）
- `S_RB_*` / `S_RP_*`：Redbook / Redpaper（補完）
- `S_*_RFC`：横断技術（Regex / Syslog RFC 等）

## LFA 中核（S1-S7）

| 出典 ID | ドキュメント名 | 形態 | 主に参照する章 |
|---|---|---|---|
| **S1** | IBM Tivoli Monitoring 6.3 / Log File Agent — IBM Documentation トピック群 | Web | index, 03 用語集, 06 マニュアル参照マップ |
| **S2** | IBM Tivoli Monitoring 6.3 / Installation and Setup Guide — Log File Agent 章 | PDF / Web | 09 cfg-agent-install, 09 cfg-tems-connect |
| **S3** | Tivoli Log File Agent Version 6.3 User's Guide（SC14-7484-04、2011-2013） | PDF（公式） | 全章（中核出典）。`.conf` / `.fmt` 構文・属性グループ・サブノード・EIF 設定の根拠 |
| S4 | IBM Tivoli Monitoring 6.3 / Administrator's Guide — Log File Agent 関連章 | PDF / Web | 09 cfg-agent-config-itmcmd, 09 cfg-trace-ras1 |
| S5 | IBM Tivoli Monitoring 6.3 / Troubleshooting Guide — Log File Agent 章 | PDF | 06 トラブル早見表, 10 障害対応手順 |
| S_IF04 | Tivoli Log File Agent 6.3.0 Interim Fix 04（6.3.0-TIV-ITM_LFA-IF0004） | IBM Support Tech Note | 09 cfg-agent-install（パッチ適用ライン） |
| S_TN_BASIC | IBM Tech Note：「How to install IBM Tivoli Log File Agent V6.3 and do basic configuration to receive data in TEP?」 | IBM Support | 09 cfg-tems-connect, 09 cfg-conf-create |

## ITM 6.3 本体（S_ITM_*）

| 出典 ID | ドキュメント名 | 形態 | 主に参照する章 |
|---|---|---|---|
| S_ITM_INSTALL | IBM Tivoli Monitoring 6.3 / Installation and Setup Guide | PDF | 09 cfg-agent-install |
| S_ITM_CMD | IBM Tivoli Monitoring 6.3 / Command Reference（itmcmd / tacmd 一覧） | PDF | 02 コマンド一覧 |
| S_ITM_ADMIN | IBM Tivoli Monitoring 6.3 / Administrator's Guide | PDF | 09 cfg-tep-situation, 09 cfg-tep-workspace |
| S_ITM_TROUBLE | IBM Tivoli Monitoring 6.3 / Troubleshooting Guide | PDF | 10 inc-tems-conn-fail, 10 inc-tep-no-data |
| S_ITM_AGENT | IBM Tivoli Monitoring 6.3 / Agent Builder User's Guide | PDF | 11 対象外（カスタム Agent Builder 領域） |
| S_ITM_DPLY | IBM Tivoli Monitoring 6.3 / Remote Deploy（Agent depot / tacmd addBundles） | Web | 09 cfg-tacmd-deploy |
| S_ITM_HD | IBM Tivoli Monitoring 6.3 / Historical Data Collection Guide | PDF | 09 cfg-tep-workspace（History 設定） |
| S_ITM_AGT_TRC | IBM Tech Note：「Agent trace logs」（KBB_RAS1 / RAS1 unit 一覧） | IBM Support | 09 cfg-trace-ras1, 10 inc-disk-fill-trace |
| S_ITM_LINUX_TS | IBM Tivoli Monitoring 6.3 FP2 Linux OS Agent Troubleshooting Guide（共通技法） | PDF | 10 障害対応手順 |

## Netcool / EIF 連携（S_NCO_*）

| 出典 ID | ドキュメント名 | 形態 | 主に参照する章 |
|---|---|---|---|
| S_NCO_EIF | Netcool/OMNIbus 8.1 — Probe for Tivoli EIF（`nco_p_tivoli_eif`）リファレンス | Web | 09 cfg-eif-target, 10 inc-eif-not-delivered |
| S_NCO_BP | Netcool/OMNIbus Best Practices Guide v1.3（IBM 公式 PDF、198p） | PDF | 09 cfg-eif-target（受信側設計） |
| S_NCO_RULES | Netcool/OMNIbus 8.1 — `tivoli_eif.rules` / `eif_default.rules` サンプル | Web | 09 cfg-eif-target |
| S_NCO_INTEG | IBM Tivoli Monitoring と Netcool/OMNIbus の統合ガイド | PDF / Web | 12 scn-eif-to-netcool |
| S_NCO_OMN_LFA | 本サイト：[Netcool/OMNIbus 8.1](../netcool-omnibus-8-1/) | 本サイト内部 | 12 scn-eif-to-netcool |

## 補完（横断技術 / 関連）

| 出典 ID | ドキュメント名 | 形態 | 主に参照する章 |
|---|---|---|---|
| S_RB_LFA | IBM Redbook：「IBM Tivoli Monitoring Implementation」関連章（LFA 含む） | Redbook（PDF） | 12 scn-tep-monitoring（補完） |
| S_PCRE_RFC | PCRE / POSIX Regex の挙動差（greedy / non-greedy / look-ahead） | Web | 03 用語集, 09 cfg-fmt-create |
| S_SYSLOG_RFC | RFC 5424（Syslog Protocol） | Web | 09 cfg-conf-create（syslog 監視時） |

---

## 参照ポリシー

- **Tivoli Log File Agent Version 6.3 User's Guide（S3）が中核**：本サイトの `.conf` / `.fmt` の構文・既定値・属性グループ等の記述はすべて S3 の章番号に対応する事実を根拠としている。
- **IBM Docs（S1）は SPA 化で個別ページの plain HTML 取得が困難**：本サイトでは IBM Docs の topic ID のみ参照し、内容根拠は S3（PDF 版）を主とする。
- **Netcool 側（S_NCO_*）との連携は本サイトの [Netcool/OMNIbus 8.1](../netcool-omnibus-8-1/) と双方向リンク**。LFA 側は EIF 送信、Netcool 側は EIF Probe での受信、`tivoli_eif.rules` で alerts.status 整形までを 2 ページにまたがって解説。
- **本サイトでカバーしない領域**（[11. 対象外項目](10-out-of-scope.md)）はそれぞれの公式ドキュメントへの直接参照を推奨。

## 引用方針

- 本サイトの記述末尾には `S*` 出典 ID を列挙
- 引用は事実・手順の根拠提示のみ（コピペは原則行わず、IBM Docs / User's Guide の趣旨を再構成して掲載）
- 公式ドキュメントの URL は IBM 側の改訂で頻繁に変わるため、本ページでは固定 URL を載せず、上記の出典 ID とトピック名で IBM Documentation 内検索を推奨

---

*v1 では LFA 6.3 の中核ドキュメントを ChromaDB の `manual_docs` collection 投入対象とし、`mcp__education-rag__search_manual` から横断検索可能にする方針（HNSW 再構築後）。投入用スクリプトはリポジトリルートの `ingest_tivoli_lfa.py` 系（v2 以降で整備）を参照。*
