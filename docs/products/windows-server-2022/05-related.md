# Windows Server 2022 — 関連製品連携

Windows Server 2022 — 関連製品連携 / 依存関係

| 連携先製品 | 連携の種類 | 設定要点 | 出典 |
|---|---|---|---|
| Microsoft Azure (Arc / Automanage / Update Manager) | ハイブリッドクラウド管理 | Azure Arc で WS2022 をクラウド外でも一元管理。Azure Update Manager で Hotpatch 含む更新スケジュール。Azure Extended Network でオンプレ IP を Azure に延伸 | S1, S2, S12 |
| Azure Local（旧 Azure Stack HCI） | オンプレ HCI 基盤 | WS2022 Datacenter: Azure Edition は Azure Local 22H2 上のゲスト VM として稼働可能。Hotpatch / SMB over QUIC 等の機能をオンプレで利用 | S2, S12 |
| Microsoft SQL Server | データベース | AD 統合認証 (Kerberos)、SMB 3.0 ファイル共有での DB 配置、Storage Spaces Direct 上の HCI で Always On 可用性グループ。Windows Server へ通常密結合 | S1, S32 |
| Microsoft SharePoint Server | コラボレーション基盤 | WS2022 上で IIS / SQL Server / AD / Search / Workflow を統合。Windows Authentication / TLS 1.3 をフル活用 | S1, S21 |
| Microsoft Exchange Server | メッセージング | AD DS 必須。Schannel / TLS 1.3 / Kerberos / Windows Firewall 連携。HA は DAG が中心（Failover Cluster 抽象化版） | S1, S23 |
| System Center Configuration Manager (SCCM / MECM) | 構成管理 / ソフトウェア配布 | WSUS と統合してパッチ配布、コンプライアンス、OS 展開、Endpoint Protection を WS2022 配下のクライアントへ | S47, S1 |
| System Center Virtual Machine Manager (SCVMM) | Hyper-V / SDN 集中管理 | WS2022 Hyper-V クラスタ・S2D・SDN を SCVMM から統合管理。VM テンプレート / ライブラリ / ロールベース | S55, S33 |
| Windows Admin Center | ブラウザ統合管理コンソール | Server Manager の現代的後継。Hyper-V / S2D / Cluster / Update / Azure 拡張を 1 ペインで提供 | S45, S44 |
| PowerShell / Windows Terminal / SConfig | 管理 CLI | Server Core の主要管理経路。Get-WindowsFeature / Install-WindowsFeature 等の ServerManager モジュールを多用。SConfig は Server Core の TUI ツール | S10, S48 |
| OpenSSH for Windows | セキュアリモートシェル | WS2022 では Optional Feature。Linux / macOS / Windows クライアント間の標準 SSH 互換管理。GitHub の Microsoft フォークで開発 | S46 |
| Microsoft Defender for Servers / Defender for Cloud | EDR / セキュリティ統合 | Secured-core server と組合せ多層防御。Azure Arc 経由で Defender for Cloud の継続的評価対象に組込み | S20, S19 |
| Active Directory Federation Services (AD FS) / Microsoft Entra ID | ID 連携 / SSO | オンプレ AD FS で SAML / WS-Federation / OAuth、ハイブリッドは Microsoft Entra Connect で Entra ID へ同期 | S15, S13 |
| Microsoft Endpoint Configuration Manager (Intune 連携) | クライアント管理 | Group Policy の代替/補完。Intune は LAPS / BitLocker / Windows Defender 等を WS2022 ドメイン配下端末にも展開可能 | S17, S25 |
| Remote Desktop Services 関連クライアント | VDI / セッションホスト クライアント | Windows Desktop / Microsoft Store / iOS / macOS / Android / Web Client（HTML5）。MSI / Microsoft Store 経由で配布 | S53, S52 |
| Hyper-V ゲスト OS（Linux / FreeBSD / Windows） | ゲスト OS サポート | Generation 2 VM では UEFI Secure Boot / vTPM / Shielded VM 対応。Linux Integration Services（LIS）で Linux ゲスト最適化 | S55, S56 |

