# ユースケース集

> 特定の作業の手順だけ知りたい読者向け。各ユースケースは独立完結、他に依存せず拾い読み可能。

**収録ユースケース**: 30 件

## カテゴリ別目次

- **インストール / 構成（5 件）**: [uc-agent-install](#uc-agent-install), [uc-tems-connect](#uc-tems-connect), [uc-itmcmd-config](#uc-itmcmd-config), [uc-tacmd-deploy](#uc-tacmd-deploy), [uc-cluster-deploy](#uc-cluster-deploy)
- **監視対象設計（5 件）**: [uc-syslog-monitor](#uc-syslog-monitor), [uc-app-log-monitor](#uc-app-log-monitor), [uc-rotating-log](#uc-rotating-log), [uc-windows-eventlog](#uc-windows-eventlog), [uc-pipe-source](#uc-pipe-source)
- **フォーマットファイル（5 件）**: [uc-fmt-write](#uc-fmt-write), [uc-multiline](#uc-multiline), [uc-attribute-map](#uc-attribute-map), [uc-value-specifier](#uc-value-specifier), [uc-summary-event](#uc-summary-event)
- **設定ファイル（4 件）**: [uc-conf-write](#uc-conf-write), [uc-flood-threshold](#uc-flood-threshold), [uc-fqdomain](#uc-fqdomain), [uc-filecomparison](#uc-filecomparison)
- **サブノード / グループ管理（3 件）**: [uc-subnode-create](#uc-subnode-create), [uc-subnode-distribute](#uc-subnode-distribute), [uc-multi-os](#uc-multi-os)
- **TEP / 監視連携（4 件）**: [uc-tep-situation](#uc-tep-situation), [uc-tep-workspace](#uc-tep-workspace), [uc-historical-data](#uc-historical-data), [uc-self-monitor](#uc-self-monitor)
- **EIF / Netcool 連携（2 件）**: [uc-eif-target](#uc-eif-target), [uc-eif-fanout](#uc-eif-fanout)
- **障害対応 / 診断（2 件）**: [uc-trace-collect](#uc-trace-collect), [uc-pdcollect](#uc-pdcollect)

!!! info "本章の品質方針"
    全ユースケースは LFA 6.3 公式マニュアル（S1, S3, S5）と ITM 6.3 関連ドキュメント記載の事実・手順のみで構成。AI が苦手な定性的判断（パラメータの業務的妥当値、運用ノウハウ）は範囲外で注意書きを付ける。

---

## インストール / 構成

### LFA agent のローカルインストール { #uc-agent-install }

**ID**: `uc-agent-install` / **カテゴリ**: インストール / 構成

#### 想定状況

監視対象ホストに LFA agent を新規導入する。Hub TEMS は別環境で稼働中、対象ホストの root 権限あり。

#### 詳細手順

1. ITM 6.3 配布媒体を取得し `/tmp/itm63/` に展開。
2. UNIX：`/tmp/itm63/unix/install.sh` 実行、Windows：`setup.exe` 実行。
3. 「Tivoli Log File Agent」のみチェック。
4. `$CANDLEHOME` を確認（既定 `/opt/IBM/ITM` / `C:\IBM\ITM`）。
5. 完了後 `cinfo -i`（UNIX）/ MTEMS（Windows）で installed 確認。

#### 注意点

OS / カーネル互換は LFA User's Guide の Compatibility report に従う。Fix Pack / Interim Fix（IF04 等）は別タスクで適用。
**関連**: [uc-tems-connect](#uc-tems-connect), [uc-tacmd-deploy](#uc-tacmd-deploy)
**出典**: S2, S3, S_ITM_INSTALL

---

### LFA を Hub TEMS / Remote TEMS に接続 { #uc-tems-connect }

**ID**: `uc-tems-connect` / **カテゴリ**: インストール / 構成

#### 想定状況

インストール直後の LFA を TEMS に接続し、TEP の Managed Systems 一覧に表示される状態にする。

#### 詳細手順

1. `itmcmd config -A lo` 起動。
2. TEMS host name を入力（FQDN）。
3. Network Protocol は `ip.pipe` 既定（SSL なら `ip.spipe`）、port 1918 / 3660。
4. 保存後 `itmcmd agent start lo`。
5. `tacmd login` → `tacmd listsystems -t lo` で表示確認。

#### 注意点

接続先が複数 TEMS の場合、optional protocols で予備パスを指定可能。
**関連**: [uc-itmcmd-config](#uc-itmcmd-config), [scn-new-deployment](11-scenarios.md#scn-new-deployment)
**出典**: S2, S3, S_TN_BASIC

---

### `itmcmd config` で agent 設定を再編集 { #uc-itmcmd-config }

**ID**: `uc-itmcmd-config` / **カテゴリ**: インストール / 構成

#### 想定状況

TEMS 接続情報・protocol・SECMODE を変更する。

#### 詳細手順

1. `itmcmd agent stop lo`
2. `itmcmd config -A lo` で対話再編集
3. `itmcmd agent start lo`

#### 注意点

`lo.ini` は変更前 `.bak` で保管。
**関連**: [uc-tems-connect](#uc-tems-connect)
**出典**: S_ITM_CMD

---

### tacmd による LFA 遠隔配信 { #uc-tacmd-deploy }

**ID**: `uc-tacmd-deploy` / **カテゴリ**: インストール / 構成

#### 想定状況

多数のホストに LFA を一括配布。各ホストに先に OS Agent が入っている前提。

#### 詳細手順

1. `tacmd login -s <hub>` でログイン。
2. `tacmd addBundles -i /mnt/itm63/unix -t lo` で agent depot へ登録。
3. `tacmd installAgent -t lo -n host10:KUX` で対象ホストにインストール。
4. `tacmd configureSystem -m host10:KLO -p config.parm` で初期設定。

#### 注意点

`createNode` は SSH / SMB の認証情報が必要、社内セキュリティポリシー要確認。
**関連**: [uc-agent-install](#uc-agent-install)
**出典**: S_ITM_DPLY, S_ITM_CMD

---

### クラスタ環境への LFA 配置 { #uc-cluster-deploy }

**ID**: `uc-cluster-deploy` / **カテゴリ**: インストール / 構成

#### 想定状況

HACMP / MSCS / VCS / Pacemaker の active-passive クラスタに LFA を入れる。フェイルオーバ時に monitor 切替。

#### 詳細手順

1. 共有 CANDLEHOME か個別 CANDLEHOME か選定。
2. 共有方式：共有 FS に CANDLEHOME を作成 → installer は active node のみ → 他ノードは `cinfo -i` でリンク確認。
3. 個別方式：両ノードで installer 実行、`CTIRA_HOSTNAME` を VIP に統一。
4. cluster resource の start/stop スクリプトに `itmcmd agent start lo` / `itmcmd agent stop lo` を埋め込む。

#### 注意点

cluster ソフト固有の設計は本ドキュメント範囲外（[10. 対象外](10-out-of-scope.md)）。
**関連**: [scn-cluster-monitoring](11-scenarios.md#scn-cluster-monitoring), [cfg-cluster-failover](08-config-procedures.md#cfg-cluster-failover)
**出典**: S3, S_ITM_INSTALL

---

## 監視対象設計

### Linux syslog の監視 { #uc-syslog-monitor }

**ID**: `uc-syslog-monitor` / **カテゴリ**: 監視対象設計

#### 想定状況

`/var/log/messages*` / `/var/log/secure*` を LFA で監視。

#### 詳細手順

1. `.conf`：

    ```ini
    LogSources=/var/log/messages*, /var/log/secure*
    FormatFile=/opt/IBM/ITM/aix526/lo/syslog.fmt
    FileComparisonMode=CompareSizeAndMtime
    ```

2. `.fmt`：syslog 形式（`<MMM DD HH:MM:SS> <host> <process>: <msg>`）の REGEX を 1 ブロック。
3. agent restart。

#### 注意点

`/var/log/secure` は root 限定 read。agent ユーザのグループを `adm` 等に追加。
**関連**: [uc-fmt-write](#uc-fmt-write), [uc-rotating-log](#uc-rotating-log)
**出典**: S3

---

### アプリケーションログの監視（WebSphere / Db2 / Apache 等） { #uc-app-log-monitor }

**ID**: `uc-app-log-monitor` / **カテゴリ**: 監視対象設計

#### 想定状況

ミドルウェアのログを subnode 別に監視。

#### 典型例

| アプリ | LogSources 例 |
|---|---|
| WebSphere | `/opt/IBM/WebSphere/AppServer/profiles/*/logs/*/SystemOut.log*` |
| Apache HTTPD | `/var/log/httpd/access_log*, /var/log/httpd/error_log*` |
| Db2 | `/home/db2inst1/sqllib/db2dump/db2diag.log*` |
| Tomcat | `/var/log/tomcat/catalina.out*` |

#### 詳細手順

1. アプリ別の `.conf` + `.fmt` を作成。
2. subnode で並行運用するなら [uc-subnode-create](#uc-subnode-create) と組合せ。

#### 注意点

ログのフォーマットはアプリ / バージョンで変わる。改修サイクルを業務に組込。
**関連**: [uc-fmt-write](#uc-fmt-write), [uc-multiline](#uc-multiline)
**出典**: S3

---

### ローテーションするログの追尾 { #uc-rotating-log }

**ID**: `uc-rotating-log` / **カテゴリ**: 監視対象設計

#### 想定状況

logrotate / Windows Event Log の Archive 等でファイルが切り替わるログを欠損なく追尾。

#### 詳細手順

1. ローテータ方式判定（rename / copytruncate）。
2. `.conf` の `FileComparisonMode` を選定（rename → `CompareSizeAndMtime`、copytruncate → `CompareSize`）。
3. `LogSources` のワイルドカードを工夫（`messages*` で過去ログも拾う）。
4. agent restart。

#### 注意点

copytruncate は最後数行が消えやすい仕様。
**関連**: [uc-filecomparison](#uc-filecomparison), [inc-rotation-missed](09-incident-procedures.md#inc-rotation-missed)
**出典**: S3

---

### Windows Event Log の監視 { #uc-windows-eventlog }

**ID**: `uc-windows-eventlog` / **カテゴリ**: 監視対象設計

#### 想定状況

Windows Server 上の System / Application / Security チャネルを LFA に取り込み、`LogfileEvents` に統合。

#### 詳細手順

1. `.conf`：

    ```ini
    WINEVENTLOGS=System,Application,Security
    ```

2. サービスログオンアカウントを `LocalSystem` にする（Security チャネル read 用）。
3. `.fmt` は省略可（標準属性化）、必要ならカスタム抽出を追加。

#### 注意点

イベント ID の意味は OS / アプリ依存（業務的解釈は範囲外）。
**関連**: [cfg-windows-eventlog](08-config-procedures.md#cfg-windows-eventlog)
**出典**: S3（Chapter 5）

---

### `UnixCommand` でパイプソース監視 { #uc-pipe-source }

**ID**: `uc-pipe-source` / **カテゴリ**: 監視対象設計

#### 想定状況

ファイルとして存在しないログ（AIX errlog のバイナリ、`journalctl -f`）を `tail` 系コマンドの標準出力で取り込む。

#### 詳細手順

1. `.conf` に `UnixCommand`：

    ```ini
    UnixCommand=errpt -a
    FormatFile=.../aix_errlog.fmt
    ```

2. コマンドが終了するとイベント供給も止まるため、常駐コマンドを使う。

#### 注意点

コマンド権限（sudo 等）に注意。
**関連**: [cfg-pipe-stream](08-config-procedures.md#cfg-pipe-stream)
**出典**: S3（Chapter 5）

---

## フォーマットファイル

### `.fmt` の基本構文を書く { #uc-fmt-write }

**ID**: `uc-fmt-write` / **カテゴリ**: フォーマットファイル

#### 想定状況

新しい監視対象ログ用に `.fmt` を新規作成。

#### 詳細手順

1. `examples/regex1.fmt` をコピー。
2. `REGEX <name>` ブロックを定義：

    ```
    REGEX SyslogError
    ^([A-Z][a-z]{2} +[0-9]+ [0-9:]+) +(\S+) +(\S+): (.*)$
    timestamp $1
    hostname $2
    process $3
    msg $4
    severity 4
    END
    ```

3. catch-all を最後に配置。
4. agent restart で反映。

#### 注意点

REGEX の評価は上から順、最初に一致したブロックが採用。
**関連**: [uc-attribute-map](#uc-attribute-map), [uc-multiline](#uc-multiline)
**出典**: S3（Chapter 4）

---

### 多行イベント / `NewLinePattern` { #uc-multiline }

**ID**: `uc-multiline` / **カテゴリ**: フォーマットファイル

#### 想定状況

Java スタックトレースを 1 イベントとしてまとめて送る。

#### 詳細手順

1. `.conf` に `NewLinePattern=^[0-9]{4}-[0-9]{2}-[0-9]{2}` を追加。
2. `.conf` で `EventMaxSize` を 64KB 程度に拡張。
3. `.fmt` の REGEX は `[\s\S]*?` 等で多行を受ける。

#### 注意点

`EventMaxSize` を超えると truncate。
**関連**: [cfg-multiline-newline](08-config-procedures.md#cfg-multiline-newline)
**出典**: S3（Chapter 4）

---

### REGEX capture → 属性マッピング { #uc-attribute-map }

**ID**: `uc-attribute-map` / **カテゴリ**: フォーマットファイル

#### 想定状況

ログから抽出した値を `LogfileEvents` 標準属性 / カスタム属性に振り分ける。

#### 詳細手順

1. `(.*)` の capture group を `$1` / `$2` / ... で attribute 行に割当。
2. 標準属性（`msg` / `severity` / `hostname` / `process` / `timestamp`）を優先。
3. カスタム属性は ITM 側 attribute group の定義と整合（標準範囲超は Agent Builder 領域 = [10. 対象外](10-out-of-scope.md)）。

#### 注意点

属性名は大文字小文字を含めて完全一致。
**関連**: [uc-fmt-write](#uc-fmt-write)
**出典**: S3（Chapter 4 / Chapter 7）

---

### Value Specifier 活用 { #uc-value-specifier }

**ID**: `uc-value-specifier` / **カテゴリ**: フォーマットファイル

#### 想定状況

`-FILENAME` でファイル名を attribute へ、`-line` で raw 行を別 attribute へ流す。

#### 典型例

```
-FILENAME PRINTF("%s","filename")
-line PRINTF("%s","originalmsg")
-month PRINTF("%s","month")
-day PRINTF("%s","day")
-time PRINTF("%s","time")
```

#### 注意点

`PRINTF` の format 指定子は LFA User's Guide 記載の範囲。
**関連**: [uc-fmt-write](#uc-fmt-write)
**出典**: S3（Chapter 4）

---

### Summary イベントで流量制御 { #uc-summary-event }

**ID**: `uc-summary-event` / **カテゴリ**: フォーマットファイル

#### 想定状況

同一イベントが大量発生時に summary だけを送る。

#### 詳細手順

1. `.conf`：

    ```ini
    EventFloodThreshold=send_first 10
    EventSummaryInterval=300
    ```

2. agent restart。

#### 注意点

業務 SLA に応じた n / interval の選定は範囲外。
**関連**: [cfg-flood-threshold](08-config-procedures.md#cfg-flood-threshold)
**出典**: S3（Chapter 3）

---

## 設定ファイル

### `.conf` の基本構文を書く { #uc-conf-write }

**ID**: `uc-conf-write` / **カテゴリ**: 設定ファイル

#### 詳細手順

1. `examples/regex1.conf` をコピー。
2. 必須：`LogSources` / `FormatFile`。
3. 任意：`NumEventsToCatchUp` / `MaxEventQueueDepth` / `EventFloodThreshold` / `FileComparisonMode` / `EIFServer` 等。
4. agent restart で反映。

**関連**: [uc-fmt-write](#uc-fmt-write), [cfg-conf-create](08-config-procedures.md#cfg-conf-create)
**出典**: S3（Chapter 3）

---

### `EventFloodThreshold` 設計 { #uc-flood-threshold }

**ID**: `uc-flood-threshold` / **カテゴリ**: 設定ファイル

#### 想定状況

同一イベント大量発生時に上流（TEMS / EIF）が落ちないよう抑制。

#### 詳細手順

`.conf` に `EventFloodThreshold=send_first <n>` + `EventSummaryInterval=<秒>`。

#### 注意点

n の選定は範囲外。
**関連**: [cfg-flood-threshold](08-config-procedures.md#cfg-flood-threshold)
**出典**: S3

---

### `FQDomain` で hostname を FQDN 化 { #uc-fqdomain }

**ID**: `uc-fqdomain` / **カテゴリ**: 設定ファイル

#### 想定状況

複数ドメイン環境で Netcool 側の dedup を一意にする。

#### 詳細手順

`.conf` に `FQDomain=yes` または `FQDomain=example.com`。

#### 注意点

既存 dedup 設計の変更を伴うため段階展開。
**関連**: [cfg-fqdomain](08-config-procedures.md#cfg-fqdomain)
**出典**: S3, S_NCO_BP

---

### `FileComparisonMode` 選定 { #uc-filecomparison }

**ID**: `uc-filecomparison` / **カテゴリ**: 設定ファイル

#### 想定状況

ログローテータの方式に合わせて agent 側 file 同定を調整。

#### 詳細手順

- rename 方式 → `CompareSizeAndMtime` または `CompareByAllMatches`
- copytruncate 方式 → `CompareSize`（既定）

**関連**: [uc-rotating-log](#uc-rotating-log), [inc-rotation-missed](09-incident-procedures.md#inc-rotation-missed)
**出典**: S3

---

## サブノード / グループ管理

### subnode の作成 { #uc-subnode-create }

**ID**: `uc-subnode-create` / **カテゴリ**: サブノード / グループ管理

#### 想定状況

1 ホストで 3 種類のログ群を独立 subnode で監視。

#### 詳細手順

1. subnode 別の `.conf` + `.fmt` ペア作成。
2. `itmcmd config -S -t <subnode> -p <param>` で登録。
3. agent restart → TEP に `host01:syslog-LO` / `host01:websphere-LO` が出る。

**関連**: [scn-multi-subnode](11-scenarios.md#scn-multi-subnode), [cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi)
**出典**: S3（Chapter 5）

---

### subnode を Managed System List に振り分け { #uc-subnode-distribute }

**ID**: `uc-subnode-distribute` / **カテゴリ**: サブノード / グループ管理

#### 想定状況

業務単位の MSL（例：`MSL-Syslog-Production`）を作成し、subnode を振り分けて Situation を一括配信。

#### 詳細手順

1. TEP の Object Editor で MSL 作成。
2. subnode を MSL に追加。
3. `tacmd distributeSit -s <Sit> -m <MSL>` で配信。

**関連**: [uc-tep-situation](#uc-tep-situation), [cfg-subnode-distribute](08-config-procedures.md#cfg-subnode-distribute)
**出典**: S_ITM_ADMIN, S_ITM_CMD

---

### マルチ OS 環境（Linux + Windows + AIX） { #uc-multi-os }

**ID**: `uc-multi-os` / **カテゴリ**: サブノード / グループ管理

#### 想定状況

3 OS の LFA を 1 つの Hub TEMS で集約管理。

#### 詳細手順

1. 各 OS で LFA を ITM 6.3 互換版でインストール。
2. すべて同じ Hub TEMS に向ける。
3. MSL は OS 別 + 業務別の 2 軸で設計（例：`MSL-Linux-WebApp`、`MSL-Win-AD`）。
4. Situation は OS 共通の `LogfileEvents` 属性で書く（OS 固有部分は subnode 別 `.fmt` でカバー）。

**関連**: [uc-subnode-distribute](#uc-subnode-distribute)
**出典**: S2, S3

---

## TEP / 監視連携

### TEP Situation で重要イベントに警報 { #uc-tep-situation }

**ID**: `uc-tep-situation` / **カテゴリ**: TEP / 監視連携

#### 想定状況

`severity >= 4` の LogfileEvents が来たら Situation Event Console に出す。

#### 詳細手順

1. TEP Situation Editor で新規 → `LogfileEvents` を attribute 元に。
2. 条件式：`severity >= 4`。
3. Sampling interval / Until 条件を設定 → MSL に配信、enable。

**関連**: [cfg-tep-situation](08-config-procedures.md#cfg-tep-situation)
**出典**: S_ITM_ADMIN

---

### TEP Workspace カスタマイズ { #uc-tep-workspace }

**ID**: `uc-tep-workspace` / **カテゴリ**: TEP / 監視連携

#### 想定状況

業務単位の Workspace を作って Bar Chart / Trend で可視化。

#### 詳細手順

1. Workspace Editor で新規 Workspace。
2. View 配置（Table / Bar Chart / Trend）。
3. `LogfileEvents` 属性をクエリに紐付け。
4. Workspace を Managed System List に紐付けて保存。

**関連**: [uc-historical-data](#uc-historical-data)
**出典**: S_ITM_ADMIN, S_ITM_HD

---

### Historical Data の収集 { #uc-historical-data }

**ID**: `uc-historical-data` / **カテゴリ**: TEP / 監視連携

#### 想定状況

LogfileEvents の履歴を Trend Chart で可視化。

#### 詳細手順

1. MTEMS の History Collection Configuration で `LogfileEvents` を選択。
2. 収集間隔（5 分 / 15 分等）と TEPS 側保持期間を設定。
3. 必要なら Tivoli Data Warehouse 連携（[10. 対象外](10-out-of-scope.md)）。

**関連**: [cfg-tep-workspace](08-config-procedures.md#cfg-tep-workspace)
**出典**: S_ITM_HD

---

### LFA agent 自己監視 Situation { #uc-self-monitor }

**ID**: `uc-self-monitor` / **カテゴリ**: TEP / 監視連携

#### 想定状況

LFA agent 自身がダウンしたら検知できるようにする。

#### 詳細手順

1. **`MS_Offline` Situation を有効化**（Hub TEMS 共通）。
2. **`LogfileMonitor` / `LogfileFileStatus` 属性で監視ファイルの最終更新時刻が止まっていないか監視**：

    ```
    LogfileFileStatus.LastModifiedTime older than 1 hour
    ```

3. 該当 Situation を当該 MSL に配信。

#### 注意点

時刻ズレ環境では false-positive 注意。
**関連**: [uc-tep-situation](#uc-tep-situation)
**出典**: S3, S_ITM_ADMIN

---

## EIF / Netcool 連携

### Netcool/OMNIbus へ EIF 送信 { #uc-eif-target }

**ID**: `uc-eif-target` / **カテゴリ**: EIF / Netcool 連携

#### 想定状況

LFA イベントを Netcool/OMNIbus の Probe for Tivoli EIF に送る。

#### 詳細手順

1. `.conf`：

    ```ini
    EIFServer=eifprobe01.example.com
    EIFPort=5529
    EIFCachePath=/var/IBM/ITM/eifcache
    EIFHeartbeatInterval=300
    ```

2. キャッシュディレクトリ作成 + 権限。
3. agent restart → Netcool 側 alerts.status で着信確認。

**関連**: [scn-eif-to-netcool](11-scenarios.md#scn-eif-to-netcool), [cfg-eif-target](08-config-procedures.md#cfg-eif-target)
**出典**: S3, S_NCO_EIF

---

### EIF を 2 系統 receiver に並行送信 { #uc-eif-fanout }

**ID**: `uc-eif-fanout` / **カテゴリ**: EIF / Netcool 連携

#### 想定状況

主 / 副の 2 つの EIF receiver に送って高可用化、または production / siem の 2 系統 fanout。

#### 詳細手順

1. `.conf` で 2 つ目の receiver 指定（実装制約あり、LFA User's Guide Chapter 6 を確認）。あるいは：
2. **代替案**：Netcool 側で `nco_p_tivoli_eif` から別 ObjectServer / SIEM へ Gateway で並行転送（本サイト [Netcool/OMNIbus 8.1](../netcool-omnibus-8-1/) 側で扱う）。

#### 注意点

LFA 側で multi-target を直接書けない場合は Netcool 側 fanout が現実解。
**関連**: [scn-eif-to-netcool](11-scenarios.md#scn-eif-to-netcool)
**出典**: S3, S_NCO_BP

---

## 障害対応 / 診断

### RAS1 トレース取得 { #uc-trace-collect }

**ID**: `uc-trace-collect` / **カテゴリ**: 障害対応 / 診断

#### 想定状況

agent の挙動を詳細追跡。

#### 詳細手順

1. `kfaenv` で `KBB_RAS1=ERROR (UNIT:logfile_agent ALL)` に昇格。
2. agent restart → 再現操作。
3. agent log を保存後、即座に既定 `KBB_RAS1=ERROR (UNIT:klog STATE)` に戻す。

#### 注意点

`ALL` 放置は数分で GB 級ログ。
**関連**: [uc-pdcollect](#uc-pdcollect), [cfg-trace-ras1](08-config-procedures.md#cfg-trace-ras1)
**出典**: S5, S_ITM_AGT_TRC

---

### `pdcollect` で診断アーカイブ取得 { #uc-pdcollect }

**ID**: `uc-pdcollect` / **カテゴリ**: 障害対応 / 診断

#### 想定状況

IBM サポートチケット起票時の標準提出物作成。

#### 詳細手順

1. `$CANDLEHOME/bin/pdcollect` を実行。
2. 出力 `tar.gz` をサポートに送付。

#### 注意点

`/tmp` 容量を事前確認、RAS1 を事前に上げてから取得すると有用な情報が増える。
**関連**: [uc-trace-collect](#uc-trace-collect), [pdcollect](01-commands.md#pdcollect)
**出典**: S5, S_ITM_AGT_TRC

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
