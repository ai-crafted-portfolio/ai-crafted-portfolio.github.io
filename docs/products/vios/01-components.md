# VIOS — 構成要素

VIOS — 構成要素（コンポーネント・機能ブロック）

VIOS LPAR を構成する仮想化サブシステム群。各行末『出典』列に [SX] 形式の出典 ID（06_出典一覧 参照）。

| コンポーネント名 | 役割 | 主要機能・特徴 | 関連サブシステム | 出典 |
|---|---|---|---|---|
| VIOS Partition (LPAR) | VIOS ソフトウェアを稼働させる専用 LPAR | PowerVM Editions の一部。専用 LPAR が必須（他 OS と同居不可）。HMC から Add VIOS Wizard で作成し、CPU・メモリ・物理 I/O アダプタ（ネットワーク + ストレージ用に少なくとも 1 枚以上）を割り当てる。 | PowerVM, HMC | S7, S11 |
| Virtual SCSI (vSCSI) ターゲット | クライアント LPAR に vSCSI LUN を提供 | VIOS が vSCSI サーバアダプタ・物理ストレージを所有、クライアントの vSCSI イニシエータが標準 SCSI LUN としてアクセス。バッキング種別: 論理ボリューム (LV) / 物理ボリューム (PV) / ファイル / 共用ストレージ・プール (SSP) 上の LU。光ディスク (CD-ROM / DVD-RAM / DVD-ROM)、磁気テープ、USB マスストレージも対象。シック/シン・プロビジョニング、永続予約 (persistent reservation) サポート。 | ODM, vhost adapter | S17, S7 |
| Virtual Fibre Channel / NPIV (N_Port ID Virtualization) | クライアント LPAR を物理 FC アダプタ越しに直接 SAN へ | 1 枚の物理 FC アダプタを複数 LPAR で共有しつつ、各 LPAR に独立した WWPN を割当て。VIOS 側に vfchost、クライアント側に vfclient を作成。LPM（Live Partition Mobility）連携、port-level validation、QoS（4.1.2.00 で Tech Preview として VFC IOPS / Bandwidth 制御）対応。 | PowerVM, FC アダプタ | S7, S6, S25 |
| Shared Ethernet Adapter (SEA) | 仮想 Ethernet と物理 Ethernet を橋渡し | VIOS 内で仮想スイッチ trunk と物理 NIC を Layer-2 ブリッジ。Multi-VIOS 構成で SEA failover によるパッシブ／アクティブ冗長化が可能。SSP 構成では SEA は Threaded mode 必須（Interrupt mode 非サポート）。4.1.2.00 で SEA accounting オーバヘッド削減。 | Virtual Ethernet, VLAN, Link Aggregation | S25, S3, S8 |
| Shared Storage Pool (SSP) クラスター | 複数 VIOS でストレージプールを共有 | 1〜16 VIOS ノード（高スペック構成で最大 24 ノード）。物理ディスク 1〜1024、最大 8192 LU マッピング、最大 2000 クライアント LPAR/クラスタ。リポジトリディスク 1 本（10〜1016 GB）、データディスク最低 1 本以上。シン・プロビジョニング、SSP Rolling Upgrade（全ノード 4.1.x 到達後に自動でクラスタサービス更新）対応。 | vSCSI, クラスタ | S3, S23, S17 |
| padmin CLI / RBAC | VIOS 管理者シェルとロール | padmin が既定の管理ユーザで ksh93 を使用。AIX RBAC ベースで root 系コマンド実行を制御。4.1.2.00 で mkitab/lsitab/rmitab/chitab および pvi（vios.file.read / vios.file.write 認可で /etc/syslog.conf 等の編集）が RBAC 対応。 | AIX RBAC, ksh93 | S23, S6 |
| viosupgrade ツール | メジャーバージョン upgrade (3.1.x → 4.1.x) | 既存 rootvg をクローンして新バージョンを別ディスクへインストール。-F devname で vfchost/vhost/fcnvme/nvme/fscsi/iSCSI/hdisk/network adapter のデバイス名を保持、-k / -o rerun で pre-restore script を制御、-i で mksysb / ISO 両対応、-noprompt で対話プロンプトをスキップ、-skipdevname でデバイス名保持を無効化、-g で構成ファイル退避。HMC GUI / NIM / padmin の 3 経路で実行可能。 | viosbr, mksysb | S18, S3, S5, S4, S23 |
| updateios コマンド | 同一メジャー内の Update / Service Pack 適用 | ioslevel を上げる際の標準ツール（例: 3.1.X → 3.1.Y、4.1.X → 4.1.Y）。4.1.2.00 で -altdisk オプション追加（rootvg を代替ディスクへクローンしてからアップデート、ロールバック容易）。-listlang / -rmlang / -preserve で不要言語メッセージ fileset 削除。 | rootvg, fix pack | S20, S6, S5, S4 |
| viosbr / virtual I/O 構成バックアップ | vSCSI / NPIV / SEA など仮想 I/O 構成のバックアップとリストア | viosbr -backup で構成 XML 保存、viosbr -restore で復元。同一 PV を複数 vhost にマップしている全 PV-backed VTD のリストア対応（4.1.0.40〜）、複数 iSCSI controller のリストア対応、-skip security_config で security 構成のリストアを除外（4.1.1.10〜）。 | vSCSI mapping, NPIV mapping | S23, S3, S5 |
| alt_root_vg | 代替 rootvg のクローニングと更新 | 4.1.0.40 以降、cloning フェーズと update フェーズを分離して段階実行可能。安全なロールバック起点を確保しつつ更新作業を進められる。 | rootvg, viosupgrade | S3, S23 |
| Trusted Execution / Trusted Update / Secure Boot | 署名ベースの実行・更新整合性管理 | 4.1.0.30 / 4.1.0.40 から VIOS で Secure Boot 対応（admin 許可プログラムと Kernel Extensions のみ実行可）。Trusted Update は IBM 署名済イメージのみによる fileset 更新を保証。 | AIX セキュリティ, hdcryptmgr | S23, S3 |
| hdcryptmgr / LVM 暗号化 | rootvg / dump / 物理ボリューム暗号化 | rootvg と dump デバイスの LVM 暗号化、SCSI プロトコル経由の物理ボリューム暗号化を hdcryptmgr で管理。AIX 7.3 ベースの暗号化機構を継承。 | AIX LVM, AIX Key Manager | S23, S3 |
| viosecure / firewall | VIOS の Stateful firewall 管理 | viosecure -firewall で許可／拒否ルールを管理。4.1.2.00 でサブネット範囲（IP アドレス + サブネット）単位の allow/deny ルール対応。 | セキュリティ, ネットワーク | S25, S6 |
| VIOS Expansion Pack | ベース外オプション fileset 群 | ベース DVD/Flash イメージに含まれない追加 fileset を提供（例: 4.1.2.00 では bind.rte = BIND 9.x DNS）。Expansion Pack 適用時は updateios で本体と Expansion Pack を併せて更新する。 | fileset 管理 | S6, S25 |
| Virtual Media Library | ISO / 光ディスクイメージのリポジトリ | mkvopt で ISO を Virtual Media Library に登録。4.1.1.x で NFS マウント ISO 対応（-nfslink オプションで NFS サーバ上の ISO へシンボリックリンク作成）。NFSv3 / v4 両対応、複数 VIOS 間でイメージを共有可能。 | 光ディスク, NFS | S5, S4 |
| Paging VIOS Partition | PowerVM Active Memory Sharing 用ページング機能 | POWER8 環境での AMS 連動。POWER10 以降の AMS 非サポート、および VIOS 4.1 以降の AMS 非サポートに伴い役割は縮小。AMS 利用環境のアップグレード前には un-configure 必須。 | AMS, POWER8 | S7, S6 |
| Integrated Virtualization Manager (IVM) | HMC 不在環境の Web 管理 UI | POWER8 + 単独 VIOS 環境で、HMC を導入せずに Web ブラウザベースで仮想化管理を行うための機能。POWER9 以降では非サポート（HMC 必須）。 | Web UI, POWER8 | S8 |
| Electronic Service Agent / FLRT | サービスサポート連携 | FLRT (Fix Level Recommendation Tool) for Power System で機種・現行 ioslevel から推奨 Update / Upgrade 取得。Fix Central から Fix Pack をダウンロード、ESS（Entitled Systems Support）から VIOS 4.1 インストール媒体を取得。 | Fix Central, ESS | S20, S21 |

