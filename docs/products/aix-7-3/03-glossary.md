# AIX 7.3 — 用語集（網羅・168 件）

AIX 固有概念 + 略号 + 主要コマンド名。

| 用語 | 読み | 定義 | 略称・別称 | 関連 | 出典 |
|---|---|---|---|---|---|
| AIX | エーアイエックス | IBM Power Systems 上で稼働する 64-bit エンタープライズ UNIX OS | Advanced Interactive eXecutive |  | S35 |
| LPAR | エルパー | ハードウェア資源を論理分割して複数 OS を独立稼働させる単位 | Logical Partition | PowerVM, HMC, WPAR | S35 |
| DLPAR | ディーエルパー | 稼働中 LPAR の CPU/メモリ/IO を動的に増減させる機能 | Dynamic Logical Partitioning | PowerVM, HMC, WPAR | S35 |
| WPAR | ダブリュパー | 単一カーネル上で OS レベル隔離を実現する AIX のコンテナ機能 | Workload Partition |  | S35 |
| VIOS | ヴィオス | Power VM 上で IO デバイス共有を提供する専用 LPAR | Virtual I/O Server |  | S35 |
| PowerVM | パワーブイエム | IBM Power サーバの仮想化ハイパーバイザ | Power Virtualization Manager |  | S35 |
| PowerHA | パワーエイチエー | AIX 上の高可用クラスタ製品（旧 HACMP） | Power High Availability SystemMirror |  | S35 |
| SMIT | スミット | AIX のメニュー駆動システム管理 TUI | System Management Interface Tool |  | S35 |
| smitty | スミッティ | SMIT の文字端末モード起動コマンド | SMIT TTY-mode |  | S35 |
| ODM | オーディーエム | AIX の構成情報を保持するオブジェクト指向 DB | Object Data Manager |  | S35 |
| TL | ティーエル | AIX のメジャー保守単位（年次更新） | Technology Level |  | S35 |
| SP | エスピー | TL 内の累積パッチ単位 | Service Pack |  | S35 |
| JFS2 | ジェイエフエス2 | AIX の既定ジャーナリング FS（最大 128 TB） | Enhanced Journaled File System | ストレージ, JFS2 | S35 |
| JFS | ジェイエフエス | JFS2 以前の旧 FS | Journaled File System (legacy) |  | S35 |
| LVM | エルブイエム | 物理ボリュームを論理ボリュームに抽象化する OS 機能 | Logical Volume Manager | ストレージ, JFS2 | S35 |
| VG | ブイジー | 物理ボリュームの集合体 | Volume Group | ストレージ, JFS2 | S35 |
| PV | ピーブイ | LVM 配下の物理ディスク（hdiskN） | Physical Volume | ストレージ, JFS2 | S35 |
| LV | エルブイ | VG 内に作る論理ディスク | Logical Volume | ストレージ, JFS2 | S35 |
| PP | ピーピー | VG の最小割当て単位 | Physical Partition | ストレージ, JFS2 | S35 |
| LP | エルピー | LV を構成する PP マッピング単位 | Logical Partition (LVM) |  | S35 |
| CAA | シーエーエー | OS レベルクラスタリング機構（PowerHA 基盤） | Cluster Aware AIX |  | S35 |
| RSCT | アールエスシーティー | AIX 同梱のクラスタ基盤フレームワーク | Reliable Scalable Cluster Technology |  | S35 |
| NIM | ニム | AIX の集中インストール管理 | Network Installation Management |  | S35 |
| SPOT | スポット | NIM クライアント用の共有ブートイメージ | Shared Product Object Tree |  | S35 |
| LPP | エルピーピー | IBM ライセンスプログラム製品の総称 | Licensed Program Product |  | S35 |
| LPP_SOURCE | エルピーピーソース | NIM 配信用のソフトウェア媒体格納ディレクトリ | LPP Source (NIM resource) |  | S35 |
| BOS | ビーオーエス | AIX OS の中核（bos.* fileset） | Base Operating System |  | S35 |
| RBAC | アールバック | ロールベースアクセス制御。AIX 7.3 で Domain RBAC が拡張 | Role-Based Access Control | Security | S35 |
| MPIO | エムピーアイオー | ストレージ多重経路アクセス機構 | Multipath I/O | ストレージ, FC | S35 |
| PCM | ピーシーエム | MPIO のパス制御モジュール | Path Control Module | ストレージ, FC | S35 |
| AAPCM | エーエーピーシーエム | アクティブ/アクティブ MPIO 用 PCM | AIX Active/Active Path Control Module | ストレージ, FC | S35 |
| SDD | エスディーディー | 旧 IBM ストレージドライバ（AIX 7.3 で削除） | Subsystem Device Driver | ストレージ, FC | S35 |
| SDDPCM | エスディーディーピーシーエム | SDD ベースの PCM | SDD Path Control Module | ストレージ, FC | S35 |
| PKS | ピーケーエス | PowerVM ファームウェア内の鍵保管領域 | Platform KeyStore |  | S35 |
| HMC | エイチエムシー | Power サーバ管理コンソール | Hardware Management Console |  | S35 |
| FSM | エフエスエム | Flex System のシステム管理コンソール | Flex System Manager |  | S35 |
| POWER | パワー | IBM Power プロセッサアーキテクチャ | Performance Optimization With Enhanced RISC |  | S35 |
| SMT | エスエムティー | 1コアで複数論理スレッド実行（Power10 で SMT8 まで） | Simultaneous MultiThreading |  | S35 |
| NUMA | ヌーマ | メモリアクセス遅延が CPU 距離に依存するアーキテクチャ | Non-Uniform Memory Access |  | S35 |
| AME | エーエムイー | メモリ圧縮で実装メモリを論理拡張する機能 | Active Memory Expansion |  | S35 |
| AMS | エーエムエス | 複数 LPAR 間で物理メモリを動的共有 | Active Memory Sharing |  | S35 |
| ASO | エーエスオー | ワークロード自動最適化機構 | Active System Optimizer |  | S35 |
| DSO | ディーエスオー | ASO のサブセット（TL1 で ASO に統合） | Dynamic System Optimizer |  | S35 |
| SCSI | スカジー | ストレージ標準インタフェース | Small Computer System Interface |  | S35 |
| FC | エフシー | ストレージエリアネットワーク用伝送方式 | Fibre Channel |  | S35 |
| NPIV | エヌピーアイブイ | FC HBA の論理仮想化機構 | N_Port ID Virtualization |  | S35 |
| SR-IOV | エスアールアイオーブイ | PCIe デバイスの SR レベル仮想化 | Single Root I/O Virtualization |  | S35 |
| IPMP | アイピーエムピー | ネットワーク多重経路機構 | IP MultiPathing |  | S35 |
| EtherChannel | イーサチャネル | 物理 NIC のリンク集約機能 | Link aggregation in AIX |  | S35 |
| SEA | シーエー | VIOS が提供する共有 Ethernet | Shared Ethernet Adapter |  | S35 |
| VLAN | ブイラン | タグ VLAN（IEEE 802.1Q） | Virtual LAN |  | S35 |
| SMB | エスエムビー | Windows ファイル共有プロトコル | Server Message Block |  | S35 |
| NFS | エヌエフエス | UNIX 系標準ファイル共有プロトコル | Network File System |  | S35 |
| SMBFS | エスエムビーエフエス | 旧 CIFS の AIX クライアント実装 | SMB File System (SMB 1.0 client) |  | S35 |
| SSH | エスエスエイチ | 暗号化リモート接続プロトコル | Secure Shell | ネットワークセキュリティ | S35 |
| OpenSSH | オープンエスエスエイチ | SSH 標準実装（AIX 7.3 既定 9.7p1） | OpenBSD Secure Shell |  | S35 |
| OpenSSL | オープンエスエスエル | TLS / 暗号ライブラリ（AIX 7.3 = 3.0 系） | Open Secure Sockets Layer | ネットワークセキュリティ | S35 |
| TCP | ティーシーピー | コネクション型ネットワーク層プロトコル | Transmission Control Protocol |  | S35 |
| UDP | ユーディーピー | コネクションレス型ネットワーク層プロトコル | User Datagram Protocol |  | S35 |
| BIND | バインド | DNS リゾルバ・サーバ実装（AIX 7.3 = 9.18） | Berkeley Internet Name Domain |  | S35 |
| NTP | エヌティーピー | 時刻同期プロトコル（AIX 7.3 で v4 のみ） | Network Time Protocol |  | S35 |
| DNS | ディーエヌエス | ホスト名解決システム | Domain Name System |  | S35 |
| LDAP | エルダップ | ディレクトリサービスプロトコル | Lightweight Directory Access Protocol |  | S35 |
| ISVD | アイエスブイディー | IBM 製 LDAP サーバ（旧 ISDS） | IBM Security Verify Directory |  | S35 |
| ISDS | アイエスディーエス | 旧 IBM 製 LDAP サーバ（EOS 2024/9） | IBM Security Directory Server |  | S35 |
| AD | エーディー | Microsoft 製ディレクトリサービス | Active Directory |  | S35 |
| PowerVC | パワーブイシー | Power サーバ向けクラウドプロビジョニング | Power Virtualization Center |  | S35 |
| LPM | エルピーエム | LPAR の無停止マイグレーション | Live Partition Mobility |  | S35 |
| LKU | エルケーユー | 業務無停止のカーネル更新 | Live Kernel Update |  | S35 |
| LLU | エルエルユー | 業務無停止の libc 等ライブラリ更新（TL3 新規） | Live Library Update |  | S35 |
| RDMA | アールディーエムエー | 高速リモートメモリアクセス機構 | Remote Direct Memory Access |  | S35 |
| RoCE | ロッキー | Ethernet 上の RDMA 実装 | RDMA over Converged Ethernet |  | S35 |
| InfiniBand | インフィニバンド | HPC 向け高速ネットワーク | InfiniBand network |  | S35 |
| SRC | エスアールシー | AIX のサブシステム制御フレームワーク（startsrc/stopsrc） | System Resource Controller |  | S35 |
| WLM | ダブリューエルエム | プロセスグループへのリソース割当て管理 | Workload Manager |  | S35 |
| EFS | イーエフエス | AIX のファイルレベル暗号化機能 | Encrypted File System |  | S35 |
| CCA | シーシーエー | IBM 製 HSM ベース暗号アーキテクチャ | Common Cryptographic Architecture |  | S35 |
| AIXPert | エイアイエックスパート | AIX のセキュリティ自動チューニングツール | AIX Security Expert | Security | S35 |
| TE | トラステッドエクスキューション | 実行ファイル整合性検証機構 | Trusted Execution | Security | S35 |
| TSD | ティーエスディー | Trusted Execution の署名 DB | Trusted Signature Database | Security | S35 |
| TLS | ティーエルエス | SSL の後継暗号通信プロトコル | Transport Layer Security | ネットワークセキュリティ | S35 |
| GSSAPI | ジーエスエスエーピーアイ | Kerberos 等を抽象化する認証 API | Generic Security Service API |  | S35 |
| AES | エーイーエス | 対称鍵暗号標準 | Advanced Encryption Standard |  | S35 |
| DH | ディーエッチ | 公開鍵共有アルゴリズム | Diffie-Hellman |  | S35 |
| DNF | ディーエヌエフ | RPM パッケージマネージャ（AIX 7.3 では YUM 非対応） | Dandified YUM |  | S35 |
| RPM | アールピーエム | Linux 系パッケージ形式 | RPM Package Manager |  | S35 |
| ESA | イーエスエー | ハードウェア障害自動 IBM 通知 | Electronic Service Agent |  | S35 |
| SUMA | スーマ | fix 自動取得ツール | Service Update Management Assistant |  | S35 |
| SWMA | エスダブリューエムエー | ソフトウェア保守契約 | Software Maintenance Agreement |  | S35 |
| iSCSI | アイスカジー | TCP/IP 上の SCSI | Internet Small Computer System Interface |  | S35 |
| VPN | ブイピーエヌ | 暗号化トンネル | Virtual Private Network |  | S35 |
| IPsec | アイピーセック | IP 層暗号化 | Internet Protocol Security | ネットワークセキュリティ | S35 |
| IKEv2 | アイケーイーブイツー | IPsec 鍵交換プロトコル | Internet Key Exchange v2 | ネットワークセキュリティ | S35 |
| MWC | エムダブリューシー | LV ミラーリング整合性 | Mirror Write Consistency |  | S35 |
| MWCC | エムダブリューシーシー | MWC キャッシュ機構（lvmstat で観測） | Mirror Write Consistency Cache |  | S35 |
| PowerSC | パワーエスシー | Power 環境向けセキュリティ統合製品 | Power Security and Compliance |  | S35 |
| VMM | ブイエムエム | AIX のページング・メモリ管理 | Virtual Memory Manager |  | S35 |
| CHRP | シーエッチアールピー | Power の共通ハードウェアリファレンス | Common Hardware Reference Platform |  | S35 |
| TPMD | ティーピーエムディー | tunable 自動制御デーモン | Tunables Performance Management Daemon |  | S35 |
| ASMI | エーエスエムアイ | Power サーバの BMC 相当管理 IF | Advanced System Management Interface |  | S35 |
| OPAL | オパール | オープンソース OS 用の Power 抽象化層 | Open Power Abstraction Layer |  | S35 |
| PHYP | パイプ | Power のハードウェアハイパーバイザ | POWER Hypervisor |  | S35 |
| FW | ファームウェア | ハードウェア組み込みプログラム | Firmware |  | S35 |
| POST | ポスト | 起動時自己診断 | Power-On Self Test |  | S35 |
| errpt | エラーピーティー | AIX のエラーログ要約コマンド | error report |  | S35 |
| errdemon | エラーデーモン | AIX のエラー集中ログ書き込みデーモン | error daemon |  | S35 |
| diag | ダイアグ | AIX のハードウェア診断コマンド | diagnostic |  | S35 |
| snap | スナップ | AIX のサポート提供データ収集ツール | snap |  | S35 |
| trace | トレース | AIX のカーネルトレース機構 | system trace |  | S35 |
| topas | トパス | AIX 標準のリアルタイム性能モニタ | top + AIX |  | S35 |
| lparstat | エルパースタット | LPAR レベル CPU 統計コマンド | LPAR stat |  | S35 |
| mpstat | エムピースタット | CPU毎の統計情報 | multi-processor stat |  | S35 |
| vmstat | ブイエムスタット | VMM ページング統計 | VM stat |  | S35 |
| iostat | アイオースタット | I/O 統計 | I/O stat |  | S35 |
| netstat | ネットスタット | ネットワーク統計 | network stat |  | S35 |
| sar | エスエーアール | 累積系の系統別統計レポート | system activity report |  | S35 |
| rmss | アールエムエスエス | メモリ縮退シミュレータ | Reduced Memory System Simulator |  | S35 |
| alog | エーログ | AIX 早期ブートログ機構 | AIX log |  | S35 |
| cron | クロン | 定期実行スケジューラ | Command run on |  | S35 |
| chdev | シーエッチデブ | デバイス属性変更コマンド | change device |  | S35 |
| lsdev | エルエスデブ | デバイス一覧表示コマンド | list device |  | S35 |
| lsattr | エルエスアトル | 属性一覧表示コマンド | list attribute |  | S35 |
| rmdev | アールエムデブ | デバイス削除コマンド | remove device |  | S35 |
| mkdev | エムケーデブ | デバイス作成コマンド | make device |  | S35 |
| cfgmgr | シーエフジーエムジーアール | ODM デバイス自動構成コマンド | configuration manager |  | S35 |
| installp | インストールピー | AIX fileset インストールコマンド | install package |  | S35 |
| lslpp | エルエスエルピーピー | fileset 一覧表示 | list licensed program product |  | S35 |
| oslevel | オーエスレベル | OS レベル取得 | operating system level |  | S35 |
| bosboot | ボスブート | ブート LV 再生成 | BOS boot |  | S35 |
| bootlist | ブートリスト | ブート優先順序設定 | boot list |  | S35 |
| alt_disk_install | オルトディスクインストール | 代替ディスクへの並行インストール | alternate disk install |  | S35 |
| mksysb | エムケーシスビー | ブート可能な OS バックアップ生成 | make system backup |  | S35 |
| savevg | セーブブイジー | VG バックアップコマンド | save VG |  | S35 |
| restvg | レストアブイジー | VG リストアコマンド | restore VG |  | S35 |
| mkwpar | エムケーダブリューパー | WPAR 作成 | make WPAR |  | S35 |
| lswpar | エルエスダブリューパー | WPAR 一覧 | list WPAR |  | S35 |
| startwpar | スタートダブリューパー | WPAR 起動 | start WPAR |  | S35 |
| clogin | シーログイン | WPAR への login | container login |  | S35 |
| clmgr | シーエルエムジーアール | CAA / PowerHA クラスタ管理 | cluster manager |  | S35 |
| ioo | アイオーオー | JFS2/AIO/VMM I/O tunable 管理コマンド | I/O options |  | S35 |
| no | エヌオー | TCP/IP tunable 管理コマンド | network options |  | S35 |
| schedo | スケジューオー | スケジューラ tunable 管理コマンド | scheduler options |  | S35 |
| vmo | ブイエムオー | VMM tunable 管理コマンド | VMM options |  | S35 |
| raso | ラソオー | RAS tunable 管理コマンド | RAS options |  | S35 |
| tunsave | チューンセーブ | 現在の tunable 値の保存 | tune save |  | S35 |
| tunrestore | チューンレストア | tunable 値の復元 | tune restore |  | S35 |
| geninstall | ジェンインストール | installp/RPM 統合インストール | general install |  | S35 |
| genfs | ジェンエフエス | 汎用 FS 操作（NIM 関連） | generic filesystem |  | S35 |
| nimadm | ニムエーディーエム | NIM 経由代替ディスクマイグレーション | NIM alternate disk migration |  | S35 |
| lparstat -i | エルパースタットアイ | LPAR 設定詳細表示 | LPAR information |  | S35 |
| lkupdate | エルケーアップデート | LKU 実行コマンド | Live Kernel Update |  | S35 |
| error ID | エラーアイディー | 32bit CRC 16進コードでエラーを一意識別。各エラーレコードテンプレートに固有 |  | errpt, errlogger | S45 |
| error label | エラーラベル | error ID のニーモニック名 |  | errpt -j | S45 |
| error log | エラーログ | システムが検出したエラー・障害を蓄積するファイル（HW=90日 / SW=30日で自動削除） |  | errdemon, errclear | S45 |
| error log entry | エラーログエントリ | エラーログ内の1レコード。HW障害・SW障害・オペレータメッセージを記録 |  | errpt | S45 |
| error record template | エラーレコードテンプレート | エラーログをレポート整形するための雛形。type/class/probable causes/recommended actions を含む |  | Error Record Template Repository | S45 |
| errnotify | エラーノーティファイ | 特定エラーで通知/動作を発火させる ODM オブジェクトクラス |  | odmadd | S45 |
| snap.pax.gz | スナップパックスジーゼット | snap コマンドが既定で生成するサポート提供アーカイブ |  | snap | S35 |
| image.data | イメージデータ | NIM の base+update 混在 LPP_SOURCE で SPOT 作成時に必須となるリソース |  | NIM, SPOT | S35 |
| bosinst.data | ボスインストデータ | NIM/BOS インストールの応答ファイル。ACCEPT_LICENSES 等を記述 |  | NIM | S35 |
| hdcryptmgr | エッチディークリプトエムジーアール | 暗号化LV/PV の鍵運用コマンド（PKS 移行・passphrase 管理） |  | PKS, EFS | S35 |
| pksctl | ピーケーエスシーティーエル | PKS（Platform KeyStore）操作コマンド |  | PKS | S35 |
| clogin | シーログイン | WPAR にコンテナログイン |  | WPAR | S75 |
| manage_disk_drivers | マネージディスクドライバーズ | AIX のディスクドライバ（AIX_FCPARRAY / AIX_AAPCM 等）切替コマンド |  | MPIO, SDD migration | S35 |
| trustchk | トラストチェック | Trusted Execution の整合性チェックコマンド |  | TE, tepolicies.dat | S35 |
| premigration script | プレマイグレーションスクリプト | 7.1/7.2 から 7.3 へのマイグレーション前に実行する事前点検スクリプト |  | migration | S35 |
| 144 I/O slot 制約 | いちよんよんアイオースロット | AIX 7.3 ファームウェアメモリ容量制約。bootable デバイスは Bus 順最初の 144 I/O slot 内に配置 |  | bootlist, MPIO | S35 |
| hd5 | エッチディーファイブ | AIX のブート LV。最小 40 MB、ディスク先頭 4GB 内連続パーティション |  | bosboot | S35 |

[← AIX 7.3 トップへ](index.md)
