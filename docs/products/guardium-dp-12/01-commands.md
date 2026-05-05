# コマンド一覧

> 掲載：**45 件（grdapi / appliance CLI / S-TAP CLI / GIM）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

IBM Guardium Data Protection 12.x の管理者・SOC・DBA・Compliance 担当が日常的に使う定番コマンドを厳選。本ページでは 6 系統に分類：(A) **GuardAPI（grdapi）**、(B) **Appliance CLI - System / Configuration**、(C) **Appliance CLI - File handling / Support**、(D) **Appliance CLI - Network / User**、(E) **S-TAP / GIM CLI**、(F) **Audit Process / Policy 制御**。

すべての例で `cli`（Guardium CLI ユーザでログイン）または `root`（GIM / S-TAP）を前提。`grdapi` は CLI 経由、または UI の API Test Bench、または REST API で叩ける。

## 目次

- **(A) GuardAPI（grdapi、12 件）**: [`grdapi list_policy`](#grdapi-list-policy), [`grdapi install_policy`](#grdapi-install-policy), [`grdapi create_datasource`](#grdapi-create-datasource), [`grdapi modify_datasource`](#grdapi-modify-datasource), [`grdapi list_groups`](#grdapi-list-groups), [`grdapi update_engine_config`](#grdapi-update-engine-config), [`grdapi list_ata_case_severity`](#grdapi-list-ata-case-severity), [`grdapi update_ata_case_status`](#grdapi-update-ata-case-status), [`grdapi get_certificates`](#grdapi-get-certificates), [`grdapi configure_complete_cold_storage`](#grdapi-configure-cold-storage), [`grdapi MODIFY_GUARD_PARAM`](#grdapi-modify-guard-param), [`grdapi stop_audit_process`](#grdapi-stop-audit-process)
- **(B) Appliance CLI System / Config（10 件）**: [`store auto_stop_services_when_full`](#store-auto-stop), [`show system info`](#show-system-info), [`show installed_modules`](#show-installed-modules), [`store max_results_set_size`](#store-max-results-set-size), [`store max_result_set_packet_size`](#store-max-result-set-packet-size), [`store max_tds_response_packets`](#store-max-tds-response-packets), [`store save_result_fetch_size`](#store-save-result-fetch-size), [`restart system`](#restart-system), [`restart gui`](#restart-gui), [`config jobs schedule`](#config-jobs-schedule)
- **(C) File handling / Support（8 件）**: [`fileserver`](#fileserver), [`store certificate keystore trusted console`](#store-cert-trusted), [`show certificate stored`](#show-certificate-stored), [`show certificate exceptions`](#show-certificate-exceptions), [`support`](#support), [`support show high cpu`](#support-show-high-cpu), [`support must_gather`](#support-must-gather), [`backup system`](#backup-system)
- **(D) Network / User（5 件）**: [`store network interface`](#store-network-interface), [`store network resolver`](#store-network-resolver), [`change_cli_password`](#change-cli-password), [`store user`](#store-user), [`show user`](#show-user)
- **(E) S-TAP / GIM CLI（6 件）**: [`consolidated_installer.sh`](#consolidated-installer), [`guard_tap.sh`](#guard-tap-sh), [`gim cli`](#gim-cli), [`ps -ef | grep -i gim/tap`](#ps-stap-check), [`tap_diag`](#tap-diag), [`uninstall_gim`](#uninstall-gim)
- **(F) Audit Process / Policy（4 件）**: [`grdapi run_audit_process`](#grdapi-run-audit-process), [Policy Installation tool（UI）](#policy-installation-tool), [Smart assistant（UI）](#smart-assistant), [Compliance Workflow（UI）](#compliance-workflow)

---

## (A) GuardAPI（grdapi）

### `grdapi list_policy` { #grdapi-list-policy }
**用途**: 配備済み Policy の一覧。ID / 名前 / type（Access / Extrusion / Selective Audit / Session-level）/ install state を出力。

**構文**:

```
grdapi list_policy [parentRuleId=<id>]
```

**典型例**:

```
cli> grdapi list_policy
ID 12  PCI Audit Policy           ACCESS    INSTALLED
ID 17  Privileged User Watch      ACCESS    NOT INSTALLED
```

**注意点**: 「INSTALLED」は Policy Installation tool で配布済を意味する。Policy 単独保存だけでは Sniffer / Collector に反映されない。

**関連手順**: [cfg-policy-build](08-config-procedures.md#cfg-policy-build), [inc-policy-not-active](09-incident-procedures.md#inc-policy-not-active)

**関連用語**: [Policy](03-glossary.md#policy), [Policy Installation](03-glossary.md#policy-installation)

**出典**: S9, S11, S12, S72

---

### `grdapi install_policy` { #grdapi-install-policy }
**用途**: 指定 Policy を Inspection Engine に配備する。複数 Policy を順序付きでセットして 1 回でインストール可能。

**構文**:

```
grdapi install_policy policy="<name>" [overwriteCurrentPolicy=true|false]
```

**典型例**:

```
cli> grdapi install_policy policy="PCI Audit Policy"
SUCCESS: Policy installed (size=82 rules, install_id=204)
```

**注意点**: install 後に Inspection Engine の再起動は **不要**（内部に動的ロード）。ただし Policy 内で参照している Group / Datasource が未存在だと部分失敗する。

**関連手順**: [cfg-policy-build](08-config-procedures.md#cfg-policy-build), [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy)

**関連用語**: [Policy](03-glossary.md#policy), [Inspection Engine](03-glossary.md#inspection-engine)

**出典**: S12, S50, S72

---

### `grdapi create_datasource` { #grdapi-create-datasource }
**用途**: Datasource（VA や Audit Process が参照する DB 接続定義）を新規作成。

**構文**:

```
grdapi create_datasource name="<name>" host="<host>" port=<n> dbType="<Oracle|DB2|MSSQL|MySQL|PostgreSQL|...>" \
                         user="<user>" password="<pwd>" [serviceName="..."] [databaseInstanceName="..."]
```

**典型例**:

```
cli> grdapi create_datasource name="prod_oracle_01" host="db01.gdemo.com" port=1521 \
       dbType="Oracle" user="guardium_audit" password="****" serviceName="ORCLPDB1"
SUCCESS: datasource id=42
```

**注意点**: VA を回す場合は VA Database Privileges に従い権限を最小限で付与（grant 例は [13. uc-va-run](12-use-cases.md#uc-va-run) 参照）。パスワードは grdapi 引数に直書きせず、--input ファイル経由が推奨。

**関連手順**: [cfg-datasource-register](08-config-procedures.md#cfg-datasource-register)

**関連用語**: [Datasource](03-glossary.md#datasource), [VA](03-glossary.md#va)

**出典**: S29, S36, S72

---

### `grdapi modify_datasource` { #grdapi-modify-datasource }
**用途**: 既存 Datasource のホスト / ポート / 認証 / DB Type を変更。Audit Process 内で多数の Datasource を一括書き換える運用で多用。

**構文**:

```
grdapi modify_datasource id=<n> [host="..."] [port=<n>] [user="..."] [password="..."]
```

**注意点**: 同一 Datasource を参照している Audit Process / VA / Classification がある場合、変更後の動作確認は必須。

**関連手順**: [cfg-datasource-register](08-config-procedures.md#cfg-datasource-register)

**出典**: S36, S72

---

### `grdapi list_groups` { #grdapi-list-groups }
**用途**: Policy / Audit Process で利用する Group（IP / User / Object / Command 等のセット）の一覧。

**構文**:

```
grdapi list_groups [groupType="OBJECTS|COMMANDS|USERS|CLIENT_IPS|SERVER_IPS|..."]
```

**典型例**:

```
cli> grdapi list_groups groupType="USERS"
ID 18  Privileged DB Users      19 members
ID 22  PCI Cardholder Tables   142 members
```

**注意点**: Group は populate（自動追加）と manual（手動追加）の 2 種。populate group はクエリベースで定期更新される。Group ID を Policy で参照しているため、ID 変更は破壊的。

**関連手順**: [cfg-group-define](08-config-procedures.md#cfg-group-define)

**関連用語**: [Group](03-glossary.md#group)

**出典**: S21, S58, S72

---

### `grdapi update_engine_config` { #grdapi-update-engine-config }
**用途**: Inspection Engine のプロパティを CLI から更新（UI から Manage > Activity Monitoring > Inspection Engines と等価）。

**構文**:

```
grdapi update_engine_config engineName="<name>" [protocol="..."] [dbServerIpMask="..."] [port=<n>] [activeOnStartup=true]
```

**注意点**: 順序・除外条件は更新後に **即時反映**（Engine 再起動不要）。global 設定変更の場合は Restart Inspection Engines 必須。

**関連手順**: [cfg-inspection-engine](08-config-procedures.md#cfg-inspection-engine)

**関連用語**: [Inspection Engine](03-glossary.md#inspection-engine)

**出典**: S84, S72

---

### `grdapi list_ata_case_severity` { #grdapi-list-ata-case-severity }
**用途**: Active Threat Analytics（ATA）case の severity 一覧 / カウント。重大度別の脅威分布を CLI で取得。

**構文**:

```
grdapi list_ata_case_severity
```

**典型例**:

```
cli> grdapi list_ata_case_severity
SEVERITY     COUNT
HIGH           18
MEDIUM         62
LOW           135
INFO          412
```

**注意点**: 12.2.1 で追加。case の閉じ込みは `update_ata_case_status` を使う。

**関連用語**: [ATA](03-glossary.md#ata), [Outliers Mining](03-glossary.md#outliers-mining)

**出典**: S48, S2, S72

---

### `grdapi update_ata_case_status` { #grdapi-update-ata-case-status }
**用途**: ATA case の status 一括更新（CLOSED / OPEN / EXCLUDED）。

**構文**:

```
grdapi update_ata_case_status caseId=<n> status="CLOSED|OPEN|EXCLUDED" [comment="..."]
```

**注意点**: 12.2 で case 一括クローズ・除外リスト対応。CSV ベースの bulk update は UI 経由が推奨。

**出典**: S48, S2, S72

---

### `grdapi get_certificates` { #grdapi-get-certificates }
**用途**: Guardium 内部証明書の一覧取得（Cryptography Manager 経由）。12.2.1 で追加。

**構文**:

```
grdapi get_certificates [type="trusted|appliance|web|grouper"]
```

**注意点**: 期限切れの early warning に使用。expired ステータスの証明書は要 rotation。`store certificate keystore trusted console` で trusted CA import。

**関連手順**: [cfg-cert-rotation](08-config-procedures.md#cfg-cert-rotation)

**関連用語**: [GCM](03-glossary.md#gcm)

**出典**: S2, S37, S83, S72

---

### `grdapi configure_complete_cold_storage` { #grdapi-configure-cold-storage }
**用途**: Long-term retention（S3 互換オブジェクトストレージ）の cold storage 完全構成。Guardium 12.2 で追加された統合 API。

**構文**:

```
grdapi configure_complete_cold_storage endpoint="..." accessKey="..." secretKey="..." \
                                       bucket="..." [retention=<days>]
```

**注意点**: 暗号化 + 署名の archive を S3 互換へ転送。Aggregator → Long-term retention の経路を CLI 一発で構成可能。

**関連手順**: [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge)

**関連用語**: [Long-term retention](03-glossary.md#long-term-retention)

**出典**: S2, S81, S72

---

### `grdapi MODIFY_GUARD_PARAM` { #grdapi-modify-guard-param }
**用途**: 内部パラメータ（GUARD_PARAM）の get / set。設定 UI に出ない隠しパラメータを変更する管理者向け API。

**構文**:

```
grdapi MODIFY_GUARD_PARAM paramName="<NAME>" paramValue="<value>"
```

**典型例**: 12.2.2 で Access Manager 旧 UI に戻す。

```
grdapi MODIFY_GUARD_PARAM paramName=LEGACY_ACCESSMGR_ENABLED paramValue=1
```

**注意点**: 公開された param のみ変更を推奨。未公開 param の触りは IBM サポート確認推奨。

**出典**: S2, S72

---

### `grdapi stop_audit_process` { #grdapi-stop-audit-process }
**用途**: 実行中の Audit Process を停止。長時間実行が暴走したときの緊急停止。

**構文**:

```
grdapi stop_audit_process processName="<name>"
```

**注意点**: 部分結果は破棄される場合があるため、定常運用では Schedule 側でタイムアウト設定を入れるのが推奨。

**関連手順**: [inc-audit-process-stuck](09-incident-procedures.md#inc-audit-process-stuck)

**関連用語**: [Audit Process](03-glossary.md#audit-process)

**出典**: S17, S89, S72

---

## (B) Appliance CLI - System / Configuration

<a id="cmd-store-auto-stop"></a>
### `store auto_stop_services_when_full` { #store-auto-stop }
**用途**: 内部 DB / `/var` パーティションが 90% 超過時に nanny プロセスがサービス停止する保護機構の有効/無効切替。

**構文**:

```
cli> store auto_stop_services_when_full <on|off>
cli> show auto_stop_services_when_full
```

**注意点**: 既定 `on`、production では基本 ON のまま。`off` は緊急時の一時的措置のみ（無効化中にディスク満杯まで進むと内部 DB 破損リスク）。

**関連手順**: [inc-disk-full](09-incident-procedures.md#inc-disk-full)

**出典**: S79

---

### `show system info` { #show-system-info }
**用途**: appliance のバージョン、ホスト、ライセンス、Managed Unit 関係、ディスク使用率を一括表示。

**構文**:

```
cli> show system info
```

**注意点**: must_gather 提出時の最低限の付帯情報。CM の場合は配下 MU 一覧も含む。

**出典**: S64, S65, S66

---

### `show installed_modules` { #show-installed-modules }
**用途**: 配備されているモジュール（GPU、TurboParser、ATA、Outliers 等）の有効化状態確認。

**構文**:

```
cli> show installed_modules
```

**出典**: S30, S64

---

### `store max_results_set_size` { #store-max-results-set-size }
**用途**: SQL `SELECT` で返却される行数の最大値。Inspection Engine の `Log Records Affected` を有効にしている際のログ量制御。

**構文**:

```
cli> store max_results_set_size <bytes>
```

**注意点**: 大きすぎると buffer 消費が激増、Inspection Engine の sniffer overload リスク。

**関連手順**: [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload)

**出典**: S84, S76

---

### `store max_result_set_packet_size` { #store-max-result-set-packet-size }
**用途**: パケット単位の最大サイズ。`max_results_set_size` と組み合わせて記録粒度を制御。

**構文**:

```
cli> store max_result_set_packet_size <bytes>
```

**出典**: S84, S76

---

### `store max_tds_response_packets` { #store-max-tds-response-packets }
**用途**: TDS（MS SQL / Sybase）応答パケットの最大数。SQL Server 監視時の records affected 制御。

**出典**: S84, S76

---

### `store save_result_fetch_size` { #store-save-result-fetch-size }
**用途**: Audit Process の remote source 結果の最大件数（既定 100,000）。CSV 出力上限を変更したい時に使用。

**構文**:

```
cli> store save_result_fetch_size <n>
```

**注意点**: CSV 出力は 10GB 上限のため、サイズ大の Audit Process は Zip CSV for email を併用するのが推奨。

**関連手順**: [cfg-audit-process](08-config-procedures.md#cfg-audit-process)

**出典**: S17, S89

---

### `restart system` { #restart-system }
**用途**: appliance を再起動。GUI と内部 DB を含めた完全再起動。

**注意点**: 再起動中は S-TAP からの監査データが滞留（ILB / Failover Collector 設定があれば failover）。Aggregator の Daily Import スケジュールが再起動と被らないように管理。

**出典**: S64

---

### `restart gui` { #restart-gui }
**用途**: HTTPS 8443 の Web Console（Tomcat）のみを再起動。設定変更や軽微なハングの初期対応で使用。

**出典**: S64, S77

---

### `config jobs schedule` { #config-jobs-schedule }
**用途**: 内部 cron 系（Daily Archive、Daily Import、Patch Backup 等）のスケジュール表示・変更。

**構文**:

```
cli> config jobs schedule list
cli> config jobs schedule set <jobName> "<cron-expr>"
```

**関連手順**: [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge)

**出典**: S42, S64, S81

---

## (C) File handling / Support

### `fileserver` { #fileserver }
**用途**: appliance に対して一時的に HTTPS ファイル受信エンドポイントを開いて、パッチ / Custom Class / 証明書 / インポート用ファイル等を投入する手段。

**構文**:

```
cli> fileserver <duration_minutes> <client-ip-or-network/mask>
=> 出力された URL に対して https で put / get 操作
cli> fileserver stop
```

**典型例**:

```
cli> fileserver 30 10.0.0.0/24
URL: https://<appliance>:8445/  (open for 30 min)
```

**注意点**: 開いている時間を最小限に。stop 忘れに注意（auto-stop はあるが、明示的 stop 推奨）。CM 配下の Managed Unit にも個別に開く必要。

**関連手順**: [cfg-patch-install](08-config-procedures.md#cfg-patch-install), [cfg-cert-rotation](08-config-procedures.md#cfg-cert-rotation)

**出典**: S31, S37, S68

---

### `store certificate keystore trusted console` { #store-cert-trusted }
**用途**: trusted CA 証明書（社内 CA や proxy CA）を appliance keystore に追加。

**構文**:

```
cli> store certificate keystore trusted console
=> プロンプトで証明書 PEM を貼り付け
```

**注意点**: Audit Process / VA で外部 DB に SSL 接続する際、社内 CA をここに登録しておく必要あり。

**関連手順**: [cfg-cert-rotation](08-config-procedures.md#cfg-cert-rotation)

**出典**: S37, S83

---

### `show certificate stored` { #show-certificate-stored }
**用途**: appliance の keystore に存在する証明書一覧を表示（label / expiry / type）。

**出典**: S37, S83

---

### `show certificate exceptions` { #show-certificate-exceptions }
**用途**: 期限切れ・期限切れ間近・チェーン不整合などの証明書例外を表示。早期警報。

**出典**: S37, S83, S2

---

### `support` { #support }
**用途**: support サブコマンドのエントリ。日常診断（show high cpu / show high memory / show network connections / show buffer pool）を集約。

**構文**:

```
cli> support show high cpu
cli> support show high memory
cli> support show network connections
cli> support show buffer pool
```

**関連手順**: [inc-objserv-equiv-perf](09-incident-procedures.md#inc-system-slow), [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload)

**出典**: S69, S73, S74

---

### `support show high cpu` { #support-show-high-cpu }
**用途**: 直近 CPU を食っているプロセス上位を表示。性能調査の初手。

**注意点**: sniffer / mysql / java（Web Console）が上位に来るのは正常。極端な張り付きは inc-sniffer-overload 仮説 A を疑う。

**関連手順**: [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload)

**出典**: S69, S73, S76

---

### `support must_gather` { #support-must-gather }
**用途**: IBM サポートに提出する付属情報を一括収集（system info / logs / config / Inspection Engine 状態）。tar.gz で `/var/log/guard/` 配下に出力、`fileserver` で取り出す。

**構文**:

```
cli> support must_gather full
```

**注意点**: 容量が GB 級になりうる。`fileserver` での pickup タイムアウトに注意。機密データ（実際の SQL 本文）が含まれるためハンドリング注意。

**関連手順**: [inc-stap-conn-fail](09-incident-procedures.md#inc-stap-conn-fail), [inc-policy-not-active](09-incident-procedures.md#inc-policy-not-active)

**出典**: S69, S73

---

### `backup system` { #backup-system }
**用途**: appliance 全体（system + data）のバックアップ。Daily Archive とは別経路で、appliance 設定そのものを退避。

**構文**:

```
cli> backup system <protocol> <host> <path> <user> <password>
```

**注意点**: Daily Archive（監査データ）は **これとは別** に Comply > Tools and Views > Data Archive で構成。両方が要件。

**関連手順**: [cfg-archive-purge](08-config-procedures.md#cfg-archive-purge)

**出典**: S33, S81

---

## (D) Network / User

### `store network interface` { #store-network-interface }
**用途**: appliance の NIC / IP / mask / gateway 設定。

**注意点**: 変更は再起動必須。CM ↔ MU 間の経路変更は CM 側証明書再配布が必要なケースあり。

**出典**: S70

---

### `store network resolver` { #store-network-resolver }
**用途**: DNS resolver の登録。

**出典**: S70

---

### `change_cli_password` { #change-cli-password }
**用途**: CLI ユーザ（cli）のパスワード変更。

**注意点**: GuardAPI の grdapi コマンドは CLI ユーザのコンテキストで動く。パスワード変更後は自動化スクリプト側の credential 更新を忘れない。

**出典**: S71, S72

---

### `store user` { #store-user }
**用途**: appliance OS レベルのユーザ管理（SSH / CLI ログイン）。

**出典**: S71

---

### `show user` { #show-user }
**用途**: 現在の OS ユーザ一覧表示。

**出典**: S71

---

## (E) S-TAP / GIM CLI

### `consolidated_installer.sh` { #consolidated-installer }
**用途**: DB サーバ側で S-TAP + GIM client をワンショットでインストール。OS / アーキ別の `.gim.sh` と組合せ。

**構文**:

```
./consolidated_installer.sh \
    --installdir <path> \
    --tapip <DB host> \
    --gim_sqlguardip <CM/Collector> \
    --stap_sqlguardip <Collector> \
    [--failover_sqlguardip <Backup Collector>] \
    [--ktap_allow_module_combos] \
    [--use_discovery 1] \
    [--perl /usr/bin/]
```

**典型例**:

```
# Linux RHEL 8 の Db2 サーバへ S-TAP 投入
./consolidated_installer.sh --installdir /usr/local/guardium \
    --tapip db01.gdemo.com --gim_sqlguardip cm.gdemo.com \
    --stap_sqlguardip col01.gdemo.com --failover_sqlguardip col02.gdemo.com \
    --ktap_allow_module_combos --use_discovery 1 --perl /usr/bin/
```

**注意点**: root 必須。`--ktap_allow_module_combos` はカーネル互換問題の回避フラグ。導入後 `ps -ef | grep -i gim/tap` で `guard_gimd` と `guard_stap` の両方が走っているか確認。

**関連手順**: [cfg-stap-deploy](08-config-procedures.md#cfg-stap-deploy)

**関連用語**: [S-TAP](03-glossary.md#s-tap), [GIM](03-glossary.md#gim), [K-TAP](03-glossary.md#k-tap)

**出典**: S35, S34

---

### `guard_tap.sh` { #guard-tap-sh }
**用途**: S-TAP プロセスの起動・停止・状態確認。systemd / SRC（AIX）配下で動かすのが定番。

**構文**:

```
/usr/local/guardium/guard_stap/guard_tap.sh start|stop|status|restart
```

**注意点**: production では起動失敗時のリトライ・通知のラッパが推奨。`status` は `guard_stap` プロセスの存在を見るだけで、Collector との接続性までは見ない（接続性は CM UI または log で確認）。

**関連手順**: [inc-stap-conn-fail](09-incident-procedures.md#inc-stap-conn-fail)

**関連用語**: [S-TAP](03-glossary.md#s-tap), [guard_tap.ini](03-glossary.md#guard-tap-ini)

**出典**: S35

---

### `gim cli` { #gim-cli }
**用途**: GIM 経由で S-TAP / CAS のモジュール管理を CM 側からリモート実行する CLI。バージョンアップグレード / 設定一括配布で使用。

**構文**:

```
cli> gim modify <module>=<version> CLIENT_NAME=<host>
cli> gim apply
```

**注意点**: GIM 12.2 系で SHA1 / SHA256 証明書サポート。証明書 expired の GIM client は反応しない。

**関連用語**: [GIM](03-glossary.md#gim)

**出典**: S34, S35, S2

---

### `ps -ef | grep -i gim/tap` { #ps-stap-check }
**用途**: DB サーバ側で S-TAP / GIM プロセスの稼働確認の定番。

**構文**:

```
ps -ef | grep -i gim
ps -ef | grep -i tap
```

**典型出力**:

```
root  10234     1  0 03:00 ?  00:00:01 /usr/local/guardium/modules/GIM/12.2.1/perl/bin/perl ./gim_client.pl ...
root  10310 10234  0 03:00 ?  00:00:00 /usr/local/guardium/modules/STAP/12.2.1/guard_stap
root  10311 10310  0 03:00 ?  00:00:00 /usr/local/guardium/modules/STAP/12.2.1/guard_discovery
```

**注意点**: `guard_gimd` が居て `guard_stap` が居ない場合は S-TAP プロセス障害（[inc-stap-down](09-incident-procedures.md#inc-stap-down) 参照）。

**出典**: S35, S73

---

### `tap_diag` { #tap-diag }
**用途**: S-TAP の自己診断（OS / カーネル / 設定 / Collector への疎通）。

**構文**:

```
/usr/local/guardium/guard_stap/tap_diag
```

**関連手順**: [inc-stap-conn-fail](09-incident-procedures.md#inc-stap-conn-fail)

**出典**: S35, S73

---

### `uninstall_gim` { #uninstall-gim }
**用途**: GIM / S-TAP の完全アンインストール。古い 11.x からの環境クリーンアップ等で使用。

**構文**:

```
/usr/local/guardium/modules/GIM/<ver>/uninstall_gim.sh
```

**注意点**: K-TAP モジュールはカーネルに残ることがあり、別途 `rmmod` または再起動が必要。

**出典**: S35

---

## (F) Audit Process / Policy 制御

### `grdapi run_audit_process` { #grdapi-run-audit-process }
**用途**: Audit Process を CLI から手動起動（Run once now と等価）。Schedule に依存しない手動実行。

**構文**:

```
grdapi run_audit_process processName="<name>"
```

**注意点**: 暴走時は `grdapi stop_audit_process` で停止。

**関連手順**: [cfg-audit-process](08-config-procedures.md#cfg-audit-process)

**関連用語**: [Audit Process](03-glossary.md#audit-process)

**出典**: S17, S89, S72

---

### Policy Installation tool（UI） { #policy-installation-tool }
**用途**: Setup > Tools and Views > Policy Installation tool で Policy を配備する UI。Policy 保存だけでは反映されないため、本ツールでの install が必須。

**注意点**: 複数 Policy を install 順に並べる時、上位 Policy で blocking 動作（TERMINATE 等）が走ると下位は評価されない。順序設計が重要。

**関連手順**: [cfg-policy-build](08-config-procedures.md#cfg-policy-build)

**関連用語**: [Policy Installation](03-glossary.md#policy-installation)

**出典**: S12, S50

---

### Smart assistant（UI） { #smart-assistant }
**用途**: Comply > Tools and Views > Smart assistant for compliance monitoring。PCI / SOX / HIPAA / DORA / NYDFS のテンプレートから Policy + Group + Audit Process + Alert + VA を一括生成。

**注意点**: 生成された Policy は雛形であり、本番配備前に環境に合わせ調整必須（IP マスク、対象 DB 種別、特権ユーザリスト）。

**関連手順**: [cfg-compliance-template](08-config-procedures.md#cfg-compliance-template)

**関連用語**: [Compliance Workflow](03-glossary.md#compliance-workflow), [Smart assistant](03-glossary.md#smart-assistant)

**出典**: S61, S62, S63, S88

---

### Compliance Workflow（UI） { #compliance-workflow }
**用途**: Comply > Tools and Views > Compliance Workflow Automation。複数 Audit Process を 1 つの workflow にまとめてレビュー・署名・配信を自動化。

**注意点**: distribution profile を CM 経由で複数 MU に配信できる。署名（Sign-off）は職務分掌（SoD）要件の中核。

**関連手順**: [cfg-audit-process](08-config-procedures.md#cfg-audit-process)

**関連用語**: [Audit Process](03-glossary.md#audit-process), [Receivers](03-glossary.md#receivers)

**出典**: S17, S18, S62, S89

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
