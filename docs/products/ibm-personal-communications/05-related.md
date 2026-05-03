# IBM Personal Communications 15.0 — 関連製品連携

IBM Personal Communications 15.0 — 関連製品連携 / 依存関係

| 連携先製品 | 連携の種類 | 設定要点 | 出典 |
|---|---|---|---|
| z/OS / z/VM 上の TN3270E サーバ (zSeries) | TN3270 / TN3270E 接続 | Type of Host = zSeries、Attachment = Telnet3270 を選択し、 ホスト名 / ポート (23 or 992) / LU 名を指定。TLS/SSL を有効化する場合は Default Certificate Validation を有効のまま使い、必要な CA を .kdb に登録。 Express Logon Feature 利用時は RACF Pass-Ticket / クライアント証明書を整える。 | S32, S36, S37 |
| IBM i / iSeries / System i (5250 ホスト) | Telnet5250 / APPC / iSeries Access 連携 | Telnet5250 over TCP/IP / IPX/SPX、APPC 5250、3270 via iSeries (passthru)。 iSeries Connection Configuration (.ndc)、iSeries User Profile (.upr)、 Data Transfer Request (.tto/.tfr) を保存。iSeries Access が同一 PC に 共存可能（iSeries Access coexistence support）。 | S32, S15 |
| IBM Communications Server for Windows | SNA バックエンドサーバ | 3270 via Communications Server for Windows、APPC、DLUR を利用する場合の SNA ゲートウェイ。SNA Node を Communications Server に委譲し、PCOMM は Microsoft SNA client (LUA / APPC interface)、または APPC over LAN として接続。 | S32 |
| IBM Communications Server SNA API Client | Node Operator Facility 互換 API | NOF API（WinNOF 等）は Communications Server SNA API Client もサポート。 PCOMM 単独で実装される一部 Verb は Communications Server で未対応のため、 「Verbs Supported by Communications Server and Not by Personal Communications」 を確認した上で互換コードを設計。 Querying the Node Verbs（QUERY_*）は SNA Node 構成・運用状態の取得に 広範に用いられる。 | S44, S45, S52, S53, S54 |
| Microsoft SNA Server / Host Integration Server | サードパーティ SNA バックエンド | Microsoft SNA client over FMI、LUA interface、APPC interface の各経由で 3270 セッションをホストに接続。サポート対象外の組合せは Quick Beginnings の 接続表で確認。 | S32 |
| ASCII ホスト (UNIX / Linux / OEM) | VT-over-Telnet / VT-over-Async | VT100/VT220/VT420 対応。SBCS のみ。Tab Setup、ASCII Host Data Transfer、 COM ポートでの VT-over-Async（Hayes AutoSync 等の DLC 経由）にも対応。 | S32 |
| Microsoft Windows Installer (MSI) / InstallShield | インストール基盤 | setup.exe が msiexec.exe を呼び出し、必要に応じて Windows Installer service を自動配備。Initialization (response) File、SAVEINI/ONLYINI/USEINI/REMOVEINI、 UNC パス、Administrative Installation に対応。 | S19, S15 |
| Microsoft schannel (MSCAPI) | TLS/SSL プロバイダ | Default Certificate Validation を担当。署名検証 / チェーン検証を実施。 無効化は推奨されず、ホスト身元検証が外れる旨が文書化されている。 | S37 |
| ODBC / 32-bit ODBC Administrator / Database Access | DB データソース連携 | 32-Bit ODBC Administrator でデータソースを追加、Database Access ユーティリティ から読み取り専用でアクセス。iSeries Data Transfer と組合せた業務データ 集計に利用可能。 | S32 |
| Microsoft Windows プリンタドライバ / PDT | セッション印刷 | Windows Printer Driver と Personal Communications PDT (Printer Definition Table) のいずれかで 3270/5250 印刷出力。5250 は Host Print Transform もサポート。 Truetype APL フォント、IBM 5586-H02（日本のみ）、Konica Minolta PCL 6（日本）等。 | S30 |
| 外部スクリプト / 業務アプリ | EHLLAPI / HACL / ActiveX / DDE 連携 | VBA / Excel マクロ（ActiveX/OLE 2.0）、C++/Java（HACL）、C 言語 （EHLLAPI 32/64-bit）、レガシー（DDE）から PCOMM セッションを操作。 ZipPrint や Object-Oriented API も同等の自動化に利用可能。 | S31, S32, S6 |
| Session Manager Online / HACP Server | プロファイル集中管理 / 自動アップグレード | Web Server から PCOMM の最新インストーラ・FixPack を取得。HACP Server (Config Server) にユーザプロファイルを集中保管。Preferences Manager の Advanced タブまたは InstallShield Wizard で URL / DNS / IP を構成。 | S37 |

