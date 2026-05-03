# AIX 7.3 — 用語集（網羅・104 件）

AIX 固有概念 + 略号 + 主要コマンド名。各定義は「何のための概念か / どこで使うか / 関連用語との違い」を含むよう拡張済（v3 で「読み」列を削除し、定義を充実）。

## カテゴリ別件数

| カテゴリ | 件数 |
|---|---|
| HA | 3 |
| HW | 3 |
| HW/性能 | 2 |
| OS | 2 |
| tunable | 5 |
| コマンド | 11 |
| ストレージ | 15 |
| セキュリティ | 13 |
| ネットワーク | 6 |
| パッケージ | 1 |
| ブート | 2 |
| 仮想化 | 8 |
| 仮想化/ストレージ | 1 |
| 仮想化/ネット | 2 |
| 性能 | 7 |
| 版数 | 2 |
| 環境変数 | 2 |
| 管理 | 3 |
| 運用 | 10 |
| 障害 | 6 |

## 全用語

| 用語 | カテゴリ | 略称 / 別称 | 定義 | 関連 | 関連手順 | 出典 |
|---|---|---|---|---|---|---|
| **AIX** | OS | Advanced Interactive eXecutive | IBM Power Systems 上で稼働する 64bit エンタープライズ UNIX OS。基幹業務 OLTP・統合基盤・HA クラスタの土台として使われる。Linux on Power は別 OS（共存可）。 | Power Systems, PowerVM | — | S35 |
| **LPAR** | 仮想化 | Logical Partition | Power サーバの CPU/メモリ/IO を OS 単位で論理分割したもの。1 物理サーバ上で複数の AIX/Linux/IBM i を独立稼働させる単位。VIOS や PowerHA も LPAR 上で動く。WPAR が「OSの中の OS 隔離」なのに対し LPAR は「ハードウェアの分割」。 | DLPAR, WPAR, PowerVM | — | S72 |
| **DLPAR** | 仮想化 | Dynamic Logical Partitioning | 稼働中 LPAR の CPU/メモリ/IO スロットを再起動なしで増減できる機能。ピーク負荷時の動的拡張・夜間縮退に使う。HMC からトリガし、AIX 側のドライバ・カーネルが受け取って反映する。 | LPAR, HMC, LPM | — | S72 |
| **WPAR** | 仮想化 | Workload Partition | 単一の AIX カーネル上で OS レベル隔離を実現する AIX 固有のコンテナ機構。Solaris Zones / Linux container に似る。LPAR より軽量だが性能チューニング・SAN 直接アクセスに制約。system WPAR と application WPAR の 2 種類がある。 | LPAR, WLM | [WPAR 作成 + WLM クラス連携](08-config-procedures.md#cfg-wpar-create)<br>[PowerSC Trusted Surveyor 残存で migration ブロック](09-incident-procedures.md#inc-powersc-ts-block) | S75 |
| **VIOS** | 仮想化 | Virtual I/O Server | PowerVM 上で物理 IO（FC/Ethernet/SCSI）をクライアント LPAR に共有提供する専用 LPAR。AIX 派生だがライセンス・コマンド体系は別建て。SEA/NPIV/vSCSI の 3 種類のネットワーク・ストレージ仮想化を提供する。 | PowerVM, NPIV, SEA | — | S35 |
| **PowerVM** | 仮想化 | Power Virtualization Manager | IBM Power サーバのハードウェア仮想化スタック（ハイパーバイザ + VIOS + HMC）の総称。LPAR/DLPAR/LPM/AME はすべて PowerVM の機能。AIX は「PowerVM の上で動く客 OS」という位置付け。 | VIOS, HMC, LPAR | — | S35 |
| **PowerHA** | HA | Power High Availability SystemMirror | AIX 上で稼働する高可用性クラスタ製品（旧 HACMP）。RSCT 3.3.0.0 と Cluster Aware AIX をベースに、リソースグループとフェイルオーバーポリシーを管理する。SystemMirror は商標、コマンドは clmgr 系。 | RSCT, CAA | [Cluster Aware AIX リポジトリディスク構築](08-config-procedures.md#cfg-cluster-aware-aix) | S6 |
| **SMIT** | 運用 | System Management Interface Tool | AIX のメニュー駆動システム管理 TUI。ほぼ全管理コマンドのフロントエンドで、smit / smitty どちらでも起動できる。実行ログが /smit.log と /smit.script に残るので、内部で叩かれた actual command を後から確認できるのが運用上有用。 | smitty, ODM | — | S24 |
| **ODM** | 運用 | Object Data Manager | AIX 固有のシステム構成情報を保持するオブジェクト指向 DB。デバイス属性（CuDv/CuAt/PdDv/PdAt）、エラーテンプレート、SRC サブシステム情報を保存する。Linux の sysfs + udev DB に相当するが、odmadd/odmget で直接編集可能なのが大きな違い。 | CuDv, CuAt, PdDv, errnotify | — | S12 |
| **TL** | 版数 | Technology Level | AIX のメジャー保守単位（年次更新）。AIX 7.3 → 7.3.1 → 7.3.2 → 7.3.3 のように増える。新ハードウェア・新機能・廃止フィーチャの境目になる。SP（Service Pack）は TL 内の累積パッチ。oslevel -s で TL/SP まで取得できる。 | SP, oslevel | — | S35 |
| **SP** | 版数 | Service Pack | TL 内の累積パッチ単位。TL3 SP1 のように TL 番号 + SP 番号で表記。CSP（Concluding Service Pack）は次の TL リリース後に出る最終 SP。 | TL, oslevel | — | S35 |
| **JFS2** | ストレージ | Enhanced Journaled File System | AIX の既定ジャーナリングファイルシステム。最大ファイルサイズ・FS サイズ 128 TB、INLINE log 既定、LV 暗号化対応、snapshot/quota 機能。旧 JFS（既存だが新規作成は JFS2 推奨）と異なり 64bit inode、大容量対応。 | LVM, EFS, snapshot | [低メモリ機（4GB 以下）で多数同時 open file 障害](09-incident-procedures.md#inc-low-mem-cache-thrash) | S66 |
| **LVM** | ストレージ | Logical Volume Manager | AIX の論理ボリューム管理レイヤ。物理ディスク (PV) を VG にまとめ、その上に LV を切り出す。Linux の LVM2 に相当する概念だが、scalable VG では既定 1024 PV / 256 LV / 32768 PP まで拡張可能。 | VG, PV, LV, PP | — | S40 |
| **VG** | ストレージ | Volume Group | 物理ボリュームの集合体。rootvg は OS 用 VG、それ以外は datavg などユーザ命名。stale な PV を含む VG は import/export で別マシンへ移送できる。 | PV, LV, varyonvg | — | S40 |
| **PV** | ストレージ | Physical Volume | LVM 配下の物理ディスク（hdiskN）。ODM の CuDv にも登録される。MPIO 配下のときは hdisk + path の組み合わせで管理される。 | VG, MPIO, hdisk | — | S40 |
| **LV** | ストレージ | Logical Volume | VG 内に作る論理ディスク。OS インストール時に hd5/hd2/hd9var 等が自動作成される。boot LV (hd5) はディスク先頭 4GB 内連続パーティションで配置必須。 | VG, JFS2, hd5 | — | S40 |
| **PP** | ストレージ | Physical Partition | VG の最小割当単位（既定 4MB～)。LV はこの PP の集合として割り当てられる。LP（Logical Partition）は LV 側からみた同じ単位で、ミラー時は 1 LP = 複数 PP の写像になる。 | VG, LV, LP, MWC | — | S40 |
| **LP (LVM)** | ストレージ | Logical Partition (LVM 用語) | LV 側の最小単位。1 LV = N LP。ミラーリング時 1 LP = 2-3 PP（コピー数だけ）。電源障害時の整合性は MWC (Mirror Write Consistency) で確保。 | PP, MWC, MWCC | — | S40 |
| **CAA** | HA | Cluster Aware AIX | OS レベルのクラスタリング機構。PowerHA の前提となるリポジトリディスク・ノードメンバーシップ管理を提供する。TL3 から NVMe ディスクをリポジトリとして利用可能。clmgr / lscluster / mkcluster で操作。 | PowerHA, RSCT | [Cluster Aware AIX リポジトリディスク構築](08-config-procedures.md#cfg-cluster-aware-aix) | S6 |
| **RSCT** | HA | Reliable Scalable Cluster Technology | AIX 同梱のクラスタ基盤フレームワーク。AIX 7.3 同梱は 3.3.0.0。VSD/LAPI 機能は廃止（rsct.vsd / rsct.lapi.rte は削除必須）、互換 .sp / .hacmp fileset も shipping 停止。PowerHA / DB2 PureScale / Spectrum Scale 等が使う。 | CAA, PowerHA | [Cluster Aware AIX リポジトリディスク構築](08-config-procedures.md#cfg-cluster-aware-aix)<br>[rsct.vsd / rsct.lapi.rte が AIX 7.3 で install 不能](09-incident-procedures.md#inc-rsct-vsd-block) | S35 |
| **NIM** | 運用 | Network Installation Management | ネットワーク経由で AIX を集中インストール・管理する仕組み。bos.sysmgt.nim.master fileset を NIM サーバに導入。LPP_SOURCE と SPOT を組み合わせて bootp で client を立ち上げる。base+update 混在 LPP_SOURCE では image_data resource が必須。 | SPOT, LPP, bosinst.data, mksysb | [NIM サーバ構築 + LPP_SOURCE 整備](08-config-procedures.md#cfg-nim-server-build)<br>[NIM SPOT 作成時 missing image エラー](09-incident-procedures.md#inc-nim-spot-missing-image) | S18 |
| **SPOT** | 運用 | Shared Product Object Tree | NIM クライアントがネットワークブートで使う共有ブートイメージ。LPP_SOURCE から作成し、複数クライアントで共有する。base + update 混在で作る場合、image_data resource を NIM master に登録しないと missing image エラーで失敗する。 | NIM, LPP_SOURCE | [NIM サーバ構築 + LPP_SOURCE 整備](08-config-procedures.md#cfg-nim-server-build)<br>[NIM SPOT 作成時 missing image エラー](09-incident-procedures.md#inc-nim-spot-missing-image) | S18 |
| **LPP** | 運用 | Licensed Program Product | IBM ライセンスプログラム製品の総称。AIX の fileset 名（bos.* / sysmgt.* 等）でも使う。LPP_SOURCE は NIM の一形態で、updates と base media の集合体。 | LPP_SOURCE, installp | [NIM サーバ構築 + LPP_SOURCE 整備](08-config-procedures.md#cfg-nim-server-build) | S18 |
| **BOS** | OS | Base Operating System | AIX OS の中核（カーネル・基本ライブラリ・基本コマンド）。bos.* fileset 群を介して提供される。AIX 7.3 では bos.net.tcp.client/server が分割され 31 fileset 化された。 | fileset, installp | — | S35 |
| **RBAC** | セキュリティ | Role-Based Access Control | ロールベースアクセス制御。AIX 7.3 では Trusted AIX が削除され、Domain RBAC が代替（fine-grained 権限分離）。lsroles / mkrole / swrole で操作。authorization と privilege の組合せで「root 権限を分割して付与」する設計。 | Domain RBAC, AIXPert | [AIXPert で security policy 適用](08-config-procedures.md#cfg-aixpert-policy)<br>[Trusted AIX 残存で AIX 7.3 マイグレーション失敗](09-incident-procedures.md#inc-trusted-aix-migration-block) | S61 |
| **MPIO** | ストレージ | Multipath I/O | ストレージ多重経路アクセス機構。複数 FC パス経由で同じ LUN を hdisk として認識する。AIX 7.3 で reserve_policy=no_reserve / algorithm=shortest_queue / queue_depth=64(DS8000) が既定に変更された。 | PCM, AAPCM, lspath | [MPIO 既定値の調整（reserve_policy / algorithm / queue_depth）](08-config-procedures.md#cfg-mpio-defaults)<br>[SDD 依存ストレージで AIX 7.3 起動後に MPIO 不能](09-incident-procedures.md#inc-sdd-multipath-broken)<br>[144 I/O slot 越えのデバイスから boot 不可](09-incident-procedures.md#inc-144slot-boot-fail) | S35 |
| **PCM** | ストレージ | Path Control Module | MPIO のパス制御モジュール。ストレージベンダごとに固有の PCM を持つ（AIX_AAPCM/SDDPCM 等）。AIX 7.3 で SDD は削除されたため、SDD 利用環境は manage_disk_drivers で AIX_AAPCM へ移行する。 | MPIO, manage_disk_drivers | [MPIO 既定値の調整（reserve_policy / algorithm / queue_depth）](08-config-procedures.md#cfg-mpio-defaults) | S35 |
| **AAPCM** | ストレージ | AIX Active/Active Path Control Module | アクティブ/アクティブ MPIO 用の PCM。AIX 7.3 で SDD/SDDPCM 互換 PCM の代替標準。manage_disk_drivers AIX_FCPARRAY → AIX_AAPCM の置換が migration の主作業。 | MPIO, PCM, SDD | [MPIO 既定値の調整（reserve_policy / algorithm / queue_depth）](08-config-procedures.md#cfg-mpio-defaults)<br>[SDD 依存ストレージで AIX 7.3 起動後に MPIO 不能](09-incident-procedures.md#inc-sdd-multipath-broken) | S35 |
| **SDD** | ストレージ | Subsystem Device Driver | 旧 IBM ストレージ用 multipath ドライバ。AIX 7.3 で完全削除されたため、起動前に AIX_AAPCM か SDDPCM へ移行が必要。AIX 7.2 以前から 7.3 へマイグレーションする時の主要な事前作業の 1 つ。 | SDDPCM, AAPCM, manage_disk_drivers | [SDD 依存ストレージで AIX 7.3 起動後に MPIO 不能](09-incident-procedures.md#inc-sdd-multipath-broken) | S35 |
| **SDDPCM** | ストレージ | SDD Path Control Module | SDD ベースの PCM 形式。SDD 廃止後の互換窓口だが、新規構築では AIX_AAPCM 推奨。 | SDD, MPIO | [SDD 依存ストレージで AIX 7.3 起動後に MPIO 不能](09-incident-procedures.md#inc-sdd-multipath-broken) | S35 |
| **PKS** | セキュリティ | Platform KeyStore | PowerVM ファームウェア内の鍵保管領域（TL3 で導入）。Encrypted LV/PV や AIX Key Manager の鍵を保管し、起動時パスフレーズなしで復号可能にする。pksctl で操作。Power FW1030+ なら PKS への鍵移行可。 | EFS, hdcryptmgr | [rootvg の暗号化構築（PKS + passphrase）](08-config-procedures.md#cfg-encrypt-rootvg) | S35 |
| **HMC** | 管理 | Hardware Management Console | Power サーバのプラットフォーム管理コンソール。LPAR 構成・I/O slot 確認（144 slot 制約に注意）・LKU トリガ・PowerHA 連携を担う。GUI 版と REST API 版がある。 | ASMI, PowerVM | — | S35 |
| **POWER** | HW | Performance Optimization With Enhanced RISC | IBM Power プロセッサアーキテクチャ。AIX 7.3 は POWER8 / POWER9 / Power10 / Power11 をサポート（POWER8 互換以降のモード必須）。SMT, NUMA, AME 等の性能機能はすべて POWER 固有。 | SMT, NUMA, CHRP | — | S35 |
| **SMT** | HW/性能 | Simultaneous MultiThreading | 1コアで複数論理スレッドを同時実行する Power の機能。POWER8: SMT8、Power10: SMT8 まで。AIX からは smtctl で動的切替できる。スレッド数増は throughput 向上、SMT1 はラテンシ重視。 | POWER, smtctl | — | S25 |
| **NUMA** | HW/性能 | Non-Uniform Memory Access | メモリアクセスがプロセッサ距離に依存するアーキテクチャ。AIX は memory affinity / enhanced_memory_affinity で NUMA を意識した割当てを行う。複数 socket 機の Db2 / Oracle で性能差が出る箇所。 | memory_affinity, enhanced_memory_affinity | — | S25 |
| **AME** | 性能 | Active Memory Expansion | メモリ圧縮で実装メモリを論理拡張する機能。HMC で LPAR ごとに有効化し、amepat で expansion factor を提案させる。CPU を消費するため I/O bound より CPU 余裕がある OLAP 系向き。 | VMM, amepat | — | S25 |
| **AMS** | 性能 | Active Memory Sharing | 複数 LPAR 間で物理メモリを動的共有する PowerVM 機能。Hypervisor が paging 制御するため、VIOS にページングデバイスを用意する。 | PowerVM, VIOS | — | S35 |
| **ASO** | 性能 | Active System Optimizer | ワークロード自動最適化機構。large page 自動最適化、data stream prefetch 最適化、CPU/memory affinity 最適化を行う。TL1 以降 DSO は ASO に統合された。asoo で大域有効化、login.cfg でプロセス別除外。 | DSO, large page | — | S33 |
| **DSO** | 性能 | Dynamic System Optimizer | ASO の旧サブセット（TL1 で ASO に統合）。動的に large page / prefetch / affinity を最適化する機能群。現在は ASO の一部として動作。 | ASO | — | S33 |
| **FC** | ストレージ | Fibre Channel | ストレージエリアネットワーク用伝送方式。AIX では fcs / fscsi デバイスとして認識される。adapter 属性（num_cmd_elems/max_xfer_size/dyntrk/fast_fail）が性能・障害動作に大きく影響。 | NPIV, MPIO, hdisk | — | S12 |
| **NPIV** | 仮想化/ストレージ | N_Port ID Virtualization | FC HBA を論理仮想化し、複数 LPAR が個別の WWPN を持つ仮想 FC アダプタとして見せる仕組み。VIOS が仲介する。VIOS-vSCSI に比べて SAN ベースの管理が容易。 | VIOS, FC | — | S35 |
| **SR-IOV** | 仮想化/ネット | Single Root I/O Virtualization | PCIe デバイスの SR レベル仮想化（NIC/HBA を論理 VF に分割）。VIOS を経由しない直接 IO で性能ロスが少ない。 | PowerVM, vNIC | — | S35 |
| **EtherChannel** | ネットワーク | Link aggregation in AIX | 物理 NIC のリンク集約機能（LACP/Static）。冗長化と帯域束ね。AIX 専用名で、Linux で言う bond0 相当。smitty etherchannel で構成。 | VLAN, SEA | — | S52 |
| **SEA** | 仮想化/ネット | Shared Ethernet Adapter | VIOS が物理 Ethernet をクライアント LPAR と共有する仕組み。NPIV のネットワーク版。LACP EtherChannel と組み合わせて冗長化することが多い。 | VIOS, EtherChannel | — | S35 |
| **NFS** | ネットワーク | Network File System | UNIX 系標準ファイル共有プロトコル。AIX 7.3.1 以降は 16 TB 超ファイルに対応（最大 256 TB テスト済）。biod / nfsd / rpc.lockd / rpc.statd の各デーモンで構成。 | biod, nfsd, /etc/exports | — | S51 |
| **SMB** | ネットワーク | Server Message Block | Windows ファイル共有プロトコル。AIX では SMBFS（SMB 1.0）と SMB Client File System（SMB 2.1+3.0.2）の 2 系統があり、CIFS は Expansion Pack へ移管。 | SMBFS, CIFS | — | S54 |
| **SSH** | セキュリティ | Secure Shell | 暗号化リモート接続プロトコル。AIX 7.3 既定は OpenSSH 9.7p1（OpenSSL 3.0.13 でビルド）で、GSSAPI Key Exchange パッチ済み。Telnet/rlogin の置換として運用必須。 | OpenSSH, OpenSSL, GSSAPI | [OpenSSH の堅牢化（PermitRootLogin / Ciphers / GSSAPI）](08-config-procedures.md#cfg-ssh-hardening) | S65 |
| **OpenSSH** | セキュリティ | OpenBSD Secure Shell | SSH 標準実装。AIX 7.3 = 9.7p1。8.x 系は EOS、9.7 で AIX 固有 GSSAPI パッチ適用済。/etc/ssh/sshd_config で挙動を制御。 | SSH, OpenSSL | [OpenSSH の堅牢化（PermitRootLogin / Ciphers / GSSAPI）](08-config-procedures.md#cfg-ssh-hardening) | S65 |
| **OpenSSL** | セキュリティ | Open Secure Sockets Layer | TLS / 暗号ライブラリ。AIX 7.3 = 3.0 系（TL3 SP1 で 3.0.15.1001）。Power11 In-core 性能最適化済。1.0.2 / 1.1.1 は EOS で、共有オブジェクトは 2025 秋に AIX archive から削除予定。 | OpenSSH, IPsec, providers | [OpenSSH の堅牢化（PermitRootLogin / Ciphers / GSSAPI）](08-config-procedures.md#cfg-ssh-hardening)<br>[bos.net.tcp.sendmail 7.3.0.0 install 時に libcrypto エラー](09-incident-procedures.md#inc-sendmail-libcrypto-fail) | S35 |
| **BIND** | ネットワーク | Berkeley Internet Name Domain | DNS リゾルバ・サーバ実装。AIX 7.3 = 9.18（bind.rte fileset、TL2 以降同梱）。bos.net.tcp.bind / bind_utils を置換するが、既定 install 対象外なので明示インストールが必要。 | DNS, named9 | [BIND 9.18 移行後に dnssec ツールが見つからない](09-incident-procedures.md#inc-bind-918-tools-missing) | S35 |
| **NTP** | ネットワーク | Network Time Protocol | 時刻同期プロトコル。AIX 7.3 では NTPv3 サポート廃止 → ntp4 (/usr/sbin/ntp4/) のみ。互換のため /usr/sbin/xntpd は ntp4/ntpd4 へのリンクになっている。 | ntpd4 | [AIX 7.3 移行後に NTPv3 デーモンが起動失敗](09-incident-procedures.md#inc-ntpv3-fail) | S35 |
| **LDAP** | セキュリティ | Lightweight Directory Access Protocol | ディレクトリサービスプロトコル。AIX は secldapclntd で LDAP を統合認証バックエンドとして使う。/etc/security/ldap/ldap.cfg に bindDN/baseDN 等を記述。TL3 SP1 で defaulthomedirectory 等のフィールド追加。 | ISVD, ISDS, secldapclntd | [LDAP クライアント設定（AIX 7.3 TL3 SP1 拡張フィールド対応）](08-config-procedures.md#cfg-ldap-client)<br>[LDAP ユーザログイン後にホームディレクトリ作成失敗](09-incident-procedures.md#inc-ldap-home-fail) | S34 |
| **ISVD** | セキュリティ | IBM Security Verify Directory | IBM 製 LDAP サーバ（v10.0、旧 ISDS）。AIX 7.3 TL2 で同梱、ISDS 6.4 は EOS 2024/9。AD 連携も SFU plug-in なしで TL3 から対応。 | LDAP, ISDS | [LDAP クライアント設定（AIX 7.3 TL3 SP1 拡張フィールド対応）](08-config-procedures.md#cfg-ldap-client)<br>[LDAP ユーザログイン後にホームディレクトリ作成失敗](09-incident-procedures.md#inc-ldap-home-fail) | S34 |
| **LPM** | 仮想化 | Live Partition Mobility | LPAR を他の物理サーバへ無停止マイグレーションする PowerVM 機能。HMC からトリガ。AIX 側は cthags critical resource monitor の例外設定が必要なことがある。 | PowerVM, HMC, DLPAR | — | S35 |
| **LKU** | 運用 | Live Kernel Update | 業務無停止のカーネル更新機能。geninstall（LKU mode）または HMC ベース LKU でトリガし、blackout 短時間でカーネル切替。TL3 で性能改善・libc Live Library Update（LLU）対応。 | LLU, geninstall, lvupdate.data | [Live Kernel Update（LKU）実施](08-config-procedures.md#cfg-live-kernel-update)<br>[Live Kernel Update 中に IPsec 接続が切断](09-incident-procedures.md#inc-lku-ipsec-drop) | S35 |
| **LLU** | 運用 | Live Library Update | 業務無停止での libc 等ライブラリ更新（TL3 新規）。LKU の補完機能で、ライブラリ脆弱性パッチ適用に使う。 | LKU | [Live Kernel Update（LKU）実施](08-config-procedures.md#cfg-live-kernel-update) | S35 |
| **RDMA** | ネットワーク | Remote Direct Memory Access | 高速リモートメモリアクセス機構。RoCE（Ethernet 上 RDMA）と InfiniBand の 2 経路がある。Spectrum Scale や HPC アプリで使う。 | RoCE, InfiniBand | — | S29 |
| **SRC** | 運用 | System Resource Controller | AIX のサブシステム制御フレームワーク。startsrc/stopsrc/refresh/lssrc で各種デーモン（sshd, syslogd, named, secldapclntd 等）を統一的に管理。/etc/inittab で初期起動。 | startsrc, stopsrc, lssrc | — | S24 |
| **WLM** | 運用 | Workload Manager | プロセスグループへのリソース割当て管理機構。CPU / Memory / I/O / Process count を class ごとに上限・下限設定できる。WPAR と統合可能。 | WPAR, classes | [WPAR 作成 + WLM クラス連携](08-config-procedures.md#cfg-wpar-create) | S75 |
| **EFS** | セキュリティ | Encrypted File System | AIX のファイルレベル暗号化機能。LV 暗号化（暗号化LV）と相補。efsenable で有効化、AES-128/256 ベース。 | PKS, hdcryptmgr | [rootvg の暗号化構築（PKS + passphrase）](08-config-procedures.md#cfg-encrypt-rootvg) | S63 |
| **CCA** | セキュリティ | Common Cryptographic Architecture | IBM 製 HSM ベース暗号アーキテクチャ。AIX では PCIe Crypto Coprocessor 4765/4767 と組み合わせて、PKS / AIX Key Manager と連動する。 | PKS, 4765, 4767 | [rootvg の暗号化構築（PKS + passphrase）](08-config-procedures.md#cfg-encrypt-rootvg) | S4 |
| **AIXPert** | セキュリティ | AIX Security Expert | AIX のセキュリティ自動チューニングツール。aixpert -p で policy 適用（low/med/high/sox-cobit）、aixpert -u で undo。/etc/security/aixpert/log/ に履歴。 | RBAC, TE | [Trusted Execution + CHKSHOBJS 有効化（TL3 SP1）](08-config-procedures.md#cfg-trusted-execution)<br>[AIXPert で security policy 適用](08-config-procedures.md#cfg-aixpert-policy) | S32 |
| **TE** | セキュリティ | Trusted Execution | 実行ファイル整合性検証機構。TL3 SP1 で CHKSHOBJS ポリシー追加（共有オブジェクト .o の整合性）。trustchk コマンドで適用、tepolicies.dat / lib.tsd.dat に署名 DB を保持。 | trustchk, tepolicies.dat | [Trusted Execution + CHKSHOBJS 有効化（TL3 SP1）](08-config-procedures.md#cfg-trusted-execution) | S34 |
| **IPsec** | セキュリティ | Internet Protocol Security | IP 層暗号化プロトコル。AIX 7.3 で DH groups 14/19/20/21/24（TL3 で 20/21 追加）、SHA2_512 hash（TL3）、AES-GCM Power In-core 最適化（TL3）対応。 | IKEv2, ipsec.conf | [Live Kernel Update（LKU）実施](08-config-procedures.md#cfg-live-kernel-update)<br>[Live Kernel Update 中に IPsec 接続が切断](09-incident-procedures.md#inc-lku-ipsec-drop) | S35 |
| **IKEv2** | セキュリティ | Internet Key Exchange v2 | IPsec の鍵交換プロトコル。AIX では ikedb / ipsec.so で操作。LKU 時は ipsec_auto_migrate=yes を設定しないと再ネゴ失敗。 | IPsec | [Live Kernel Update 中に IPsec 接続が切断](09-incident-procedures.md#inc-lku-ipsec-drop) | S35 |
| **MWC** | ストレージ | Mirror Write Consistency | LV ミラーリング時のデータ整合性確保機構。電源障害時の inconsistent state を防ぐ。passive MWC (AIX 7.3 既定) と active MWC（旧）があり、性能と書込安全性のトレードオフがある。 | MWCC, LV | — | S40 |
| **MWCC** | ストレージ | Mirror Write Consistency Cache | MWC のキャッシュ機構（TL3 で lvmstat に統計対応）。dirty block 領域を高速に管理する。 | MWC, lvmstat | — | S35 |
| **VMM** | 性能 | Virtual Memory Manager | AIX のページング・メモリ管理。vmo tunable で minfree/maxfree/page_steal_method 等を調整。Computational vs File ページの分類が独自で、minperm/maxperm/maxclient で挙動変更。 | vmo, page_steal | [VMM tunable 変更（minfree / maxfree / page_steal_method）](08-config-procedures.md#cfg-vmm-tunables)<br>[低メモリ機（4GB 以下）で多数同時 open file 障害](09-incident-procedures.md#inc-low-mem-cache-thrash) | S25 |
| **CHRP** | HW | Common Hardware Reference Platform | Power の共通ハードウェアリファレンス。AIX 7.3 は 64-bit CHRP のみサポート（POWER8+）。 | POWER, OPAL | — | S35 |
| **ASMI** | 管理 | Advanced System Management Interface | Power サーバの BMC 相当ファームウェア管理 IF。HMC 経由で Web UI として提供。電源・PHYP・ファームウェアログにアクセス。 | HMC, PHYP | — | S35 |
| **OPAL** | HW | Open Power Abstraction Layer | オープンソース OS（Linux on Power）用の Power 抽象化層。PHYP の上に乗る。AIX は OPAL を使わず PHYP 直接利用。 | PHYP, POWER | — | S35 |
| **PHYP** | 仮想化 | POWER Hypervisor | Power のハードウェアハイパーバイザ。LPAR の物理的隔離・DLPAR・LPM を担う。AIX/VIOS から見ると下層の OS。 | PowerVM, OPAL | — | S35 |
| **DNF** | パッケージ | Dandified YUM | RPM パッケージマネージャ。AIX 7.3 では YUM 非対応で DNF を使う。AIX Toolbox から導入し、bos.system.python の有効化が前提。 | RPM, AIX Toolbox | — | S35 |
| **ESA** | 管理 | Electronic Service Agent | ハードウェア障害自動 IBM 通知（コールホーム）。esagent fileset で導入。HMC との連携も可。 | HMC, esagent | — | S14 |
| **SUMA** | 運用 | Service Update Management Assistant | fix 自動取得ツール。Fix Central から TL/SP/iFix を取得して LPP_SOURCE 等に蓄積。TL3 SP1 でプロキシ経由ダウンロードに対応。 | Fix Central, NIM | — | S34 |
| **hd5** | ブート | ブート LV (hd5) | AIX のブート LV。最小 40 MB、ディスク先頭 4GB 内連続パーティション必須。bosboot コマンドで再生成、bootlist で優先順序を制御する。 | bosboot, bootlist | [インストール時 hd5 拡張失敗の切り分け](09-incident-procedures.md#inc-install-hd5-fail) | S35 |
| **144 I/O slot 制約** | ブート | Boot device の 144 slot 内制約 | AIX 7.3 ファームウェアメモリ容量制約。bootable デバイスは Bus 順最初の 144 I/O slot 内に配置必要。MPIO の場合は両アダプタとも 144 slot 内へ。 | bootlist, MPIO | [インストール時 hd5 拡張失敗の切り分け](09-incident-procedures.md#inc-install-hd5-fail)<br>[144 I/O slot 越えのデバイスから boot 不可](09-incident-procedures.md#inc-144slot-boot-fail) | S35 |
| **error ID** | 障害 | エラー ID | 32bit CRC 16進コードでエラーを一意識別。各エラーレコードテンプレートに固有。errpt -j <error_id> で特定エラーのみ抽出可能。 | errpt, error label | — | S45 |
| **error label** | 障害 | エラーラベル | error ID のニーモニック名（人間が読める識別子）。errnotify ODM オブジェクトの match 条件として使う。 | errpt, errnotify | — | S45 |
| **errpt** | コマンド | error report 表示 | AIX のエラーログ要約表示コマンド。errpt（要約） / errpt -a（詳細） / errpt -j <id>（特定）。HW エラーは 90 日、SW エラーは 30 日で自動削除。 | errnotify, errclear | — | S45 |
| **errdemon** | 障害 | error daemon | AIX のエラー集中ログ書き込みデーモン。/dev/error special file を監視し、ODM の Error Record Template Repository と照合してログ書き込み。 | errpt, ODM | — | S45 |
| **errnotify** | 障害 | error notify ODM class | 特定エラー条件で通知 / 動作を発火させる ODM オブジェクトクラス。label/class/type で条件指定し、odmadd で登録 → 即時有効。 | ODM, errpt | — | S45 |
| **snap** | 障害 | snap support data | AIX のサポート提供データ収集ツール。snap -ac で全カテゴリ採取し /tmp/ibmsupt/snap.pax.gz を生成（既定）。IBM サポート連絡時の標準提供物。 | errpt, IBM Support | — | S35 |
| **trace** | 障害 | system trace | AIX のカーネルトレース機構。trace -f で取得、trcrpt で展開。AIX 7.3 で root 限定化（セキュリティ強化）。 | trcrpt | — | S35 |
| **topas** | 性能 | real-time perf monitor | AIX 標準のリアルタイム性能モニタ。CPU/メモリ/ディスク/ネット要約を 1 画面表示。topas -P でプロセス別、topas_nmon でログ出力可能。 | vmstat, iostat | — | S25 |
| **lparstat** | 性能 | LPAR statistics | LPAR レベル CPU 統計コマンド。lparstat（要約）、lparstat -i（LPAR 設定詳細）、lparstat 1 5（5 秒間隔×5）。共有プロセッサ LPAR では entitled / consumed の差を見る。 | vmstat, mpstat | — | S25 |
| **ioo** | tunable | I/O options | JFS2/AIO/VMM I/O tunable 管理コマンド。ioo -L（一覧）、ioo -p -o name=value（永続）、ioo -d name（既定値復元）。多くは動的反映。 | no, schedo, vmo | — | S25 |
| **no** | tunable | network options | TCP/IP tunable 管理コマンド。no -L で全パラメータ表示、no -p -o tcp_recvspace=131072 で永続反映。 | ioo, schedo | — | S25 |
| **schedo** | tunable | scheduler options | スケジューラ tunable 管理コマンド。vpm_throughput_mode / vpm_xvcpus / smt_snooze_delay 等。動的反映。 | ioo, no, vmo | — | S25 |
| **vmo** | tunable | VMM options | VMM tunable 管理コマンド。minfree/maxfree/page_steal_method/lru_file_repage 等。動的反映、再起動要のものは boot value で指定。 | ioo, no, schedo | — | S25 |
| **chdev** | コマンド | change device | デバイス属性変更コマンド。-a で属性指定、-U でデバイス open 中も動的反映可能（一部）、-P で次回再起動時反映。MPIO 属性（reserve_policy 等）の調整に頻用。 | lsdev, lsattr | — | S12 |
| **oslevel** | コマンド | OS level | AIX のレベル取得コマンド。oslevel -s で TL/SP まで（例 7300-03-01-2516）、oslevel -r で TL のみ。lslpp -L bos.rte.libc で fileset 別バージョン確認可。 | lslpp | — | S24 |
| **installp** | コマンド | install package | AIX fileset インストールコマンド。-acgXd で apply+commit+全 prereq+解凍 を一括。lslpp -L で結果確認、installp -C でcommit pending fileset 確認。 | lslpp, geninstall | — | S18 |
| **mksysb** | コマンド | make system backup | ブート可能な OS（rootvg）バックアップ生成。tape/file/NIM 全対応。-i で image.data 同梱（マイグレーション時必須）。alt_disk_install で別ディスクに復元可能。 | savevg, alt_disk_install | — | S41 |
| **hdcryptmgr** | コマンド | hard disk cryptography manager | 暗号化LV/PV の鍵運用コマンド（PKS 移行・passphrase 管理）。multibos / mksysb 復元時は鍵再生成必要。Power FW1030+ で PKS への移行が可能。 | PKS, EFS | — | S35 |
| **manage_disk_drivers** | コマンド | manage disk drivers | AIX のディスクドライバ（AIX_FCPARRAY / AIX_AAPCM 等）切替コマンド。SDD 廃止に伴う AIX 7.3 マイグレーション前の必須作業。 | MPIO, SDD | — | S35 |
| **trustchk** | コマンド | trust check | Trusted Execution の整合性チェック・ポリシー適用コマンド。tepolicies.dat / lib.tsd.dat を参照。CHKSHOBJS は TL3 SP1 で追加。 | TE, tepolicies.dat | — | S34 |
| **clmgr** | コマンド | cluster manager | CAA / PowerHA クラスタ管理の単一フロントエンド。clmgr add cluster / clmgr add node / clmgr query cluster で構成・参照を行う。 | CAA, PowerHA | — | S6 |
| **clogin** | コマンド | container login | WPAR にコンテナログインするコマンド（chroot 強化版）。WPAR 内シェルが起動し、システムコール境界が分離される。 | WPAR, mkwpar | — | S75 |
| **mkwpar** | コマンド | make WPAR | WPAR 作成コマンド。-n で名前指定、-N で network spec、-B で base dir。WLM クラス指定でリソース上限を設定可能。 | WPAR, WLM | — | S75 |
| **AIX_CWD_CACHE** | 環境変数 | AIX CWD cache | プロセス環境変数。getcwd/getwd 結果をキャッシュするか（TL2 以降は ON 既定）。OFF にすると毎回 stat を回るのでパフォーマンス低下する。 | getcwd | — | S35 |
| **LDR_CNTRL** | 環境変数 | loader control | プロセス環境変数。MAXDATA= / USER_REGS= / NAMEDSHLIB= 等のサブオプション文字列。プロセスメモリレイアウト（large page、heap サイズ）の制御。 | large page | — | S34 |
| **ipsec_auto_migrate** | tunable | IPsec auto migrate (LKU) | Live Update 用設定。LKU 実行時に IPsec を自動再ネゴするか。yes/no、TL3 で導入。lvupdate.data に記述、LKU 実行時にのみ評価。 | LKU, IPsec, lvupdate.data | — | S35 |
| **DLPAR memory** | 仮想化 | DLPAR memory | DLPAR で動的に増減するメモリ領域。LMB（Logical Memory Block、既定 256MB）単位で割当。HMC からトリガし、AIX 側 vmstat で確認。 | DLPAR, LMB | — | S72 |

[← AIX 7.3 トップへ](index.md)
