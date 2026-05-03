# Windows Server 2022 — 主要設定項目

Windows Server 2022 — 主要設定項目（Group Policy / Registry / Event Log / PowerShell）

Group Policy 設定、レジストリキー、Event Log 設定、Performance Tuning パラメータ、PowerShell コマンド類。

| 設定項目 | 管理レイヤ / 配置先 | 既定値 | 取り得る値 / 説明 | 影響範囲 / 反映タイミング | 出典 |
|---|---|---|---|---|---|
| Group Policy Object (GPO) | AD DS Domain / Site / OU、または Local Group Policy Editor (gpedit.msc) | 未リンク状態 | Computer / User Configuration（ポリシー＋プリファレンス）。Container は AD のドメインパーティション、Template は SYSVOL に配置 | Computer 起動 / User サインイン時に同期/非同期適用。バックグラウンドで定期更新 | S61 |
| TLS バージョン制御 | HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\<TLS x.y>\<Client\|Server> | WS2022: TLS 1.0/1.1 有効、TLS 1.2/1.3 有効 | Enabled (DWORD: 1=有効/0=無効)、DisabledByDefault (DWORD: 1=既定無効) | Schannel 利用サービス再起動後反映 | S23, S24 |
| Schannel ログレベル | HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\EventLogging | 1 (エラーのみ) | 0=なし / 1=エラー / 2=警告 / 3=エラー+警告 / 4=情報・成功 / 5・6・7=組合せ | ログレベル変更には再起動必須 | S24 |
| CertificateMappingMethods | HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\CertificateMappingMethods | Kerberos S4U （既定有効） | S4U / UPN / one-to-one / many-to-one の組合せ。クライアント証明書認証マッピング方式 | Schannel 利用サービス再起動後反映 | S24 |
| SMB 暗号化 | Set-SmbServerConfiguration / Set-SmbShare PowerShell | 未強制（共有別 EncryptData=False） | EncryptData=$true、AES-128-GCM / AES-256-GCM / AES-256-CCM。Group Policy でも強制可 | オンライン適用、既存セッションは再接続後反映 | S32, S2 |
| SMB over QUIC | Set-SmbServerConfiguration -EnableSMBQUIC （Datacenter: Azure Edition） | 無効 | TLS 1.3 と組合せて UDP/443 で SMB を提供。VPN レスでファイルアクセス可能 | サービス再起動後反映 | S2, S32 |
| BitLocker | manage-bde / Enable-BitLocker / Group Policy 'Computer Configuration > Administrative Templates > Windows Components > BitLocker Drive Encryption' | OS ドライブで無効 | TPM のみ / TPM+PIN / TPM+Startup Key / TPM+PIN+Startup Key、Recovery Key 自動エスクロー（AD / Microsoft アカウント） | 暗号化処理は実行中継続、再起動で完全反映 | S25 |
| Windows Firewall プロファイル | Set-NetFirewallProfile / wf.msc / Group Policy | 全 3 プロファイル（Domain/Private/Public）有効 | Domain（AD 接続時）/ Private（家庭/信頼）/ Public（公開）。受信/送信ブロック既定 | オンライン適用、新規接続から有効 | S35 |
| Hotpatch ベースライン | Azure Update Manager（Hotpatch SKU の VM） | Azure Automanage 経由で自動 | Hotpatch 適用月と Latest Cumulative Update（LCU）月の交互スケジュール。月次 | Hotpatch は再起動不要、LCU は再起動必須 | S12 |
| Cluster Quorum モード | Failover Cluster Manager / Set-ClusterQuorum | ノード数に応じ自動（推奨: 奇数票） | Node Majority / Node + Disk witness / Node + File Share witness / Node + Cloud witness / No Majority (Disk Only) | オンライン適用、サービス継続 | S60, S58 |
| Cluster-Aware Updating (CAU) | ClusterAwareUpdating GUI / Add-CauClusterRole / Invoke-CauRun PowerShell | 未構成 | Self-updating または Remote-updating モード、Updating Run Profile で詳細制御 | Updating Run 開始時にノードを順次メンテナンスモード化 | S59 |
| イベントログ管理 | wevtutil（コマンドライン）/ Get-WinEvent (PowerShell) / Event Viewer GUI | Application / System / Security 等が既定有効、最大サイズはログ別に設定 | wevtutil sl <Logname> /e:<true\|false> /ms:<bytes> /rt:<true\|false> /ab:<true\|false>。最小 1,048,576 bytes、64KB 単位 | オンライン反映、サービス継続 | S51 |
| DNS-over-HTTPS (DoH) クライアント | Set-DnsClientDohServerAddress / Group Policy | OS 全体としては未強制、サーバ別に有効化 | Auto / RequireDoH / AllowOpportunistic 等のモード | DNS Client サービス再起動後反映 | S2 |
| Windows Update / WSUS クライアント | Group Policy 'Windows Components > Windows Update' / レジストリ HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate | Microsoft Update から直接ダウンロード | WSUS サーバ URL、UseWUServer、UpdateAutoInstall、ScheduledInstallTime 等 | Windows Update Agent 次回チェック時反映 | S47 |
| AD DS パスワードポリシー | Default Domain Policy GPO / Fine-Grained Password Policy (FGPP) | ドメイン既定（複雑性有効、長さ 7 等は環境依存） | MinPasswordLength / PasswordHistorySize / MaxPasswordAge / LockoutThreshold 等。FGPP で OU 単位上書き | GPO 更新間隔（既定 90 分 ± 30 分）後反映 | S13, S61 |
| LAPS パスワードローテーション | Group Policy 'Computer Configuration > Administrative Templates > LAPS' / Set-LapsADComputer | 未構成 | PasswordLength（既定 14）、PasswordAgeDays、PasswordComplexity、ADPasswordEncryptionEnabled | LAPS CSE 実行間隔（既定 1 時間）後反映 | S17 |
| PowerShell 実行ポリシー | Set-ExecutionPolicy / Group Policy 'Computer Configuration > Administrative Templates > Windows PowerShell' | Restricted（対話シェル既定）、サーバでは RemoteSigned が一般的 | Restricted / AllSigned / RemoteSigned / Unrestricted / Bypass / Undefined | 新規セッションから有効 | S49, S44 |
| Performance Tuning カテゴリ | Performance Tuning Guidelines for Windows Server 2022 | OS 既定（汎用ワークロード前提） | Hardware（電源・CPU・メモリ）/ Server Role（AD・File・Hyper-V・RDS・Web・Containers）/ Server Subsystem（キャッシュ・ネットワーク・S2D・SDN） | 個別パラメータごと（多くは再起動不要） | S49 |

