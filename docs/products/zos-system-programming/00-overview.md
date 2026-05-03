# z/OS システムプログラミング (ABCs) — 概要

z/OS System Programming — ABCs Redbooks シリーズ概要

本シートは ChromaDB 投入済みの "ABCs of z/OS System Programming" Redbooks 13 巻 （20,596 chunks / 13 sources, SG24-6981〜6990 + SG24-6327 + SG24-7621 + SG24-7622） を Sysprog 教材観点で構造化したサマリ。各記述末尾の [SX] は出典 ID（06_出典一覧 を参照）。 別途進行中の z/OS 3.1 公式マニュアル（IBM Docs Web / SA22-/SC23- 系）構造化タスクとは 役割を分担し、本ファイルは ABCs シリーズの「教材としての構成」のみを扱う。

| 項目 | 内容 | 出典 |
|---|---|---|
| シリーズ名 | ABCs of z/OS System Programming (IBM Redbooks)  [S1, S2] | S1, S2 |
| 発行元 | International Technical Support Organization (ITSO), IBM Redbooks  [S1, S10] | S1, S10 |
| 巻数 | 全 13 巻（Vol 1 〜 Vol 13）。Vol 13 は ABCs シリーズではなく Rational ALM Redbook が混在（後述）。  [S1, S13] | S1, S13 |
| 発行年レンジ | 2008 年（Vol 7/12/13 初版）〜 2018 年（Vol 3 第5版・Vol 10 第6版）。Vol によって改訂サイクル・最新性が異なる。  [S3, S7, S10] | S3, S7, S10 |
| 想定読者 | 新任〜中級の z/OS System Programmer（システム管理者、SMP/E 担当、 パフォーマンス・キャパシティ担当、セキュリティ管理者、UNIX SS 担当）。 Vol 1 で Sysprog 業務全体像を理解した上で、業務領域別に Vol 2〜12 を辿る学習動線を想定。  [S1, S2] | S1, S2 |
| 本シリーズの位置付け | 公式マニュアル（z/OS Library, SA22-/SC23-/SC24-）が機能網羅型のリファレンスであるのに対し、 ABCs シリーズは「Sysprog が日常業務で必要となる主題」を業務領域単位に分冊した チュートリアル兼サマリ。各巻は概念→GUI/CLI 例→運用ベストプラクティスの順で構成され、 公式マニュアルへの導線を提供する役割を担う。  [S1, S2, S8] | S1, S2, S8 |
| 対象 z/OS バージョン | 各巻の発行時点で当時の最新 z/OS（V1.13 〜 V2.3 程度）。Vol 1 (2017) が z/OS V2.2/V2.3、 Vol 3 (2018) が z/OS V2.3、Vol 10 (2018) が z14 ハードウェアまでカバー。 後発の z/OS V2.4/V2.5/V3.1 固有機能（例: AKM, zCX 強化, R5 RACF 機能等）は本シリーズ外。  [S1, S3, S10] | S1, S3, S10 |
| 全巻の総文書量 | ChromaDB 投入時のチャンク数 = 20,596 chunks / 13 sources。1 巻あたり平均 ≒ 1,580 chunks。  [S1] | S1 |
| 言語 | 全巻 英語版 (en) のみ。日本語版は本 ChromaDB には登録なし。  [S1] | S1 |
| 推奨読書順 | Sysprog 入門者は Vol 1 → Vol 10（z/Architecture 基礎）→ Vol 2（実装・保守）の順で 基盤を作り、その後 業務に応じて Vol 3 (DFSMS) / Vol 4 (Comm) / Vol 5 (Sysplex) / Vol 6 (Security) / Vol 9 (USS) / Vol 11+12 (WLM/RMF) に分岐する流れを推奨。 Vol 8（障害診断）は他巻と並行して常時参照する位置付け。  [S1, S2, S8, S10] | S1, S2, S8, S10 |
| Vol 13 の PDF 内容不一致 | ファイル名は ABCs_Vol13_SDSF となっているが、PDF 中身は SG24-7622-00 "Collaborative Application Lifecycle Management with IBM Rational Products" (December 2008 / 著者: Mats Göthe ほか) であり、JES2/JES3 SDSF を扱う Redbook ではない。 ABCs シリーズで SDSF を学ぶ場合は Vol 1 Ch3 (TSO/E, ISPF, JCL, and SDSF) と Vol 8 Ch9 (SDSF and RMF) を参照する必要がある。本 ChromaDB の topic メタデータ ("Vol.13 - JES2/JES3 SDSF") も乖離しているため要訂正。  [S13, S1, S8] | S13, S1, S8 |
| z/OS 3.1 タスクとの棲み分け | z/OS 3.1 の機能・パラメータの網羅は別タスク（z/OS 3.1 公式マニュアル構造化）が 担当。本ファイルは「ABCs での扱い方・教材としての位置」までに記述を絞り、 IEASYSxx の各 keyword 詳細や RACF Profile の項目網羅、TCP/IP プロファイル 全 statement 一覧などには踏み込まない。  [S1, S2] | S1, S2 |
| 教材としての強み | (1) 業務単位の章立て（Sysprog の朝のチェック、PTF 適用、ダンプ採取の流れ等）、 (2) ISPF/SDSF パネルのスクリーンショットつき手順、 (3) JCL/PROC 例の即実行可能サンプル、 (4) Vol 横断の用語の同義性整理（例: GRS と GRS Star、JES2 と JES3 の対比）、 (5) 公式マニュアル参照 ID（SA22-/SC23-）への明示リンク。  [S1, S2, S5] | S1, S2, S5 |
| 教材としての弱み・古さ | 初版が 2008-2011 年の巻（Vol 4/5/7/9/11/12/13）は z/OS V2.x 後半以降の機能更新が 反映されていない。最新の Sysplex 機能（CFCC レベル、CF Encryption）、TCP/IP の Stateful AT-TLS、RACF のパスワードハッシュ強化（SC256→KDFAES）、PKI Services の REST API 化などは本シリーズ外で公式マニュアルを参照する必要がある。  [S4, S5, S6, S9] | S4, S5, S6, S9 |
| 本ファイルの抽出方針 | 各巻の章構成（Chapter X の見出し）を ChromaDB chunk から直接抽出。 表紙・edition 情報は PDF 先頭の chunk から取得。Vol 13 の内容不一致のように ラベルと実体に乖離がある場合は 事実に即して訂正記述する。  [S1, S13] | S1, S13 |

