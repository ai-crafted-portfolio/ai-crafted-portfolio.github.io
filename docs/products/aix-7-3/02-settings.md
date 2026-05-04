# 設定値一覧

> 掲載：**40 件（tunable 20 + 設定ファイル 20）**（定番のみ）。除外項目は [10. 対象外項目](10-out-of-scope.md) を参照。

vmo / no / nfso / ioo / schedo の tunable と /etc/ 配下の主要設定ファイル。Default / 取り得る値は日本語化、影響範囲（applyType）は個別記載（v3 のファミリ固定文を撤廃）。

## チューナブルパラメータ（20 件）

| パラメータ名 | 設定コマンド | 既定値 | 取り得る値 | 影響範囲（再起動要否） | 関連手順 | 注意点 |
|---|---|---|---|---|---|---|
| `j2_inodeCacheSize` | `ioo -p -o` | 200（AIX 7.1 で 400 → 200 に変更、AIX 7.3 も同値） | 1〜1000 の整数（メモリ GB あたりの inode キャッシュ目安） | 動的反映（再起動不要）。-p 指定で /etc/tunables/nextboot にも書き込み恒久化。 | [cfg-ioo-tuning](08-config-procedures.md#cfg-ioo-tuning) | 低メモリ機 (4GB 以下) で同時 open file が多いと不足する。`vmstat -v \| grep inode` で extend 失敗回数を確認。 |
| `j2_metadataCacheSize` | `ioo -p -o` | 200 | 1〜1000 の整数 | 動的反映 | [cfg-ioo-tuning](08-config-procedures.md#cfg-ioo-tuning) | 通常 j2_inodeCacheSize と同値で運用。 |
| `minperm%` | `vmo -p -o` | 3（AIX 7.x） | 0〜100 の整数（メモリ全体に占める割合 %） | 動的反映 | `cfg-vmo-tuning` | ファイルキャッシュの最低保持率。低くしすぎるとファイル I/O 性能低下。 |
| `maxperm%` | `vmo -p -o` | 90 | 0〜100 の整数 | 動的反映 | `cfg-vmo-tuning` | ファイルキャッシュの最大保持率。プロセスメモリ重視なら 80 程度に下げる。 |
| `maxclient%` | `vmo -p -o` | 90 | 0〜100 の整数（maxperm% 以下である必要あり） | 動的反映 | `cfg-vmo-tuning` | クライアント FS（NFS/JFS2）キャッシュの最大保持率。 |
| `lru_file_repage` | `vmo -p -o` | 0（restricted） | 0 または 1 | 動的反映だが restricted（vmo -F 必須） | `cfg-vmo-tuning` | AIX 7.1 以降は事実上 no-op（IBM Docs 注記）。設定変更は推奨されない。 |
| `minfree` | `vmo -p -o` | 960（フレーム数、~3.75MB at 4KB） | 8〜200000 の整数（4KB ページ数） | 動的反映 | `cfg-vmo-tuning` | page stealing 開始の下限。大きい I/O burst 受ける機は 1024〜の値推奨。 |
| `maxfree` | `vmo -p -o` | 1088（フレーム数） | 16〜200000、minfree より大きい必要あり | 動的反映 | `cfg-vmo-tuning` | page stealing 終了の上限。 |
| `tcp_sendspace` | `no -p -o` | 262144 バイト（256KB） | 4096 以上の整数（バイト） | 動的反映（既存接続には影響しない、新規接続から有効） | [cfg-tcp-buffers](08-config-procedures.md#cfg-tcp-buffers) | 高遅延 WAN や 10GbE 環境では 1MB（1048576）以上推奨。setsockopt で個別アプリが上書き可能。 |
| `tcp_recvspace` | `no -p -o` | 262144 バイト（256KB） | 4096 以上の整数（バイト） | 動的反映（新規接続のみ） | [cfg-tcp-buffers](08-config-procedures.md#cfg-tcp-buffers) | tcp_sendspace と同値で運用が定石。 |
| `sb_max` | `no -p -o` | 1048576 バイト（1MB） | 4096 以上の整数 | 動的反映 | [cfg-tcp-buffers](08-config-procedures.md#cfg-tcp-buffers) | ソケットバッファ最大値。tcp_sendspace/recvspace の 2 倍以上が望ましい。 |
| `rfc1323` | `no -p -o` | 1（有効） | 0=無効, 1=有効 | 動的反映（新規接続のみ） | [cfg-tcp-buffers](08-config-procedures.md#cfg-tcp-buffers) | TCP window scaling。64KB 超のバッファ使うときは必須。 |
| `ipforwarding` | `no -p -o` | 0（無効） | 0=無効, 1=有効（ルータ動作） | 動的反映 | `cfg-network-router` | AIX をルータとして使う場合のみ 1。通常サーバは 0 のまま。 |
| `nfs_socketsize` | `nfso -p -o` | 600000 バイト | 40000 以上の整数 | 動的反映（新規 NFS 接続のみ） | [cfg-nfs-mount](08-config-procedures.md#cfg-nfs-mount) | v3 で `no` で扱った誤りを訂正。NFS は nfso 専用。 |
| `nfs_tcp_socketsize` | `nfso -p -o` | 600000 バイト | 40000 以上の整数 | 動的反映（新規 NFS 接続のみ） | [cfg-nfs-mount](08-config-procedures.md#cfg-nfs-mount) | TCP マウント用。10GbE 等で大量転送する場合は値を上げる。 |
| `nfs_rfc1323` | `nfso -p -o` | 1（有効） | 0=無効, 1=有効 | 動的反映 | [cfg-nfs-mount](08-config-procedures.md#cfg-nfs-mount) | NFS over TCP の window scaling。 |
| `vpm_throughput_mode` | `schedo -p -o` | 2（Power10 共有プロセッサモード時の AIX 7.3 既定） | 0=disabled / 1=raw / 2=enhanced raw / 4=scaled / 8=enhanced scaled | 動的反映、`schedo -d vpm_throughput_mode` で既定値復元 | `cfg-schedo-tuning` | 誤った値で性能劣化することあり。共有プロセッサ LPAR で要確認。 |
| `vpm_xvcpus` | `schedo -p -o` | 0 | 整数（folded VP の追加 unfold 数） | 動的反映 | `cfg-schedo-tuning` | VP folding の余剰 unfold 数。スパイク負荷でレスポンス重視なら +1 以上。 |
| `reserve_policy` | `chdev -l hdiskN -a reserve_policy=` | no_reserve（AIX 7.3〜の新規ディスク） | no_reserve / single_path / PR_exclusive / PR_shared | デバイス属性。chdev -U で動的反映可（オープン中も適用）。 | [cfg-mpio-tuning](08-config-procedures.md#cfg-mpio-tuning) | PowerHA/LPM 環境では no_reserve 必須。SCSI-2 reserve は old style。 |
| `queue_depth` | `chdev -l hdiskN -a queue_depth=` | DS8000=64 / SVC・FlashSystem=32（AIX 7.3〜の新規ディスク） | 1 以上の整数（ストレージ仕様に依存） | デバイス属性。chdev -U で動的反映可（オープン中も適用）。 | [cfg-mpio-tuning](08-config-procedures.md#cfg-mpio-tuning) | FC adapter 側 num_cmd_elems も同期して上げる必要あり。 |

## 設定ファイル（20 件）

| 設定ファイル | 用途 | 編集者・コマンド | 反映タイミング | 関連手順 | 注意点 |
|---|---|---|---|---|---|
| `/etc/hosts` | 静的 IP-ホスト名マッピング。DNS が引けない時のフォールバック。 | vi（直接編集可） | 編集後即時有効（プロセスごとに再読み込み） | [cfg-hostname-ip](08-config-procedures.md#cfg-hostname-ip), [cfg-dns](08-config-procedures.md#cfg-dns) | 1 行 1 エントリ: `IP hostname [alias...]`。ループバック 127.0.0.1 localhost は必須。 |
| `/etc/resolv.conf` | DNS リゾルバ設定（nameserver, domain, search）。 | vi または smitty namerslv | 新規プロセスから有効 | [cfg-dns](08-config-procedures.md#cfg-dns) | nameserver は最大 3 つ。/etc/netsvc.conf で hosts=local,bind の順序指定。 |
| `/etc/netsvc.conf` | ネームサービス検索順（local/bind/nis 等の優先順位）。 | vi | 新規プロセスから有効 | [cfg-dns](08-config-procedures.md#cfg-dns) | 例: `hosts=local,bind` で /etc/hosts → DNS の順。Linux の nsswitch.conf 相当。 |
| `/etc/inittab` | init プロセスが起動する各種サービスの定義。 | mkitab / chitab / lsitab / rmitab（直接 vi は非推奨） | 次回 boot から有効。telinit q で再読み込み。 | `cfg-init-service` | vi で編集するとフォーマットエラーで boot 不能になることあり。lsitab で確認、mkitab/chitab で変更が安全。 |
| `/etc/rc.tcpip` | TCP/IP 関連サービスの起動スクリプト。inittab から呼ばれる。 | vi | 次回 boot から有効。手動実行も可能。 | [cfg-syslog](08-config-procedures.md#cfg-syslog), `cfg-network-services` | syslogd / sendmail / inetd 等の起動有無を制御。 |
| `/etc/syslog.conf` | syslogd の出力先設定。 | vi | refresh -s syslogd で再読み込み | [cfg-syslog](08-config-procedures.md#cfg-syslog) | tab 区切り（スペースだと無視される行あり）。出力ファイルは事前に touch しておく。 |
| `/etc/security/user` | ユーザ属性（パスワードポリシー、umask、ulimit 等）の集中管理。 | chsec / chuser / vi | 次回ログインから有効 | [cfg-user-add](08-config-procedures.md#cfg-user-add), [cfg-passwd-policy](08-config-procedures.md#cfg-passwd-policy) | default stanza でデフォルト値、ユーザ別 stanza で個別上書き。 |
| `/etc/security/login.cfg` | ログイン関連の制御（試行回数、時間帯、メソッド）。 | chsec / vi | 次回ログインから有効 | [cfg-passwd-policy](08-config-procedures.md#cfg-passwd-policy), [inc-login-locked](09-incident-procedures.md#inc-login-locked) | loginretries, logintimes, sak_enabled, port stanza 等を含む。 |
| `/etc/security/passwd` | ユーザのパスワードハッシュ格納（shadow 相当）。 | passwd コマンド経由（vi 直接編集禁止） | passwd コマンド実行時即時 | [cfg-user-add](08-config-procedures.md#cfg-user-add), [inc-login-locked](09-incident-procedures.md#inc-login-locked) | AIX 7.3 既定 hash は SSHA-256（最大 255 文字）。直接編集すると ODM 不整合。 |
| `/etc/security/lastlog` | ログイン試行履歴・失敗回数。 | chsec（unsuccessful_login_count リセット用） | 即時 | [inc-login-locked](09-incident-procedures.md#inc-login-locked) | `chsec -f /etc/security/lastlog -a unsuccessful_login_count=0 -s <user>` でロック解除。 |
| `/etc/security/limits` | プロセスごとのリソース制限（fsize, cpu, data, stack, nofiles, ...）。 | chuser / vi | 次回ログインから有効 | `cfg-ulimit-tuning` | default stanza に基本値、root も含めて全ユーザに適用。fsize=-1 で無制限。 |
| `/etc/filesystems` | マウントするファイルシステムの定義（mount コマンドのデフォルト）。 | crfs / chfs / rmfs / vi | mount/umount 実行時に参照 | [cfg-fs-extend](08-config-procedures.md#cfg-fs-extend), [cfg-nfs-mount](08-config-procedures.md#cfg-nfs-mount) | stanza 形式。mount=true で boot 時自動マウント、mount=false で手動。 |
| `/etc/exports` | NFS エクスポート対象 FS と権限の定義。 | mknfsexp / chnfsexp / vi | exportfs -a で再読み込み | [cfg-nfs-mount](08-config-procedures.md#cfg-nfs-mount) | `exportfs -av` で全エクスポート再評価、`-u <FS>` で個別 unexport。 |
| `/etc/environment` | 全ユーザ共通の環境変数（PATH, LANG, NLSPATH 等）。 | vi | ログイン時に評価（新規シェルから有効） | `cfg-locale-env` | AIX 7.3 で java8_64 が PATH に含まれる（新規/上書き install 時）。 |
| `/etc/profile` | 全ユーザ共通のログインシェル初期化スクリプト。 | vi | 次回ログインから有効 | `cfg-locale-env` | ksh/bash 起動時に source される。/etc/environment と分離。 |
| `/var/spool/cron/crontabs/<user>` | ユーザ別 cron ジョブ定義。 | crontab -e（vi 直接編集非推奨） | crond が次サイクルで再読み込み | `cfg-cron-job`, [inc-cron-fail](09-incident-procedures.md#inc-cron-fail) | crontab -e で編集するとフォーマット検証あり。直接編集すると syntax error で全ジョブ停止。 |
| `/etc/security/ldap/ldap.cfg` | LDAP クライアント（secldapclntd）設定。AD/LDAP 連携時の必須ファイル。 | vi | stop-secldapclntd / start-secldapclntd で再読み込み | `cfg-ldap-client` | TL3 SP1 で defaulthomedirectory / pwdalgorithm / defaultloginshell 拡張。 |
| `/var/ssl/openssl.cnf` | OpenSSL 3.0 設定ファイル。openssl コマンドおよび OpenSSH の暗号設定。 | vi | 次回 OpenSSL/OpenSSH プロセス起動から有効 | `cfg-openssl-migration` | AIX 7.3 で OpenSSL 3.0 になり旧版 cnf は退避必須。openssl_init / providers / legacy_sect セクション。 |
| `/etc/ntp.conf` | NTPv4 デーモン（ntpd4）の時刻同期サーバ設定。 | vi | stopsrc -s xntpd / startsrc -s xntpd で再読み込み | [cfg-ntp](08-config-procedures.md#cfg-ntp) | AIX 7.3 で NTPv4 が既定。/usr/sbin/xntpd → ntp4/ntpd4 にリンクされている。 |
| `/etc/sudoers` | sudo 権限定義（OpenSSH や bos.sysmgt.misc から導入）。 | visudo（vi 直接編集禁止） | 即時（次回 sudo 実行から有効） | `cfg-sudo-config` | visudo は構文チェック付き。AIX では sudo は base 同梱でなく Toolbox から。 |

---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
