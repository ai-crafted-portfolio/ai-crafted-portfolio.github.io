# IBM Personal Communications 15.0 — 概要

IBM Personal Communications 15.0 — 製品概要

本シートは ChromaDB 投入済みの Personal Communications 15.0 マニュアル （3,387 chunks / 63 sources、4 冊（Quick Beginnings / Install Guide / Host Access Class Library / System Management Programs）の HTML 抽出版） から構造化した製品サマリ。各記述末尾の [SX] は出典 ID（06_出典一覧 を参照）。

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM Personal Communications for Windows, Version 15.0  [S31, S17] | S31, S17 |
| ベンダ | IBM Corporation  [S31] | S31 |
| 製品の役割 | Windows ワークステーション上で稼働する IBM ホスト接続用エミュレータ製品。 3270（zSeries / z/OS / z/VM）、5250（iSeries / System i / IBM i）、 VT（ASCII ホスト）の画面エミュレーションと、SNA / TN3270 / TN5250 / VT-over-Telnet 等の各種接続プロトコル、IND$FILE / Data Transfer による ホスト⇔PC ファイル転送、EHLLAPI / Host Access Class Library (HACL) による 自動化 API を提供する。  [S31, S32, S6] | S31, S32, S6 |
| 想定読者 | IBM ホスト（z/OS / IBM i / ASCII ホスト）に Windows クライアントから接続する 業務システム利用者、PCOMM 配備・運用を担当するシステム管理者、 EHLLAPI / HACL を用いて自動化スクリプトや 3270 アプリ連携を開発する開発者。  [S31, S2, S44] | S31, S2, S44 |
| 提供エミュレーション | 3270（zSeries 用）、5250（iSeries 用）、VT100/VT220/VT420 等（ASCII ホスト用、SBCS のみ）  [S31, S32] | S31, S32 |
| 接続プロトコル | TN3270 / TN3270E、TN5250、VT-over-Telnet（TCP/IP 経由）、SNA（IEEE 802.2 LAN via Communications Server / DLUR）、APPC、APPN、AnyNet SNA over TCP/IP、 Enterprise Extender (HPR over IP)、3270 via iSeries (passthru)、 COM ポート（VT over Async）、X.25、SDLC、Hayes AutoSync 等。  [S32] | S32 |
| 対応 OS（本書の Windows の定義） | Microsoft Windows 7 / 8 / 8.1 / 10、Windows Server 2008 / 2012。 x64 platforms では IBM SNA protocols / DOS EHLLAPI / 16-bit API は非導入。 （注: マニュアル本文上の Windows の定義。実運用時は最新の動作要件を別途確認。）  [S31, S18] | S31, S18 |
| 推奨ハードウェア | Intel Pentium クラス CPU、DVD-ROM 利用可能な機器、VGA 解像度以上の表示、180 MB 以上の固定ディスク空き  [S33] | S33 |
| メモリ要件 | OS / 接続種別 / 同時セッション数 / EHLLAPI / DDE 利用有無で変動。 推奨メモリは Software Product Compatibility Reports を参照する旨が 製品ドキュメントで案内されている。  [S33] | S33 |
| ディスク容量要件 | 最低 180 MB の空きが必要。Personal Communications を Windows ボリューム 以外にインストールしても、Windows ボリュームに最大 180 MB 程度の空きが 別途必要（Windows Installer service の作業領域・Installer DB キャッシュのため）。  [S33, S18] | S33, S18 |
| 既定インストール先 | C:\Program Files\IBM\Personal Communications（x86 OS）、 x64 OS では C:\Program Files (x86)\IBM\Personal Communications。  [S33, S19] | S33, S19 |
| ユーザデータ既定保存先（Application Data） | [UserProfile]\Application Data 選択時: C:\Users\%USERNAME%\AppData\Roaming\IBM\Personal Communications。 All Users 共通選択時: C:\ProgramData\IBM\Personal Communications。  [S33, S19] | S33, S19 |
| 実行ファイル | PCSWS.EXE（セッション起動エンジン、バッチファイル *.BCH を解釈して複数セッション起動）  [S35] | S35 |
| 主要構成ファイル拡張子 | .ws (Workstation Profile) / .acg (SNA Configuration) / .bch (Multiple Sessions batch) / .kmp (Keyboard) / .pmp (Popup Keypad) / .bar (Toolbar) / .mac (Macro) / .mmp (Mouse) / .xlt / .xld (Translation Table) / .cert (Certificate) / .sth (Password Stash) / .kdb (Certificate Mgmt DB) / .srl (File Transfer List) / .ndc (iSeries Connection Config) / .upr (iSeries User Profile) / .tto / .tfr (Data Transfer Request) / .cfg (FTP Client Config)  [S33] | S33 |
| 提供する Programming Interface | EHLLAPI（Emulator High-Level Language API、IBM Standard / WinHLLAPI 互換）、 Host Access Class Library (HACL) C++ クラスライブラリ、 Host Access Class Library Java、Host Access Beans for Java、 Object-Oriented (OO) API、ActiveX/OLE 2.0 オートメーション、 DDE (Dynamic Data Exchange)、SNA Node Operator Facility (NOF) API。  [S31, S32, S3, S6, S44] | S31, S32, S3, S6, S44 |
| ファイル転送機能 | 3270 ホスト向け IND$FILE（Send/Receive、ASCII / BINARY / CRLF / NOSO 等オプション）、 5250 ホスト向け Data Transfer（DT、別系統で *.tto/*.tfr 転送リクエスト保存）、 ASCII Host Data Transfer、Personal Communications FTP Client。 ZipPrint（3270 のみ）でホスト画面・PROFS / OfficeVision / CMS / XEDIT 文書の印刷も可。  [S30, S36, S37] | S30, S36, S37 |
| 高可用・運用機能 | Load Balancing（ワイルドカード Server Name / Service Name + LU プール）、 Hot Standby（active server 障害時のバックアップサーバ自動再接続、IBMSLP.DLL 必須）、 Express Logon Feature、Session Manager Online、Auto-Reconnect。  [S39] | S39 |
| ドキュメント形態（本 RAG への投入分） | IBM Docs（Personal Communications 15.0.0 ツリー）の HTML から抽出した英語版 4 マニュアル × 計 63 ファイル（QB 13 / IG 15 / HACL 14 / SMP 21）。 ChromaDB 投入チャンク数は 3,387。  [S30, S15, S1, S43] | S30, S15, S1, S43 |

