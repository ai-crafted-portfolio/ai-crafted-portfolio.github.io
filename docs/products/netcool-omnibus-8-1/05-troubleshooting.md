# トラブル早見表

> 掲載：**20 件**。症状起点で見つけて、詳細手順へジャンプする入り口。詳細・A/B/C 仮説分岐は [10. 障害対応手順](09-incident-procedures.md)。

## カテゴリ別目次

- **接続 / 起動**: 6 件
- **性能 / 肥大化**: 4 件
- **failover / SMAC**: 3 件
- **Probe / Gateway**: 4 件
- **Web GUI / WAAPI**: 3 件

---

## 接続 / 起動

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| ObjectServer が起動しない（`nco_objserv` exit） | プロパティファイル誤り、ポート競合、`Memstore.DataDirectory` 不整合、SSL 設定不整合 | `$OMNIHOME/log/<ObjectServerName>.log` の last 50 行確認、`-messagelevel debug` で再起動 | [inc-objserv-startup-fail](09-incident-procedures.md#inc-objserv-startup-fail) |
| ObjectServer が突然 hang / unresponsive | 長時間 hold trigger、Profile が ON 放置、メモリ枯渇 | `show locks;` で長時間 hold 確認、Profile が ON なら OFF | [inc-objserv-hang](09-incident-procedures.md#inc-objserv-hang) |
| Probe が ObjectServer に接続できない | omni.dat / interfaces 不整合、ポート閉塞、SecureMode 不一致 | Probe を `-messagelevel debug -dumpprops` で起動、ログで接続エラー確認 | [inc-probe-conn-fail](09-incident-procedures.md#inc-probe-conn-fail) |
| nco_pa_status で表示されるべきプロセスが居ない | nco_pad 未起動、process entry 漏れ、PA.Username 認証失敗 | `ps -ef \| grep nco_pad`、PA 設定ファイル確認 | [inc-pa-process-down](09-incident-procedures.md#inc-pa-process-down) |
| `nco_xigen` 後も Probe が古い接続先を見ている | Probe のキャッシュ、Probe HTTP `reload` 未実行、別 omni.dat を見ている | Probe を `-dumpprops` で `Server` プロパティ確認、`$NCHOME/etc/omni.dat` を `cat` で再確認 | [inc-probe-conn-fail](09-incident-procedures.md#inc-probe-conn-fail) |
| nco_sql が `Connection refused` で繋がらない | ObjectServer 未起動、ファイアウォール、`-server` 名 typo | `nco_pa_status`、interfaces ファイルの port 確認 | [inc-objserv-startup-fail](09-incident-procedures.md#inc-objserv-startup-fail) |

## 性能 / 肥大化

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| alerts.status が肥大化（数十万行〜） | `delete_clears` 無効、`hk_set_expiretime` 無効、`ExpireTime=0` 多数、deduplication 未設計 | `select count(*) from alerts.status;`、trigger group の状態確認 | [inc-alerts-status-bloat](09-incident-procedures.md#inc-alerts-status-bloat) |
| ObjectServer の応答が遅い（SQL レイテンシ増） | 高コスト custom trigger、Impact ポリシーが過剰問い合わせ、profiling 放置 | profiling ON → trigger statistics 取得 → 高コスト trigger 特定 → profiling OFF | [inc-objserv-slow](09-incident-procedures.md#inc-objserv-slow) |
| 大量イベントが短時間で来て alerts.status が爆発 | event storm、Probe rules で discard 未実装 | event storm signal で通知、Probe で低 severity discard | [inc-event-flood](09-incident-procedures.md#inc-event-flood) |
| メモリ枯渇で nco_objserv が OOM | alerts.status 肥大、JVM 系 Probe との同居、Profile 長時間 ON | OS 側 free / vmstat、ObjectServer 行数、profiling 状態 | [inc-objserv-hang](09-incident-procedures.md#inc-objserv-hang) |

## failover / SMAC

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| AGG_GATE で resync が終わらない | Gateway cache 不整合、mapping table 漏れ、片側 trigger 不一致 | Gateway log で Status Serial 確認、両 ObjectServer で trigger の SQL diff | [inc-failover-resync-fail](09-incident-procedures.md#inc-failover-resync-fail) |
| Primary 復旧後も Probe が Backup に居続ける | 自動 failback 設定、controlled failback の resync 未完、virtual 名と Server プロパティ不一致 | Probe `-dumpprops` で Server / ServerBackup 確認、AGG_GATE log の resync 完了確認 | [inc-failover-resync-fail](09-incident-procedures.md#inc-failover-resync-fail) |
| Aggregation 障害後にイベントが Display 層に流れない | A→D Gateway 停止、IDUC 不通、Display 側 trigger 不在 | A→D Gateway の nco_pa_status、Display ObjectServer の `select count(*)` | [inc-iduc-stuck](09-incident-procedures.md#inc-iduc-stuck) |

## Probe / Gateway

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| Probe で rules 修正したのに反映されない | reload 未実行、rules ファイルパス不一致、構文エラー | Probe HTTP `reload` 実行、Probe log で構文エラー確認 | [inc-rules-syntax-error](09-incident-procedures.md#inc-rules-syntax-error) |
| EIF イベントが alerts.status に到着しない | tivoli_eif.rules / eif_default.rules の include 漏れ、EIF アダプタ送信先誤、GSKit パス不整合 | nco_p_tivoli_eif の log、tivoli_eif.rules、LIBPATH 確認 | [inc-eif-no-arrival](09-incident-procedures.md#inc-eif-no-arrival) |
| MIB Manager で SNMP Trap 生成が打ち切られる | Number of Traps 上限、MIB ファイル構文不一致 | MIB Manager で Number of Traps 引上げ、MIB 再ロード | [inc-mib-trap-truncate](09-incident-procedures.md#inc-mib-trap-truncate) |
| C→A Gateway で大量バックログ | バッファサイズ不足、ターゲット側遅い、ネットワーク逼迫 | Gateway log の Status Serial、ターゲット ObjectServer の負荷 | [inc-gateway-backlog](09-incident-procedures.md#inc-gateway-backlog) |

## Web GUI / WAAPI

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| Web GUI でイベントが更新されない（AEL 無反応） | IDUC 不通、`Granularity` 過大、ObjectServer 側 IDUC 接続拒否、AEN 未起動 | Iduc.ListeningPort、Granularity、nco_aen の起動確認 | [inc-iduc-stuck](09-incident-procedures.md#inc-iduc-stuck) |
| WAAPI スクリプトがエラー XML を返す | ユーザ権限不足、XML 構文不正、接続先誤、Web GUI のキャッシュ | runwaapi 出力 XML 確認、Web GUI ユーザのロール、Web GUI server log | [inc-waapi-error](09-incident-procedures.md#inc-waapi-error) |
| Web GUI に新しいイベントは出るが Severity 色が更新されない | trigger（generic_clear / hk_de_escalate_events）停止、IDUC delta が UPDATE を通さない | trigger group 状態確認、Web GUI の filter / view 設定 | [inc-iduc-stuck](09-incident-procedures.md#inc-iduc-stuck) |

## 共通の最初の動作

どの症状でも、最初に取る情報は固定：

1. `$OMNIHOME/log/<ObjectServerName>.log`、`$OMNIHOME/log/<probe>.log`、`$OMNIHOME/log/<gateway>.log` の **直近 200 行**
2. `nco_pa_status -server <PA>` で配下プロセスの稼働状況
3. `nco_sql` で `select count(*) from alerts.status;` と各 trigger group の `enabled` 状態
4. `dumpprops` 系で各プロセスの実効プロパティ

これらを揃えてから A/B/C 仮説分岐（[10. 障害対応手順](09-incident-procedures.md) 参照）に進む。

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
