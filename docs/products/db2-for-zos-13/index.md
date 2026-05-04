# Db2 13 for z/OS

> IBM メインフレーム向けエンタープライズ RDBMS。**13 章構成** で staple なコマンド・設定・用語・手順 + シナリオ別ガイド + ユースケース集を整理。**v1.1（v13.1 Function Level 500/501/510/513、Continuous Delivery 体系）に対応**。

**カテゴリ**: z/OS 系 / リレーショナル DB

## 構成（13 章）

| セクション | 内容 |
|---|---|
| **01. 製品概要** | 製品の役割（本ページ下部） |
| [02. コマンド一覧](01-commands.md) | DB2 オペレータコマンド/DSN サブコマンド/DSNUTILB ユーティリティ/SQL 運用クエリ **47 件** |
| [03. 設定値一覧](02-settings.md) | DSNZPARM マクロメンバ **6 種 + tunable 21 件**（DSN6SYSP/DSN6SPRM/DSN6FAC/DSN6LOGP/DSN6ARVP/DSN6GRP） |
| [04. 用語集](03-glossary.md) | Db2 z/OS 固有 **80 件**（Catalog/Buffer Pool/Lock/Log/Utility/DDF/Data Sharing） |
| [05. プレイブック](04-playbook.md) | 8 シーン × 3 習熟度 = **24 セル** |
| [06. トラブル早見表](05-troubleshooting.md) | SQLCODE / SQLSTATE 由来の症状 **20 件** |
| [07. マニュアル参照マップ](06-manual-map.md) | **22 テーマ** |
| [08. 出典一覧](07-sources.md) | **40 件**（公式 22 + Redbook 10 + 補完 z/OS 8） |
| [09. 設定手順](08-config-procedures.md) | **18 件** + S 級は実機期待出力サンプル付き |
| [10. 障害対応手順](09-incident-procedures.md) | **18 件** + S 級は A/B/C 仮説分岐付き |
| [11. 対象外項目](10-out-of-scope.md) | カテゴリ別整合（33 ユースケース + 6 シナリオに対応） |
| [12. シナリオ別ガイド](11-scenarios.md) | **6 本**（新規導入・性能・DR・セキュリティ監査・移行・データ共用追加） |
| [13. ユースケース集](12-use-cases.md) | **33 件**（独立タスク粒度、カテゴリ別に分類） |

各章の関連エントリには、設定手順 / 障害対応手順 / 用語 / ユースケースへの双方向リンクを付与。

---

## 01. 製品概要

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM Db2 13 for z/OS | S_DB2_Intro |
| 最新バージョン | Db2 13 for z/OS（V13R1、2022-05 GA、Continuous Delivery で Function Level を順次拡張） | S_DB2_WhatsNew |
| 対応 HW / OS | z14 以降推奨 / z/OS 2.4 以降（V13R1 移行先で必須） | S_DB2_Install |
| 想定読者 | Db2 DBA、システムプログラマ、アプリ開発者（バインド・SQL チューニング担当）、運用者 | S_DB2_Admin |
| 主要アドレス空間 | DB2MSTR（マスタ）/ DB2DBM1（DB マネージャ）/ DB2DIST（DDF）/ DB2SPAS（WLM 起動 SP）/ IRLM（ロックマネージャ） | S_DB2_Admin |
| 主要オブジェクト | Catalog（DSNDB06）/ Directory（DSNDB01）/ Buffer Pool（BP0–BP49 ほか）/ Tablespace / Indexspace / Plan / Package / Schema / Stogroup | S_DB2_SQLRef |
| 主要 Function Level | FL500（V13R1 Initial）→ FL501（SQL Data Insights）→ FL510 → **FL513（最新 FL、2025 公開）** | S_DB2_FuncLevels |
| 補助 Redbook | Db2 13 for z/OS and More（SG24-8527）、Performance Topics（SG24-8525）他 | S_DB2_RB_Db213More |

!!! note "v13 主要新機能（v12 → v13 のうち本サイト範囲）"
    1. **SQL Data Insights（SQL DI / FL501）** — 表データに対する AI 支援セマンティック検索（`AI_SIMILARITY` / `AI_SEMANTIC_CLUSTER` / `AI_ANALOGY`）。FL501 適用とモデル学習が必要。
    2. **Continuous Availability の強化** — Online schema change の対象拡張、UTS partition by range の online conversion、データ共用の retained-lock 削減。
    3. **Function Level の継続拡張（Continuous Delivery）** — Db2 v10 以降の `APPLCOMPAT`（アプリケーション互換レベル）と並行で、サブシステム機能を `FL` 単位で段階適用。`-ACTIVATE FUNCTION LEVEL` コマンドで切替。
    4. **lock 性能改善** — Lock avoidance / Insert algorithm 2 の既定化（v12 から継承）、retained lock 短期化。
    5. **utility 強化** — `REORG TABLESPACE SHRLEVEL CHANGE` の改善、`MERGECOPY` 自動化、新 `CATMAINT` フローによる移行簡易化。
    6. **Function Level 513（最新 FL）** — Continuous Delivery で順次拡張された FL510/FL511/FL512 を経て、**FL513** が最新の到達点。`-DISPLAY GROUP DETAIL` の `HIGHEST POSSIBLE FUNCTION LEVEL` で V13R1M513 が表示される環境では `-ACTIVATE FUNCTION LEVEL(V13R1M513)` で有効化できる（前提として CATMAINT による Catalog Level 引き上げ + 直前 FL の activate 完了）。FL513 で追加された個別機能は IBM 公式 Function Level Summary（[S_DB2_FuncLevels](07-sources.md)）参照。

!!! warning "AI 生成と人手の併用"
    本ページは公式マニュアル等の公開情報のみを根拠に整理した二次資料。AI 生成と人手の併用で作成しているため、情報の正確性は保証しない。実装・適用前には公式情報での再確認を推奨。

!!! info "v1 の図表方針"
    本サイト v1 は「テキスト網羅優先」で、Redbook 由来の図表埋込は v2 以降に拡張する方針。各章の章末注に出典 Redbook ID を記載しているため、必要に応じて元 Redbook（リンクは [08. 出典一覧](07-sources.md) 参照）の図を直接参照可能。
