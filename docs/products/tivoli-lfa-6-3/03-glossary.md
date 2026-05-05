# 用語集

> 掲載：**62 件（LFA 固有 + ITM 6.3 共通 + Netcool 連携）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## アーキテクチャ階層 / 中核コンポーネント（10 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="lfa">**Log File Agent（LFA）**</span> | テキストログファイルを継続的に追尾し、`.fmt` の REGEX で解析して `LogfileEvents` へイベント化する ITM 6.3 配下のエージェント。製品番号 5724-C04、edition SC14-7484-04 | [ITM](#itm), [TEMS](#tems), [Format File](#format-file) | [cfg-agent-install](08-config-procedures.md#cfg-agent-install) |
| <span id="itm">**IBM Tivoli Monitoring（ITM）6.3**</span> | LFA を含む IBM の統合監視基盤。Hub TEMS / Remote TEMS / TEPS / TEP / Agent の階層 | [TEMS](#tems), [TEPS](#teps), [TEP](#tep) | [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect) |
| <span id="tems">**TEMS（Tivoli Enterprise Monitoring Server）**</span> | エージェントから受信した監視データの中核サーバ。Hub TEMS と Remote TEMS の 2 種、agent は通常 Remote TEMS（または直接 Hub TEMS）に接続 | [Hub TEMS](#hub-tems), [Remote TEMS](#remote-tems), [LFA](#lfa) | [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect) |
| <span id="hub-tems">**Hub TEMS**</span> | TEMS 階層のルート。Situation 評価、TEPS への中継、agent / managed system の集中管理 | [Remote TEMS](#remote-tems), [TEPS](#teps) | [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect) |
| <span id="remote-tems">**Remote TEMS**</span> | Hub TEMS 配下のサブ TEMS。スケール拡張用、agent 数が多い環境で agent 接続点を分散 | [Hub TEMS](#hub-tems) | [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect) |
| <span id="teps">**TEPS（Tivoli Enterprise Portal Server）**</span> | TEP（ポータル GUI）のバックエンド。Hub TEMS と接続し agent 情報を提供 | [TEP](#tep), [Hub TEMS](#hub-tems) | [cfg-tep-situation](08-config-procedures.md#cfg-tep-situation) |
| <span id="tep">**TEP（Tivoli Enterprise Portal）**</span> | LFA イベントを可視化する Java GUI / Web ブラウザ版。Workspace / Situation / Manage Tivoli Enterprise Monitoring Services のエントリ点 | [TEPS](#teps), [LogfileEvents](#logfileevents) | [cfg-tep-workspace](08-config-procedures.md#cfg-tep-workspace) |
| <span id="agent-code">**Agent code（`lo`）**</span> | LFA の内部識別子。`itmcmd agent start lo`、`$CANDLEHOME/<arch>/lo/` のように使用 | [LFA](#lfa) | [cfg-agent-install](08-config-procedures.md#cfg-agent-install) |
| <span id="candlehome">**`$CANDLEHOME`（UNIX）/ `%CANDLE_HOME%`（Windows）**</span> | ITM ルート。UNIX 既定 `/opt/IBM/ITM`、Windows 既定 `C:\IBM\ITM` | [LFA](#lfa) | [cfg-agent-install](08-config-procedures.md#cfg-agent-install) |
| <span id="klogagent">**`klogagent`（プロセス名）**</span> | LFA agent の常駐プロセス本体（環境により `kfaagent` 表記もあり）。`ps -ef \| grep -i klog` で確認 | [LFA](#lfa) | [inc-agent-down](09-incident-procedures.md#inc-agent-down) |

## 設定ファイル系（8 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="conf-file">**Configuration file（`.conf`）**</span> | LFA の動作を決める設定ファイル。`LogSources` / `FormatFile` / `NumEventsToCatchUp` / `MaxEventQueueDepth` / `EventFloodThreshold` / `NewLinePattern` / `EventMaxSize` / `FQDomain` / `FileComparisonMode` / `EIFServer` 等のディレクティブ | [Format File](#format-file), [Subnode](#subnode) | [cfg-conf-create](08-config-procedures.md#cfg-conf-create) |
| <span id="format-file">**Format file（`.fmt`）**</span> | 監視ログ行を REGEX で解析し `LogfileEvents` 属性へマッピングする宣言ファイル。`REGEX <name>` ブロック + 正規表現 + `<attribute> $<n>` 割当 + value specifier | [Configuration file](#conf-file), [LogfileEvents](#logfileevents), [REGEX](#regex) | [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create) |
| <span id="logsources">**`LogSources`**</span> | `.conf` の主要ディレクティブ。監視対象ファイルパスをカンマ区切り / ワイルドカードで指定 | [Configuration file](#conf-file), [FileComparisonMode](#filecomparisonmode) | [cfg-conf-create](08-config-procedures.md#cfg-conf-create) |
| <span id="filecomparisonmode">**`FileComparisonMode`**</span> | ローテートされたファイルを「同一ファイル」と判定するモード。`CompareSize` / `CompareSizeAndMtime` / `CompareByAllMatches` 等 | [LogSources](#logsources) | [cfg-rotation-monitor](08-config-procedures.md#cfg-rotation-monitor), [inc-rotation-missed](09-incident-procedures.md#inc-rotation-missed) |
| <span id="newlinepattern">**`NewLinePattern`**</span> | 多行イベントを定義する REGEX。一致行が「新イベントの先頭」とみなされ、それまでの蓄積行が 1 イベントとして flush | [EventMaxSize](#eventmaxsize) | [cfg-multiline-newline](08-config-procedures.md#cfg-multiline-newline) |
| <span id="eventmaxsize">**`EventMaxSize`**</span> | 1 イベントの最大バイト数。多行イベントでオーバーフロー時に truncate | [NewLinePattern](#newlinepattern) | [cfg-multiline-newline](08-config-procedures.md#cfg-multiline-newline) |
| <span id="floodthreshold">**`EventFloodThreshold`**</span> | 同一イベントの大量発生時の流量制御。`send_all` / `send_none` / `send_first <n>` / `reset_summary` 等。`EventSummaryInterval` と組合せ | [EventSummaryInterval](#eventsummaryinterval), [MaxEventQueueDepth](#maxeventqueuedepth) | [cfg-flood-threshold](08-config-procedures.md#cfg-flood-threshold) |
| <span id="eventsummaryinterval">**`EventSummaryInterval`**</span> | summary イベントの flush 間隔（秒）。`EventFloodThreshold` で summary 系を選んだとき有効 | [EventFloodThreshold](#floodthreshold) | [cfg-flood-threshold](08-config-procedures.md#cfg-flood-threshold) |
| <span id="maxeventqueuedepth">**`MaxEventQueueDepth`**</span> | LFA 内部キュー（agent → TEMS / EIF への滞留分）の上限件数。上流が遅延した場合の許容滞留量を決める。超過時は古いイベントから破棄 | [EventFloodThreshold](#floodthreshold) | [cfg-flood-threshold](08-config-procedures.md#cfg-flood-threshold), [inc-event-flood](09-incident-procedures.md#inc-event-flood) |

## 解析・REGEX 系（6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="regex">**REGEX（正規表現）**</span> | `.fmt` の各 `REGEX <name>` ブロック内で、ログ行に当てる正規表現。capture group `( ... )` の値を attribute 割当に使用 | [Format File](#format-file), [Value Specifier](#value-specifier) | [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create) |
| <span id="value-specifier">**Value Specifier**</span> | `.fmt` で attribute へ流す値を指定する記法。`-FILENAME` / `-line` / `-month` / `-day` / `-time` / `PRINTF` 等 | [Format File](#format-file), [Capture Group](#capture-group) | [cfg-attribute-mapping](08-config-procedures.md#cfg-attribute-mapping) |
| <span id="capture-group">**Capture Group（`$1`, `$2`, ...）**</span> | REGEX の `( ... )` 内容を順番に取り出す。attribute 割当の右辺で `msg $1` のように使用 | [REGEX](#regex), [Value Specifier](#value-specifier) | [cfg-attribute-mapping](08-config-procedures.md#cfg-attribute-mapping) |
| <span id="regex-cache">**RegexCache**</span> | LFA agent log に出力される、各 `.fmt` REGEX の hit / miss 統計。`LogfileRegexStatistics` 属性グループでも参照可能 | [Format File](#format-file), [LogfileRegexStatistics](#logfileregexstatistics) | [inc-regex-mismatch](09-incident-procedures.md#inc-regex-mismatch) |
| <span id="catastrophic-backtracking">**Catastrophic Backtracking**</span> | greedy な `(.*)+` / `(a+)+` 等の REGEX が指数的に時間を食う現象。LFA で CPU 高騰の主因 | [REGEX](#regex) | [inc-event-flood](09-incident-procedures.md#inc-event-flood) |
| <span id="newline-handling">**改行ハンドリング（CR/LF/CRLF）**</span> | `.fmt` の REGEX 評価時に行末文字をどう扱うか。Windows 出力ログを UNIX agent で読む等で問題化 | [REGEX](#regex), [NewLinePattern](#newlinepattern) | [inc-regex-mismatch](09-incident-procedures.md#inc-regex-mismatch) |

## 属性グループ（attribute groups、6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="logfileevents">**LogfileEvents**</span> | LFA が生成するイベントの中核属性グループ。`msg` / `EventClass` / `severity` / `timestamp` / `hostname` 等の固定属性 + `.fmt` でマッピングしたカスタム属性 | [Format File](#format-file) | [cfg-attribute-mapping](08-config-procedures.md#cfg-attribute-mapping) |
| <span id="logfileprofileevents">**LogfileProfileEvents**</span> | プロファイル（subnode / 監視対象別）に紐付くイベント。subnode 設計時の参照点 | [Subnode](#subnode), [LogfileEvents](#logfileevents) | [cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi) |
| <span id="logfileregexstatistics">**LogfileRegexStatistics**</span> | 各 `.fmt` REGEX の hit / miss 統計。trend ワークスペースで「動かない REGEX」を可視化 | [RegexCache](#regex-cache), [Format File](#format-file) | [inc-regex-mismatch](09-incident-procedures.md#inc-regex-mismatch) |
| <span id="logfilemonitor">**LogfileMonitor / LogfileFileStatus**</span> | LFA 自身の自己監視属性。監視中ファイルの存在 / サイズ / 最終更新時刻、subnode の可用性 | [Subnode](#subnode) | [cfg-tep-situation](08-config-procedures.md#cfg-tep-situation) |
| <span id="performanceobjectstatus">**PerformanceObjectStatus**</span> | ITM 6.3 共通の自己監視属性グループ。属性収集成否を確認 | [LogfileMonitor](#logfilemonitor) | [inc-tep-no-data](09-incident-procedures.md#inc-tep-no-data) |
| <span id="situation">**Situation**</span> | TEP 上で属性閾値を評価して alert を生成する仕組み。LFA では `LogfileEvents` の `EventClass` / `severity` で発火する situation を組むのが定石 | [TEP](#tep), [LogfileEvents](#logfileevents) | [cfg-tep-situation](08-config-procedures.md#cfg-tep-situation) |

## サブノード / マルチインスタンス（6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="subnode">**Subnode**</span> | 1 LFA エージェントプロセスが扱う複数の独立監視グループ。subnode ごとに `.conf` + `.fmt` ペア。TEP 上で agent name の suffix として表示 | [Configuration file](#conf-file), [CTIRA_SUBSYSTEM_ID](#ctira-subsystem-id) | [cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi) |
| <span id="kfaenv">**`kfaenv`（UNIX）/ レジストリ環境（Windows）**</span> | LFA の Operating Environment 変数定義ファイル。`KBB_RAS1` / `CTIRA_*` / `KDC_FAMILIES` / `LANG` などを設定 | [KBB_RAS1](#kbb-ras1), [CTIRA_HOSTNAME](#ctira-hostname) | [cfg-trace-ras1](08-config-procedures.md#cfg-trace-ras1) |
| <span id="ctira-hostname">**`CTIRA_HOSTNAME`**</span> | TEP に表示される agent ホスト名。OS の `hostname` を上書きしたいときに使う | [CTIRA_SUBSYSTEM_ID](#ctira-subsystem-id) | [cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi) |
| <span id="ctira-subsystem-id">**`CTIRA_SUBSYSTEM_ID`**</span> | subnode 識別子。TEP の agent 名に suffix として付与（例：`hostname:syslog-LO`） | [Subnode](#subnode) | [cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi) |
| <span id="managed-system-list">**Managed System List（MSL）**</span> | TEP / Hub TEMS で agent / subnode をグループ化する管理単位。Situation の配信対象や Workspace 表示の括りに使う | [TEP](#tep), [Subnode](#subnode) | [cfg-subnode-distribute](08-config-procedures.md#cfg-subnode-distribute) |
| <span id="multiple-instances">**Multiple instances（複数インスタンス）**</span> | 物理的に別 agent プロセスで複数 LFA を立てる構成。subnode との違いは「プロセス分離」。重い `.fmt` を持つ環境で安定性確保用 | [Subnode](#subnode) | [cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi) |

## 通信 / 接続系（6 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="kdc-families">**`KDC_FAMILIES`**</span> | TEMS との通信プロトコル指定。`IP.PIPE`（既定、TCP 1918）/ `IP.SPIPE`（SSL、TCP 3660）/ `IP.UDP`（UDP）/ `SNA`（z/OS） | [TEMS](#tems), [Hub TEMS](#hub-tems) | [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect) |
| <span id="ip-pipe">**IP.PIPE**</span> | ITM 既定の TCP プロトコル。port 1918（既定）。multiplexing で agent 多数を 1 port に集約 | [KDC_FAMILIES](#kdc-families) | [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect) |
| <span id="ip-spipe">**IP.SPIPE**</span> | IP.PIPE の SSL 暗号化版。port 3660（既定）。GSKit / iKeyman で証明書管理 | [KDC_FAMILIES](#kdc-families) | [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect) |
| <span id="cms-hostname">**`CMS_HOSTNAME`**</span> | agent が接続する TEMS のホスト名 / IP。`itmcmd config -A lo` の対話で入力 | [TEMS](#tems) | [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect) |
| <span id="kdc-partition">**`KDC_PARTITION`**</span> | NW segment 識別。複数 NW を跨ぐ TEMS 配置で必要 | [KDC_FAMILIES](#kdc-families) | [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect) |
| <span id="heartbeat">**Heartbeat（agent 死活）**</span> | agent → TEMS 方向の生存確認。Hub TEMS の `MS_Offline` Situation で監視 | [TEMS](#tems) | [inc-tems-conn-fail](09-incident-procedures.md#inc-tems-conn-fail) |

## EIF 連携系（8 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="eif">**EIF（Event Integration Facility）**</span> | Tivoli 製品横断のイベント転送プロトコル。LFA は EIF を使って Netcool/OMNIbus 等の receiver にイベント送信 | [EIFServer](#eifserver), [Netcool/OMNIbus](#netcool-omnibus) | [cfg-eif-target](08-config-procedures.md#cfg-eif-target) |
| <span id="eifserver">**`EIFServer` / `EIFPort`**</span> | LFA の `.conf` で指定する EIF receiver の host / port。既定 port は 5529 | [EIFCachePath](#eifcachepath) | [cfg-eif-target](08-config-procedures.md#cfg-eif-target) |
| <span id="eifcachepath">**`EIFCachePath`**</span> | EIF receiver 不通時の永続キャッシュディレクトリ。停止が長引くと肥大化 | [EIFServer](#eifserver) | [inc-eif-cache-stuck](09-incident-procedures.md#inc-eif-cache-stuck) |
| <span id="eifheartbeat">**`EIFHeartbeatInterval`**</span> | EIF receiver への生存確認間隔。failover 構成での切替判定に影響 | [EIFServer](#eifserver) | [cfg-eif-target](08-config-procedures.md#cfg-eif-target) |
| <span id="netcool-omnibus">**Netcool/OMNIbus**</span> | LFA から EIF 中継先となる IBM の中核イベント管理製品。本サイトの [Netcool/OMNIbus 8.1](../netcool-omnibus-8-1/) と連携 | [EIF](#eif), [Probe for Tivoli EIF](#probe-tivoli-eif) | [cfg-eif-target](08-config-procedures.md#cfg-eif-target) |
| <span id="probe-tivoli-eif">**Probe for Tivoli EIF（`nco_p_tivoli_eif`）**</span> | Netcool/OMNIbus 側の EIF 受信器。`tivoli_eif.rules` を介して alerts.status へ整形 | [EIF](#eif), [tivoli-eif-rules](#tivoli-eif-rules) | [cfg-eif-target](08-config-procedures.md#cfg-eif-target) |
| <span id="tivoli-eif-rules">**`tivoli_eif.rules` / `eif_default.rules`**</span> | Probe for Tivoli EIF の rules ファイル。EIF イベント → alerts.status 列マッピング | [Probe for Tivoli EIF](#probe-tivoli-eif) | [cfg-eif-target](08-config-procedures.md#cfg-eif-target) |
| <span id="fqdomain">**`FQDomain`**</span> | EIF 出力時に hostname を FQDN にするか。Netcool 側の dedup 設計に直結 | [EIFServer](#eifserver) | [cfg-fqdomain](08-config-procedures.md#cfg-fqdomain) |

## トレース / 診断系（5 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="kbb-ras1">**`KBB_RAS1`**</span> | RAS1 トレースレベル指定。例：`ERROR (UNIT:klog STATE)` / `ERROR (UNIT:logfile_agent ALL)` | [RAS1](#ras1), [pdcollect](#pdcollect) | [cfg-trace-ras1](08-config-procedures.md#cfg-trace-ras1) |
| <span id="ras1">**RAS1 trace**</span> | ITM 共通のトレース機構。「unit」と「level」で粒度を制御。LFA 側の典型 unit は `klog` / `logfile_agent` | [KBB_RAS1](#kbb-ras1) | [cfg-trace-ras1](08-config-procedures.md#cfg-trace-ras1) |
| <span id="pdcollect">**`pdcollect`**</span> | ITM 共通の診断アーカイブ収集ツール。`$CANDLEHOME/bin/pdcollect`（UNIX）。IBM サポート連携時の標準提出物 | [RAS1](#ras1) | [inc-disk-fill-trace](09-incident-procedures.md#inc-disk-fill-trace) |
| <span id="agent-log">**Agent log**</span> | `$CANDLEHOME/logs/<host>_lo_<timestamp>.log`（UNIX）/ `%CANDLE_HOME%\TMAITM6\logs\` 配下（Windows）。RAS1 の出力先 | [KBB_RAS1](#kbb-ras1) | [inc-agent-down](09-incident-procedures.md#inc-agent-down) |
| <span id="logfilefilestatus">**LogfileFileStatus**</span> | 監視中ファイルごとの最終更新・サイズ・読込位置を保持する内部属性。LFA 自身の自己監視 | [LogfileMonitor](#logfilemonitor) | [inc-rotation-missed](09-incident-procedures.md#inc-rotation-missed) |

## OS / 入力ソース系（5 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="wineventlogs">**`WINEVENTLOGS`**</span> | Windows Event Log の channel リスト指定（`System,Application,Security` 等）。`.fmt` を経由せず標準属性化 | [Configuration file](#conf-file) | [cfg-windows-eventlog](08-config-procedures.md#cfg-windows-eventlog) |
| <span id="unixcommand">**`UnixCommand`**</span> | 標準出力を継続的に読むコマンドソース指定。`tail -F`、`errpt -a`（AIX）、`journalctl -f` 等 | [LogSources](#logsources) | [cfg-pipe-stream](08-config-procedures.md#cfg-pipe-stream) |
| <span id="syslog">**Syslog**</span> | UNIX 系の標準ログ集約機構（rsyslog / syslogd）。LFA は `/var/log/messages*` を読むのが定石 | [LogSources](#logsources) | [uc-syslog-monitor](12-use-cases.md#uc-syslog-monitor) |
| <span id="aix-errlog">**AIX errlog**</span> | AIX のバイナリエラーログ。LFA で扱う場合は `errpt -a` をパイプして `UnixCommand` で読む | [UnixCommand](#unixcommand) | [uc-pipe-source](12-use-cases.md#uc-pipe-source) |
| <span id="rotating-log">**Rotating Log**</span> | ローテートで切り替わるログ。`logrotate` の rename 方式と copytruncate 方式で LFA 側 `FileComparisonMode` の最適値が異なる | [FileComparisonMode](#filecomparisonmode), [LogSources](#logsources) | [cfg-rotation-monitor](08-config-procedures.md#cfg-rotation-monitor) |

## 配備 / 運用系（4 件）

| 用語 | 定義 | 関連用語 | 関連手順 |
|---|---|---|---|
| <span id="itmcmd">**`itmcmd`**</span> | UNIX 上の ITM 共通コマンド。`itmcmd agent {start\|stop\|status} lo` / `itmcmd config -A lo` 等。Windows は MTEMS GUI と `tacmd` で代替 | [tacmd](#tacmd) | [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect) |
| <span id="tacmd">**`tacmd`**</span> | Hub TEMS / TEPS / agent 横断管理 CLI。`tacmd login` → `tacmd listsystems` / `tacmd putfile` / `tacmd addBundles` / `tacmd createNode` / `tacmd configureSystem` 等 | [itmcmd](#itmcmd), [Remote Deploy](#remote-deploy) | [cfg-tacmd-deploy](08-config-procedures.md#cfg-tacmd-deploy) |
| <span id="remote-deploy">**Remote Deploy（agent depot）**</span> | TEMS 上の agent depot に bundle を登録（`tacmd addBundles`）し、`tacmd createNode` / `tacmd installAgent` で agent を遠隔配信する仕組み | [tacmd](#tacmd) | [cfg-tacmd-deploy](08-config-procedures.md#cfg-tacmd-deploy) |
| <span id="mtems">**Manage Tivoli Enterprise Monitoring Services（MTEMS）**</span> | Windows / Linux GUI ツール。agent 構成、サービス制御、history 設定、TEMS 接続情報等を画面操作で実施 | [itmcmd](#itmcmd) | [cfg-agent-config-itmcmd](08-config-procedures.md#cfg-agent-config-itmcmd) |

## 補足：用語の出処

- 大半は **Tivoli Log File Agent Version 6.3 User's Guide（S3）** Chapter 1-7 の記述に基づく
- ITM 共通用語（TEMS / TEPS / TEP / `itmcmd` / `tacmd` / RAS1 / `pdcollect`）は ITM 6.3 Installation and Setup Guide（S2 / S_ITM_INSTALL）と Administrator's Guide（S_ITM_ADMIN）から
- EIF 関連は Netcool/OMNIbus 8.1 / Probe for Tivoli EIF（S_NCO_EIF）と本サイト [Netcool/OMNIbus 8.1](../netcool-omnibus-8-1/) を併読

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
