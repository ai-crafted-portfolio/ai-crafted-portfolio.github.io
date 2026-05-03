# VIOS — 概要

VIOS — 製品概要

本シートは ChromaDB 投入済み VIOS マニュアル（339 chunks / 25 source_files、Web）から 構造化抽出した製品サマリ。出典は IBM Support の Fix Pack Release Notes・IBM Docs Power10 ナレッジセンター・PowerVM Community ブログから構成される（PDF は不在）。各記述末尾の [SX] は出典 ID（06_出典一覧 を参照）。

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM PowerVM Virtual I/O Server (VIOS) 4.1.x  [S7, S23] | S7, S23 |
| ベンダ | IBM Corporation  [S8] | S8 |
| 最新バージョン | VIOS 4.1.2.00（GA: 2025-12-12）。長期サポート系の前バージョンは 4.1.1.10 / 4.1.0.40 / 4.1.0.10。3.1.x 系は 2026-04-30 で Standard Support 終了。  [S6, S25, S20, S1] | S6, S25, S20, S1 |
| OS 基盤 | VIOS 4.1.x は AIX 7.3 (TL2) ベース。4.1.2.00 は AIX 7300-04、4.1.1.10 は AIX 7300-03-01、4.1.1.00 は AIX 7300-02-02、4.1.0.40 は AIX 7300-02-04。NIM Master の AIX レベルは VIOS の AIX レベル以上が必須。  [S23, S6, S5, S4, S3] | S23, S6, S5, S4, S3 |
| 対応ハードウェア | POWER8 / POWER9 / POWER10（4.1.0.40 まで）。VIOS 3.1.4.60+, 4.1.0.40+, 4.1.1.10+ は POWER9 以降必須。VIOS 4.1.2.00 は POWER11 / POWER10 / POWER9。  [S23, S18, S25] | S23, S18, S25 |
| VIOS の役割 | PowerVM Editions ハードウェア・フィーチャーの一部として、専用の論理区画 (LPAR) で稼働 するソフトウェア・アプライアンス。サーバー内のクライアント論理区画間で物理 I/O リソース (SCSI / Fibre Channel / Ethernet / 光ディスク) を仮想化・共用する。仮想 SCSI ターゲット、 仮想 Fibre Channel (NPIV)、共用イーサネット・アダプター (SEA)、共用ストレージ・プール (SSP)、 POWER8 では PowerVM Active Memory Sharing (AMS) を提供する。  [S7, S12] | S7, S12 |
| AMS の取扱い | PowerVM Active Memory Sharing (AMS) は POWER10 以降では非サポート、かつ VIOS 4.1 以降では VIOS 自身が AMS をサポートしない。VIOS 4.1.x へアップグレード前に AMS は un-configure 必須。  [S7, S6, S12] | S7, S6, S12 |
| 管理インターフェース | Hardware Management Console (HMC) と padmin ユーザでログインする VIOS コマンド行 (CLI)。HMC が無い POWER8 環境では Integrated Virtualization Manager (IVM) が VIOS 区画上で起動するが、IVM は POWER9 以降では非サポート。  [S8, S10, S13] | S8, S10, S13 |
| 想定読者 | PowerVM 仮想化基盤の設計・構築・運用担当、VIOS padmin 管理者、HMC オペレータ、Power Systems 上で AIX / IBM i / Linux on Power を運用する SIer / IT 部門。  [S8, S10] | S8, S10 |
| 典型的利用シーン | ハードウェア I/O スロットを上回る数の LPAR を 1 サーバ上で構築（vSCSI / NPIV / SEA で I/O を仮想化）、SSP による複数 VIOS のストレージ統合、PowerHA / Live Partition Mobility (LPM) の前提基盤、Db2 / Oracle / SAP の集約 OLTP 基盤の I/O 層。  [S7, S11, S10] | S7, S11, S10 |
| 推奨レベル | FLRT (Fix Level Recommendation Tool) for Power System で対象 Machine-Type-Model と現行 ioslevel を入力し『Recommended Update』または『Recommended Upgrade』を取得。FLRT 推奨レベルが直接適用可能とは限らないため、対象 Fix Pack Release Notes の前提条件確認が必須。  [S20] | S20 |
| ライフサイクル | VIOS 3.1.0 / 3.1.1 / 3.1.2 / 3.1.3 は End of Fix Support 到達済。VIOS 3.1.x 全体は 2026-04-30 で Standard Support 終了。Power10 で 4.1 を新規導入する場合は最新の Fix Pack を併せて適用することが推奨される。VIOS 4.1.0.10 は 2024-05 公開のメインライン、4.1.0.x 系統は POWER8 / POWER9 / POWER10 のみサポート（POWER7 以前で 4.1 適用すると Virtual Fibre Channel Config を失う既知不具合あり）。  [S20, S3, S1, S19] | S20, S3, S1, S19 |
| 管理 OS ユーザ | padmin（既定の管理ユーザ、ksh93 を既定シェルに使用）。RBAC 経由で root 系コマンドの実行が制限される。  [S23, S3] | S23, S3 |
| アップグレードツール | viosupgrade（3.1.x → 4.1.x のメジャー upgrade、alt_disk_mksysb 方式で free disk 上に新インストールし元 rootvg は無傷）、updateios（同一メジャー内の SP/Update、4.1.2.00 で -altdisk オプション追加）、viosbr（virtual I/O 構成のバックアップ/リストア）、alt_root_vg（複数フェーズ実行対応）。詳細手順は『viosupgrade Checklist』および『How to upgrade to VIOS 4.1.0.10 with IBM Storage』参照。  [S18, S6, S23, S19, S24] | S18, S6, S23, S19, S24 |
| Release Notes 構成 | Power10 Knowledge Center の VIOS Release Notes はベストプラクティス推奨、パッケージ用語、インストール前確認事項、Memory / ROOTVG 要件、各 VRMF のエンハンスメント、ソフトウェア更新、ライセンス契約、オンライン資料の各セクションで構成される。  [S9] | S9 |
| 関連製品（密結合） | PowerVM (HMC), AIX 7.3, IBM i, Linux on Power, PowerHA SystemMirror, PowerVC, FLRT, Fix Central, NIM, IBM Tivoli Monitoring (4.1.x で同梱廃止)  [S8, S23, S20] | S8, S23, S20 |

