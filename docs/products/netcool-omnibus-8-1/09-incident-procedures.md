# 障害対応手順

> 掲載：**18 件（S/A/B/C × 用途、S 級は A/B/C 仮説分岐付き）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## 重要度 × 用途 マトリクス

<div class="md-typeset__scrollwrap" markdown="1">

| 重要度＼用途 | 起動 / 接続 | 性能 / 肥大 | failover / SMAC | Probe / Gateway | Web GUI |
|---|---|---|---|---|---|
| **S** | [inc-objserv-startup-fail](#inc-objserv-startup-fail)<br>[inc-objserv-hang](#inc-objserv-hang)<br>[inc-probe-conn-fail](#inc-probe-conn-fail) | [inc-alerts-status-bloat](#inc-alerts-status-bloat)<br>[inc-objserv-slow](#inc-objserv-slow) | [inc-failover-resync-fail](#inc-failover-resync-fail) | [inc-eif-no-arrival](#inc-eif-no-arrival) | [inc-iduc-stuck](#inc-iduc-stuck) |
| **A** | [inc-pa-process-down](#inc-pa-process-down) | [inc-event-flood](#inc-event-flood) | [inc-gateway-backlog](#inc-gateway-backlog) | [inc-rules-syntax-error](#inc-rules-syntax-error)<br>[inc-mib-trap-truncate](#inc-mib-trap-truncate) | [inc-waapi-error](#inc-waapi-error) |
| **B** | [inc-omni-dat-mismatch](#inc-omni-dat-mismatch) | [inc-disk-full-log](#inc-disk-full-log) | — | [inc-probe-orphan-row](#inc-probe-orphan-row) | — |
| **C** | — | [inc-trigger-loop](#inc-trigger-loop) | — | — | — |

</div>

---

## 詳細手順

### inc-objserv-startup-fail: ObjectServer 起動失敗 { #inc-objserv-startup-fail }

**重要度**: `S` / **用途**: 起動 / 接続

**目的**: `nco_objserv` 起動が即時 exit する、または PA 配下で再起動ループに陥っている状態の切り分け。

**前提**: ObjectServer log（`$OMNIHOME/log/<name>.log`）にアクセス可能。

**仮説分岐**:

_トリガ事象_: nco_pa_status で `RESTARTING` ループ、または `nco_objserv` を手動起動して exit code != 0。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | プロパティファイル誤り（必須項目欠落、構文不正） | log に `E-OBJ-100-002: invalid property file` | プロパティファイルを sample（`$OMNIHOME/etc/<name>.props.sample`）と diff して修正 |
| **B** | ポート競合（4100 が既に使われている） | `netstat -an \| grep 4100`、log に `E-OBJ-100-009: port in use` | omni.dat / props のポート変更、または競合プロセスを停止 |
| **C** | `Memstore.DataDirectory` の物理問題（既存 DB 破損 / 書込権限なし） | log に `E-OBJ-100-014`、`ls -ld $OMNIHOME/db/<name>` の所有者 / 権限確認 | 権限修正、または `nco_dbinit` で再作成（バックアップ後） |

_共通の最初の動作_: `tail -200 $OMNIHOME/log/<name>.log` のメッセージコード（`E-OBJ-100-XXX`）を確実に保存。

**手順（共通）**:

1. log 末尾 200 行を保存
2. `-messagelevel debug` で再起動して詳細ログ取得
3. プロパティ / ポート / 権限を仮説別に確認
4. 修正 → `nco_objserv` 手動起動でテスト → PA 配下に戻す

**期待出力**:

```
$ tail -50 $OMNIHOME/log/AGG_P.log
2026-04-01 10:00:00 [ERROR] E-OBJ-100-002: invalid property file: line 5, missing quote
```

**検証**: 修正後 `nco_objserv` 手動起動で `I-OBJ-100-029` が出ること、`nco_sql` で接続可能。

**ロールバック**: 直前の正常時のプロパティファイルへ戻す。

**関連**: [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create)

**出典**: S_OMN_BP, S_OMN_ADMIN

---

### inc-objserv-hang: ObjectServer hang / unresponsive { #inc-objserv-hang }

**重要度**: `S` / **用途**: 起動 / 接続

**目的**: ObjectServer が応答停止、`nco_sql` も繋がらないか SELECT が返らない状態の切り分け。

**仮説分岐**:

_トリガ事象_: `nco_sql` が hang、Web GUI が更新されない、Probe ログに `Lost connection` 多発。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | 長時間 hold trigger / procedure | nco_sql の別セッション（管理者）から `show locks;` で長時間 hold 確認 | hold trigger を kill（`kill connection <id>;`）、root cause 分析 |
| **B** | profiling が ON 放置で overhead 大 | log に `Profile : TRUE`、最近 ProfilingEnabled 設定変更 | `alter system set 'ProfilingEnabled' = 'FALSE';`（管理者セッション） |
| **C** | OS 側 OOM / メモリ枯渇 | `free -m`、`vmstat` で swap 使用率高、`dmesg` で OOM kill 痕跡 | 当該 ObjectServer を計画停止 → メモリ追加、alerts.status の reduce、Memstore.DataDirectory の I/O 改善 |

_共通の最初の動作_: kill する前に `ps -ef | grep nco_objserv` の状態を保存、可能なら gcore で coredump。

**手順（共通）**:

1. 別管理者セッションで `show locks;` 確認
2. profiling 状態確認 / OFF 化
3. OS 側リソース確認（`free`, `top`, `vmstat`）
4. 必要なら計画停止 → 再起動（alerts.status は永続化されているため再起動で復元）

**期待出力**:

```
[NCOMS] 1> show locks;
[NCOMS] 2> go
USER     COUNT_LOCKS  HOLD_TIME
root        24         600
```

**検証**: kill / 再起動後に `nco_sql` で SELECT が即時返ること、Web GUI 更新再開。

**関連**: [inc-objserv-slow](#inc-objserv-slow), [inc-alerts-status-bloat](#inc-alerts-status-bloat)

**出典**: S_OMN_BP（Chapter 9）

---

### inc-probe-conn-fail: Probe → ObjectServer 接続失敗 { #inc-probe-conn-fail }

**重要度**: `S` / **用途**: 起動 / 接続

**目的**: Probe ログに `Failed to connect`、または接続後すぐ切断する状態の切り分け。

**仮説分岐**:

_トリガ事象_: Probe log の `Connection refused` / `Connection timed out` / `Authentication failed`。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | omni.dat / interfaces 不整合 | Probe `-dumpprops` の `Server`、`$NCHOME/etc/omni.dat`、`$NCHOME/etc/interfaces.<arch>` の三者が一致しているか確認 | omni.dat 修正 → `nco_xigen` 再生成 → Probe 再起動 |
| **B** | ファイアウォール / TCP ポート閉塞 | Probe ホストから `telnet objserv-host 4100`、または `nc -zv` で疎通確認 | ファイアウォール開放、または Probe のホスト配置見直し |
| **C** | SecureMode / SSL / 認証ミスマッチ | Probe 側 `SecureMode` と ObjectServer 側 `SecureMode` の片寄せ、kdb のラベル / 期限 | 両側 SecureMode 一致、`nc_gskcmd -cert -list` で証明書期限確認 |

_共通の最初の動作_: Probe を `-messagelevel debug -dumpprops` で起動し、接続前のすべてのプロパティと初期通信を log に出す。

**手順（共通）**:

1. Probe `-dumpprops` で実効プロパティ取得
2. omni.dat / interfaces / ObjectServer 側 listen 確認（`netstat`）
3. firewall / SecureMode 仮説別に確認
4. 修正 → 再接続テスト

**期待出力**:

```
2026-04-01 10:00:00 [INFO]  : Probe properties dumped to /tmp/syslog_dumpprops.log
2026-04-01 10:00:00 [DEBUG] : Connecting to NCOMS (192.168.1.10:4100)...
2026-04-01 10:00:00 [ERROR] : Failed to connect: Connection refused
```

**検証**: `nco_pa_status` で Probe RUNNING、ObjectServer log に `Probe X connected` が出ること、alerts.status にイベント蓄積。

**関連**: [cfg-probe-syslog](08-config-procedures.md#cfg-probe-syslog)

**出典**: S_OMN_BP（Chapter 5）, S_OMN_PROBE_GW

---

### inc-alerts-status-bloat: alerts.status の肥大化 { #inc-alerts-status-bloat }

**重要度**: `S` / **用途**: 性能 / 肥大

**目的**: alerts.status が数十万行〜数百万行と肥大化、応答遅延 / メモリ逼迫を引き起こしている状態の対処。

**仮説分岐**:

_トリガ事象_: `select count(*) from alerts.status;` が想定（small 10K / medium 50K / large 50K+）の桁外れ、Web GUI が重い、メモリ高使用率。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | housekeeping trigger group が disabled | `select Name, IsEnabled from catalog.trigger_groups;` で `housekeeping` / `default_triggers` の状態確認 | `alter trigger group housekeeping enabled;` |
| **B** | Probe rules で Identifier がユニーク化されすぎて deduplication が効いていない | 同一現象から多数の Identifier が生成されているかを `select count(distinct Identifier) from alerts.status where Node='X' and AlertGroup='Y';` で確認 | rules の Identifier 組成見直し（過剰なフィールド連結を削減） |
| **C** | DisableDetails 未設定で alerts.details が膨張 | `select count(*) from alerts.details;` が status 行数の数倍 | 詳細不要 Probe で `DisableDetails=1`、既存 alerts.details を `delete` で掃除 |

_共通の最初の動作_: 現状値（status 行数、details 行数、journal 行数）を保存、Severity 分布も。

**手順（共通）**:

1. 行数把握：`select count(*) from alerts.status; / from alerts.details; / from alerts.journal;`
2. Severity 分布：`select Severity, count(*) from alerts.status group by Severity;`
3. trigger group 確認 → A 対応
4. Identifier 偏り確認 → B 対応
5. details 比率確認 → C 対応
6. 大量削除は業務時間外に：`delete from alerts.status where Severity = 0 and StateChange < (now - 86400);`

**期待出力**:

```
[NCOMS] 1> select count(*) from alerts.status;
COUNT
-----
247389
[NCOMS] 1> select Severity, count(*) from alerts.status group by Severity;
SEVERITY  COUNT
0          189234   <- delete_clears が動いていない疑い
1            1234
2            8901
3           42891
5            5129
```

**検証**: 24 時間後に行数が安定、新規イベントの deduplication が効いていること（Tally が増えること）。

**関連**: [cfg-trigger-deploy](08-config-procedures.md#cfg-trigger-deploy)

**出典**: S_OMN_BP（Chapter 4 + 9）, S_OMN_HOUSEKEEPING

---

### inc-objserv-slow: ObjectServer 応答遅延 { #inc-objserv-slow }

**重要度**: `S` / **用途**: 性能 / 肥大

**目的**: ObjectServer の応答が秒単位で遅い、Web GUI 更新が遅延する状態の根本対処。

**仮説分岐**:

_トリガ事象_: SQL レイテンシが 1 秒超、Web GUI のページ切替で 5 秒以上、Probe log に `Server slow to respond`。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | 高コスト custom trigger（多重 FOR EACH ROW、WHERE に主キー以外） | profiling ON 後に `select Name, TotalTime from catalog.trigger_stats order by TotalTime desc;` の上位 trigger | trigger を IF-ELSEIF で 1 ループに統合（Best Practices v1.3 推奨）、WHERE に Identifier を使う |
| **B** | Impact ポリシーが過剰問い合わせ | Impact 側 service log で SQL 発行頻度 | Impact ポリシーで cache 利用、ObjectServer 側 trigger に処理を寄せる |
| **C** | Probe の流入が想定超（event storm） | `select count(*) from alerts.status where LastOccurrence > (now - 60);` が大きい | [inc-event-flood](#inc-event-flood) へ |

**手順（共通）**:

1. profiling ON（短時間、1 時間以内）
2. trigger_stats 上位確認
3. Impact / event 流入の量確認
4. profiling OFF

**関連**: [inc-event-flood](#inc-event-flood), [cfg-trigger-deploy](08-config-procedures.md#cfg-trigger-deploy)

**出典**: S_OMN_BP（Chapter 9）

---

### inc-failover-resync-fail: AGG_GATE で resync 完了せず { #inc-failover-resync-fail }

**重要度**: `S` / **用途**: failover / SMAC

**目的**: Primary 復旧後に AGG_GATE の resync が終わらず controlled failback できない状態の切り分け。

**仮説分岐**:

_トリガ事象_: Gateway log で `Resync started` の後 `Resync complete` が出ない、または target 側に古いままの行が残る。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | mapping table（複製対象）が両側で不一致 | `AGG_GATE.map` の定義と各 ObjectServer の alerts.* スキーマを照合 | mapping を両側スキーマに合わせて更新、Gateway 再起動 |
| **B** | 片側 trigger 内容差分（generic_clear 等を片側だけ修正したケース） | 両 ObjectServer で `select Name, IsEnabled, Body from catalog.triggers;` の diff | 両側で trigger を一致、特に SMAC では nco_confpack で同一 jar から投入 |
| **C** | Gateway cache 破損 | Gateway log の Status Serial が進まない、cache file の更新タイムスタンプ古い | Gateway 停止 → cache 削除 → 再起動で full resync |

**手順（共通）**:

1. Gateway log を `Resync` で grep
2. 両 ObjectServer の `count(*) from alerts.status;` 差分確認
3. 仮説別調査 → 修正 → Gateway 再起動

**期待出力**:

```
2026-04-01 12:00:00 [INFO]  : AGG_GATE: Resync started, target AGG_P locked (PARTIAL).
2026-04-01 12:01:30 [WARN]  : AGG_GATE: Status Serial mismatch on row 84529, mapping issue suspected.
2026-04-01 12:30:00 [ERROR] : AGG_GATE: Resync timeout (1800 seconds), aborting.
```

**関連**: [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair)

**出典**: S_OMN_BP（Chapter 7）, S_OMN_FAILOVER

---

### inc-iduc-stuck: Web GUI でイベントが流れてこない（IDUC 不通） { #inc-iduc-stuck }

**重要度**: `S` / **用途**: Web GUI

**目的**: AEL / Event Viewer が更新されない、新規イベントが Web GUI に出ない状態の切り分け。

**仮説分岐**:

_トリガ事象_: ObjectServer 側に新規イベントは入っている（`select count(*)` で増えている）が Web GUI が無反応。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | Iduc.Enabled / Iduc.ListeningPort 不整合、または ObjectServer 側で IDUC 接続拒否 | ObjectServer の `dumpprops`、`netstat` で IDUC ポート LISTEN 確認、Web GUI server log で `IDUC connection failed` | ObjectServer プロパティ修正 → 再起動 |
| **B** | Granularity が大きすぎ（数分単位） | プロパティで `Granularity` 確認 | 60 〜 120 秒に戻す、または AEN を併用（[cfg-aen-enable](08-config-procedures.md#cfg-aen-enable)） |
| **C** | A→D Gateway が止まっていて Display 層に新規イベントが届いていない | DSP_V の `select count(*)` が止まっている、Gateway log | A→D Gateway 再起動、または [inc-gateway-backlog](#inc-gateway-backlog) 参照 |

**手順（共通）**:

1. AGG / DSP の count(*) 比較
2. Iduc.* プロパティ + nco_aen 状態確認
3. Web GUI server log で IDUC connection 確認
4. 仮説別対応

**関連**: [cfg-aen-enable](08-config-procedures.md#cfg-aen-enable)

**出典**: S_OMN_BP, S_OMN_WEBGUI

---

### inc-eif-no-arrival: EIF イベントが alerts.status に到着しない { #inc-eif-no-arrival }

**重要度**: `S` / **用途**: Probe / Gateway

**目的**: ITM 側で EIF を送出しているのに OMNIbus に着かない状態。

**仮説分岐**:

_トリガ事象_: ITM 側 log では send 成功だが、`select * from alerts.status where AlertGroup like 'ITM%';` が増えない。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | tivoli_eif.rules / eif_default.rules の include 漏れ（特に predictive_event.rules のコメントアウト解除忘れ） | Probe log の `rules file loaded`、rules 内 include の有効化確認 | コメントアウト解除 → Probe HTTP `reload` |
| **B** | EIF アダプタ送信先の port / host 誤 | nco_p_tivoli_eif の listen port 確認、ITM 送信先確認 | ITM 側 EIF 送信先設定修正 |
| **C** | C-based EIF アプリの GSKit パス不整合（SSL 接続時） | LD_LIBRARY_PATH / LIBPATH で GSKit パス確認 | env 修正、aplリスタート |

**期待出力**:

```
2026-04-01 10:00:00 [INFO]  : Probe nco_p_tivoli_eif started, listening on tcp/5529.
2026-04-01 10:00:00 [INFO]  : tivoli_eif.rules loaded, included rules: eif_default.rules.
2026-04-01 10:00:00 [WARN]  : predictive_event.rules NOT included (commented out in tivoli_eif.rules).
```

**関連**: [cfg-probe-eif](08-config-procedures.md#cfg-probe-eif)

**出典**: S_OMN_EIF, S_OMN_ITM

---

### inc-pa-process-down: nco_pa_status で表示されるべきプロセスが居ない { #inc-pa-process-down }

**重要度**: `A` / **用途**: 起動 / 接続

**目的**: nco_pa_status の出力に期待プロセス（ObjectServer / Probe / Gateway）が見えない、または `STOPPED` 表示。

**手順**:

1. `ps -ef | grep nco_pad` で nco_pad 自体の生死確認
2. nco_pad 設定ファイルの process entries 確認
3. PA.Username / PA.Password 認証エラーの可能性を log で確認
4. 必要なら `nco_pa_start -server NCO_PA -process <name>` で個別起動

**関連**: [cfg-pa-deploy](08-config-procedures.md#cfg-pa-deploy)

**出典**: S_OMN_PA

---

### inc-event-flood: Event Storm（短時間で大量イベント流入） { #inc-event-flood }

**重要度**: `A` / **用途**: 性能 / 肥大

**目的**: 短時間で alerts.status に数千行 / 秒の流入があり ObjectServer が遅延。

**手順**:

1. `event_storm_signal STORM` で administrator に通知（事前設計が必要）
2. Probe rules で低 severity を discard：`if (@Severity <= 1) { discard }`
3. 一時的に Probe を `nco_pa_stop` で止める（業務影響と引き換え）
4. 根本原因（イベント送信元の機器障害等）を特定

**関連**: [inc-objserv-slow](#inc-objserv-slow)

**出典**: S_OMN_BP（Chapter 5）

---

### inc-gateway-backlog: Gateway で大量バックログ { #inc-gateway-backlog }

**重要度**: `A` / **用途**: failover / SMAC

**目的**: C→A や A→D Gateway で、source の更新が target に遅延蓄積している状態。

**手順**:

1. Gateway log で Status Serial の進行状況確認
2. target ObjectServer の負荷確認（profiling）
3. `Gate.ObjectServer*.BufferSize` 拡大（既定 50 → 100 など、Best Practices v1.3 検証下では 50 が最適）
4. ネットワーク遅延の確認

**関連**: [cfg-failover-pair](08-config-procedures.md#cfg-failover-pair)

**出典**: S_OMN_BP（Chapter 7）

---

### inc-rules-syntax-error: Probe rules の構文エラー { #inc-rules-syntax-error }

**重要度**: `A` / **用途**: Probe / Gateway

**目的**: rules 編集後 Probe が起動しない / reload 失敗する場合。

**手順**:

1. Probe log に `parse error at line N` で行番号特定
2. 該当行の構文確認（`if {}` の中括弧、`@` カラム名 typo、引用符閉じ忘れ）
3. 修正後 `Probe HTTP reload` で再読込

**関連**: [cfg-probe-syslog](08-config-procedures.md#cfg-probe-syslog)

**出典**: S_OMN_PROBE_GW

---

### inc-mib-trap-truncate: MIB Manager の trap 生成上限 { #inc-mib-trap-truncate }

**重要度**: `A` / **用途**: Probe / Gateway

**目的**: MIB → rules 変換で trap 数が上限で切られている。

**手順**:

1. MIB Manager の `Generating SNMP traps` で `Number of Traps` を必要数（例 5000 → 10000）に。
2. MIB を再ロードして再生成。
3. Probe rules に統合 → Probe HTTP reload。

**関連**: [cfg-probe-snmp](08-config-procedures.md#cfg-probe-snmp)

**出典**: S_OMN_MIB_MGR

---

### inc-waapi-error: WAAPI スクリプトがエラー応答 { #inc-waapi-error }

**重要度**: `A` / **用途**: Web GUI

**目的**: `runwaapi` の応答 XML に error が返る。

**手順**:

1. 応答 XML をファイル化（`-outfile`）してエラーコード確認
2. Web GUI ユーザのロール / 権限確認
3. コマンド XML を最小例に縮退して切り分け
4. Web GUI server log で server 側応答確認

**関連**: [cfg-webgui-waapi](08-config-procedures.md#cfg-webgui-waapi)

**出典**: S_OMN_WAAPI

---

### inc-omni-dat-mismatch: omni.dat と interfaces ファイルが不整合 { #inc-omni-dat-mismatch }

**重要度**: `B` / **用途**: 起動 / 接続

**目的**: omni.dat 編集後 nco_xigen を忘れた、または別の omni.dat を見ている。

**手順**:

1. `$NCHOME/etc/omni.dat` の最終更新時刻と interfaces.<arch> の最終更新時刻を比較
2. `nco_xigen` 実行で interfaces 再生成
3. Probe / Gateway / nco_sql で接続テスト

**関連**: [cfg-objserv-create](08-config-procedures.md#cfg-objserv-create)

**出典**: S_OMN_BP

---

### inc-disk-full-log: log 肥大化でディスク逼迫 { #inc-disk-full-log }

**重要度**: `B` / **用途**: 性能 / 肥大

**目的**: `$OMNIHOME/log/` 配下でディスク逼迫。

**手順**:

1. `du -sh $OMNIHOME/log/*` でサイズ確認
2. logrotate 設定の見直し（OS 側）
3. ObjectServer / Probe の MessageLevel が `debug` で放置されていないか確認 → `info` に戻す

**出典**: S_OMN_BP

---

### inc-probe-orphan-row: Probe 切断中の orphan event { #inc-probe-orphan-row }

**重要度**: `B` / **用途**: Probe / Gateway

**目的**: Probe が再接続できなかった期間のイベントが alerts.status に取り残される。

**手順**:

1. `select * from alerts.status where ServerName = '<old probe>' and LastOccurrence < (now - <閾値>);`
2. Probe 名 / Node 名で絞って delete
3. Probe 側 buffering の見直し（Probe Reference Guide 参照）

**出典**: S_OMN_PROBE_GW

---

### inc-trigger-loop: trigger の無限ループ { #inc-trigger-loop }

**重要度**: `C` / **用途**: 性能 / 肥大

**目的**: custom trigger が自身の更新で再発火を繰り返している状況。

**手順**:

1. profiling ON で `trigger_stats` の `NumZeroes` 異常上昇を確認
2. trigger を `disabled` にして停止
3. 条件を WHEN 句で絞る（最終更新からの経過時間判定など）

**出典**: S_OMN_BP

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
