# 設定値一覧

> 掲載：**`.conf` 主要ディレクティブ 22 件 + `.fmt` 構文要素 8 件 + Operating Environment 変数 10 件 = 40 件**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

LFA 6.3 の挙動は次の 3 系統の設定で決まる：

1. **`.conf`（Configuration file）** — agent 動作と監視対象の指定。`$CANDLEHOME/<arch>/lo/` 配下、または subnode 別 `$CANDLEHOME/config/lo/<subnode>.conf`（UNIX）。
2. **`.fmt`（Format file）** — REGEX による行解析と `LogfileEvents` 属性へのマッピング。
3. **Operating Environment 変数** — `kfaenv`（UNIX）/ レジストリ + サービス環境変数（Windows）。`KBB_RAS1` トレース、`CTIRA_HOSTNAME` / `CTIRA_SUBSYSTEM_ID` 等の subnode 識別、`KDC_FAMILIES` 通信プロトコル、ロケール / NLS。

すべての設定変更は **agent 再起動（`itmcmd agent stop lo && itmcmd agent start lo`）で反映**。一部の値は変更後に既存 `LogfileEvents` 行へ波及しないため、再起動前後の動作差を確認する習慣が必須。

## `.conf` 主要ディレクティブ（22 件）

**種別の凡例**: 入力 = 監視対象指定、解析 = 行のパース挙動、出力 = TEMS / EIF への送出、運用 = 起動・キャッチアップ。

<div class="md-typeset__scrollwrap" markdown="1">

| ディレクティブ | 種別 | 既定値 | 取り得る値 | 影響 / 関連手順 | 注意点 |
|---|---|---|---|---|---|
| `LogSources` | 入力 | —（必須、または `Sources`） | カンマ区切りの絶対パス、ワイルドカード可（例：`/var/log/messages*`） | [cfg-conf-create](08-config-procedures.md#cfg-conf-create) | ワイルドカードは subnode 起動時に展開。途中で増えるファイルは検出されないケースがある（`PollingInterval` と `FileComparisonMode` 併用） |
| `Sources` | 入力 | — | 名前付きソース定義（`SOURCE=<name> <path>`）の列挙 | [cfg-conf-create](08-config-procedures.md#cfg-conf-create) | `LogSources` のシンプル版。複数パターンに名前を付けたい場合に使う |
| `UnixCommand` | 入力 | — | 任意のシェルコマンド（出力を継続的に読む） | [cfg-pipe-stream](08-config-procedures.md#cfg-pipe-stream) | `tail -F` 系の常駐コマンドや syslog pipe との接続。コマンドが終了するとイベント供給も止まる |
| `WINEVENTLOGS` | 入力 | — | Windows Event Log の channel リスト（例：`System,Application,Security`） | [cfg-windows-eventlog](08-config-procedures.md#cfg-windows-eventlog) | Windows 限定。Event Log API 経由で取得、`.fmt` 不要のデフォルト属性化あり |
| `FormatFile` | 解析 | `<agent>.fmt` | 絶対パス、または agent root 相対パス | [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create) | subnode 別に分離する設計が定石。同一 `.fmt` を複数 subnode で共用も可 |
| `RegexFiles` | 解析 | — | カンマ区切りの追加 `.fmt` ファイル | [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create) | `FormatFile` を main、`RegexFiles` を appendix にする運用が読みやすい |
| `NewLinePattern` | 解析 | 単一行（既定で 1 line = 1 event） | REGEX | [cfg-multiline-newline](08-config-procedures.md#cfg-multiline-newline) | スタックトレース・SQL plan 等の多行イベント定義の中核。pattern 一致行が **新イベントの先頭** とみなされる |
| `EventMaxSize` | 解析 | 実装既定（数 KB 程度） | バイト数 | [cfg-multiline-newline](08-config-procedures.md#cfg-multiline-newline) | 多行イベントが長すぎると truncate される。Java スタック対応で増やすことが多い |
| `FileComparisonMode` | 入力 | `CompareSize` | `CompareSize` / `CompareSizeAndMtime` / `CompareByAllMatches` 等 | [cfg-rotation-monitor](08-config-procedures.md#cfg-rotation-monitor), [inc-rotation-missed](09-incident-procedures.md#inc-rotation-missed) | logrotate / copytruncate 方式の選択により最適値が異なる |
| `PollingInterval` | 入力 | 実装既定（秒） | 秒数 | [cfg-conf-create](08-config-procedures.md#cfg-conf-create) | 短すぎると CPU を食い、長すぎるとイベント遅延 |
| `NumEventsToCatchUp` | 運用 | `0`（起動時に過去ログを送らない） | `0` / `-1`（全件）/ 正の整数（最後の N 件） | [cfg-conf-create](08-config-procedures.md#cfg-conf-create) | 起動時の挙動を決める。再起動連発で過去ログが二重送信されないよう注意 |
| `MaxEventQueueDepth` | 運用 | 実装既定 | 件数 | [inc-event-flood](09-incident-procedures.md#inc-event-flood) | 上流（TEMS / EIF）が遅いときの内部キュー上限。超過時は古い順に破棄 |
| `EventFloodThreshold` | 出力 | `send_all`（無制限） | `send_all` / `send_none` / `send_first <n>` / `reset_summary` 等 | [cfg-flood-threshold](08-config-procedures.md#cfg-flood-threshold) | 同一イベントの集中時に流量制御。設定を強くしすぎるとイベントロスの主因 |
| `EventSummaryInterval` | 出力 | 未指定 | 秒数 | [cfg-flood-threshold](08-config-procedures.md#cfg-flood-threshold) | summary イベントの flush 間隔 |
| `EIFServer` | 出力 | — | EIF receiver のホスト名 / IP | [cfg-eif-target](08-config-procedures.md#cfg-eif-target) | Netcool/OMNIbus の `nco_p_tivoli_eif` ホストを指定 |
| `EIFPort` | 出力 | `5529` | TCP ポート | [cfg-eif-target](08-config-procedures.md#cfg-eif-target) | `nco_p_tivoli_eif` の `ServerPort` と一致させる |
| `EIFCachePath` | 出力 | 実装既定 | ディレクトリパス | [cfg-eif-target](08-config-procedures.md#cfg-eif-target), [inc-eif-cache-stuck](09-incident-procedures.md#inc-eif-cache-stuck) | EIF receiver ダウン時の永続キャッシュ。容量監視必須 |
| `EIFHeartbeatInterval` | 出力 | 実装既定 | 秒数 | [cfg-eif-target](08-config-procedures.md#cfg-eif-target) | EIF receiver への生存確認 |
| `FQDomain` | 出力 | 未指定（短い hostname） | `yes` / `no` / 任意のドメイン文字列 | [cfg-fqdomain](08-config-procedures.md#cfg-fqdomain) | 出力イベントの `hostname` 属性を FQDN にするか。Netcool の dedup 設計に直結 |
| `EventSource` | 出力 | 未指定 | 文字列 | [cfg-conf-create](08-config-procedures.md#cfg-conf-create) | EIF / TEMS 出力時の source 識別子 |
| `ProcessPriorityClass` | 運用 | OS 既定 | OS の priority 値 | [cfg-conf-create](08-config-procedures.md#cfg-conf-create) | DB サーバなど CPU タイトな環境で agent 優先度を下げたいとき |
| `ConfigurationFile` | 運用 | — | 別 `.conf` への参照 | [cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi) | 共通設定を分離する用途 |

</div>

## `.fmt` 構文要素（8 件）

<div class="md-typeset__scrollwrap" markdown="1">

| 構文要素 | 形式 | 用途 | 関連手順 | 注意点 |
|---|---|---|---|---|
| `REGEX <name>` | 行頭、後続行で REGEX 本体 | 1 イベント定義の開始マーカ。`<name>` がイベントクラス名相当 | [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create) | `.conf` の `EventClass` 等から参照される |
| 正規表現本体 | 1 行の REGEX | 監視ログ行を抽出する。capture group `( ... )` を attribute へ割当 | [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create) | greedy 過多は性能劣化の主因 |
| `<attribute_name> $<n>` | `(.*)` capture を指定属性へ割当 | 例：`msg $1` | [cfg-attribute-mapping](08-config-procedures.md#cfg-attribute-mapping) | `LogfileEvents` 属性グループの定義済 attribute 名に合わせる |
| `-FILENAME` value specifier | `-FILENAME PRINTF("%s","filename")` 等 | 監視中ファイル名を attribute へ | [cfg-attribute-mapping](08-config-procedures.md#cfg-attribute-mapping) | ローテーション後のファイル識別に有用 |
| `-line` value specifier | 監視ログ行そのもの全体 | 「originalmsg」属性等にそのまま流用 | [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create) | 構造化を諦めて raw 行を Netcool に渡したいとき |
| `-month` / `-day` / `-time` 等 | 日時 value specifier | 抽出した日付・時刻を ITM 標準形式へ | [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create) | OS / アプリのタイムゾーンと TEMS / TEPS の TZ を一致させる |
| `END` | REGEX ブロック終端 | 1 つの `REGEX` 定義の終わり | [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create) | 省略すると次の `REGEX` まで読み込まれる |
| 連続 `REGEX` ブロック | 評価順の宣言 | 上から順に評価、最初に一致したパターンが採用 | [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create) | 順序が結果を左右する。catch-all は最後に置く |

</div>

## Operating Environment 変数（10 件）

<div class="md-typeset__scrollwrap" markdown="1">

| 変数名 | 設定経路 | 既定値 / 推奨値 | 用途 | 関連手順 |
|---|---|---|---|---|
| `KBB_RAS1` | `kfaenv`（UNIX） / レジストリ環境変数（Windows） | 実装既定（簡易トレース） | RAS1 トレースレベル。例：`ERROR (UNIT:klog STATE)` / `ERROR (UNIT:logfile_agent ALL)` | [cfg-trace-ras1](08-config-procedures.md#cfg-trace-ras1) |
| `KBB_RAS1_LOG` | `kfaenv` | `<host>_lo_<timestamp>.log` | trace ログファイル名指定 | [cfg-trace-ras1](08-config-procedures.md#cfg-trace-ras1) |
| `KBB_RAS1_LOG_INVENTORY` | `kfaenv` | 実装既定 | trace ログのローテーション設定（個数 / サイズ） | [inc-disk-fill-trace](09-incident-procedures.md#inc-disk-fill-trace) |
| `KDC_FAMILIES` | `lo.ini` / `itmcmd config -A lo` | 環境による（IP.PIPE / IP.SPIPE / IP.UDP のいずれか） | TEMS との通信プロトコルと port | [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect) |
| `CTIRA_HOSTNAME` | `kfaenv` | OS の hostname | TEP に表示される agent 名のホスト部分 | [cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi) |
| `CTIRA_SUBSYSTEM_ID` | `kfaenv` | 任意 | subnode 識別子（TEP 表示の suffix） | [cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi) |
| `CTIRA_NODETYPE` | `kfaenv` | LFA 既定 | TEP に表示される node type | [cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi) |
| `LANG` / `LC_ALL` | OS shell / `kfaenv` | 環境による | NLS / locale。マルチバイト文字の取り扱いに直結 | [inc-encoding-garbled](09-incident-procedures.md#inc-encoding-garbled) |
| `CANDLEHOME` | `itmenv` 等 | UNIX：`/opt/IBM/ITM`、Windows：`C:\IBM\ITM` | ITM ルート。すべてのコマンド・パスの起点 | [cfg-agent-install](08-config-procedures.md#cfg-agent-install) |
| `JAVA_HOME` | OS / `kfaenv` | 環境による | LFA 自体は C コンポーネントだが、ITM 共通コンポーネントが Java を要求 | [cfg-agent-install](08-config-procedures.md#cfg-agent-install) |

</div>

## 監視対象ファイルの典型パターン（参考）

| 用途 | `LogSources` 例 | 関連手順 |
|---|---|---|
| Linux syslog | `/var/log/messages*, /var/log/secure*` | [uc-syslog-monitor](12-use-cases.md#uc-syslog-monitor) |
| AIX errlog（テキスト化必須、`errpt -a` をパイプ） | `UnixCommand=errpt -a` | [uc-pipe-source](12-use-cases.md#uc-pipe-source) |
| WebSphere SystemOut | `/opt/IBM/WebSphere/AppServer/profiles/*/logs/*/SystemOut.log*` | [uc-app-log-monitor](12-use-cases.md#uc-app-log-monitor) |
| Apache access log | `/var/log/httpd/access_log*` | [uc-app-log-monitor](12-use-cases.md#uc-app-log-monitor) |
| Db2 db2diag | `/home/db2inst1/sqllib/db2dump/db2diag.log*` | [uc-app-log-monitor](12-use-cases.md#uc-app-log-monitor) |
| Windows Event Log | `WINEVENTLOGS=System,Application,Security` | [uc-windows-eventlog](12-use-cases.md#uc-windows-eventlog) |

---

!!! info "本章の品質方針"
    全ディレクティブは Tivoli Log File Agent Version 6.3 User's Guide（S3）の Chapter 3 / Chapter 4 / Chapter 5 / Chapter 6 章記述を根拠とする。**業務上の妥当値**（業務 SLA に応じた `EventFloodThreshold` の値、`MaxEventQueueDepth` の上限）は環境依存のため [11. 対象外項目](10-out-of-scope.md) に逃がす。

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
