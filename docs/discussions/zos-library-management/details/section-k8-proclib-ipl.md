# §K-8. PROCLIB 標準 PROC 網羅 (1) — IPL/JES 起動 + 中核

T30.1 のうち IBM 標準 PROC を網羅する。

| # | PROC 名 | 役割 |
|---|---|---|
| 1 | JES2 / JES3 | JES サブシステム本体。バッチ・出力管理の中核 |
| 2 | VTAM | SNA ネットワーク (Virtual Telecommunications Access Method) 主タスク |
| 3 | TCPIP | TCP/IP スタック本体 |
| 4 | RACF | RACF サブシステム (RACF コマンド処理用、オプショナル) |
| 5 | WLM | Workload Manager (システム自動起動) |
| 6 | TRACE | システム トレース |
| 7 | SYSLOG | システム ログ |
| 8 | SMS | DFSMS スタートアップ |
| 9 | DLF | Data Lookaside Facility |
| 10 | LLA | Library Lookaside Address space |
| 11 | VLF | Virtual Lookaside Facility |
| 12 | BPXAS / BPXOINIT / BPXBATCH | USS 関連 (本ツール環境: [SSOT ④](../overview/01-ssot.md) により USS 不在で対象外) |
| 13 | IZUSVR1 / IZUANG1 | z/OSMF (本ツール環境: [SSOT ①](../overview/01-ssot.md) により z/OSMF 不採用で対象外) |

!!! warning "管理運用上の留意点 (T46)"
    JES2/JES3/VTAM/TCPIP 起動失敗は OS 全体の停止に直結。変更前 syntax check + テスト LPAR 実起動テストを必須化すること。

---

次ページ → [§K-9 PROCLIB ネットワーク + TSO 系](section-k9-proclib-network.md)
