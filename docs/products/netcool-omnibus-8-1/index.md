# Netcool/OMNIbus 8.1

!!! info "本ページの位置付け / 関連ページ"
    本ページは **IBM Tivoli Netcool/OMNIbus 8.1 公式マニュアル系の運用リファレンス**（13 章）。日々の運用で「どの nco_* コマンドを叩くか」「どの ObjectServer プロパティを変えるか」「Probe / Gateway / Aggregation 障害時の切り分け」を引く用途に最適化。

    Netcool 関連の他資料：
    - **[Netcool/OMNIbus V8.1（旧 7 シート）](../netcool-omnibus/)** — ChromaDB 投入済みドキュメントから抽出した俯瞰サマリ（7 シート）。本ページの前身、概要把握用。
    - 本ページは旧 7 シート版の上位互換（13 章 + S 級 A/B/C 仮説分岐 + 期待出力サンプル）。

> IBM Netcool ファミリの中核を成すイベント管理・統合監視製品。ObjectServer（インメモリ DB）に Probe からのアラートを集約し、deduplication・自動相関・通知・Web GUI 可視化までを行う。**13 章構成** で staple な nco_* コマンド・ObjectServer プロパティ・用語・手順 + シナリオ別ガイド + ユースケース集を整理。**v1（OMNIbus 8.1.0/8.1.x、Best Practices Guide v1.3 ベース）に対応**。

**カテゴリ**: 監視・ジョブ運用 系 / イベント統合管理基盤

## 構成（13 章）

| セクション | 内容 |
|---|---|
| **01. 製品概要** | 製品の役割（本ページ下部） |
| [02. コマンド一覧](01-commands.md) | nco_* / SQL / Probe / Gateway / Process Agent / WAAPI **45 件** |
| [03. 設定値一覧](02-settings.md) | ObjectServer プロパティ **18 件** + Probe / Gateway / Process Agent / Web GUI **20 件** |
| [04. 用語集](03-glossary.md) | OMNIbus 固有 **78 件**（ObjectServer / Probe / Gateway / SMAC / IDUC / AEN / FIPS 等） |
| [05. プレイブック](04-playbook.md) | 7 シーン × 3 習熟度 = **21 セル** |
| [06. トラブル早見表](05-troubleshooting.md) | 症状起点の早見 **20 件** |
| [07. マニュアル参照マップ](06-manual-map.md) | **22 テーマ** |
| [08. 出典一覧](07-sources.md) | **40 件**（公式 25 + Best Practices Guide v1.3 + Redpaper + 補完 z/OS / 連携製品 14） |
| [09. 設定手順](08-config-procedures.md) | **18 件** + S 級は実機期待出力サンプル付き |
| [10. 障害対応手順](09-incident-procedures.md) | **18 件** + S 級は A/B/C 仮説分岐付き |
| [11. 対象外項目](10-out-of-scope.md) | カテゴリ別整合（30 ユースケース + 6 シナリオに対応） |
| [12. シナリオ別ガイド](11-scenarios.md) | **6 本**（新規構築 / SMAC 構築 / failover 整備 / 性能チューニング / EIF 連携 / DR） |
| [13. ユースケース集](12-use-cases.md) | **30 件**（独立タスク粒度） |

各章の関連エントリには、設定手順 / 障害対応手順 / 用語 / ユースケースへの双方向リンクを付与。

---

## 01. 製品概要

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM Tivoli Netcool/OMNIbus 8.1 | S_OMN_BP, S_OMN_QSG |
| 最新バージョン | OMNIbus 8.1.0 / 8.1.x（Best Practices Guide v1.3 / 2024 改訂対応） | S_OMN_BP |
| ベンダ | IBM Corporation | S_OMN_QSG |
| 対応 OS | AIX、Linux on x86_64 / s390x / ppc64le、Solaris、Windows Server（Probe / Gateway 個別に対応 OS あり） | S_OMN_QSG |
| 想定読者 | Netcool/OMNIbus 管理者、運用設計者、Probe / Gateway 開発者、Web GUI 管理者、SRE / 監視チーム | S_OMN_BP, S_OMN_WAAPI |
| 中核アーキテクチャ | ObjectServer（インメモリ DB）+ Probe（イベント取込）+ Gateway（複製/連携）+ Process Agent（nco_pad）+ Web GUI（Jazz/DASH 上）+ Proxy Server。多段化（**SMAC** = Standard Multitier Architecture Configuration）として **Collection / Aggregation / Display** ObjectServer の 3 層構成が公式推奨 | S_OMN_BP |
| 主要イベントテーブル | alerts.status（イベント本体）/ alerts.details（詳細属性 KV ペア）/ alerts.journal（オペレータ追記） | S_OMN_BP, S_OMN_WAAPI |
| 主要環境変数 | $NCHOME（製品ルート、UNIX 例 /opt/IBM/tivoli/netcool）/ $OMNIHOME（OMNIbus サブディレクトリ） | S_OMN_BP |
| 通信ポート（既定） | ObjectServer ポート（NCOMS = 4100、QuickStart 例で 9000 / 8002）、Iduc.ListeningPort で IDUC 通信ポート設定 | S_OMN_QSG, S_OMN_BP |
| 管理 GUI | Netcool/OMNIbus Administrator（Java デスクトップ GUI）+ Web GUI（DASH 上、AEL/Event Viewer/Gauges 提供） | S_OMN_BP, S_OMN_WAAPI |
| 管理 CLI / API | nco_sql（SQL interactive interface）、WAAPI（runwaapi コマンド + XML）、ObjectServer HTTP Interface（NHttpd） | S_OMN_WAAPI, S_OMN_BP |
| セキュリティ | ユーザ / グループ / ロール（CatalogUser / AlertsUser / AlertsProbe / RegisterProbe / ChannelUser）、SSL/TLS、FIPS 140-2、SecureMode、LDAP、監査 | S_OMN_BP |
| 高可用性 | Backup ObjectServer + bidirectional ObjectServer Gateway（AGG_GATE）による fail-over、SMAC の Aggregation 層で冗長化、controlled failback による段階的再同期 | S_OMN_BP |
| EIF 連携 | Tivoli EIF プロトコルで多製品（IBM Tivoli Monitoring 等）からイベントを受信。Probe for Tivoli EIF（nco_p_tivoli_eif）+ eif_default.rules / tivoli_eif.rules | S_OMN_EIF, S_OMN_ITM |
| ドキュメント形態 | IBM Documentation（旧 Knowledge Center、OMNIbus 8.1.0）+ Best Practices Guide v1.3（PDF 198p） | S_OMN_BP |
| 関連製品（密結合） | Netcool/Impact、IBM Tivoli Monitoring（TEMS）、Tivoli Enterprise Portal、Jazz for Service Management / DASH、WebSphere Application Server、Netcool MIB Manager、IBM Operations Analytics - Log Analysis（SCALA）、Netcool Operations Insight（NOI）Event Analytics | S_OMN_BP, S_OMN_ITM |

!!! note "v1 の特徴"
    **z/OS 3.1 v4 / Db2 13 v1 と同一の 13 章フレームワーク** で書き起こした初版。本サイトの旧 7 シート版（[../netcool-omnibus/](../netcool-omnibus/)）が概要俯瞰で停まっていた領域を、**S 級 18 件の設定手順 + S 級 18 件の障害対応 + 30 件の独立ユースケース** で深掘り。Best Practices Guide v1.3（IBM 公式 PDF）からの引用根拠が中心、`alert.status` / IDUC / AEN / SMAC / controlled failback / accelerated_inserts / generic_clear / hk_set_expiretime / hk_de_escalate_events 等の運用メカニズム解説に重点。

!!! warning "AI 生成と人手の併用"
    本ページは公式マニュアル等の公開情報のみを根拠に整理した二次資料。AI 生成と人手の併用で作成しているため、情報の正確性は保証しない。実装・適用前には公式情報での再確認を推奨。

!!! info "v1 の図表方針"
    本サイト v1 は「テキスト網羅優先」で、Best Practices Guide / Redbook 由来の図表埋込は v2 以降に拡張する方針。各章の章末注に出典 ID を記載しているため、必要に応じて元 PDF（リンクは [08. 出典一覧](07-sources.md) 参照）の図を直接参照可能。

---

## 用途別の入り口

- **「これから新規に Netcool を構築したい」** → [11. シナリオ別ガイド > scn-new-deployment](11-scenarios.md#scn-new-deployment)
- **「SMAC を組みたい / Collection・Aggregation・Display を分けたい」** → [11. シナリオ別ガイド > scn-smac-build](11-scenarios.md#scn-smac-build) + [08. cfg-smac-aggregation](08-config-procedures.md#cfg-smac-aggregation)
- **「failover を組みたい」** → [08. cfg-failover-pair](08-config-procedures.md#cfg-failover-pair) + [11. scn-failover-build](11-scenarios.md#scn-failover-build)
- **「ObjectServer が遅い・落ちた・肥大化した」** → [09. inc-objserv-hang](09-incident-procedures.md#inc-objserv-hang) / [09. inc-alerts-status-bloat](09-incident-procedures.md#inc-alerts-status-bloat)
- **「Probe が ObjectServer に接続しない」** → [09. inc-probe-conn-fail](09-incident-procedures.md#inc-probe-conn-fail)
- **「Web GUI でイベントが流れてこない」** → [09. inc-iduc-stuck](09-incident-procedures.md#inc-iduc-stuck)
- **「特定の単発タスクだけやりたい（拾い読み）」** → [13. ユースケース集](12-use-cases.md)

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
