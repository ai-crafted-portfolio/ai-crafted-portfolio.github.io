# 障害対応手順

> 掲載：**18 件（S/A/B/C × 用途、S 級は A/B/C 仮説分岐付き）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## 重要度 × 用途 マトリクス

<div class="md-typeset__scrollwrap" markdown="1">

| 重要度＼用途 | 起動 / 接続 | イベント取込 | 性能 / 流量 | EIF / Netcool | TEP / 履歴 |
|---|---|---|---|---|---|
| **S** | [inc-agent-down](#inc-agent-down)<br>[inc-tems-conn-fail](#inc-tems-conn-fail) | [inc-events-not-captured](#inc-events-not-captured) | [inc-event-flood](#inc-event-flood) | [inc-eif-not-delivered](#inc-eif-not-delivered) | — |
| **A** | [inc-itmcmd-fail](#inc-itmcmd-fail) | [inc-regex-mismatch](#inc-regex-mismatch)<br>[inc-multiline-broken](#inc-multiline-broken)<br>[inc-rotation-missed](#inc-rotation-missed) | [inc-disk-fill-trace](#inc-disk-fill-trace)<br>[inc-perms-readfail](#inc-perms-readfail) | [inc-eif-cache-stuck](#inc-eif-cache-stuck) | [inc-tep-no-data](#inc-tep-no-data) |
| **B** | [inc-subnode-not-shown](#inc-subnode-not-shown) | [inc-encoding-garbled](#inc-encoding-garbled)<br>[inc-config-bad-syntax](#inc-config-bad-syntax) | — | — | [inc-windows-eventlog-fail](#inc-windows-eventlog-fail) |
| **C** | [inc-cluster-failover-stuck](#inc-cluster-failover-stuck) | — | — | — | — |

</div>

---

## 詳細手順

### inc-agent-down: LFA エージェントが起動しない / 即停止する { #inc-agent-down }

**重要度**: `S` / **用途**: 起動 / 接続

**目的**: `itmcmd agent start lo`（または Windows サービス起動）が失敗、または起動直後に exit する状態の切り分け。

**前提**: agent ホストにログイン可、`$CANDLEHOME/logs/` を読める、`.conf` / `.fmt` を読める。

**仮説分岐**:

_トリガ事象_: `itmcmd agent status lo` が `not running`、または Windows サービス「IBM Tivoli Monitoring Tivoli Log File Agent」が「停止」状態のまま。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | `.conf` / `.fmt` の構文エラー | agent log の最新 200 行に `Failed to parse configuration file` / `Format file syntax error` | 当該 `.conf` / `.fmt` を `.bak` から復旧、または syntax を修正して再起動 |
| **B** | OS リソース / パーミッション | `ls -l $CANDLEHOME/<arch>/lo/bin/`、agent log に `Permission denied` / `Cannot open log file`、`df -h $CANDLEHOME` で空き | パーミッションは ITM 既定（root:bin 700 / 755）を確認。空きがなければ拡張 |
| **C** | 共有ライブラリ依存 / Java 不整合 / OS 互換問題 | UNIX：`ldd $CANDLEHOME/<arch>/lo/bin/klogagent` で missing。Windows：Event Viewer の「アプリケーション」ログ | OS / カーネル / Java を ITM 6.3 互換版に揃える（[11. 対象外](10-out-of-scope.md)）。LFA 単体ではなく ITM 共通コンポーネント側の問題が多い |

_共通の最初の動作_: `$CANDLEHOME/logs/<host>_lo_*.log` の最新 200 行を保存、`itmcmd agent status lo` を 3 回繰り返して結果固定、`ps -ef \| grep -i klog`。

**手順（共通）**:

1. agent log 最新 200 行を確認
2. `cinfo -i`（UNIX）/ MTEMS（Windows）で installed 状態確認
3. `.conf` / `.fmt` を vi / notepad で構文確認（不安なら `.bak` に保管後、空に近い雛形で起動できるか確認）
4. 仮説別に切り分け
5. 修正後、`itmcmd agent start lo` で再起動 → `itmcmd agent status lo` で running 確認

**期待出力**:

正常起動時の agent log：

```
... LogFileAgent: Starting Log File Agent
... LogFileAgent: Configuration file '/opt/IBM/ITM/aix526/lo/syslog.conf' loaded
... LogFileAgent: Format file '...syslog.fmt' loaded with 5 REGEX blocks
... LogFileAgent: Connected to TEMS 'hub01.example.com:1918' via IP.PIPE
... LogFileAgent: Agent ready, monitoring 2 file(s)
```

**検証**: TEP の Managed Systems で agent が緑、`tacmd listsystems -t lo` で対象 host が表示。

**ロールバック**: 直前の `.conf` / `.fmt` 改修を `.bak` から戻して再起動。

**関連**: [cfg-conf-create](08-config-procedures.md#cfg-conf-create), [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create), [inc-config-bad-syntax](#inc-config-bad-syntax)

**出典**: S3, S5, S_ITM_TROUBLE

---

### inc-tems-conn-fail: TEMS への接続失敗（agent は起動するが TEP に出ない） { #inc-tems-conn-fail }

**重要度**: `S` / **用途**: 起動 / 接続

**目的**: `itmcmd agent status lo` は running なのに TEP の Managed Systems に出ない / `tacmd listsystems` で見えない状態の切り分け。

**仮説分岐**:

_トリガ事象_: `itmcmd agent status lo` running、agent log に `Connection refused` / `socket error` / `Connection timeout`、Hub TEMS 側 `<hub>_ms_*.log` に当該 agent の接続要求が見えない。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | `lo.ini` の TEMS 接続情報誤 / hostname 解決失敗 | `cat $CANDLEHOME/config/lo.ini` の `CMS_HOSTNAME`、`nslookup <hub>`、`ping <hub>` | `itmcmd config -A lo` で再設定、または `/etc/hosts` 整備 |
| **B** | ファイアウォール / 1918 / 3660 閉塞 | agent ホストから `telnet <hub> 1918` / `nc -zv <hub> 1918`、Hub TEMS 側 `netstat -an \| grep 1918` で LISTEN 確認 | NW チームと協議、F/W 開放。クラウド環境ならセキュリティグループ |
| **C** | KDC_FAMILIES の protocol 不整合 / SSL 証明書（IP.SPIPE） | `lo.ini` の `KDC_FAMILIES`、Hub TEMS の `KDS_TEMS.config` の `KDC_FAMILIES`、IP.SPIPE 利用時は GSKit 証明書 expiry | `itmcmd config -A lo` で protocol を IP.PIPE に揃える、または証明書 rotate |

_共通の最初の動作_: agent log の最新 200 行から `TEMS` / `socket` / `connect` 関連メッセージ抽出、Hub TEMS 側 `$CANDLEHOME/logs/<hub>_ms_*.log` の同時間帯 200 行を取得。

**手順（共通）**:

1. agent log の TEMS 関連エラー抽出
2. agent ホスト → Hub TEMS への TCP 疎通確認（`telnet` / `nc`）
3. Hub TEMS の `KDS_TEMS.config` の listen port と一致確認
4. 仮説別に対応 → `itmcmd agent restart lo`
5. `tacmd listsystems -t lo` で出現確認

**期待出力**: `tacmd listsystems -t lo` に `host01:KLO` が表示。

**ロールバック**: `lo.ini` を変更前に保管していれば戻して agent restart。

**関連**: [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect), [inc-itmcmd-fail](#inc-itmcmd-fail)

**出典**: S2, S3, S_ITM_TROUBLE, S_ITM_LINUX_TS

---

### inc-events-not-captured: ログには出ているが TEP / Netcool に上がらない { #inc-events-not-captured }

**重要度**: `S` / **用途**: イベント取込

**目的**: 監視対象ログには新行が出ているのに `LogfileEvents` ワークスペースが空、または Netcool 側に何も届かない状態の切り分け。

**仮説分岐**:

_トリガ事象_: 対象ログに `tail -F` で行が見えるが、TEP / Netcool 側でイベント観測なし。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | `.conf` の `LogSources` が対象ファイルを開けていない | agent log に `Cannot open file` / `No matching files for LogSources`、`ls -l <log>` で agent ユーザの read 権限 | `LogSources` の絶対パス / ワイルドカード再確認、ファイル read 権限を agent ユーザへ付与 |
| **B** | `.fmt` の REGEX が一致していない | `LogfileRegexStatistics` の hit 件数（TEP）、agent log の `RegexCache` 統計、テストホストで REGEX 単体検証 | `.fmt` の REGEX を簡易化して切り分け、catch-all を一時追加 |
| **C** | `MaxEventQueueDepth` 飽和 / `EventFloodThreshold` で抑制 / `NumEventsToCatchUp=0` で起動時 skip | `.conf` の現値、agent log に `Queue full` / `Flood threshold reached` メッセージ | 一時的に `EventFloodThreshold=send_all` / `MaxEventQueueDepth` 拡張、起動時は agent restart 後に再現テスト |

_共通の最初の動作_: 対象ログに 1 行追記してから 1 分待って `LogfileEvents` を確認、agent log の最新 200 行を保存。

**手順（共通）**:

1. `LogfileRegexStatistics` をワークスペースで開く（hit が 0 なら REGEX 不一致が濃厚）
2. `.conf` を簡易化（`EventFloodThreshold=send_all`、`NumEventsToCatchUp=-1`）してテスト
3. `.fmt` に catch-all を追加して全行が拾われるか確認
4. 修正後、agent restart で疎通確認

**期待出力**: TEP の `LogfileEvents` ワークスペースに対象行が現れること。

**関連**: [cfg-conf-create](08-config-procedures.md#cfg-conf-create), [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create), [inc-regex-mismatch](#inc-regex-mismatch)

**出典**: S3, S5

---

### inc-event-flood: イベント大量発生 / 流量制御の異常動作 { #inc-event-flood }

**重要度**: `S` / **用途**: 性能 / 流量

**目的**: 同一イベントが大量発生して TEMS / Netcool が過負荷になる、または逆に `EventFloodThreshold` で過抑制されて重要イベントが落ちる、両方向の切り分け。

**仮説分岐**:

_トリガ事象_: TEMS / Netcool 受信側の負荷高騰、または「summary」イベントだけが届く。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | `.fmt` REGEX の catastrophic backtracking で agent CPU 高騰 | agent ホストの `top` で agent プロセス CPU 100%、`.fmt` に `(.*)+` / `(a+)+` 等の重い表現 | REGEX を non-greedy / 文字クラス限定に書換 |
| **B** | `EventFloodThreshold` 設定誤 | `.conf` の `EventFloodThreshold` / `EventSummaryInterval`、agent log の `flood threshold` メッセージ | 適切な閾値（`send_first 100` 等）に再設定。業務 SLA 整合は本サイト範囲外 |
| **C** | `MaxEventQueueDepth` 到達 → 古いイベント破棄 | `.conf` の `MaxEventQueueDepth`、agent log に `Queue full, dropping oldest` | キュー上限を上げる、または上流（TEMS / EIF）の処理速度を上げる |

_共通の最初の動作_: agent ホストで `top -p <pid>` 観測、agent log の最新 500 行で `flood` / `Queue` / `REGEX` メッセージ抽出、Netcool 側 alerts.status の Tally 推移確認。

**手順（共通）**:

1. agent CPU と内部キュー深さを観測
2. `.fmt` の REGEX を `LogfileRegexStatistics` で見て、極端に hit が多い REGEX を特定
3. `EventFloodThreshold` を一時的に緩和して全件届くか確認 → 緩和できないなら REGEX 側を直す
4. agent restart で反映確認

**期待出力**: agent CPU が常時 5-15% 程度、`MaxEventQueueDepth` 到達なし、Netcool 側 dedup（Tally インクリメント）が正常動作。

**関連**: [cfg-flood-threshold](08-config-procedures.md#cfg-flood-threshold), [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create)

**出典**: S3（Chapter 3 / Chapter 8）, S5

---

### inc-eif-not-delivered: EIF が Netcool/OMNIbus に届かない { #inc-eif-not-delivered }

**重要度**: `S` / **用途**: EIF / Netcool

**目的**: LFA 側は agent log に「Sent N events to EIF receiver」と出ているのに、Netcool 側 alerts.status に着信していない。

**仮説分岐**:

_トリガ事象_: agent log 上は EIF 送信成功、Netcool 側 alerts.status に LFA イベントなし、または `nco_p_tivoli_eif` が稼働していない。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | `nco_p_tivoli_eif` 未起動 / Netcool 側障害 | Netcool 側 `ps -ef \| grep -i tivoli_eif`、`nco_p_tivoli_eif` log に `connection refused` / `cannot bind port 5529` | Probe 起動、`nco_postmsg` 等で疎通確認、本サイト [Netcool/OMNIbus 8.1 / 09. cfg-probe-config](../netcool-omnibus-8-1/08-config-procedures.md) 参照 |
| **B** | `tivoli_eif.rules` で reject されている | Probe log の `discarded` / `rejected` メッセージ、`rules` ファイル内の `discard` 文 | `rules` を見直し、必要なら `eif_default.rules` に戻す |
| **C** | ファイアウォール 5529 閉塞 / hostname 解決失敗 | LFA agent ホストから `telnet <eif_host> 5529`、`nslookup <eif_host>` | NW 開放、または `EIFServer` を IP 直書き |

_共通の最初の動作_: agent log の EIF 関連 50 行（`grep -i eif`）、Probe log の同時間帯、Netcool 側 `nco_sql` で `select count(*) from alerts.status where Manager='tivoli_eif'`。

**手順（共通）**:

1. LFA → EIF Probe の TCP 疎通確認
2. Probe ステータス確認、`tivoli_eif.rules` を最小化（`@AlertGroup = "TestEIF"` だけにする）してテスト
3. Netcool 側 alerts.status で receive 確認
4. 仮説別に対応 → 段階的に rules を戻す

**期待出力**: Netcool 側 `select Identifier, Node, Summary, Tally from alerts.status where Manager='tivoli_eif'` で LFA 起源イベントが見える、Tally がインクリメント。

**関連**: [cfg-eif-target](08-config-procedures.md#cfg-eif-target), [inc-eif-cache-stuck](#inc-eif-cache-stuck), 本サイト [Netcool/OMNIbus 8.1 / 09. inc-probe-conn-fail](../netcool-omnibus-8-1/09-incident-procedures.md)

**出典**: S3, S_NCO_EIF, S_NCO_BP, S_NCO_RULES

---

### inc-itmcmd-fail: `itmcmd config -A lo` がエラーで終わる { #inc-itmcmd-fail }

**重要度**: `A` / **用途**: 起動 / 接続

**目的**: 対話プロンプトの最後で「Configuration failed」エラー、または `lo.ini` が壊れて agent 起動できない状態の対処。

**よくある原因 / 対処**:

- **入力した hostname が DNS / `/etc/hosts` で解決できない** → `nslookup` 確認、`/etc/hosts` に追記、または IP 直書き
- **`KDC_PARTITION` 設定が不整合** → 通常は空欄、複数 NW セグメントなら値設定
- **ITM 共通コンポーネントの破損** → `cinfo -i` で installed 整合確認、必要なら ITM 共通 patch を再適用

**手順**:

1. `$CANDLEHOME/config/lo.ini.bak` から復旧（`itmcmd config` は変更前を `.bak` で保管）
2. `itmcmd config -A lo` を再実行、入力値を記録
3. 失敗継続なら IBM サポート連携（[10. inc-disk-fill-trace](#inc-disk-fill-trace) で `pdcollect`）

**関連**: [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect), [inc-tems-conn-fail](#inc-tems-conn-fail)
**出典**: S2, S_ITM_CMD

---

### inc-regex-mismatch: REGEX が期待通り一致しない { #inc-regex-mismatch }

**重要度**: `A` / **用途**: イベント取込

**目的**: 一部の行だけ拾われない / 全く拾われない状態を、REGEX 単体検証で切り分ける。

**よくある原因**:

- greedy `.*` の最長マッチで後続が削れる → non-greedy `.*?` に変更
- 行末 `$` の改行解釈差（Perl PCRE と LFA 内部実装）
- 特殊文字 escape 漏れ（`.`、`(`、`)`、`?`、`+`）
- locale / encoding 不一致（`-utf8` 未指定）

**手順**:

1. **問題行のサンプル 5-10 行を `/tmp/sample.log` に保管**
2. **REGEX を単体テスト**：

    ```bash
    perl -ne 'if (/^([A-Z][a-z]{2} +[0-9]+ [0-9:]+) +(\S+) +(.*?): (.*)$/) { print "MATCH: 1=$1 2=$2 3=$3 4=$4\n" } else { print "NOMATCH: $_" }' /tmp/sample.log
    ```

3. **不一致行が判明したら REGEX 修正** → `.fmt` 反映 → agent restart
4. **`LogfileRegexStatistics` の hit 件数で検証**

**注意点**: PCRE と LFA の REGEX 実装は概ね互換だが、look-behind 等の拡張機能は環境差あり。
**関連**: [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create), [inc-events-not-captured](#inc-events-not-captured)
**出典**: S3, S_PCRE_RFC

---

### inc-multiline-broken: 多行イベントが分裂する { #inc-multiline-broken }

**重要度**: `A` / **用途**: イベント取込

**目的**: Java スタックトレースが 1 行ずつバラバラに上がる状態を直す。

**よくある原因**:

- `NewLinePattern` 未指定 → 1 行 1 イベント既定で分裂
- `NewLinePattern` の REGEX が新行の判定を誤る
- `EventMaxSize` 不足で truncate

**手順**:

1. **サンプルスタック 1 セット**を採取
2. **`NewLinePattern` 候補を REGEX 単体検証**：行頭が「YYYY-MM-DD HH:MM:SS」なら `^[0-9]{4}-[0-9]{2}-[0-9]{2}` のように
3. **`EventMaxSize` を 64KB 程度に拡張**（Java スタック対応）
4. agent restart → サンプル例外を再現してまとまることを確認

**関連**: [cfg-multiline-newline](08-config-procedures.md#cfg-multiline-newline), [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create)
**出典**: S3（Chapter 4）

---

### inc-rotation-missed: ローテーション直後にイベント取り溢し { #inc-rotation-missed }

**重要度**: `A` / **用途**: イベント取込

**目的**: ログローテータの方式と `FileComparisonMode` の不整合を是正。

**手順**:

1. **ローテータ方式判定**：`logrotate.conf` の `copytruncate` の有無、Windows Event Log の Archive 設定
2. **`FileComparisonMode` 選択**：
    - rename 方式 → `CompareSizeAndMtime` または `CompareByAllMatches`
    - copytruncate 方式 → `CompareSize`（既定）で多くは OK だが最後数行が消えやすい
3. **`LogSources` ワイルドカード**：rename なら `messages*` で過去ログも拾う
4. agent restart → ローテをトリガして欠損ゼロ確認

**注意点**: Windows Event Log は `WINEVENTLOGS` 経由なら回転は自動でハンドリングされる。

**関連**: [cfg-rotation-monitor](08-config-procedures.md#cfg-rotation-monitor)
**出典**: S3（Chapter 5）

---

### inc-disk-fill-trace: トレースログでディスクが埋まる { #inc-disk-fill-trace }

**重要度**: `A` / **用途**: 性能 / 流量

**目的**: `KBB_RAS1=ALL` 等の高粒度トレースで `$CANDLEHOME/logs/` が肥大化、`/opt` パーティション枯渇を回避。

**手順**:

1. **緊急対処**：
    - `KBB_RAS1` を `ERROR (UNIT:klog STATE)` に戻す
    - 古い `<host>_lo_*.log` を `gzip` または削除
    - `$CANDLEHOME/logs/` 全体の `du -sh` で残量確認
2. **ローテーション設定**：`KBB_RAS1_LOG_INVENTORY` で個数 / サイズ上限指定
3. **必要分だけ収集**：再現操作前に `KBB_RAS1` 一時昇格 → 操作 → `pdcollect` → 即座に戻す

**注意点**: `pdcollect` 実行時は `/tmp` の容量も確認（数百 MB-GB）。
**関連**: [cfg-trace-ras1](08-config-procedures.md#cfg-trace-ras1), [pdcollect](01-commands.md#pdcollect)
**出典**: S5, S_ITM_AGT_TRC

---

### inc-perms-readfail: ログファイル読込で「Permission denied」 { #inc-perms-readfail }

**重要度**: `A` / **用途**: 性能 / 流量

**目的**: agent ユーザがログファイルを read できない状態の対処。

**手順**:

1. **agent 実行ユーザ確認**：`ps -ef \| grep -i klog` の UID
2. **対象ファイル権限**：`ls -l /var/log/messages` 等
3. **対処パターン**：
    - 対象ファイルを所有グループに agent ユーザを追加（`usermod -a -G adm <itm_user>`）
    - `chmod` で other-read を許可（セキュリティ要件次第）
    - SELinux / AppArmor の context 確認（`ls -Z`、`getenforce`）
4. agent restart → 読込再開を agent log で確認

**注意点**: セキュリティポリシーに反する権限緩和は避け、グループ所属で解決を優先。
**関連**: [cfg-conf-create](08-config-procedures.md#cfg-conf-create)
**出典**: S3, S5

---

### inc-eif-cache-stuck: EIF キャッシュ（`EIFCachePath`）が肥大化 { #inc-eif-cache-stuck }

**重要度**: `A` / **用途**: EIF / Netcool

**目的**: EIF receiver 長時間ダウンに起因するキャッシュ肥大化の対処。

**手順**:

1. **EIF receiver 復旧**：[inc-eif-not-delivered](#inc-eif-not-delivered) で根本対応
2. **キャッシュサイズ確認**：`du -sh <EIFCachePath>`、agent log の EIF flush 状況
3. **長時間ダウンが避けられないなら**：
    - `EIFHeartbeatInterval` を短く（receiver 復旧検知を早く）
    - キャッシュ上限制御（実装制約あり、IBM サポート確認推奨）
4. **キャッシュ手動クリア**：agent 停止 → キャッシュ削除 → agent 起動（**未送信イベントは失う**）

**注意点**: キャッシュ削除はイベントロスを招くため、ロス可否を業務側に確認してから。
**関連**: [cfg-eif-target](08-config-procedures.md#cfg-eif-target), [inc-eif-not-delivered](#inc-eif-not-delivered)
**出典**: S3, S_NCO_EIF

---

### inc-tep-no-data: TEP で agent は緑だが LogfileEvents が空 { #inc-tep-no-data }

**重要度**: `A` / **用途**: TEP / 履歴

**目的**: TEP 表示の「データなし」を Situation / History / TEPS の 3 視点で切り分ける。

**よくある原因**:

- Situation 未配信（MSL 不一致）
- Historical Data Collection 未設定
- TEPS の cache stale（再ログイン / `tacmd refreshTEPSPlugins` で解消する場合あり）

**手順**:

1. リアルタイムワークスペースで `LogfileEvents` テーブルを開く（HD なしでも 1 件は見えるはず）
2. Situation Status / Manage Tivoli Enterprise Monitoring Services で agent 緑確認
3. Historical Data Collection Configuration で `LogfileEvents` 属性グループの収集状態確認
4. 必要なら HD 有効化 → 30 分待って傾向グラフ確認

**関連**: [cfg-tep-situation](08-config-procedures.md#cfg-tep-situation), [cfg-tep-workspace](08-config-procedures.md#cfg-tep-workspace)
**出典**: S_ITM_ADMIN, S_ITM_HD

---

### inc-subnode-not-shown: 一部 subnode が TEP に出ない { #inc-subnode-not-shown }

**重要度**: `B` / **用途**: 起動 / 接続

**目的**: 複数 subnode 構成で 1 つだけ TEP に出ない状態の対処。

**よくある原因**:

- subnode 用 `.conf` の syntax error → agent 全体は起動するが該当 subnode だけ skip
- `kfaenv` の `CTIRA_SUBSYSTEM_ID` 重複
- Managed System List の配信反映待ち

**手順**:

1. agent log で subnode ごとの Configuration loaded メッセージ確認
2. `tacmd listsystems -t lo` で subnode 一覧
3. `.conf` syntax を簡易化、または既知の正常 subnode を雛形に複製してテスト
4. agent restart → 5 分待って TEP 反映

**関連**: [cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi), [cfg-subnode-distribute](08-config-procedures.md#cfg-subnode-distribute)
**出典**: S3（Chapter 5）

---

### inc-encoding-garbled: 日本語 / マルチバイトが文字化け { #inc-encoding-garbled }

**重要度**: `B` / **用途**: イベント取込

**目的**: agent → TEMS → TEPS → 表示の経路でいずれかの codepage 不一致を解消。

**手順**:

1. **対象ログのエンコーディング判定**：`file <log>`、`nkf --guess`（UNIX）
2. **agent 環境変数**：`LANG=ja_JP.UTF-8` 等を `kfaenv` に設定
3. **`.fmt` で `-utf8` 指定**（必要な場合）
4. **TEPS 側 codepage 設定**：MTEMS の Advanced > KFW_REPORT_TERM_BREAK_POINT 周辺
5. **Netcool 側受信ルール**：`tivoli_eif.rules` での再エンコード処理確認

**注意点**: TEMS / TEPS / Netcool すべて同じ codepage に揃える原則。混在環境は技術的に可能だが運用が破綻しやすい。
**関連**: [cfg-conf-create](08-config-procedures.md#cfg-conf-create)
**出典**: S3, S_ITM_TROUBLE

---

### inc-config-bad-syntax: `.conf` / `.fmt` の syntax error で agent 起動失敗 { #inc-config-bad-syntax }

**重要度**: `B` / **用途**: イベント取込

**目的**: 構文エラーをピンポイントで特定して修正。

**手順**:

1. agent log の最新 200 行で `Failed to parse` / `syntax error` メッセージを抽出
2. メッセージに行番号があれば該当箇所、なければ `.bak` と diff で直前変更を特定
3. 雛形 `examples/regex1.conf` / `regex1.fmt` と比較
4. 修正後 `itmcmd agent start lo` で再起動

**よくある syntax mistake**:

- `LogSources` 行で改行が CR/LF 混在
- `REGEX` ブロックの `END` 漏れ
- attribute 行の `$N` 番号誤
- value specifier の `PRINTF` 構文ミス

**関連**: [cfg-conf-create](08-config-procedures.md#cfg-conf-create), [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create)
**出典**: S3

---

### inc-windows-eventlog-fail: Windows Event Log が取れない { #inc-windows-eventlog-fail }

**重要度**: `B` / **用途**: TEP / 履歴

**目的**: `WINEVENTLOGS` 設定でも System / Application / Security チャネルが TEP に来ない状態の対処。

**手順**:

1. **サービスログオンアカウント確認**：services.msc で「IBM Tivoli Monitoring Tivoli Log File Agent」のプロパティ。Security チャネルは `LocalSystem` 必須
2. **`.conf` の `WINEVENTLOGS` 値**確認（チャネル名はカンマ区切り、空白なし）
3. **Event Viewer でチャネル自体に書込があるか**確認
4. **agent log の Windows Event 関連エラー**抽出

**関連**: [cfg-windows-eventlog](08-config-procedures.md#cfg-windows-eventlog)
**出典**: S3（Chapter 5）

---

### inc-cluster-failover-stuck: クラスタ環境で agent ID 衝突 { #inc-cluster-failover-stuck }

**重要度**: `C` / **用途**: 起動 / 接続

**目的**: HACMP / MSCS フェイルオーバ後に「同名 subnode が両方 online」など agent ID 衝突の解消。

**主な原因**:

- 共有 CANDLEHOME 方式で前 active node の agent stop 漏れ
- 個別 CANDLEHOME 方式で `CTIRA_HOSTNAME` を resource hostname と不整合に設定

**手順**:

1. 前 active node で `itmcmd agent status lo` 確認、停止していなければ手動停止
2. cluster resource の start/stop スクリプトを確認、`itmcmd agent stop lo` が `acquire` 解除に組み込まれているか
3. Hub TEMS 側で重複 agent をクリーンアップ（`tacmd cleanms`）
4. 必要なら個別 CANDLEHOME 方式に切替検討（[cfg-cluster-failover](08-config-procedures.md#cfg-cluster-failover)）

**関連**: [cfg-cluster-failover](08-config-procedures.md#cfg-cluster-failover)
**出典**: S3, S_ITM_INSTALL

---

!!! info "本章の品質方針"
    全障害手順は LFA User's Guide Chapter 8（S3）と ITM 6.3 Troubleshooting Guide（S5）の章記述を根拠とする。**業務上の許容ダウンタイム / 復旧手順** は環境依存のため [11. 対象外項目](10-out-of-scope.md) に逃がす。

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
