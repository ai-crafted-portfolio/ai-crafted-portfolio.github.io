# Netcool OMNIbus V8.1 — 主要設定項目

Netcool/OMNIbus V8.1 — 主要設定項目（プロパティ／スキーマ／プロセス制御）

ObjectServer プロパティ / Probe プロパティ / Web GUI 設定 / alerts.status スキーマの主要項目。各値の根拠は出典列の [SX] を参照。

| パラメータ名 | 設定ファイル / コマンド | 既定値 | 取り得る値 | 影響範囲（再起動要否・動的反映） | 関連パラメータ | 出典 |
|---|---|---|---|---|---|---|
| MessageLevel | ObjectServer プロパティ / -messagelevel | info | fatal / error / warn / info / debug | 起動時設定（再起動で反映） | MessageLog | S1 |
| MessageLog | ObjectServer プロパティ | $OMNIHOME/log/<ObjectServerName>.log | ファイルパス文字列 | 起動時設定 | MessageLevel | S1 |
| Memstore.DataDirectory | ObjectServer プロパティ / -memstoredatadirectory | $OMNIHOME/db | 絶対ディレクトリパス | 起動時設定 | ObjectServer DB 永続化先 | S1 |
| Iduc.ListeningPort | ObjectServer プロパティ | ObjectServer ポートと別の TCP ポート | 1〜65535 の整数 | 起動時設定（IDUC クライアントへ影響） | Granularity / IDUC 配信 | S1 |
| Granularity | ObjectServer プロパティ | 60（秒、IDUC 配信間隔） | 整数（秒） | 起動時設定 — 短くすると Web GUI 応答性が向上するが負荷上昇 | Iduc.ListeningPort / AEN | S1 |
| NHttpd.EnableHTTP | ObjectServer プロパティ | FALSE（HTTP インターフェース無効） | TRUE / FALSE | 起動時設定 | NHttpd.ConfigFile | S1, S5 |
| NHttpd.AuthenticationDomain | ObjectServer プロパティ / -nhttpd_authdomain | omnibus | ドメイン名文字列 | 起動時設定 | NHttpd.EnableHTTP | S1 |
| NHttpd.ConfigFile | ObjectServer プロパティ / -nhttpd_configfile | $OMNIHOME/etc/libnhttpd.json | JSON ファイルパス | 起動時設定 | libnhttpd / nhttpd | S1 |
| SecureMode (Proxy Server / Probe / Gateway) | プロパティ / -secure コマンドラインオプション | 未設定（非セキュア） | TRUE / FALSE | 起動時設定 | PA.Username / PA.Password / SSL | S1 |
| FIPS Mode | ObjectServer / Process Agent / Proxy Server / Gateway | 未設定（非 FIPS） | TRUE / FALSE（FIPS 140-2 モード） | 起動時設定（暗号モジュールが切替） | GSKit / SSL | S1 |
| PA.Username / PA.Password | Process Agent ($NCHOME/etc 配下のプロパティ) | 未設定（任意） | ユーザ名 / 暗号化済パスワード | 起動時設定 | nco_pa_start / nco_pa_stop / SecureMode | S1 |
| Store.LocalizedSort | ObjectServer プロパティ | FALSE | TRUE / FALSE | 起動時設定（ロケール対応 SORT に影響） | ObjectServer のマルチカルチャ対応 | S1 |
| DisableDetails (Probe) | Probe プロパティファイル / -disabledetails | 0（alerts.details 出力する） | 0 / 1 | 起動時設定（Probe） | alerts.details / 性能 | S1 |
| alerts.status.Identifier | alerts.status スキーマ / 主キー候補 | —（一意キー、Probe rules file で組成） | string(255) | deduplication 判定キー | AlertGroup / AlertKey / Node | S1, S5 |
| alerts.status.Severity | alerts.status スキーマ | —（Probe rules file で 0〜5 を設定） | 0 (Clear) / 1 (Indeterminate) / 2 (Warning) / 3 (Minor) / 4 (Major) / 5 (Critical) | delete_clears / generic_clear で 0 = Clear へ更新→削除候補 | generic_clear / delete_clears | S1 |
| alerts.status.FirstOccurrence / LastOccurrence | alerts.status スキーマ | —（自動更新） | UNIX time (integer) | deduplication 時に LastOccurrence と Tally を更新 | Tally / deduplication | S1 |
| ExpireTime | alerts.status / master.properties | 0（無期限） | 整数（秒） | hk_set_expiretime トリガが既定値を反映、期限超過で削除 | hk_set_expiretime / master.properties | S1 |
| trigger_group の有効/無効 | ObjectServer Administrator または SQL (alter trigger group ... enabled) | 標準 trigger_group は有効 | enabled / disabled | 動的（alter で即時反映） | automation.sql / signal | S1 |
| Default groups（Probe / Gateway / 等） | Netcool/OMNIbus Administrator / SQL | Probe = CatalogUser, AlertsUser, AlertsProbe, RegisterProbe; Gateway = CatalogUser 系 | 標準＋カスタムグループ | ユーザログイン時の権限決定 | RBAC / ChannelUser | S1 |
| omni.dat 接続情報 | $NCHOME/etc/omni.dat (UNIX) | —（NCOMS, BARROW 等のサンプル） | サーバ名／ホスト／ポート（IPv4/IPv6 両対応） | nco_xigen による interfaces 再生成で反映 | nco_xigen / IPv6 設定 | S1 |
| Probe rules file (@manager / @Severity 等) | $OMNIHOME/probes/<arch>/<probe>.rules | —（Probe ごとに同梱） | Tcl 風ルール構文 / @-prefix で alerts.status カラム代入 | Probe 再起動 or HTTP コマンドで reload | MIB Manager / nco_p_tivoli_eif | S1, S2 |
| WAAPI 設定（runwaapi） | $WEBGUI_HOME/waapi/bin/runwaapi(.cmd) と XML | —（接続情報は client.props 系で管理） | ユーザ・グループ・ロール・フィルタ・ビュー・ツールの定義 XML | Web GUI 側のキャッシュ更新で反映 | Web GUI / DASH | S5 |

