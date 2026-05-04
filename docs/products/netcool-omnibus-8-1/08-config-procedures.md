# 設定手順

> 掲載：**18 件（S/A/B/C × 用途、S 級は期待出力サンプル付き）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## 重要度 × 用途 マトリクス

<div class="md-typeset__scrollwrap" markdown="1">

| 重要度＼用途 | ObjectServer | Probe | Gateway / SMAC | Process Agent | セキュリティ | Web GUI | 連携 |
|---|---|---|---|---|---|---|---|
| **S** | [cfg-objserv-create](#cfg-objserv-create)<br>[cfg-trigger-deploy](#cfg-trigger-deploy) | [cfg-probe-syslog](#cfg-probe-syslog) | [cfg-failover-pair](#cfg-failover-pair)<br>[cfg-smac-aggregation](#cfg-smac-aggregation) | [cfg-pa-deploy](#cfg-pa-deploy) | [cfg-ssl-objserv](#cfg-ssl-objserv) | [cfg-webgui-waapi](#cfg-webgui-waapi) | — |
| **A** | [cfg-objserv-http](#cfg-objserv-http)<br>[cfg-aen-enable](#cfg-aen-enable) | [cfg-probe-snmp](#cfg-probe-snmp)<br>[cfg-probe-eif](#cfg-probe-eif) | [cfg-smac-collection](#cfg-smac-collection)<br>[cfg-smac-display](#cfg-smac-display) | — | — | — | [cfg-scala-link](#cfg-scala-link) |
| **B** | — | [cfg-probe-glf](#cfg-probe-glf)<br>[cfg-probe-http-cmd](#cfg-probe-http-cmd) | — | — | — | — | — |
| **C** | — | — | [cfg-proxy-deploy](#cfg-proxy-deploy) | — | — | — | — |

</div>

---

## 詳細手順

### cfg-objserv-create: ObjectServer の新規作成と起動 { #cfg-objserv-create }

**重要度**: `S` / **用途**: ObjectServer

**目的**: 新規 ObjectServer インスタンス（NCOMS 等）の作成、`omni.dat` への登録、`interfaces` 生成、起動、生死確認まで。

**前提**: OMNIbus 本体 IM インストール済、`$NCHOME` / `$OMNIHOME` 環境変数設定済、Process Agent（[cfg-pa-deploy](#cfg-pa-deploy)）配置済または手動運用。

**手順**:

1. **ObjectServer インスタンス作成**

    ```
    $OMNIHOME/bin/nco_dbinit -server NCOMS
    ```

2. **omni.dat 編集**（`$NCHOME/etc/omni.dat`）

    ```
    [NCOMS]
        {
            Primary: ncohost1 4100
        }
    ```

3. **interfaces 生成**

    ```
    $NCHOME/bin/nco_xigen
    ```

4. **プロパティファイル準備**（`$OMNIHOME/etc/NCOMS.props`）

    ```
    Name : 'NCOMS'
    MessageLevel : 'info'
    MessageLog : '$OMNIHOME/log/NCOMS.log'
    Memstore.DataDirectory : '$OMNIHOME/db'
    Iduc.ListeningPort : 4101
    Granularity : 60
    Auto.Enabled : TRUE
    Iduc.Enabled : TRUE
    Store.UseTwoFiles : TRUE
    ```

5. **起動**（手動 or PA 配下）

    ```
    $OMNIHOME/bin/nco_objserv -name NCOMS -propsfile $OMNIHOME/etc/NCOMS.props
    ```

6. **生死確認**

    ```
    $OMNIHOME/bin/nco_sql -server NCOMS -username root
    1> select count(*) from alerts.status;
    2> go
    ```

**期待出力（実機サンプル）**:

`nco_dbinit` 成功時:

```
ObjectServer NCOMS created in $OMNIHOME/db/NCOMS
Catalog and master tables initialized.
Default groups, roles, restriction filters loaded.
NCOIM0011I: Database initialization successful.
```

`nco_objserv` 起動時 log（`$OMNIHOME/log/NCOMS.log`）:

```
Information: I-OBJ-100-029: NCOMS: ObjectServer started, listening on port 4100.
Information: I-OBJ-100-031: NCOMS: IDUC listening on port 4101.
Information: I-OBJ-100-035: NCOMS: Trigger 'generic_clear' enabled.
Information: I-OBJ-100-040: NCOMS: All initial triggers loaded.
```

`nco_sql` 接続成功時:

```
[NCOMS] 1> select count(*) from alerts.status;
[NCOMS] 2> go
COUNT
-----
0
(1 row affected)
```

失敗時に出る代表メッセージ:

- `E-OBJ-100-002`（プロパティファイル不正）
- `E-OBJ-100-009`（指定ポート占有）
- `E-OBJ-100-014`（`Memstore.DataDirectory` 配下に既存 DB ファイルあり、または書込権限なし）

**検証**: `nco_pa_status -server <PA>` で RUNNING、`nco_sql` で接続可能、log に `ObjectServer started` が出ていること。

**ロールバック**: `nco_pa_stop` または kill。`$OMNIHOME/db/<name>` ディレクトリ削除で完全クリーン化（再作成可）。

**関連**: [cfg-pa-deploy](#cfg-pa-deploy), [cfg-trigger-deploy](#cfg-trigger-deploy), [inc-objserv-startup-fail](09-incident-procedures.md#inc-objserv-startup-fail)

**出典**: S_OMN_BP, S_OMN_QSG, S_OMN_ADMIN

---

### cfg-trigger-deploy: 標準 trigger / procedure の有効化と custom trigger 投入 { #cfg-trigger-deploy }

**重要度**: `S` / **用途**: ObjectServer

**目的**: `delete_clears` / `generic_clear` / `hk_set_expiretime` / `hk_de_escalate_events` 等の標準 trigger が enabled であることを確認し、必要なら custom trigger を投入。

**前提**: ObjectServer 起動済、nco_sql 権限。

**手順**:

1. 標準 trigger group の状態確認

    ```sql
    select Name, IsEnabled, GroupName from catalog.trigger_groups order by Name;
    go
    select Name, IsEnabled, GroupName from catalog.triggers where GroupName = 'housekeeping';
    go
    ```

2. 必要な group を enabled に

    ```sql
    alter trigger group housekeeping enabled;
    alter trigger group default_triggers enabled;
    go
    ```

3. custom trigger 投入（ファイルから読み込む例）

    ```
    $OMNIHOME/bin/nco_sql -server NCOMS -username root -input my_custom_trigger.sql
    ```

    `my_custom_trigger.sql` の例（`hk_de_escalate_events` 形式）:

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
        elseif (this_event.Severity = 3 and this_event.LastOccurrence < (now - 86400)) then
          set this_event.Severity = 2;
        end if;
      end;
    end;
    go
    ```

4. profiling で性能影響確認

    ```sql
    alter system set 'ProfilingEnabled' = 'TRUE';
    -- ... 1 hour ...
    select Name, NumZeroes, AverageTime, TotalTime
      from catalog.trigger_stats
      order by TotalTime desc;
    alter system set 'ProfilingEnabled' = 'FALSE';
    ```

**期待出力（実機サンプル）**:

`alter trigger group housekeeping enabled;` 成功時:

```
[NCOMS] 1> alter trigger group housekeeping enabled;
[NCOMS] 2> go
(0 rows affected)
```

profiling 結果（高コスト trigger 順）:

```
NAME                 NUMZEROES  AVERAGETIME  TOTALTIME
custom_de_escalate          1     12000000    12000000
hk_set_expiretime           5      8500000    42500000
generic_clear              42      1200000    50400000
delete_clears              42       450000    18900000
```

失敗時:

- `E-SQL-001-014`（trigger 構文エラー、行 / 列番号付き）
- `E-SQL-002-021`（指定 trigger group が存在しない）

**検証**: `select count(*) from alerts.status where Severity = 0 and StateChange < (now - 120);` が時間と共に減ること（delete_clears が動作している証拠）。

**ロールバック**: `alter trigger group <name> disabled;`、または個別 `drop trigger <name>;`。

**関連**: [cfg-objserv-create](#cfg-objserv-create), [inc-alerts-status-bloat](09-incident-procedures.md#inc-alerts-status-bloat)

**出典**: S_OMN_BP（Chapter 4）

---

### cfg-probe-syslog: Syslog Probe 配置と rules 設計 { #cfg-probe-syslog }

**重要度**: `S` / **用途**: Probe

**目的**: `nco_p_syslog` を配置、Identifier 組成 / Severity マッピングを rules で設計、ObjectServer に接続してイベント INSERT を確認する。

**前提**: ObjectServer 起動済 + omni.dat にエントリ済 + interfaces 生成済、Probe ホストに OMNIbus Probe バイナリ配置済。

**手順**:

1. **Probe プロパティファイル準備**（`$OMNIHOME/probes/linux2x86/syslog.props`）

    ```
    Server : 'NCOMS'
    MessageLevel : 'warn'
    MessageLog : '$OMNIHOME/log/syslog.log'
    RulesFile : '$OMNIHOME/probes/linux2x86/syslog.rules'
    DisableDetails : 0
    Heartbeat : 60
    RetryInterval : 60
    EnableHTTP : TRUE
    HTTPPort : 8001
    ```

2. **rules ファイル編集**（`$OMNIHOME/probes/linux2x86/syslog.rules`）

    ```tcl
    @Manager = "Syslog Probe"
    @AlertGroup = "Syslog"
    @Node = $hostname
    @Severity = 3
    if (regmatch($message, "kernel:.*[Ee]rror")) {
      @Severity = 4
    }
    if (regmatch($message, "[Ff]atal|[Pp]anic")) {
      @Severity = 5
    }
    @Identifier = $hostname + "_" + $process + "_" + $facility + "_" + @AlertKey
    ```

3. **Probe 起動**（PA 配下推奨、開発時は手動）

    ```
    $OMNIHOME/probes/linux2x86/nco_p_syslog -propsfile $OMNIHOME/probes/linux2x86/syslog.props
    ```

4. **テストイベント投入**（local syslog 経由）

    ```
    logger -t mytest "this is a test syslog event"
    ```

5. **ObjectServer 側で受信確認**

    ```sql
    select Identifier, Node, Summary, Severity from alerts.status where AlertGroup='Syslog' order by LastOccurrence desc;
    go
    ```

**期待出力（実機サンプル）**:

Probe 起動 log:

```
2026-04-01 10:00:00 [INFO]  : Reading rules file: syslog.rules
2026-04-01 10:00:00 [INFO]  : Rules file parsed successfully (32 rule blocks).
2026-04-01 10:00:00 [INFO]  : Connected to ObjectServer NCOMS (4100/tcp).
2026-04-01 10:00:00 [INFO]  : nco_p_syslog ready, listening on syslog stream.
```

`select` 結果:

```
IDENTIFIER                              NODE     SUMMARY                  SEVERITY
ncohost1_user_local0_USER_TEST          ncohost1 this is a test syslog... 3
```

失敗時:

- `Probe rules parse error at line 12: unknown token`
- `Failed to connect to ObjectServer NCOMS: Connection refused`（[inc-probe-conn-fail](09-incident-procedures.md#inc-probe-conn-fail)）

**検証**: 1 時間運用して alerts.status に Syslog 行が蓄積、Identifier の deduplication（Tally インクリメント）が動作。

**ロールバック**: Probe 停止 → rules 元戻し → Probe 再起動。

**関連**: [cfg-failover-pair](#cfg-failover-pair)（Server に virtual 名指定）, [inc-rules-syntax-error](09-incident-procedures.md#inc-rules-syntax-error)

**出典**: S_OMN_BP（Chapter 5）, S_OMN_PROBE_SYSLOG

---

### cfg-failover-pair: Aggregation 二重化（AGG_GATE bidirectional Gateway） { #cfg-failover-pair }

**重要度**: `S` / **用途**: Gateway / SMAC

**目的**: Aggregation 層の Primary（AGG_P）+ Backup（AGG_B）+ bidirectional Gateway（AGG_GATE）で fail-over を組み、controlled failback で resync する。

**前提**: AGG_P / AGG_B が両方起動、両 ObjectServer の trigger / schema が一致。

**手順**:

1. **Gateway プロパティファイル**（`$OMNIHOME/etc/AGG_GATE.props`）

    ```
    Gate.ObjectServerA.Server : 'AGG_P'
    Gate.ObjectServerA.BufferSize : 50
    Gate.ObjectServerB.Server : 'AGG_B'
    Gate.ObjectServerB.BufferSize : 50
    Resync.LockType : PARTIAL
    MaxLogFileSize : 2048
    Gate.MapFile : '$OMNIHOME/etc/AGG_GATE.map'
    Gate.Reader.IducFlushRate : 60
    PropsFile : '$OMNIHOME/etc/AGG_GATE.props'
    ```

2. **mapping table（複製対象）定義**（`$OMNIHOME/etc/AGG_GATE.map`）

    ```
    CREATE MAPPING StatusMap
    (
      'Identifier' = '@Identifier',
      'Severity' = '@Severity',
      ...
    );
    ```

3. **virtual ObjectServer 名 omni.dat 登録**

    ```
    [AGG_V]
    {
      Primary: aggp_host 4100
      Backup: aggb_host 4100
    }
    ```

4. **Gateway 起動**

    ```
    $OMNIHOME/bin/nco_g_objserv_bi -name AGG_GATE -propsfile $OMNIHOME/etc/AGG_GATE.props
    ```

5. **Probe 側 Server プロパティを virtual 名に変更**

    ```
    Server : 'AGG_V'
    ```

6. **failover テスト**：AGG_P を停止 → Probe が AGG_B へ自動切替を確認 → AGG_P 再起動 → Gateway resync → controlled failback。

**期待出力（実機サンプル）**:

Gateway 起動 log:

```
2026-04-01 10:00:00 [INFO]  : AGG_GATE: Connected to AGG_P (primary).
2026-04-01 10:00:00 [INFO]  : AGG_GATE: Connected to AGG_B (backup).
2026-04-01 10:00:00 [INFO]  : AGG_GATE: Resync.LockType=PARTIAL.
2026-04-01 10:00:01 [INFO]  : AGG_GATE: Initial resynchronisation complete.
```

failover 中（AGG_P 停止）:

```
2026-04-01 11:00:00 [WARN]  : AGG_GATE: Lost connection to AGG_P, will retry.
2026-04-01 11:00:00 [INFO]  : Probe ServerBackup AGG_B is taking over for AGG_V clients.
```

failback 中（AGG_P 再起動）:

```
2026-04-01 12:00:00 [INFO]  : AGG_GATE: AGG_P reconnected.
2026-04-01 12:00:00 [INFO]  : AGG_GATE: Resync started, target AGG_P locked (PARTIAL).
2026-04-01 12:00:30 [INFO]  : AGG_GATE: Resync complete (gw_resync_finish signal raised).
2026-04-01 12:00:30 [INFO]  : AGG_GATE: Target AGG_P unlocked, clients can reconnect.
```

失敗時:

- `Resync timeout exceeded` → Gateway log で Status Serial 確認、mapping 漏れ調査。

**検証**: 24 時間運用で AGG_P / AGG_B の `select count(*) from alerts.status;` が一致を維持。

**ロールバック**: Gateway 停止 → AGG_P / AGG_B 単独運用に戻す。Probe Server を AGG_P に戻して再起動。

**関連**: [cfg-smac-aggregation](#cfg-smac-aggregation), [inc-failover-resync-fail](09-incident-procedures.md#inc-failover-resync-fail)

**出典**: S_OMN_BP（Chapter 7）, S_OMN_FAILOVER

---

### cfg-smac-aggregation: SMAC Aggregation 層構築 { #cfg-smac-aggregation }

**重要度**: `S` / **用途**: Gateway / SMAC

**目的**: SMAC の中段である Aggregation 層を構築（AGG_P + AGG_B + AGG_GATE + 標準 SQL 投入）。

**前提**: ObjectServer インスタンス AGG_P / AGG_B 作成済（[cfg-objserv-create](#cfg-objserv-create)）。

**手順**:

1. **`$OMNIHOME/extensions/multitier/objectserver/aggregation.sql` の投入**

    ```
    $OMNIHOME/bin/nco_sql -server AGG_P -username root -input $OMNIHOME/extensions/multitier/objectserver/aggregation.sql
    $OMNIHOME/bin/nco_sql -server AGG_B -username root -input $OMNIHOME/extensions/multitier/objectserver/aggregation.sql
    ```

2. **AGG_GATE 配置**（[cfg-failover-pair](#cfg-failover-pair) を実施）

3. **accelerated_inserts trigger group の有効化**

    ```sql
    alter trigger group accelerated_inserts enabled;
    go
    ```

4. **`resync_complete` signal trigger の動作確認**：Gateway resync 完了で synthetic event が両 ObjectServer に挿入されることを確認。

**関連**: [cfg-smac-collection](#cfg-smac-collection), [cfg-smac-display](#cfg-smac-display), [cfg-failover-pair](#cfg-failover-pair)

**出典**: S_OMN_BP（Chapter 7）, S_OMN_SMAC

---

### cfg-pa-deploy: Process Agent（nco_pad）配置 { #cfg-pa-deploy }

**重要度**: `S` / **用途**: Process Agent

**目的**: nco_pad を OS サービスとして起動し、ObjectServer / Probe / Gateway を PA 配下にして自動再起動を実現。

**前提**: OMNIbus 本体配置済、`netcool` ユーザ作成（root 起動回避）。

**手順**:

1. **nco_pad プロパティ準備**（`$OMNIHOME/etc/<PA>.props`）

    ```
    Name : 'NCO_PA'
    Username : 'paadmin'
    Password : '<暗号化文字列>'    # nco_pa_crypt で生成
    Authenticate : 'PAM'
    SecureMode : TRUE
    ```

2. **process entries 定義**（PA 設定ファイル内）

    ```
    process AGG_P_OBJSERV 'nco_objserv -name AGG_P -propsfile ... start' \
            "nobody" autostart yes
    process AGG_GATE 'nco_g_objserv_bi -name AGG_GATE start' \
            "nobody" autostart yes
    process SYSLOG_PROBE 'nco_p_syslog -propsfile ... start' \
            "nobody" autostart yes
    ```

3. **systemd unit（Linux 例）**（`/etc/systemd/system/nco_pa.service`）

    ```
    [Unit]
    Description=Netcool OMNIbus Process Agent
    After=network.target

    [Service]
    Type=forking
    User=netcool
    ExecStart=/opt/IBM/tivoli/netcool/omnibus/bin/nco_pad -name NCO_PA -authenticate PAM -secure
    ExecStop=/opt/IBM/tivoli/netcool/omnibus/bin/nco_pa_shutdown -server NCO_PA -user paadmin
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target
    ```

4. **systemd 登録 / 起動**

    ```
    sudo systemctl daemon-reload
    sudo systemctl enable --now nco_pa
    ```

5. **状態確認**

    ```
    $OMNIHOME/bin/nco_pa_status -server NCO_PA -user paadmin
    ```

**関連**: [cfg-objserv-create](#cfg-objserv-create), [cfg-probe-syslog](#cfg-probe-syslog), [inc-pa-process-down](09-incident-procedures.md#inc-pa-process-down)

**出典**: S_OMN_BP（Chapter 10）, S_OMN_PA

---

### cfg-ssl-objserv: ObjectServer SSL/TLS（SecureMode）有効化 { #cfg-ssl-objserv }

**重要度**: `S` / **用途**: セキュリティ

**目的**: ObjectServer / Probe / Gateway の通信を SSL/TLS（GSKit ベース）で暗号化、必要なら FIPS 140-2 モード。

**前提**: GSKit 同梱済、`nc_gskcmd` 使用可。

**手順**:

1. **鍵 DB 作成**

    ```
    $NCHOME/bin/nc_gskcmd -keydb -create -db $OMNIHOME/etc/keydb.kdb -pw <pwd> -type cms -stash
    ```

2. **サーバ証明書作成 / インポート**

    ```
    $NCHOME/bin/nc_gskcmd -cert -create -db $OMNIHOME/etc/keydb.kdb -pw <pwd> -label aggp_cert -dn "CN=aggp_host,O=mycompany"
    ```

3. **ObjectServer プロパティに SecureMode**

    ```
    SecureMode : TRUE
    Sec.SSLKeyFile : '$OMNIHOME/etc/keydb.kdb'
    Sec.SSLLabel : 'aggp_cert'
    FIPS : FALSE   # FIPS 必要時 TRUE
    ```

4. **Probe / Gateway 側でも同 kdb を参照、または public 証明書のみ取り込み**。

5. **再起動 → SSL 接続テスト**：`nco_sql -fips` 等で接続。

**関連**: [cfg-objserv-create](#cfg-objserv-create), [03-glossary > SecureMode](03-glossary.md#securemode)

**出典**: S_OMN_ADMIN, S_GSKIT

---

### cfg-webgui-waapi: Web GUI 構築と WAAPI による設定自動化 { #cfg-webgui-waapi }

**重要度**: `S` / **用途**: Web GUI

**目的**: Jazz/DASH 上に Web GUI をデプロイ、WAAPI でユーザ・フィルタ・ビューを XML で一括投入。

**前提**: WAS / DASH 構築済、Web GUI バイナリ IM インストール済。

**手順**:

1. Web GUI を WAS 上にデプロイ（IM）。
2. Web GUI のデータソースとして AGG_V（virtual 名）を登録。
3. WAAPI コマンドファイル（XML）を準備：

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

4. `runwaapi -user wasadmin -file create_user.xml -outfile resp.xml` で投入。

5. Web GUI で AEL を開いて事象が流れているか確認。

**関連**: [cfg-objserv-http](#cfg-objserv-http), [inc-waapi-error](09-incident-procedures.md#inc-waapi-error)

**出典**: S_OMN_WAAPI, S_OMN_WEBGUI

---

### cfg-objserv-http: ObjectServer HTTP/REST インタフェース有効化 { #cfg-objserv-http }

**重要度**: `A` / **用途**: ObjectServer

**目的**: REST 経由の event INSERT、外部システム（カスタム dashboard 等）からの SQL 発行を可能にする。

**手順**:

1. ObjectServer プロパティに

    ```
    NHttpd.EnableHTTP : TRUE
    NHttpd.AuthenticationDomain : 'omnibus'
    NHttpd.ConfigFile : '$OMNIHOME/etc/libnhttpd.json'
    ```

2. `libnhttpd.json` 内で許可エンドポイント / CORS / SSL 設定。
3. 再起動 → curl でテスト：

    ```
    curl -k -u root:pwd https://aggp_host:port/objectserver/restapi/v1/sql -d '{"sql":"select count(*) from alerts.status"}'
    ```

**関連**: [cfg-ssl-objserv](#cfg-ssl-objserv)

**出典**: S_OMN_NHTTPD

---

### cfg-aen-enable: Accelerated Event Notification（AEN）有効化 { #cfg-aen-enable }

**重要度**: `A` / **用途**: ObjectServer

**目的**: Critical イベントだけ Granularity を待たず Display 層へ即時配信。

**手順**:

1. `accelerated_inserts` trigger group enabled

    ```sql
    alter trigger group accelerated_inserts enabled;
    go
    ```

2. Probe rules 内でフラグ列セット

    ```tcl
    if (@Severity = 5) {
      @AcceleratedEvent = 1
    } else {
      @AcceleratedEvent = 0
    }
    ```

3. nco_aen 起動（PA 配下推奨）

    ```
    $OMNIHOME/bin/nco_aen -server DSP_P -pa NCO_PA
    ```

**関連**: [cfg-trigger-deploy](#cfg-trigger-deploy)

**出典**: S_OMN_BP（Chapter 6）, S_OMN_AEN

---

### cfg-probe-snmp: SNMP Trap Probe（nco_p_mttrapd）配置 { #cfg-probe-snmp }

**重要度**: `A` / **用途**: Probe

**目的**: UDP 162 で SNMP Trap を受信し、MIB に基づいて alerts.status へマッピング。

**手順**:

1. MIB Manager で MIB → rules 変換、`Generating SNMP traps` の Number of Traps を必要数（例：5000）に。
2. 生成された rules を `mttrapd.rules` に include。
3. Probe プロパティ：`NetworkPort : 162`、`Server : COL_V_1`。
4. Probe 起動（root 権限が必要なポート 162 のため、setcap または PA 配下で root で起動）。

**関連**: [cfg-probe-syslog](#cfg-probe-syslog), [inc-mib-trap-truncate](09-incident-procedures.md#inc-mib-trap-truncate)

**出典**: S_OMN_PROBE_MTTRAPD, S_OMN_MIB_MGR

---

### cfg-probe-eif: Tivoli EIF Probe + Predictive Event 連携 { #cfg-probe-eif }

**重要度**: `A` / **用途**: Probe

**目的**: ITM 等から EIF イベントを受け、Predictive Event を含めて alerts.status へ。

**手順**:

1. `nco_p_tivoli_eif` 配置、`tivoli_eif.props` で Server / RulesFile 設定。
2. `tivoli_eif.rules` 内の `include "predictive_event.rules"` のコメントアウトを解除。
3. ITM 側で EIF 送信先として Probe ホスト：ポート を設定。
4. C-based EIF アプリの環境変数 `LIBPATH` / `LD_LIBRARY_PATH` に GSKit を含める。

**関連**: [inc-eif-no-arrival](09-incident-procedures.md#inc-eif-no-arrival)

**出典**: S_OMN_EIF, S_OMN_ITM

---

### cfg-smac-collection: SMAC Collection 層構築 { #cfg-smac-collection }

**重要度**: `A` / **用途**: Gateway / SMAC

**目的**: Probe を直接受ける Collection ObjectServer と Aggregation 層への uni-directional Gateway を配置。

**手順**:

1. COL_P_1 / COL_B_1 の ObjectServer 作成 + `collection.sql` 投入（`col_expire` trigger 込み）。
2. C_TO_A_GATE_P_1 / C_TO_A_GATE_B_1（uni-directional）配置。
3. Probe `Server : COL_V_1` で接続。

**関連**: [cfg-smac-aggregation](#cfg-smac-aggregation)

**出典**: S_OMN_BP（Chapter 7）

---

### cfg-smac-display: SMAC Display 層構築 { #cfg-smac-display }

**重要度**: `A` / **用途**: Gateway / SMAC

**目的**: Web GUI / Impact 接続用の Display ObjectServer + Aggregation → Display Gateway を配置。

**手順**:

1. DSP_P / DSP_B の ObjectServer 作成 + `display.sql` 投入（`dsd_triggers` 等）。
2. A_TO_D_GATE_P / A_TO_D_GATE_B（uni-directional）配置。
3. Web GUI のデータソースを DSP_V に変更。

**関連**: [cfg-smac-aggregation](#cfg-smac-aggregation), [cfg-webgui-waapi](#cfg-webgui-waapi)

**出典**: S_OMN_BP（Chapter 7）

---

### cfg-scala-link: Operations Analytics（SCALA）連携 { #cfg-scala-link }

**重要度**: `A` / **用途**: 連携

**目的**: alerts.status の更新を SCALA に送出してログ分析統合。

**手順**:

1. `$OMNIHOME/extensions/scala/scala_triggers.jar` を `nco_confpack -import` で投入。
2. SCALA エンドポイント（host / port）を `scala_triggers` group の procedure 内で設定。
3. trigger group enabled。

**関連**: [cfg-trigger-deploy](#cfg-trigger-deploy)

**出典**: S_OMN_SCALA

---

### cfg-probe-glf: Generic Log File Probe 配置 { #cfg-probe-glf }

**重要度**: `B` / **用途**: Probe

**目的**: アプリ独自ログをパースして alerts.status へ。1 ホストで複数インスタンス起動可。

**手順**:

1. `glf.props` で `LogFile` / `RulesFile` 設定、複数インスタンスは `Name` を変えて Process Agent 経由で起動。
2. rules で正規表現 + Identifier 組成。

**関連**: [cfg-probe-syslog](#cfg-probe-syslog)

**出典**: S_OMN_PROBE_GLF

---

### cfg-probe-http-cmd: Probe HTTP Command Interface 有効化 { #cfg-probe-http-cmd }

**重要度**: `B` / **用途**: Probe

**目的**: Probe 再起動なしで rules reload / status 取得をするために HTTP インタフェースを有効化。

**手順**:

1. Probe プロパティに `EnableHTTP : TRUE`、`HTTPPort : 8001` 等。
2. HTTP 認証 / SSL 必須（DMZ 越しでは特に注意）。
3. `curl -k -u user:pwd https://probe-host:8001/probes/syslog/reload` でテスト。

**関連**: [cfg-probe-syslog](#cfg-probe-syslog)

**出典**: S_OMN_PROBE_GW

---

### cfg-proxy-deploy: Proxy Server 配置（DMZ 経由 Probe 集約） { #cfg-proxy-deploy }

**重要度**: `C` / **用途**: Gateway / SMAC

**目的**: 多数の Probe を DMZ Proxy Server 経由で内部 ObjectServer に集約、firewall を 1 経路に集約。

**手順**:

1. DMZ ホストに `nco_proxyserv -name DMZ_PROXY -secure` で起動（SecureMode 必須）。
2. Probe `Server : DMZ_PROXY` で接続。
3. firewall は DMZ_PROXY → 内部 AGG_V のみ開放。

**関連**: [cfg-failover-pair](#cfg-failover-pair), [cfg-ssl-objserv](#cfg-ssl-objserv)

**出典**: S_OMN_PROXY

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
