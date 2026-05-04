# z/OS 3.1

!!! info "関連: z/OS 運用資材の管理ツール検討は [discussions/zos-library-management/](../../discussions/zos-library-management/) を参照。"

> IBM Z メインフレームの 64-bit エンタープライズ OS。**13 章構成**で staple なコマンド・設定・用語・手順 + シナリオ別ガイド + ユースケース集を整理。**v3 でレビュー B → A 改善（仮説分岐 / 期待出力 / 図表拡張）**。

**カテゴリ**: z/OS 系 / メインフレーム OS

## 構成（13 章）

| セクション | 内容 |
|---|---|
| **01. 製品概要** | 製品の役割（本ページ下部） |
| [02. コマンド一覧](01-commands.md) | オペレータ/JES2/TSO/SDSF/JCL/USS/SMP/E **45 件** |
| [03. 設定値一覧](02-settings.md) | PARMLIB **19** + tunable **20** + 種別列追加 |
| [04. 用語集](03-glossary.md) | z/OS 固有 **78 件**（仮想記憶カテゴリ追加） |
| [05. プレイブック](04-playbook.md) | 22 セル |
| [06. トラブル早見表](05-troubleshooting.md) | **20 件** |
| [07. マニュアル参照マップ](06-manual-map.md) | **22 テーマ** |
| [08. 出典一覧](07-sources.md) | **40 件** |
| [09. 設定手順](08-config-procedures.md) | **18 件** + 期待出力サンプル追加 |
| [10. 障害対応手順](09-incident-procedures.md) | **18 件** + A/B/C 仮説分岐追加（S 級） |
| [11. 対象外項目](10-out-of-scope.md) | 全件カテゴリ別 |
| [12. シナリオ別ガイド](11-scenarios.md) | **6 本**（本記事範囲を個別化） |
| [13. ユースケース集](12-use-cases.md) | **30 件** |

各章の関連エントリには、設定手順 / 障害対応手順 / 用語 / ユースケースへの双方向リンクを付与。本文中に **72 図表エントリ** を埋込（ABCs of z/OS Redbooks 13 冊から厳選）。

---

## 01. 製品概要

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM z/OS 3.1 | S_ZOS_Intro |
| 最新バージョン | z/OS 3.1（2023-09 リリース） | S_ZOS_WhatsNew |
| 対応 HW | IBM Z（z14 以降推奨） | S_ZOS_Intro |
| 想定読者 | z/OS システムプログラマ、オペレータ、運用者 | S_ZOS_MVS_Init |
| 主要サブシステム | JES2 / RACF / USS / TCP/IP / SMS / SMF / WLM | S_ZOS_Intro |

!!! note "v3 改善ポイント"
    レビュー B → A への改善差分：(1) Master Catalog の事実訂正 (2) 仮想記憶カテゴリ追加（PSA/CSA/ECSA/SQA/ESQA/LPA/SVC/CVT）(3) tunable 種別列（サイジング / モード選択 / 運用ポリシー / 構成定義）(4) 09 章 S 級 incident に A/B/C 仮説分岐 (5) 08 章 S 級 cfg に期待出力サンプル (6) シナリオ「本記事の範囲」を個別化 (7) 図表埋込を 8 → 73 エントリに拡張。

!!! warning "AI 生成と人手の併用"
    本ページは公式マニュアル等の公開情報のみを根拠に整理した二次資料。AI 生成と人手の併用で作成しているため、情報の正確性は保証しない。実装・適用前には公式情報での再確認を推奨。


!!! note "v4 改善ポイント（v3 → v4 差分）"
    実画面レビュー指摘の B+ → A 改善：
    1. **03-glossary.md** — 仮想記憶 6 用語（SVC/PSA/CSA/ECSA/ESQA/CVT）に独立 `## XXX { #xxx }` 見出し追加（v3 ではテーブル内 span だけだった）
    2. **10-out-of-scope.md** — 「25 ユースケース」表記を「30 ユースケース + 6 シナリオ」に修正
    3. **11-scenarios.md** — DR / セキュリティ監査 / PTF パッチ 3 シナリオの「本記事の範囲」を個別化（v3 では未対応）
    4. **08/09 マトリクス表** — `<div class="md-typeset__scrollwrap">` で囲んで横スクロール可能に（モバイル対策）
    5. **extra.css** — モバイル（≤768px）テーブル font-size 縮小 + overflow-x:auto 強制
    6. **index.md** — 図表エントリ表記を実数 72 に統一
