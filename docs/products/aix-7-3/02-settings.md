# AIX 7.3 — 主要設定項目

AIX 7.3 — 主要設定項目（チューナブル）

ioo / no / schedo / chdev 系のチューナブルおよび設定ファイル（ldap.cfg / openssl.cnf / tepolicies.dat 等）。

| パラメータ名 | 設定ファイル / コマンド | 既定値 | 取り得る値 | 影響範囲（再起動要否・動的反映可否） | 関連パラメータ | 出典 |
|---|---|---|---|---|---|---|
| j2_inodeCacheSize | ioo -p -o | 200（AIX 7.3 で 400→200 に変更） | 整数（GB あたり open file 数の概算上限） | 動的（boot/current 両方反映） | j2_metadataCacheSize | S35 |
| j2_metadataCacheSize | ioo -p -o | 200（TL2 以降） | 整数 | 動的（boot/current 両方反映） | j2_inodeCacheSize | S35 |
| vpm_throughput_mode | schedo -p -o | 2（Power10 共有プロセッサモード時の既定） | 0 / 1 / 2 / 4 / 8 | 動的反映、`schedo -d vpm_throughput_mode` で既定値復元可 | Power10 LPAR migration | S35 |
| tcp_dss | no -p -o | 1（有効） | 0 / 1 | 動的反映、setsockopt 明示時は無効化 | TCP socket buffer auto-tuning | S35 |
| queues_rx | Virtual Ethernet adapter 属性 (chdev) | 0（legacy receive mode） | 0 以上の整数 | デバイス属性、chdev 適用後ステート遷移 | Virtual Ethernet Multi-Queue（tx 12 既定） | S35 |
| ipsec_auto_migrate | lvupdate.data ファイル（Live Update リソース） | TL3 で導入、明示指定推奨 | yes / no | LKU 実行時のみ反映 | IPsec、Live Kernel Update | S35 |
| mt_qk_io_recov | Disk and disk adapter tunable | TL3 SP1 導入（既定値はマニュアル参照） | 数値 | デバイス属性 | MPIO disk recovery | S34 |
| LDR_CNTRL | プロセス環境変数 / Miscellaneous tunable | 未設定 | MAXDATA=, USER_REGS=, NAMEDSHLIB= 等のサブオプション文字列 | プロセス起動時に評価 | プログラムローダ、large page 最適化 | S34 |
| AIX_CWD_CACHE | プロセス環境変数 | ON（TL2 以降、getcwd/getwd 結果をキャッシュ） | ON / OFF | プロセス起動時に評価 | getcwd, getwd | S35 |
| reserve_policy | ODM (chdev で変更) | no_reserve（AIX 7.3〜） | no_reserve / single_path / PR_exclusive / PR_shared 等 | デバイス属性（chdev -U で動的可） | MPIO、IBM DS8000/SVC/Flash | S35 |
| algorithm | ODM (chdev) | shortest_queue（AIX 7.3〜） | round_robin / fail_over / shortest_queue 等 | デバイス属性（chdev -U で動的可） | MPIO | S35 |
| queue_depth (DS8000) | ODM (chdev -U) | 64（AIX 7.3〜） | 整数（ストレージ仕様依存） | 動的（chdev -U） | MPIO、num_cmd_elems | S35 |
| queue_depth (SVC / Flash Systems) | ODM (chdev -U) | 32（AIX 7.3〜） | 整数 | 動的（chdev -U） | MPIO | S35 |
| rw_timeout | chdev -U（SAS / FC / iSCSI ディスク） | デバイスごとに異なる | 秒数 | 動的（オープン中も変更可） | ストレージ I/O リトライ | S35 |
| num_cmd_elems | chdev -U（FC adapter protocol） | デバイスごとに異なる | 整数 | 動的（オープン中も変更可） | FC adapter キュー深度 | S35 |
| rto_high / rto_length / rto_limit / rto_low | no -p -o（TCP retransmission timeout） | カーネル既定値 | 秒数 等 | 動的反映 | TCP retransmission | S35 |
| /etc/environment PATH | /etc/environment | java8_64 を含む（新規/上書き install 時） | コロン区切りパスリスト | ログイン時に評価 | Java 環境 | S35 |
| /var/ssl/openssl.cnf | OpenSSL 3.0 設定ファイル | OpenSSL 3.0 デフォルト設定（旧版から退避してから上書き必須） | openssl_init / providers / default_sect / legacy_sect セクション | サービス再起動 | OpenSSL providers, OpenSSH | S35 |
| ldap.cfg fields | /etc/security/ldap/ldap.cfg | TL3 SP1 で idgeneration / domainid 追加、pwdalgorithm / defaulthomedirectory / defaultloginshell 拡張 | （フィールドごとに異なる） | secldapclntd 再起動 | Domain RBAC、AD/LDAP 連携 | S34 |
| Trusted Execution policy CHKSHOBJS | tepolicies.dat | TL3 SP1 新規追加（既定: 未設定） | enabled / disabled 等のフラグ | trustchk 適用 | lib.tsd.dat、Trusted Signature DB | S34 |

