# §K-1. PARMLIB 標準メンバ網羅 (1) — IPL/起動制御

T29.1 のメンバを網羅する。

| # | メンバ名 | 役割 |
|---|---|---|
| 1 | LOADxx | IPL ロード制御。NUCLST、SYSPLEX 名、PARMLIB 連結等を指定。LOAD パラメータで選択 |
| 2 | IEASYSxx | システム起動パラメータ。CMD/CMB/CON/CSA/GRS/SMF/SCH 等の他メンバの xx を指定する起点 |
| 3 | IEASYMxx | システムシンボル定義 (`&SYSNAME`, `&SYSPLEX` 等)。SYSDEF/SYMDEF で値設定 |
| 4 | NUCLSTxx | Nucleus inclusion list。IPL 時にロードする nucleus モジュール一覧 |
| 5 | IEAPAKxx | LPA pack list。LPA に積む順序の指定 |
| 6 | IEALPAxx | 動的 LPA。SETPROG 等で動的に LPA 追加するモジュール |
| 7 | IEAFIXxx | Fixed ストレージ。IPL 時に fix するモジュール |
| 8 | LPALSTxx | LPA データセット連結。LINKLIB に類するライブラリ群 |
| 9 | LNKLSTxx | LNKLST 連結 (旧形式)。PROGxx LNKLST 文への移行が推奨 |
| 10 | IEAAPFxx | APF 認可ライブラリ (旧形式)。PROGxx APF 文への移行が推奨 |
| 11 | **PROGxx** | **APF/LNKLST/LPA/Exit 動的更新。最重要メンバ。SETPROG で更新可** |
| 12 | IEABLDxx | Build IPCS。DAE のコレクション定義 |

!!! info "出典"
    z/OS MVS Initialization and Tuning Reference (zOS31_ieae200, S2)

---

次ページ → [§K-2 PARMLIB コンソール/運用](section-k2-parmlib-console.md)
