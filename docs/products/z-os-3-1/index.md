# z/OS 3.1

> IBM Z メインフレームの 64-bit エンタープライズ OS。**13 章構成**で staple なコマンド・設定・用語・手順 + シナリオ別ガイド + ユースケース集を整理。

**カテゴリ**: z/OS 系 / メインフレーム OS

## 構成（13 章）

| セクション | 内容 |
|---|---|
| **01. 製品概要** | 製品の役割（本ページ下部） |
| [02. コマンド一覧](01-commands.md) | オペレータ/JES2/TSO/SDSF/JCL/USS/SMP/E **45 件** |
| [03. 設定値一覧](02-settings.md) | PARMLIB **19** + tunable **20** |
| [04. 用語集](03-glossary.md) | z/OS 固有 **70 件**（関連用語クロスリンク） |
| [05. プレイブック](04-playbook.md) | 22 セル |
| [06. トラブル早見表](05-troubleshooting.md) | **20 件** |
| [07. マニュアル参照マップ](06-manual-map.md) | **22 テーマ**（IBM Docs deep link） |
| [08. 出典一覧](07-sources.md) | **40 件** |
| [09. 設定手順](08-config-procedures.md) | **18 件**（S/A 級） |
| [10. 障害対応手順](09-incident-procedures.md) | **18 件**（S/A 級） |
| [11. 対象外項目](10-out-of-scope.md) | 全件カテゴリ別 |
| [12. シナリオ別ガイド](11-scenarios.md) | **6 本**（業務全体の俯瞰、ユースケース組み合わせ案内） |
| [13. ユースケース集](12-use-cases.md) | **30 件**（独立完結の手順、拾い読み可能） |

各章の関連エントリには、設定手順 / 障害対応手順 / 用語 / ユースケースへの双方向リンクを付与。

---

## 01. 製品概要

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM z/OS 3.1 | S_ZOS_Intro |
| 最新バージョン | z/OS 3.1（2023-09 リリース） | S_ZOS_WhatsNew |
| 対応 HW | IBM Z（z14 以降推奨） | S_ZOS_Intro |
| 想定読者 | z/OS システムプログラマ、オペレータ、運用者 | S_ZOS_MVS_Init |
| 主要サブシステム | JES2 / RACF / USS / TCP/IP / SMS / SMF / WLM | S_ZOS_Intro |
| 補助辞典 | ABCs of z/OS Redbooks 13冊（出典 S_ZOS_ABCs01〜13） | S_ZOS_Review |

!!! note "v2 構築方針"
    z/OS 3.1 の staple な範囲を AIX v9 と同じ品質ゲートで構築 + ABCs Redbooks から構成図を関連章に埋込（C subroutine ノイズなし、定性記述なし、公式マニュアル準拠、URL 必須）。

!!! warning "AI 生成と人手の併用"
    本ページは公式マニュアル等の公開情報のみを根拠に整理した二次資料。AI 生成と人手の併用で作成しているため、情報の正確性は保証しない。実装・適用前には公式情報での再確認を推奨。
