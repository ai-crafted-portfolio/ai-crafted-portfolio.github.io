# 設定手順

> 掲載：**18 件（S/A/B/C × 用途、S 級は期待出力サンプル付き）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## 重要度 × 用途 マトリクス

<div class="md-typeset__scrollwrap" markdown="1">

| 重要度＼用途 | エージェント設置 | `.conf` / `.fmt` | サブノード | EIF / Netcool | TEP / 監視統合 | 運用補助 |
|---|---|---|---|---|---|---|
| **S** | [cfg-agent-install](#cfg-agent-install)<br>[cfg-tems-connect](#cfg-tems-connect) | [cfg-conf-create](#cfg-conf-create)<br>[cfg-fmt-create](#cfg-fmt-create) | [cfg-subnode-multi](#cfg-subnode-multi) | [cfg-eif-target](#cfg-eif-target) | — | — |
| **A** | [cfg-agent-config-itmcmd](#cfg-agent-config-itmcmd) | [cfg-multiline-newline](#cfg-multiline-newline)<br>[cfg-flood-threshold](#cfg-flood-threshold)<br>[cfg-attribute-mapping](#cfg-attribute-mapping)<br>[cfg-rotation-monitor](#cfg-rotation-monitor) | — | — | [cfg-windows-eventlog](#cfg-windows-eventlog) | [cfg-trace-ras1](#cfg-trace-ras1) |
| **B** | — | [cfg-fqdomain](#cfg-fqdomain) | [cfg-subnode-distribute](#cfg-subnode-distribute) | — | [cfg-tep-situation](#cfg-tep-situation)<br>[cfg-tep-workspace](#cfg-tep-workspace) | — |
| **C** | [cfg-tacmd-deploy](#cfg-tacmd-deploy) | [cfg-pipe-stream](#cfg-pipe-stream) | — | — | — | [cfg-cluster-failover](#cfg-cluster-failover) |

</div>

---

## 詳細手順

### cfg-agent-install: LFA エージェントの新規インストール { #cfg-agent-install }

**重要度**: `S` / **用途**: エージェント設置

**目的**: 監視対象ホストに LFA agent を新規インストールし、`itmcmd agent start lo` で起動できる状態にする。

**前提**: ITM 6.3 配布媒体（インストール ISO / Fix Pack zip）を取得済、対象ホストの `$CANDLEHOME` 領域に十分な空き、root（または ITM 配置用ユーザ）でインストール権限あり、対応 OS / アーキテクチャ確認済（LFA User's Guide の Compatibility report）。

**手順**:

1. **配布物展開**：ISO をマウント、または zip を `/tmp/itm63/` 等に展開。
2. **インストールスクリプト起動**：UNIX 系は `/tmp/itm63/unix/install.sh`、Windows は `D:\WINDOWS\setup.exe` を実行。
3. **コンポーネント選択**：「Tivoli Log File Agent」のみチェック（既存 ITM 環境がある場合は OS Agent と LFA のみ）。
4. **`$CANDLEHOME` 確認**：UNIX は `/opt/IBM/ITM`、Windows は `C:\IBM\ITM` がデフォルト。社内標準があれば従う。
5. **インストール完了**：`/opt/IBM/ITM/<arch>/lo/` 配下に bin / config / examples が展開されたことを確認。
6. **Fix Pack / IF 適用**：必要に応じて 6.3.0-TIV-ITM_LFA-IF0004（S_IF04）等を適用。

**期待出力（実機サンプル）**:

```
$ ls -d /opt/IBM/ITM/aix526/lo/
/opt/IBM/ITM/aix526/lo/

$ ls /opt/IBM/ITM/aix526/lo/
bin  config  examples  hdr

$ /opt/IBM/ITM/bin/cinfo -i
*********** Mon May  5 09:15:00 JST 2026 ******************
User: root  Groups: system bin sys security cron audit lp
Host name : host01.example.com   Installer Lvl:06.30.04.00
CandleHome: /opt/IBM/ITM
...
Tivoli Log File Agent                    lo  06.30.04.00  installed
```

**検証**: `cinfo -i`（UNIX）/ MTEMS（Windows）で「Log File Agent installed」が見えること。

**ロールバック**: アンインストールは UNIX `uninstall.sh`、Windows はコントロールパネル経由。`$CANDLEHOME/<arch>/lo/` だけ手動削除しないこと（cinfo 整合が崩れる）。

**関連**: [cfg-tems-connect](#cfg-tems-connect), [cfg-tacmd-deploy](#cfg-tacmd-deploy)

**出典**: S2, S3, S_ITM_INSTALL, S_IF04

---

### cfg-tems-connect: LFA から Hub TEMS / Remote TEMS への接続設定 { #cfg-tems-connect }

**重要度**: `S` / **用途**: エージェント設置

**目的**: インストール直後の LFA を TEMS に接続し、TEP の Managed Systems 一覧に表示される状態にする。

**前提**: Hub TEMS / Remote TEMS が稼働中、対象ホストから TEMS への 1918/tcp（IP.PIPE）または 3660/tcp（IP.SPIPE）が開いている、TEMS の hostname が DNS / `/etc/hosts` で解決可。

**手順**:

1. **`itmcmd config -A lo` を起動**：

    ```
    /opt/IBM/ITM/bin/itmcmd config -A lo
    ```

2. **対話プロンプト入力**（`Will this agent connect to a TEMS?` から始まる）。
3. **TEMS host name** に Hub TEMS / Remote TEMS の FQDN を入力。
4. **Network Protocol** に `ip.pipe`（既定）を選択、port は **1918**（既定）。SSL なら `ip.spipe` + 3660。
5. **Optional protocols** は通常スキップ（ループバック・サブネット経路の予備）。
6. **保存後、agent を起動**：

    ```
    itmcmd agent start lo
    ```

7. **TEP / TEMS 側で確認**：

    ```
    tacmd login -s hub01.example.com -u sysadmin
    tacmd listsystems -t lo
    ```

**期待出力（実機サンプル）**:

`itmcmd config` の終端：

```
Configuration for "Log File Agent" was completed successfully.
Stop the existing instance for changes to take effect.
```

`tacmd listsystems`：

```
Managed System Name              Type    Version   Host Address
host01:KLO                       lo      06.30.04  host01.example.com
```

**検証**: TEP の Managed Systems で `host01:KLO`（または `<host>:<subsystem>:KLO` 形式）が緑色で見えること。`itmcmd agent status lo` が `running`。

**ロールバック**: `lo.ini` を変更前に保管、または `itmcmd config -A lo` を再実行で別 TEMS に向ける。

**関連**: [cfg-agent-install](#cfg-agent-install), [cfg-subnode-multi](#cfg-subnode-multi), [inc-tems-conn-fail](09-incident-procedures.md#inc-tems-conn-fail)

**出典**: S2, S3, S_ITM_CMD, S_TN_BASIC

---

### cfg-conf-create: `.conf`（Configuration file）の作成 { #cfg-conf-create }

**重要度**: `S` / **用途**: `.conf` / `.fmt`

**目的**: 監視対象ログを指定する `.conf` を作成し、agent に読み込ませる。

**前提**: agent インストール済、TEMS 接続済、監視対象ログのパスが分かっている、agent ユーザがログファイルへの read 権限を持つ。

**手順**:

1. **テンプレートをコピー**：`$CANDLEHOME/<arch>/lo/examples/` 配下の `regex1.conf` / `regex1.fmt` を雛形として `/opt/IBM/ITM/aix526/lo/syslog.conf` にコピー。
2. **必須ディレクティブを記述**：

    ```ini
    LogSources=/var/log/messages*
    FormatFile=/opt/IBM/ITM/aix526/lo/syslog.fmt
    NumEventsToCatchUp=0
    MaxEventQueueDepth=1000
    EventFloodThreshold=send_all
    FileComparisonMode=CompareSize
    ```

3. **任意で EIF を有効化**：

    ```ini
    EIFServer=eifprobe01.example.com
    EIFPort=5529
    EIFCachePath=/var/IBM/ITM/eifcache
    EIFHeartbeatInterval=300
    ```

4. **対応する `.fmt`** を作成（[cfg-fmt-create](#cfg-fmt-create) 参照）。
5. **agent 再起動**：`itmcmd agent stop lo && itmcmd agent start lo`。

**期待出力**:

agent log（`$CANDLEHOME/logs/<host>_lo_*.log`）に：

```
... LogFileAgent: Configuration file '/opt/IBM/ITM/aix526/lo/syslog.conf' loaded.
... LogFileAgent: Monitoring '/var/log/messages' (matched 2 files).
... LogFileAgent: Format file '/opt/IBM/ITM/aix526/lo/syslog.fmt' loaded with 5 REGEX blocks.
```

**検証**: 監視対象ログに 1 行追記して TEP の `LogfileEvents` ワークスペースで反映されること。

**ロールバック**: 元の `.conf` を `.bak` で保存、不具合時は戻して agent 再起動。

**関連**: [cfg-fmt-create](#cfg-fmt-create), [cfg-multiline-newline](#cfg-multiline-newline), [inc-events-not-captured](09-incident-procedures.md#inc-events-not-captured)

**出典**: S3（Chapter 3 Configuration file）

---

### cfg-fmt-create: `.fmt`（Format file）の作成 { #cfg-fmt-create }

**重要度**: `S` / **用途**: `.conf` / `.fmt`

**目的**: REGEX で監視ログ行を解析し、`LogfileEvents` 属性へマッピングする `.fmt` を作成する。

**前提**: 対象ログのサンプル行を 5-10 行手元に揃える、`.conf` 側で `FormatFile` 指定済。

**手順**:

1. **雛形コピー**：`$CANDLEHOME/<arch>/lo/examples/regex1.fmt` をコピー。
2. **REGEX ブロックを定義**：1 ブロック = 1 種類のイベント。

    ```
    REGEX SyslogError
    ^([A-Z][a-z]{2} +[0-9]+ [0-9:]+) +(\S+) +(\S+): (.*)$
    timestamp $1
    hostname $2
    process $3
    msg $4
    severity 4
    -line PRINTF("%s", "originalmsg")
    -FILENAME PRINTF("%s", "filename")
    END
    ```

3. **必要なら catch-all ブロック**を最後に置く：

    ```
    REGEX UnclassifiedSyslog
    ^(.*)$
    msg $1
    severity 6
    END
    ```

4. **手元検証**：Python / Perl でサンプル行に対して REGEX 単体テスト（catastrophic backtracking 回避）。
5. **agent 再起動**で反映。

**期待出力**:

agent log：

```
... LogFileAgent: Format file 'syslog.fmt' loaded with 2 REGEX blocks.
... LogFileAgent: REGEX 'SyslogError' compiled successfully.
... LogFileAgent: REGEX 'UnclassifiedSyslog' compiled successfully.
```

TEP の LogfileEvents で：

| timestamp | hostname | process | msg | severity |
|---|---|---|---|---|
| May  5 10:15:01 | host01 | sshd | Invalid user attacker | 4 |

**検証**: TEP のリアルタイムワークスペースで、対象行が想定 attribute に分解されて表示。`LogfileRegexStatistics` で各 REGEX の hit 件数を確認。

**ロールバック**: 元の `.fmt` を `.bak` で保管、不具合時に戻して agent 再起動。

**関連**: [cfg-attribute-mapping](#cfg-attribute-mapping), [cfg-multiline-newline](#cfg-multiline-newline), [inc-regex-mismatch](09-incident-procedures.md#inc-regex-mismatch)

**出典**: S3（Chapter 4 Format file）, S_PCRE_RFC

---

### cfg-subnode-multi: 1 ホストに複数サブノード（マルチログ群監視） { #cfg-subnode-multi }

**重要度**: `S` / **用途**: サブノード

**目的**: 1 ホストで「syslog 監視」「WebSphere ログ監視」「Db2 db2diag 監視」のような独立グループを subnode で並走させる。

**前提**: agent / TEMS 接続済、各 subnode の `.conf` + `.fmt` ペアを用意済。

**手順**:

1. **subnode 別 `.conf` 配置**：`/opt/IBM/ITM/aix526/lo/syslog.conf`、`websphere.conf`、`db2diag.conf` を作成。
2. **`itmcmd config -S` で subnode 登録**：

    ```
    itmcmd config -S -t syslog -p /tmp/syslog_subnode.parm lo
    itmcmd config -S -t websphere -p /tmp/websphere_subnode.parm lo
    itmcmd config -S -t db2diag -p /tmp/db2diag_subnode.parm lo
    ```

   subnode parameter ファイルには `KFA_CONFIG_FILE` / `CTIRA_SUBSYSTEM_ID` / `CTIRA_HOSTNAME` 等を記述（LFA User's Guide Chapter 5 参照）。

3. **`kfaenv` で subnode ごとに環境分離**（必要なら）。
4. **agent 再起動** → TEP で `host01:syslog-LO` / `host01:websphere-LO` / `host01:db2diag-LO` の 3 subnode が現れることを確認。

**期待出力**:

```
$ tacmd listsystems -t lo
host01:KLO                       lo      06.30.04  host01.example.com
host01:syslog-LO                 lo      06.30.04  host01.example.com
host01:websphere-LO              lo      06.30.04  host01.example.com
host01:db2diag-LO                lo      06.30.04  host01.example.com
```

**検証**: 各 subnode の LogfileEvents ワークスペースが独立に動くこと、Situation の MSL を subnode 別に振り分けられること。

**関連**: [cfg-conf-create](#cfg-conf-create), [cfg-subnode-distribute](#cfg-subnode-distribute), [inc-subnode-not-shown](09-incident-procedures.md#inc-subnode-not-shown)

**出典**: S3（Chapter 5 Customizing the monitoring agent）

---

### cfg-eif-target: Netcool/OMNIbus への EIF 中継設定 { #cfg-eif-target }

**重要度**: `S` / **用途**: EIF / Netcool

**目的**: LFA が生成したイベントを TEMS 経由の通常パスと並行して Netcool/OMNIbus の Probe for Tivoli EIF に送る。

**前提**: Netcool/OMNIbus 8.1 ObjectServer が稼働、`nco_p_tivoli_eif` Probe を起動可能、agent ホストから Probe ホストの `5529/tcp`（既定）が開放、`tivoli_eif.rules` を編集できる権限。

**手順**:

1. **Netcool 側で `nco_p_tivoli_eif` を起動**（本サイト [Netcool/OMNIbus 8.1 / 09. cfg-probe-config](../netcool-omnibus-8-1/08-config-procedures.md) 参照）。
2. **LFA 側 `.conf` に EIF ディレクティブ追加**：

    ```ini
    EIFServer=eifprobe01.example.com
    EIFPort=5529
    EIFCachePath=/var/IBM/ITM/eifcache
    EIFHeartbeatInterval=300
    FQDomain=yes
    EventSource=lfa-host01
    ```

3. **EIF キャッシュディレクトリ作成 + 権限**：`mkdir -p /var/IBM/ITM/eifcache && chown <itm_user> /var/IBM/ITM/eifcache`。
4. **agent 再起動**。
5. **Netcool 側 `tivoli_eif.rules` で alerts.status マッピング**確認：

    ```
    if (match($source, "lfa")) {
        @AlertGroup = "LogfileEvents"
        @Class = 60001
        @Manager = "tivoli_eif"
        @Identifier = $hostname + ":" + $msg
    }
    ```

6. **疎通確認**：手元で 1 行ログを追記、Netcool 側 `nco_sql` で `select * from alerts.status where Manager='tivoli_eif'` で着信確認。

**期待出力**:

agent log：

```
... LogFileAgent: EIF cache opened at '/var/IBM/ITM/eifcache'
... LogFileAgent: EIF heartbeat to 'eifprobe01.example.com:5529' OK
... LogFileAgent: Sent 5 events to EIF receiver
```

Netcool 側 `nco_p_tivoli_eif` log：

```
[Information] G-CON-I-0024: Connected to ObjectServer 'NCOMS' at hostname 'agg01.example.com'
[Information] EIF: Received event from 'lfa-host01' at 'host01.example.com'
```

**検証**: Netcool 側 alerts.status に LFA イベントが INSERT され、`Tally` がインクリメントすること（dedup）。

**ロールバック**: `.conf` の EIF ディレクティブをコメントアウトして agent 再起動。EIF キャッシュは agent 停止後に削除可。

**関連**: [cfg-fqdomain](#cfg-fqdomain), [inc-eif-not-delivered](09-incident-procedures.md#inc-eif-not-delivered), [scn-eif-to-netcool](11-scenarios.md#scn-eif-to-netcool)

**出典**: S3（Chapter 6 Sending events）, S_NCO_EIF, S_NCO_BP, S_NCO_RULES

---

### cfg-agent-config-itmcmd: `itmcmd config` による agent 設定の再編集 { #cfg-agent-config-itmcmd }

**重要度**: `A` / **用途**: エージェント設置

**目的**: TEMS 接続情報、protocol、history collection 設定等を変更する。

**手順**:

1. `itmcmd agent stop lo` で停止。
2. `itmcmd config -A lo` で再編集。
3. `itmcmd agent start lo` で起動。

**注意点**: history collection は TEPS 側 Manage Tivoli Enterprise Monitoring Services / TEP の History Collection Configuration で設定するのが標準（agent 側だけでは完結しない）。

**関連**: [cfg-tems-connect](#cfg-tems-connect), [cfg-tep-workspace](#cfg-tep-workspace)
**出典**: S_ITM_CMD, S_ITM_HD

---

### cfg-multiline-newline: 多行イベント / `NewLinePattern` { #cfg-multiline-newline }

**重要度**: `A` / **用途**: `.conf` / `.fmt`

**目的**: Java スタックトレースや SQL plan のような複数行で 1 イベントを構成するログを正しく束ねる。

**手順**:

1. **`.conf` に `NewLinePattern` を追加**：

    ```ini
    NewLinePattern=^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9:]+
    EventMaxSize=65536
    ```

   この例では「YYYY-MM-DD HH:MM:SS 形式の行頭」を新イベント先頭と判定。

2. **`.fmt` の REGEX は多行を `[\s\S]*?` 等で受ける**：

    ```
    REGEX JavaStackTrace
    ^([0-9-]+ [0-9:]+) +(\S+) +(.*Exception.*)$([\s\S]*)
    timestamp $1
    severity_text $2
    msg $3
    stack_trace $4
    END
    ```

3. agent 再起動 → サンプル例外ログを書き込み、TEP で 1 イベントとしてまとまることを確認。

**注意点**: `EventMaxSize` を超える長大スタックは truncate される。Java の `printStackTrace` 長を見積もって設定。
**関連**: [cfg-fmt-create](#cfg-fmt-create), [inc-multiline-broken](09-incident-procedures.md#inc-multiline-broken)
**出典**: S3（Chapter 4）

---

### cfg-flood-threshold: `EventFloodThreshold` チューニング { #cfg-flood-threshold }

**重要度**: `A` / **用途**: `.conf` / `.fmt`

**目的**: 同一イベント大量発生時の流量制御。Netcool 受信側 / TEMS 過負荷の予防。

**手順**:

1. **`.conf` に閾値設定**：

    ```ini
    EventFloodThreshold=send_first 10
    EventSummaryInterval=300
    ```

   この例：同一イベントが 10 件超え後、5 分（300 秒）ごとに summary イベントだけ送る。

2. **取り得る値**：
    - `send_all` — 既定、無制限。
    - `send_none` — 完全抑制。
    - `send_first <n>` — 最初の n 件だけ送る。
    - `reset_summary` — summary 後に counter リセット。
3. **agent 再起動** → 大量ログを生成して `LogfileEvents` の件数推移を確認。

**注意点**: 業務的妥当値（n の選定）は環境依存、本サイト範囲外（[10. 対象外](10-out-of-scope.md) 参照）。
**関連**: [inc-event-flood](09-incident-procedures.md#inc-event-flood)
**出典**: S3（Chapter 3）

---

### cfg-attribute-mapping: REGEX capture → LogfileEvents 属性マッピング { #cfg-attribute-mapping }

**重要度**: `A` / **用途**: `.conf` / `.fmt`

**目的**: ログ行から抽出した値を `LogfileEvents` の標準属性 / カスタム属性に正しく流す。

**手順**:

1. **標準属性に振る**（`msg` / `severity` / `timestamp` / `hostname` / `process`）。
2. **value specifier を使う**：

    ```
    -FILENAME PRINTF("%s","filename")
    -line PRINTF("%s","originalmsg")
    -month PRINTF("%s","month")
    -day PRINTF("%s","day")
    -time PRINTF("%s","time")
    ```

3. **カスタム属性は ITM 側 attribute group の定義と整合**させる必要あり（標準 LogfileEvents の範囲を超える場合は Agent Builder 領域 = [10. 対象外](10-out-of-scope.md)）。
4. agent 再起動 → TEP で属性が想定通り埋まること確認。

**注意点**: `LogfileEvents` の属性名を間違えると黙って空欄になる。
**関連**: [cfg-fmt-create](#cfg-fmt-create), [inc-regex-mismatch](09-incident-procedures.md#inc-regex-mismatch)
**出典**: S3（Chapter 4 / Chapter 7）

---

### cfg-rotation-monitor: ローテーションログの監視（`FileComparisonMode`） { #cfg-rotation-monitor }

**重要度**: `A` / **用途**: `.conf` / `.fmt`

**目的**: logrotate / Windows Event Log の Archive 等でファイルが切り替わるログを正確に追尾。

**手順**:

1. **ローテータ方式を確認**：
    - **rename 方式**（`messages` → `messages.1`、新 `messages` 作成）：inode が変わる。
    - **copytruncate 方式**：inode は変わらないがサイズが急減する。
2. **`.conf` で適切なモード選択**：

    ```ini
    LogSources=/var/log/messages*
    FileComparisonMode=CompareSizeAndMtime
    ```

   - `CompareSize`（既定）：サイズだけで「同じファイル」判定。copytruncate でサイズが急減した瞬間を切替と認識。
    - `CompareSizeAndMtime`：サイズ + 最終更新時刻。rename 方式に強い。
    - `CompareByAllMatches`：ワイルドカードに完全マッチする全ファイルを別個追尾。
3. **ワイルドカードを工夫**：rename 方式では `messages*` で過去ログも拾える設計。
4. agent 再起動 → ログローテをトリガしてイベント取り溢しが無いことを確認。

**注意点**: copytruncate は最後の数行が失われやすい（ローテータの仕様による）。
**関連**: [inc-rotation-missed](09-incident-procedures.md#inc-rotation-missed)
**出典**: S3（Chapter 3 / Chapter 5）

---

### cfg-windows-eventlog: Windows Event Log 監視（`WINEVENTLOGS`） { #cfg-windows-eventlog }

**重要度**: `A` / **用途**: TEP / 監視統合

**目的**: Windows Event Log の System / Application / Security チャネルを LFA で取り込み、`LogfileEvents` に統一。

**手順**:

1. **`.conf` で `WINEVENTLOGS` を指定**：

    ```ini
    WINEVENTLOGS=System,Application,Security
    ```

   この場合、`LogSources` は不要。`.fmt` も省略可能（標準属性化される）。

2. **必要なら `.fmt` で REGEX 後処理**を追加（既定属性に加えてカスタム抽出）。
3. **サービスログオンアカウント**：Security チャネルを読むには通常 `LocalSystem` が必要。

**注意点**: イベント ID の意味は OS / アプリ依存、業務的解釈は本サイト範囲外。
**関連**: [uc-windows-eventlog](12-use-cases.md#uc-windows-eventlog), [inc-windows-eventlog-fail](09-incident-procedures.md#inc-windows-eventlog-fail)
**出典**: S3（Chapter 5）

---

### cfg-trace-ras1: RAS1 トレース設定（`KBB_RAS1`） { #cfg-trace-ras1 }

**重要度**: `A` / **用途**: 運用補助

**目的**: agent の挙動を詳細追跡し、IBM サポート提出物として `pdcollect` の質を上げる。

**手順**:

1. **既定レベル**：`kfaenv` または `lo.ini` の `KBB_RAS1=ERROR (UNIT:klog STATE)` 程度。
2. **重い debug**：`KBB_RAS1=ERROR (UNIT:logfile_agent ALL)`。
3. **設定後 agent 再起動** → 再現操作 → `pdcollect` で収集 → 既定レベルに戻して再起動。
4. **必ず元に戻す**：`ALL` のままだと数分で GB 級ログ。

**注意点**: 「既定の戻し忘れ」が事故の主因。チケット番号と紐付けて作業記録を残す。
**関連**: [pdcollect](01-commands.md#pdcollect), [inc-disk-fill-trace](09-incident-procedures.md#inc-disk-fill-trace)
**出典**: S3（Chapter 8）, S_ITM_AGT_TRC

---

### cfg-fqdomain: `FQDomain` で hostname を FQDN 化（Netcool dedup 設計） { #cfg-fqdomain }

**重要度**: `B` / **用途**: `.conf` / `.fmt`

**目的**: Netcool 側 alerts.status の `Node` / `Identifier` を一意化し、複数ドメイン環境での dedup 衝突を回避。

**手順**:

1. **`.conf` に追加**：

    ```ini
    FQDomain=yes
    # または明示的にドメイン文字列
    # FQDomain=example.com
    ```

2. agent 再起動 → Netcool 側 `select Node from alerts.status` で FQDN 表示確認。

**注意点**: 既存 dedup 設計を変えるため、本番反映は段階展開推奨（dev → stg → prod）。
**関連**: [cfg-eif-target](#cfg-eif-target)
**出典**: S3（Chapter 6）, S_NCO_BP

---

### cfg-subnode-distribute: Managed System List への subnode 配信 { #cfg-subnode-distribute }

**重要度**: `B` / **用途**: サブノード

**目的**: Hub TEMS / TEP 側で subnode を業務単位（用途・拠点・管理チーム）でグループ化し、Situation を MSL 単位で配信。

**手順**:

1. TEP の Object Editor で MSL 作成（例：`MSL-Syslog-Production`）。
2. `tacmd createMSList -m <MSL名> -t lo` で CLI から作成も可。
3. 当該 subnode を MSL に追加（GUI / CLI）。
4. Situation を `tacmd distributeSit -s <Situation> -m <MSL>` で配信。

**関連**: [cfg-subnode-multi](#cfg-subnode-multi), [cfg-tep-situation](#cfg-tep-situation)
**出典**: S_ITM_ADMIN, S_ITM_CMD

---

### cfg-tep-situation: TEP Situation で LogfileEvents 監視 { #cfg-tep-situation }

**重要度**: `B` / **用途**: TEP / 監視統合

**目的**: 重要な LFA イベントが発生したら TEP / Situation Event Console で alert を発火させる。

**手順**:

1. TEP の Situation Editor → 新規 → `Log File Agent` ナビゲーションから `LogfileEvents` を選択。
2. 条件式：例 `EventClass == 'AppFatalError' AND severity >= 4`。
3. Sampling interval 5 分（業務 SLA に合わせる）、Until 条件で自動 reset の挙動を制御。
4. MSL に配信、enable。
5. テストログを書き込んで Situation が fired し、Event Console に出ること、Until 条件で reset すること確認。

**注意点**: Situation 過多は TEP / TEMS 両方の負荷源。100 個超になったら Compliance 連携 / Netcool 側集約を検討。
**関連**: [cfg-subnode-distribute](#cfg-subnode-distribute), [inc-tep-no-data](09-incident-procedures.md#inc-tep-no-data)
**出典**: S_ITM_ADMIN

---

### cfg-tep-workspace: TEP Workspace + Historical Data 設定 { #cfg-tep-workspace }

**重要度**: `B` / **用途**: TEP / 監視統合

**目的**: LogfileEvents の履歴を可視化し、傾向分析できる workspace を整備。

**手順**:

1. TEP の Workspace Editor で新規 workspace を作成、`Log File Agent` ナビゲーションに紐付け。
2. View として「Table View」「Bar Chart」「Trend Chart」等を配置。
3. **Historical Data Collection 設定**：Manage Tivoli Enterprise Monitoring Services の History Collection Configuration で `LogfileEvents` 属性グループを選択、収集間隔・TEPS 側保持期間・Tivoli Data Warehouse 連携を設定。
4. workspace の time range を「Last 24 hours」等に設定。

**関連**: [cfg-tep-situation](#cfg-tep-situation)
**出典**: S_ITM_ADMIN, S_ITM_HD

---

### cfg-tacmd-deploy: `tacmd` による LFA の遠隔配信 { #cfg-tacmd-deploy }

**重要度**: `C` / **用途**: エージェント設置

**目的**: 多数のホストに LFA を一括配布する。

**手順**:

1. **agent depot に bundle 登録**：

    ```
    tacmd login -s hub01.example.com -u sysadmin
    tacmd addBundles -i /mnt/itm63/unix -t lo
    tacmd listBundles -t lo
    ```

2. **対象ホストに OS Agent を先に配置**：

    ```
    tacmd createNode -h host10.example.com -u root -p ****** -t ux
    ```

3. **LFA を遠隔インストール**：

    ```
    tacmd installAgent -t lo -n host10:KUX
    ```

4. **設定をリモート反映**：

    ```
    tacmd configureSystem -m host10:KLO -p config.parm
    ```

**注意点**: SSH / SMB の認証情報を渡すため、社内セキュリティポリシーに従う。`createNode` 失敗時は対象ホストの SSH / SMB 設定確認。
**関連**: [cfg-agent-install](#cfg-agent-install)
**出典**: S_ITM_DPLY, S_ITM_CMD

---

### cfg-pipe-stream: `UnixCommand` でパイプソース監視 { #cfg-pipe-stream }

**重要度**: `C` / **用途**: `.conf` / `.fmt`

**目的**: ファイルとして存在しないログ（AIX errlog のバイナリ、`journalctl -f`、ネットワーク経由のリモートログ）を `tail`-like なコマンドの標準出力で取り込む。

**手順**:

1. **`.conf` に `UnixCommand` ディレクティブ**：

    ```ini
    UnixCommand=errpt -a
    FormatFile=/opt/IBM/ITM/aix526/lo/aix_errlog.fmt
    ```

   または：

    ```ini
    UnixCommand=journalctl -f -o short-iso
    ```

2. **`.fmt` で出力フォーマットに合わせた REGEX を書く**。
3. agent 再起動。

**注意点**: コマンドが終了するとイベント供給も止まる。`tail -F` 等で常駐するコマンドを使う。コマンド権限（sudo 等）に注意。
**関連**: [cfg-fmt-create](#cfg-fmt-create)
**出典**: S3（Chapter 5）

---

### cfg-cluster-failover: クラスタ環境（HACMP / MSCS）への配置 { #cfg-cluster-failover }

**重要度**: `C` / **用途**: 運用補助

**目的**: フェイルオーバ時に LFA を一意に動かしつつ、両ノードで監視欠損が出ない構成を組む。

**主な選択肢**:

- **共有 CANDLEHOME 方式**：`$CANDLEHOME` を共有 FS に置き、active node でのみ agent 起動。フェイルオーバ時にスクリプトで `itmcmd agent stop lo` → 切替 → `itmcmd agent start lo`。
- **個別 CANDLEHOME 方式**：両ノードに独立配置、Hub TEMS 側で同名 subnode の混在を許容（または別 hostname で識別）。

**注意点**: HACMP / MSCS の設定詳細は [10. 対象外](10-out-of-scope.md)。LFA 側は「停止 → 起動」の手順を cluster resource に組み込めば足りる。
**関連**: [cfg-tems-connect](#cfg-tems-connect)
**出典**: S3（Cluster considerations）, S_ITM_INSTALL

---

!!! info "本章の品質方針"
    全手順は LFA User's Guide（S3）と ITM 6.3 Installation and Setup / Administrator's Guide（S2 / S_ITM_INSTALL / S_ITM_ADMIN）の章記述を根拠とする。**業務上の妥当値**（閾値 / retention / Sampling interval）は環境依存のため [11. 対象外項目](10-out-of-scope.md) に逃がす。

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
