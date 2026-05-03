# リンク集

技術領域の公式ドキュメント・コミュニティリソース・学習リソースを、カテゴリごとに整理しています。

**注釈の見方**

- **(英)** : 英語版のみ
- **(日)** : 日本語版のみ
- 注釈なし : 日本語版あり、または UI から日本語切替が可能（章により翻訳率に差がある場合があります）
- ★ : コマンド仕様などの詳細リファレンスとして特に有用

---

## A. IBM メインフレーム / z/OS

### 全般・運用計画

- [z/OS 3.1 Initialization and Tuning Reference (PDF)](https://www.ibm.com/docs/en/SSLTBW_3.1.0/pdf/ieae200_v3r1.pdf) **(英)** — PARMLIB 全メンバの初期化パラメータ syntax
- [z/OS 3.1 Migration (HTML)](https://www.ibm.com/docs/en/zos/3.1.0?topic=migration) — リリース移行時の互換性・廃止機能・移行手順を集約した公式移行ガイド
- [i-Learning IBM Z 研修](https://www.i-learning.jp/service/it/zseries.html) **(日)** — IBM 公式研修パートナー。z/OS 入門〜セキュリティまでの体系コース
- [Qiita: メインフレームタグ](https://qiita.com/tags/メインフレーム) **(日)** — 日本人エンジニアによるメインフレーム関連の日本語技術記事集積
- [iMagazine: メインフレームモダナイゼーション](https://www.imagazine.co.jp/mainframe-modernization/) **(日)** — 国内 IBM 製品系の技術記事を扱う日本語専門メディア

### JES2

- [z/OS 3.1 JES2 Initialization and Tuning Guide (PDF)](https://www.ibm.com/docs/en/SSLTBW_3.1.0/pdf/hasa300_v3r1.pdf) **(英)** — JES2 のシステム初期化処理と性能チューニングの公式ガイド
- [z/OS 3.1 JES2 Commands (PDF)](https://www.ibm.com/docs/en/SSLTBW_3.1.0/pdf/hasa200_v3r1.pdf) **(英)** ★ — JES2 全オペレータコマンド・syntax・例示を網羅したコマンド仕様書

### ISPF / TSO・REXX

- [z/OS 3.1 ISPF Edit and Edit Macros (PDF)](https://www.ibm.com/docs/en/SSLTBW_3.1.0/pdf/f54em00_v3r1.pdf) **(英)** ★ — ISPF Edit の primary commands と Edit Macro の仕様
- [z/OS 3.1 ISPF Messages and Codes (PDF)](https://www.ibm.com/docs/en/SSLTBW_3.1.0/pdf/f54mc00_v3r1.pdf) **(英)** — ISPF が出力するメッセージ・リターンコードの完全リファレンス
- [z/OS 3.1 TSO/E REXX Reference (PDF)](https://www.ibm.com/docs/en/SSLTBW_3.1.0/pdf/ikjc500_v3r1.pdf) **(英)** ★ — REXX 全組み込み関数・命令の言語仕様書

### DFSMSdfp / データセット管理

- [z/OS 3.1 DFSMSdfp Utilities (PDF)](https://www.ibm.com/docs/en/SSLTBW_3.1.0/pdf/idau100_v3r1.pdf) **(英)** ★ — IEBPTPCH / IEHLIST など DFSMSdfp 標準ユーティリティの実行 syntax と例示
- [z/OS 3.1 DFSMS Access Method Services Commands (PDF)](https://www.ibm.com/docs/en/SSLTBW_3.1.0/pdf/idai200_v3r1.pdf) **(英)** ★ — IDCAMS（LISTCAT 等）の全コマンド仕様

### 変更管理

- [z/OS Change Tracker functionality (HTML)](https://www.ibm.com/docs/en/zos/3.1.0?topic=overview-zos-change-tracker-functionality) — z/OS 公式の運用資材変更管理 priced feature の機能仕様（日本語化確認済）

### サブシステム / 関連製品

- [CICS Transaction Server for z/OS 6.x documentation (HTML)](https://www.ibm.com/docs/en/cics-ts/6.x) — z/OS 上のトランザクションサーバ。アプリケーションサーバ機能・トランザクション管理を提供
- [Db2 for z/OS documentation (HTML)](https://www.ibm.com/docs/en/db2-for-zos) — z/OS 上のリレーショナル・データベース管理システム
- [IMS 15.5 documentation (HTML)](https://www.ibm.com/docs/en/ims/15.5.0) — z/OS 上の階層型データベース / トランザクション・マネージャ
- [PSF for z/OS 4.7 documentation (HTML)](https://www.ibm.com/docs/en/psf-for-zos/4.7.0) — Print Services Facility。z/OS の印刷サブシステム
- [z/OS 3.1 全体ドキュメントポータル](https://www.ibm.com/docs/en/zos/3.1.0) — z/OS System Programming 系マニュアル（PARMLIB / PROCLIB / SDSF / RACF 等）の集約ポータル

---

## B. AIX / Power 系

### 公式ドキュメント

- [IBM AIX 7.3 documentation (HTML)](https://www.ibm.com/docs/en/aix/7.3) — IBM 製 UNIX OS「AIX」の公式ドキュメントポータル
- [IBM AIX 7.3 Commands Reference (HTML)](https://www.ibm.com/docs/en/aix/7.3?topic=reference-commands) ★ — AIX 全標準コマンドの syntax・オプション・例示
- [IBM PowerHA SystemMirror 7.2 documentation (HTML)](https://www.ibm.com/docs/en/powerha-aix/7.2) — AIX 上のクラスタ HA ソリューション公式ドキュメント
- [IBM PowerHA SystemMirror Commands Reference (HTML)](https://www.ibm.com/docs/en/powerha-aix/7.2?topic=reference-powerha-systemmirror-commands) ★ — `clmgr` `clstat` `clRGmove` 等の PowerHA 専用コマンド仕様
- [IBM PowerVM / VIOS documentation (HTML)](https://www.ibm.com/docs/en/power9/vios) — Power Systems 上の仮想化レイヤ Virtual I/O Server の公式ドキュメント

### Redbooks

- [Redbook: IBM PowerHA SystemMirror for AIX Cookbook (SG24-7739)](https://www.redbooks.ibm.com/abstracts/sg247739.html) **(英)** — PowerHA 7.2.7 の構築・運用を実例ベースで解説する IBM Redbook
- [Redbook: Guide to IBM PowerHA SystemMirror for AIX 7.1.3 (SG24-8167)](https://www.redbooks.ibm.com/abstracts/sg248167.html) **(英)** — PowerHA 7.1.3 のデプロイモデル別ガイド
- [Redpaper: Deploying PowerHA Solution (REDP-4954)](https://www.redbooks.ibm.com/redpapers/pdfs/redp4954.pdf) **(英)** — PowerHA 導入実装の Redpaper（短編）
- [Redbook: IBM AIX Enhancements and Modernization (SG24-8453)](https://www.redbooks.ibm.com/abstracts/sg248453.html) **(英)** — AIX の機能強化動向とモダナイゼーション戦略を扱う Redbook
- [Redbook: IBM AIX Enterprise Edition System Administration (SG24-7738)](https://www.redbooks.ibm.com/redbooks/pdfs/sg247738.pdf) **(英)** — AIX Enterprise Edition の運用管理を扱う Redbook

---

## C. 監視 / 運用ツール

- [IBM Netcool/OMNIbus 8.1.0 documentation (HTML)](https://www.ibm.com/docs/en/netcoolomnibus/8.1.0) — エンタープライズ向けイベント監視・統合運用基盤の公式ドキュメント
- [IBM Workload Automation documentation (HTML)](https://www.ibm.com/docs/en/workload-automation) — エンタープライズ向けジョブスケジューラ / ワークロード自動化（旧 Tivoli Workload Scheduler）
- [Tivoli Log File Agent 6.3 User's Guide (PDF)](https://www.ibm.com/docs/en/SSTFXA_6.3.0/com.ibm.itm.doc_6.3/logfileagent63_user.pdf) **(英)** — ログファイル監視エージェントの構成・運用ガイド

---

## D. メッセージング

- [IBM MQ 9 documentation (HTML)](https://www.ibm.com/docs/en/ibm-mq/9.0) — エンタープライズメッセージング基盤の公式ドキュメント（z/OS / 分散プラットフォーム両対応）

---

## E. セキュリティ・監査・バックアップ

- [IBM Guardium Data Protection 12 documentation (HTML)](https://www.ibm.com/docs/en/guardium/12.0) — データベース・ファイルアクセス監査の公式ドキュメント
- [Redbook: IBM Security Guardium Key Lifecycle Manager (SG24-8472)](https://www.redbooks.ibm.com/abstracts/sg248472.html) **(英)** — Guardium 暗号鍵管理ソリューションの導入・統合 Redbook
- [Symantec Endpoint Protection — Tech Docs (Broadcom)](https://techdocs.broadcom.com/us/en/symantec-security-software/endpoint-security-and-management/endpoint-protection/all/Related-Documents.html) **(英)** — エンドポイントセキュリティ製品の公式 Tech Docs（Broadcom 配下）
- [ESS REC（特権操作記録ツール）公式 — エンカレッジ・テクノロジ](https://product.et-x.jp/rec6/function/) **(日)** — 国内市販の特権操作記録・証跡管理ツールの製品情報
- [IBM Spectrum Protect 8.1 documentation (HTML)](https://www.ibm.com/docs/en/spectrum-protect/8.1) — エンタープライズバックアップ / リカバリ基盤（現 IBM Storage Protect）の公式ドキュメント

---

## F. 端末・ファイル転送

- [IBM Personal Communications 14.0 documentation (HTML)](https://www.ibm.com/docs/en/personal-communications/14.0.0) — IBM 純正の 3270 / 5250 端末エミュレータ公式ドキュメント
- [PCOMM 14 Quick Beginnings (PDF)](https://www.ibm.com/docs/en/SSEQ5Y_14.0.0/com.ibm.pcomm.doc/books/pdf/quick_beginningsV140.pdf) **(英)** — PCOMM 14.0 のセットアップ・基本操作ガイド（IND$FILE 等のファイル転送機能を含む）
- [IBM Personal Communications 15.0 documentation (HTML)](https://www.ibm.com/docs/en/personal-communications/15.0.0) — PCOMM 15.0（14.0 の後継メジャー）公式ドキュメント

---

## G. Windows Server 2022

- [Microsoft Learn: Windows Server documentation (HTML)](https://learn.microsoft.com/en-us/windows-server/) — Windows Server 全バージョン（2016〜2025）の公式ドキュメントポータル
- [Microsoft Learn: Windows Commands Reference (HTML)](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands) ★ — `cmd` シェルから利用できる Windows 標準コマンドの完全リファレンス

---

## H. PowerShell

- [Microsoft Learn: PowerShell documentation (HTML)](https://learn.microsoft.com/en-us/powershell/) — PowerShell 全般のドキュメントポータル
- [Microsoft Learn: PowerShell Module Reference (HTML)](https://learn.microsoft.com/en-us/powershell/module/) ★ — 全モジュール・全 cmdlet の syntax・パラメータ・例示
- [Microsoft Learn: PowerShell Scripting Overview (HTML)](https://learn.microsoft.com/en-us/powershell/scripting/overview) — PowerShell スクリプティングの全体像（言語・実行環境・推奨パターン）
- [Microsoft Learn: PowerShell Language Specification (HTML)](https://learn.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-01) **(英)** — PowerShell 言語の仕様書（章別構成）

---

## I. AI / LLM 関連

- [Anthropic Claude documentation](https://docs.anthropic.com/en/home) — Claude API 全体ドキュメント。モデル仕様、API リファレンス、Tool use、Claude Code 等を網羅
- [Anthropic Claude support](https://support.anthropic.com/) — Claude 利用全般の FAQ / トラブルシュート（消費者・開発者共通のヘルプセンター）

---

## J. コミュニティ・学習（英語圏）

- [IBM Redbooks 公式](https://www.redbooks.ibm.com/) **(英)** — IBM 製品全般の Redbook / Redpaper を全文検索できる入口
- [IBM Mainframer Community](https://www.ibmmainframer.com/) **(英)** — z/OS 入門〜認定試験対策までを体系化した非公式チュートリアル集
- [IBM TechXchange Community: IBM Z and LinuxOne](https://community.ibm.com/community/user/ibmz-and-linuxone) **(英)** — IBM 公式の Q&A フォーラム。トラブルシュート時の過去スレッド参照に有用
- [Open Mainframe Project (Linux Foundation)](https://www.openmainframeproject.org/) **(英)** — Zowe 等のメインフレーム関連 OSS の本拠地。z/OS モダナイゼーション領域の入口

---

## J2. 日本語コミュニティ・学習リソース

- [i-Learning（アイ・ラーニング）IBM Z 研修](https://www.i-learning.jp/service/it/zseries.html) **(日)** — IBM 公式研修パートナー。z/OS 入門〜セキュリティまでの体系コース
- [Qiita: メインフレームタグ](https://qiita.com/tags/メインフレーム) **(日)** — 日本人エンジニアによる日本語技術記事集積
- [iMagazine: メインフレームモダナイゼーション](https://www.imagazine.co.jp/mainframe-modernization/) **(日)** — 国内 IBM 製品系の技術記事を扱う日本語専門メディア
- [ESS REC（特権操作記録ツール）公式 — エンカレッジ・テクノロジ](https://product.et-x.jp/rec6/function/) **(日)** — 国内市販の特権操作記録・証跡管理ツールの製品情報
