# AIX 7.3 — 構成要素

AIX 7.3 — 構成要素（コンポーネント・機能ブロック）

各コンポーネント記述の末尾「出典」列に [SX] 形式の出典 ID（06_出典一覧 参照）。

| コンポーネント名 | 役割 | 主要機能 | 関連サブシステム | 出典 |
|---|---|---|---|---|
| BOS (Base Operating System) | AIX OS 中核（カーネル・基本コマンド・ライブラリ） | bos.* fileset 群を介して提供。AIX 7.3 ではコア fileset が分割（bos.net.tcp.client/server から 31 fileset 化） | 全サブシステムの基盤 | S35 |
| LVM (Logical Volume Manager) | 物理ボリュームを論理ボリュームに抽象化する OS 機能 | scalable VG（既定: 1024 PV / 256 LV / 32768 PP）、データ暗号化既定有効、INLINE log JFS2 / passive MWC | JFS2、ストレージ（MPIO） | S35 |
| JFS2 (Enhanced Journaled File System) | AIX の既定ジャーナルファイルシステム | 最大ファイル/FS サイズ 128 TB、INLINE log 既定、LV 暗号化対応、snapshot/quota 機能 | LVM、Encrypted LV | S35 |
| NFS (Network File System) クライアント | リモートファイル共有（POSIX 互換） | AIX 7.3.1 以降で 16 TB 超のファイル対応（最大 256 TB テスト済）、DIO オプションで高容量ファイルの性能向上 | TCP/IP | S35 |
| SMBFS / SMB Client File System | Windows 系（SMB プロトコル）共有アクセス | SMBFS = SMB 1.0 / SMB Client FS = SMB 2.1 + 3.0.2（CIFS クライアントの後継、CIFS は Expansion Pack へ移管） | TCP/IP | S54, S35 |
| TCP/IP スタック | ネットワークプロトコル基盤 | OpenSSH 9.7p1 既定同梱、Virtual Ethernet Multi-Queue（既定: tx 12 / rx 0）、tcp_dss 動的バッファサイズ | ネットワーキング、IPsec | S35 |
| ODM (Object Data Manager) | システム構成情報の永続化 DB | デバイス属性、エラーテンプレート、SRC サブシステム情報を保持。AIX 7.3 で MPIO の数属性が nondisplay 化 | デバイス管理、エラーログ | S35, S45 |
| Error Logging サブシステム | ハードウェア・ソフトウェアエラーの集中ログ | errdemon デーモンが /dev/error を監視 → ODM の Error Record Template Repository と照合してログ書き込み。HW=90日 / SW=30日で自動削除 | diag、ODM、SMIT | S45 |
| RBAC / Domain RBAC | ロールベースアクセス制御 | AIX 7.3 で Trusted AIX が削除され Domain RBAC が代替。fine-grained 権限分離 | セキュリティ、ldap.cfg | S35 |
| RSCT 3.3.0.0 | 上位クラスタ製品の基盤フレームワーク | AIX 7.3 同梱。VSD/LAPI 機能は廃止（rsct.vsd / rsct.lapi.rte 削除必須）。互換 .sp / .hacmp fileset も shipping 停止 | Cluster Aware AIX、PowerHA | S35 |
| Cluster Aware AIX (CAA) | OS レベルのクラスタリング機能 | Cluster Repository（TL3 から NVMe ディスク対応）、ノード間メンバーシップ管理。PowerHA SystemMirror が利用 | RSCT、PowerHA | S34, S6 |
| WPAR (Workload Partitions) | OS レベル仮想化（コンテナ相当） | system WPAR / application WPAR、Workload Manager（WLM）と連携、PowerSC.ts は AIX 7.3 で非サポート | OS、WLM | S75, S35 |
| LPAR / DLPAR (Dynamic Logical Partitioning) | ハードウェアパーティショニング（PowerVM 機能の OS 側ハンドリング） | リソース（CPU、メモリ、I/O）の動的増減を OS が受け取る。HMC ベース LKU で TL3 から動的拡張対応 | PowerVM、HMC | S72, S35 |
| Live Kernel Update (LKU) / Live Library Update (LLU) | 業務無停止のカーネル/ライブラリ更新 | TL3 で LKU 性能改善（blackout 短縮）、TL3 で LLU 新規導入（libc 等のライブラリ更新）、IPsec 対応（ipsec_auto_migrate） | RSCT、暗号化LV | S35 |
| ASO / DSO (Active / Dynamic System Optimizer) | ワークロード自動最適化 | TL1 以降 DSO は ASO の一部に統合。large page 最適化、data stream prefetch 最適化を自動適用 | カーネル、性能管理 | S35, S33 |
| AME (Active Memory Expansion) | メモリ圧縮による実装メモリ拡張 | Power10 で既定 page size = 64 KB | VMM、カーネル | S35 |
| MPIO (Multipath I/O) | ストレージ多重経路アクセス | AIX 7.3 で既定値変更: reserve_policy=no_reserve / algorithm=shortest_queue / queue_depth=64(DS8000) or 32(SVC/Flash)。AP PCM は AIX 7.3 で削除、SDD は SDDPCM/AIX_AAPCM へ移行必須 | ODM、デバイス管理 | S35 |
| NIM (Network Installation Management) | ネットワーク経由の AIX 集中導入 | bos.sysmgt.nim.master fileset、SPOT、LPP_SOURCE、image_data resource。/usr/lpp/bos.sysmgt/nim/README に詳細 | TCP/IP、ストレージ | S35 |
| Trusted Execution / Trusted Signature DB | 実行ファイル整合性検証 | TL3 SP1 で CHKSHOBJS ポリシー追加（共有オブジェクト .o の整合性確認）。tepolicies.dat / lib.tsd.dat | セキュリティ、AIXPert | S34 |
| AIX Key Manager (PKS) | 鍵管理サブシステム | TL3 から導入。pksctl コマンド、PowerVM Platform Keystore 経由で鍵保管。TL3 SP1 で wrapping 機能追加 | 暗号化LV/PV、HPCS | S35 |
| IPsec | ネットワーク層暗号化 | DH groups 14/19/20/21/24（TL3 で 20/21 追加）、SHA2_512 hash（TL3）、AES-GCM Power In-core 最適化（TL3） | TCP/IP、IKEv2 | S35 |
| SUMA (Service Update Management Assistant) | 更新自動取得 | TL3 SP1 でプロキシ設定経由のダウンロードに対応 | fix管理、ESS | S34 |
| Electronic Service Agent (ESA) | ハードウェア障害の自動 IBM 通知（コールホーム） | esagent fileset | Service support、HMC | S14 |
| Diagnostic Subsystem (diag) | ハードウェア診断ユーティリティ | AIX 7.3 で 1 日複数回の定期診断スケジューリング対応、最大 10 ディスク並列 certify/format 対応 | Error Log | S35, S45 |
| Performance Tools | 性能監視・分析ツール群 | sar, lparstat, mpstat, pmcycles, lvmstat（TL3 で MWCC 統計対応） | カーネル、ASO/DSO | S25, S26, S35 |
| BIND 9.18 (bind.rte) | DNS リゾルバ・サーバ | TL2 以降同梱。bos.net.tcp.bind / bind_utils を置換（既定インストール対象外）。/usr/sbin/isc_bind/ 配下に配置 | TCP/IP | S35 |
| NTPv4 (ntp.rte) | 時刻同期 | AIX 7.3 で NTPv3 サポート廃止。/usr/sbin/ntp4/ 配下、互換のため /usr/sbin/xntpd → ntp4/ntpd4 リンク | TCP/IP | S35 |
| OpenSSH 9.7p1 | セキュアリモートアクセス（既定インストール） | VRMF 9.7.3013.1000、GSSAPI Key Exchange パッチ済、OpenSSL 3.0.13 でビルド。8.x 系は EOS | TCP/IP、OpenSSL | S35 |
| OpenSSL 3.0.x | TLS/暗号ライブラリ | TL1 で 3.0.7、TL3 で 3.0.13.1000、TL3 SP1 で 3.0.15.1001。Power11 In-core 性能最適化。1.0.2 / 1.1.1 共有オブジェクトは 2025 秋まで互換配置 | OpenSSH、IPsec、bind.rte | S35 |
| RPM 4.18.1 (DNF) | RPM パッケージマネージャ | TL2 以降。sqlite3 backend、OpenSSL ベース（nss/nspr/db library packages 削除）。YUM 非サポート、DNF を使用 | AIX Toolbox | S35 |

