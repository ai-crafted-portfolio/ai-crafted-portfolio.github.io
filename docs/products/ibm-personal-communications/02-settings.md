# IBM Personal Communications 15.0 — 主要設定項目

IBM Personal Communications 15.0 — 主要設定項目

Workstation Profile (.ws) / Keyboard (.kmp) / Color / SSL/TLS / IND$FILE 転送 オプション等。値の単位や許容値はマニュアル本体（QB / IG / HACL）を参照。

| パラメータ名 | 設定ファイル / 設定経路 | 既定値 / 推奨値 | 取り得る値 | 影響範囲 | 関連パラメータ | 出典 |
|---|---|---|---|---|---|---|
| セッション種別 (Type of Host) | Workstation Profile (.ws) / Configure → Customize Communication | — | 3270 / 5250 / ASCII (VT) | セッション全体・以降の設定項目 | Attachment, Host Code Page | S34 |
| Attachment / Interface | .ws / Configure | — | LAN (IEEE 802.2) / Telnet3270 / Telnet5250 over TCP/IP / VT-over-Telnet / APPC 3270 via LAN / DLUR / SNA Node / X.25 / SDLC / Hayes AutoSync 等 | セッションの物理／論理接続方式 | SNA Node 設定 (.acg) | S32 |
| Host / Port / LU Name (or Workstation Id) | .ws / Quick Connect bar | — | ホスト名 (DNS or IP)、TCP ポート、TN3270E LU 名 / 5250 WS Id | Telnet セッション接続先 | Quick Connect bar | S36 |
| Host Code Page (Session Parameters) | .ws / Configure → Session Parameters | ホスト・地域に依存（例: 1390/1399、420 Arabic） | EBCDIC コードページ番号 | セッション内の文字コード | Font, NLS | S34, S30 |
| Font (Display) | .ws / Settings → Appearance → Font | Automatic Sizing | Automatic Sizing / Fixed Size + face name (例: ARB3270, HEB3270) | セッションウィンドウ表示 | Host Code Page | S34 |
| Keyboard 配列 (.kmp) | .kmp / Settings → Keyboard / Settings → Keyboard Setup | — | Personal Communications 提供のレイアウト（Arabic Speaking 等）または .kmp ファイルでカスタマイズ | セッション内のキー割当 | Hotspot, Macro | S33, S34 |
| Popup Keypad (.pmp) | .pmp / Settings → Pop-Up Keypad Setup | — | ボタン定義（キー / マクロ / ホスト関数の割当） | セッション内のポップアップキーパッド | Keyboard, Mouse | S30, S33 |
| Toolbar (.bar) | .bar / Settings → Tool Bar Setup | — | ツールバー項目定義（マクロ / メニュー / 内蔵関数） | セッションウィンドウ上部 | Macro | S33 |
| Hotspot 定義 | .ws / Settings → Hotspot Setup | ホストキーワード（PF1〜PF24 等）が既定でアクティブ | Hotspot 文字列と動作（キー送信 / マクロ / コマンド） | セッション内のダブルクリック動作 | Mouse | S36 |
| Macro / Script (.mac) | .mac / Appearance → Macro/Script | — | キー操作・コマンド・条件分岐の手順記述 | セッションへの自動入力 | Express Logon, Toolbar, Keyboard | S36 |
| TLS/SSL 有効化 | .ws / Configure → Session Parameters → Security | 無効 | Telnet / TN3270 / TN5250 / VT-over-Telnet で有効化可 | セッションの暗号化 | 証明書 (.cert), .kdb, .sth | S37 |
| Default Certificate Validation | .ws / セキュリティ詳細設定（schannel / MSCAPI 利用時） | 有効（Default は enable） | enable / disable | SSL/TLS handshake 中の証明書検証 | Certificate Management (.kdb) | S37 |
| 証明書管理 (.kdb / .sth / .cert) | Certificate Management ユーティリティ | — | サーバ証明書 / クライアント証明書 / 中間 CA、stash パスワード | TLS/SSL 認証情報の永続化 | TLS/SSL | S33 |
| IND$FILE 転送オプション (3270) | Send/Receive ダイアログ / .srl (File Transfer List) | ASCII（テキスト）/ BINARY | ASCII / BINARY、CRLF、NOSO、recfm / lrecl / blksize / space (CMS/TSO/CICS) 等 | ファイル転送の挙動 | 3270 セッション | S36 |
| Data Transfer Request (5250) | .tto (Receive) / .tfr (Send) | — | ライブラリ／ファイル名／メンバー、データ形式変換、フォーマット定義 | iSeries との 5250 データ転送 | iSeries User Profile (.upr) | S33 |
| Application Data Location | InstallShield (Application Data Location dialog) | [UserProfile]\Application Data（既定推奨） | [UserProfile]\Application Data / All Users\Application Data | ユーザ／全ユーザいずれにプロファイル保存するか | User-Class Directory | S19, S23, S33 |
| Automatic Migration Options | InstallShield (Automatic Migration Options dialog) | Automatic Migration of Profiles = チェック ON | ON / OFF + Migration Level（V6.0 / V14.0 等から） | 旧版 PCOMM プロファイル・SNA 構成・バッチの自動移行 | Application Data Location | S19 |
| Initialization (response) File | .iss / .ini （SAVEINI / ONLYINI / USEINI / REMOVEINI） | — | InstallShield パラメータ群、UNC パス、システム変数を含む | サイレント・カスタムインストール | Silent Install | S15, S16, S20, S21, S27 |
| HACP Server / Web Server Details | Preferences Manager → Advanced タブ または InstallShield Wizard | — | DNS 名 / IP（Config Server）、URL（Web Server） | Session Manager Online のプロファイル取得 / 自動アップグレード元 | Session Manager Online | S37 |
| PCSWS.EXE コマンドラインオプション | PCSWS.EXE *.bch / 直接起動 | — | /V=myview（ビュー指定）等。バッチでは外部アプリ起動文字列も記述可 | セッション起動方式 | Multiple Sessions, .bch | S35 |
| pcomstop suppress confirmation | Preferences / レジストリ設定 | 確認メッセージ表示 | ON（抑制）/ OFF | セッション停止時の確認ダイアログ | Session Stop | S30 |
| Power Management 動作 | .ws / Preferences → Standby/Hibernate | Connected State 監視 ON | Connected / Non-Connected / Critical Sleep の制御切替 | Sleep/Hibernate 時のセッション維持 | OS 電源イベント | S36 |
| NLS / Language Pack | InstallShield (Language pack considerations) | OS ロケール準拠 | 国別 NLS 略号（Appendix C 参照） | メッセージ・ヘルプ言語 / フォント | Code Page | S15, S24, S28 |

