# トラブル早見表

> 掲載：**20 件**。症状起点で見つけて、詳細手順へジャンプする入り口。詳細・A/B/C 仮説分岐は [10. 障害対応手順](09-incident-procedures.md)。

## カテゴリ別目次

- **エージェント起動 / 接続**: 5 件
- **イベント取込 / `.fmt` パース**: 5 件
- **性能 / 流量制御**: 4 件
- **EIF / Netcool 連携**: 3 件
- **TEP / 履歴データ**: 3 件

---

## エージェント起動 / 接続

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| `itmcmd agent start lo` が「Agent failed to start」で失敗 | `.conf` / `.fmt` の構文エラー、Java / 共有ライブラリの依存欠損、`$CANDLEHOME` 配下のパーミッション、起動ログ書込不能 | `$CANDLEHOME/logs/<host>_lo_*.log` の最新 200 行、`itmcmd agent status lo`、`ls -l $CANDLEHOME/<arch>/lo/bin/` のパーミッション | [inc-agent-down](09-incident-procedures.md#inc-agent-down) |
| `itmcmd config -A lo` の対話プロンプト後にエラー | `.ini` の TEMS 接続情報誤、KDC_FAMILIES の I/F 設定、ホスト名解決失敗 | `cat $CANDLEHOME/config/lo.ini`、`KDC_PARTITION` の設定、`nslookup <hub_tems>` | [inc-itmcmd-fail](09-incident-procedures.md#inc-itmcmd-fail) |
| TEP に LFA agent が現れない（offline / 表示なし） | TEMS 接続失敗、ファイアウォール 1918/3660 閉塞、CMS_HOSTNAME / NODE 名重複、agent 側証明書不整合（IP.SPIPE 利用時） | TEP の Managed Systems 一覧、`itmcmd agent status lo`、Hub TEMS 側 `$CANDLEHOME/logs/<hub>_ms_*.log` で agent 接続要求の有無 | [inc-tems-conn-fail](09-incident-procedures.md#inc-tems-conn-fail) |
| Subnode が一部だけ TEP に表示されない | `kfaenv` 系 環境変数誤、subnode 用 `.conf` ファイル未配置、agent 起動順序、Managed System List の配信反映待ち | `$CANDLEHOME/config/lo/<subnode>.conf` の有無、`itmcmd agent stop lo && itmcmd agent start lo` 後の TEP 反映 | [inc-subnode-not-shown](09-incident-procedures.md#inc-subnode-not-shown) |
| Windows サービス「IBM Tivoli Monitoring Tivoli Log File Agent」が即停止 | サービスログオンアカウント権限不足（log 読込権 / `%CANDLE_HOME%` 書込権）、`.conf` 構文エラー、Windows Event Log への書込失敗 | Event Viewer の System / Application、`%CANDLE_HOME%\TMAITM6\logs\` の最新 log、`services.msc` のログオンアカウント | [inc-agent-down](09-incident-procedures.md#inc-agent-down) |

## イベント取込 / `.fmt` パース

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| 監視対象ログには行が出ているのに TEP / Netcool に何も上がらない | `.fmt` の REGEX が一致していない、`.conf` の `LogSources` がそもそもファイルを開けていない、`MaxEventQueueDepth` 到達で破棄、起動直後で `NumEventsToCatchUp=-1` のため過去ログ skip | LFA agent log の `RegexCache` / `LogSource` 関連メッセージ、`itmcmd agent` で再起動して再現確認、`.fmt` を簡易化して切り分け | [inc-events-not-captured](09-incident-procedures.md#inc-events-not-captured) |
| 多行スタックトレースが 1 行ずつバラバラに上がる | `NewLinePattern` 未指定 / 正規表現ミス、Java スタックの行頭判定が誤、`EventMaxSize` 超過で truncate | `.conf` の `NewLinePattern`、サンプル 5 行を手元で REGEX 検証、`EventMaxSize` の現値 | [inc-multiline-broken](09-incident-procedures.md#inc-multiline-broken) |
| 一部の行だけ拾われない（規則性が見えない） | REGEX の greedy / non-greedy 誤、エンコーディング不一致（CP932 / EUC-JP）、行末の CR / LF 不一致、特殊文字 escape 漏れ | LFA agent log の `RegexCache` 統計（`LogfileRegexStatistics` 属性参照）、`file <log>` で encoding 判定、test ホストで `.fmt` 単体検証 | [inc-regex-mismatch](09-incident-procedures.md#inc-regex-mismatch) |
| 日本語 / マルチバイト文字が ?????? に化ける | LFA の locale / NLS 環境不一致、`-utf8` 未指定、TEMS / TEPS 側の codepage 不一致、Netcool 側受信ルールでの再エンコード問題 | `locale` 出力、`itmcmd agent start` 時の環境変数、TEPS / Netcool 側の表示 | [inc-encoding-garbled](09-incident-procedures.md#inc-encoding-garbled) |
| ログローテーション直後にイベントが落ちる | `FileComparisonMode` の選定不一致（CompareSize → 同サイズで rotate を見逃し）、ファイルパスに inode 変化が伴う rename rotate、`LogSources` のワイルドカード設計ミス | `.conf` の `FileComparisonMode`、ログローテータの方式（copy-truncate / rename）、`LogSources` のパターン | [inc-rotation-missed](09-incident-procedures.md#inc-rotation-missed) |

## 性能 / 流量制御

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| イベントが大量に落ちている / 受信側で「summary」イベントだけ届く | `EventFloodThreshold` が `send_first` / `send_none` / `summary` 等で抑制動作、`MaxEventQueueDepth` 到達 | `.conf` の `EventFloodThreshold` / `EventSummaryInterval` / `MaxEventQueueDepth`、agent log の `flood threshold` メッセージ | [inc-event-flood](09-incident-procedures.md#inc-event-flood) |
| ディスクが急速に埋まる（agent log / RAS1 trace） | `KBB_RAS1` を `ALL` で残しっぱなし、agent log のローテーション設定なし | `du -sh $CANDLEHOME/logs/`、`KBB_RAS1` の現値、ログローテ設定（`KBB_RAS1_LOG_INVENTORY` 系） | [inc-disk-fill-trace](09-incident-procedures.md#inc-disk-fill-trace) |
| CPU 使用率が常時高い / 監視対象が多くないのに重い | `.fmt` の REGEX が catastrophic backtracking、`MaxEventQueueDepth` 飽和でリトライループ、`PollingInterval` 未指定で過剰ポーリング | `top -p <agent pid>`、agent log の REGEX 関連メッセージ、`.fmt` の `(.*)+` 等の重い表現 | [inc-event-flood](09-incident-procedures.md#inc-event-flood)（共通切り分け） |
| 「Permission denied」でログ読めない | サービス起動アカウント / agent ユーザがログファイル read 権限なし、SELinux / AppArmor 制限 | `ls -l <log file>`、`getenforce`（SELinux）、agent 実行ユーザの `id` | [inc-perms-readfail](09-incident-procedures.md#inc-perms-readfail) |

## EIF / Netcool 連携

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| LFA は緑 / TEP には来ているが Netcool に届かない | `.conf` の `EIFServer` / `EIFPort` 誤、Netcool 側 `nco_p_tivoli_eif` 未起動、`tivoli_eif.rules` で reject、ファイアウォール 5529 閉塞 | `.conf` 内 `EIFServer` / `EIFPort`、Netcool 側 `nco_p_tivoli_eif` プロセスと port、`telnet <eif_host> 5529` 疎通 | [inc-eif-not-delivered](09-incident-procedures.md#inc-eif-not-delivered) |
| EIF キャッシュファイル（`EIFCachePath`）が肥大化 | EIF receiver 長時間ダウン、ネットワーク断続、cache サイズ上限超過後の挙動 | `du -sh <EIFCachePath>`、`tail -f $CANDLEHOME/logs/<host>_lo_*.log` の EIF 関連 | [inc-eif-cache-stuck](09-incident-procedures.md#inc-eif-cache-stuck) |
| Netcool 側で「flush」イベントだけ届く | summary / flush 設定（`EventSummaryInterval`）に従って flush イベント生成、または EIF receiver で個別イベントが drop | `.conf` の `EventSummaryInterval`、Netcool 側 `tivoli_eif.rules` の filter | [inc-event-flood](09-incident-procedures.md#inc-event-flood) |

## TEP / 履歴データ

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| TEP で agent は緑だが LogfileEvents ワークスペースが空 | situation 未配信、history 未収集、TEPS の cache 古い、agent → TEMS → TEPS の経路で時刻ズレ | TEP の Manage Situations、`itmcmd config -A cms`（Hub）の history collection 設定、TEPS の `KFW_REPORT_TERM_BREAK_POINT` 等 | [inc-tep-no-data](09-incident-procedures.md#inc-tep-no-data) |
| 履歴データがほとんど残らない / 数日で消える | History Collection の保持期間設定不足、TDW（Tivoli Data Warehouse）未構築、`KFW_REPORT_TERM_BREAK_POINT` 設定 | TEPS の Tivoli Data Warehouse 接続、Manage Tivoli Enterprise Monitoring Services の History 設定 | [inc-tep-no-data](09-incident-procedures.md#inc-tep-no-data) |
| Situation が常時 fired のまま / 自動 reset しない | UNTIL 条件未指定、persist condition 設定誤、agent 側 attribute group の更新間隔と situation interval 不一致 | TEP の Edit Situation > Until tab、agent log の sit reload | [inc-tep-no-data](09-incident-procedures.md#inc-tep-no-data) |

## 共通の最初の動作

どの症状でも、最初に取る情報は固定：

1. **agent ログの最新 200 行**：`tail -200 $CANDLEHOME/logs/<host>_lo_*.log`
2. **agent ステータス**：`itmcmd agent status lo` または Windows サービス状態
3. **`.conf` / `.fmt` の現物保管**：`cp $CANDLEHOME/<arch>/lo/<file>.conf /tmp/snapshot/`（解析時に変更前後を比較できるよう）
4. **TEMS 接続情報**：`itmcmd config -A lo` の現値（CMS_HOSTNAME / KDC_FAMILIES）
5. **`pdcollect`** で診断情報一括収集（IBM サポート連携時）

これらを揃えてから A/B/C 仮説分岐（[10. 障害対応手順](09-incident-procedures.md) 参照）に進む。

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
