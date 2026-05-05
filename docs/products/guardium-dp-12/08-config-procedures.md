# 設定手順

> 掲載：**18 件（S/A/B/C × 用途、S 級は期待出力サンプル付き）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

## 重要度 × 用途 マトリクス

<div class="md-typeset__scrollwrap" markdown="1">

| 重要度＼用途 | アプライアンス | S-TAP / DB 監視 | Policy / Audit | Aggregator / Archive | アクセス / 証明書 | 連携 |
|---|---|---|---|---|---|---|
| **S** | [cfg-appliance-deploy](#cfg-appliance-deploy)<br>[cfg-cm-managed-unit](#cfg-cm-managed-unit) | [cfg-stap-deploy](#cfg-stap-deploy)<br>[cfg-inspection-engine](#cfg-inspection-engine) | [cfg-policy-build](#cfg-policy-build)<br>[cfg-audit-process](#cfg-audit-process) | [cfg-archive-purge](#cfg-archive-purge) | [cfg-rbac-design](#cfg-rbac-design) | — |
| **A** | [cfg-patch-install](#cfg-patch-install)<br>[cfg-upgrade](#cfg-upgrade) | [cfg-stap-failover](#cfg-stap-failover)<br>[cfg-stap-zos](#cfg-stap-zos) | [cfg-policy-blocking](#cfg-policy-blocking)<br>[cfg-policy-session](#cfg-policy-session)<br>[cfg-compliance-template](#cfg-compliance-template) | — | [cfg-cert-rotation](#cfg-cert-rotation) | [cfg-cloud-monitoring](#cfg-cloud-monitoring) |
| **B** | — | [cfg-extrusion-policy](#cfg-extrusion-policy) | [cfg-group-define](#cfg-group-define)<br>[cfg-alert-route](#cfg-alert-route) | — | — | — |
| **C** | — | [cfg-replay](#cfg-replay) | [cfg-va-scan](#cfg-va-scan)<br>[cfg-discovery-classify](#cfg-discovery-classify)<br>[cfg-ata-tune](#cfg-ata-tune) | — | — | — |

</div>

---

## 詳細手順

### cfg-appliance-deploy: Collector / Aggregator / CM の新規デプロイ { #cfg-appliance-deploy }

**重要度**: `S` / **用途**: アプライアンス

**目的**: 物理 / 仮想アプライアンスとして Collector（または Aggregator / CM）を新規デプロイし、初期構成・ライセンス投入・Web Console 8443 起動までを完了させる。

**前提**: IBM 提供 ISO / OVA を Passport Advantage / Fix Central から取得済、ホスト名 / IP / DNS / NTP の設計済、ライセンスキーあり。

**手順**:

1. **インストール**：物理は ISO ブート、仮想は OVA / qcow2 を vSphere / KVM へ展開。Storage は `/var` を最大化（既定パーティション設計に従う）。
2. **初期コンソール（Console / SSH）**：CLI ユーザでログイン、`store network interface` で IP / mask / gateway / NIC、`store network resolver` で DNS、`store system hostname` でホスト名。
3. **時刻同期**：`store system clock timezone` / `store system clock ntp` で NTP 同期（Aggregator / Collector 間の時刻同期は厳密に必要）。
4. **ライセンス投入**：`fileserver` で license file を授受 → UI から Setup > Tools and Views > License > Apply。
5. **タイプ設定**：Setup > Tools and Views > Configuration > Unit Utilization で Collector / Aggregator / CM を切替（既定は Collector）。
6. **Web UI 起動確認**：HTTPS 8443 で admin ログイン → System view ダッシュボードに緑表示。

**期待出力（実機サンプル）**:

`show system info` 抜粋:

```
Hostname           : col01.gdemo.com
IP Address         : 10.0.0.21
Software Version   : 12.2.1
Build              : 119073
Unit Type          : Standalone Collector
License            : Valid until 2027-12-31
Patches Installed  : 12.2.0_p1, 12.2.1_p2
Disk Used (/var)   : 14%
```

**検証**: Web UI で「System view」タブを開き Collector / Aggregator / CM の status が緑であること。`support show high cpu` で sniffer / mysql / java が起動中であること。

**ロールバック**: 初期構成は ISO 再投入で初期化可能。`fileserver` で受けた license / patch ファイルは保管。

**関連**: [cfg-cm-managed-unit](#cfg-cm-managed-unit), [cfg-patch-install](#cfg-patch-install)

**出典**: S30, S31, S32, S64

---

### cfg-cm-managed-unit: Central Manager 配下に Managed Unit を登録 { #cfg-cm-managed-unit }

**重要度**: `S` / **用途**: アプライアンス

**目的**: Standalone Collector / Aggregator を Central Manager 配下の Managed Unit として登録し、CM から patch / 証明書 / Policy / Audit Process を一括配布できる状態にする。

**前提**: CM 本体が起動済、Collector / Aggregator が個別に稼働、CM ↔ MU 間で TCP 8444 / 8445 が開いている、CM 側の証明書を MU に trust 登録済。

**手順**:

1. **CM 側で MU 登録**：CM の Setup > Tools and Views > Central Management > Add Unit に Collector の IP / 8443 認証を入力。
2. **Collector 側 Unit Utilization**：Collector 側で Setup > Configuration > Unit Utilization を「CM-managed」に切替。
3. **証明書 trust 配布**：CM 側で `store certificate keystore appliance console` から CM 証明書を export → MU 側で `store certificate keystore trusted console` に import。
4. **Distribution Profile 作成**：CM 側で Comply > Distribution Profile を作成し、配下の Collector グループに対応する Audit Process / Policy をまとめる。
5. **配布テスト**：CM 側で適当な Audit Process を Distribution Profile に Add し、配下 MU で受け取れるか確認。

**期待出力**:

CM 側 `show installed_modules` 配下に MU 一覧が表示。

```
cli> show managed_units
HOSTNAME              TYPE        STATUS  PATCH_LEVEL
col01.gdemo.com       Collector   green   12.2.1
col02.gdemo.com       Collector   green   12.2.1
agg01.gdemo.com       Aggregator  green   12.2.1
```

**検証**: CM の System View 配下で MU が緑表示。Distribution Profile からの配布で MU 側の Audit Process / Policy が更新されること。

**関連**: [cfg-cert-rotation](#cfg-cert-rotation), [cfg-compliance-template](#cfg-compliance-template)

**出典**: S43, S90, S37

---

### cfg-stap-deploy: S-TAP の新規配備（Linux x86_64 / Db2） { #cfg-stap-deploy }

**重要度**: `S` / **用途**: S-TAP / DB 監視

**目的**: 新規 DB サーバへ GIM client + S-TAP を導入し、DB トラフィックを Collector へ送信できる状態にする。

**前提**: Collector が稼働中、DB サーバ → Collector 16016/16017 開放、DB サーバが root（または sudo）で操作可、対応 OS / カーネル整合確認済。

**手順**:

1. **配布物入手**：Passport Advantage / Fix Central から `Guardium_12.x.x_GIM_<OS>_<build>.zip` と `Guardium_12.x.x_S-TAP_<OS>_<build>.zip` をダウンロード → DB サーバに配置。
2. **解凍**：

    ```
    unzip Guardium_12.1.1.2_GIM_RedHat_r119073.zip
    unzip Guardium_12.1.1.2_S-TAP_RedHat_r119073.zip
    ```

3. **consolidated_installer 配置**：unzip された `consolidated_installer/` ディレクトリに `consolidated_installer.sh` と OS 用 `.gim.sh` がそろうことを確認。
4. **インストール実行**：

    ```
    ./consolidated_installer.sh \
        --installdir /usr/local/guardium \
        --tapip db01.gdemo.com \
        --gim_sqlguardip cm.gdemo.com \
        --stap_sqlguardip col01.gdemo.com \
        --failover_sqlguardip col02.gdemo.com \
        --ktap_allow_module_combos \
        --use_discovery 1 \
        --perl /usr/bin/
    ```

5. **プロセス確認**：

    ```
    ps -ef | grep -i gim
    ps -ef | grep -i tap
    ```

   `guard_gimd`、`guard_stap`、`guard_discovery` が起動していること。

6. **CM 側で確認**：CM の Manage > Module Installation で当該ホストが GREEN 表示。
7. **Inspection Engine 作成**：[cfg-inspection-engine](#cfg-inspection-engine) へ。

**期待出力（実機サンプル）**:

`consolidated_installer.sh` 末尾:

```
Module installation complete.
GIM Client connected to cm.gdemo.com.
S-TAP started successfully (PID 10310).
Discovery process started (PID 10311).
=== Installation Summary ===
GIM Client      : OK
S-TAP           : OK (Primary: col01.gdemo.com, Failover: col02.gdemo.com)
Discovery       : OK
```

`ps -ef | grep -i tap`:

```
root  10310     1  0 03:00 ?  00:00:00 /usr/local/guardium/modules/STAP/12.1.1.2/guard_stap
root  10311 10310  0 03:00 ?  00:00:00 /usr/local/guardium/modules/STAP/12.1.1.2/guard_discovery
```

**検証**: CM UI で当該 DB サーバの S-TAP が GREEN、Inspection Engine 作成後に Activity Monitor で SQL ログが見えること。`tap_diag` で Collector への接続性確認。

**ロールバック**: `/usr/local/guardium/modules/GIM/<ver>/uninstall_gim.sh` で完全アンインストール。K-TAP モジュールは `rmmod` または再起動で完全除去。

**関連**: [cfg-inspection-engine](#cfg-inspection-engine), [cfg-stap-failover](#cfg-stap-failover), [inc-stap-conn-fail](09-incident-procedures.md#inc-stap-conn-fail)

**出典**: S34, S35, S30, S2

---

### cfg-inspection-engine: Inspection Engine の新規作成と起動 { #cfg-inspection-engine }

**重要度**: `S` / **用途**: S-TAP / DB 監視

**目的**: S-TAP からの DB トラフィックを受ける Inspection Engine を Collector 上に作成し、Activity Monitor で SQL が見える状態にする。

**前提**: S-TAP 配備済（[cfg-stap-deploy](#cfg-stap-deploy)）、Collector の Web Console にログイン可、対象 DB の Protocol / Port が判明。

**手順**:

1. **UI 経路**：Manage > Activity Monitoring > Inspection Engines > Add Inspection Engine（Collector 上で実施。**CM 上では作成不可**）。
2. **必須プロパティ**：
    - **Name**: `db01_db2_eng01`（appliance 内ユニーク）
    - **Protocol**: `DB2`
    - **DB Server IP/Mask**: `10.0.0.51 / 32`
    - **Port**: `50000`
    - **DB Client IP/Mask**: `0.0.0.0 / 0`（全て）+ Exclude DB Client IP に Zabbix / バックアップサーバを追加
    - **Active on startup**: チェック
3. **オプションプロパティ**：
    - **Inspect Returned Data**: Extrusion Policy 使う場合のみ ON
    - **Log Records Affected**: 性能注意（[inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) 参照）
    - **Logging Granularity**: 任意（Real-time alert は影響なし）
    - **Ignored Ports List**: 監視対象外ポート（性能改善）
4. **Save & Start**：保存後に Engine 起動。global 設定変更がない場合は **Restart Inspection Engines 不要**。
5. **動作確認**：Investigate > Data > Activity Monitor で対象 DB の SQL が流れていること、Buffer Free 80% 以上であること。

**期待出力**:

`grdapi update_engine_config` 経由の応答:

```
cli> grdapi update_engine_config engineName="db01_db2_eng01" protocol="DB2" \
       dbServerIpMask="10.0.0.51/32" port=50000 activeOnStartup=true
SUCCESS: engine created. id=89
```

UI の Inspection Engines タブ:

```
Name                  Protocol   Status     Buffer Free    Sessions
db01_db2_eng01        DB2        Running    96%            12
```

**検証**: Activity Monitor で対象 DB ホストの SQL が表示。Buffer Free が 80% 以上で安定。Sniffer Restart Threshold 件数が増えていないこと。

**関連**: [cfg-policy-build](#cfg-policy-build), [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload)

**出典**: S84, S39, S72

---

### cfg-policy-build: Policy の作成 / 配備 { #cfg-policy-build }

**重要度**: `S` / **用途**: Policy / Audit

**目的**: Access Policy を Policy Builder で作成し、Policy Installation tool で配備、ルール一致時にアラート / ログが流れる状態にする。

**前提**: Inspection Engine 稼働中、Group / Datasource 必要に応じて事前定義済（[cfg-group-define](#cfg-group-define) 参照）。

**手順**:

1. **Policy 作成**：Setup > Tools and Views > Policy Builder > New Policy。
    - Type: Access（標準）
    - Name: `PCI Audit Policy`
2. **Rule 追加**：Add Rule で：
    - **対象**: Object Group = "PCI Cardholder Tables"、User Group = "Privileged DB Users"
    - **Rule Action**: `Log Full Details` + `Alert Per Match`（`receivers` に SOC メーリングリスト）
3. **必要なら blocking ルール**：[cfg-policy-blocking](#cfg-policy-blocking) 参照。
4. **保存**：Save Policy。
5. **Policy Analyzer 実行**：Setup > Tools and Views > Policy Analyzer で衝突 / 重複チェック。
6. **配備**：Setup > Tools and Views > Policy Installation tool > Add Policy → Install。
7. **確認**：`grdapi list_policy` で `INSTALLED` を確認。

**期待出力**:

```
cli> grdapi list_policy
ID 12  PCI Audit Policy           ACCESS    INSTALLED
ID 17  Privileged User Watch      ACCESS    NOT INSTALLED
```

`grdapi install_policy` 直後:

```
cli> grdapi install_policy policy="PCI Audit Policy"
SUCCESS: Policy installed (size=82 rules, install_id=204)
```

**検証**: Policy 適用後、対象 Object Group の DB アクセスが Reports / Investigate Dashboard に Severity 付きで流れること。

**ロールバック**: Policy Installation tool で旧 Policy に install 戻し（installation 履歴を保存）。

**関連**: [cfg-policy-blocking](#cfg-policy-blocking), [cfg-policy-session](#cfg-policy-session), [cfg-group-define](#cfg-group-define), [inc-policy-not-active](09-incident-procedures.md#inc-policy-not-active)

**出典**: S9, S11, S12, S50, S51

---

### cfg-audit-process: Audit Process の作成と Schedule 設定 { #cfg-audit-process }

**重要度**: `S` / **用途**: Policy / Audit

**目的**: PCI / SOX / HIPAA / DORA / NYDFS の証跡レビューを Audit Process で自動化し、Receivers にメール / ticket 配信、Schedule で定期実行されるようにする。

**前提**: Reports / Privacy Set / VA / Security Assessment の必要なタスクがそろっている、Receivers 候補（ユーザ / グループ / メーリングリスト）が Access Manager で定義済、Global Profile に SMTP 登録済。

**手順**:

1. **Audit Process 作成**：Comply > Tools and Views > Audit Process Builder > New Audit Process。
    - Name: `Monthly_PCI_Audit`
    - Advanced Options: archive 保持、CSV / CEF 出力ファイル名、Custom email template（12.1+）
2. **Tasks 追加**：少なくとも 1 つ。
    - Privacy Set タスク（Sensitive Data Discovery 結果のレビュー）
    - Security Assessment タスク（VA 結果のレビュー）
    - Report タスク（Predefined or Custom Report）
3. **Receivers**：個人 / グループ / メール / ticket 配信、`Continuous flag` で順序制御、`Sign-off` 必須者の指定（職務分掌対応）。
4. **Schedule**：UI から cron 形式（例：毎月 1 日 03:00）で設定。
5. **Run once now で動作確認** → Audit Process Log で結果ファイル / 配信履歴を確認。
6. **CM 配下なら Distribution Profile**：Comply > Distribution Profile に当該 Audit Process を追加し配下 MU へ配信（[cfg-compliance-template](#cfg-compliance-template) 参照）。

**期待出力**:

`grdapi run_audit_process processName="Monthly_PCI_Audit"`:

```
SUCCESS: process started, runId=8821
```

Audit Process Log:

```
[8821] STARTED at 2026-05-01 03:00:01
[8821] Task 1 (Report: PCI Cardholder Access)   :  COMPLETE  rows=12,432
[8821] Task 2 (Privacy Set Review)              :  COMPLETE  rows=  85
[8821] Task 3 (Security Assessment)             :  COMPLETE  findings=  41
[8821] Notification sent to: pci-soc@example.com (3 recipients)
[8821] CSV archived: /var/IBM/Guardium/data/audit_results/Monthly_PCI_Audit_2026-05-01.csv (4.2 GB)
[8821] FINISHED at 2026-05-01 03:42:18  status=OK
```

**検証**: 1 ヶ月後の Audit Process Log で正常完了、Receivers のメール受信、署名（Sign-off）状態の更新を UI から確認。

**注意点**: remote source 結果の上限は 100,000 件（`store save_result_fetch_size` で変更可）、CSV は 10GB 上限のため Zip CSV for email 推奨。

**関連**: [cfg-compliance-template](#cfg-compliance-template), [cfg-alert-route](#cfg-alert-route), [inc-audit-process-stuck](09-incident-procedures.md#inc-audit-process-stuck)

**出典**: S17, S18, S89, S62, S22

---

### cfg-archive-purge: Daily Archive / Daily Import / Daily Purge の構成 { #cfg-archive-purge }

**重要度**: `S` / **用途**: Aggregator / Archive

**目的**: Collector の Daily Archive、Aggregator の Daily Import、両者の Daily Purge を **正しい順序** で構成して、データ欠損なく長期保持を実現する。

**前提**: Collector / Aggregator が稼働中、Aggregator が CM 配下の MU として認識済、外部ストレージ（NFS / SMB / S3 互換）への接続性確認済。

**手順**:

1. **Collector 側 Daily Archive**：Comply > Tools and Views > Data Archive で：
    - 開始時刻: 02:00（業務時間外）
    - 保持期間: 15 日（推奨既定）
    - 出力先: NFS / SMB / SCP（暗号化 + 署名）
2. **Aggregator 側 Daily Import**：Aggregator 上で Schedule に Daily Import を設定。Collector の Archive **完了時刻 + 30 分** をマージン。
3. **Daily Purge**：Collector 側で **Archive 完了の確認後** に Daily Purge を Schedule。Aggregator 側でも保持期間（推奨 30 日）を超過したものを Purge。
4. **Long-term retention（任意）**：S3 互換ストレージへの cold storage を `grdapi configure_complete_cold_storage` で構成。

    ```
    grdapi configure_complete_cold_storage \
        endpoint="https://s3.example.com" \
        accessKey="AKIAxxx" secretKey="****" \
        bucket="guardium-archive" retention=2555
    ```

5. **動作確認**：Comply > Tools and Views > Data Management Schedule で各ジョブの最終成功時刻を確認。

**期待出力**:

Data Management Schedule History 抜粋:

```
JOB                        LAST SUCCESS              SIZE     STATUS
Daily Archive (Collector)  2026-05-04 02:48:21       3.1 GB   OK
Daily Import (Aggregator)  2026-05-04 03:15:42       3.1 GB   OK
Daily Purge (Collector)    2026-05-04 04:01:08       —        OK (15 days retained)
Long-term retention (S3)   2026-05-04 04:30:55       3.1 GB   OK (s3://guardium-archive/2026/05/04/)
```

**検証**: Aggregator のレポート取得時に Collector の最新データが反映、`/var` 使用率が 60% 以下で安定。

**注意点**: **Archive 前に Purge は禁止**（データ欠損）。**Aggregator archive は Collector へ復元不可**（逆は可、`Backup and restore` ガイド参照）。CSV 10GB 上限。

**関連**: [inc-disk-full](09-incident-procedures.md#inc-disk-full), [inc-aggregator-import-fail](09-incident-procedures.md#inc-aggregator-import-fail)

**出典**: S33, S41, S42, S80, S81, S82, S2

---

### cfg-rbac-design: 最小権限ロールの設計と Access Manager 設定 { #cfg-rbac-design }

**重要度**: `S` / **用途**: アクセス / 証明書

**目的**: GDP 運用者ごとに最小権限で UI / API アクセスさせ、職務分掌（SoD）と監査追跡性を確保する。

**前提**: Access Manager UI が動作（Setup > Tools and Views > Access Management）、社内のロール体系（DB セキュリティ管理 / SOC / DBA / 監査人）が決まっている。

**手順**:

1. **Roles**：「Creating a role with minimal access」（S57）に従い、必要権限のみ付与。標準 default roles（admin / inv / user / cli / accessmgr / dbaccess）の権限を「Access for default roles and applications」（S56）で確認の上、不要な権限を削る方式が推奨。
2. **Groups**：対象 DB 種別 / table / port 等の Group を定義。
3. **Users**：ユーザにロール割当。MFA は Portal 側で有効化（Web Console の認証は LDAP / SAML / Radius と接続）。
4. **API-only User**：自動化スクリプト用には UI ログイン不可・API のみのユーザ作成（12.2 で導入）。
5. **旧 UI への退避（必要時）**：12.2.2 の新 Access Manager UI から旧 UI に戻すには `grdapi MODIFY_GUARD_PARAM paramName=LEGACY_ACCESSMGR_ENABLED paramValue=1`。

**期待出力**:

```
cli> grdapi list_users
USER         ROLES                        TYPE    LAST_LOGIN
admin        admin                        UI      2026-05-04 09:12
soc_audit    inv,user                     UI      2026-05-04 08:55
api_etl      api-only                     API     2026-05-04 03:00
dba_view     user(read-only),dbaccess     UI      2026-04-28 10:34
```

**検証**: 設定後、各ユーザで UI ログインして見えるメニューが期待通りであること、API キー認証で grdapi が叩けること。

**注意点**: admin ロールは複数人に渡さない。SoD 観点で Audit Process の Sign-off は admin と別ユーザに割当。

**関連**: [cfg-cert-rotation](#cfg-cert-rotation)

**出典**: S19, S20, S55, S56, S57, S58, S2

---

### cfg-stap-failover: S-TAP failover_sqlguardip 設定と動作確認 { #cfg-stap-failover }

**重要度**: `A` / **用途**: S-TAP / DB 監視

**目的**: プライマリ Collector が落ちたとき S-TAP が自動的にバックアップ Collector に切替し、データ損失を最小化する構成。

**手順**:

1. consolidated_installer.sh インストール時に `--failover_sqlguardip <Backup Collector>` を追加。既存 S-TAP は guard_tap.ini の Server List に backup IP を追加 → S-TAP 再起動。
2. **テスト**：プライマリ Collector を `restart system`、S-TAP のログで failover 検知 / Backup へ接続切替が記録されることを確認。
3. **ILB 併用**：appliance 側で ILB を有効化、virtual IP を S-TAP に指定して Collector 群への分散と冗長を兼ねる。

**注意点**: failover 中は監査データの一部が滞留する場合があるため、業務 SLA に応じてバッファサイズを調整。

**関連**: [cfg-stap-deploy](#cfg-stap-deploy), [inc-stap-conn-fail](09-incident-procedures.md#inc-stap-conn-fail)

**出典**: S35, S2, S43

---

### cfg-stap-zos: z/OS 上の DB2 / IMS / Datasets 監視 S-TAP { #cfg-stap-zos }

**重要度**: `A` / **用途**: S-TAP / DB 監視

**目的**: z/OS 上の DB2 / IMS / Dataset 監視を行う。Linux 系 S-TAP とは別パッケージ。

**手順**: SMP/E 配布物（FMID 単位）を z/OS に APPLY → ZPARM / SDSF から S-TAP プロシージャ起動 → Collector 側で Inspection Engine の Protocol を `DB2 z/OS` 等に設定。詳細は IBM Docs の「S-TAP for DB2 on z/OS」「S-TAP for IMS on z/OS」「S-TAP for Data Sets on z/OS」（S24/S25/S26）と「z/OS S-TAP troubleshooting」（S27）。

**注意点**: z/OS 系 S-TAP は別ライセンスが必要なケースあり、Db2 z/OS のセキュリティ要件（RACF / EXTERNAL SECURITY）の設定も併行。

**関連**: 本サイトの [Db2 for z/OS 13 ガイド](../db2-for-zos-13/index.md), [z/OS 3.1 ガイド](../z-os-3-1/index.md)

**出典**: S24, S25, S26, S27

---

### cfg-policy-blocking: ブロッキング Policy（S-GATE TERMINATE）の構成 { #cfg-policy-blocking }

**重要度**: `A` / **用途**: Policy / Audit

**目的**: 違反 SQL を S-GATE TERMINATE で **インライン切断**する Policy を作成し、業務継続性とセキュリティのバランスを取る。

**手順**: Policy Builder で Rule に `S-GATE TERMINATE`（または `DROP` / `QUARANTINE`）を Action として設定 → Policy Analyzer で誤検知の可能性を確認 → 段階展開（小さな Group → 全社）。

**注意点**: ブロッキングは事故が大きいため、最初は **アラート + ログ** で誤検知率を測定してから TERMINATE 化が定石。`Quarantine for failed logins`（12.1）は閾値設計が要点。

**関連**: [cfg-policy-build](#cfg-policy-build), [inc-blocking-misfire](09-incident-procedures.md#inc-blocking-misfire)

**出典**: S10, S49, S2

---

### cfg-policy-session: Session-level Policy で IGNORE SESSION 構成 { #cfg-policy-session }

**重要度**: `A` / **用途**: Policy / Audit

**目的**: 信頼アプリ / バックアップ / 監視（Zabbix 等）からのセッションを **IGNORE SESSION** で sniffer 評価から外し、性能を確保する。

**手順**: Setup > Tools and Views > Policy Builder で **Session-level Policy** を新規作成 → Rule で User Group / Source Program Group に対し `IGNORE SESSION`（または重い Audit が不要なら `SOFT DISCARD SESSION`）。Access Policy より先に評価される（`Selective Audit` の階層上）。

**注意点**: 業務的に監査が必要なユーザを IGNORE してしまうと監査漏れリスク。Group 設計は慎重に。

**関連**: [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload)

**出典**: S87, S94, S76

---

### cfg-compliance-template: Smart assistant でテンプレート展開 { #cfg-compliance-template }

**重要度**: `A` / **用途**: Policy / Audit

**目的**: PCI / SOX / HIPAA / DORA / NYDFS のテンプレートから Policy + Group + Audit Process + Alert + VA を一括生成し、CM 経由で Distribution Profile に展開。

**手順**: Comply > Tools and Views > Smart assistant for compliance monitoring > 規制を選択 → 生成された Policy / Audit Process を環境に合わせ調整（IP マスク、対象 DB 種別、特権ユーザ Group）→ Policy Installation tool で配備 → CM 側 Distribution Profile に登録 → 配下 MU へ配信。

**注意点**: 生成物は雛形。本番配備前に Policy Analyzer + 段階展開（IGNORE SESSION 併用）。

**関連**: [cfg-policy-build](#cfg-policy-build), [cfg-audit-process](#cfg-audit-process), [cfg-cm-managed-unit](#cfg-cm-managed-unit)

**出典**: S61, S62, S63, S88

---

### cfg-cert-rotation: 証明書 rotation（Trusted / Appliance / Web） { #cfg-cert-rotation }

**重要度**: `A` / **用途**: アクセス / 証明書

**目的**: 期限切れ前に Trusted CA / Appliance / Web 証明書を rotation し、CM ↔ MU、S-TAP ↔ Collector、Web Console の通信が継続。

**手順**: 期限の事前確認（`show certificate stored` / `show certificate exceptions` / `grdapi get_certificates`）→ 新証明書を `fileserver` で受信 → `store certificate keystore trusted console` で trusted 追加（または appliance / web） → 一部はサービス再起動（`restart gui`）→ 動作確認。proxy 環境なら proxy CA を trusted に追加。

**注意点**: GIM 12.2 系で SHA1 → SHA256 切替時、旧 SHA1 を当面残す並行期間を設けると DB サーバ側の更新が安全。

**関連**: [cfg-cm-managed-unit](#cfg-cm-managed-unit), [inc-stap-conn-fail](09-incident-procedures.md#inc-stap-conn-fail)

**出典**: S37, S83, S2

---

### cfg-cloud-monitoring: External S-TAP / Edge Gateway / Universal Connector でクラウド DB を監視 { #cfg-cloud-monitoring }

**重要度**: `A` / **用途**: 連携

**目的**: AWS RDS / Azure SQL DB / GCP Cloud SQL / Snowflake / SAP HANA / Teradata 等、エージェント設置不可な DB 群を監視対象に組み込む。

**手順**: External S-TAP（DB サーバ非変更型のプロキシ）または Edge Gateway 2.x（K8s ベース、Helm Chart）を AWS EKS / OpenShift / K3s に展開 → Universal Connector のプリインストールプラグイン（AlloyDB / Milvus / Singlestore / Sybase / Snowflake / SAP HANA / Teradata 等）または CloudWatch / JDBC / Kafka source を構成 → Collector / Aggregator / Insights へストリーミング。

**注意点**: VPC / 専用線 / TGW の経路設計、IAM ロール、KMS 鍵管理は本ドキュメント範囲外（[11. 対象外項目](10-out-of-scope.md) C カテゴリ）。

**関連**: [cfg-stap-deploy](#cfg-stap-deploy)

**出典**: S2, S43

---

### cfg-extrusion-policy: Extrusion Policy で漏洩監視 { #cfg-extrusion-policy }

**重要度**: `B` / **用途**: Policy / Audit

**目的**: DB から **返却される行データ** をパターン検出し、機密情報の漏洩を検知 / ブロック。

**手順**: Inspection Engine で `Inspect Returned Data` を ON → Policy Builder で **Extrusion Policy** を新規作成 → Rule に検出パターン（カード番号正規表現 / 個別 Group）を設定 → 検出時に `Alert Per Match` または `S-GATE TERMINATE`。

**注意点**: 性能影響大。Group / Object Group で対象を絞り込むのが必須。

**関連**: [cfg-policy-build](#cfg-policy-build), [cfg-inspection-engine](#cfg-inspection-engine)

**出典**: S9, S10, S49

---

### cfg-group-define: Group / Tag の定義と populate { #cfg-group-define }

**重要度**: `B` / **用途**: Policy / Audit

**目的**: Policy / Audit Process が参照する Group（IP / User / Object / Command 等のセット）を定義し、運用負荷を下げる。

**手順**: Setup > Tools and Views > Group Builder で New Group → Type 選択（OBJECTS / COMMANDS / USERS / CLIENT_IPS / SERVER_IPS 等）→ populate（クエリベース自動更新）または manual で member 投入 → Tag を付与し他 Policy から再利用（Tag-based Rule Import、S53）。

**関連**: [cfg-policy-build](#cfg-policy-build)

**出典**: S21, S52, S53, S58

---

### cfg-alert-route: アラート配信先（SMTP / SNMP / Syslog / CEF / LEEF） { #cfg-alert-route }

**重要度**: `B` / **用途**: Policy / Audit

**目的**: アラートを SMTP / SNMP / Syslog / CEF / LEEF / Custom feed に流して SOC / SIEM へ届ける。

**手順**: Setup > Tools and Views > Global Profile で SMTP / SNMP / Syslog 受信先 → Policy ルールの `Alert Per Match` Action で受信者選択 → 12.2 で S/MIME（FIPS 140-3）対応のメール署名・暗号化。

**関連**: [cfg-policy-build](#cfg-policy-build)

**出典**: S22, S23, S2

---

### cfg-va-scan: Vulnerability Assessment の構成と実行 { #cfg-va-scan }

**重要度**: `C` / **用途**: Policy / Audit

**目的**: 対象 DB の脆弱性 / 構成不備を CIS / STIG / 独自テンプレートで定期スキャンし、Vulnerability management hub で集中管理。

**手順**: Setup > Data Sources で Datasource 登録（VA database privileges に従い権限を最小限で付与）→ Harden > Vulnerability Assessment Builder でアセスメント定義 → Schedule → View Results / Vulnerability management hub（12.2.1）で確認。AWS EKS 上の VA Scanner（Helm Chart）展開も可能（12.2.1+）。

**注意点**: サポート DB は GA ノートで頻繁に更新（12.2.2 で MongoDB Atlas 8.0 / MarkLogic 11/12 / EDB PG 17.5 / Db2 LUW 12.1 / Oracle MySQL 8.4 等追加）。Modifiable severity / threshold は 12.2.2 で活用可。

**関連**: [cfg-datasource-register](#cfg-datasource-register)

**出典**: S28, S29, S2

---

### cfg-discovery-classify: Sensitive Data Discovery + Classification { #cfg-discovery-classify }

**重要度**: `C` / **用途**: Policy / Audit

**目的**: PCI / SOX 対象データを自動発見し分類、結果を Privacy Set として Audit Process / Policy で再利用。

**手順**: Discover > Database Discovery で DB 走査 → Sensitive Data Discovery でパターン検出（カード番号 / SSN / Canadian SIN 等）→ Privacy Set として保存。12.0+ では **Unified Discovery and Classification**（独立コンポーネント、Data Protection ライセンスに同梱）を活用。

**注意点**: Classification 単独では保護を提供しない。Policy で参照して保護を実装。

**関連**: [cfg-policy-build](#cfg-policy-build)

**出典**: S46, S47, S2

---

### cfg-ata-tune: ATA / Outliers Mining のチューニング { #cfg-ata-tune }

**重要度**: `C` / **用途**: Policy / Audit

**目的**: Active Threat Analytics の case 生成基準をチューニングし、誤検知（Noise）と検知漏れのバランスを取る。

**手順**: Outliers Mining のベースライン期間（既定 7 日）を業務サイクルに合わせ調整 → ポリシールール / 閾値アラートから脅威カテゴリ作成 → Risk Spotter でリスクユーザ識別 → `grdapi update_ata_case_status` で case 一括クローズ / 除外 → CSV ベースの bulk update も UI 経由で。

**関連**: [cfg-policy-build](#cfg-policy-build)

**出典**: S48, S6, S2

---

### cfg-replay: Default Capture Value で Replay 機能を有効化 { #cfg-replay }

**重要度**: `C` / **用途**: S-TAP / DB 監視

**目的**: prepared statement の bind 値を補足して Replay 機能で SQL を再現できるようにする。

**手順**: Inspection Engine の `Default Capture Value` を `true` に → Engine 再起動 → Investigate > SQL Replay で対象 SQL を選択。

**注意点**: 性能影響あり（パケット解析が重くなる）。本当に Replay が必要な対象 Engine のみ ON が推奨。

**関連**: [cfg-inspection-engine](#cfg-inspection-engine)

**出典**: S84

---

### cfg-patch-install: パッチ適用（CM 経由 / 単機経由） { #cfg-patch-install }

**重要度**: `A` / **用途**: アプライアンス

**目的**: IBM Fix Central から取得した patch を CM 経由で配下 MU に一括配布、または単機 appliance に手動配布する。

**手順**: CM 経由は Patch Distribution Status から → Distribution Profile で配下グループ選択 → Apply。単機は `fileserver` で patch 受信 → UI から Setup > Tools and Views > Patch Installer で適用。

**注意点**: 適用順序を守る（minor → fix pack の順）。Backup（`backup system`）後に適用。

**関連**: [cfg-archive-purge](#cfg-archive-purge)

**出典**: S31, S78

---

### cfg-upgrade: メジャーバージョンアップグレード { #cfg-upgrade }

**重要度**: `A` / **用途**: アプライアンス

**目的**: GDP のメジャーバージョン（11.x → 12.x、12.0 → 12.1 等）を計画停止で実施。

**手順**: 「Upgrading Guardium」（S32）の手順に従い、CM → Aggregator → Collector の順、各層で patch 互換性を確認しつつ適用。S-TAP は GIM 経由で更新（[cfg-stap-deploy](#cfg-stap-deploy) と同じ）。

**注意点**: メジャー upgrade は事前検証環境で。Daily Archive / Backup を必ず取得後に実行。

**関連**: [cfg-patch-install](#cfg-patch-install)

**出典**: S32, S31, S2

---

### cfg-datasource-register: Datasource の登録と Test Connection { #cfg-datasource-register }

**重要度**: `B` / **用途**: Policy / Audit

**目的**: VA / Audit Process / Classification が参照する DB 接続定義を登録し、Test Connection で疎通確認。

**手順**: Setup > Data Sources で New Datasource → host / port / dbType / user / password → Test Connection → 必要に応じ社内 CA を `store certificate keystore trusted console` で登録。grdapi 経由は [01. grdapi create_datasource](01-commands.md#grdapi-create-datasource)。

**注意点**: 認証情報の rotation 計画。Datasource ID 変更は Audit Process / VA / Classification の参照を破壊する。

**関連**: [cfg-va-scan](#cfg-va-scan), [cfg-audit-process](#cfg-audit-process)

**出典**: S36, S60, S37

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
