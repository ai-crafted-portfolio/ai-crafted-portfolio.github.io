# トラブル早見表

> 掲載：**20 件**。症状起点で見つけて、詳細手順へジャンプする入り口。詳細・A/B/C 仮説分岐は [10. 障害対応手順](09-incident-procedures.md)。

## カテゴリ別目次

- **接続 / 起動**: 5 件
- **性能 / 肥大化**: 5 件
- **Policy / Audit Process**: 4 件
- **VA / Discovery / ATA**: 3 件
- **Aggregator / Archive**: 3 件

---

## 接続 / 起動

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| S-TAP が Collector に接続しない | guard_tap.ini の Collector IP / FQDN 誤、ファイアウォール 16016/16017 閉塞、SSL 証明書期限切れ、Collector 自体が down | DB サーバで `ps -ef \| grep -i tap`、`tap_diag` 実行、`telnet <collector> 16016` で疎通確認、CM UI の S-TAP Status | [inc-stap-conn-fail](09-incident-procedures.md#inc-stap-conn-fail) |
| guard_stap プロセスが居ない | K-TAP モジュール ロード失敗、カーネル更新後の互換問題、`guard_tap.sh start` が起動失敗 | `dmesg \| grep -i ktap`、`/var/log/messages`、`/usr/local/guardium/log/` の startup ログ | [inc-stap-down](09-incident-procedures.md#inc-stap-down) |
| Collector が起動しない / Web UI 8443 が開かない | 内部 DB 起動失敗、ディスク満杯（auto_stop_services_when_full）、証明書不整合 | `restart system` 後 `support show high cpu`、`/var` 使用率、`show system info` | [inc-collector-down](09-incident-procedures.md#inc-collector-down) |
| GIM が CM に接続しない | gim_sqlguardip 誤、GIM 証明書期限切れ（GIM 12.2 系で SHA1 / SHA256 切替）、CM 側 8444 / 8445 閉塞 | DB サーバで `ps -ef \| grep -i gim`、CM UI の Module Installation 表示、CM 側証明書（`show certificate stored`） | [inc-gim-conn-fail](09-incident-procedures.md#inc-gim-conn-fail) |
| Patch が Managed Unit に届かない | Distribution Profile 未設定、CM ↔ MU 証明書不整合、MU 側 fileserver 閉鎖 | CM の Patch Distribution Status、`show certificate exceptions`、MU 側 `support show network connections` | [inc-patch-distribution-fail](09-incident-procedures.md#inc-patch-distribution-fail) |

## 性能 / 肥大化

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| Sniffer が頻繁に restart する | Buffer Free 低下、信頼アプリ未除外、`Log Records Affected` 有効、`Inspect Returned Data` 有効、event flood | Inspection Engine の Buffer Free、Sniffer Restart Threshold、event 流入元 IP 分布 | [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) |
| Inspection Engine が応答しない / restart loop | 不正な Policy（Custom Class 例外）、Parse Tree 失敗、メモリ枯渇 | Engine の error log、Policy install 履歴（直前変更）、`support show high memory` | [inc-engine-restart-loop](09-incident-procedures.md#inc-engine-restart-loop) |
| 内部 DB / `/var` が 90% 超 | Daily Purge 未実行、long retention 設定ミス、Audit Process の CSV 出力滞留 | `df -h /var`、Data Management Schedule（Archive / Import / Purge の実行履歴）、Audit Process の result file サイズ | [inc-disk-full](09-incident-procedures.md#inc-disk-full) |
| Audit Process が異常に遅い / タイムアウト | remote source 結果 100,000 件超、CSV 10GB 上限到達、Datasource 遅延、Aggregator overload | Audit Process Log、`store save_result_fetch_size` 設定、Aggregator 側 `support show high cpu` | [inc-audit-process-stuck](09-incident-procedures.md#inc-audit-process-stuck) |
| Web UI 8443 が遅い / hang | Tomcat heap 不足、長時間 query、複数管理者同時操作 | `support show high cpu`（java プロセス）、Investigate Dashboard でクエリ履歴 | [inc-web-ui-slow](09-incident-procedures.md#inc-web-ui-slow) |

## Policy / Audit Process

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| Policy 保存後にアラート / ログが出ない | Policy Installation 未実行（保存だけ）、Inspection Engine が違う Policy を install 済、ルール順序問題 | `grdapi list_policy` で INSTALLED 確認、Policy Installation tool で配備状態確認 | [inc-policy-not-active](09-incident-procedures.md#inc-policy-not-active) |
| アラートが配信されない | Global Profile の SMTP / SNMP / Syslog 未設定、Receivers のメール無効、Threshold Alerter 停止 | Reports > Threshold Alerter Status、Setup > Tools and Views > Global Profile、Audit Process Log | [inc-alert-not-delivered](09-incident-procedures.md#inc-alert-not-delivered) |
| Policy 内で参照している Group が空 | populate group の query 失敗、Datasource 接続エラー、Group ID 変更（参照断） | Group の Last Populated 時刻、Datasource Test Connection、Policy ルールの Group 参照 ID | [inc-group-populate-fail](09-incident-procedures.md#inc-group-populate-fail) |
| ブロッキング Policy が誤動作（業務 SQL を切る） | S-GATE TERMINATE のルール条件が広すぎ、Group の包含範囲誤、優先順位上位の Policy が先に発火 | Policy Analyzer、ルール条件（Object/Command/User の組合せ）、ブロッキング履歴 | [inc-blocking-misfire](09-incident-procedures.md#inc-blocking-misfire) |

## VA / Discovery / ATA

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| VA scan が失敗する | Datasource credentials 期限切れ / 権限不足、SSL 証明書 trust 未登録、対象 DB 未対応バージョン | View Results、`store certificate keystore trusted console` 状態、サポート対象 DB 版（What's new） | [inc-va-scan-fail](09-incident-procedures.md#inc-va-scan-fail) |
| Sensitive Data Discovery が完了しない | 対象 DB が大きい（partition 単位の走査推奨）、検出パターン過多、Network 帯域不足 | Classification Process Log、対象 DB の table size、走査時間 | — |
| ATA case が 1 つも生成されない | Outliers Mining 未起動、ベースライン期間（既定 7 日）未経過、ポリシー閾値が緩すぎる | ATA dashboard、Outliers Mining 設定、`grdapi list_ata_case_severity` | — |

## Aggregator / Archive

| 症状 | よくある原因 | 切り分けのとっかかり | 詳細手順 |
|---|---|---|---|
| Aggregator への Daily Import が失敗する | Collector 側 Archive 未完了、Aggregator 容量不足、network MTU 不整合、order 違反（Archive 前に Purge） | Data Management Schedule の History、Aggregator `df -h /var`、Collector 側 archive log | [inc-aggregator-import-fail](09-incident-procedures.md#inc-aggregator-import-fail) |
| Long-term retention（S3）への転送が止まる | endpoint 認証エラー、bucket 容量上限、network outbound 閉塞 | `grdapi configure_complete_cold_storage` の get、S3 側監査ログ、curl で endpoint 疎通 | [inc-cold-storage-fail](09-incident-procedures.md#inc-cold-storage-fail) |
| Aggregator のレポートが古いデータのまま | Daily Import の lag、Aggregator Parallel Query 未有効化、partition 不整合 | Daily Import の最終成功時刻、Aggregator 側の最新 timestamp、Parallel Query option 設定 | — |

## 共通の最初の動作

どの症状でも、最初に取る情報は固定：

1. **ChromaDB に投入された IBM Docs 公式マニュアル**（[02. コマンド > support](01-commands.md#support) 参照）
2. `cli> show system info` / `support show high cpu` / `support show high memory` / `df -h /var`
3. `support must_gather full` で診断情報一括収集 → `fileserver` で取り出し
4. CM 側で Managed Unit Status / Patch Distribution Status の確認
5. DB サーバ側で `ps -ef | grep -i gim`、`ps -ef | grep -i tap`、`tap_diag`

これらを揃えてから A/B/C 仮説分岐（[10. 障害対応手順](09-incident-procedures.md) 参照）に進む。

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
