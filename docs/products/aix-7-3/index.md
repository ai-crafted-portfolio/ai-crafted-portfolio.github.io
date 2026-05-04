# AIX 7.3

> IBM Power Systems 上のエンタープライズ UNIX OS。**v9 = 用語リンク化 + プレイブック詳細化 + A級手順詳細化 + 公式図表埋め込み**

**カテゴリ**: Power 系 / OS（UNIX）

## v9 の改修

- **用語集の関連用語をクリック可能な内部リンクに変換**
- **プレイブック 22 セル全件を詳細化**（目的/前提/手順/検証/rollback 構造）
- **A 級手順を S 級と同じ詳細度に**（設定 5 + 障害 6 = 11 件）
- **AIX 公式マニュアル PDF から 100+ 図表を抽出、関連章に埋め込み**

## 構成（12 章）

| セクション | 内容 |
|---|---|
| **01. 製品概要** | 製品の役割・想定ユーザ（本ページ下部） |
| [02. コマンド一覧](01-commands.md) | **45 コマンド / 710 オプション** |
| [03. 設定値一覧](02-settings.md) | tunable 20 + 設定ファイル 20 |
| [04. 用語集](03-glossary.md) | **65 件**（v9 で関連用語リンク化） |
| [05. タスクプレイブック](04-playbook.md) | **22 セル**（v9 で詳細化、各 100-200 行） |
| [06. トラブルシュート早見表](05-troubleshooting.md) | 20 件 |
| [07. マニュアル参照マップ](06-manual-map.md) | 22 テーマ |
| [08. 出典一覧](07-sources.md) | 40 件 |
| [09. 設定手順](08-config-procedures.md) | **18 手順**（S 級 13 + A 級 5 が詳細版、v7+v9） |
| [10. 障害対応手順](09-incident-procedures.md) | **18 手順**（A 級 6 が詳細版、v9） |
| [11. 対象外項目](10-out-of-scope.md) | 〜全件 |
| [12. 特集記事](11-special-features.md) | 5 本 |

各章で扱うエントリには、該当する **設定手順** / **障害対応手順** / **用語** への双方向リンクを付与しています。
特集記事 / 詳細手順 / プレイブックには **AIX 公式マニュアルから抽出した図表** を埋め込んでいます。

---

## 01. 製品概要

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM AIX 7.3 (Standard Edition) | S_AIX73_release_notes_734 |
| 最新バージョン | **AIX 7.3.4 / TL4**（2025-12 リリース） | S_AIX73_release_notes_734 |
| 対応アーキテクチャ | 64-bit CHRP — POWER8 / POWER9 / Power10 / Power11 | S_AIX73_release_notes_734 |
| 最小メモリ | **4 GB**（Quick Installation Guide v7.3 記載） | S_AIX73_install_quick |
| 最小ディスク | 20 GB | S_AIX73_release_notes_734 |
| ブート LV | hd5 = 40 MB | S_AIX73_release_notes_734 |
| 製品の役割 | IBM Power Systems 上の 64-bit エンタープライズ UNIX OS | S_AIX73_release_notes_734 |
| 想定読者 | AIX システム管理者、IBM Power サーバ運用者 | S_AIX73_osmanagement |
| OpenSSL/OpenSSH | OpenSSL 3.0.x、OpenSSH 9.7p1 | S_AIX73_release_notes_733 |
| 掲載コマンド | **45 件 / 710 オプション** | — |
| 掲載設定値 | 40 件 | — |
| 掲載用語 | **65 件**（v9 で関連用語リンク化） | — |
| 掲載手順 | 設定 **18** / 障害対応 **18**（S 級 + A 級が詳細版） | — |
| 掲載特集記事 | **5 本** | — |
| プレイブック | **22 セル**（v9 で詳細化） | — |

!!! note "v9 リビルドの理由"
    v8（特集記事章）に加え、v9 では「リファレンスとカタログの解像度」を上げる 4 改善を実施。用語の相互参照、A 級手順の詳細化、プレイブックの実用化、公式図表による視覚的補強。

!!! warning "AI 生成と人手の併用"
    本ページは公式マニュアル等の公開情報のみを根拠に整理した二次資料です。AI 生成と人手の併用で作成しているため、情報の正確性は保証しません。実装・適用前には公式情報での再確認を推奨します。


!!! note "v10 改善ポイント（v9 → v10 差分）"
    1. **02-settings.md** — 環境依存 tunable に個別注記（maxfree / vpm_throughput_mode 他 6 件）
    2. **05-troubleshooting.md** — errpt label 30 種補足表 + HMC SRC コード初動表
    3. **11-special-features.md** — OpenSSH/OpenSSL バージョン整合表（AIX 7.3 TL/SP 別）+ Trusted Execution 公式リンク補強


!!! note "v11 改善ポイント（v10 → v11 差分）"
    mkdocs --strict で残っていた anchor 不在 76 件 INFO 警告を解消：
    1. **01-commands.md** — 関連コマンド stub 38 件の anchor を `{ #cmd }` 形式で補完
    2. **08-config-procedures.md** — 概念 anchor 26 件 + cfg-vmo-tuning 補完
    3. **09-incident-procedures.md** — 概念 anchor 6 件補完
    各 stub は IBM 公式コマンド/マニュアル URL のみで構成（推測内容ゼロ）。
