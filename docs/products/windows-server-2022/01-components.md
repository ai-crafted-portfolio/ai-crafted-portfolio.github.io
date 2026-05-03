# Windows Server 2022 — 構成要素

Windows Server 2022 — 構成要素（役割・機能ブロック）

各コンポーネント記述の末尾「出典」列に [SX] 形式の出典 ID（06_出典一覧 参照）。

| コンポーネント名 | 役割 | 主要機能 | 関連サブシステム | 出典 |
|---|---|---|---|---|
| Active Directory Domain Services (AD DS) | ディレクトリサービス（認証・認可・ポリシー） | ユーザ・コンピュータ・グループ等のオブジェクトを階層管理。スキーマ・グローバルカタログ・レプリケーション（FRS / DFSR）・サインイン認証・GPO 適用基盤を提供 | DNS、Group Policy、Kerberos | S13, S61 |
| Active Directory Federation Services (AD FS) | フェデレーション認証（SSO） | クレームベース認証で複数ドメイン・組織間のフェデレーション SSO を実現。SAML / WS-Federation / OAuth 連携 | AD DS、Web Application Proxy | S15 |
| Active Directory Certificate Services (AD CS) | 公開鍵基盤（PKI） | Certification Authority、Certificate Enrollment Web Service、Network Device Enrollment Service、Online Responder（OCSP）等を提供。証明書の発行・失効管理 | AD DS、Schannel | S16, S9 |
| Hyper-V | Type-1 ハイパーバイザ仮想化 | Generation 1/2 VM、Shielded VM、Discrete Device Assignment、Live Migration、Hyper-V Replica、入れ子仮想化、最大 240 TB RAM・2,048 vCPU/VM をサポート | Failover Clustering、SDN、Storage | S55, S56, S1 |
| Failover Clustering | 高可用性クラスタ | active-active / active-passive 構成、Cluster Shared Volume (CSV)、heartbeat 監視、Quorum（Cloud witness / Disk witness / File share witness）。最大 16 ノード | Storage Spaces Direct、Hyper-V | S58, S60, S37 |
| Storage Spaces Direct (S2D) | ソフトウェア定義ストレージ（HCI） | 2〜16 ノードの内部ストレージを共有プール化。Software Storage Bus、Storage Bus Layer Cache、ReFS、CSV、Mirror / Erasure Coding、Scale-Out File Server (SoFS) 構成。Datacenter エディション限定 | Failover Clustering、SMB Direct、ReFS | S37, S9 |
| Storage Replica | ボリューム同期/非同期レプリケーション | サーバ間・クラスタ間でブロックレベルのレプリケーション（同期/非同期）。2022-09 累積更新で送信時データ圧縮対応（Azure Edition） | Storage Spaces、Failover Clustering | S38, S2 |
| SMB (Server Message Block) | ファイル共有プロトコル | SMB 3.1.1 ベース。AES-256-GCM/CCM 暗号、AES-128-GMAC 署名、SMB over QUIC（VPN レス WAN アクセス）、SMB Direct (RDMA)、SMB Multichannel、Transparent Failover | TCP/IP、QUIC、Schannel | S32, S2 |
| DFS (Distributed File System) | 分散ファイル名前空間 / レプリケーション | DFS Namespaces（複数物理共有を一つの論理階層へ統合）と DFS Replication（DFSR、SYSVOL レプリケーション含む）。AD 統合 | AD DS、SMB | S40, S13 |
| Data Deduplication | ボリューム重複排除 | ブロックチャンク + 任意の圧縮で 30〜95% の容量削減。VDI 80–95%、汎用ファイル 50–60% 等。Files Server / VDI / Backup シナリオ向け | ReFS / NTFS、Storage | S41 |
| iSCSI Target Server | ブロックストレージ提供 | VHD/VHDX をバックエンドとした iSCSI ターゲット。診断レス起動・SAN 互換性テスト・小規模ブロックストレージ提供向け | Storage、ネットワーキング | S42 |
| BranchCache | WAN 帯域削減用ローカルキャッシュ | 支社・小規模拠点の HTTP / SMB トラフィックをローカルキャッシュ。Hosted Cache / Distributed Cache モード | SMB、HTTP/HTTPS | S34 |
| DNS Server | 名前解決（権威 / リゾルバ） | AD 統合ゾーン、DNSSEC、条件付きフォワーダ、DNS ポリシー、エニーキャスト、DNS Client は DNS-over-HTTPS (DoH) 対応 | AD DS、TCP/IP | S27, S2 |
| DHCP Server | IP アドレス自動配布 | リース管理、予約、スコープ、フェイルオーバ、サブネット間転送（リレー）。RFC 2131/2132 ベース | TCP/IP、IPAM | S28 |
| Network Policy Server (NPS) | RADIUS サーバ / ネットワーク アクセス ポリシー | VPN / ワイヤレス / 802.1X 認証の RADIUS フロントエンド。条件付きアクセスポリシー定義 | AD DS、RADIUS、IAS | S29 |
| IPAM (IP Address Management) | IP アドレス・DNS / DHCP の集中管理 | 複数 DHCP / DNS / DC を統合的に可視化・監査。AD 統合 | DHCP、DNS、AD DS | S31 |
| Software Defined Networking (SDN) | ネットワーク仮想化 | Hyper-V 仮想スイッチ + Network Controller、HNV（VXLAN/NVGRE）、Software Load Balancer (SLB)、RAS Gateway | Hyper-V、Network Controller | S33, S14 |
| Windows Firewall (with Advanced Security) | ホスト型ファイアウォール | 受信/送信トラフィックを IP・ポート・サービス基準でフィルタ。IPsec ベース認証通信、Network Location Awareness、3 プロファイル（Domain/Private/Public） | IPsec、Group Policy | S35 |
| BitLocker Drive Encryption | ボリューム暗号化 | TPM 2.0 ベースのフルボリューム暗号化、起動 PIN / スタートアップ キー多要素対応、TCG-compliant BIOS / UEFI 必須 | TPM、Secure Boot | S25, S7 |
| Schannel SSP / TLS スタック | SSL/TLS プロバイダ | TLS 1.3 既定有効（Windows Server 2022）、TLS 1.0/1.1 は非推奨。SSPI 経由で各種アプリへ提供。SCHANNEL レジストリで詳細制御 | OpenSSL は別系統、AD CS | S23, S24, S2 |
| Windows Authentication / Credential Guard | 認証基盤 | Kerberos / NTLM（NTLMv1 削除、NTLMv2 非推奨）、Negotiate、Smart Card、Windows Hello、LSA。Credential Guard で資格情報を VBS で隔離 | AD DS、VBS、LSA | S21, S22, S11 |
| LAPS (Local Administrator Password Solution) | ローカル Administrator パスワード自動管理 | AD ベースで各端末のローカル Administrator パスワードを自動ローテーション・保管 | AD DS、Group Policy | S17 |
| Group Managed Service Accounts (gMSA) | サービス用管理 ID 自動パスワード管理 | 複数ホストで共有可能なサービスアカウント。AD で 30 日ごとに自動的にパスワードローテーション | AD DS、Kerberos | S18 |
| Group Policy | 構成・設定の集中配布 | GPO（Container + Template）を Site / Domain / OU にリンク。クライアント側 CSE が同期/非同期で適用。SYSVOL 経由で複製 | AD DS、SYSVOL、DFSR | S61 |
| Windows Server Update Services (WSUS) | 更新パッケージ集中配布 | PowerShell cmdlet 管理、SHA-256 サイン対応、UUP（Unified Update Platform）対応（IIS MIME 追加要）。Windows Server 2022 で deprecated（生産展開は引き続き支援） | IIS、Windows Update Agent | S47, S11 |
| Windows Admin Center (WAC) | ブラウザベース統合管理コンソール | Hyper-V / S2D / Cluster / Server Manager 機能を Web UI で統合。Azure ハイブリッド機能のエントリポイント | PowerShell、Azure Arc | S45, S44 |
| Server Manager | ローカル/リモート役割管理 GUI | 役割と機能の追加・削除、複数サーバ管理、ベストプラクティス アナライザ（BPA）連携 | PowerShell、WMI | S48 |
| Remote Desktop Services (RDS) | セッションベース・VDI 配信 | Connection Broker / Session Host / Web Access / Gateway / Licensing。Windows / iOS / macOS / Android / Web クライアント対応 | AD DS、IIS、ネットワーク | S52, S53, S54 |
| Hotpatch (Datacenter: Azure Edition) | 再起動なしセキュリティ更新 | メモリ内コードへ直接パッチ。年再起動回数を 12 → 4 回程度に削減。Server Core / Desktop Experience 両対応（一部）。Azure Arc 経由で WS2025 にも提供（有料） | Azure Update Manager、Azure Automanage | S12, S2 |
| Secured-core server | ハードウェア組込みセキュリティ | TPM 2.0 + Secure Boot + DRTM (System Guard Secure Launch) + VBS + HVCI + Boot DMA Protection (IOMMU) を統合した認定構成 | TPM、UEFI、ハイパーバイザ | S20, S7 |
| OpenSSH for Windows | セキュアリモートシェル | ssh / sshd / ssh-keygen / ssh-agent / sftp / scp。Windows Server 2022 では Optional Feature（要追加導入） | TCP/IP、PowerShell | S46 |
| Print and Document Services | プリントサーバ / ドキュメント サービス | Print Server、Distributed Scan Server、Internet Printing 等。プリンタプール / 印刷フィルタリング / Branch Office Direct Printing | AD DS、ネットワーク | S62 |
| Storage Migration Service | 旧サーバ → 新サーバへの段階的移行 | Windows Server / Linux / NetApp Filer から WS2019/2022 へファイル/アクセス権/ID をオンライン移行 | SMB、AD DS | S43 |

