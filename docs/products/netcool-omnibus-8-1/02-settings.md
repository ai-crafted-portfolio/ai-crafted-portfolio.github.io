# 設定値一覧

> 掲載：**ObjectServer プロパティ 18 件 + Probe / Gateway / Process Agent / Web GUI 関連 20 件 = 38 件**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

Netcool/OMNIbus 8.1 の挙動は次の 4 系統のプロパティで決まる：

1. **ObjectServer プロパティ** — `$OMNIHOME/etc/<ObjectServerName>.props` または起動時 `-propsfile`。
2. **Probe プロパティ** — `$OMNIHOME/probes/<arch>/<probe>.props`。
3. **Gateway プロパティ** — `$OMNIHOME/etc/<GatewayName>.props`（uni/bi/各種マッピング含む）。
4. **Process Agent / Proxy プロパティ** — `$NCHOME/etc/<PA>.props` 等。

加えて、Web GUI（Jazz/DASH 上）のプロパティは WAS / DASH 側の `*.props` および server.xml 系で管理される。

## ObjectServer プロパティ（18 件）

**種別の凡例**: サイジング = メモリ・領域配分、モード選択 = 動作切替、運用ポリシー = SLA / セキュリティ / 並列性、構成定義 = サブシステム構成。

<div class="md-typeset__scrollwrap" markdown="1">

| パラメータ名 | 種別 | 既定値 | 取り得る値 | 反映タイミング | 関連手順 | 注意点 |
|---|---|---|---|---|---|---|
| `Name` | 構成定義 | —（必須） | ObjectServer 名（例 NCOMS, AGG_P） | 起動時固定 | [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create) | omni.dat / interfaces のエントリ名と完全一致が必須。 |
| `MessageLevel` | 運用ポリシー | info | fatal / error / warn / info / debug | 起動時 / `alter system set 'MessageLevel'` で動的 | [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create) | debug は IO ヘビー、本番は info 既定。トラブル時のみ debug 化 → 解析後 info に戻す。 |
| `MessageLog` | 構成定義 | `$OMNIHOME/log/<ObjectServerName>.log` | 絶対パス | 起動時 | [inc-objserv-hang](09-incident-procedures.md#inc-objserv-hang) | rotate は OS 側 logrotate で。長時間運用で肥大に注意。 |
| `Memstore.DataDirectory` | 構成定義 | `$OMNIHOME/db` | 絶対ディレクトリ | 起動時 | [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create) | DB ファイル群の物理配置先。SAN / NAS / ローカル SSD の選択で IO 性能が決まる。 |
| `Iduc.ListeningPort` | 構成定義 | ObjectServer ポートと別の TCP | 1〜65535 | 起動時 | [inc-iduc-stuck](09-incident-procedures.md#inc-iduc-stuck) | IDUC（クライアントへのプッシュ通知）のリッスンポート。Web GUI / native client が接続する。 |
| `Granularity` | 運用ポリシー | 60（秒） | 整数（秒） | 起動時 | [inc-iduc-stuck](09-incident-procedures.md#inc-iduc-stuck) | IDUC 配信間隔。短くすると Web GUI が即時反応するが ObjectServer 負荷上昇。AEN 併用なら 60 でも問題なし。 |
| `NHttpd.EnableHTTP` | モード選択 | FALSE | TRUE / FALSE | 起動時 | [cfg-objserv-http](08-config-procedures.md#cfg-objserv-http) | ObjectServer の HTTP/REST インタフェース有効化。alerts.status へ POST も可。 |
| `NHttpd.AuthenticationDomain` | 運用ポリシー | omnibus | ドメイン名文字列 | 起動時 | [cfg-objserv-http](08-config-procedures.md#cfg-objserv-http) | HTTP 認証 realm。Basic / 管理コンソールから見える名前。 |
| `NHttpd.ConfigFile` | 構成定義 | `$OMNIHOME/etc/libnhttpd.json` | JSON ファイルパス | 起動時 | [cfg-objserv-http](08-config-procedures.md#cfg-objserv-http) | HTTP インタフェースの詳細設定（許可エンドポイント、CORS 等）。 |
| `SecureMode` | モード選択 | 未設定（非セキュア） | TRUE / FALSE | 起動時 | [cfg-ssl-objserv](08-config-procedures.md#cfg-ssl-objserv) | SSL/TLS 認証モード。production 必須相当。GSKit の `.kdb` 必要。 |
| `FIPS` | モード選択 | 未設定（非 FIPS） | TRUE / FALSE | 起動時 | [cfg-ssl-objserv](08-config-procedures.md#cfg-ssl-objserv) | FIPS 140-2 モード。利用可能暗号アルゴリズムが厳格化。 |
| `Store.LocalizedSort` | モード選択 | FALSE | TRUE / FALSE | 起動時 | — | ロケール対応 SORT。日本語 collate 必要時 TRUE。性能トレードあり。 |
| `Store.UseTwoFiles` | モード選択 | TRUE | TRUE / FALSE | 起動時 | [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create) | データファイル二重化。production 必須相当。 |
| `Profile` | 運用ポリシー | FALSE | TRUE / FALSE | `alter system set 'ProfilingEnabled'` で動的 | [inc-objserv-slow](09-incident-procedures.md#inc-objserv-slow) | trigger / SQL の profiling。性能調査時のみ ON。 |
| `Auto.Enabled` | モード選択 | TRUE | TRUE / FALSE | 起動時 | — | trigger / procedure の自動実行有効化。`FALSE` で全 trigger 停止（メンテ用）。 |
| `Auto.StatsInterval` | 運用ポリシー | 60（秒） | 整数（秒） | 起動時 | — | catalog.profiles 等への統計書き込み間隔。 |
| `Iduc.Enabled` | モード選択 | TRUE | TRUE / FALSE | 起動時 | [inc-iduc-stuck](09-incident-procedures.md#inc-iduc-stuck) | IDUC 機能有効化。FALSE で Web GUI が更新されない。 |
| `Sec.AuditLevel` | 運用ポリシー | 1 | 0〜3 | 起動時 | — | セキュリティ監査ログのレベル。3 = full audit。 |

</div>

## Probe プロパティ（汎用、9 件）

<div class="md-typeset__scrollwrap" markdown="1">

| パラメータ名 | 既定値 | 取り得る値 | 反映タイミング | 関連手順 | 注意点 |
|---|---|---|---|---|---|
| `Server` | —（必須） | ObjectServer 名 / virtual 名（COL_V_1 等） | 起動時 / Probe HTTP `reload` | [cfg-probe-syslog](08-config-procedures.md#cfg-probe-syslog) | virtual 名（Primary/Backup ペア）を指定するのが SMAC 標準。 |
| `ServerBackup` | 未設定 | ObjectServer 名 | 起動時 | [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) | virtual 名を Server にする方式の代替。Server / ServerBackup を別々指定する旧方式。 |
| `MessageLevel` | warn | fatal/error/warn/info/debug | 起動時 / -messagelevel | [inc-probe-conn-fail](09-incident-procedures.md#inc-probe-conn-fail) | 接続トラブル切り分け時 debug。 |
| `MessageLog` | $OMNIHOME/log/<probe>.log | 絶対パス | 起動時 | — | Probe ごとに独立。logrotate 必須。 |
| `RulesFile` | 同梱 sample | rules ファイル絶対パス | 起動時 / Probe HTTP `reload` | [cfg-probe-syslog](08-config-procedures.md#cfg-probe-syslog) | rules 編集後は HTTP reload で反映可能（Probe 再起動不要）。 |
| `RetryInterval` | 60（秒） | 整数（秒） | 起動時 | [inc-probe-conn-fail](09-incident-procedures.md#inc-probe-conn-fail) | ObjectServer 切断時の再接続間隔。 |
| `Heartbeat` | 60（秒） | 整数（秒） | 起動時 | — | ObjectServer 側からの生存確認間隔。 |
| `DisableDetails` | 0（false） | 0 / 1 | 起動時 | [inc-alerts-status-bloat](09-incident-procedures.md#inc-alerts-status-bloat) | 1 で alerts.details への書き込み停止。詳細不要 Probe で有効化すると alerts.status 系列の負荷大幅減。 |
| `EnableHTTP` / `HTTPPort` | FALSE / 空 | TRUE / FALSE / port 番号 | 起動時 | [cfg-probe-http-cmd](08-config-procedures.md#cfg-probe-http-cmd) | Probe HTTP コマンドインタフェース。reload / getstatus 等が叩ける。 |

</div>

## Gateway プロパティ（uni / bi 共通、6 件）

<div class="md-typeset__scrollwrap" markdown="1">

| パラメータ名 | 既定値 | 用途 | 関連手順 |
|---|---|---|---|
| `Gate.ObjectServerA.Server` | — | bi-directional Gateway の primary 側 ObjectServer 名 | [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) |
| `Gate.ObjectServerA.BufferSize` | 50 | A 側へ送る SQL バッチサイズ。Best Practices v1.3 推奨 50。 | [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) |
| `Gate.ObjectServerB.Server` | — | bi-directional Gateway の backup 側 ObjectServer 名 | [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) |
| `Resync.LockType` | NONE | NONE / PARTIAL / FULL — controlled failback で `PARTIAL` が標準 | [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) |
| `MaxLogFileSize` | 1024（KB） | Gateway log の最大サイズ。Best Practices v1.3 では 2048 を推奨 | [cfg-smac-collection](08-config-procedures.md#cfg-smac-collection) |
| Mapping table（複製対象） | — | 複製対象テーブル / カラム定義。`mapping.def` で記述。 | [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) |

</div>

## Process Agent プロパティ（5 件）

<div class="md-typeset__scrollwrap" markdown="1">

| パラメータ名 | 既定値 | 用途 |
|---|---|---|
| `Name` | NCO_PA | Process Agent 名。omni.dat / nco_pa_status の `-server` で参照。 |
| `Username` / `PA.Username` | 未設定 | PA 認証ユーザ。`-authenticate PAM` 使用時は OS の PAM ユーザに対応。 |
| `Password` / `PA.Password` | 未設定 | PA 認証パスワード。`nco_pa_crypt` で暗号化して props に書く。 |
| `Authenticate` | NONE | NONE / PAM / Native — production は PAM が標準。 |
| Process entries | — | nco_pad の設定ファイル（process / service / routing 定義）に各プロセス（ObjectServer / Probe / Gateway）の `command`、`autostart` 等を列挙。 |

</div>

## alerts.status スキーマ主要カラム（標準）

| カラム | 型 | 用途 | 注意 |
|---|---|---|---|
| `Identifier` | varchar(255) | **deduplication 主キー**。Probe rules で `@Identifier = ...` として組成 | 一意組成設計が deduplication 動作を決める。 |
| `Severity` | int | 0=Clear, 1=Indeterminate, 2=Warning, 3=Minor, 4=Major, 5=Critical | 0 で `delete_clears` が 120 秒後に削除。 |
| `Node` | varchar(64) | イベント発生ノード名 | フィルタの主キー。 |
| `AlertGroup` | varchar(255) | 機能カテゴリ（"Network" / "OS" 等） | restriction filter の主軸。 |
| `AlertKey` | varchar(255) | サブキー（Identifier 組成の補助） | — |
| `Summary` | varchar(255) | 表示用サマリ | Web GUI の主表示。 |
| `FirstOccurrence` / `LastOccurrence` | UTC time | 初発・最新発生時刻 | deduplication で `LastOccurrence` 更新。 |
| `Tally` | int | 重複回数 | deduplication で +1。 |
| `ExpireTime` | int（秒） | 期限切れまでの秒数 | `hk_set_expiretime` で既定値設定、超過で削除。 |
| `OwnerUID` / `OwnerGID` | int | オペレータ ownership | Web GUI のチケット運用で使用。 |
| `StateChange` | UTC time | 状態変更時刻 | `delete_clears` の 120 秒判定基準。 |

詳細スキーマは Best Practices Guide v1.3 / 公式 Documentation の `alerts.status table reference` を参照。

## 参考：プロパティ適用フロー（要約）

1. ObjectServer / Probe / Gateway の `.props` を編集
2. `nco_pa_stop` → `nco_pa_start`、または ObjectServer の場合は `nco_objserv` 再起動
3. 一部の動的プロパティは `alter system set 'X' = 'Y';` で再起動なしに変更可能
4. Probe rules 変更は HTTP `reload` で再読込

詳細手順は [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create), [cfg-probe-syslog](08-config-procedures.md#cfg-probe-syslog), [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) を参照。

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
