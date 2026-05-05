# ユースケース集

> 特定の作業の手順だけ知りたい読者向け。各ユースケースは独立完結、他に依存せず拾い読み可能。

**収録ユースケース**: 30 件

## カテゴリ別目次

- **アプライアンス / 構成（4 件）**: [uc-appliance-deploy](#uc-appliance-deploy), [uc-cm-managed-unit](#uc-cm-managed-unit), [uc-patch-install](#uc-patch-install), [uc-upgrade](#uc-upgrade)
- **S-TAP / DB 監視（5 件）**: [uc-stap-install](#uc-stap-install), [uc-stap-failover-pair](#uc-stap-failover-pair), [uc-stap-zos](#uc-stap-zos), [uc-inspection-engine](#uc-inspection-engine), [uc-buffer-monitor](#uc-buffer-monitor)
- **Policy / Rule（5 件）**: [uc-policy-build](#uc-policy-build), [uc-policy-blocking](#uc-policy-blocking), [uc-policy-extrusion](#uc-policy-extrusion), [uc-policy-session-tune](#uc-policy-session-tune), [uc-group-define](#uc-group-define)
- **Audit Process / Compliance（4 件）**: [uc-audit-process](#uc-audit-process), [uc-smart-assistant](#uc-smart-assistant), [uc-alert-route](#uc-alert-route), [uc-predefined-reports](#uc-predefined-reports)
- **アクセス / セキュリティ（3 件）**: [uc-rbac-design](#uc-rbac-design), [uc-cert-rotation](#uc-cert-rotation), [uc-fips-mode](#uc-fips-mode)
- **アーカイブ / 保持（3 件）**: [uc-archive-purge](#uc-archive-purge), [uc-cold-storage](#uc-cold-storage), [uc-purge-emergency](#uc-purge-emergency)
- **VA / Discovery / ATA（3 件）**: [uc-va-run](#uc-va-run), [uc-discovery-classify](#uc-discovery-classify), [uc-ata-tune](#uc-ata-tune)
- **連携 / クラウド（3 件）**: [uc-datasource-register](#uc-datasource-register), [uc-cloud-monitoring](#uc-cloud-monitoring), [uc-siem-integration](#uc-siem-integration)

!!! info "本章の品質方針"
    全ユースケースは GDP 12.x 公式マニュアル（IBM Docs Web S1-S96）記載の事実・手順のみで構成。AI が苦手な定性的判断（パラメータの業務的妥当値、運用ノウハウ）は範囲外で注意書きを付ける。

---

## アプライアンス / 構成

### Collector / Aggregator / CM の新規デプロイ { #uc-appliance-deploy }

**ID**: `uc-appliance-deploy` / **カテゴリ**: アプライアンス / 構成

#### 想定状況

新規 Guardium 環境（または既存環境への追加）として、Collector / Aggregator / CM のいずれかのアプライアンスを 1 台立ち上げる。

#### 詳細手順

1. **インストール**：物理は ISO ブート、仮想は OVA / qcow2 を vSphere / KVM へ展開。Storage は `/var` を最大化。
2. **初期コンソール設定**：

    ```
    cli> store network interface ...
    cli> store network resolver ...
    cli> store system hostname ...
    cli> store system clock ntp ...
    ```

3. **ライセンス投入**：`fileserver` で license file を授受 → UI から Setup > Tools and Views > License > Apply。
4. **タイプ設定**：Setup > Tools and Views > Configuration > Unit Utilization で Collector / Aggregator / CM を切替（既定は Collector）。
5. **Web UI 起動確認**：HTTPS 8443 で admin ログイン → System view ダッシュボードに緑表示。

#### 注意点

ライセンス系操作は商用契約領域、本ユースケースの範囲外。Trial license は 90 日（延長 1 回 90 日）。Trial と通常ライセンスは併用不可。

#### 関連ユースケース

[uc-cm-managed-unit](#uc-cm-managed-unit), [uc-stap-install](#uc-stap-install)

**出典**: S30, S31, S32, S64

---

### Central Manager 配下に Managed Unit を登録 { #uc-cm-managed-unit }

**ID**: `uc-cm-managed-unit` / **カテゴリ**: アプライアンス / 構成

#### 想定状況

Standalone Collector / Aggregator を CM 配下の Managed Unit として登録し、CM から patch / Policy / Audit Process を一括配布できる状態にする。

#### 詳細手順

1. CM の Setup > Tools and Views > Central Management > Add Unit に Collector の IP / 8443 認証を入力。
2. Collector 側で Setup > Configuration > Unit Utilization を「CM-managed」に切替。
3. CM 証明書を MU 側に trust 登録（`store certificate keystore trusted console`）。
4. Distribution Profile を作成して配下 MU グループに紐付け。

#### 関連ユースケース

[uc-cert-rotation](#uc-cert-rotation), [uc-smart-assistant](#uc-smart-assistant)

**出典**: S43, S90, S37

---

### パッチ適用（CM 経由 / 単機経由） { #uc-patch-install }

**ID**: `uc-patch-install` / **カテゴリ**: アプライアンス / 構成

#### 想定状況

IBM Fix Central から取得した patch を、CM 経由で配下 MU に一括配布、または単機 appliance に手動配布。

#### 詳細手順

1. CM 経由：Patch Distribution Status > Distribution Profile で配下選択 → Apply。
2. 単機：`fileserver 30 <client-ip>` で patch 受信 → UI から Setup > Tools and Views > Patch Installer で適用。
3. 適用後、`show installed_modules` でパッチレベル確認。

#### 注意点

minor → fix pack の順、`backup system` を取得後に適用。

#### 関連ユースケース

[uc-upgrade](#uc-upgrade)

**出典**: S31, S78

---

### メジャーバージョンアップグレード { #uc-upgrade }

**ID**: `uc-upgrade` / **カテゴリ**: アプライアンス / 構成

#### 想定状況

GDP 11.x → 12.x、または 12.0 → 12.1 等のメジャー upgrade を計画停止で実施。

#### 詳細手順

1. 「Upgrading Guardium」（S32）の手順に従い、CM → Aggregator → Collector の順で適用。
2. 各層で patch 互換性を確認しつつ適用、Daily Archive を直前に取得。
3. S-TAP は GIM 経由で更新（[uc-stap-install](#uc-stap-install) と同様の流れ）。

#### 注意点

事前検証環境必須。Aggregator archive 互換性は upgrade 前に確認（一部 archive は新版で読めないケースあり）。

**出典**: S32, S31, S2

---

## S-TAP / DB 監視

### Linux x86_64 Db2 サーバへ S-TAP を配備 { #uc-stap-install }

**ID**: `uc-stap-install` / **カテゴリ**: S-TAP / DB 監視

#### 想定状況

新規 DB サーバを Guardium 監視対象に追加。Linux RHEL 8 + Db2 の典型例。

#### 前提条件

- IBM Guardium Data Protection Trial / Passport Advantage から GIM + S-TAP zip を入手
- Collector 側で 16016 / 16017 開放、`failover_sqlguardip` の Backup Collector も決定済
- DB サーバが root 権限で操作可

#### 詳細手順

1. **配布物入手 / 解凍**：

    ```
    unzip Guardium_12.1.1.2_GIM_RedHat_r119073.zip
    unzip Guardium_12.1.1.2_S-TAP_RedHat_r119073.zip
    ```

2. **インストール**：

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

3. **プロセス確認**：`ps -ef | grep -i gim`、`ps -ef | grep -i tap` で `guard_gimd`、`guard_stap`、`guard_discovery` 起動確認。
4. **CM UI で Module Installation が GREEN 確認**。
5. **Inspection Engine 作成** → [uc-inspection-engine](#uc-inspection-engine)

#### 注意点

Trial license は 90 日。GIM client と S-TAP の OS / アーキ整合（rhel-7/8/9 × x86_64）に注意。

#### 関連ユースケース

[uc-inspection-engine](#uc-inspection-engine), [uc-stap-failover-pair](#uc-stap-failover-pair)

**出典**: S35, S34, S30, S2

---

### S-TAP の Failover ペア構成 { #uc-stap-failover-pair }

**ID**: `uc-stap-failover-pair` / **カテゴリ**: S-TAP / DB 監視

#### 想定状況

プライマリ Collector が落ちた際、S-TAP が自動的にバックアップ Collector に切替するように構成。

#### 詳細手順

1. consolidated_installer.sh インストール時に `--failover_sqlguardip <Backup Collector>` 追加。既存 S-TAP は guard_tap.ini の Server List に backup IP を追加 → S-TAP 再起動。
2. テスト：プライマリ Collector を `restart system`、S-TAP のログで failover 切替を確認。

#### 注意点

ILB（Internal Load Balancer）併用で Collector 群への負荷分散と冗長を兼ねるのが推奨。

**出典**: S35, S2, S43

---

### z/OS S-TAP（DB2 / IMS / Datasets） { #uc-stap-zos }

**ID**: `uc-stap-zos` / **カテゴリ**: S-TAP / DB 監視

#### 想定状況

z/OS 上の DB2 / IMS / Dataset 監視を行う。Linux 系 S-TAP とは別パッケージ。

#### 詳細手順

1. SMP/E 配布物（FMID 単位）を z/OS に APPLY。
2. ZPARM / SDSF から S-TAP プロシージャ起動。
3. Collector 側で Inspection Engine の Protocol を `DB2 z/OS` 等に設定。

#### 詳細

IBM Docs の「S-TAP for DB2 on z/OS」「S-TAP for IMS on z/OS」「S-TAP for Data Sets on z/OS」（S24/S25/S26）と「z/OS S-TAP troubleshooting」（S27）。

#### 注意点

z/OS 系 S-TAP は別ライセンスが必要なケースあり、Db2 z/OS のセキュリティ要件（RACF / EXTERNAL SECURITY）の設定も並行。

#### 関連ユースケース

本サイトの [Db2 for z/OS 13](../db2-for-zos-13/index.md), [z/OS 3.1](../z-os-3-1/index.md)

**出典**: S24, S25, S26, S27

---

### Inspection Engine の作成と起動 { #uc-inspection-engine }

**ID**: `uc-inspection-engine` / **カテゴリ**: S-TAP / DB 監視

#### 想定状況

S-TAP からのトラフィックを受ける Inspection Engine を Collector 上に作成。

#### 詳細手順

1. Manage > Activity Monitoring > Inspection Engines > Add Inspection Engine（Collector 上、CM では作成不可）。
2. Name / Protocol / DB Server IP/Mask / Port / Active on startup を設定。
3. Save → Engine 起動 → Activity Monitor で SQL 確認。

#### バリエーション

`grdapi update_engine_config` 経由でも作成可（自動化フレームワーク向け）。

#### 注意点

`Log Records Affected` / `Inspect Returned Data` は性能影響大。必要時のみ ON。

**出典**: S84, S39, S72

---

### Buffer Free 監視と Sniffer Restart 確認 { #uc-buffer-monitor }

**ID**: `uc-buffer-monitor` / **カテゴリ**: S-TAP / DB 監視

#### 想定状況

日次 / 週次で Sniffer の健全性を確認、Buffer Free が安定して 80% 以上であることを保証。

#### 詳細手順

1. Manage > Activity Monitoring > Inspection Engines で各 Engine の Buffer Free / Sessions 数 / Sniffer Restart 件数を確認。
2. Investigate Dashboard でフィルタ保存を活用して定期チェック化。
3. 異常傾向（Buffer Free 50% 以下、Restart 連発）は [inc-sniffer-overload](09-incident-procedures.md#inc-sniffer-overload) へ。

**出典**: S39, S40, S76

---

## Policy / Rule

### Access Policy の作成と配備 { #uc-policy-build }

**ID**: `uc-policy-build` / **カテゴリ**: Policy / Rule

#### 想定状況

PCI / SOX / HIPAA 系で「特権ユーザの機密テーブルアクセスを記録 + アラート」する Policy を導入。

#### 詳細手順

1. Setup > Tools and Views > Policy Builder > New Policy。Type: Access、Name: 例 `PCI Audit Policy`。
2. Add Rule で Object Group / User Group / Rule Action を設定。
3. Policy Analyzer で衝突 / 重複チェック。
4. Setup > Tools and Views > Policy Installation tool > Add Policy → Install。
5. `grdapi list_policy` で `INSTALLED` 確認。

#### 注意点

保存だけでは反映されない。Policy Installation tool での Install が必須。

**出典**: S9, S11, S12, S50, S51

---

### ブロッキング Policy（S-GATE TERMINATE） { #uc-policy-blocking }

**ID**: `uc-policy-blocking` / **カテゴリ**: Policy / Rule

#### 想定状況

機密テーブルへの違反 SQL を **インライン切断** したい。

#### 詳細手順

1. Policy Builder で Rule Action を `S-GATE TERMINATE`（または `DROP` / `QUARANTINE`）に。
2. 段階展開：最初は **アラート + ログ** で誤検知率を測定 → 落ち着いてから TERMINATE 化。
3. Policy Analyzer で誤検知の可能性を確認。

#### 注意点

ブロッキングは事故が大きい。Group の包含範囲が広すぎると業務影響大。`Quarantine for failed logins`（12.1）の閾値設計も慎重に。

**出典**: S10, S49, S2

---

### Extrusion Policy で漏洩監視 { #uc-policy-extrusion }

**ID**: `uc-policy-extrusion` / **カテゴリ**: Policy / Rule

#### 想定状況

DB から **返却される行データ** にカード番号 / SSN 等のパターンが出現したら検知 / ブロック。

#### 詳細手順

1. Inspection Engine の `Inspect Returned Data` を ON。
2. Policy Builder で Extrusion Policy 新規作成。
3. Rule に検出パターン（正規表現 / Group）→ `Alert Per Match` または `S-GATE TERMINATE`。

#### 注意点

性能影響大。Group / Object Group で対象を絞り込むのが必須。

**出典**: S9, S10, S49

---

### Session-level Policy で IGNORE SESSION { #uc-policy-session-tune }

**ID**: `uc-policy-session-tune` / **カテゴリ**: Policy / Rule

#### 想定状況

信頼アプリ / バックアップ / Zabbix を sniffer から外して性能確保。

#### 詳細手順

1. Setup > Tools and Views > Policy Builder で **Session-level Policy** を新規作成。
2. Rule で User Group / Source Program Group に対し `IGNORE SESSION`（または `SOFT DISCARD SESSION`）。
3. Policy Installation tool で配備。Access Policy より上位で評価される。

#### 注意点

監査が必要なユーザを誤って IGNORE すると監査漏れリスク。Group 設計は慎重に。

**出典**: S87, S94, S76

---

### Group / Tag の定義と populate { #uc-group-define }

**ID**: `uc-group-define` / **カテゴリ**: Policy / Rule

#### 想定状況

Policy 横断で「Privileged DB Users」「PCI Cardholder Tables」を共有する Group を整備。

#### 詳細手順

1. Setup > Tools and Views > Group Builder > New Group。
2. Type 選択（OBJECTS / COMMANDS / USERS / CLIENT_IPS / SERVER_IPS 等）。
3. populate（クエリベース自動更新）または manual で member 投入。
4. Tag 付与で他 Policy から Tag-based Rule Import 可能。

#### 注意点

populate group は Datasource 接続必須。populate query が遅いと Policy 展開が遅延。

**出典**: S21, S52, S53, S58

---

## Audit Process / Compliance

### Audit Process の作成と Schedule 設定 { #uc-audit-process }

**ID**: `uc-audit-process` / **カテゴリ**: Audit Process / Compliance

#### 想定状況

PCI / SOX / HIPAA / DORA / NYDFS の証跡を月次でレビュー、Receivers にメール / ticket 配信。

#### 詳細手順

1. Comply > Tools and Views > Audit Process Builder > New Audit Process。
2. Tasks（Privacy Set / Security Assessment / Report）を Add tasks で追加。
3. Receivers タブで配信先 / 署名責任者を設定（Continuous flag で順序制御）。
4. Schedule で定期実行（例：毎月 1 日 03:00）。
5. Run once now で動作確認 → Audit Process Log で結果確認。

#### 注意点

remote source 結果は 100,000 件上限（`store save_result_fetch_size` で変更可）。CSV は 10GB 上限（Zip CSV for email 推奨）。

**出典**: S17, S18, S89, S62

---

### Smart assistant でテンプレート展開 { #uc-smart-assistant }

**ID**: `uc-smart-assistant` / **カテゴリ**: Audit Process / Compliance

#### 想定状況

PCI-DSS / SOX / HIPAA / DORA / NYDFS の Policy + Group + Audit Process + Alert + VA を一括生成して時短。

#### 詳細手順

1. Comply > Tools and Views > Smart assistant for compliance monitoring。
2. 規制テンプレートを選択 → 雛形を一括生成。
3. 生成された Policy を環境に合わせ調整（IP / DB 種別 / 特権ユーザ Group）。
4. Policy Installation tool で配備、Audit Process Builder で Receivers / Schedule 完成。

#### 注意点

生成物は雛形。本番配備前に Policy Analyzer + 段階展開（IGNORE SESSION 併用）。

**出典**: S61, S62, S63, S88

---

### アラート配信先（SMTP / SNMP / Syslog / CEF / LEEF） { #uc-alert-route }

**ID**: `uc-alert-route` / **カテゴリ**: Audit Process / Compliance

#### 想定状況

Policy ルール発火時のアラートを SOC / SIEM へ流す。

#### 詳細手順

1. Setup > Tools and Views > Global Profile で SMTP / SNMP / Syslog 受信先登録。
2. Policy ルールの Action を `Alert Per Match` 等にして受信者を選択。
3. 12.2 で S/MIME（FIPS 140-3）のメール署名・暗号化対応。

**出典**: S22, S23, S2

---

### Predefined Reports での監査ログ確認 { #uc-predefined-reports }

**ID**: `uc-predefined-reports` / **カテゴリ**: Audit Process / Compliance

#### 想定状況

新規環境で監査ログが流れていることを Predefined Reports で確認。

#### 詳細手順

1. Reports > Predefined Reports（user / admin / common）。
2. PCI Cardholder Access、Privileged User Activity 等の標準レポートを開く。
3. 必要に応じ Query-Report Builder でカスタムレポート派生。

**出典**: S13, S14, S15, S54, S86

---

## アクセス / セキュリティ

### 最小権限ロールの設計 { #uc-rbac-design }

**ID**: `uc-rbac-design` / **カテゴリ**: アクセス / セキュリティ

#### 想定状況

GDP 運用者ごとに最小権限で UI / API アクセス。

#### 詳細手順

1. Setup > Tools and Views > Access Management（12.2.2 で再設計、tab レイアウト）。
2. Roles タブで「Creating a role with minimal access」（S57）の手順に沿って権限を絞る。
3. Groups / Users タブで割当。
4. API-only User（12.2 導入）を自動化スクリプト用に作成。

#### バリエーション

旧 Access Manager UI に戻すには `grdapi MODIFY_GUARD_PARAM paramName=LEGACY_ACCESSMGR_ENABLED paramValue=1`（12.2.2）。

**出典**: S19, S20, S55, S56, S57, S58, S2

---

### 証明書 rotation { #uc-cert-rotation }

**ID**: `uc-cert-rotation` / **カテゴリ**: アクセス / セキュリティ

#### 想定状況

期限切れ前に Trusted CA / Appliance / Web 証明書を rotation。

#### 詳細手順

1. `show certificate stored`、`show certificate exceptions`、`grdapi get_certificates` で期限確認。
2. 新証明書を `fileserver` で受信。
3. `store certificate keystore trusted console` で trusted 追加（または appliance / web）。
4. 一部はサービス再起動（`restart gui`）→ 動作確認。

#### 注意点

GIM 12.2 系で SHA1 → SHA256 切替時、旧 SHA1 を当面残す並行期間を設けると DB サーバ側の更新が安全。

**出典**: S37, S83, S2

---

### FIPS 140-2 / 140-3 モード { #uc-fips-mode }

**ID**: `uc-fips-mode` / **カテゴリ**: アクセス / セキュリティ

#### 想定状況

公的機関 / NIST 準拠要件で FIPS モードを有効化。

#### 詳細手順

1. CLI で FIPS モード有効化（`store system fips on` 系コマンド、IBM Docs 該当章参照）。
2. Web Console / S-TAP / GIM の暗号アルゴリズムが FIPS 準拠に切替。
3. 12.2 で S/MIME（FIPS 140-3）対応のメール署名・暗号化を Audit Process アラートに適用。

#### 注意点

FIPS モード化は再起動を伴うケースあり。利用可能な暗号 suite が制限される。

**出典**: S2, S37, S_FIPS_140

---

## アーカイブ / 保持

### Daily Archive / Daily Import / Daily Purge の構成 { #uc-archive-purge }

**ID**: `uc-archive-purge` / **カテゴリ**: アーカイブ / 保持

#### 想定状況

Collector の日次アーカイブ → Aggregator の Daily Import → 両側 Daily Purge を **正しい順序** で構成。

#### 詳細手順

1. Comply > Tools and Views > Data Archive で Collector 側 Daily Archive を Schedule（例：02:00、保持 15 日）。
2. Aggregator 側で Daily Import を Schedule（Archive 完了 + 30 分マージン）。
3. Collector / Aggregator 両側で Daily Purge を Schedule。
4. Comply > Tools and Views > Data Management Schedule History で各ジョブの最終成功時刻確認。

#### 注意点

**Archive 前に Purge は禁止**（データ欠損）。**Aggregator archive は Collector へ復元不可**（一方向）。

**出典**: S33, S41, S42, S80, S81, S82, S2

---

### Long-term retention（S3 互換） { #uc-cold-storage }

**ID**: `uc-cold-storage` / **カテゴリ**: アーカイブ / 保持

#### 想定状況

規制要件で 7 年保持等、ローカルでは抱えきれない長期保持を S3 互換オブジェクトストレージで実現。

#### 詳細手順

```
grdapi configure_complete_cold_storage \
    endpoint="https://s3.example.com" \
    accessKey="AKIAxxx" secretKey="****" \
    bucket="guardium-archive" retention=2555
```

12.2 統合 API。Aggregator → Long-term retention の経路を CLI 一発で構成可能。

#### 注意点

S3 endpoint 認証 / IAM / KMS 設計は範囲外（[10. 対象外項目](10-out-of-scope.md) C カテゴリ）。

**出典**: S2, S81, S82

---

### 緊急 Purge（disk full 対応） { #uc-purge-emergency }

**ID**: `uc-purge-emergency` / **カテゴリ**: アーカイブ / 保持

#### 想定状況

`/var` 90% 超で `auto_stop_services_when_full` が走る前に手動 Purge で復旧。

#### 詳細手順

1. `df -h /var` で使用率確認。
2. `du -sh /var/IBM/Guardium/data/*` で大カテゴリ特定。
3. UI: Comply > Purge で過去日付指定の Manual Purge 実行（または retention 短縮）。
4. Audit Process の古い結果ファイル（`/var/IBM/Guardium/data/audit_results/`）を `fileserver` で取り出して削除。
5. 60% 切ったら Schedule の retention / Purge 履歴見直し。

#### 注意点

`auto_stop_services_when_full off` は緊急時の一時的措置のみ。OFF のままは内部 DB 破損リスク。

**出典**: S79, S81, S2

---

## VA / Discovery / ATA

### Vulnerability Assessment 実行 { #uc-va-run }

**ID**: `uc-va-run` / **カテゴリ**: VA / Discovery / ATA

#### 想定状況

DB の構成不備・既知脆弱性を CIS / STIG / 独自テンプレートでスキャン。

#### 詳細手順

1. Setup > Data Sources で対象 DB のクレデンシャル登録（VA database privileges に従い権限付与）。
2. Harden > Vulnerability Assessment Builder でアセスメント定義。
3. スケジュール実行 → View Results / Vulnerability management hub（12.2.1）で確認。
4. AWS EKS 上の VA Scanner（Helm Chart）導入（12.2.1+）も可。
5. 12.2.2 で Modifiable severity / threshold（Assessment Tests レポート）を活用。

#### 注意点

サポート DB は 12.2.2 で MongoDB Atlas 8.0 / MarkLogic 11/12 / EDB PG 17.5 / Db2 LUW 12.1 / Oracle MySQL 8.4 等追加。

**出典**: S28, S29, S2

---

### Sensitive Data Discovery + Classification { #uc-discovery-classify }

**ID**: `uc-discovery-classify` / **カテゴリ**: VA / Discovery / ATA

#### 想定状況

PCI / SOX 対象の機密データを自動発見し分類、Privacy Set として Audit Process / Policy で再利用。

#### 詳細手順

1. Discover > Database Discovery で DB 走査。
2. Discover > Sensitive Data Discovery でクラシフィケーションプロセス作成（カード番号 / SSN / Canadian SIN 等のパターン）。
3. 結果を Privacy Set として保存。
4. 12.0+ では Unified Discovery and Classification（独立コンポーネント）も活用可能。

#### 注意点

Classification 単独では保護を提供しない。Policy で参照して保護を実装。

**出典**: S46, S47, S2

---

### ATA case のレビューと一括クローズ { #uc-ata-tune }

**ID**: `uc-ata-tune` / **カテゴリ**: VA / Discovery / ATA

#### 想定状況

ATA で生成された case が増えすぎたので severity 別にレビューして一括クローズ / 除外リスト追加。

#### 詳細手順

1. `grdapi list_ata_case_severity` で severity 別件数確認。
2. UI: Investigate > ATA から case をフィルタ。
3. `grdapi update_ata_case_status caseId=<n> status="CLOSED"` で更新。
4. 12.2 で case 一括クローズ・除外リスト対応。CSV bulk update も UI 経由で。

#### 関連ユースケース

[uc-policy-build](#uc-policy-build)（脅威カテゴリ作成）

**出典**: S48, S6, S2

---

## 連携 / クラウド

### Datasource の登録と Test Connection { #uc-datasource-register }

**ID**: `uc-datasource-register` / **カテゴリ**: 連携 / クラウド

#### 想定状況

VA / Audit Process / Classification が参照する Datasource を新規登録。

#### 詳細手順

1. Setup > Data Sources で New Datasource。host / port / dbType / user / password を入力。
2. Test Connection で疎通確認。
3. 必要に応じ社内 CA を `store certificate keystore trusted console` で登録。
4. grdapi 経由なら [01. grdapi create_datasource](01-commands.md#grdapi-create-datasource)。

#### 注意点

Datasource ID は他オブジェクトから参照されるため変更時は影響範囲を確認。

**出典**: S36, S60, S37

---

### クラウド DB 監視（External S-TAP / Edge Gateway / UC） { #uc-cloud-monitoring }

**ID**: `uc-cloud-monitoring` / **カテゴリ**: 連携 / クラウド

#### 想定状況

AWS RDS / Azure SQL DB / GCP Cloud SQL / Snowflake / SAP HANA / Teradata 等のマネージド DB を Guardium で監視。

#### 詳細手順

1. **External S-TAP**：DB サーバ非変更型のプロキシを VPC / VNet 内に配置。
2. **Edge Gateway 2.x**（K8s）：AWS EKS / OpenShift / K3s に Helm Chart で展開。Terraform 対応、外部レジストリ（air-gapped）対応。
3. **Universal Connector**：プリインストールプラグイン（AlloyDB / Milvus / Singlestore / Sybase / Snowflake / SAP HANA / Teradata 等）を有効化。CloudWatch / JDBC / Kafka source / CSV bulk upload で取り込み。
4. CM から Edge Gateway / UC を一元設定。

#### 注意点

VPC / 専用線 / TGW / IAM / KMS 設計は範囲外（[10. 対象外項目](10-out-of-scope.md) C カテゴリ）。

**出典**: S2, S43

---

### SIEM 連携（QRadar / Splunk / Elastic、CEF / LEEF / Syslog） { #uc-siem-integration }

**ID**: `uc-siem-integration` / **カテゴリ**: 連携 / クラウド

#### 想定状況

GDP のアラート / 監査ログを SIEM（QRadar / Splunk / Elastic）へ転送して相関分析。

#### 詳細手順

1. Setup > Tools and Views > Global Profile で Syslog 送信先（CEF / LEEF / 標準 syslog）を登録。
2. Policy ルールの Action で Alert を Syslog 経由で送出。
3. Audit Process Builder の Receivers に Syslog タスク追加で監査結果も連携。
4. 12.2 で Audit Process の CSV / CEF / 外部 feed export を統合。

#### 注意点

QRadar 側 / Splunk 側のパース定義は SIEM 側ドキュメント参照。

**出典**: S22, S23, S2

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
