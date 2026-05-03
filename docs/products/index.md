# 製品技術情報

公式マニュアルは多数のページに分割された HTML 形式や英語のみで提供されているものが多く、必要な情報を集めるのに時間がかかります。本サイトでは、その中からユーザが必要とする可能性の高い情報を整理して掲載しています。

## 構造化方針

各製品とも、ChromaDB に投入済みの公式マニュアル本文から、以下 7 シート構成で抽出した二次資料を掲載しています。

1. **概要** — 製品の目的・主要機能・対象ユーザ
2. **構成要素** — コンポーネント・機能ブロックの一覧
3. **主要設定項目** — 代表的なチューナブル / 設定ファイル
4. **典型ユースケース** — 代表的な利用シナリオ
5. **トラブルシュート** — 頻出問題と対処
6. **関連製品連携** — 他製品との接続ポイント
7. **出典一覧** — 各記述に紐づく公式マニュアル URL

各記述末尾の `[SX]` は `06. 出典一覧` の出典 ID に対応します。

## 公開済み製品

### Power 系

| 製品 | 概要 |
|---|---|
| [AIX 7.3](aix-7-3/index.md) | IBM Power 上の UNIX OS。AIX 7.3 のカーネル/ファイルシステム/ネットワーク/セキュリティ等の運用・チューニング情報。 |
| [VIOS](vios/index.md) | Virtual I/O Server。Power VM 上の I/O 仮想化レイヤ。SEA/NPIV/vSCSI などの仮想化リソース管理。 |

### Windows 系

| 製品 | 概要 |
|---|---|
| [Windows Server 2022](windows-server-2022/index.md) | Microsoft の x64 サーバ OS。Active Directory / Hyper-V / IIS / Storage Spaces 等の主要機能。 |

### z/OS 系

| 製品 | 概要 |
|---|---|
| [z/OS システムプログラミング (ABCs)](zos-system-programming/index.md) | z/OS のシステムプログラミング基礎（ABCs of z/OS）。SMS/JES2/RACF/USS 等の中核領域。 |

### 監視・ジョブ運用 系

| 製品 | 概要 |
|---|---|
| [Netcool OMNIbus V8.1](netcool-omnibus/index.md) | イベント管理・統合監視。多数のプローブから ObjectServer に集約してアラートを統制。 |
| [IBM Workload Automation](ibm-workload-automation/index.md) | ジョブスケジューリング製品。マスタ・ドメインマネージャ + フォールトトレラントエージェントでジョブネットを実行。 |

### データ保護・セキュリティ 系

| 製品 | 概要 |
|---|---|
| [IBM Spectrum Protect 8.1](ibm-spectrum-protect/index.md) | エンタープライズ・バックアップ製品（旧 TSM）。重複排除・階層化ストレージ・レプリケーションを統合管理。 |
| [IBM Guardium Data Protection 12.x](ibm-guardium-data-protection/index.md) | データベース監査・データ保護プラットフォーム。S-TAP/コレクタ/アグリゲータで監査・脅威検知を実行。 |

### 端末エミュレータ 系

| 製品 | 概要 |
|---|---|
| [IBM Personal Communications 15.0](ibm-personal-communications/index.md) | Windows 用 3270/5250 ターミナルエミュレータ。HOD/HACL の代替として広く利用。 |

## 構造化準備中（公開なし）

以下の製品は ChromaDB 投入は済んでいますが、構造化 Excel が他セッションで管理中、または抽出未着手のため本サイトへの反映は今後行います。

- Anthropic Claude Docs / Claude Support（フレームワーク登録済、Excel 化作業中）
- IBM Db2 / IBM CICS TS / IBM IMS 15.5 / IBM IIDR / IBM PSF / IBM PowerHA / IBM MFT / Tivoli LFA / z/OS 3.1 等（別セッションの outputs 配下に分散・本セッションからアクセス不可）

---

!!! note "サイトポリシー"
    本ページは個人が運営する技術ポートフォリオであり、公式マニュアル等の公開情報のみを根拠に整理した二次資料です。業務上の固有情報や秘密情報は含みません。AI 生成と人手の併用で作成しているため、情報の正確性は保証しません。実装・適用前には公式情報での再確認を推奨します。
