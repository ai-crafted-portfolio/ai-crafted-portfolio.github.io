# IBM Workload Automation — 主要設定項目

IBM Workload Automation — 主要設定項目 (globalopts / localopts / useropts ほか)

globalopts は DB 内で optman 操作。localopts はワークステーション毎の TWA_DATA_DIR/localopts テキストファイル (netman 再起動で反映)。useropts はユーザ単位の上書き。

| パラメータ名 (短縮名) | 種別 | 設定ファイル / コマンド | 既定値 | 取り得る値 | 影響範囲・反映タイミング | 出典 |
|---|---|---|---|---|---|---|
| enWorkloadServiceAssurance (wa) | globalopt | optman chg | yes | yes / no | JnextPlan で反映 | S11 |
| approachingLateOffset (al) | globalopt | optman chg | 120 sec | 0 以上の整数 (秒) | JnextPlan または WebSphere Liberty 再起動で反映 | S11 |
| deadlineOffset (do) | globalopt | optman chg | 2 min | 0 以上の整数 (分) | JnextPlan または WebSphere Liberty 再起動 | S11 |
| promotionOffset (po) | globalopt | optman chg | 120 sec | 0 以上 (秒) | JnextPlan | S11 |
| enCarryForward (cf) | globalopt | optman chg | all | all / yes / no | JnextPlan で反映 (stageman -carryforward が上書き) | S11 |
| enCFinterNetworkDeps (ci) | globalopt | optman chg | yes | yes / no | JnextPlan | S11 |
| enCFResourceQuantity (rq) | globalopt | optman chg | yes | yes / no | JnextPlan | S11 |
| enDbAudit (da) | globalopt | optman chg | 1 | 0 / 1 | 即時反映。auditStore で出力先 (file/DB/両方) 制御 | S11 |
| enAddUser (au) | globalopt | optman chg | yes | yes / no | 即時 (Symphony 自動追加切替) | S11 |
| enAddWorkstation (aw) | globalopt | optman chg | no | yes / no | 即時 (Dynamic Agent/Pool の Symphony 自動追加) | S11 |
| enAutomaticFailover (af) | globalopt | optman chg | yes (新規) / no (旧版アップグレード) | yes / no | WebSphere Liberty Base 再起動 | S11 |
| enAutomaticFailoverActions (aa) | globalopt | optman chg | yes | yes / no | WebSphere Liberty 再起動 (af=yes 時のみ意味) | S11 |
| workstationMasterListInAutomaticFailover (wm) | globalopt | optman chg | (空) | 256 byte の WS リスト | WebSphere Liberty 再起動 | S11 |
| workstationEventMgrListInAutomaticFailover (we) | globalopt | optman chg | (空) | 256 byte の WS リスト | WebSphere Liberty 再起動 | S11 |
| enCentSec (ts) | globalopt | optman chg | no | yes / no | JnextPlan (role-based security には非適用) | S11 |
| deploymentFrequency (df) | globalopt | optman chg | 5 min | 0-60 (分) | 即時。0 で planman deploy 手動運用 | S11 |
| licenseType / defaultWksLicenseType | globalopt | optman chg | perServer | perServer / perJob 等 | 変更前に IBM 営業へ要相談 | S11 |
| thiscpu | localopt | TWA_DATA_DIR/localopts | ホスト名 | workstation 名 | netman 再起動 (conman shut;wait → StartUp) | S11 |
| nm port | localopt | localopts | 31111 | ポート番号 | netman 再起動 | S11 |
| bm look | localopt | localopts | (秒) | 整数 (秒) | netman 再起動。batchman の評価周期 | S11 |
| bm check deadline | localopt | localopts | (秒) | 整数 (秒) | netman 再起動。手動追記が必要なオプション | S11 |
| jm load user profile | localopt | localopts | on | on / off | netman 再起動。jobman でのユーザプロファイル読込 | S11 |
| jm no root | localopt | localopts | (必要に応じ yes) | yes / no | netman 再起動。root 実行抑止 | S11 |
| mm cache mailbox | localopt | localopts | yes 推奨 | yes / no | netman 再起動。mailman メモリキャッシュ | S11 |
| wr enable compression | localopt | localopts | no | yes / no | netman 再起動。回線圧縮 (V9.x で導入) | S11 |
| sync level | localopt | localopts | low | low / medium / high | netman 再起動。mailbox の I/O 同期強度 | S11 |
| tcp timeout / tcp connect timeout | localopt | localopts | (秒) | 整数 (秒) | netman 再起動。ネットワーク許容遅延 | S11 |
| ssl auth mode | localopt | localopts | — | caonly / string / cpu | netman 再起動。SSL 認証モード | S11 |
| ssl fips enabled | localopt | localopts | no | yes / no | yes で GSKit、no で OpenSSL を使用 | S11 |
| ssl tls12 cipher | localopt | localopts | HIGH | HIGH / cipher 文字列 | netman 再起動。TLS1.2 cipher (1.0/1.1 は廃止) | S11, S33 |
| nm ssl full port / nm ssl port | localopt | localopts | — | ポート番号 | netman 再起動。SSL 専用ポート | S11 |
| mozart directory / parameters directory / unison network directory | localopt | localopts | — | 共有ディレクトリパス | リモート DB ファイル参照時に設定 | S11 |
| pobox サイズ (FTA) | tunable | pobox.msg | 10 MB | サイズ (MB) | JnextPlan 失敗時のヒント (動的拡張のためサイズ調整) | S15, S11 |
| IWS_DESCRIPTION / IWS_CATEGORY / IWS_TICKET | env var | シェル環境変数 | — | 文字列 (各 128-512 byte 上限) | audit ログのジャスティフィケーション情報を付加 | S11 |
| useropts ファイル | user setting | TWA_DATA_DIR/useropts | — | localopts と同形式 | ユーザ単位上書き。multi instance 切替に利用 | S11 |
| ssl_config.xml verifyHostname | Liberty 設定 | configDropins/overrides/ssl_config.xml | true | true / false | Liberty 24.0.0.7+ 利用時 false 必須回避策 (V10.2.3 で解消) | S33 |
| MAXECSA (z/OS) | z/OS パラメータ | SMF parameters | — | 数値 | z/OS Agent の event tracking 用 ECSA サイズ。Examples Table 7 参照 | S12 |
| EELUX000 / EELUX002 (z/OS exit) | z/OS exit | agent for z/OS exit | — | exit ロード モジュール | tracking event / job-library-read のカスタマイズ | S12, S19, S21 |

