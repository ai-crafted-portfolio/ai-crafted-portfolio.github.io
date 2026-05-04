# コマンド一覧

> 掲載：**45 件（nco_* バイナリ / ObjectServer SQL / Probe / Gateway / Process Agent / WAAPI）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

Netcool/OMNIbus 8.1 の管理者・オペレータ・Probe/Gateway 開発者が日常的に使う定番コマンドを厳選。本ページでは 6 系統に分類：(A) **ObjectServer 制御**、(B) **Probe / Gateway 制御**、(C) **Process Agent**、(D) **ObjectServer SQL（nco_sql 経由）**、(E) **Web GUI / WAAPI**、(F) **支援ツール（証明書 / MIB Manager / インストール）**。

すべての例で `$NCHOME` = OMNIbus インストールルート、`$OMNIHOME` = `$NCHOME/omnibus` を前提。Windows では `$OMNIHOME\bin\xxx.bat`、UNIX 系では `$OMNIHOME/bin/xxx`。

## 目次

- **(A) ObjectServer 制御**（10 件）: [`nco_objserv`](#nco-objserv), [`nco_dbinit`](#nco-dbinit), [`nco_sql`](#nco-sql), [`nco_xigen`](#nco-xigen), [`nco_confpack`](#nco-confpack), [`nco_aen`](#nco-aen), [`nco_g_objserv_bi`](#nco-g-objserv-bi), [`nco_g_objserv_uni`](#nco-g-objserv-uni), [`nco_proxyserv`](#nco-proxyserv), [`nco_postmsg`](#nco-postmsg)
- **(B) Probe 関連**（8 件）: [`nco_p_syslog`](#nco-p-syslog), [`nco_p_mttrapd`](#nco-p-mttrapd), [`nco_p_tivoli_eif`](#nco-p-tivoli-eif), [`nco_p_glf`](#nco-p-glf), Probe `-dumpprops`、Probe `-help`、Probe HTTP `reload`、Probe HTTP `getstatus`
- **(C) Process Agent**（5 件）: [`nco_pad`](#nco-pad), [`nco_pa_start`](#nco-pa-start), [`nco_pa_stop`](#nco-pa-stop), [`nco_pa_status`](#nco-pa-status), [`nco_pa_shutdown`](#nco-pa-shutdown)
- **(D) ObjectServer SQL（nco_sql 内）**（10 件）: [`SELECT FROM alerts.status`](#sql-select-status), [`UPDATE alerts.status`](#sql-update-status), [`DELETE FROM alerts.status`](#sql-delete-status), [`ALTER TRIGGER`](#sql-alter-trigger), [`ALTER TRIGGER GROUP`](#sql-alter-trigger-group), [`CREATE PROCEDURE`](#sql-create-procedure), [`RAISE SIGNAL`](#sql-raise-signal), [`DESCRIBE`](#sql-describe), [`SHOW LOCKS`](#sql-show-locks), [`ALTER SYSTEM`](#sql-alter-system)
- **(E) Web GUI / WAAPI**（5 件）: [`runwaapi`](#runwaapi), [`startWebGUI`](#start-webgui), [`stopWebGUI`](#stop-webgui), Web GUI Server log tail、Web GUI Event List configure
- **(F) 支援ツール**（7 件）: [`nc_gskcmd`](#nc-gskcmd), [`nco_keygen`](#nco-keygen), [`nco_pa_crypt`](#nco-pa-crypt), Netcool MIB Manager、IBM Installation Manager (IM)、`nco_install_inc`、`nco_check_install`

---

## (A) ObjectServer 制御

### `nco_objserv` { #nco-objserv }

**用途**: ObjectServer プロセス本体を起動。インメモリ DB として alerts.status / alerts.details / alerts.journal を保持し、Probe / Gateway / Web GUI / Impact からの SQL を捌く。

**構文**:

```
$OMNIHOME/bin/nco_objserv -name <ObjectServerName> [-pa <PA name>] [-secure] [-fips]
                          [-messagelevel debug|info|warn|error|fatal]
                          [-memstoredatadirectory <dir>] [-propsfile <file>]
                          [-nhttpd_authdomain <domain>] [-nhttpd_configfile <file>]
```

**典型例**:

```
$OMNIHOME/bin/nco_objserv -name AGG_P -messagelevel info \
    -memstoredatadirectory $OMNIHOME/db -propsfile $OMNIHOME/etc/AGG_P.props
```

**注意点**: Process Agent（nco_pad）配下で起動するのが本番運用の標準（手動 nco_objserv は開発・検証時のみ）。`-secure` / `-fips` で SSL / FIPS 140-2 モードを有効化。`-name` は omni.dat と一致させる必要があり、不整合時は Probe 側で接続失敗。

**関連手順**: [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create), [inc-objserv-hang](09-incident-procedures.md#inc-objserv-hang)

**関連用語**: [ObjectServer](03-glossary.md#objectserver), [omni.dat](03-glossary.md#omni-dat), [SecureMode](03-glossary.md#securemode)

**出典**: S_OMN_BP, S_OMN_QSG

---

### `nco_dbinit` { #nco-dbinit }

**用途**: 新規 ObjectServer インスタンスを作成。`$OMNIHOME/db/<ObjectServerName>` 配下に物理ファイル群を生成し、initial スキーマ（alerts.status / alerts.details / alerts.journal / master.* / catalog.* 等）を投入。

**構文**:

```
$OMNIHOME/bin/nco_dbinit -server <ObjectServerName>
                         [-customsql <file>] [-quiet]
```

**典型例**:

```
$OMNIHOME/bin/nco_dbinit -server NCOMS
$OMNIHOME/bin/nco_dbinit -server AGG_P -customsql $OMNIHOME/extensions/multitier/objectserver/aggregation.sql
```

**注意点**: 既存の同名 ObjectServer データがあると失敗。SMAC（Standard Multitier Architecture Configuration）構築時は role 別 SQL（collection.sql / aggregation.sql / display.sql）を `-customsql` で同時投入するのが標準。

**関連手順**: [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create), [cfg-smac-aggregation](08-config-procedures.md#cfg-smac-aggregation)

**関連用語**: [ObjectServer](03-glossary.md#objectserver), [SMAC](03-glossary.md#smac)

**出典**: S_OMN_BP, S_OMN_QSG

---

### `nco_sql` { #nco-sql }

**用途**: ObjectServer に対する対話的 SQL クライアント。alerts.status の参照・更新、trigger / procedure 編集、ALTER SYSTEM などの管理コマンドの発行に使用。

**構文**:

```
$OMNIHOME/bin/nco_sql -server <ObjectServerName> -username <user> [-password <pwd>]
                      [-input <file>] [-output <file>] [-fips]
```

**典型例**:

```
$OMNIHOME/bin/nco_sql -server NCOMS -username root
1> select Identifier, Severity, Node, Summary from alerts.status where Severity > 3;
2> go
1> alter trigger group housekeeping enabled;
2> go
```

**注意点**: スクリプトから流す場合は `-input file.sql` で SQL ファイルを渡し、`go` をステートメント終端として明示。`-output` で結果を別ファイルへ。`select count(*) from alerts.status` は本番でも頻用、長時間 hold は厳禁。

**関連手順**: [cfg-trigger-deploy](08-config-procedures.md#cfg-trigger-deploy), [inc-alerts-status-bloat](09-incident-procedures.md#inc-alerts-status-bloat)

**関連用語**: [alerts.status](03-glossary.md#alerts-status), [Trigger](03-glossary.md#trigger), [Trigger Group](03-glossary.md#trigger-group)

**出典**: S_OMN_BP

---

### `nco_xigen` { #nco-xigen }

**用途**: `$NCHOME/etc/omni.dat`（接続定義テキスト）から `interfaces` ファイル（バイナリ接続定義）を生成。Probe / Gateway / nco_sql / Web GUI が ObjectServer に到達するために必要。

**構文**:

```
$NCHOME/bin/nco_xigen [-in <omni.dat>] [-out <interfaces>] [-help]
```

**典型例**:

```
# UNIX 標準パス
$NCHOME/bin/nco_xigen
# IPv6 構成では omni.dat の Primary 行に [::1] を記述
```

**注意点**: 接続失敗時はまず omni.dat を見直して `nco_xigen` を再実行。Windows では `interfaces.cfg` を生成。`omni.dat` には NCOMS / 自社 ObjectServer のホスト名・ポート・アドレスファミリ（IPv4 / IPv6）を Primary / Backup の順で記述。

**関連手順**: [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create), [inc-probe-conn-fail](09-incident-procedures.md#inc-probe-conn-fail)

**関連用語**: [omni.dat](03-glossary.md#omni-dat), [interfaces](03-glossary.md#interfaces)

**出典**: S_OMN_BP, S_OMN_QSG

---

### `nco_confpack` { #nco-confpack }

**用途**: ObjectServer 設定（trigger / procedure / table / restriction filter / role / group / user）の **export / import パッケージツール**。`$NCHOME/omnibus/extensions/` 配下の `.jar` / `.zip` をインポート。SMAC 用の collection.sql / aggregation.sql / display.sql、ShowRootCauseTool（仮想化用）等も nco_confpack 経由で導入可。

**構文**:

```
$OMNIHOME/bin/nco_confpack -import -server <name> -user <user> [-password <pwd>] -package <file>
$OMNIHOME/bin/nco_confpack -export -server <name> -user <user> [-password <pwd>] -package <out.zip>
```

**典型例**:

```
$OMNIHOME/bin/nco_confpack -import -server AGG_P -user root \
    -package $OMNIHOME/extensions/scala/scala_triggers.jar
```

**注意点**: import 前に必ず ObjectServer のフルバックアップ（nco_sql で `-output` を使った export）を取得。trigger 名衝突は失敗の主因。

**関連手順**: [cfg-trigger-deploy](08-config-procedures.md#cfg-trigger-deploy), [cfg-scala-link](08-config-procedures.md#cfg-scala-link)

**関連用語**: [Trigger Group](03-glossary.md#trigger-group), [Procedure](03-glossary.md#procedure)

**出典**: S_OMN_BP

---

### `nco_aen` { #nco-aen }

**用途**: Accelerated Event Notification（AEN）プロセス。ObjectServer 内で `accelerated_inserts` トリガが立てた高優先イベントを Web GUI / desktop client へ即時配信。通常 IDUC（Granularity 既定 60 秒）を待たずに送る。

**構文**:

```
$OMNIHOME/bin/nco_aen -server <ObjectServerName> [-pa <PA name>]
```

**典型例**:

```
$OMNIHOME/bin/nco_aen -server DSP_P -pa NCO_PA
```

**注意点**: AEN は **trigger `accelerated_inserts` を enabled にしないと動作しない**。閾値は Probe rules で acceleration フラグ列を 1 に設定する設計。AEN を流しすぎると Display 層の Gateway を圧迫するため、絞り込み（critical / 業務影響大のみ）が必要。

**関連手順**: [cfg-aen-enable](08-config-procedures.md#cfg-aen-enable)

**関連用語**: [AEN](03-glossary.md#aen), [IDUC](03-glossary.md#iduc), [Granularity](03-glossary.md#granularity)

**出典**: S_OMN_BP

---

### `nco_g_objserv_bi` { #nco-g-objserv-bi }

**用途**: **Bidirectional ObjectServer Gateway**（双方向）。Aggregation 層の Primary / Backup ObjectServer 間で alerts.status / alerts.details / alerts.journal を相互複製、controlled failback の中核。

**構文**:

```
$OMNIHOME/bin/nco_g_objserv_bi -name <gateway-name> [-propsfile <file>]
```

**典型例**:

```
$OMNIHOME/bin/nco_g_objserv_bi -name AGG_GATE -propsfile $OMNIHOME/etc/AGG_GATE.props
```

**注意点**: `Resync.LockType=PARTIAL` が SMAC の標準。controlled failback を機能させるには Probe 側自動 failback を **disable** にして、Gateway 側 resync 完了後にクライアントを失敗復帰させる設計（Best Practices v1.3 の推奨）。

**関連手順**: [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair), [inc-failover-resync-fail](09-incident-procedures.md#inc-failover-resync-fail)

**関連用語**: [Gateway](03-glossary.md#gateway), [Controlled Failback](03-glossary.md#controlled-failback), [AGG_GATE](03-glossary.md#agg-gate)

**出典**: S_OMN_BP

---

### `nco_g_objserv_uni` { #nco-g-objserv-uni }

**用途**: **Unidirectional ObjectServer Gateway**（一方向）。Collection → Aggregation 層、Aggregation → Display 層へのイベント転送に使用。bidirectional より軽量。

**構文**:

```
$OMNIHOME/bin/nco_g_objserv_uni -name <gateway-name> [-propsfile <file>]
```

**典型例**:

```
$OMNIHOME/bin/nco_g_objserv_uni -name C_TO_A_GATE_P_1 -propsfile $OMNIHOME/etc/C_TO_A_GATE_P_1.props
```

**注意点**: SMAC の Collection → Aggregation 転送、Aggregation → Display 転送はすべて **uni**。bidirectional は Aggregation Primary ↔ Backup の 1 ペアだけ。

**関連手順**: [cfg-smac-collection](08-config-procedures.md#cfg-smac-collection)

**関連用語**: [Gateway](03-glossary.md#gateway), [SMAC](03-glossary.md#smac)

**出典**: S_OMN_BP

---

### `nco_proxyserv` { #nco-proxyserv }

**用途**: **Proxy Server**。多数の Probe を 1 接続にまとめ、ObjectServer 側の接続スケーリング負荷を低減。DMZ 越しの firewall bridge 用途にも。

**構文**:

```
$OMNIHOME/bin/nco_proxyserv -name <ProxyName> [-secure] [-fips]
```

**典型例**:

```
$OMNIHOME/bin/nco_proxyserv -name DMZ_PROXY -secure
```

**注意点**: 100+ の Probe を集約する局面で価値が出る。`SecureMode=TRUE` / `-secure` で認証付き運用必須（DMZ 配置の前提）。

**関連手順**: [cfg-proxy-deploy](08-config-procedures.md#cfg-proxy-deploy)

**関連用語**: [Proxy Server](03-glossary.md#proxy-server)

**出典**: S_OMN_BP

---

### `nco_postmsg` { #nco-postmsg }

**用途**: 単発イベントを ObjectServer の alerts.status へ INSERT する CLI。スクリプト / バッチからの簡易イベント投入、トラブル時のテストイベント注入に便利。

**構文**:

```
$OMNIHOME/bin/nco_postmsg -server <ObjectServerName> -username <user> [-password <pwd>] \
    "Identifier='...';Node='...';Severity=4;Summary='...';AlertGroup='...'"
```

**典型例**:

```
$OMNIHOME/bin/nco_postmsg -server NCOMS -username root \
    "Identifier='TEST-001';Node='hostA';Severity=5;Summary='test event from nco_postmsg'"
```

**注意点**: 重要：production の alerts.status を実テストで汚さないため、`Identifier` を一意に組成し、後で `delete from alerts.status where Identifier='TEST-001'` で消す運用。

**関連手順**: [cfg-trigger-deploy](08-config-procedures.md#cfg-trigger-deploy)

**関連用語**: [alerts.status](03-glossary.md#alerts-status), [Identifier](03-glossary.md#identifier)

**出典**: S_OMN_BP

---

## (B) Probe 関連

### `nco_p_syslog` { #nco-p-syslog }

**用途**: **Syslog Probe**。UNIX/Linux の syslog（local / network）をパースして alerts.status へイベント化。代表的な single-threaded Probe（best practices で 100 events/sec 想定）。

**構文**:

```
$OMNIHOME/probes/<arch>/nco_p_syslog -propsfile <file> [-rulesfile <file>]
                                     [-server <name>] [-serverbackup <name>]
                                     [-messagelevel debug|info|warn|error]
                                     [-disabledetails]
```

**典型例**:

```
$OMNIHOME/probes/linux2x86/nco_p_syslog -propsfile $OMNIHOME/probes/linux2x86/syslog.props
```

**注意点**: rules file は `$OMNIHOME/probes/<arch>/syslog.rules`（既定）。Server プロパティに **virtual ObjectServer 名（COL_V_1 等、Primary/Backup ペア）** を指定するのが SMAC の標準。`-disabledetails` で alerts.details 投入を抑止できる。

**関連手順**: [cfg-probe-syslog](08-config-procedures.md#cfg-probe-syslog), [inc-probe-conn-fail](09-incident-procedures.md#inc-probe-conn-fail)

**関連用語**: [Probe](03-glossary.md#probe), [Rules File](03-glossary.md#rules-file)

**出典**: S_OMN_BP, S_OMN_QSG

---

### `nco_p_mttrapd` { #nco-p-mttrapd }

**用途**: **SNMP Trap Probe**（multi-threaded、別名 MTTrapd）。UDP 162 でトラップ受信、200 events/sec 程度を想定。MIB Manager で MIB → rules 変換した出力をインクルードする。

**構文**:

```
$OMNIHOME/probes/<arch>/nco_p_mttrapd -propsfile <file>
```

**典型例**:

```
$OMNIHOME/probes/linux2x86/nco_p_mttrapd -propsfile $OMNIHOME/probes/linux2x86/mttrapd.props
```

**注意点**: 設定の核は `mttrapd.props` の `NetworkPort`（既定 162、root 権限が必要）と rules 内 `@AlertGroup` / `@Severity` のマッピング。MIB Manager の Number of Traps 上限超過に注意。

**関連手順**: [cfg-probe-snmp](08-config-procedures.md#cfg-probe-snmp), [inc-mib-trap-truncate](09-incident-procedures.md#inc-mib-trap-truncate)

**関連用語**: [SNMP Probe](03-glossary.md#snmp-probe), [MIB Manager](03-glossary.md#mib-manager)

**出典**: S_OMN_BP

---

### `nco_p_tivoli_eif` { #nco-p-tivoli-eif }

**用途**: **Tivoli EIF Probe**。IBM Tivoli Monitoring（TEMS）等の EIF 送信元から alerts.status へイベント化。`tivoli_eif.rules` / `eif_default.rules` でクラス → カラムマッピング。

**構文**:

```
$OMNIHOME/probes/<arch>/nco_p_tivoli_eif -propsfile <file>
```

**典型例**:

```
$OMNIHOME/probes/linux2x86/nco_p_tivoli_eif -propsfile $OMNIHOME/probes/linux2x86/tivoli_eif.props
```

**注意点**: Predictive Event 連携では `tivoli_eif.rules` 内の `include "predictive_event.rules"` のコメントアウトを解除。GSKit を `LIBPATH` / `LD_LIBRARY_PATH` に含めないと SSL 接続失敗。

**関連手順**: [cfg-probe-eif](08-config-procedures.md#cfg-probe-eif), [inc-eif-no-arrival](09-incident-procedures.md#inc-eif-no-arrival)

**関連用語**: [EIF](03-glossary.md#eif), [Predictive Event](03-glossary.md#predictive-event)

**出典**: S_OMN_EIF, S_OMN_ITM

---

### `nco_p_glf` { #nco-p-glf }

**用途**: **Generic Log File Probe**。任意のログファイルを正規表現でパースして alerts.status へ。OS native syslog 以外（アプリ独自ログ）の取り込みで多用。

**構文**:

```
$OMNIHOME/probes/<arch>/nco_p_logfile -propsfile <file>
```

**注意点**: 1 ホストで複数の log を取り込む場合は **複数インスタンス起動**（Best Practices v1.3 推奨）が標準。各インスタンスを Process Agent でまとめて管理。

**関連手順**: [cfg-probe-glf](08-config-procedures.md#cfg-probe-glf)

**関連用語**: [GLF Probe](03-glossary.md#glf-probe)

**出典**: S_OMN_BP

---

### Probe `-dumpprops` / `-help` / HTTP `reload` / HTTP `getstatus`

**用途**:

- `-dumpprops` : Probe の現在のプロパティ全件を標準出力。トラブル時の最初に取る情報。
- `-help` : Probe バイナリのオプション一覧と short description。
- HTTP `reload` : Probe の rules file を再読込（Probe 再起動なしで rules 更新を反映）。Probe HTTP コマンドインタフェース経由。
- HTTP `getstatus` : Probe の動作状況・統計を返す。

**典型例**:

```
$OMNIHOME/probes/linux2x86/nco_p_syslog -propsfile syslog.props -dumpprops
curl -k -u user:pwd https://probe-host:port/probes/syslog/reload
curl -k -u user:pwd https://probe-host:port/probes/syslog/getstatus
```

**注意点**: HTTP コマンドは `EnableHTTP=TRUE` + 認証情報設定が前提。

**関連手順**: [cfg-probe-http-cmd](08-config-procedures.md#cfg-probe-http-cmd)

**関連用語**: [Probe HTTP Interface](03-glossary.md#probe-http-interface)

**出典**: S_OMN_BP

---

## (C) Process Agent

### `nco_pad` { #nco-pad }

**用途**: **Process Agent デーモン**。OMNIbus 関連プロセス（ObjectServer、Probe、Gateway、Proxy 等）を起動・監視・自動再起動。OS のサービスマネージャ（systemd 等）から `nco_pad` を 1 つ起こせば、配下プロセスは Process Agent が制御する。

**構文**:

```
$OMNIHOME/bin/nco_pad -name <PA name> [-authenticate PAM|NONE] [-secure]
```

**典型例**:

```
$OMNIHOME/bin/nco_pad -name NCO_PA -authenticate PAM -secure
```

**注意点**: Best Practices v1.3 推奨：`netcool` ユーザで起動（root 不要）、`-authenticate PAM` で OS PAM 連携、`-secure` で SSL。Linux なら systemd unit、AIX なら inittab / SRC で起動制御。

**関連手順**: [cfg-pa-deploy](08-config-procedures.md#cfg-pa-deploy)

**関連用語**: [Process Agent](03-glossary.md#process-agent), [PAM](03-glossary.md#pam)

**出典**: S_OMN_BP

---

### `nco_pa_start` { #nco-pa-start }

**用途**: Process Agent 配下の特定プロセスを起動。

**構文**: `$OMNIHOME/bin/nco_pa_start -server <PA name> -process <process-id> -user <user> [-password <pwd>]`

**典型例**: `$OMNIHOME/bin/nco_pa_start -server NCO_PA -process AGG_P_OBJSERV -user pa_user`

**関連手順**: [cfg-pa-deploy](08-config-procedures.md#cfg-pa-deploy)

**出典**: S_OMN_BP

---

### `nco_pa_stop` { #nco-pa-stop }

**用途**: Process Agent 配下の特定プロセスを停止。

**構文**: `$OMNIHOME/bin/nco_pa_stop -server <PA name> -process <process-id> -user <user>`

**典型例**: `$OMNIHOME/bin/nco_pa_stop -server NCO_PA -process SYSLOG_PROBE`

**出典**: S_OMN_BP

---

### `nco_pa_status` { #nco-pa-status }

**用途**: Process Agent 配下の全プロセスの稼働状況一覧。**最頻用の運用コマンド**。

**構文**: `$OMNIHOME/bin/nco_pa_status -server <PA name> -user <user>`

**典型例**:

```
$ $OMNIHOME/bin/nco_pa_status -server NCO_PA -user pa_user
PA name = NCO_PA, host = ncohost1
Process              Status      PID    Last Started
AGG_P_OBJSERV        RUNNING     12345  2026-04-01 10:00:00
AGG_GATE             RUNNING     12346  2026-04-01 10:00:01
SYSLOG_PROBE         RUNNING     12347  2026-04-01 10:00:02
```

**注意点**: `RUNNING` 以外（`STOPPED` / `RESTARTING`）が出ていれば即座に詳細調査。

**関連手順**: [inc-pa-process-down](09-incident-procedures.md#inc-pa-process-down)

**出典**: S_OMN_BP

---

### `nco_pa_shutdown` { #nco-pa-shutdown }

**用途**: Process Agent 自体（およびその配下プロセス全体）の停止。

**構文**: `$OMNIHOME/bin/nco_pa_shutdown -server <PA name> -user <user>`

**注意点**: PA を落とすと配下全 OMNIbus プロセスが停止するので、メンテ時間外には絶対に使わない。

**出典**: S_OMN_BP

---

## (D) ObjectServer SQL（nco_sql 内）

### `SELECT FROM alerts.status` { #sql-select-status }

**用途**: イベント状態の参照。Severity / Node / AlertGroup での絞り込みが運用の基本。

**典型例**:

```sql
1> select Identifier, Severity, Node, Summary, FirstOccurrence, LastOccurrence, Tally
2>   from alerts.status
3>   where Severity >= 4 and AlertGroup = 'Network'
4>   order by LastOccurrence desc;
5> go
```

**注意点**: production の alerts.status は数万行〜数十万行の規模になるため、フルスキャン SQL は避ける（WHERE で Severity / Node / Identifier に絞る）。Identifier は主キー相当で最速。

**関連用語**: [Identifier](03-glossary.md#identifier), [Tally](03-glossary.md#tally)

**出典**: S_OMN_BP, S_OMN_WAAPI

---

### `UPDATE alerts.status` { #sql-update-status }

**用途**: イベントの severity 強制変更、acknowledge 設定、ownership 変更など。

**典型例**:

```sql
update alerts.status set OwnerUID = 1234, OwnerGID = 1
  where Identifier = 'NET-LINKDOWN-hostA-eth0';
go
```

**注意点**: WHERE に Identifier（主キー）を使うのが鉄則。Severity を直接 0 に書き換えると `delete_clears` が動いて 120 秒後に消えるため、消したい場合の常套手段。

**関連用語**: [delete_clears](03-glossary.md#delete-clears)

**出典**: S_OMN_BP

---

### `DELETE FROM alerts.status` { #sql-delete-status }

**用途**: 強制的なイベント削除。テストイベント掃除、暴走時の緊急対応で使用。

**典型例**:

```sql
delete from alerts.status where Identifier = 'TEST-001';
go
delete from alerts.status where AlertGroup = 'OBSOLETE';
go
```

**注意点**: 大量 delete はトリガを大量に発火させるため、業務時間内は避ける。`alerts.details` / `alerts.journal` の付随行は `clean_details_table` / `clean_journal_table` トリガが後始末する（**両トリガが enabled** であることが前提）。

**関連用語**: [clean_details_table](03-glossary.md#clean-details-table)

**出典**: S_OMN_BP

---

### `ALTER TRIGGER` { #sql-alter-trigger }

**用途**: 個別トリガの enable / disable / 内容変更。

**典型例**:

```sql
alter trigger generic_clear enabled;
go
alter trigger delete_clears disabled;
go
```

**注意点**: 単独 trigger を disable するより、**trigger group 単位での制御**（[`ALTER TRIGGER GROUP`](#sql-alter-trigger-group)）の方が事故が少ない。

**関連用語**: [Trigger](03-glossary.md#trigger)

**出典**: S_OMN_BP

---

### `ALTER TRIGGER GROUP` { #sql-alter-trigger-group }

**用途**: トリガグループ全体の enable / disable。

**典型例**:

```sql
alter trigger group housekeeping enabled;
go
alter trigger group default_triggers enabled;
go
```

**注意点**: 標準 group：`default_triggers`、`housekeeping`、`dsd_triggers`（Display 用）、`scala_triggers`、`accelerated_inserts`。`housekeeping` を停めたまま運用すると alerts.status が肥大化する。

**関連手順**: [inc-alerts-status-bloat](09-incident-procedures.md#inc-alerts-status-bloat)

**関連用語**: [Trigger Group](03-glossary.md#trigger-group)

**出典**: S_OMN_BP

---

### `CREATE PROCEDURE` { #sql-create-procedure }

**用途**: SQL procedure 定義。trigger からのみ呼べる internal procedure と、external script 起動用 external procedure の 2 種。

**典型例**:

```sql
create procedure count_up_criticals(out count_of_criticals int)
begin
  declare my_counter int;
  set my_counter = 0;
  for each row this_event in alerts.status where this_event.Severity = 5
  begin
    set my_counter = my_counter + 1;
  end;
  set count_of_criticals = my_counter;
end;
go
```

**注意点**: コメントは procedure body 内に inline で。コメントヘッダに最終更新者・日付・目的を入れるのが Best Practices v1.3 推奨。

**関連用語**: [Procedure](03-glossary.md#procedure)

**出典**: S_OMN_BP

---

### `RAISE SIGNAL` { #sql-raise-signal }

**用途**: signal トリガ起動。custom signal を業務上のフラグとして利用。

**典型例**:

```sql
raise signal event_storm_signal STORM;
go
raise signal event_storm_signal NORMAL;
go
```

**注意点**: 1 つの signal にパラメータを持たせて条件分岐するのが Best Practices 推奨（複数 signal 乱立を避ける）。

**関連用語**: [Signal](03-glossary.md#signal)

**出典**: S_OMN_BP

---

### `DESCRIBE` { #sql-describe }

**用途**: テーブル / view の構造表示。

**典型例**:

```sql
describe alerts.status;
go
```

**出典**: S_OMN_BP

---

### `SHOW LOCKS` { #sql-show-locks }

**用途**: ObjectServer 内のロック状況。長時間 hold が見えたら問題。

**典型例**:

```sql
show locks;
go
```

**関連手順**: [inc-objserv-hang](09-incident-procedures.md#inc-objserv-hang)

**出典**: S_OMN_BP

---

### `ALTER SYSTEM` { #sql-alter-system }

**用途**: システム属性の動的変更。例：実行中 ObjectServer の Profile / メッセージレベル変更。

**典型例**:

```sql
alter system set 'MessageLevel' = 'debug';
go
alter system set 'ProfilingEnabled' = 'TRUE';
go
```

**注意点**: profiling は overhead を伴うため、収集後は OFF に戻す。

**出典**: S_OMN_BP

---

## (E) Web GUI / WAAPI

### `runwaapi` { #runwaapi }

**用途**: Web GUI（Jazz/DASH 上）のユーザ・グループ・ロール・フィルタ・ビュー・ツール定義を XML で一括投入する CLI。Web GUI 設定の自動化に必須。

**構文**:

```
# UNIX
$WEBGUI_HOME/waapi/bin/runwaapi <options> -file <command.xml>
# Windows
%WEBGUI_HOME%\waapi\bin\runwaapi.cmd <options> -file <command.xml>
```

**典型例**:

```
$WEBGUI_HOME/waapi/bin/runwaapi -user wasadmin -file create_filter.xml -outfile resp.xml
```

**注意点**: コマンドファイル（XML）は WAAPI スキーマに準拠。応答 XML を見て成功 / 失敗を判定。Web GUI 側にキャッシュがあるため、反映に少し遅延あり。

**関連手順**: [cfg-webgui-waapi](08-config-procedures.md#cfg-webgui-waapi)

**関連用語**: [WAAPI](03-glossary.md#waapi)

**出典**: S_OMN_WAAPI

---

### `startWebGUI` / `stopWebGUI` { #start-webgui }
<a id="stop-webgui"></a>

**用途**: Web GUI（DASH 上で稼働する WAS プロファイル）の起動・停止。実体は WAS の startServer.sh / stopServer.sh をラップ。

**典型例**:

```
$JAZZSM_HOME/profile/bin/startWebGUI.sh
$JAZZSM_HOME/profile/bin/stopWebGUI.sh
```

**出典**: S_OMN_WAAPI, S_OMN_BP

---

### Web GUI Server log tail / Event List configure

**用途**:

- Web GUI Server log は `$JAZZSM_HOME/profile/logs/<server>/SystemOut.log`、`SystemErr.log` を tail。
- Event List 設定は Web GUI 管理画面の Event List Configuration で `*.elf` フィルタ / `*.elv` ビューを Load。

**関連用語**: [Web GUI](03-glossary.md#web-gui), [AEL](03-glossary.md#ael)

**出典**: S_OMN_WAAPI

---

## (F) 支援ツール

### `nc_gskcmd` { #nc-gskcmd }

**用途**: GSKit（IBM Global Security Kit）の証明書・鍵 DB（`.kdb`）操作。OMNIbus のすべての SSL/TLS 経路で使用。

**典型例**:

```
$NCHOME/bin/nc_gskcmd -keydb -create -db key.kdb -pw <pwd> -type cms -stash
$NCHOME/bin/nc_gskcmd -cert -create -db key.kdb -label myserver -dn "CN=hostA"
```

**注意点**: FIPS 140-2 モードでは利用可能アルゴリズムが制限される。kdb のパスワード stash ファイル（`.sth`）の取り扱いに注意。

**関連手順**: [cfg-ssl-objserv](08-config-procedures.md#cfg-ssl-objserv)

**関連用語**: [GSKit](03-glossary.md#gskit), [FIPS](03-glossary.md#fips)

**出典**: S_OMN_BP

---

### `nco_keygen` { #nco-keygen }

**用途**: ObjectServer / Probe 間の対称暗号化鍵（`$OMNIHOME/etc/conf.key` 等）生成。Probe rules 内の暗号化文字列、プロパティの暗号化に使う。

**典型例**: `$OMNIHOME/bin/nco_keygen -o $OMNIHOME/etc/conf.key`

**出典**: S_OMN_BP

---

### `nco_pa_crypt` { #nco-pa-crypt }

**用途**: Process Agent の `PA.Password` 等を平文 → 暗号化文字列に変換。プロパティファイルへの書き込み専用。

**典型例**: `$OMNIHOME/bin/nco_pa_crypt myplaintext`

**出典**: S_OMN_BP

---

### Netcool MIB Manager / IBM Installation Manager (IM) / `nco_install_inc` / `nco_check_install`

**用途**:

- **Netcool MIB Manager** : Eclipse ベース GUI、SNMP MIB → Probe rules file 生成。`Generating SNMP traps` の Number of Traps を必要数に設定。
- **IBM Installation Manager (IM)** : OMNIbus 本体・Web GUI のインストール / fix pack 適用。Probe / Gateway は IM ではなく個別 install.txt に従う。
- **`nco_install_inc`** : `$OMNIHOME/etc/automation.sql` 等の標準 SQL を ObjectServer に再投入する保守ツール。
- **`nco_check_install`** : インストール整合性チェック。

**関連用語**: [MIB Manager](03-glossary.md#mib-manager), [IM](03-glossary.md#im)

**出典**: S_OMN_BP, S_OMN_QSG

---

## まとめ：日常運用の最短コマンドセット

| 場面 | コマンド |
|---|---|
| OMNIbus 全体の生死確認 | `nco_pa_status -server NCO_PA -user pa_user` |
| 重大イベント一覧 | `nco_sql -server <name> -username <user>` → `select * from alerts.status where Severity>=4;` |
| Probe rules 修正後の反映 | Probe HTTP `reload`（再起動不要） |
| trigger group の停止 / 再開 | `alter trigger group <name> enabled / disabled;` |
| 手動テストイベント注入 | `nco_postmsg ...` |
| omni.dat 修正後の反映 | `nco_xigen` |
| Web GUI 設定一括投入 | `runwaapi -file ...` |

詳細は各章の手順 / 用語へリンク。
