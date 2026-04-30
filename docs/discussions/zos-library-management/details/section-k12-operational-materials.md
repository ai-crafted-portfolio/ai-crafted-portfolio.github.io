# §K-12. 運用資材 — 標準データセット類別 + サイト命名テンプレ

運用資材は IBM 公式命名なし。USER.* / OPS.* / SITE.* が一般的だがサイトごとに独自命名。本ツールは命名規則に依存せず Excel 一覧で個別管理する。

| # | T 番号 | 類別 | 代表的 DSN テンプレ (サイト慣習) | 中身の例 |
|---|---|---|---|---|
| 1 | T31.1 | 業務 JCL | `USER.OPS.JCL` / `SITE.JCL.LIB` / `APP.JCL.*` / `*.PROD.JCL` | 業務日次・月次バッチの実行 JCL。SCM 一次管理が原則 |
| 2 | T31.2 | 運用 JCL (BKUP/RCVR) | `OPS.BKUP.JCL` / `OPS.RCVR.JCL` / `OPS.NIGHT.JCL` / `OPS.MAINT.JCL` | バックアップ・リカバリ・保守用 JCL |
| 3 | T31.3 | REXX exec / ISPF マクロ | `OPS.REXX.LIB` / `SYS3.SBLSCLI0` / `SITE.CLIST` | 運用補助 REXX、ISPF 編集マクロ |
| 4 | T31.4 | ISPF パネル/ダイアログ (RECFM=F) | `SYS3.ISPPLIB` (PANEL) / `SYS3.ISPMLIB` (MSG) / `SYS3.ISPSLIB` (SKEL) / `SYS3.ISPTLIB` (TBL) | PANEL定義(F) は対象、MSG ライブラリ(U) は別管理 (T55) |
| 5 | T31.5 | 運用パラメータファイル | `OPS.PROC.PARM` / `SITE.PARM.LIB` / `OPS.CONFIG.LIB` | 運用 PROC から参照される SYSIN 用パラメータ |
| 6 | T31.6 | SORT カード / IDCAMS | `OPS.SORT.LIB` / `OPS.IDC.CMD` / `SITE.SORT.PARM` | SORT 制御文、IDCAMS DEFINE/REPRO/DELETE スクリプト |
| 7 | T31.7 | アプリ用ライブラリ (テキスト) | `APP.COPYLIB` / `APP.SQLLIB` / `APP.PROC.LIB` | コピーブック・定型 SQL 等。原則 SCM 移管 (T58) |
| 8 | T31.8 | 運用手順書 (テキスト形式) | `OPS.DOC.LIB` / `SITE.MANUAL.LIB` / `OPS.HANDBOOK` | z/OS 上のテキスト手順書。Wiki 一次、本ツールはオフライン参照用 (T59) |
| 9 | T31.9 | 監視・通知定義 | `OPS.MON.LIB` / `SITE.ALERT.LIB` / `SITE.HEALTH.LIB` | 監視ツール定義 (閾値・宛先・文面)。テスト alert で事前検証 (T60) |

!!! note "運用資材 命名の特徴"
    運用資材は IBM 標準命名が存在しない。USER.* / OPS.* / SITE.* が一般的だがサイトごとに完全に独自。本ツールは命名規則に依存せず、対象データセット一覧 (Excel) で個別管理する。

!!! info "§K セクション完了"
    §K-1〜§K-12 で本ツール対象 3 領域 (PARMLIB / PROCLIB / 運用資材) のメンバ・PROC・資材を網羅した。これにより読み手は「どのデータセット / メンバが本ツールで管理されるか」を具体的に把握可能。

---

次ページ → [出典 (IBM 公式マニュアル)](sources.md)
