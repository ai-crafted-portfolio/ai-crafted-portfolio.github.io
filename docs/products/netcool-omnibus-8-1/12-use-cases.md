# ユースケース集

> 特定の作業の手順だけ知りたい読者向け。各ユースケースは独立完結、他に依存せず拾い読み可能。

**収録ユースケース**: 30 件

## カテゴリ別目次

- **インストール / 起動準備**（5 件）: [uc-im-install](#uc-im-install), [uc-netcool-user-create](#uc-netcool-user-create), [uc-omni-dat-edit](#uc-omni-dat-edit), [uc-objserv-create](#uc-objserv-create), [uc-pa-deploy](#uc-pa-deploy)
- **状態確認 / 日常運用**（4 件）: [uc-display-status](#uc-display-status), [uc-trigger-tune](#uc-trigger-tune), [uc-config-backup](#uc-config-backup), [uc-disable-details](#uc-disable-details)
- **Probe 配置**（5 件）: [uc-probe-syslog](#uc-probe-syslog), [uc-probe-snmp](#uc-probe-snmp), [uc-probe-eif](#uc-probe-eif), [uc-probe-glf](#uc-probe-glf), [uc-rules-edit](#uc-rules-edit)
- **Gateway / SMAC**（5 件）: [uc-failover-pair](#uc-failover-pair), [uc-virtual-server-name](#uc-virtual-server-name), [uc-smac-collection](#uc-smac-collection), [uc-smac-display](#uc-smac-display), [uc-confpack-import](#uc-confpack-import)
- **AEN / 自動化**（3 件）: [uc-aen-enable](#uc-aen-enable), [uc-trigger-deploy-custom](#uc-trigger-deploy-custom), [uc-signal-define](#uc-signal-define)
- **Web GUI / WAAPI**（3 件）: [uc-webgui-datasource](#uc-webgui-datasource), [uc-webgui-load-views](#uc-webgui-load-views), [uc-waapi-user-create](#uc-waapi-user-create)
- **セキュリティ**（3 件）: [uc-ssl-objserv](#uc-ssl-objserv), [uc-fips-mode](#uc-fips-mode), [uc-user-create](#uc-user-create)
- **支援 / Proxy / 連携**（2 件）: [uc-proxy-deploy](#uc-proxy-deploy), [uc-scala-link](#uc-scala-link)

!!! info "本章の品質方針"
    全ユースケースは IBM Netcool/OMNIbus 8.1 公式マニュアル + Best Practices Guide v1.3 記載の事実・手順のみで構成。AI が苦手な定性的判断（パラメータの業務的妥当値、運用ノウハウ）は範囲外で注意書きを付ける。

---

## インストール / 起動準備

### IBM Installation Manager で OMNIbus 本体を入れる { #uc-im-install }

**ID**: `uc-im-install` / **カテゴリ**: インストール / 起動準備

#### 想定状況

新規ホストに OMNIbus 8.1 を入れたい。

#### 前提条件

- IBM Installation Manager（IM）が配置済 / インストール可
- IBM ID（パスポート）あり、または社内 fix repo あり
- root 権限（または sudo）

#### 詳細手順

1. **IM 起動**

    ```
    cd /opt/IBM/InstallationManager/eclipse
    ./IBMIM
    ```

2. **リポジトリ登録**：File → Preferences → Repositories で OMNIbus / Web GUI / Probe 用 repo を追加。
3. **インストール**：Install → 「IBM Tivoli Netcool/OMNIbus 8.1」を選択 → Path を `/opt/IBM/tivoli/netcool` に → Next → 完了。
4. **環境変数設定**：`/etc/profile.d/netcool.sh` に：

    ```
    export NCHOME=/opt/IBM/tivoli/netcool
    export OMNIHOME=$NCHOME/omnibus
    export PATH=$OMNIHOME/bin:$PATH
    ```

#### 検証

`$OMNIHOME/bin/nco_check_install` で整合性確認。

#### バリエーション

interim fix / fix pack 適用も IM 経由（Update / Modify）。Probe / Gateway は IM ではなく **個別ダウンロード + install.txt** に従うのが OMNIbus の流儀。

#### 注意点

ライセンス系操作は商用契約領域。本ユースケースの範囲外。

#### 関連ユースケース

[uc-netcool-user-create](#uc-netcool-user-create), [uc-objserv-create](#uc-objserv-create)

**出典**: S_OMN_DEPLOY, S_OMN_QSG, S_INSTALL_MANAGER

---

### netcool ユーザを作成して OMNIbus を root 以外で起動 { #uc-netcool-user-create }

**ID**: `uc-netcool-user-create` / **カテゴリ**: インストール / 起動準備

#### 想定状況

OMNIbus を本番で root で起動するのを避けたい。Best Practices v1.3 推奨の `netcool` ユーザでの起動。

#### 詳細手順

1. **OS ユーザ作成**

    ```
    sudo useradd -m -d /home/netcool -s /bin/bash netcool
    sudo passwd netcool
    ```

2. **`$NCHOME` 配下の所有者変更**

    ```
    sudo chown -R netcool:netcool /opt/IBM/tivoli/netcool
    ```

3. **systemd unit などを netcool ユーザ起動に**：[uc-pa-deploy](#uc-pa-deploy) を参照。

#### 注意点

UDP 162（SNMP Trap）等の特権ポートを使う Probe（[uc-probe-snmp](#uc-probe-snmp)）では `setcap` または PA 経由 root 起動が必要なケースがある。

#### 関連ユースケース

[uc-pa-deploy](#uc-pa-deploy), [uc-probe-snmp](#uc-probe-snmp)

**出典**: S_OMN_BP（Chapter 10）

---

### omni.dat の編集と interfaces ファイル生成 { #uc-omni-dat-edit }

**ID**: `uc-omni-dat-edit` / **カテゴリ**: インストール / 起動準備

#### 想定状況

新規 ObjectServer / Process Agent / Proxy を追加して、Probe / Gateway / nco_sql から到達できるようにしたい。

#### 詳細手順

1. **omni.dat 編集**（`$NCHOME/etc/omni.dat`）

    ```
    [NCOMS]
        {
            Primary: ncohost1 4100
        }
    [AGG_V]
        {
            Primary: aggp_host 4100
            Backup: aggb_host 4100
        }
    [NCO_PA]
        {
            Primary: ncohost1 4200
        }
    ```

2. **interfaces 再生成**

    ```
    $NCHOME/bin/nco_xigen
    ```

3. **接続テスト**

    ```
    $OMNIHOME/bin/nco_sql -server NCOMS -username root
    ```

#### バリエーション

IPv6 利用時は `Primary: [2001:db8::10] 4100` のように `[]` で囲む。

#### 注意点

Probe / Gateway / nco_sql で **異なる omni.dat を見ていないか**は接続トラブル時の最初の確認点。

#### 関連ユースケース

[uc-objserv-create](#uc-objserv-create), [uc-virtual-server-name](#uc-virtual-server-name)

**出典**: S_OMN_ADMIN, S_OMN_BP

---

### ObjectServer の新規作成と起動 { #uc-objserv-create }

**ID**: `uc-objserv-create` / **カテゴリ**: インストール / 起動準備

#### 想定状況

新規 ObjectServer インスタンス（NCOMS 等）を作って Probe を繋げる準備。

#### 詳細手順

1. **`nco_dbinit -server <name>` で DB ファイル群作成**
2. **omni.dat にエントリ + nco_xigen** → [uc-omni-dat-edit](#uc-omni-dat-edit)
3. **プロパティファイル準備**（[02. 設定値](02-settings.md) 参照）
4. **手動起動 → 確認**：`nco_objserv -name <name>` → `nco_sql` 接続テスト
5. **PA 配下化** → [uc-pa-deploy](#uc-pa-deploy)

#### 期待出力

`I-OBJ-100-029: NCOMS: ObjectServer started, listening on port 4100.`

#### バリエーション

SMAC（Collection / Aggregation / Display）構築時は `nco_dbinit -customsql collection.sql` 等で SMAC 用 SQL を初期投入できる。

#### 関連ユースケース

[uc-omni-dat-edit](#uc-omni-dat-edit), [uc-pa-deploy](#uc-pa-deploy), [uc-trigger-tune](#uc-trigger-tune)

**出典**: S_OMN_BP, S_OMN_QSG

---

### Process Agent（nco_pad）配置と systemd 統合 { #uc-pa-deploy }

**ID**: `uc-pa-deploy` / **カテゴリ**: インストール / 起動準備

#### 想定状況

OMNIbus 関連プロセスを OS 起動時に自動起動 + 障害時に自動再起動したい。

#### 詳細手順

1. **PA プロパティ準備**（`$OMNIHOME/etc/<PA>.props`）：`Authenticate=PAM`、`SecureMode=TRUE`
2. **process entries 定義**：ObjectServer / Probe / Gateway 各々を `process <name> '<command>' "<user>" autostart yes` で登録
3. **systemd unit 配置**（[08. cfg-pa-deploy](08-config-procedures.md#cfg-pa-deploy) のサンプル）
4. **`systemctl enable --now nco_pa`**
5. **`nco_pa_status -server <PA>` で配下確認**

#### 期待出力

```
PA name = NCO_PA, host = ncohost1
Process              Status      PID    Last Started
AGG_P_OBJSERV        RUNNING     12345  2026-04-01 10:00:00
SYSLOG_PROBE         RUNNING     12347  2026-04-01 10:00:02
```

#### 注意点

systemd の `Restart=on-failure` と PA 自身の `autostart yes` が二重に効くため、停止 / 起動の操作は systemd 経由に統一するのが事故が少ない。

#### 関連ユースケース

[uc-objserv-create](#uc-objserv-create), [uc-netcool-user-create](#uc-netcool-user-create)

**出典**: S_OMN_BP（Chapter 10）, S_OMN_PA, S_SYSTEMD

---

## 状態確認 / 日常運用

### 状態確認の定番（行数 / Severity 分布 / trigger 状態） { #uc-display-status }

**ID**: `uc-display-status` / **カテゴリ**: 状態確認 / 日常運用

#### 想定状況

毎朝 / シフト交代の状態確認ルーチン。

#### 詳細手順

1. **PA 配下プロセス全件**

    ```
    $OMNIHOME/bin/nco_pa_status -server NCO_PA -user paadmin
    ```

2. **alerts.status の俯瞰**

    ```sql
    select count(*) from alerts.status;
    select Severity, count(*) from alerts.status group by Severity;
    select count(*) from alerts.details;
    ```

3. **trigger group 全件**

    ```sql
    select Name, IsEnabled from catalog.trigger_groups order by Name;
    ```

4. **Gateway 状態**：各 Gateway log の Status Serial / 最新 Resync 状態を確認

#### 関連ユースケース

[uc-trigger-tune](#uc-trigger-tune)

**出典**: S_OMN_BP（Chapter 9）

---

### profiling で高コスト trigger を特定する { #uc-trigger-tune }

**ID**: `uc-trigger-tune` / **カテゴリ**: 状態確認 / 日常運用

#### 想定状況

ObjectServer の応答遅延が見られる、custom trigger 投入後の影響を確認したい。

#### 詳細手順

1. profiling ON（短時間、1 時間以内）

    ```sql
    alter system set 'ProfilingEnabled' = 'TRUE';
    go
    ```

2. 1 時間運用
3. 統計確認

    ```sql
    select Name, NumZeroes, AverageTime, TotalTime
      from catalog.trigger_stats
      order by TotalTime desc;
    go
    ```

4. profiling OFF

    ```sql
    alter system set 'ProfilingEnabled' = 'FALSE';
    go
    ```

#### 注意点

profiling 自体が overhead を伴う。本番継続 ON は禁忌。

#### 関連ユースケース

[uc-trigger-deploy-custom](#uc-trigger-deploy-custom)

**出典**: S_OMN_BP（Chapter 4 + 9）

---

### 構成 backup の取得（ObjectServer + Probe + Web GUI） { #uc-config-backup }

**ID**: `uc-config-backup` / **カテゴリ**: 状態確認 / 日常運用

#### 想定状況

DR 演習前 / 大幅変更前の構成バックアップ。

#### 詳細手順

1. **ObjectServer 全 trigger / procedure / table 構造を export**

    ```
    $OMNIHOME/bin/nco_sql -server NCOMS -username root \
        -input $OMNIHOME/extensions/dump_all.sql -output backup_objserv_$(date +%Y%m%d).sql
    ```

2. **設定ファイル群**

    ```
    tar czf netcool_etc_$(date +%Y%m%d).tgz $NCHOME/etc $OMNIHOME/etc $OMNIHOME/probes/*/*.props $OMNIHOME/probes/*/*.rules
    ```

3. **kdb（証明書 DB）も含める**：`$OMNIHOME/etc/keydb.kdb` 等
4. **Web GUI 設定**：WAAPI で export（`runwaapi <export options>`）

#### 注意点

backup は別ホスト / オフサイトに退避。kdb のパスワード stash ファイル（`.sth`）の取り扱いに注意。

**出典**: S_OMN_BP（Chapter 11）

---

### Probe で alerts.details への書込を抑止する（DisableDetails） { #uc-disable-details }

**ID**: `uc-disable-details` / **カテゴリ**: 状態確認 / 日常運用

#### 想定状況

alerts.details が肥大化、Probe からの詳細情報が運用に使われていない。

#### 詳細手順

1. Probe プロパティに `DisableDetails : 1`
2. Probe 再起動
3. 既存 alerts.details の掃除：`delete from alerts.details where Identifier in (select Identifier from alerts.status where ...);`

#### 関連ユースケース

[inc-alerts-status-bloat](09-incident-procedures.md#inc-alerts-status-bloat)

**出典**: S_OMN_BP（Chapter 5）

---

## Probe 配置

### Syslog Probe を配置する { #uc-probe-syslog }

**ID**: `uc-probe-syslog` / **カテゴリ**: Probe 配置

#### 想定状況

UNIX/Linux ホストの syslog を OMNIbus に取り込む。

#### 詳細手順

1. **Probe バイナリ配置**：個別ダウンロード + install.txt
2. **`syslog.props` 編集**：`Server : NCOMS` または virtual 名
3. **`syslog.rules` で Identifier / Severity 組成** → [uc-rules-edit](#uc-rules-edit)
4. **PA 配下で起動**
5. **`logger -t test "hello"` でテスト → AEL で確認**

#### 注意点

Single-threaded、capacity 100 events/sec 想定。これを超える流入が想定される場合は MTTrapd（SNMP）/ GLF Probe / カスタム Probe を検討。

#### 関連ユースケース

[uc-rules-edit](#uc-rules-edit), [uc-virtual-server-name](#uc-virtual-server-name)

**出典**: S_OMN_BP（Chapter 5）, S_OMN_PROBE_SYSLOG

---

### SNMP Trap Probe（nco_p_mttrapd）を配置する { #uc-probe-snmp }

**ID**: `uc-probe-snmp` / **カテゴリ**: Probe 配置

#### 想定状況

NW 機器の SNMP Trap を OMNIbus に取り込む。

#### 詳細手順

1. **MIB Manager で MIB → rules 変換**：`Generating SNMP traps` の Number of Traps を必要数（例 5000）に設定
2. **生成された rules を `mttrapd.rules` に include**
3. **`mttrapd.props` 編集**：`NetworkPort : 162`、`Server : COL_V_1`
4. **特権ポート 162 のため setcap か PA 経由 root 起動**
5. **テスト**：`snmptrap` コマンドで疑似 trap 送出 → AEL で確認

#### 注意点

Multi-threaded、capacity 200 events/sec 想定。MIB の Number of Traps 上限超過は [inc-mib-trap-truncate](09-incident-procedures.md#inc-mib-trap-truncate) 参照。

#### 関連ユースケース

[uc-rules-edit](#uc-rules-edit)

**出典**: S_OMN_PROBE_MTTRAPD, S_OMN_MIB_MGR

---

### Tivoli EIF Probe を配置（ITM 連携） { #uc-probe-eif }

**ID**: `uc-probe-eif` / **カテゴリ**: Probe 配置

#### 詳細手順

1. **`nco_p_tivoli_eif` 配置**
2. **`tivoli_eif.props`**：`Server`、`RulesFile`、`NetworkPort`
3. **`tivoli_eif.rules` で `include "predictive_event.rules"` のコメントアウト解除**（Predictive Event 取込）
4. **C-based EIF アプリの env**：`LIBPATH` / `LD_LIBRARY_PATH` に GSKit 含める
5. **ITM 側で EIF 送信先設定**

#### 関連ユースケース

[uc-rules-edit](#uc-rules-edit)

**出典**: S_OMN_EIF, S_OMN_ITM

---

### Generic Log File Probe で任意ログをパース { #uc-probe-glf }

**ID**: `uc-probe-glf` / **カテゴリ**: Probe 配置

#### 詳細手順

1. **`nco_p_logfile` 配置**
2. **`glf.props`**：`LogFile`、`RulesFile`
3. **rules で正規表現マッチ + Identifier 組成**
4. **複数ログを取り込む場合は複数インスタンス起動**（PA 配下）

#### 関連ユースケース

[uc-rules-edit](#uc-rules-edit)

**出典**: S_OMN_PROBE_GLF

---

### Probe rules を編集して Identifier / Severity を組成 { #uc-rules-edit }

**ID**: `uc-rules-edit` / **カテゴリ**: Probe 配置

#### 想定状況

Probe rules で deduplication 主キー Identifier を設計。

#### 詳細手順

1. **Identifier 組成**

    ```tcl
    @AlertGroup = "Network"
    @AlertKey = $event_class + "_" + $interface
    @Identifier = $hostname + "_" + @AlertGroup + "_" + @AlertKey
    ```

2. **Severity マッピング**

    ```tcl
    @Severity = 3
    if (regmatch($message, "(?i)error|fail|down")) { @Severity = 4 }
    if (regmatch($message, "(?i)fatal|critical|panic")) { @Severity = 5 }
    if (regmatch($message, "(?i)up|cleared|recovered")) { @Severity = 0 }
    ```

3. **discard 条件**

    ```tcl
    if (regmatch($message, "(?i)debug|info-only")) { discard }
    ```

4. **HTTP `reload`** で Probe 再起動なしで反映

#### 注意点

Identifier の組成は deduplication の挙動を決める。**業務的にユニークすぎる組成**だと deduplication が効かず alerts.status が肥大化、**業務的に粗すぎる組成**だと別事象が同じ Identifier に纏まって誤検知。

#### 関連ユースケース

[uc-probe-syslog](#uc-probe-syslog), [uc-probe-snmp](#uc-probe-snmp), [uc-probe-eif](#uc-probe-eif)

**出典**: S_OMN_BP（Chapter 5）, S_OMN_PROBE_GW

---

## Gateway / SMAC

### bidirectional Gateway（AGG_GATE）で Aggregation を二重化 { #uc-failover-pair }

**ID**: `uc-failover-pair` / **カテゴリ**: Gateway / SMAC

#### 詳細手順

1. **AGG_P / AGG_B が両起動**
2. **`AGG_GATE.props`**：`Gate.ObjectServerA.Server=AGG_P`、`Gate.ObjectServerB.Server=AGG_B`、`Resync.LockType=PARTIAL`、`MaxLogFileSize=2048`、`Gate.ObjectServerA.BufferSize=50`
3. **mapping table 定義**（`AGG_GATE.map`）
4. **`nco_g_objserv_bi -name AGG_GATE` で起動**
5. **virtual 名 AGG_V を omni.dat に登録** → [uc-virtual-server-name](#uc-virtual-server-name)

#### 注意点

両 ObjectServer の trigger / schema を完全一致させる。Probe 側自動 failback は **disable**（controlled failback 推奨）。

#### 関連ユースケース

[uc-virtual-server-name](#uc-virtual-server-name), [uc-smac-collection](#uc-smac-collection)

**出典**: S_OMN_BP（Chapter 7）

---

### virtual ObjectServer 名を使って Probe / Web GUI から透過的に切替 { #uc-virtual-server-name }

**ID**: `uc-virtual-server-name` / **カテゴリ**: Gateway / SMAC

#### 詳細手順

1. **omni.dat に virtual 名エントリ**

    ```
    [AGG_V]
        {
            Primary: aggp_host 4100
            Backup: aggb_host 4100
        }
    ```

2. **`nco_xigen` で interfaces 再生成**
3. **Probe `Server : AGG_V`、Web GUI データソースも AGG_V に**

#### 注意点

`Backup` 行が Probe / client の自動 failover 対象。

#### 関連ユースケース

[uc-failover-pair](#uc-failover-pair)

**出典**: S_OMN_BP

---

### SMAC Collection 層を構築（COL_P_1 + col_expire） { #uc-smac-collection }

**ID**: `uc-smac-collection` / **カテゴリ**: Gateway / SMAC

#### 詳細手順

1. **COL_P_1 / COL_B_1 ObjectServer 作成** + **`collection.sql` 投入**：`col_expire` trigger（30 秒で reap）含む
2. **C→A uni-directional Gateway 配置**：`C_TO_A_GATE_P_1` / `_B_1`
3. **Probe Server を `COL_V_1` に**

**出典**: S_OMN_BP（Chapter 7）

---

### SMAC Display 層を構築（DSP_P + Web GUI 接続） { #uc-smac-display }

**ID**: `uc-smac-display` / **カテゴリ**: Gateway / SMAC

#### 詳細手順

1. **DSP_P / DSP_B ObjectServer 作成 + `display.sql` 投入**：`dsd_triggers` group 含む
2. **A→D uni-directional Gateway 配置**：`A_TO_D_GATE_P` / `_B`
3. **Web GUI データソースを `DSP_V` に**

**出典**: S_OMN_BP（Chapter 7）

---

### nco_confpack で SMAC SQL / 拡張 jar を投入 { #uc-confpack-import }

**ID**: `uc-confpack-import` / **カテゴリ**: Gateway / SMAC

#### 詳細手順

```
$OMNIHOME/bin/nco_confpack -import -server AGG_P -user root \
    -package $OMNIHOME/extensions/multitier/objectserver/aggregation.jar
```

#### 注意点

import 前にバックアップ。trigger 名衝突は失敗の主因。

#### 関連ユースケース

[uc-config-backup](#uc-config-backup)

**出典**: S_OMN_BP

---

## AEN / 自動化

### AEN（Accelerated Event Notification）を有効化 { #uc-aen-enable }

**ID**: `uc-aen-enable` / **カテゴリ**: AEN / 自動化

#### 詳細手順

1. **`accelerated_inserts` trigger group enabled**
2. **Probe rules でフラグ列セット**：`if (@Severity = 5) { @AcceleratedEvent = 1 }`
3. **`nco_aen` を Display 層で起動**（PA 配下）
4. **Web GUI で Critical イベントの即時表示確認**

#### 注意点

AEN 対象は絞る（Critical のみ等）。流しすぎると Display Gateway が圧迫される。

#### 関連ユースケース

[uc-trigger-tune](#uc-trigger-tune)

**出典**: S_OMN_BP（Chapter 6）, S_OMN_AEN

---

### custom trigger を投入する（hk_de_escalate_events スタイル） { #uc-trigger-deploy-custom }

**ID**: `uc-trigger-deploy-custom` / **カテゴリ**: AEN / 自動化

#### 詳細手順

```sql
create or replace trigger custom_de_escalate
  group housekeeping
  priority 5
  every 86400 seconds
begin
  for each row this_event in alerts.status
  begin
    if (this_event.Severity = 5 and this_event.LastOccurrence < (now - 259200)) then
      set this_event.Severity = 4;
    elseif (this_event.Severity = 4 and this_event.LastOccurrence < (now - 172800)) then
      set this_event.Severity = 3;
    end if;
  end;
end;
go
```

#### 注意点

IF-ELSEIF で 1 つの FOR EACH ROW にまとめるのが Best Practices v1.3 推奨（複数 FOR EACH ROW より圧倒的に高速）。

**出典**: S_OMN_BP（Chapter 4）

---

### custom signal を定義して signal trigger を作る { #uc-signal-define }

**ID**: `uc-signal-define` / **カテゴリ**: AEN / 自動化

#### 詳細手順

1. **signal 宣言**：`create signal event_storm_signal cause '%s';`
2. **signal trigger**

    ```sql
    create or replace trigger on_event_storm
      group default_triggers
      priority 5
      on signal event_storm_signal
    begin
      -- send_email procedure 等を呼ぶ
      send_email('netcool-admin@mycompany', 'Event storm: ' || $cause, '...');
    end;
    go
    ```

3. **発火**：`raise signal event_storm_signal STORM;`

#### 注意点

1 signal にパラメータを持たせて分岐するのが Best Practices v1.3 推奨（custom signal 乱立を避ける）。

**出典**: S_OMN_BP（Chapter 4）

---

## Web GUI / WAAPI

### Web GUI のデータソースを登録する { #uc-webgui-datasource }

**ID**: `uc-webgui-datasource` / **カテゴリ**: Web GUI / WAAPI

#### 詳細手順

1. Web GUI 管理コンソール → Administration → Event Management Tools → Data Sources
2. New Data Source：name `LONDON`、ObjectServer 名 `AGG_V`、host / port 入力、SSL 必要なら kdb 指定
3. Save → Test Connection
4. AEL の対象データソースとして登録

#### バリエーション

複数データソース構成（マルチサイト）では各 view の Data Sources で複数選択可。

**出典**: S_OMN_WAAPI, S_OMN_WEBGUI

---

### Web GUI に filter / view を一括 Load { #uc-webgui-load-views }

**ID**: `uc-webgui-load-views` / **カテゴリ**: Web GUI / WAAPI

#### 詳細手順

1. `*.elf`（filter）/ `*.elv`（view）ファイルを Event List Configuration で Load
2. または WAAPI XML で投入：[uc-waapi-user-create](#uc-waapi-user-create) のスタイル

#### 関連ユースケース

[uc-waapi-user-create](#uc-waapi-user-create)

**出典**: S_OMN_WEBGUI, S_OMN_WAAPI

---

### WAAPI でユーザを XML 一括投入 { #uc-waapi-user-create }

**ID**: `uc-waapi-user-create` / **カテゴリ**: Web GUI / WAAPI

#### 詳細手順

1. XML 作成（`create_users.xml`）

    ```xml
    <user>
      <create>
        <username>op_user1</username>
        <fullname>Operator 1</fullname>
        <roles>
          <role>ncw_user</role>
        </roles>
      </create>
    </user>
    ```

2. `runwaapi -user wasadmin -file create_users.xml -outfile resp.xml` で投入
3. `resp.xml` で成功 / 失敗確認

#### 注意点

Web GUI 側のキャッシュ更新で反映に少し遅延。

**出典**: S_OMN_WAAPI

---

## セキュリティ

### ObjectServer の SSL/TLS（SecureMode）を有効化 { #uc-ssl-objserv }

**ID**: `uc-ssl-objserv` / **カテゴリ**: セキュリティ

#### 詳細手順

1. `nc_gskcmd -keydb -create -db keydb.kdb -pw ... -type cms -stash`
2. サーバ証明書作成 / 取込
3. ObjectServer プロパティに `SecureMode : TRUE`、`Sec.SSLKeyFile`、`Sec.SSLLabel`
4. Probe / Gateway 側でも同 kdb を参照、または public 証明書のみ取込

**出典**: S_OMN_ADMIN, S_GSKIT

---

### FIPS 140-2 モードで運用 { #uc-fips-mode }

**ID**: `uc-fips-mode` / **カテゴリ**: セキュリティ

#### 詳細手順

1. ObjectServer / Probe / Gateway / Process Agent / Proxy のプロパティで `FIPS : TRUE`
2. GSKit kdb を FIPS 準拠で作成
3. 利用可能暗号アルゴリズムが厳格化されるため、既存サードパーティ接続が動作するか **事前検証**

#### 注意点

FIPS モードは段階的に有効化（まず ObjectServer 単体 → Probe 順次切替）。

**出典**: S_OMN_BP, S_FIPS_140

---

### ObjectServer のユーザ / グループ / ロールを作成 { #uc-user-create }

**ID**: `uc-user-create` / **カテゴリ**: セキュリティ

#### 詳細手順

```sql
-- ユーザ作成
create user 'op_user1' set fullname = 'Operator 1', password = 'ChangeMe!';
go

-- グループ作成 / 既存グループへのメンバ追加
create group 'NWOperators';
alter group 'NWOperators' add member 'op_user1';
go

-- ロール（既存標準 = AlertsUser）の付与
alter group 'NWOperators' assign role 'AlertsUser';
go
```

#### 注意点

`CatalogUser` / `AlertsUser` / `AlertsProbe` / `RegisterProbe` / `ChannelUser` の標準ロールの組合せで多くの場面はカバー可。LDAP 統合は範囲外（[10. 対象外項目](10-out-of-scope.md)）。

**出典**: S_OMN_BP, S_OMN_ADMIN

---

## 支援 / Proxy / 連携

### Proxy Server を DMZ に置いて Probe を集約 { #uc-proxy-deploy }

**ID**: `uc-proxy-deploy` / **カテゴリ**: 支援 / Proxy / 連携

#### 詳細手順

1. DMZ ホストに `nco_proxyserv -name DMZ_PROXY -secure` で起動
2. Probe `Server : DMZ_PROXY`
3. firewall は DMZ_PROXY → 内部 AGG_V のみ開放

**出典**: S_OMN_PROXY

---

### Operations Analytics（SCALA）連携を有効化 { #uc-scala-link }

**ID**: `uc-scala-link` / **カテゴリ**: 支援 / Proxy / 連携

#### 詳細手順

1. `$OMNIHOME/extensions/scala/scala_triggers.jar` を `nco_confpack -import` で投入
2. SCALA エンドポイント設定
3. `scala_triggers` group enabled

**出典**: S_OMN_SCALA

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
