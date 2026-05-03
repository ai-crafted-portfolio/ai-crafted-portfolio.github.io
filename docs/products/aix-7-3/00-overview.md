# AIX 7.3 — 概要

AIX 7.3 — 製品概要

本シートは ChromaDB 投入済みの AIX 7.3 マニュアル（17,443 chunks / 75 sources） から構造化抽出した製品サマリ。各記述末尾の [SX] は出典 ID（06_出典一覧 を参照）。

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM AIX 7.3 (Standard Edition, Technology Level 3)  [S30, S35] | S30, S35 |
| ベンダ | IBM Corporation  [S35] | S35 |
| 最新バージョン | AIX 7.3.3 / TL3 SP1（2025年12月時点のドキュメント反映）  [S34, S35] | S34, S35 |
| 対応アーキテクチャ | 64-bit Common Hardware Reference Platform (CHRP) — POWER8/POWER9/Power10/Power11 (POWER8 互換以降のモード必須)  [S35] | S35 |
| 最小メモリ要件 | 2 GB（最大メモリ構成・デバイス数に応じて要増加）  [S35] | S35 |
| 最小ディスク要件 | 20 GB（既定インストール = devices + Graphics + System Management Client bundle）  [S35] | S35 |
| ブートLV最小サイズ | hd5 = 40 MB（ディスク先頭 4GB 以内に連続パーティションで配置）  [S35] | S35 |
| 製品の役割 | IBM Power Systems 上で稼働する 64-bit エンタープライズ UNIX オペレーティングシステム。 POWER ハードウェアの仮想化（LPAR/DLPAR/WPAR）、論理ボリュームマネージャ（LVM/JFS2）、 セキュリティ（RBAC、暗号化LV/PV、IPsec、PKS-based AIX Key Manager）、 高可用性（Cluster Aware AIX, RSCT 3.3.0.0、Live Kernel Update）を提供する。  [S35, S6, S75] | S35, S6, S75 |
| 想定読者 | AIX システム管理者、IBM Power サーバ運用者、UNIX 運用担当者、ミッションクリティカル業務基盤の運用設計担当者  [S24, S12, S22, S25, S32] | S24, S12, S22, S25, S32 |
| 典型的利用シーン | 基幹業務 OLTP（Db2 11.1 等）、エンタープライズ統合、PowerHA による HA クラスタ、 PowerVC によるクラウド配備、WPAR による OS レベル分離環境提供。  [S35, S6] | S35, S6 |
| 既定シェル | ksh (ksh88) — ksh93 (u+ 版)、bash (bash.rte) も TL3 で利用可  [S35] | S35 |
| 既定 Java | Java 8 64-bit (java8_64) — Java 6/7 は base media 不同梱  [S35] | S35 |
| 既定 Python | Python 3.9 (python3.9.base, 既定インストール) / 3.11 (python3.11.base, 任意)  [S35] | S35 |
| 既定パスワード Hash | SSHA-256（最大 255 文字、上書き/マイグレーションインストールのデフォルト）  [S35] | S35 |
| ドキュメント形態 | 公式 IBM Docs Web 49 トピック + PDF 63 ファイル（en/ja 両言語）。本 Excel では英語版を主たる出典として参照  [S34] | S34 |
| 関連製品（密結合） | PowerVM (HMC), PowerHA SystemMirror, RSCT 3.3.0.0, IBM Db2, IBM Security Verify Directory (旧 ISDS), Spectrum Scale (旧 GPFS), PowerVC  [S35, S6] | S35, S6 |

