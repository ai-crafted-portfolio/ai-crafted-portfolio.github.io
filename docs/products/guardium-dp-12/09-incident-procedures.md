# 障害対応手順

> 掲載：**18 件（S/A/B/C × 用途、S 級は A/B/C 仮説分岐付き）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## 重要度 × 用途 マトリクス

<div class="md-typeset__scrollwrap" markdown="1">

| 重要度＼用途 | 起動 / 接続 | 性能 / 肥大 | Policy / Audit | Aggregator / Archive | アクセス / 証明書 |
|---|---|---|---|---|---|
| **S** | [inc-stap-conn-fail](#inc-stap-conn-fail)<br>[inc-collector-down](#inc-collector-down) | [inc-sniffer-overload](#inc-sniffer-overload)<br>[inc-disk-full](#inc-disk-full) | [inc-policy-not-active](#inc-policy-not-active) | [inc-aggregator-import-fail](#inc-aggregator-import-fail) | — |
| **A** | [inc-stap-down](#inc-stap-down)<br>[inc-gim-conn-fail](#inc-gim-conn-fail) | [inc-engine-restart-loop](#inc-engine-restart-loop)<br>[inc-system-slow](#inc-system-slow) | [inc-blocking-misfire](#inc-blocking-misfire)<br>[inc-audit-process-stuck](#inc-audit-process-stuck) | [inc-cold-storage-fail](#inc-cold-storage-fail) | [inc-cert-expiry](#inc-cert-expiry) |
| **B** | [inc-patch-distribution-fail](#inc-patch-distribution-fail) | [inc-web-ui-slow](#inc-web-ui-slow) | [inc-alert-not-delivered](#inc-alert-not-delivered)<br>[inc-group-populate-fail](#inc-group-populate-fail) | — | — |
| **C** | — | — | [inc-va-scan-fail](#inc-va-scan-fail) | — | — |

</div>

---

## 詳細手順

### inc-stap-conn-fail: S-TAP → Collector 接続失敗 { #inc-stap-conn-fail }

**重要度**: `S` / **用途**: 起動 / 接続

**目的**: DB サーバ上の S-TAP が Collector に接続できず、CM UI で当該 DB が **赤** または **見えない** 状態の切り分け。

**前提**: CM Web Console と DB サーバの両方にアクセス可。S-TAP のログ（`/usr/local/guardium/log/`）と guard_tap.ini が読める。

**仮説分岐**:

_トリガ事象_: DB サーバで `tap_diag` が `Connection failed`、または CM UI で S-TAP Status が RED / Last Heartbeat が古い。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | guard_tap.ini の Server List 誤、または FQDN 名前解決失敗 | DB サーバで `nslookup col01.gdemo.com`、`grep Server /usr/local/guardium/modules/STAP/*/guard_tap.ini` | guard_tap.ini 修正（CM UI からの設定書換も可）→ S-TAP 再起動 |
| **B** | ファイアウォール / TCP 16016 / 16017 閉塞 | DB サーバから `telnet <collector> 16016` / `nc -zv <collector> 16016`、Collector 側 `support show network connections` で受信ポート確認 | ファイアウォール開放、または Failover Collector で迂回 |
| **C** | 証明書期限切れ / SHA1↔SHA256 不整合（GIM 12.2 系） | CM 側 `show certificate stored`、`show certificate exceptions`、`grdapi get_certificates`、DB サーバ側 `/usr/local/guardium/modules/GIM/*/cert/` の expiry | [cfg-cert-rotation](08-config-procedures.md#cfg-cert-rotation) に従い rotation |

_共通の最初の動作_: DB サーバで `tap_diag` の出力 / `/var/log/messages` / `/usr/local/guardium/log/guard_stap.log` の最新 200 行を保存。

**手順（共通）**:

1. `tap_diag` 実行
2. Collector 側 `support show network connections` で当該 DB サーバ IP からの接続有無確認
3. 仮説別に切り分け
4. 修正後、`guard_tap.sh restart` で S-TAP 再起動 → CM UI で GREEN を確認

**期待出力**:

`tap_diag` 失敗例:

```
S-TAP Diagnostic Report
=========================
Configured Primary Collector : col01.gdemo.com:16016
Connection                   : FAILED  (timeout after 30s)
Configured Failover Collector: col02.gdemo.com:16016
Connection                   : OK
GIM Daemon                   : RUNNING (PID 10234)
guard_stap                   : RUNNING (PID 10310)
=========================
RECOMMENDATION: Primary collector unreachable; check network or firewall.
```

**検証**: `tap_diag` で Primary Collector が OK、CM UI で GREEN、Activity Monitor で SQL が見える。

**ロールバック**: 設定変更前の guard_tap.ini に戻して S-TAP 再起動。

**関連**: [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy), [cfg-stap-failover](08-config-procedures.md#cfg-stap-failover), [cfg-cert-rotation](08-config-procedures.md#cfg-cert-rotation)

**出典**: S35, S37, S73, S74

---

### inc-collector-down: Collector 起動失敗 / Web UI 8443 が開かない { #inc-collector-down }

**重要度**: `S` / **用途**: 起動 / 接続

**目的**: `restart system` 後または運用中に Web UI 8443 が開かない / `cli` ログイン不可の状態の切り分け。

**仮説分岐**:

_トリガ事象_: Web UI が応答しない、SSH `cli` ログインできない、または `cli` ログインできても `show system info` が hang。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | 内部 DB（MySQL）起動失敗 | コンソールログで `mysql startup failed`、`/var/log/guard/db_init.log`、`auto_stop_services_when_full` で停止しているか確認 | `df -h /var` で使用率確認、超過なら [inc-disk-full](#inc-disk-full) へ。それ以外は IBM サポート（must_gather） |
| **B** | ディスク満杯（`/var` 90% 超） | `df -h /var`、auto_stop_services_when_full の挙動でサービス停止しているか | [inc-disk-full](#inc-disk-full) に従い緊急 purge / 拡張 |
| **C** | 証明書不整合 / Tomcat 起動失敗 | `restart gui` 単独で UI 復旧するか、`/var/log/guard/tomcat.log`、`show certificate stored` の有効期限 | 証明書問題なら [inc-cert-expiry](#inc-cert-expiry)、Tomcat 設定なら IBM サポート |

_共通の最初の動作_: コンソール直接ログイン → `df -h`、`free -m`、`support show high cpu`、`/var/log/guard/` の主要 log の last 200 行を保存。

**手順（共通）**:

1. コンソール（KVM / iLO / IPMI）で `cli` ログイン
2. `df -h /var` でディスク確認
3. `restart gui` で軽症復旧を試行
4. NG なら `restart system`（再起動）
5. それでも NG なら `support must_gather full` で診断情報を集めて IBM サポートへ

**期待出力**:

`restart gui` 成功時:

```
cli> restart gui
Restarting Web Console (Tomcat)...
[OK] Tomcat stopped (PID 9821)
[OK] Tomcat started (PID 12044, port 8443)
Web Console is now reachable at https://col01.gdemo.com:8443/
```

**検証**: Web UI 8443 にブラウザでログイン、System view ダッシュボードが緑表示、`support show high cpu` で sniffer / mysql / java が稼働。

**関連**: [inc-disk-full](#inc-disk-full), [inc-cert-expiry](#inc-cert-expiry)

**出典**: S64, S77, S79

---

### inc-sniffer-overload: Sniffer overload / restart ループ { #inc-sniffer-overload }

**重要度**: `S` / **用途**: 性能 / 肥大

**目的**: Sniffer が S-TAP からの流量を捌ききれず restart を繰り返している状態を解消。

**仮説分岐**:

_トリガ事象_: Inspection Engine の Buffer Free が 10% 切る、Sniffer Restart Threshold を頻繁に超える、Activity Monitor のラグが拡大。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | 信頼アプリ（バックアップ / 監視 / Zabbix 等）が監視対象に流れ込み流量過剰 | event 流入元 IP の上位、Source Program の上位 | Session-level Policy で `IGNORE SESSION` 設定（[cfg-policy-session](08-config-procedures.md#cfg-policy-session)） |
| **B** | `Log Records Affected` 有効、または `Inspect Returned Data` 有効で大量のデータ復号 | Inspection Engine 設定確認 | 必要のない Engine では OFF。required な場合は `store max_results_set_size` / `store max_result_set_packet_size` を低めに |
| **C** | event flood / DB 異常クエリの大量発生 | 直近の Severity 分布、特定 Identifier の急増 | DB 側の異常確認 → 業務側に確認 → 必要なら IGNORE SESSION で一時遮断 |

_共通の最初の動作_: 直近 30 分の event flow（Reports / Investigate Dashboard）を保存し流入元を特定。

**手順（共通）**:

1. Inspection Engine の Buffer Free を確認
2. 上位 Source Program / IP / User を分析
3. 仮説別に Policy / Engine 設定を変更
4. 効果確認（Buffer Free 80% 以上に戻る、Sniffer Restart 件数が下がる）

**期待出力**:

Buffer usage monitor:

```
Engine: db01_db2_eng01
Buffer Free   : 4%       (CRITICAL)
Sessions       : 384
Sniffer Restart Threshold reached: 7 times in last hour
Top source programs:
  1. zabbix_agent2     - 62.4 % of traffic
  2. backup_runner.py  - 18.1 % of traffic
  3. user app          - 11.7 %
```

→ IGNORE SESSION で zabbix_agent2 / backup_runner.py を除外後:

```
Buffer Free   : 87%      (OK)
Sessions       : 142
Sniffer Restart Threshold reached: 0 times in last hour
```

**検証**: Buffer Free 80% 以上で安定、Sniffer Restart 0 件 / 時、Activity Monitor のラグ消滅。

**関連**: [cfg-policy-session](08-config-procedures.md#cfg-policy-session), [cfg-inspection-engine](08-config-procedures.md#cfg-inspection-engine)

**出典**: S39, S40, S76, S87, S94

---

### inc-disk-full: 内部 DB / `/var` 90% 超 { #inc-disk-full }

**重要度**: `S` / **用途**: 性能 / 肥大

**目的**: 内部 DB / `/var` 使用率が 90% を超え、`auto_stop_services_when_full` が走ってサービス停止する手前 / 直後の対応。

**仮説分岐**:

_トリガ事象_: `df -h /var` で 90% 超、または auto_stop によりサービスが停止し UI が応答しなくなった。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | Daily Purge が動いていない / 実行失敗 | Comply > Tools and Views > Data Management Schedule の Purge 履歴 | 手動 Purge（Comply > Purge）、retention 期間短縮、Schedule 修復 |
| **B** | Audit Process の CSV 出力が大きく滞留 | `/var/IBM/Guardium/data/audit_results/` のサイズ、`store save_result_fetch_size` 設定 | 古い結果ファイルを `fileserver` で取り出して削除、`save_result_fetch_size` 縮小 |
| **C** | データ流入急増（Policy / Engine 変更後に Log Full Details が増えた等） | Inspection Engine の `Log Full Details` 行数推移、最近の Policy 変更履歴 | 一時的に Logging Granularity を粗く、または Skip Logging に切替、根本対応として [inc-sniffer-overload](#inc-sniffer-overload) |

_共通の最初の動作_: `df -h`、`du -sh /var/IBM/Guardium/data/*` で使用 top カテゴリを特定。`Purging data to resolve full disk`（S79）の手順を確認。

**手順（共通）**:

1. `df -h /var` 確認
2. 大きいディレクトリ特定（`du -sh ...`）
3. 仮説別の対応（Purge / 結果ファイル削除 / Logging 粒度調整）
4. 90% 切ったら `store auto_stop_services_when_full on` のまま放置（既定）
5. 容量設計の見直し（[cfg-archive-purge](08-config-procedures.md#cfg-archive-purge)）

**期待出力**:

緊急 Purge 後:

```
cli> df -h /var
Filesystem      Size  Used Avail Use% Mounted on
/dev/mapper/vg-var  500G  280G  220G  56% /var
```

**検証**: `/var` 使用率 60% 以下に低下、Web UI 応答復活。Daily Purge を Schedule に再登録、retention 計画を見直し。

**注意点**: `auto_stop_services_when_full off` は **緊急時の一時的措置のみ**。OFF のままディスク満杯まで進むと内部 DB 破損リスク。

**関連**: [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge), [inc-sniffer-overload](#inc-sniffer-overload)

**出典**: S79, S81, S2

---

### inc-policy-not-active: Policy 保存後にアラート / ログが出ない { #inc-policy-not-active }

**重要度**: `S` / **用途**: Policy / Audit

**目的**: Policy Builder で保存した Policy が動作しない（アラート未発火、ログ未生成）状態の切り分け。

**仮説分岐**:

_トリガ事象_: 期待した Policy 一致イベントが Investigate Dashboard / Reports に出ない。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | Policy Installation 未実行（保存だけ） | `grdapi list_policy` で `NOT INSTALLED`、Policy Installation tool で配備履歴確認 | Policy Installation tool で `Add Policy` → `Install`（[cfg-policy-build](08-config-procedures.md#cfg-policy-build)） |
| **B** | 別 Policy が install 済で当該 Policy が外れた / 順序問題 | 現在の Policy stack（Policy Installation tool 上で見える順序） | 必要な Policy をすべて install 順に並べ直し |
| **C** | ルール条件不適合（Group メンバ不在 / Object 名不整合 / Inspection Engine の Active off） | Policy Analyzer 結果、対象 Inspection Engine の Active on startup、Group の populate 状態 | Policy Analyzer の指摘修正、Group / Engine 状態修正 |

_共通の最初の動作_: `grdapi list_policy` で INSTALLED 状態確認、Policy Analyzer（Setup > Tools and Views）実行。

**手順（共通）**:

1. `grdapi list_policy` で対象 Policy が INSTALLED か
2. Policy Installation tool で stack を確認、必要に応じ再 Install
3. Policy Analyzer で衝突 / 重複チェック
4. テストイベント（既知の対象 Object / User）を流して発火確認
5. アラート未発火なら [inc-alert-not-delivered](#inc-alert-not-delivered) も合わせて確認

**期待出力**:

```
cli> grdapi list_policy
ID 12  PCI Audit Policy           ACCESS    NOT INSTALLED   <-- これ
```

→ install 後:

```
cli> grdapi install_policy policy="PCI Audit Policy"
SUCCESS: Policy installed (size=82 rules, install_id=204)
cli> grdapi list_policy
ID 12  PCI Audit Policy           ACCESS    INSTALLED
```

**検証**: テスト SQL 実行後、対象 Reports / Investigate Dashboard でログが流れること、アラート Receivers にメール / SIEM 通知到達。

**関連**: [cfg-policy-build](08-config-procedures.md#cfg-policy-build), [inc-alert-not-delivered](#inc-alert-not-delivered)

**出典**: S12, S50, S51, S72

---

### inc-aggregator-import-fail: Aggregator Daily Import 失敗 { #inc-aggregator-import-fail }

**重要度**: `S` / **用途**: Aggregator / Archive

**目的**: Aggregator が Collector からの Daily Import を完了できない状態の切り分け。

**仮説分岐**:

_トリガ事象_: Data Management Schedule History で Daily Import が `FAILED`、または Aggregator のレポートが古い timestamp のまま。

| 仮説 | 内容 | 見分け方 | 対応 |
|---|---|---|---|
| **A** | Collector 側 Archive 未完了（順序違反） | Collector 側 Archive ジョブの最終成功時刻、Aggregator Import ジョブの開始時刻の前後関係 | Schedule の開始時刻を Archive 完了 + 30 分にずらす |
| **B** | Aggregator 容量不足（`/var` 80% 超） | Aggregator `df -h /var`、Daily Purge 履歴 | Aggregator 側 Purge / retention 短縮 / 拡張 |
| **C** | Network MTU 不整合 / 接続切断 | Aggregator log の transfer 失敗エラー、`support show network connections` | MTU 統一、必要に応じ keepalive チューニング |

_共通の最初の動作_: Aggregator 側 Data Management Schedule の History 全件と `/var/log/guard/aggregation.log` の last 200 行を保存。

**手順（共通）**:

1. ジョブ History を時系列で確認（Archive → Import → Purge の順守）
2. 容量・MTU・network を仮説別に確認
3. 修正後、Run once now で Import を試行
4. 連続成功確認

**期待出力**:

```
[Aggregator] Daily Import from col01.gdemo.com  FAILED
  Error: peer disconnected after 5.2 GB / 8.1 GB transferred
  Retry attempts: 3
[Aggregator] Daily Import from col02.gdemo.com  OK
```

→ MTU 統一後:

```
[Aggregator] Daily Import from col01.gdemo.com  OK  (8.1 GB / 03:24)
[Aggregator] Daily Import from col02.gdemo.com  OK  (7.8 GB / 02:58)
```

**検証**: Aggregator のレポート（Daily Activity Summary）で Collector 群すべての最新 timestamp が当日深夜になっていること。

**関連**: [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge), [inc-disk-full](#inc-disk-full)

**出典**: S43, S75, S81, S82

---

### inc-stap-down: guard_stap プロセスが居ない { #inc-stap-down }

**重要度**: `A` / **用途**: 起動 / 接続

**目的**: DB サーバで `ps -ef \| grep -i tap` しても guard_stap が見つからない状態の対応。`guard_gimd` は居る前提。

**手順**: `dmesg \| grep -i ktap` で K-TAP モジュール ロード失敗を確認 → `--ktap_allow_module_combos` でカーネル互換問題を回避 → 必要なら DB サーバ再起動。`guard_tap.sh start` で起動試行、それでも NG なら IBM サポートへ K-TAP 互換性確認。

**関連**: [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy)

**出典**: S35

---

### inc-gim-conn-fail: GIM が CM に接続しない { #inc-gim-conn-fail }

**重要度**: `A` / **用途**: 起動 / 接続

**目的**: DB サーバ上で `guard_gimd` は走っているが CM UI の Module Installation で当該ホストが見えない / RED の状態を解消。

**手順**: DB サーバから CM の 8444 / 8445 への疎通確認、GIM 証明書（`/usr/local/guardium/modules/GIM/*/cert/`）の有効期限を確認、SHA1 / SHA256 切替の整合確認、CM 側 `show certificate stored`。証明書問題なら [cfg-cert-rotation](08-config-procedures.md#cfg-cert-rotation)。

**関連**: [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy), [cfg-cert-rotation](08-config-procedures.md#cfg-cert-rotation)

**出典**: S34, S35, S37, S2

---

### inc-engine-restart-loop: Inspection Engine が restart loop { #inc-engine-restart-loop }

**重要度**: `A` / **用途**: 性能 / 肥大

**目的**: 特定 Inspection Engine が起動 / クラッシュ / 再起動を繰り返す状態の切り分け。

**手順**: Engine の error log（`/var/log/guard/`）を確認、直前の Policy install 履歴を確認、不正な Custom Class を含む Policy なら別 Policy に切替テスト、Parse Tree が作れない DB Protocol 不整合（Cassandra / MongoDB 等で起こりがち）なら Protocol を見直し。

**関連**: [cfg-inspection-engine](08-config-procedures.md#cfg-inspection-engine), [cfg-policy-build](08-config-procedures.md#cfg-policy-build)

**出典**: S40, S84, S76

---

### inc-system-slow: appliance 全体の応答遅延 { #inc-system-slow }

**重要度**: `A` / **用途**: 性能 / 肥大

**目的**: Web UI / `cli` / レポートのすべてが遅い状態の切り分け。

**手順**: `support show high cpu`、`support show high memory`、`/var` 使用率、Inspection Engine 数 / Buffer Free、Audit Process の同時実行数。Mysql プロセスが CPU 上位なら長時間 query → Audit Process / Reports の見直し。

**関連**: [inc-sniffer-overload](#inc-sniffer-overload), [inc-audit-process-stuck](#inc-audit-process-stuck), [inc-disk-full](#inc-disk-full)

**出典**: S69, S73, S77

---

### inc-blocking-misfire: ブロッキング Policy が業務 SQL を切る { #inc-blocking-misfire }

**重要度**: `A` / **用途**: Policy / Audit

**目的**: S-GATE TERMINATE が想定外の業務トラフィックを切断している状態の緊急復旧。

**手順**: Policy Installation tool で当該 Policy を即座に **uninstall**、または該当 Rule の Action を一時的に `Alert Per Match` に降格。Policy Analyzer で衝突解析、Group の包含範囲が広すぎないか確認、優先順位上位の Policy が先に発火していないか確認。段階展開（小範囲 → 全社）を再徹底。

**関連**: [cfg-policy-blocking](08-config-procedures.md#cfg-policy-blocking)

**出典**: S10, S49, S51, S2

---

### inc-audit-process-stuck: Audit Process が完了しない { #inc-audit-process-stuck }

**重要度**: `A` / **用途**: Policy / Audit

**目的**: Audit Process が長時間（数時間〜）完了せず、後続スケジュールがブロックされる状態を解消。

**手順**: `grdapi stop_audit_process processName="<name>"` で停止 → Audit Process Log で根本原因（remote source タイムアウト / CSV 10GB 上限 / Datasource 遅延）を特定 → タスク分割 / `store save_result_fetch_size` 縮小 / Datasource 認証 rotation。Schedule 側でタイムアウト設定追加。

**関連**: [cfg-audit-process](08-config-procedures.md#cfg-audit-process)

**出典**: S17, S89, S2

---

### inc-cold-storage-fail: Long-term retention（S3）転送停止 { #inc-cold-storage-fail }

**重要度**: `A` / **用途**: Aggregator / Archive

**目的**: S3 互換 cold storage への転送が停止し、Daily Archive の long-term 保持が機能していない状態の対応。

**手順**: `grdapi configure_complete_cold_storage` で現状取得、S3 endpoint への curl 疎通確認、IAM / accessKey / secretKey の有効性確認、bucket 容量 / lifecycle policy 確認、network outbound 閉塞確認。

**関連**: [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge)

**出典**: S2, S81, S82

---

### inc-cert-expiry: 証明書期限切れによる接続障害 { #inc-cert-expiry }

**重要度**: `A` / **用途**: アクセス / 証明書

**目的**: appliance / CM / S-TAP / Web Console の証明書期限切れに伴う通信障害（CM ↔ MU 切断 / Web UI ブラウザ警告 / S-TAP RED）の対応。

**手順**: `show certificate exceptions` で期限切れ / 期限切れ間近の証明書を一覧、`grdapi get_certificates` で詳細、緊急時は猶予期間を超える前に [cfg-cert-rotation](08-config-procedures.md#cfg-cert-rotation) で新証明書配布。GIM 12.2 系で SHA1 ↔ SHA256 並行運用期間を活用。

**関連**: [cfg-cert-rotation](08-config-procedures.md#cfg-cert-rotation), [inc-stap-conn-fail](#inc-stap-conn-fail)

**出典**: S37, S83, S2

---

### inc-patch-distribution-fail: CM からの Patch 配布失敗 { #inc-patch-distribution-fail }

**重要度**: `B` / **用途**: 起動 / 接続

**目的**: CM の Patch Distribution Status で当該 MU への配布が `FAILED` / `STUCK`。

**手順**: Distribution Profile の MU 一覧確認 → MU 側 fileserver が時間切れ閉鎖していないか → CM ↔ MU 証明書整合 → MU 側 `support show network connections`。容量不足なら MU 側 `df -h /var` 確認。

**関連**: [cfg-patch-install](08-config-procedures.md#cfg-patch-install), [cfg-cm-managed-unit](08-config-procedures.md#cfg-cm-managed-unit)

**出典**: S31, S78, S43

---

### inc-web-ui-slow: Web Console 8443 の遅延 / hang { #inc-web-ui-slow }

**重要度**: `B` / **用途**: 性能 / 肥大

**目的**: Web UI 操作が極端に遅い、または特定操作で hang する状態を解消。

**手順**: `restart gui` で軽症復旧、`support show high cpu`（java プロセス）、Investigation Dashboard で長時間クエリ確認、複数管理者の同時操作を分散。Tomcat heap 不足の可能性は IBM サポートへ。

**関連**: [inc-system-slow](#inc-system-slow)

**出典**: S77, S64

---

### inc-alert-not-delivered: アラート配信されない { #inc-alert-not-delivered }

**重要度**: `B` / **用途**: Policy / Audit

**目的**: Policy ルールは発火しているが Receivers にメール / SIEM 通知が届かない状態の切り分け。

**手順**: Reports > Threshold Alerter Status で発火履歴確認、Setup > Tools and Views > Global Profile で SMTP / SNMP / Syslog 設定確認、Receivers のメール無効化設定、Distribution Profile（CM 配下なら）配布状況。

**関連**: [cfg-alert-route](08-config-procedures.md#cfg-alert-route), [inc-policy-not-active](#inc-policy-not-active)

**出典**: S22, S23, S2

---

### inc-group-populate-fail: Populate Group が空のまま { #inc-group-populate-fail }

**重要度**: `B` / **用途**: Policy / Audit

**目的**: Policy が参照する populate group が空のままで、Policy が誰にも当たらない状態を解消。

**手順**: Group 詳細で Last Populated 時刻を確認、Datasource Test Connection、populate query の SQL を Datasource 上で手動実行して検証、必要なら manual mode に一時切替。

**関連**: [cfg-group-define](08-config-procedures.md#cfg-group-define), [cfg-datasource-register](08-config-procedures.md#cfg-datasource-register)

**出典**: S21, S52, S58

---

### inc-va-scan-fail: VA scan が常に失敗 { #inc-va-scan-fail }

**重要度**: `C` / **用途**: Policy / Audit

**目的**: Vulnerability Assessment が `FAILED` で結果が見えない状態の切り分け。

**手順**: View Results / Vulnerability management hub でエラー詳細確認、Datasource credentials 期限切れ / 権限不足、対象 DB の SSL 証明書を `store certificate keystore trusted console` で trust、対象 DB バージョンが What's new（S2）の supported list に含まれるか確認、Helm Chart で展開した EKS 上の VA Scanner ならコンテナログ確認。

**関連**: [cfg-va-scan](08-config-procedures.md#cfg-va-scan), [cfg-datasource-register](08-config-procedures.md#cfg-datasource-register)

**出典**: S28, S29, S2

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
