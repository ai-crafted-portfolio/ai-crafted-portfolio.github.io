# SORT カード / IDCAMS コマンド (T31.6)

**SORT 制御文・IDCAMS スクリプト**

*§K-12. 運用資材  (6/9)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | SORT/MERGE 制御文、IDCAMS DEFINE/REPRO/DELETE/PRINT スクリプト |
| **主要パラメータ** | SORT FIELDS=(1,10,CH,A) / OPTION COPY / DEFINE CLUSTER(NAME(...)) / DELETE 'dataset.name' |
| **影響範囲** | **IDCAMS DELETE は誤実行でデータセット消失。データ破壊リスク最大級** |
| **関連メンバ** | T31.5 運用パラメータ |
| **注意点** | **テンプレ + パラメータ分離管理を運用ルール化** (T57)。テンプレの中で DELETE 'literal_name' を直書きせず、パラメータ注入経由とする |

---

[← 運用パラメータファイル (T31.5)](運用パラメータファイル-t31-5.md) / [↑ §K-12. 運用資材](../section-k12-operational-materials.md) / [アプリ用ライブラリ — テキスト (T31.7) →](アプリ用ライブラリ-テキスト-t31-7.md)
