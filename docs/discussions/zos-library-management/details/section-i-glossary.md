# §I. 用語集

本資料の独自整理ラベルと公式用語。

---

| 用語 | 区分 | 意味 |
|---|---|---|
| IBM 保守領域 | 本資料独自 | IPL コア (SYS1.NUCLEUS 等)。IBM 公式分類ではないが、所有者軸での整理 |
| システム制御領域 | 本資料独自 | PARMLIB のシステム系メンバ |
| システムプロシージャ領域 | 本資料独自 | SYS1.PROCLIB の標準 PROC |
| アプリ実行領域 | 本資料独自 | USER.LOADLIB 等のロードモジュール |
| アプリソース領域 | 本資料独自 | アプリ部門の SOURCE / JCL |
| 運用資材領域 | 本資料独自 | 運用部門が直接編集する JCL / REXX / PROC、運用所管 PARMLIB メンバ |
| PDS / PDSE | z/OS 公式 | Partitioned Data Set。区分データセット。メンバ単位で読み書き可 |
| RECFM=U | z/OS 公式 | 不定長レコード形式。ロードモジュールが代表例 |
| IND$FILE | z/OS 公式 / PCOMM | 3270 端末経由のファイル転送機能 |
| PCOMM | IBM 製品名 | IBM Personal Communications。3270 エミュレータ |
| SMP/E | z/OS 公式 | System Modification Program/Extended。IBM 製品保守の標準ツール |
| RACF / SMF | z/OS 公式 | Resource Access Control Facility / System Management Facility |
| Change Tracker | IBM 製品 | z/OS V2R5+ の運用資材変更管理 priced feature |

---

次ページ → [出典一覧](sources.md)
