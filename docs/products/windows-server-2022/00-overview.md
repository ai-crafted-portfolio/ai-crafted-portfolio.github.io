# Windows Server 2022 — 概要

Windows Server 2022 — 製品概要

本シートは ChromaDB 投入済みの Windows Server 2022 公式マニュアル （532 chunks / 62 sources、Microsoft Learn ベース Web 文書） から構造化抽出した製品サマリ。各記述末尾の [SX] は出典 ID（06_出典一覧 を参照）。

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | Microsoft Windows Server 2022  [S1, S2] | S1, S2 |
| ベンダ | Microsoft Corporation  [S1] | S1 |
| 製品ファミリ | Windows Server LTSC（長期サービスチャネル）。Windows Server 2019 の後継、Windows Server 2025 の前世代に相当  [S1, S6] | S1, S6 |
| エディション構成 | Standard（物理サーバまたは限定的な仮想化）、Datacenter（高度な仮想化・クラウド向け、無制限 VM）、 Datacenter: Azure Edition（VM 専用、Hotpatch / SMB over QUIC / Azure Extended Network 等の Azure 特化機能を提供）。  [S1, S2, S9] | S1, S2, S9 |
| 対応アーキテクチャ | x64 (64-bit) のみ。SSE4.2 / POPCNT / NX / DEP / CMPXCHG16b / LAHF・SAHF / PrefetchW / EPT (Intel) または NPT (AMD) をサポートする CPU が必須  [S7] | S7 |
| 最小 CPU 要件 | 1.4 GHz 64-bit プロセッサ (1 コア以上)  [S7] | S7 |
| 最小メモリ要件 | Server Core: 512 MB（ECC または同等技術付与時）/ Desktop Experience 含む構成: 2 GB を推奨。実装メモリは展開する役割により増加が必要  [S7] | S7 |
| 最小ディスク要件 | 32 GB（ネットワーク経由インストール / Desktop Experience 利用時はより多くの空きが必要）  [S7] | S7 |
| インストールオプション | (1) Server Core: GUI 無し、PowerShell / SConfig / Windows Admin Center 経由で管理、フットプリント小。(2) Server with Desktop Experience: フル GUI 付き標準インストール  [S1, S10] | S1, S10 |
| ライフサイクル | LTSC は Fixed Lifecycle Policy: メインストリーム 5 年 + 延長 5 年 = 計 10 年  [S11, S6] | S11, S6 |
| 製品の役割 | オンプレ / ハイブリッド / クラウドにわたる Microsoft エンタープライズ サーバ プラットフォーム。 Active Directory ドメインサービス、Hyper-V 仮想化、ファイル・ストレージ（Storage Spaces Direct / SMB / DFS）、 Failover Clustering、IIS Web 配信、リモートデスクトップサービス（RDS）、Windows Admin Center / Server Manager による管理、Azure Arc・Azure Automanage によるハイブリッド統合等を提供する。  [S1, S2, S55] | S1, S2, S55 |
| 想定読者 | Windows サーバ管理者、Active Directory 管理者、Hyper-V / Failover Cluster 運用者、エンタープライズ IT インフラ運用設計担当  [S1, S44, S48] | S1, S44, S48 |
| 典型利用シーン | Active Directory ドメインコントローラ、Hyper-V 仮想化基盤（Generation 2 VM・Shielded VM・SDN）、 Storage Spaces Direct によるハイパーコンバージドインフラ（HCI）、ファイルサーバ（SMB / DFS / Data Deduplication）、 RDS によるVDI、IIS Web サーバ、WSUS パッチ管理、AD CS による PKI 構築。  [S1, S37, S55, S47] | S1, S37, S55, S47 |
| セキュリティ強化 | Secured-core server（TPM 2.0、Secure Boot、DRTM、VBS、HVCI、Boot DMA Protection の組合せ）、 TLS 1.3 既定有効、HTTPS 既定有効、SMB AES-256-GCM/CCM 暗号、SMB over QUIC、DNS-over-HTTPS（DoH）。  [S2, S20, S23, S32] | S2, S20, S23, S32 |
| Hotpatch 機能 | Datacenter: Azure Edition（および Azure Local 22H2 以降のゲスト VM）で再起動なしのセキュリティ更新を提供。 年あたり再起動回数を 12 回程度から 4 回に削減（公式数値）。Azure Arc 接続マシンでは Windows Server 2025 で月額課金提供。  [S1, S12] | S1, S12 |
| 管理ツール | Server Manager（GUI）、Windows Admin Center（WAC、ブラウザベース）、PowerShell、SConfig（Server Core 用）、System Center / Azure Arc / Azure Automanage  [S44, S45, S48] | S44, S45, S48 |
| OpenSSH | Windows Server 2022 では Optional Feature として既定インストールされない（要追加導入）。Windows Server 2025 では既定インストール済み（既定では無効）  [S46] | S46 |
| ドキュメント形態 | Microsoft Learn 上の Web ドキュメント（本Excel では 62 ソース、532 チャンクを ChromaDB に格納）  [S1] | S1 |
| 関連製品（密結合） | Active Directory（同梱）、Hyper-V（同梱）、Microsoft SQL Server、System Center、Exchange Server、SharePoint、Microsoft Azure（Arc / Automanage / Local）  [S1, S2] | S1, S2 |

