# AIX 7.3

> IBM Power Systems 上のエンタープライズ UNIX OS。**v5 = 定番集中・透明スコープ + 各コマンド主要オプション説明** で完全リビルドした二次資料。

**カテゴリ**: Power 系 / OS（UNIX）

## v5 の改修（v4 → v5）

v4（定番集中）に加えて、**各 45 コマンドに主要オプション 5〜10 個の日本語説明**を追加（合計 325 オプション説明）。`errpt [-a] [-d ...]` のような構文を見ても何のオプションか分からなかった問題を解消。

## 構成（11 章）

| セクション | 内容 | 件数 |
|---|---|---|
| **01. 製品概要** | 製品の役割・想定ユーザ・他製品との位置付け（本ページ下部） | 18 項目 |
| [02. コマンド一覧](01-commands.md) | 各コマンドに**主要オプション説明付き** | **45 コマンド / 325 オプション** |
| [03. 設定値一覧](02-settings.md) | tunable と /etc/* 設定ファイル | **40 件**（tunable 20 + ファイル 20）|
| [04. 用語集](03-glossary.md) | AIX 固有概念 | **65 件** |
| [05. タスクプレイブック](04-playbook.md) | 習熟度 × シーン マトリクス | 22 セル |
| [06. トラブルシュート早見表](05-troubleshooting.md) | 症状/原因/対処の早見表 | **20 件** |
| [07. マニュアル参照マップ](06-manual-map.md) | テーマ別 IBM Docs 深掘り先（**全 URL 必須**） | 22 テーマ |
| [08. 出典一覧](07-sources.md) | 出典 ID と公式マニュアル名・URL | 40 件 |
| [09. 設定手順](08-config-procedures.md) | 重要度 S/A/B/C × 用途 | **18 手順** |
| [10. 障害対応手順](09-incident-procedures.md) | 重要度 S/A/B/C × 用途 | **18 手順** |
| **[11. 対象外項目](10-out-of-scope.md)** | 本サイトで意図的に除外した項目を全件・カテゴリ別に列挙 | 〜全件 |

各章で扱うコマンド・設定値・用語のエントリには、該当する **設定手順** / **障害対応手順** への双方向リンクを付与しています。

---

## 01. 製品概要

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM AIX 7.3 (Standard Edition) | S_AIX73_release_notes_734 |
| ベンダ | IBM Corporation | S_AIX73_release_notes_734 |
| 最新バージョン | **AIX 7.3.4 / TL4**（2025年12月リリース） | S_AIX73_release_notes_734 |
| 対応アーキテクチャ | 64-bit CHRP — POWER8 / POWER9 / Power10 / Power11（POWER8 互換以降のモード必須） | S_AIX73_release_notes_734 |
| 最小メモリ要件 | **4 GB**（Quick Installation Guide v7.3 記載） | S_AIX73_install_quick |
| 最小ディスク要件 | 20 GB（既定 install = devices + Graphics + System Management Client bundle） | S_AIX73_release_notes_734 |
| ブートLV最小サイズ | hd5 = 40 MB（ディスク先頭 4GB 内、連続パーティション） | S_AIX73_release_notes_734 |
| 製品の役割 | IBM Power Systems 上で稼働する 64-bit エンタープライズ UNIX OS。POWER ハードウェアの仮想化（LPAR/DLPAR/WPAR）、論理ボリュームマネージャ（LVM/JFS2）、セキュリティ（RBAC・暗号化LV/PV・IPsec・PKS）、高可用性（CAA・RSCT・LKU/LLU）を提供する。 | S_AIX73_release_notes_734 |
| 想定読者 | AIX システム管理者、IBM Power サーバ運用者、UNIX 運用担当者、ミッションクリティカル業務基盤の運用設計担当 | S_AIX73_osmanagement |
| 既定シェル | ksh（ksh88） — ksh93（u+ 版）、bash（bash.rte）も TL3 で利用可 | S_AIX73_release_notes_733 |
| 既定 Java | Java 8 64-bit（java8_64） — Java 6/7 は base media 不同梱 | S_AIX73_release_notes_733 |
| 既定 Python | Python 3.9（python3.9.base, 既定インストール）/ 3.11（python3.11.base, 任意） | S_AIX73_release_notes_733 |
| 既定パスワード Hash | SSHA-256（最大 255 文字） | S_AIX73_security |
| OpenSSL/OpenSSH | OpenSSL 3.0.x（TL3 SP1 = 3.0.15.1001、ビルド時は 3.0.13）、OpenSSH 9.7p1（GSSAPI Key Exchange パッチ済） | S_AIX73_release_notes_733 |
| 掲載コマンド | **45 件 / 325 オプション説明**（定番のみ、v5 で各コマンドに主要オプション追加） | — |
| 掲載設定値 | **40 件**（tunable 20 + 設定ファイル 20） | — |
| 掲載用語 | **65 件** | — |
| 掲載手順 | 設定 **18** / 障害対応 **18**（staple 15+ カバー） | — |

!!! note "v5 リビルドの理由"
    v4（定番集中・透明スコープ）の方針はそのまま維持し、v5 では「コマンドの構文を見てもオプションが何か分からない」という弱点を解消するため、各 45 コマンドに主要オプション 5〜10 個の日本語説明を追加（合計 325 説明）。除外項目は引き続き [10. 対象外項目](10-out-of-scope.md) で全件カテゴリ別に開示しています。

!!! warning "AI 生成と人手の併用"
    本ページは公式マニュアル等の公開情報のみを根拠に整理した二次資料です。AI 生成と人手の併用で作成しているため、情報の正確性は保証しません。実装・適用前には公式情報での再確認を推奨します。
