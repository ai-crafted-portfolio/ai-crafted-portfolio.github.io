# IBM Personal Communications 15.0 — トラブルシュート

IBM Personal Communications 15.0 — トラブルシュート（既知の問題と対処）

| 症状 | 原因 | 対処手順 | 関連ログ・コマンド | 出典 |
|---|---|---|---|---|
| Telnet3270 / Telnet5250 でホスト接続できない (timeout) | ホスト名 / Port / ファイアウォール / TLS 設定不一致 | 1) コマンドプロンプトで `telnet <host> <port>` で疎通確認<br>2) Configure → Session Parameters でホスト名 / Port (23 / 992 / 8023 等) を確認<br>3) Trace Facility で TCP/IP トレースを取得<br>4) Information Bundler で診断データ収集 | Trace Facility, Information Bundler, Log Viewer | S32, S34 |
| TLS/SSL handshake が失敗する | サーバ証明書チェーン不正 / schannel が信頼できない CA / 期限切れ証明書 | 1) サーバ証明書を openssl s_client や ブラウザで取得 → CA チェーンを確認<br>2) Certificate Management で .kdb に必要な中間 CA / ルート CA を追加し .sth を更新<br>3) Default Certificate Validation を無効化しない（推奨設定のままにする）<br>4) Windows 証明書ストア (schannel) の場合はルート CA がインストール済か確認 | Certificate Management, .kdb, .sth, Trace | S37 |
| 3270/5250 画面で文字化け（日本語・Bidi） | Host Code Page / PC コードページの不整合、フォント未一致 | 1) Configure → Session Parameters → Host Code Page を業務 EBCDIC ページ（例: 1390/1399、420 Arabic、424 Hebrew）に合わせる<br>2) Settings → Appearance → Font で言語別フォント (ARB3270 / HEB3270 / 日本語フォント) を選択<br>3) DDE/EHLLAPI の PC code page も Settings → API から整合させる<br>4) DBCS IME Auto-Start Switch（DBCS のみ）を有効化 | Session Parameters, Font, NLS | S34, S30 |
| IND$FILE 転送でテキストが破損する | BINARY ファイルを ASCII で転送、または CRLF / NOSO 設定誤り | 1) 転送タイプ (ASCII / BINARY) を再確認<br>2) BINARY 転送時は CRLF を付けない<br>3) ホスト側 lrecl / recfm / blksize を確認<br>4) DBCS の場合は NOSO 不要、SBCS+DBCS 混在は要マニュアル確認<br>5) .srl にテンプレートを保存し条件を固定化 | Send/Receive ダイアログ, .srl | S36, S37 |
| EHLLAPI / DDE が x64 Windows で動かない | x64 Edition では DOS EHLLAPI と 16-bit API が非導入 | 1) アプリが 16-bit / DOS EHLLAPI に依存していないか確認<br>2) 32-bit / 64-bit EHLLAPI へ移植<br>3) 旧 IBM SNA protocols が必要なら SNA 構成は別系（Communications Server 等）に分離 | EHLLAPI 32/64-bit DLL | S18 |
| セッション開始時 IBMSLP.DLL not found | Hot Standby / Load Balancing 構成で IBMSLP.DLL がクライアントに無い | 1) PCOMM 再インストールで Multiple Sessions / SLP 機能を選択<br>2) IBMSLP.DLL が system directory にあるか確認<br>3) System Policy / 権限設定で配布が阻害されていないか確認 | Information Bundler, ファイル存在確認 | S39 |
| Multiple Sessions のバッチが新規作成できない | System Policy 権限不足 | 1) Functions Restricted by System Policies の設定を管理者に確認<br>2) Bch 作成権限を解放、または管理者が代理で .bch を配布 | System Policy, *.bch | S35 |
| Sleep / Hibernate 復帰後にセッションが切断される | OS の電源イベント時の TCP/IP 切断 | 1) Preferences → Standby/Hibernate 設定を確認<br>2) Connected State / Critical Sleep の挙動を有効化（Windows 7 以降）<br>3) Auto-Reconnect 機能を併用 | Preferences, Power Management | S36 |
| プロファイル / SNA 構成を旧版から移行できない | Application Data Location 設定不一致 or Automatic Migration を OFF | 1) 再インストール時に Automatic Migration Options で Migration Level を選択<br>2) インストール後でも Migration Utility を起動して再移行<br>3) V6.0 Classic Private Directory からの移行は All Users 既定切替挙動を理解 | Migration Utility, Automatic Migration Options | S19 |
| ZipPrint メニューが表示されない / 印刷できない | ZipPrint は 3270 専用、5250/VT セッションでは無効 | 1) セッション種別が 3270 か確認<br>2) ZipPrint 機能をインストール時に追加<br>3) PDT / Windows Printer Driver / Page Setup を確認<br>4) Bidi 環境では RTL Print Orientation を別途指定 | ZipPrint, PDT, Page Setup | S30, S32 |
| Scratch Pad メニューが灰色で押せない | .NET Framework 3.5 が未導入 (Windows 8 / 8.1 既定で含まれない) | 1) Windows の機能の追加 / 削除で .NET Framework 3.5 を有効化<br>2) PCOMM 再起動 | OS 機能, Scratch Pad | S32 |

