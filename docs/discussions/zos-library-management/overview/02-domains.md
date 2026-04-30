# 全体観: z/OS のライブラリは 6 領域に分かれる

本ツールの管理対象は 3 領域 (PARMLIB / PROCLIB / 運用資材)、対象外は 3 領域。

---

z/OS のライブラリは、所有者と公式管理体系で 6 領域に分けて整理できる。本ツールが対象とするのは 3 領域 (システム制御 PARMLIB / システムプロシージャ PROCLIB / 運用資材)。残り 3 領域 (IBM 保守 / アプリ実行 / アプリソース) は SMP/E や SCM 等の既存公式体系があるため対象外。

| 領域名 (本資料分類) | 所有者 | 公式管理体系 | 本ツール扱い | 代表的なファイル |
|---|---|---|---|---|
| IBM 保守領域 | OS 担当 | SMP/E | 対象外 | IPL コア (SYS1.NUCLEUS 等) |
| **システム制御領域** | **OS 担当** | **運用ルール** | **★本ツール対象★** | **PARMLIB (IEASYSxx, SMFPRMxx, COMMNDxx 等)** |
| **システムプロシージャ領域** | **OS 担当** | **運用ルール** | **★本ツール対象★** | **SYS1.PROCLIB / USER.PROCLIB (JES2/VTAM/TCPIP/CICS/Db2 PROC 等)** |
| アプリ実行領域 | アプリ部門 | SCM + リリース手順 | 対象外 | USER.LOADLIB (RECFM=U バイナリ) |
| アプリソース領域 | アプリ部門 | SCLM/Endevor/Git | 対象外 | アプリソース、JCL |
| **運用資材領域** | **運用部門** | **(公式の体系なし)** | **★本ツール対象★** | **運用 JCL/REXX/PROC、運用パラメータ等** |

---

!!! info "領域名について"
    「IBM 保守領域」「運用資材領域」等のラベルは本資料独自の整理であり、IBM 公式分類ではない。所有者軸で本資料が便宜的に整理したもの。詳細は [§I 用語集](../details/section-i-glossary.md) を参照。

---

## 本ツール対象データセット 一覧 (DSN レベル網羅)

ツール対象 3 領域それぞれで考えられる DSN を IBM 標準命名 + サイト慣習命名で網羅する。詳細メンバ網羅は §K-1〜§K-12 を参照。

| # | 領域 | 代表的 DSN (IBM 標準 + サイト慣習) | 備考 / 参照先 |
|---|---|---|---|
| L1 | システム制御領域 (PARMLIB) | `SYS1.PARMLIB` (IBM 標準) / `SYS2.PARMLIB` / `SYSP.PARMLIB` / `USER.PARMLIB` / `SITE.PARMLIB` / `OPS.PARMLIB` | PARMLIB 連結は LOADxx で定義。詳細メンバ網羅は [§K-1〜§K-7](../details/section-k1-parmlib-ipl.md) |
| L2 | システムプロシージャ領域 (PROCLIB) | `SYS1.PROCLIB` (IBM 標準) / `SYS2.PROCLIB` / `USER.PROCLIB` / `OPS.PROCLIB` / `SITE.PROCLIB` | JES2 起動時の PROCLIB 連結。詳細 PROC 網羅は [§K-8〜§K-11](../details/section-k8-proclib-ipl.md) |
| L3.1 | 運用資材 — 業務 JCL (T31.1) | `USER.OPS.JCL` / `SITE.JCL.LIB` / `APP.JCL.*` / 部門別 `*.PROD.JCL` 等 (サイト固有) | SCM との境界整理 (T52) |
| L3.2 | 運用資材 — 運用 JCL (T31.2) | `OPS.BKUP.JCL` / `OPS.RCVR.JCL` / `OPS.NIGHT.JCL` / `OPS.MAINT.JCL` (サイト固有) | 緊急変更フロー (T49) |
| L3.3 | 運用資材 — REXX/ISPF (T31.3, T31.4) | `OPS.REXX.LIB` / `SYS3.SBLSCLI0` / `SYS3.ISPPLIB` / `SYS3.ISPMLIB` / `SYS3.ISPSLIB` / `SYS3.ISPTLIB` | RECFM=F のみ対象 (RECFM=U は対象外) |
| L3.4 | 運用資材 — パラメータ / SORT・IDCAMS (T31.5, T31.6) | `OPS.PROC.PARM` / `SITE.PARM.LIB` / `OPS.SORT.LIB` / `OPS.IDC.CMD` | テンプレ + パラメータ分離管理 (T57) |
| L3.5 | 運用資材 — アプリ用ライブラリ (T31.7) | `APP.COPYLIB` / `APP.SQLLIB` / `APP.PROC.LIB` (サイト固有) | 原則 SCM 移管 (T58) |
| L3.6 | 運用資材 — 手順書 / 監視・通知 (T31.8, T31.9) | `OPS.DOC.LIB` / `SITE.MANUAL.LIB` / `OPS.MON.LIB` / `SITE.ALERT.LIB` / `SITE.HEALTH.LIB` | Wiki と本ツールの同期 (T59)。詳細 [§K-12](../details/section-k12-operational-materials.md) |

!!! note "命名はサイト依存"
    標準は `SYS1.*` / 運用は `USER.*`, `OPS.*`, `SITE.*` / アプリは `APP.*`, `USR.*` 等の独自命名が一般的。本ツールは命名に依存せず、対象データセット一覧 (Excel) で個別に管理する。

---

次ページ → [運用資材領域には公式の管理体系が無い](03-existing-tools.md)
