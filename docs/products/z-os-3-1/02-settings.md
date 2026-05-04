# 設定値一覧

> 掲載：**PARMLIB 19 メンバ + tunable 20**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## PARMLIB メンバ（19 件）

| メンバ | 用途 | 編集者・コマンド | 反映タイミング | 関連手順 | 注意点 |
|---|---|---|---|---|---|
| `LOADxx` | IPL の起点メンバ。IODF / IEASYS suffix / PARMLIB チェーンを定義。 | ISPF EDIT 直接編集（SYS1.IPLPARM または SYS1.PARMLIB） | 次回 IPL 時に LOAD パラメータで指定された xx が読まれる | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) | LOAD パラメータは LPAR の Activation Profile で指定。直接編集の前に必ずバックアップ。 |
| `IEASYSxx` | システム初期化パラメータ集約。SQA, GRSCNF, SCH, CLPA, FIX 等。 | ISPF EDIT | 次回 IPL 時 | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) | LOADxx 内で `SYSPARM=(00,xx)` のように複数 IEASYS をマージ可能。 |
| `IEFSSNxx` | サブシステム定義。JES2, RACF, SMF, OMVS, RRS 等の起動順を制御。 | ISPF EDIT | 次回 IPL 時。動的追加は SETSSI ADD コマンドで可能（一部） | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) | PRIMARY サブシステム（通常 JES2）が最初。順序を間違うと IPL 失敗。 |
| `BPXPRMxx` | USS（OMVS）の構成。MAXASSIZE, MAXFILEPROC, ROOT FS, MOUNT ステートメント等。 | ISPF EDIT | 次回 IPL 時。動的反映は SET OMVS=xx コマンドで部分可能 | [cfg-uss-fs](08-config-procedures.md#cfg-uss-fs) | ROOT FS は zFS 推奨。MAXFILEPROC=64000 等で大きく。 |
| `SMFPRMxx` | SMF 設定。記録対象 type、出力先（SYS / LOGSTREAM）、バッファ。 | ISPF EDIT | SET SMF=xx で動的反映可能 | [cfg-smf-collect](08-config-procedures.md#cfg-smf-collect) | TYPE(...,30,...) でジョブ統計記録。SYS1.MAN1/MAN2/MAN3 を rotation 利用。 |
| `CONSOLxx` | コンソール定義（MCS/EMCS/HARDCOPY/AUTH/ROUTCDE）。 | ISPF EDIT | 次回 IPL 時。動的追加は VARY CN コマンド | [cfg-console-add](08-config-procedures.md#cfg-console-add) | MASTER コンソールの欠如は IPL 失敗の典型原因。 |
| `GRSRNLxx` | GRS Resource Name List。Sysplex 全体で ENQ する RESERVE/SYSTEMS リソース定義。 | ISPF EDIT | SET GRSRNL=xx で動的反映 | [cfg-grs-setup](08-config-procedures.md#cfg-grs-setup) | RESERVE 廃止して SYSTEMS に変換することで Sysplex 性能改善。 |
| `COUPLExx` | Sysplex 構成（XCF/CF/CFRM/SFM）定義。 | ISPF EDIT | 次回 IPL 時。CFRM は SETXCF START で動的活性化 | [cfg-sysplex-define](08-config-procedures.md#cfg-sysplex-define) | CDS（Couple Data Set）の事前作成・容量サイジング必須。 |
| `JES2 INITDECK` | JES2 初期化パラメータ。SPOOLDEF, INITDEF, JOBCLASS, OUTCLASS 等。 | ISPF EDIT（SYS1.PARMLIB or PROCLIB の HASPPARM 相当） | JES2 cold start / warm start。$T で動的変更可能なパラメータあり | [cfg-jes2-init](08-config-procedures.md#cfg-jes2-init) | INITDEF n,CLASS=A 形式。CHKPT/SPOOL volume 定義は warm start 必須項目。 |
| `PROFILE.TCPIP` | TCP/IP の構成。HOME IP、ROUTE、PORT、AUTOLOG 等。 | ISPF EDIT（TCPIP.PROFILE 等のデータセット） | TCPIP STC 再起動 or VARY TCPIP,,OBEYFILE で動的反映 | [cfg-tcpip-profile](08-config-procedures.md#cfg-tcpip-profile) | OBEYFILE で全 PROFILE 再読み込みでなく差分適用も可能。 |
| `VTAMLST` | VTAM の SYS1.VTAMLST 配下メンバ群（ATCSTRxx, ATCCONxx, APPL 等）。 | ISPF EDIT | VARY NET コマンドで動的反映 / VTAM 再起動 | `cfg-vtam-startup` | ATCSTRxx は VTAM start パラメータ、ATCCONxx は connect リスト。 |
| `RACF Database` | RACF プロファイル DB（VSAM）。SYS1.RACF.PRIMARY/BACKUP 等。 | RACF コマンド（ADDUSER, PERMIT 等）/ IRRDBU00 unload | RACF コマンド即時反映 | [cfg-racf-permit](08-config-procedures.md#cfg-racf-permit) | Primary/Backup 二重化必須。Backup は IRRUT200 で同期。 |
| `Master Catalog` | z/OS 起動時の最初のカタログ。SYS1.* 等のシステムデータセット定義と User Catalog への alias を含む独立 VSAM データセット（命名は通常 SYS1.MASTER.ICFCAT 等）。 | IDCAMS（DEFINE / DELETE / DEFINE ALIAS） | 即時（カタログ操作） | [cfg-dataset-mgmt](08-config-procedures.md#cfg-dataset-mgmt) | LOADxx の SYSCAT ステートメントで Master Catalog 名を指定（旧 SYSCATxx メンバ方式は LOADxx に統合済み）。SYS1.NUCLEUS は IPL モジュール格納の PDS であり Master Catalog 自体ではない。Master Catalog 損傷は IPL 失敗の致命傷。 |
| `ACS Routine` | Automatic Class Selection routine。SMS Storage Class/Data Class/MGMT Class/Storage Group の動的割り当てルール。 | ISMF（ISPF メニュー Sx）または ISPF EDIT（SCDS member） | ACTIVATE で SCDS → ACDS 反映、即時有効 | [cfg-sms-class](08-config-procedures.md#cfg-sms-class) | ACS routine は dataset name や JOBNAME パターンで分類。コンパイル必要。 |
| `WLM Service Definition` | WLM ポリシー（Service Class, Workload, Goal）。SCDS（Service Definition Data Set）に保存。 | WLM ISPF アプリケーション | POLICY ACTIVATE で動的反映 | [cfg-wlm-policy](08-config-procedures.md#cfg-wlm-policy) | Goal = Velocity / Response Time / Discretionary。Period でステップ別 goal も可能。 |
| `PROGxx` | Program management（APF, LPA, LNKLST, EXIT）。 | ISPF EDIT | SET PROG=xx で動的反映可能 | [cfg-apf-add](08-config-procedures.md#cfg-apf-add) | APF（Authorized Program Facility）追加で APF authorized library 定義。 |
| `LNKLSTxx` | Link List 定義（旧形式）。新規は PROGxx 内に統合推奨。 | ISPF EDIT | 次回 IPL or LLA REFRESH | [cfg-apf-add](08-config-procedures.md#cfg-apf-add) | LNKLSTxx より PROGxx LNKLST ステートメントが現代的。 |
| `CLOCKxx` | システムクロック・タイムゾーン設定（TIMEZONE / OPERATOR / ETRMODE 等）。 | ISPF EDIT | 次回 IPL 時 | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) | TIMEZONE は GMT からの offset を指定。日本（JST = UTC+9）は `TIMEZONE E.09.00.00`（E = East of GMT）。米国東部標準時は `TIMEZONE W.05.00.00`。OPERATOR PROMPT を NO に設定すると IPL 時の日付確認をスキップ。 |
| `LPALSTxx` | LPA（Link Pack Area）データセット連結定義。 | ISPF EDIT | 次回 IPL（CLPA 必要） | [cfg-clpa-ipl](08-config-procedures.md#cfg-clpa-ipl) | LPALIB に常駐モジュール配置。変更後 CLPA で LPA 再構築要。 |

## チューナブル / パラメータ（20 件）

**種別の凡例**: サイジング = 容量チューニング、モード選択 = 動作モード切替、運用ポリシー = SLA/セキュリティ目標、構成定義 = サブシステム構成、ランタイム = LE 等の実行時設定。

| パラメータ名 | 種別 | 設定コマンド | 既定値 | 取り得る値 | 影響範囲 | 関連手順 | 注意点 |
|---|---|---|---|---|---|---|---|
| `MAXASSIZE` | サイジング | `BPXPRMxx` | 2147483647（≒ 2GB-1） | 0〜2147483647（バイト） | 次回 IPL or SET OMVS=xx で動的反映 | [cfg-uss-fs](08-config-procedures.md#cfg-uss-fs) | USS プロセスの最大 address space サイズ。Java 等の大規模アプリでは 4GB 以上推奨。 |
| `MAXFILEPROC` | サイジング | `BPXPRMxx` | 64000 | 1〜524287 | 次回 IPL or SET OMVS=xx | [cfg-uss-fs](08-config-procedures.md#cfg-uss-fs) | USS プロセスあたりの最大オープンファイル数。Web/DB サーバで増量必要なケース多い。 |
| `MAXTHREADS` | サイジング | `BPXPRMxx` | 200 | 0〜100000 | 次回 IPL or SET OMVS=xx | [cfg-uss-fs](08-config-procedures.md#cfg-uss-fs) | USS プロセスあたりの最大スレッド数。Java application server で増量推奨。 |
| `SMF TYPE` | 構成定義 | `SMFPRMxx の TYPE() オペランド` | サイトにより異なる（典型 0,30,42,70-79,80,89,90,99 等） | 0-255 の任意組み合わせ | SET SMF=xx で動的反映 | [cfg-smf-collect](08-config-procedures.md#cfg-smf-collect) | TYPE 30 = ジョブ統計、80 = RACF、70-79 = RMF、89 = USS、99 = WLM。 |
| `CSAALOC` | サイジング | `IEASYSxx の CSA= オペランド` | サイトにより異なる（例: 256M） | 0M〜2047M | 次回 IPL 時のみ | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) | Common Storage Area サイズ。アプリ要件で増減。 |
| `ECSA` | サイジング | `IEASYSxx の CSA= で 2 番目の値` | サイトにより異なる（例: 1024M） | 0M〜2047M | 次回 IPL 時のみ | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) | Extended CSA。16MB 境界より上の CSA。多くのサブシステム（Db2, CICS）が消費。 |
| `GRSCNF` | モード選択 | `IEASYSxx の GRS= オペランド` | STAR モード（Sysplex 環境の標準値、CF 経由 Lock 構造） | NONE / RING / STAR | 次回 IPL 時のみ | [cfg-grs-setup](08-config-procedures.md#cfg-grs-setup) | Sysplex 環境では STAR 必須。CF を介した Lock 構造で性能向上。 |
| `CLPA` | モード選択 | `IEASYSxx の CLPA` | （指定なし = 既存 LPA キャッシュを再利用、CLPA 指定で再構築） | CLPA 指定 or 不指定 | 次回 IPL 時のみ | [cfg-clpa-ipl](08-config-procedures.md#cfg-clpa-ipl) | LPALIB から LPA 再構築。常駐モジュール変更 / メンテ後に必要。 |
| `JOBCLASS` | 構成定義 | `JES2 INITDECK の JOBCLASS(x)` | サイトにより異なる | JOBCLASS(A)〜JOBCLASS(9) | $T JOBCLASS(x),... で動的変更 | [cfg-jes2-init](08-config-procedures.md#cfg-jes2-init) | クラスごとに優先度・MAXJOBS 等を設定。CLASS=A は通常運用、TSU は TSO 専用。 |
| `INITDEF` | 構成定義 | `JES2 INITDECK の INITDEF` | サイトにより異なる | 1〜100 のイニシエータ数 | JES2 warm/cold start。$S I, $P I で動的開始/停止 | [cfg-jes2-init](08-config-procedures.md#cfg-jes2-init) | INITDEF=10,A,B 等で 10 個のイニシエータを Class A,B 受け持ちで定義。 |
| `SPOOLDEF` | 構成定義 | `JES2 INITDECK の SPOOLDEF` | サイトにより異なる | VOLSER, BUFSIZE 等 | JES2 cold start のみ | `cfg-jes2-spool` | SPOOL volume 追加時は cold start 必要 or $T で hot add（条件あり）。 |
| `WLM Velocity Goal` | 運用ポリシー | `WLM Service Class 定義` | サイトにより異なる | 1〜99（%） | WLM POLICY ACTIVATE で動的 | [cfg-wlm-policy](08-config-procedures.md#cfg-wlm-policy) | Velocity = (CPU using) / (CPU using + delays) %。バッチで 30〜60、STC で 70〜90 が一般的（要 IBM Sizing Guide 確認）。 |
| `WLM Response Time Goal` | 運用ポリシー | `WLM Service Class 定義` | サイトにより異なる | ms / sec | WLM POLICY ACTIVATE | [cfg-wlm-policy](08-config-procedures.md#cfg-wlm-policy) | Average Response Time / Percentile Response Time の 2 種。CICS/IMS 等の対話業務で使用。 |
| `AUTH` | 構成定義 | `CONSOLxx の AUTH() オペランド` | INFO（最小権限。コマンド入力可・システム影響なし） | INFO / SYS / IO / CONS / MASTER | 次回 IPL or VARY CN | [cfg-console-add](08-config-procedures.md#cfg-console-add) | MASTER 権限のコンソールは重要オペレータコマンド発行可能。RACF 連携でユーザ単位制御も可能。 |
| `TCPIP MAXSOCK` | サイジング | `PROFILE.TCPIP の TCPCONFIG MAXSOCK` | TCPIP STC 起動時の値 | 整数 | TCPIP STC 再起動 or VARY TCPIP,,OBEYFILE | [cfg-tcpip-profile](08-config-procedures.md#cfg-tcpip-profile) | 同時オープン socket 上限。Web/Server 用途では大きくする必要あり。 |
| `RACF SETROPTS` | 構成定義 | `SETROPTS コマンド` | サイトポリシーにより異なる | PASSWORD(...) / GENERIC(...) / CLASSACT(...) / AUDIT(...) 等 | 即時 | [cfg-racf-permit](08-config-procedures.md#cfg-racf-permit) | RACF 全体設定変更コマンド。SETR LIST で現状確認。 |
| `PASSWORD INTERVAL` | 運用ポリシー | `RACF SETROPTS PASSWORD(INTERVAL(n))` | サイトポリシーで設定（典型 30/60/90 日） | 1〜254 日 / 0=無期限 | 即時 | [cfg-racf-permit](08-config-procedures.md#cfg-racf-permit) | ユーザパスワード有効期限。組織のセキュリティポリシーに従い設定。 |
| `FUNCTION suffix (LE)` | ランタイム | `CEEPRMxx` | サイトにより異なる | Language Environment runtime options | 次回 IPL or SET CEE=xx |  | LE runtime options（HEAP, STACK, ABTERMENC 等）。COBOL/PL/I/C プログラム実行環境。 |
| `MAXSPACE` | サイジング | `IEASYSxx の MAXSPACE` | 1500M | 100M 〜 | 次回 IPL 時のみ | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) | Aux Storage に書き出される SVC dump の最大サイズ。dump 過大化抑止。 |
| `SCH` | モード選択 | `IEASYSxx の SCH= オペランド` | 00（IEASCH00 メンバを読む。site で複数連結も可） | 00〜99 の suffix 連結 | 次回 IPL 時のみ | [cfg-parmlib-update](08-config-procedures.md#cfg-parmlib-update) | Schedule（スケジュール）情報。IEASCHxx で program properties 定義。 |

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
