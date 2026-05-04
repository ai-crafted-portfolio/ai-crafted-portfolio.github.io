# シナリオ別ガイド

> 業務全体のイメージから入りたい読者向け。各シナリオは典型的な業務状況と、関連するユースケース・手順への組み合わせ案内。

**他章との関係**:

- **本章（11. シナリオ別ガイド）**: meta レベル、業務全体の俯瞰
- **[13. ユースケース集](12-use-cases.md)**: 各ユースケースは独立完結、拾い読み可能
- 1 シナリオから複数ユースケースへリンク（1:N）

**収録シナリオ**: 6 本

| ID | タイトル | 概要 |
|---|---|---|
| [scn-new-subsystem-init](#scn-new-subsystem-init) | 新規 Db2 サブシステムの初期セットアップ | 新規 LPAR / 新規 SSID で Db2 を初めて立ち上げて運用に乗せるまでの全体俯瞰 |
| [scn-perf-investigation](#scn-perf-investigation) | 性能問題の切り分けと改善 | OLTP 応答悪化時に EXPLAIN/RUNSTATS/BP/Lock の順で原因特定 |
| [scn-disaster-recovery](#scn-disaster-recovery) | 災害復旧（DR）演習・準備 | image copy + archive log での RECOVER、DR サイトでの起動手順 |
| [scn-security-audit](#scn-security-audit) | セキュリティ監査要求への対応 | 「誰が何にアクセスしたか」への AUDIT TRACE + RACF ACM での対応 |
| [scn-version-migration](#scn-version-migration) | Db2 12 → 13 のバージョン移行 | Function Level / APPLCOMPAT 段階適用と回帰テスト |
| [scn-datasharing-add](#scn-datasharing-add) | データ共用環境の拡張（メンバ追加） | 既存 Sysplex Group に新メンバ追加で水平拡張 |

!!! info "本章の品質方針"
    全シナリオは IBM Db2 13 for z/OS 公式マニュアル記載の事実・手順のみで構成。AI が苦手な定性的判断（ベストプラクティス、経験則）は範囲外。

---

## 新規 Db2 サブシステムの初期セットアップ { #scn-new-subsystem-init }

**概要**: 新規 LPAR / 新規 SSID で Db2 を初めて立ち上げて運用に乗せるまでの全体俯瞰。

### シナリオの状況

新規 LPAR が割当てられ、Db2 13 for z/OS をインストール（SMP/E APPLY/ACCEPT 完了）した直後。これから業務利用に向けて以下を順次設定する必要がある。

### 推奨フロー（参照ユースケース）

#### Phase 1: サブシステム起動準備
1. **DSNZPARM 設計** → [uc-dsnzparm-edit](12-use-cases.md#uc-dsnzparm-edit)
   - CTHREAD / CONDBAT / MAXDBAT / IRLMRWT / NUMLKTS の決定
2. **z/OS 側のサブシステム登録（IEFSSNxx）** → [uc-iefssnxx-db2-add](12-use-cases.md#uc-iefssnxx-db2-add)
3. **IRLM PROC 配置** → [uc-irlm-proc-deploy](12-use-cases.md#uc-irlm-proc-deploy)

#### Phase 2: ログ・BSDS 構成
4. **ログ設計（active/archive 二重化）** → [uc-log-active-create](12-use-cases.md#uc-log-active-create)
5. **アーカイブログ設定** → [uc-log-archive-config](12-use-cases.md#uc-log-archive-config)
6. **BSDS 二重化** → [uc-bsds-create](12-use-cases.md#uc-bsds-create)

#### Phase 3: 起動と確認
7. **Db2 初回起動** → [uc-db2-startup](12-use-cases.md#uc-db2-startup)
8. **DDF 起動** → [uc-ddf-enable](12-use-cases.md#uc-ddf-enable)
9. **基本確認（DISPLAY THREAD/DDF/LOG/GROUP）** → [uc-display-status-check](12-use-cases.md#uc-display-status-check)

#### Phase 4: スキーマ・初期表
10. **STOGROUP 作成** → [uc-stogroup-create](12-use-cases.md#uc-stogroup-create)
11. **業務データベース・テーブル空間作成** → [uc-tablespace-pbg-create](12-use-cases.md#uc-tablespace-pbg-create)
12. **業務テーブル・索引作成** → [uc-table-create](12-use-cases.md#uc-table-create)

#### Phase 5: セキュリティ
13. **GRANT 設定** → [uc-grant-roles](12-use-cases.md#uc-grant-roles)
14. **RACF Access Control Module** → [uc-racf-acm-link](12-use-cases.md#uc-racf-acm-link)

#### Phase 6: バインド・運用
15. **業務 PACKAGE BIND** → [uc-bind-package-app](12-use-cases.md#uc-bind-package-app)
16. **イメージコピー初回取得** → [uc-imagecopy-full](12-use-cases.md#uc-imagecopy-full)
17. **RUNSTATS 初回** → [uc-runstats-initial](12-use-cases.md#uc-runstats-initial)

### ポイント

各 Phase 完了後に `-DISPLAY GROUP DETAIL`、`-DISPLAY DDF DETAIL`、`-DISPLAY DATABASE(*) RESTRICT`、`-DISPLAY LOG` 等で設定を確認。Catalog Level / Function Level の整合確認は出荷前に必須。

---

## 本記事の範囲

**本記事の範囲**: 新規 Db2 サブシステムの初回立上に必要な PARMLIB / DSNZPARM / 初期 catalog セットを扱う。z/OS 側 LPAR の事前準備（IODF / IEASYS 等）は対象外で、別途 z/OS 3.1 のサイトを参照。データ共用グループ自体の新規構築は別シナリオ（[scn-datasharing-add](#scn-datasharing-add) は既存グループへの追加）。

AI が苦手な定性的判断（サイズ目安、運用ノウハウ）は範囲外。経験ある DBA・SME か IBM サポートに確認推奨。

---

## 性能問題の切り分けと改善 { #scn-perf-investigation }

**概要**: OLTP 応答悪化・バッチ遅延の問題を、EXPLAIN/RUNSTATS/BP/Lock の順で原因特定。

### シナリオの状況

業務側から「ある SQL の応答が遅くなった」「バッチが SLA を切る」と報告。Db2 系の問題なのか、アプリ・I/O・他要因なのかを切り分け、ボトルネック特定→改善まで。

### 推奨フロー

#### Phase 1: 問題特定
1. **動作中スレッド確認** → [uc-display-status-check](12-use-cases.md#uc-display-status-check)
2. **対象 SQL の EXPLAIN 取得** → [uc-explain-analyze](12-use-cases.md#uc-explain-analyze)
3. **ロック競合チェック** → 障害対応 [inc-lock-timeout](09-incident-procedures.md#inc-lock-timeout)

#### Phase 2: アクセスパス分析
4. **PLAN_TABLE 内容を分析** → [uc-explain-analyze](12-use-cases.md#uc-explain-analyze)
5. **RUNSTATS 鮮度確認・必要なら再取得** → [uc-runstats-initial](12-use-cases.md#uc-runstats-initial)
6. **REBIND APREUSE で旧 access path 維持か新採用か検討**

#### Phase 3: バッファプール・I/O 観察
7. **BP hit ratio チェック** → [uc-bufferpool-monitor](12-use-cases.md#uc-bufferpool-monitor)
8. **設定変更で再観察** → [cfg-bufferpool-tune](08-config-procedures.md#cfg-bufferpool-tune)

#### Phase 4: REORG / 索引追加
9. **対象 TS の REORG 必要性判定** → [uc-reorg-tablespace](12-use-cases.md#uc-reorg-tablespace)
10. **足りない索引の追加** → [uc-index-create](12-use-cases.md#uc-index-create)

#### Phase 5: ロック粒度・isolation 見直し
11. **LOCKSIZE / ISOLATION 見直し** → [cfg-bind-package](08-config-procedures.md#cfg-bind-package)

### ポイント

性能問題は単一原因のことは少ない。EXPLAIN → RUNSTATS → BP → Lock → 索引 → REORG の順に当たることで切り分け効率が上がる。

---

## 本記事の範囲

**本記事の範囲**: Db2 内部に起因する性能ボトルネック（access path、BP、lock、I/O）の切り分け。アプリ側のロジック改善（不要 SQL 削減等）、ハードウェア（DASD response time、CF link 帯域）、z/OS 側の WLM 調整は範囲外。

経験ある SME（パフォーマンスエンジニア）または IBM サポートと連携することを推奨。

---

## 災害復旧（DR）演習・準備 { #scn-disaster-recovery }

**概要**: image copy + archive log での RECOVER、DR サイトでの起動手順。

### シナリオの状況

四半期 DR 演習で、DR サイトの z/OS 上に primary site の Db2 サブシステムを最新時点で復元する。primary は健全、DR 側はクリーン環境。

### 推奨フロー

#### Phase 1: 事前準備（primary site）
1. **直近 image copy 取得** → [uc-imagecopy-full](12-use-cases.md#uc-imagecopy-full)
2. **catalog / directory image copy 取得** → [uc-imagecopy-full](12-use-cases.md#uc-imagecopy-full)
3. **BSDS / archive log の保管・転送** → [uc-bsds-create](12-use-cases.md#uc-bsds-create)

#### Phase 2: DR サイト準備
4. **DR 側 z/OS の Db2 SDSNSAMP 配置**
5. **DR 側 BSDS / DSNZPARM 準備**
6. **PROCLIB の DB2MSTR / DBM1 / DDF / IRLM 配置**

#### Phase 3: catalog / directory 復元
7. **catalog (DSNDB06) RECOVER** → [uc-tablespace-recover](12-use-cases.md#uc-tablespace-recover)
8. **directory (DSNDB01) RECOVER** → [uc-tablespace-recover](12-use-cases.md#uc-tablespace-recover)

#### Phase 4: 業務 TS 復元
9. **業務 TS 群を時点指定 RECOVER** → [uc-tablespace-recover](12-use-cases.md#uc-tablespace-recover)
10. **REBUILD INDEX / CHECK DATA**

#### Phase 5: 起動・検証
11. **Db2 起動** → [uc-db2-startup](12-use-cases.md#uc-db2-startup)
12. **検証 SQL** → [uc-display-status-check](12-use-cases.md#uc-display-status-check)

### ポイント

DR 演習では `RECOVER TOLOGPOINT` の点指定が肝。primary 側の最新 archive log と LRSN（data sharing は LRSN、non-DS は RBA）を演習開始時刻と整合させる。

---

## 本記事の範囲

**本記事の範囲**: Db2 サブシステム単体の DR 復元手順。GDPS HyperSwap / Q Replication / IBM Spectrum Protect Snapshot との連携、z/OS GDPS 全体構成、ネットワーク・SAN 切替は本記事の対象外（別 Redbook + プロジェクト個別設計）。

DR 演習は組織のリスクマネジメント部門と連携した上で実施。リアルタイム同期（CDC / Q Repl）は専門領域、IBM サポートと相談を推奨。

---

## セキュリティ監査要求への対応 { #scn-security-audit }

**概要**: SOX / GDPR / 個人情報保護等の監査で「誰が何にアクセスしたか」を回答する仕組みを整える。

### シナリオの状況

監査チームから「過去 90 日間、機密表 PRODSCH.PERSONAL に対する SELECT/UPDATE 履歴を user 単位で出して」との要求。

### 推奨フロー

#### Phase 1: 認可棚卸し
1. **GRANT 状況の棚卸し** → [uc-grant-roles](12-use-cases.md#uc-grant-roles)
2. **RACF Access Control Module 状況確認** → [uc-racf-acm-link](12-use-cases.md#uc-racf-acm-link)

#### Phase 2: AUDIT TRACE
3. **対象表に AUDIT 句設定** → [uc-audit-trace-start](12-use-cases.md#uc-audit-trace-start)
4. **AUDIT TRACE 起動・SMF type 102 記録** → [uc-audit-trace-start](12-use-cases.md#uc-audit-trace-start)

#### Phase 3: 集計
5. **SMF 102 を IFASMFDP で抽出**
6. **専用 reporting tool（IBM OMEGAMON / Db2 Audit Analyzer 等）で集計**
7. **CSV / レポート形式で監査チームに提出**

#### Phase 4: 継続運用
8. **AUDIT TRACE を恒久化（SMF 設定永続化）**
9. **RCAC（行・列レベル制御）導入で「見せる範囲」も制御**

### ポイント

CLASS 4（DML on AUDIT 対象表）は対象表に `AUDIT CHANGES` または `AUDIT ALL` 句が必要。CLASS 1（AUTHFAIL）/ CLASS 2（GRANT/REVOKE）/ CLASS 3（DDL）/ CLASS 5（BIND）は Db2 全体に効く。

---

## 本記事の範囲

**本記事の範囲**: Db2 内 AUDIT 機能と SMF 102 を使った監査ログ収集。レポーティングツール（OMEGAMON, Db2 Audit Analyzer, Splunk 等）の選定・構築は対象外。社内ポリシー・法規制に基づく具体的監査要件はコンプライアンス担当と協議推奨。

---

## Db2 12 → 13 のバージョン移行 { #scn-version-migration }

**概要**: Function Level / APPLCOMPAT の段階適用と回帰テスト。

### シナリオの状況

Db2 12（FL510 等）で稼働中のサブシステムを Db2 13 に移行。Continuous Delivery のため、まず V13R1M500 まで上げて、その後 FL501 + APPLCOMPAT 切替を計画的に実施。

### 推奨フロー

#### Phase 1: 事前準備
1. **Db2 12 側で M510 に到達済みであることを確認**
2. **prerequisite（z/OS, RACF, 関連 product）の整合確認** → [uc-installation-prereq](12-use-cases.md#uc-installation-prereq)
3. **直近 image copy 取得（catalog 含む）**

#### Phase 2: SMP/E APPLY
4. **Db2 13 の RECEIVE / APPLY / ACCEPT** → [uc-installation-prereq](12-use-cases.md#uc-installation-prereq)
5. **DSN.V13R1.* dataset 配置**

#### Phase 3: catalog upgrade
6. **CATMAINT で V13R1M500 へ upgrade** → [uc-functionlevel-activate](12-use-cases.md#uc-functionlevel-activate)
7. **`-DISPLAY GROUP DETAIL` で CATALOG LEVEL 確認**

#### Phase 4: Function Level activation
8. **`-ACTIVATE FUNCTION LEVEL(V13R1M500)`** → [uc-functionlevel-activate](12-use-cases.md#uc-functionlevel-activate)
9. **回帰テスト**
10. **APPLCOMPAT を REBIND で V13R1 に上げる** → [uc-applcompat-update](12-use-cases.md#uc-applcompat-update)

#### Phase 5: FL501+ への進展
11. **FL501 activate（SQL Data Insights 含む）** → [uc-functionlevel-activate](12-use-cases.md#uc-functionlevel-activate)
12. **必要なら SQL DI 学習** → [uc-sqldi-model-train](12-use-cases.md#uc-sqldi-model-train)

### ポイント

FL500 activation 後は Db2 12 への fallback 不可。activation 前に必ず image copy / DR 計画を確認。`-DISPLAY GROUP DETAIL` の `HIGHEST POSSIBLE FUNCTION LEVEL` で次の到達可能 FL を把握。

---

## 本記事の範囲

**本記事の範囲**: Db2 12 → 13 のサブシステム単体の移行（Function Level / APPLCOMPAT）。アプリ側の SQL 互換性チェック（v11 → v13 で deprecated 構文の検出）、データ共用グループ全体の rolling migration（複数メンバ間で同期）、IDAA 等の連携製品の同時移行は対象外。

移行計画は組織のチェンジマネジメントプロセスと、IBM Migration Guide（[S_DB2_Migrate12to13](07-sources.md)）参照を推奨。

---

## データ共用環境の拡張（メンバ追加） { #scn-datasharing-add }

**概要**: 既存 Sysplex Group に新メンバ追加で水平拡張。

### シナリオの状況

データ共用グループ DSNGRP01 に DB2A / DB2B の 2 メンバが稼働中。負荷増加を見越して 3 番目のメンバ DB2C を新 LPAR (SY03) に追加。

### 推奨フロー

#### Phase 1: 計画・前提
1. **CFRM policy で GBP / SCA / LOCK1 の容量増を計画** → [uc-cfrm-policy-update](12-use-cases.md#uc-cfrm-policy-update)
2. **新 LPAR の z/OS / Sysplex 参加確認**
3. **新メンバ用 SDSNSAMP / DSNZPARM 準備** → [uc-dsnzparm-edit](12-use-cases.md#uc-dsnzparm-edit)

#### Phase 2: グループ参加
4. **CFRM policy 活性化** → [uc-cfrm-policy-update](12-use-cases.md#uc-cfrm-policy-update)
5. **新メンバ DSNTIJUZ → DSNTIJIN** → [cfg-datasharing-add-member](08-config-procedures.md#cfg-datasharing-add-member)
6. **新メンバ -START DB2** → [uc-db2-startup](12-use-cases.md#uc-db2-startup)

#### Phase 3: 検証
7. **`-DISPLAY GROUP DETAIL` で 3 メンバ ACTIVE 確認**
8. **`-DISPLAY GROUPBUFFERPOOL` で GBP 接続確認**
9. **負荷テスト → CF lock contention・GBP castout 監視**

### ポイント

データ共用 group への新メンバ追加は「停止なし」で可能（既存 2 メンバはそのまま、3 番目だけ新規 IPL）。CFRM policy の変更による既存 GBP の構造拡張は短時間ロックを伴うため業務時間外推奨。

---

## 本記事の範囲

**本記事の範囲**: 既存 Sysplex / データ共用グループへの単純なメンバ追加。新規データ共用グループの構築（最初の 2 メンバ）、CF 物理機器の増設、GDPS と連携した cross-site データ共用は対象外。

CFRM policy 変更や CF link 増設は z/OS Sysplex Programmer と協業推奨。
