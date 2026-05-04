# 本サイトの対象外項目

本サイトでは、Db2 13 for z/OS の DBA / オペレータ / アプリ開発者が日常的に使う **定番のみ** を掲載しています。以下は意図的に除外しています。

## 章別サマリ

| 章 | 掲載 vs 除外 |
|---|---|
| コマンド | 本サイト掲載: 47 コマンド / 除外: 多数（Db2 には数百のコマンド + サブコマンドあり） |
| 設定値 | 本サイト掲載: DSNZPARM 6 マクロ + tunable 21 件 / 除外: 数百（DSN6SYSP 単独でも 100+ パラメータ） |
| 用語 | 本サイト掲載: 80 件 / 除外: 多数 |
| ユースケース | 本サイト掲載: 30 ユースケース（12-use-cases.md）+ 6 シナリオ別ガイド（11-scenarios.md）/ 除外: 多数 |

---

## コマンド

本サイト掲載: 47 コマンド / 除外: 多数（Db2 には数百のコマンド + サブコマンドあり）

### Performance / Trace 系コマンド

- **概数**: 30+ コマンド
- **理由**: 性能トレース・診断は専門領域、別 Redbook で扱う
- **参照先**: [Managing Performance](https://www.ibm.com/docs/en/db2-for-zos/13?topic=managing-performance)

**代表例**: `-START TRACE` / `-STOP TRACE` / `-DISPLAY TRACE` / `-MODIFY TRACE` / `-START STATISTICS` / OMEGAMON / Db2 Performance Monitor

### Admin Tool / GUI 系

- **概数**: 多数（IBM Db2 Admin Tool / Db2 Object Comparison Tool 等）
- **理由**: 各 GUI ツール固有のコマンドは個別ツールの専門書を参照
- **参照先**: 各 ツール の公式 docs

### `DSN1` 系（オフライン診断）

- **概数**: 10+ コマンド
- **理由**: hangover / dump 解析専門領域
- **参照先**: [Diagnostic techniques](https://www.ibm.com/docs/en/db2-for-zos/13?topic=diagnostic-techniques-tools)

**代表例**: `DSN1COPY` / `DSN1PRNT` / `DSN1LOGP` / `DSN1CHKR` / `DSN1COMP` / `DSN1SDMP`

### CICS / IMS attach 系コマンド

- **概数**: CICS DSNC コマンド・IMS DSNJ コマンド多数
- **理由**: CICS / IMS との連携部分は本サイトの範囲外
- **参照先**: CICS TS / IMS のサイト

---

## 設定値

本サイト掲載: DSNZPARM 6 マクロ + tunable 21 件 / 除外: 数百

### DSN6SYSP の網羅的パラメータ

- **概数**: 100+ パラメータ
- **理由**: 全パラメータは IBM 公式 reference を参照すれば足りる、本サイトでは中核のみ
- **参照先**: [Subsystem parameters reference](https://www.ibm.com/docs/en/db2-for-zos/13?topic=installing-subsystem-parameters)

**除外例**: `OPTIOWGT` / `OPT1ROWBLOCKSORT` / `OPTHIDX` / `OPTHJOIN` / `OPTIXOR` / `OPTOLAP` / その他 OPTxxxx 系（optimizer hint 系、80+ 個）

### Buffer Pool 個別チューナブル

- **概数**: BP60 個 × 各 5+ パラメータ
- **理由**: BP の個別 sizing は業務要件依存、本サイトでは方法論のみ
- **参照先**: [cfg-bufferpool-tune](08-config-procedures.md#cfg-bufferpool-tune)

### Trace / Statistics class 別パラメータ

- **概数**: CLASS 1〜31、IFCID 数百
- **理由**: Trace/Statistics は問題判別時の専門領域
- **参照先**: [Trace Reference (Db2 docs)](https://www.ibm.com/docs/en/db2-for-zos/13?topic=trace-reference)

---

## 用語

本サイト掲載: 80 件 / 除外: 多数

### Optimizer 内部用語

- **概数**: 100+
- **理由**: 内部実装の詳細はチューニング時のみ必要、本サイトは運用視点
- **参照先**: [Performance Topics Redbook](https://www.redbooks.ibm.com/abstracts/sg248525.html)

**除外例**: Hash join inner table size、Index manager prefetch quantum、Optimizer cost model、Profile feedback loop

### Internal control block / IFCID

- **概数**: 数百
- **理由**: SVC dump 解析・IBM サポート対応領域
- **参照先**: Diagnosis Reference

---

## ユースケース

本サイト掲載: **30 ユースケース（12-use-cases.md）+ 6 シナリオ別ガイド（11-scenarios.md）** / 除外: 多数

### 廃止予定機能の利用

- **理由**: stable な v13 機能のみ掲載、廃止予定機能は新規 UC 採用しない
- **除外例**: Simple tablespace の作成、PLAN (DBRM 直接) の BIND（v8 以降 PACKAGE 経由が主流）、SQLCA で SQLCODE 解釈する古い C/COBOL 慣行

### 高度な性能チューニング

- **理由**: 性能チューニングは個別案件性が強く、汎用 UC 化が困難
- **除外例**: Optimizer Profile feedback loop、Multi-row INSERT/FETCH の高度活用、外部 SORT との連携、HASH/MERGE join の hint 制御

### 統合製品との連携 UC

- **理由**: Db2 単体外の連携は別製品サイトで扱う
- **除外例**: Db2 + CICS（IMS）の attach パターン、Db2 + IDAA（Analytics Accelerator）連携、Db2 + Spectrum Protect バックアップ、Db2 + Q Replication CDC

### 開発系・SDK 系 UC

- **理由**: アプリ開発者向け SDK は本サイトの範囲外（運用に振った構成）
- **除外例**: REST Service の create / call、Java JCC driver チューニング、ODBC connection pool 設計、Native SQL Stored Procedure 開発手順

---

## 注意事項

掲載 UC / シナリオは「Db2 DBA / オペレータの定番運用」の範囲に集中。これに該当しないものは除外しています。

**カテゴリ別カバレッジ**（本サイト掲載 UC 30 + シナリオ 6）:

- DSNZPARM / 起動停止: UC 4
- バッファプール / 性能: UC 4
- ログ / アーカイブ: UC 3
- DDF / 分散: UC 3
- データ共用: UC 2
- バインド: UC 3
- ユーティリティ（COPY/LOAD/REORG/RUNSTATS/RECOVER）: UC 6
- セキュリティ: UC 3
- スキーマ / オブジェクト: UC 2

シナリオは: 新規導入 / 性能 / DR / セキュリティ監査 / 移行 / データ共用追加 の 6 本。
