# コマンド一覧

> 掲載：**42 件（itmcmd / tacmd / agent control / EIF / 診断）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

LFA 6.3 の管理者・SOC・運用設計者が日常的に使う定番コマンドを厳選。本ページでは 6 系統に分類：(A) **agent ライフサイクル（itmcmd）**、(B) **agent 設定（itmcmd config）**、(C) **TEMS / agent 横断（tacmd）**、(D) **agent 遠隔配信（tacmd Remote Deploy）**、(E) **診断 / トレース**、(F) **EIF / Netcool 側関連（参考）**。

UNIX では `itmcmd`、Windows ではサービス制御 + MTEMS GUI が定石。`tacmd` は OS 共通で Hub TEMS にログインして実行。

## 目次

- **(A) agent ライフサイクル（8 件）**: [`itmcmd agent start lo`](#itmcmd-agent-start), [`itmcmd agent stop lo`](#itmcmd-agent-stop), [`itmcmd agent status lo`](#itmcmd-agent-status), [`itmcmd agent restart lo`](#itmcmd-agent-restart), [`itmcmd manage`](#itmcmd-manage), [Windows サービス制御](#windows-service), [`ps -ef \| grep -i klog`](#ps-grep-klog), [Manage Tivoli Enterprise Monitoring Services - MTEMS](#mtems-cmd)
- **(B) agent 設定（8 件）**: [`itmcmd config -A lo`](#itmcmd-config-a-lo), [`itmcmd config -S -t <name>`](#itmcmd-config-st), [`.conf` 編集（直接）](#edit-conf), [`.fmt` 編集（直接）](#edit-fmt), [`itmcmd setperm`](#itmcmd-setperm), [`itmcmd execute`](#itmcmd-execute), [`itmenv`](#itmenv), [`itmcmd support`](#itmcmd-support)
- **(C) TEMS / agent 横断（10 件）**: [`tacmd login`](#tacmd-login), [`tacmd listsystems`](#tacmd-listsystems), [`tacmd listSit`](#tacmd-listsit), [`tacmd viewSit`](#tacmd-viewsit), [`tacmd createSit`](#tacmd-createsit), [`tacmd distributeSit`](#tacmd-distributesit), [`tacmd putfile`](#tacmd-putfile), [`tacmd getfile`](#tacmd-getfile), [`tacmd executeCommand`](#tacmd-executecommand), [`tacmd configureSystem`](#tacmd-configuresystem)
- **(D) agent 遠隔配信（5 件）**: [`tacmd addBundles`](#tacmd-addbundles), [`tacmd listBundles`](#tacmd-listbundles), [`tacmd createNode`](#tacmd-createnode), [`tacmd installAgent`](#tacmd-installagent), [`tacmd removeAgent`](#tacmd-removeagent)
- **(E) 診断 / トレース（6 件）**: [`pdcollect`](#pdcollect), [RAS1 設定（`KBB_RAS1`）](#kbb-ras1-cmd), [agent log の tail](#tail-agent-log), [`itmcmd dbgcmd`](#itmcmd-dbgcmd), [`tail -200`](#tail-200), [`grep -i ERROR / WARN`](#grep-error)
- **(F) EIF / Netcool 側参考（5 件）**: [`nco_p_tivoli_eif`](#nco-p-tivoli-eif), [`nco_p_tivoli_eif -version`](#nco-p-tivoli-eif-version), [`tivoli_eif.rules` 編集](#tivoli-eif-rules-edit), [Netcool 側 alerts.status 確認](#netcool-status-check), [Netcool 側 dedup 確認](#netcool-dedup-check)

---

## (A) agent ライフサイクル

### `itmcmd agent start lo` { #itmcmd-agent-start }
**用途**: LFA agent を起動。

**構文**:

```
$CANDLEHOME/bin/itmcmd agent start lo
```

**典型例**:

```
$ /opt/IBM/ITM/bin/itmcmd agent start lo
Starting Log File Agent ...
Log File Agent started
```

**注意点**: `.conf` / `.fmt` の構文エラーがあると失敗。失敗時は agent log の最新 200 行を確認。
**関連手順**: [cfg-agent-install](08-config-procedures.md#cfg-agent-install), [inc-agent-down](09-incident-procedures.md#inc-agent-down)
**出典**: S3, S_ITM_CMD

### `itmcmd agent stop lo` { #itmcmd-agent-stop }
**用途**: LFA agent を停止。`.conf` / `.fmt` 改修時の標準操作。

**構文**:

```
$CANDLEHOME/bin/itmcmd agent stop lo
```

**注意点**: 停止中のログは「読込位置」を内部状態として保持するが、ローテーション・大量更新中は再起動後の挙動を agent log で要確認。
**関連手順**: [cfg-conf-create](08-config-procedures.md#cfg-conf-create)
**出典**: S3, S_ITM_CMD

### `itmcmd agent status lo` { #itmcmd-agent-status }
**用途**: agent の running / stopped 状態確認。

**構文**:

```
$CANDLEHOME/bin/itmcmd agent status lo
```

**典型例**:

```
$ itmcmd agent status lo
Tivoli Log File Agent ........... is running
```

**関連手順**: [inc-agent-down](09-incident-procedures.md#inc-agent-down)
**出典**: S_ITM_CMD

### `itmcmd agent restart lo` { #itmcmd-agent-restart }
**用途**: stop + start のショートカット。

**注意点**: 「再起動できない」障害時は restart より stop → 状態確認 → start の順で切り分けやすい。
**関連手順**: [cfg-conf-create](08-config-procedures.md#cfg-conf-create)
**出典**: S_ITM_CMD

### `itmcmd manage` { #itmcmd-manage }
**用途**: UNIX 環境で MTEMS 相当の対話 GUI を起動（X11 フォワーディング前提）。

**注意点**: 端末が X 不可なら `itmcmd config` 系コマンドラインで代替。
**出典**: S_ITM_CMD

### Windows サービス制御 { #windows-service }
**用途**: Windows では LFA はサービス「IBM Tivoli Monitoring Tivoli Log File Agent」として登録。`services.msc` または `sc start TIVOLI Log File Agent` 等で制御。

**注意点**: サービスログオンアカウントの権限不足で即停止する事例あり。
**関連手順**: [inc-agent-down](09-incident-procedures.md#inc-agent-down)
**出典**: S3

### `ps -ef \| grep -i klog` { #ps-grep-klog }
**用途**: UNIX 上で agent プロセスの存在 / PID / 起動引数を確認。

**典型例**:

```
$ ps -ef | grep -i klog
itm   12345  1  0 09:00 ?   00:00:01 /opt/IBM/ITM/aix526/lo/bin/klogagent
```

**関連手順**: [inc-agent-down](09-incident-procedures.md#inc-agent-down)
**出典**: S3

### Manage Tivoli Enterprise Monitoring Services - MTEMS { #mtems-cmd }
**用途**: Windows / Linux GUI。agent サービス制御、構成、history 設定、TEMS 接続を画面操作。

**注意点**: 大量 agent 環境では `tacmd` でスクリプト化が現実的。
**出典**: S_ITM_INSTALL

---

## (B) agent 設定

### `itmcmd config -A lo` { #itmcmd-config-a-lo }
**用途**: LFA agent の TEMS 接続情報・通信プロトコル・SECMODE 等を対話で設定。

**構文**:

```
$CANDLEHOME/bin/itmcmd config -A lo
```

**典型例（要点）**:

```
Edit "Log File Agent" settings? [1=Yes, 2=No] (default is 1): 1
Will this agent connect to a TEMS? [1=YES, 2=NO] (default is 1): 1
TEMS Host Name (default is: hub01): hub01.example.com
Network Protocol [ip, ip.pipe, ip.spipe, ip.udp, sna] (default is: ip.pipe): ip.pipe
IP.PIPE Port Number (default is: 1918): 1918
```

**注意点**: 対話で入力した値は `$CANDLEHOME/config/lo.ini` 等に書かれる。再度 `itmcmd config -A lo` で再編集可。
**関連手順**: [cfg-tems-connect](08-config-procedures.md#cfg-tems-connect)
**出典**: S2, S_ITM_CMD

### `itmcmd config -S -t <name>` { #itmcmd-config-st }
**用途**: subnode（タグ付きインスタンス）の追加 / 設定。

**構文**:

```
itmcmd config -S -t <subnode_name> -p <subnode_param_file> lo
```

**注意点**: subnode パラメータファイルの様式は LFA User's Guide Chapter 5 を参照。
**関連手順**: [cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi)
**出典**: S3

### `.conf` 編集（直接） { #edit-conf }
**用途**: `LogSources` / `FormatFile` / `EventFloodThreshold` 等のディレクティブ編集。`vi` / `notepad` で直接編集が標準。

**配置先（既定）**:

```
UNIX:    $CANDLEHOME/<arch>/lo/<agent>.conf  または $CANDLEHOME/config/lo/<subnode>.conf
Windows: %CANDLE_HOME%\TMAITM6\<agent>.conf
```

**注意点**: 編集後は `itmcmd agent stop lo && itmcmd agent start lo` で反映。
**関連手順**: [cfg-conf-create](08-config-procedures.md#cfg-conf-create)
**出典**: S3

### `.fmt` 編集（直接） { #edit-fmt }
**用途**: REGEX パターン + attribute マッピングの編集。

**注意点**: `REGEX` ブロックの順序が結果を左右する。最後に catch-all を置く。
**関連手順**: [cfg-fmt-create](08-config-procedures.md#cfg-fmt-create)
**出典**: S3

### `itmcmd setperm` { #itmcmd-setperm }
**用途**: ITM の運用ユーザ / グループの権限調整（root を使わずに agent 起動を許可する用途）。

**注意点**: setuid 系の挙動を伴うため変更時は IBM サポート確認推奨。
**出典**: S_ITM_CMD

### `itmcmd execute` { #itmcmd-execute }
**用途**: ITM 環境変数を読み込んだ状態で任意コマンドを実行する補助。`pdcollect` の前置等で使用。

**典型例**:

```
itmcmd execute lo "$CANDLEHOME/bin/pdcollect"
```

**関連手順**: [inc-disk-fill-trace](09-incident-procedures.md#inc-disk-fill-trace)
**出典**: S_ITM_CMD

### `itmenv` { #itmenv }
**用途**: ITM 環境変数を現在 shell に注入する shell script。`. $CANDLEHOME/bin/itmenv` で source。

**注意点**: 直接 `itmenv` だけ叩いても何も起きない。必ず `source` する。
**出典**: S_ITM_CMD

### `itmcmd support` { #itmcmd-support }
**用途**: `pdcollect` 系の診断アーカイブ収集ヘルパー。

**関連手順**: [inc-disk-fill-trace](09-incident-procedures.md#inc-disk-fill-trace)
**出典**: S_ITM_CMD

---

## (C) TEMS / agent 横断（tacmd）

### `tacmd login` { #tacmd-login }
**用途**: Hub TEMS にログインして以降の `tacmd` を有効化。

**構文**:

```
tacmd login -s <hub_tems_host> -u <user> -p <password>
```

**注意点**: パスワードを引数に直接書くと履歴に残る。`-p` を省略して対話入力推奨。
**関連手順**: [cfg-tep-situation](08-config-procedures.md#cfg-tep-situation)
**出典**: S_ITM_CMD

### `tacmd listsystems` { #tacmd-listsystems }
**用途**: Hub TEMS に接続している managed system（agent / subnode）を一覧。

**典型例**:

```
$ tacmd listsystems -t lo
Managed System Name              Type    Version  Host Address
host01:KLO                       lo       06.30.04 host01.example.com
host01:syslog-LO                 lo       06.30.04 host01.example.com
```

**関連手順**: [inc-tems-conn-fail](09-incident-procedures.md#inc-tems-conn-fail)
**出典**: S_ITM_CMD

### `tacmd listSit` { #tacmd-listsit }
**用途**: Hub TEMS 上の Situation 一覧。

**注意点**: `LogfileEvents` 属性を参照する situation を絞るときは `-t lo` でフィルタ。
**関連手順**: [cfg-tep-situation](08-config-procedures.md#cfg-tep-situation)
**出典**: S_ITM_CMD

### `tacmd viewSit` { #tacmd-viewsit }
**用途**: Situation の詳細表示（条件式 / 対象 MSL / アクション）。

**関連手順**: [cfg-tep-situation](08-config-procedures.md#cfg-tep-situation)
**出典**: S_ITM_CMD

### `tacmd createSit` { #tacmd-createsit }
**用途**: コマンドラインから Situation を新規作成。

**注意点**: GUI（TEP の Situation Editor）と等価。XML 出力 / インポートで構成管理に乗せやすい。
**関連手順**: [cfg-tep-situation](08-config-procedures.md#cfg-tep-situation)
**出典**: S_ITM_CMD

### `tacmd distributeSit` { #tacmd-distributesit }
**用途**: Situation を Managed System List（MSL）に配信。

**注意点**: 配信失敗時は MSL の整合性と agent の online 状態を確認。
**関連手順**: [cfg-subnode-distribute](08-config-procedures.md#cfg-subnode-distribute)
**出典**: S_ITM_CMD

### `tacmd putfile` { #tacmd-putfile }
**用途**: Hub TEMS から agent ホストへファイル転送（`.conf` / `.fmt` の遠隔配信）。

**典型例**:

```
tacmd putfile -m host01:KLO -s /tmp/syslog.fmt -d /opt/IBM/ITM/aix526/lo/syslog.fmt
```

**関連手順**: [cfg-conf-create](08-config-procedures.md#cfg-conf-create)
**出典**: S_ITM_CMD

### `tacmd getfile` { #tacmd-getfile }
**用途**: agent ホストから Hub TEMS にファイル取得。診断時の `.conf` 一括収集に有用。

**関連手順**: [inc-disk-fill-trace](09-incident-procedures.md#inc-disk-fill-trace)
**出典**: S_ITM_CMD

### `tacmd executeCommand` { #tacmd-executecommand }
**用途**: managed system 上で任意コマンドを実行（agent 経由のリモート実行）。

**注意点**: セキュリティ上、本番では権限を絞る。
**出典**: S_ITM_CMD

### `tacmd configureSystem` { #tacmd-configuresystem }
**用途**: agent 設定をリモートで適用（`itmcmd config -A lo` 相当をリモートから）。

**関連手順**: [cfg-tacmd-deploy](08-config-procedures.md#cfg-tacmd-deploy)
**出典**: S_ITM_CMD

---

## (D) agent 遠隔配信

### `tacmd addBundles` { #tacmd-addbundles }
**用途**: agent depot に LFA bundle を登録。媒体（インストール ISO）から bundle を吸い上げる。

**構文**:

```
tacmd addBundles -i /mnt/itm63/unix -t lo
```

**関連手順**: [cfg-tacmd-deploy](08-config-procedures.md#cfg-tacmd-deploy)
**出典**: S_ITM_DPLY

### `tacmd listBundles` { #tacmd-listbundles }
**用途**: agent depot に登録済の bundle 一覧。

**関連手順**: [cfg-tacmd-deploy](08-config-procedures.md#cfg-tacmd-deploy)
**出典**: S_ITM_DPLY

### `tacmd createNode` { #tacmd-createnode }
**用途**: 対象ホストに OS Agent を遠隔配信して node 化。LFA を入れる前提として OS Agent が動いている必要がある。

**注意点**: SSH / SMB の認証情報を渡す。Firewall / 監査ポリシ要件に注意。
**関連手順**: [cfg-tacmd-deploy](08-config-procedures.md#cfg-tacmd-deploy)
**出典**: S_ITM_DPLY

### `tacmd installAgent` { #tacmd-installagent }
**用途**: depot から指定 node に LFA を遠隔インストール。

**典型例**:

```
tacmd installAgent -t lo -n host01:KUX
```

**関連手順**: [cfg-tacmd-deploy](08-config-procedures.md#cfg-tacmd-deploy)
**出典**: S_ITM_DPLY

### `tacmd removeAgent` { #tacmd-removeagent }
**用途**: 指定 node から LFA を遠隔アンインストール。

**注意点**: agent 停止 → 設定保管 → アンインストールの順を意識。
**出典**: S_ITM_DPLY

---

## (E) 診断 / トレース

### `pdcollect` { #pdcollect }
**用途**: ITM 環境の診断アーカイブ一括収集（agent 設定 / log / 環境変数 / OS 情報）。IBM サポート連携時の標準提出物。

**構文**:

```
$CANDLEHOME/bin/pdcollect
```

**典型例**:

```
$ /opt/IBM/ITM/bin/pdcollect
... (collecting configuration, logs, env vars) ...
Output file: /tmp/pdcollect-host01-20260505-093000.tar.gz
```

**注意点**: 出力先 `/tmp` の容量を事前確認。RAS1 を高粒度にした直後は数百 MB に達する。
**関連手順**: [inc-disk-fill-trace](09-incident-procedures.md#inc-disk-fill-trace)
**出典**: S5, S_ITM_AGT_TRC

### RAS1 設定（`KBB_RAS1`） { #kbb-ras1-cmd }
**用途**: トレースレベル変更。`kfaenv` を編集して agent 再起動。

**典型例**:

```
# In $CANDLEHOME/config/lo.ini (or kfaenv)
KBB_RAS1=ERROR (UNIT:klog STATE)
# Heavy debug:
KBB_RAS1=ERROR (UNIT:logfile_agent ALL)
```

**注意点**: `ALL` は数分でログを GB 級に膨らませるため、収集後すぐに既定レベルへ戻す。
**関連手順**: [cfg-trace-ras1](08-config-procedures.md#cfg-trace-ras1), [inc-disk-fill-trace](09-incident-procedures.md#inc-disk-fill-trace)
**出典**: S3, S_ITM_AGT_TRC

### agent log の tail { #tail-agent-log }
**用途**: 最新の agent log を継続表示。

**典型例**:

```
tail -f $CANDLEHOME/logs/$(hostname)_lo_*.log
```

**注意点**: タイムスタンプ別に複数ファイルが残るため、`ls -tr` で並べて最新を見る。
**関連手順**: [inc-agent-down](09-incident-procedures.md#inc-agent-down)
**出典**: S3

### `itmcmd dbgcmd` { #itmcmd-dbgcmd }
**用途**: ITM 内部 debug コマンドを発行（IBM サポート指示時のみ）。

**注意点**: 一般運用では使わない。
**出典**: S_ITM_TROUBLE

### `tail -200 ... | grep -i ERROR` { #tail-200 }
**用途**: 最新 200 行から ERROR 行だけ抽出する 1 行コマンド。トラブル初動の定石。

**典型例**:

```
tail -200 $CANDLEHOME/logs/$(hostname)_lo_*.log | grep -i 'ERROR\|FATAL\|FAIL'
```

**関連手順**: [inc-agent-down](09-incident-procedures.md#inc-agent-down)

### `grep -i ERROR / WARN` { #grep-error }
**用途**: agent log 全体に対する ERROR / WARN 抽出。長期間運用時の傾向把握。

**注意点**: 件数が多い場合は `awk` で時間別集計。

---

## (F) EIF / Netcool 側参考

LFA 自体のコマンドではないが、EIF 中継先 Netcool/OMNIbus 側で必ず確認するコマンド群。詳細は本サイト [Netcool/OMNIbus 8.1 / 02 コマンド一覧](../netcool-omnibus-8-1/01-commands.md) を参照。

### `nco_p_tivoli_eif` { #nco-p-tivoli-eif }
**用途**: Netcool/OMNIbus 側の EIF Probe 本体。LFA からの EIF イベントをここで受信し、`tivoli_eif.rules` 適用後に alerts.status へ INSERT。

**典型例**:

```
nco_p_tivoli_eif -name eif1 -server NCOMS -propsfile /opt/IBM/tivoli/netcool/omnibus/probes/<arch>/tivoli_eif.props
```

**関連手順**: [cfg-eif-target](08-config-procedures.md#cfg-eif-target), [inc-eif-not-delivered](09-incident-procedures.md#inc-eif-not-delivered)
**出典**: S_NCO_EIF

### `nco_p_tivoli_eif -version` { #nco-p-tivoli-eif-version }
**用途**: Probe 版数確認。LFA 側 EIF 互換確認時の基本情報。

**出典**: S_NCO_EIF

### `tivoli_eif.rules` 編集 { #tivoli-eif-rules-edit }
**用途**: EIF イベント → alerts.status カラムマッピング。Netcool 側の標準サンプルを修正して使用。

**配置先**:

```
$NCHOME/omnibus/probes/<arch>/tivoli_eif.rules
```

**関連手順**: [cfg-eif-target](08-config-procedures.md#cfg-eif-target)
**出典**: S_NCO_RULES

### Netcool 側 alerts.status 確認 { #netcool-status-check }
**用途**: LFA から送られたイベントが Netcool に着いているかの最速確認。

**典型例**:

```
nco_sql -server NCOMS -user root -password ******* <<EOF
select Identifier, Node, Summary, FirstOccurrence, LastOccurrence, Tally
from alerts.status
where AlertGroup = 'LogfileEvents' or Manager like 'tivoli_eif%';
EOF
```

**関連手順**: [inc-eif-not-delivered](09-incident-procedures.md#inc-eif-not-delivered)
**出典**: S_NCO_BP

### Netcool 側 dedup 確認 { #netcool-dedup-check }
**用途**: 同一 LFA イベントが Netcool 側で deduplicate（Tally インクリメント）されているかの確認。`FQDomain` 設定の妥当性検証に使う。

**関連手順**: [cfg-fqdomain](08-config-procedures.md#cfg-fqdomain)
**出典**: S_NCO_BP

---

!!! info "本章の品質方針"
    全コマンドは Tivoli Log File Agent 6.3 User's Guide（S3）と ITM 6.3 Command Reference（S_ITM_CMD）の章記述を根拠とする。**業務上の妥当な使い分け**（pdcollect 取得頻度、RAS1 trace の常用粒度等）は環境依存のため [11. 対象外項目](10-out-of-scope.md) に逃がす。

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
