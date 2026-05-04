# 製品技術情報

公式マニュアルは多数のページに分割された HTML 形式や英語のみで提供されているものが多く、必要な情報を集めるのに時間がかかります。本サイトでは、その中からユーザが必要とする可能性の高い情報を整理して掲載しています。

## 構造化方針

各製品とも、ChromaDB に投入済みの公式マニュアル本文から、以下 7 シート構成で抽出した二次資料（Excel ブック）を提供しています。

1. **概要** — 製品の目的・主要機能・対象ユーザ
2. **構成要素** — コンポーネント・機能ブロックの一覧
3. **主要設定項目** — 代表的なチューナブル / 設定ファイル
4. **典型ユースケース** — 代表的な利用シナリオ
5. **トラブルシュート** — 頻出問題と対処
6. **関連製品連携** — 他製品との接続ポイント
7. **出典一覧** — 各記述に紐づく公式マニュアル URL

「詳細ページ」列のリンクをクリックすると、Excel から MkDocs に展開した web 版の整理情報を閲覧できます（一部製品で公開済）。「Excel」列のリンクをクリックすると、構造化済み Excel ブックを直接ダウンロードできます。

## 製品一覧

!!! note "z/OS 系の読み分けガイド"
    z/OS 関連のページは役割が異なる **3 か所** に分かれています。目的に応じて使い分けてください。

    - **[z/OS 3.1](z-os-3-1/)** — 公式マニュアル系の **運用リファレンス**（13 章、コマンド / 設定 / 用語 / 設定手順 / 障害対応 / シナリオ / ユースケース）。日々の運用で「やり方」を引く用途。
    - **[Db2 13 for z/OS](db2-for-zos-13/)** — Db2 13 公式マニュアル系の **運用リファレンス**（13 章）。DBA / オペレータが「やり方」を引く用途。
    - **[z/OS システムプログラミング (ABCs)](zos-system-programming/)** — IBM Redbooks「ABCs of z/OS System Programming」13 巻ベースの **教材構造化**（7 シート）。Sysprog 視点で「何が何のためにあるか」を学ぶ用途。
    - **[discussions/zos-library-management](../discussions/zos-library-management/)** — ChangeTracker 代替ツールの **設計提案資料**（検討中）。製品リファレンスではない。

| 製品 | カテゴリ | 概要 | 詳細ページ | Excel |
|---|---|---|---|---|
| AIX 7.3 | OS（UNIX） | IBM Power 上の UNIX。カーネル / FS / ネットワーク / セキュリティの運用情報 | [詳細](aix-7-3/index.md) | [📥](files/AIX_7.3.xlsx) |
| VIOS | 仮想化 | Power VM 上の I/O 仮想化レイヤ。SEA / NPIV / vSCSI 管理 | [詳細](vios/index.md) | [📥](files/VIOS.xlsx) |
| PowerHA SystemMirror 7.2 | 高可用性 | AIX 上のクラスタ HA。リソースグループとフェイルオーバー | （準備中） | [📥](files/PowerHA_72.xlsx) |
| Windows Server 2022 | OS（Windows） | Microsoft x64 サーバ OS。AD / Hyper-V / IIS / Storage Spaces 等 | [詳細](windows-server-2022/index.md) | [📥](files/Windows_Server_2022.xlsx) |
| z/OS 3.1 | OS（メインフレーム） | z/OS V3R1 公式マニュアル系。実運用リファレンス（13 章） | [詳細](z-os-3-1/) | [📥](files/z_OS_3.1.xlsx) |
| z/OS システムプログラミング (ABCs) | OS（メインフレーム） | ABCs Redbooks 13 巻ベースの Sysprog 教材構造化（7 シート） | [詳細](zos-system-programming/index.md) | [📥](files/z_OS_System_Programming.xlsx) |
| Db2 13 for z/OS | データベース | z/OS 上のリレーショナル DB。Db2 13 公式マニュアル系。実運用リファレンス（13 章） | [詳細](db2-for-zos-13/) | [📥](files/Db2_for_z_OS.xlsx) |
| IMS 15.5 | データベース / TM | 階層型 DB / トランザクションマネージャ | （準備中） | [📥](files/IMS_15.5.xlsx) |
| IIDR 11.4 | データレプリケーション | InfoSphere Data Replication。CDC ベースの DB レプリケーション | （準備中） | [📥](files/IIDR_11.4.xlsx) |
| CICS TS 6.x | トランザクションマネージャ | z/OS 上のオンライン業務基盤 | （準備中） | [📥](files/CICS_TS_6.x.xlsx) |
| IBM MQ 9.3 MFT | メッセージング | MQ Managed File Transfer。マネージド・ファイル転送 | （準備中） | [📥](files/IBM_MQ_9.3_MFT.xlsx) |
| IBM Workload Automation | ジョブ管理 | TWS。マスタ + FTA でジョブネットを実行 | [詳細](ibm-workload-automation/index.md) | [📥](files/IBM_Workload_Automation.xlsx) |
| Netcool/OMNIbus 8.1 | 監視・運用 | イベント管理・統合監視。プローブ → ObjectServer 集約。**13 章 + S 級 A/B/C 仮説分岐 + 期待出力** | [詳細](netcool-omnibus-8-1/index.md) | [📥](files/Netcool_OMNIbus_V8.1.xlsx) |
| Netcool OMNIbus V8.1（旧 7 シート） | 監視・運用 | 旧版（概要俯瞰用、新版 [Netcool/OMNIbus 8.1](netcool-omnibus-8-1/index.md) を推奨） | [詳細](netcool-omnibus/index.md) | — |
| Tivoli Log File Agent 6.3 | 監視・運用 | ログファイル監視エージェント | （準備中） | [📥](files/Tivoli_Log_File_Agent_6.3.xlsx) |
| IBM Spectrum Protect 8.1 | バックアップ | エンタープライズ・バックアップ（旧 TSM） | [詳細](ibm-spectrum-protect/index.md) | [📥](files/IBM_Spectrum_Protect_8.1.xlsx) |
| IBM Guardium Data Protection 12.x | セキュリティ・監査 | DB アクセス監査プラットフォーム。S-TAP / コレクタ / アグリゲータ | [詳細](ibm-guardium-data-protection/index.md) | [📥](files/IBM_Guardium_Data_Protection_12.x.xlsx) |
| IBM Personal Communications 15.0 | 端末エミュレータ | Windows 用 3270 / 5250 ターミナルエミュレータ | [詳細](ibm-personal-communications/index.md) | [📥](files/IBM_Personal_Communications_15.0.xlsx) |
| PSF for z/OS 4.7 | 印刷 | z/OS 印刷サブシステム（Print Services Facility） | （準備中） | [📥](files/PSF_z_OS_4.7.xlsx) |
| Anthropic Claude Docs | AI / LLM | Claude API 全体ドキュメント（モデル・API・Tool use 等） | （準備中） | [📥](files/Anthropic_Claude_Docs.xlsx) |
| Anthropic Claude Support | AI / LLM | Claude 利用 FAQ / トラブルシュート | （準備中） | [📥](files/Anthropic_Claude_Support.xlsx) |

各記述末尾の `[SX]` は各 Excel `06. 出典一覧` シートの出典 ID に対応します。

---

!!! note "サイトポリシー"
    本ページは個人が運営する技術ポートフォリオであり、公式マニュアル等の公開情報のみを根拠に整理した二次資料です。業務上の固有情報や秘密情報は含みません。AI 生成と人手の併用で作成しているため、情報の正確性は保証しません。実装・適用前には公式情報での再確認を推奨します。
