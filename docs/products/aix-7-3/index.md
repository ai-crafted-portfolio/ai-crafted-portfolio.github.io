# AIX 7.3

> IBM Power 上の UNIX OS。AIX 7.3 のカーネル/ファイルシステム/ネットワーク/セキュリティ等を、コマンド/設定値/用語の3軸で網羅的に整理した二次資料。

**カテゴリ**: Power 系 / OS（UNIX）

## 構成（8 セクション構造 v2）

本製品ページは ChromaDB に投入済みの公式マニュアル（17,443 chunks / 75 sources）から構造化抽出した二次資料です。各記述末尾の `[SX]` 形式の出典 ID は [07. 出典一覧](07-sources.md) を参照してください。

| セクション | 内容 | 件数 |
|---|---|---|
| **01. 製品概要** | 製品の役割・想定ユーザ・他製品との位置付け（本ページ下部） | 17 項目 |
| [02. コマンド一覧](01-commands.md) | AIX 標準コマンドの構文・説明・例の網羅 | **348 件** |
| [03. 設定値一覧](02-settings.md) | ioo / no / schedo / vmo の tunable + /etc/* 設定ファイル | **167 件** |
| [04. 用語集](03-glossary.md) | AIX 固有概念（LPAR / VIOS / SMIT / ODM 等）+ 略号 | **168 件** |
| [05. タスクプレイブック](04-playbook.md) | 習熟度（入門/中級/上級）× シーン（構築/日常/BR/障害/性能/移行/監査/拡張）マトリクス | 22 セル |
| [06. トラブルシュート早見表](05-troubleshooting.md) | 症状/原因/対処の早見表 | 15 件 |
| [07. マニュアル参照マップ](06-manual-map.md) | テーマ別の公式マニュアル深掘り先 | 31 テーマ |
| [08. 出典一覧](07-sources.md) | 出典 ID（S1..S75）と公式マニュアル名の対応 | 75 source |

---

## section1: 製品概要

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM AIX 7.3 (Standard Edition, Technology Level 3) | S30, S35 |
| ベンダ | IBM Corporation | S35 |
| 最新バージョン | AIX 7.3.3 / TL3 SP1 | S34, S35 |
| 対応アーキテクチャ | 64-bit CHRP — POWER8 / POWER9 / Power10 / Power11（POWER8 互換以降のモード必須） | S35 |
| 最小メモリ要件 | 2 GB（最大メモリ構成・デバイス数に応じて要増加） | S35 |
| 最小ディスク要件 | 20 GB（既定 install = devices + Graphics + System Management Client bundle） | S35 |
| ブートLV最小サイズ | hd5 = 40 MB（ディスク先頭 4GB 以内に連続パーティションで配置） | S35 |
| 製品の役割 | IBM Power Systems 上で稼働する 64-bit エンタープライズ UNIX OS。POWER ハードウェアの仮想化（LPAR/DLPAR/WPAR）、論理ボリュームマネージャ（LVM/JFS2）、セキュリティ（RBAC・暗号化LV/PV・IPsec・PKS）、高可用性（CAA・RSCT・LKU/LLU）を提供する。 | S35, S6, S75 |
| 想定読者 | AIX システム管理者、IBM Power サーバ運用者、UNIX 運用担当者、ミッションクリティカル業務基盤の運用設計担当 | S24, S12, S22, S25, S32 |
| 他製品との位置付け | PowerVM（仮想化）の客 OS、PowerHA SystemMirror（HA）の基盤、CAA/RSCT 同梱、PowerVC で Cloud 配備対応。VIOS は AIX をベースとした I/O 仮想化専用 LPAR | S6, S35 |
| 既定シェル | ksh（ksh88） — ksh93（u+ 版）、bash（bash.rte）も TL3 で利用可 | S35 |
| 既定 Java | Java 8 64-bit（java8_64） — Java 6/7 は base media 不同梱 | S35 |
| 既定 Python | Python 3.9（python3.9.base, 既定インストール）/ 3.11（python3.11.base, 任意） | S35 |
| 既定パスワード Hash | SSHA-256（最大 255 文字、上書き/マイグレーションインストールのデフォルト） | S35 |
| OpenSSL/OpenSSH | OpenSSL 3.0.x（TL3 SP1 = 3.0.15.1001）、OpenSSH 9.7p1（GSSAPI Key Exchange パッチ済） | S35 |
| 網羅範囲（v2） | コマンド一覧 348件 / 設定値一覧 167件（tunable 108 + 設定ファイル 59）/ 用語集 168件 / 出典 75件 | S7, S8, S9 |
| ドキュメント形態 | 公式 IBM Docs Web 49 トピック + PDF 63 ファイル（en/ja 両言語）。本資料は英語版を主たる出典として参照 | S34 |

---

!!! note "利用上の注意"
    本ページは公式マニュアル等の公開情報のみを根拠に整理した二次資料です。AI 生成と人手の併用で作成しているため、情報の正確性は保証しません。実装・適用前には公式情報での再確認を推奨します。

## v2 構造化方針

v1 の 7 シート構成（概要/構成要素/主要設定項目/典型ユースケース/トラブル/関連製品/出典）から v2 では

- **コマンド一覧**（網羅）
- **設定値一覧**（網羅）
- **用語集**（網羅）
- **タスクプレイブック**（習熟度 × シーン マトリクス）

の 4 軸を必須化し、現場で「コマンド名で引く / 設定名で引く / 用語で引く」の 3 通りのアクセスパスを確保しました。
