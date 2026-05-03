# AIX 7.3 — 障害対応手順（15 手順）

典型障害の切り分けフロー。各手順は **症状 / 確認コマンド / 仮説 / 対処 / 検証** の 5 部構成。

## 手順一覧

| ID | タイトル | 症状 |
|---|---|---|
| [inc-install-hd5-fail](#inc-install-hd5-fail) | インストール時 hd5 拡張失敗の切り分け | AIX 7.3 install で「unable to extend hd5」「boot LV cannot be allocated contiguously |
| [inc-sdd-multipath-broken](#inc-sdd-multipath-broken) | SDD 依存ストレージで AIX 7.3 起動後に MPIO 不能 | AIX 7.3 へマイグレーション後、hdisk が認識されないか single path のみ。`lspath` で paths がない |
| [inc-low-mem-cache-thrash](#inc-low-mem-cache-thrash) | 低メモリ機（4GB 以下）で多数同時 open file 障害 | open() が ENFILE / EMFILE で失敗 / 突然の syslog エラー / Db2 / Oracle インスタンス起動失敗 |
| [inc-ldap-home-fail](#inc-ldap-home-fail) | LDAP ユーザログイン後にホームディレクトリ作成失敗 | LDAP / AD ユーザで初回ログイン時、ホームディレクトリが作られない / または既定 shell が異なる |
| [inc-lku-ipsec-drop](#inc-lku-ipsec-drop) | Live Kernel Update 中に IPsec 接続が切断 | geninstall -k 実行中、または直後に IPsec トンネル経由のセッションが切断 |
| [inc-trusted-aix-migration-block](#inc-trusted-aix-migration-block) | Trusted AIX 残存で AIX 7.3 マイグレーション失敗 | premigration script が「Trusted AIX (or Trusted AIX LAS/EAL4+) is not supported on |
| [inc-144slot-boot-fail](#inc-144slot-boot-fail) | 144 I/O slot 越えのデバイスから boot 不可 | サーバ起動時に bootlist 指定のデバイスから boot しない / SMS で見えない |
| [inc-java-sr6fp35-load-fail](#inc-java-sr6fp35-load-fail) | Java 8 32bit SR6FP35 がロード不能 | java -version で「could not load Java VM」/ 業務 Java アプリが起動しない |
| [inc-sendmail-libcrypto-fail](#inc-sendmail-libcrypto-fail) | bos.net.tcp.sendmail 7.3.0.0 install 時に libcrypto エラー | installp 中に「libcrypto_compat.a not found」と表示 |
| [inc-rsct-vsd-block](#inc-rsct-vsd-block) | rsct.vsd / rsct.lapi.rte が AIX 7.3 で install 不能 | install 中に「This fileset is no longer supported on AIX 7.3」と中断 / または起動後 VSD 機能が動か |
| [inc-ntpv3-fail](#inc-ntpv3-fail) | AIX 7.3 移行後に NTPv3 デーモンが起動失敗 | xntpd 起動失敗 / `ps -ef \| grep ntp` で xntpd プロセスがいない |
| [inc-bind-918-tools-missing](#inc-bind-918-tools-missing) | BIND 9.18 移行後に dnssec ツールが見つからない | named-checkconf -p OK だが dnssec-coverage / dnssec-keymgr / dnssec-checkds が見つからな |
| [inc-nim-spot-missing-image](#inc-nim-spot-missing-image) | NIM SPOT 作成時 missing image エラー | nim -o define -t spot で「missing image: bos.net.nfs.client / bos.net.tcp.bootp / |
| [inc-dsm-properties-lost](#inc-dsm-properties-lost) | dsm.properties が migration 後に欠落 | dsmadmc / dsmc が「dsm.properties not found」で起動失敗 |
| [inc-powersc-ts-block](#inc-powersc-ts-block) | PowerSC Trusted Surveyor 残存で migration ブロック | premigration script が「powersc.ts is not supported on AIX 7.3」と中断 |

---

## インストール時 hd5 拡張失敗の切り分け {#inc-install-hd5-fail}

**症状**: AIX 7.3 install で「unable to extend hd5」「boot LV cannot be allocated contiguously」と表示  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `lspv` | rootvg PV を確認 |
| `lsvg rootvg` | FREE PP 数を確認 |
| `lspv -p hdisk0` | hdisk0 のパーティションマップ確認 |

**Step 2. 仮説**: hd5 が 40MB 未満かつディスク先頭 4GB 内に連続 PP が確保できない（AIX 7.3 で必須）

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `# (install media メニュー) Free Space Reuse → 既存 LV を移動` | ディスク先頭領域を空ける |
| `# または 別ディスクに rootvg を分離` | 代替 hdisk への install を選択 |
| `# install を再試行` |  |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `lslv hd5` | hd5 サイズ ≥ 40MB / TYPE=boot / IN BAND % が high かを確認 |
| `bootlist -m normal -o` | ブート優先順序確認 |

**関連**:

- 関連用語: [hd5](03-glossary.md), [144 I/O slot 制約](03-glossary.md)
- 関連コマンド: `lspv`, `lsvg`, `lslv`, `bootlist`

---

## SDD 依存ストレージで AIX 7.3 起動後に MPIO 不能 {#inc-sdd-multipath-broken}

**症状**: AIX 7.3 へマイグレーション後、hdisk が認識されないか single path のみ。`lspath` で paths がない  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `lspath` | MPIO パス一覧 |
| `lsdev -Cc disk` | ディスクデバイス確認 |
| `manage_disk_drivers -l` | 現在のドライバマッピング確認 |
| `errpt \| grep -i path` | エラーログでパス障害を確認 |

**Step 2. 仮説**: AIX 7.3 で SDD（Subsystem Device Driver）が完全削除されたため

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `manage_disk_drivers -d <stype> -o AIX_AAPCM` | AIX_AAPCM へドライバ切替 |
| `# あるいは IBM Storage 推奨の SDDPCM へ移行` |  |
| `cfgmgr` | デバイス再構成 |
| `lspath` | MPIO パス再認識確認 |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `lsattr -El hdisk0` | MPIO 属性が反映されているか |
| `iostat 1 5` | I/O が複数パスで分散しているか |

**関連**:

- 関連用語: [SDD](03-glossary.md), [SDDPCM](03-glossary.md), [AAPCM](03-glossary.md), [MPIO](03-glossary.md)
- 関連コマンド: `manage_disk_drivers`, `lspath`, `cfgmgr`, `lsdev`

---

## 低メモリ機（4GB 以下）で多数同時 open file 障害 {#inc-low-mem-cache-thrash}

**症状**: open() が ENFILE / EMFILE で失敗 / 突然の syslog エラー / Db2 / Oracle インスタンス起動失敗  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `vmstat -v` | fre / pi / po / inode cache 統計 |
| `ioo -L j2_inodeCacheSize -L j2_metadataCacheSize` | 現在値（既定 200 を確認） |
| `svmon -G` | メモリ使用全体像 |

**Step 2. 仮説**: AIX 7.3 で j2_inodeCacheSize 既定が 400 → 200 に変更され、低メモリ機で inode cache 不足になっている

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `ioo -p -o j2_inodeCacheSize=400 -o j2_metadataCacheSize=400` | boot/current 両方反映 |
| `ioo -L j2_inodeCacheSize` | 変更確認 |
| `# 業務アプリの再起動（必要に応じて）` |  |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `vmstat -v \| grep inode` | inode cache が新値で稼働 |
| `ulimit -n` | プロセス上限の確認 |

**関連**:

- 関連用語: [JFS2](03-glossary.md), [VMM](03-glossary.md)
- 関連設定値: `j2_inodeCacheSize`, `j2_metadataCacheSize`
- 関連コマンド: `ioo`, `vmstat`, `svmon`

---

## LDAP ユーザログイン後にホームディレクトリ作成失敗 {#inc-ldap-home-fail}

**症状**: LDAP / AD ユーザで初回ログイン時、ホームディレクトリが作られない / または既定 shell が異なる  [S34]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `lsldap -a cn=admin,dc=example,dc=com -h ldap.example.com passwd` | LDAP からユーザ取得テスト |
| `cat /etc/security/ldap/ldap.cfg \| grep -E 'default\|pwdalg'` | TL3 SP1 拡張フィールドの記載確認 |
| `errpt \| grep -i ldap` | LDAP 関連エラー |
| `ps -ef \| grep secldap` | secldapclntd デーモン稼働確認 |

**Step 2. 仮説**: TL3 SP1 で defaulthomedirectory / defaultloginshell / pwdalgorithm が新規追加されたが ldap.cfg に未記入

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `vi /etc/security/ldap/ldap.cfg` | defaulthomedirectory: /home |
| `# 同 defaultloginshell: /usr/bin/ksh を追記` |  |
| `# 同 pwdalgorithm: ssha256 を追記` |  |
| `stop-secldapclntd` | デーモン停止 |
| `start-secldapclntd` | 再起動 |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `# LDAP ユーザで su - <user> 実行` | ホームディレクトリが作られログインできるか |
| `lsuser -R LDAP <user>` | ユーザ属性確認 |

**関連**:

- 関連用語: [LDAP](03-glossary.md), [ISVD](03-glossary.md)
- 関連設定値: `/etc/security/ldap/ldap.cfg`
- 関連コマンド: `lsldap`, `stop-secldapclntd`, `start-secldapclntd`, `lsuser`

---

## Live Kernel Update 中に IPsec 接続が切断 {#inc-lku-ipsec-drop}

**症状**: geninstall -k 実行中、または直後に IPsec トンネル経由のセッションが切断  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `cat /etc/lvupdate.data \| grep ipsec` | ipsec_auto_migrate 設定確認 |
| `ikedb -gP` | IKE DB ピア状態 |
| `netstat -in \| grep ipsec` | IPsec インターフェース統計 |

**Step 2. 仮説**: ipsec_auto_migrate=no（既定）のため、LKU 時に IPsec 再ネゴシエーションが行われずトンネルが落ちた

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `vi /etc/lvupdate.data` | ipsec_auto_migrate=yes を追記 |
| `# IPsec トンネル復旧` | ikedb -gT で SA 確認、必要なら ikemig |
| `geninstall -k -d <LPP_SOURCE> all` | LKU 再実行 |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `ikedb -gP` | ピアが confirmed 状態 |
| `# 業務アプリの IPsec 経由接続を確認` |  |

**関連**:

- 関連用語: [LKU](03-glossary.md), [IPsec](03-glossary.md), [IKEv2](03-glossary.md)
- 関連設定値: `/etc/lvupdate.data`, `ipsec_auto_migrate`
- 関連コマンド: `geninstall`, `ikedb`

---

## Trusted AIX 残存で AIX 7.3 マイグレーション失敗 {#inc-trusted-aix-migration-block}

**症状**: premigration script が「Trusted AIX (or Trusted AIX LAS/EAL4+) is not supported on AIX 7.3」と中断  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `lslpp -l \| grep -i trusted` | Trusted AIX fileset の有無 |
| `lssec -f /etc/security/login.cfg -s default -a SECURITY_FLAGS` | Trusted モード確認 |
| `/usr/sbin/getrunmode` | 実行モード |

**Step 2. 仮説**: Trusted AIX、Trusted AIX LAS/EAL4+、BAS and EAL4+ Configuration が AIX 7.3 で全廃された

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `# 旧版（AIX 7.2 等）で Domain RBAC へ移行` | lsroles, mkrole, swrole で fine-grained 権限設計 |
| `# Trusted AIX 関連 fileset 削除` | installp -u <fileset> |
| `# 確認後、premigration script 再実行` |  |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `lslpp -l \| grep -i trusted` | Trusted AIX fileset がないこと |
| `/usr/lpp/bos/premigration` | 再実行で OK 通過 |

**関連**:

- 関連用語: [RBAC](03-glossary.md)
- 関連コマンド: `lsroles`, `mkrole`, `swrole`, `installp`

---

## 144 I/O slot 越えのデバイスから boot 不可 {#inc-144slot-boot-fail}

**症状**: サーバ起動時に bootlist 指定のデバイスから boot しない / SMS で見えない  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `# HMC で I/O 構成を Bus 順に表示` |  |
| `# bootable HBA がBus 順 144 slot 内かを確認` |  |
| `bootlist -m normal -o` | 現 bootlist 表示 |

**Step 2. 仮説**: AIX 7.3 のファームウェアメモリ容量制限で、bootable デバイスは Bus 順最初の 144 I/O slot 内に配置必須

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `# HMC で boot 可能 HBA を最初の 144 slot 内へ移動` |  |
| `# MPIO の場合は両アダプタとも 144 slot 内に配置` |  |
| `bootlist -m normal hdisk0 hdisk1` | 新 bootlist 設定 |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `bootlist -m normal -o` | 新 bootlist 確認 |
| `# 再起動して SMS でブート可能デバイスを確認` |  |

**関連**:

- 関連用語: [144 I/O slot 制約](03-glossary.md), [MPIO](03-glossary.md)
- 関連コマンド: `bootlist`

---

## Java 8 32bit SR6FP35 がロード不能 {#inc-java-sr6fp35-load-fail}

**症状**: java -version で「could not load Java VM」/ 業務 Java アプリが起動しない  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `java -version` | 現バージョン確認 |
| `lslpp -L \| grep -i java` | fileset 確認 |
| `file /usr/java8/jre/bin/java` | 32bit / 64bit 確認 |

**Step 2. 仮説**: Java 8 32bit SR6FP35（VRMF 8.0.0.635）と AIX 7.3 ロード機構の互換性問題

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `# IBM Java SDK サイトから Java 8 32bit の新版を取得` |  |
| `installp -F -acgYXd <new_image> Java8.32bit` | 強制更新 |
| `# 利用不可なら Expansion Pack の SR6FP30（8.0.0.630）にダウングレード` |  |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `java -version` | 新バージョン稼働 |
| `# 業務 Java アプリ起動確認` |  |

**関連**:

- 関連コマンド: `installp`, `java`, `lslpp`

---

## bos.net.tcp.sendmail 7.3.0.0 install 時に libcrypto エラー {#inc-sendmail-libcrypto-fail}

**症状**: installp 中に「libcrypto_compat.a not found」と表示  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `lslpp -L \| grep openssl` | OpenSSL バージョン確認 |
| `lslpp -L bos.net.tcp.sendmail` | sendmail 現バージョン |

**Step 2. 仮説**: LPP_SOURCE が base 7.3.0.0 + 7.3.3 update 混在で、初期 sendmail バイナリが libcrypto_compat.a を要求するが OpenSSL 3.0 では削除済

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `installp -acgYXd <LPP_SOURCE> bos.net.tcp.sendmail` | update_all で 7.3.3 へ更新を続行 |
| `# install 完了後、libcrypto_compat 依存は解消する` |  |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `sendmail -d0.1 < /dev/null` | sendmail バージョン情報表示 |
| `lslpp -L bos.net.tcp.sendmail` | 新バージョン確認 |

**関連**:

- 関連用語: [OpenSSL](03-glossary.md)
- 関連コマンド: `installp`, `lslpp`, `sendmail`

---

## rsct.vsd / rsct.lapi.rte が AIX 7.3 で install 不能 {#inc-rsct-vsd-block}

**症状**: install 中に「This fileset is no longer supported on AIX 7.3」と中断 / または起動後 VSD 機能が動かない  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `lslpp -L \| grep -E 'rsct.vsd\|rsct.lapi'` | 対象 fileset 確認 |
| `oslevel -r` | RSCT バージョン確認 |

**Step 2. 仮説**: RSCT 3.3.0.0（AIX 7.3 同梱）で VSD / LAPI 機能が完全廃止された

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `installp -u rsct.vsd rsct.lapi.rte` | 事前削除 |
| `# VSD ベースの 3rd party 製品（旧 GPFS 等）は Spectrum Scale へ置換` |  |
| `# 互換 .sp / .hacmp fileset も shipping 停止のため削除` |  |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `lslpp -L \| grep -E 'rsct.vsd\|rsct.lapi'` | fileset がなくなる |
| `# RSCT サブシステム全体の正常稼働確認` | lssrc -g rsct |

**関連**:

- 関連用語: [RSCT](03-glossary.md)
- 関連コマンド: `installp`, `lslpp`, `lssrc`

---

## AIX 7.3 移行後に NTPv3 デーモンが起動失敗 {#inc-ntpv3-fail}

**症状**: xntpd 起動失敗 / `ps -ef | grep ntp` で xntpd プロセスがいない  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `lssrc -s xntpd` | サブシステム状態 |
| `ls -l /usr/sbin/xntpd` | xntpd の実体確認（symlink になっているか） |
| `cat /etc/ntp.conf` | 設定ファイル |

**Step 2. 仮説**: AIX 7.3 で NTPv3 サポートが廃止され、xntpd は ntp4/ntpd4 へのシンボリックリンクになった

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `ls /usr/sbin/ntp4/` | ntp4 配下のバイナリ確認 |
| `# /etc/ntp.conf を ntp v4 互換に修正（restrict 構文 等）` |  |
| `startsrc -s xntpd` | xntpd 経由で起動（実体は ntpd4） |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `ntpq -p` | ピア同期確認 |
| `date` | 時刻同期確認 |

**関連**:

- 関連用語: [NTP](03-glossary.md)
- 関連コマンド: `startsrc`, `stopsrc`, `ntpq`, `ntpd4`

---

## BIND 9.18 移行後に dnssec ツールが見つからない {#inc-bind-918-tools-missing}

**症状**: named-checkconf -p OK だが dnssec-coverage / dnssec-keymgr / dnssec-checkds が見つからない  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `lslpp -L bind.rte` | BIND バージョン確認（9.18） |
| `ls /usr/sbin/isc_bind/` | BIND バイナリ一覧 |
| `cat /etc/named.conf \| head -20` | 設定ファイル確認 |

**Step 2. 仮説**: BIND 9.18 で dnssec-coverage / dnssec-keymgr / dnssec-checkds が削除された

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `# named.conf を BIND 9.18 の dnssec-policy 統合機能に書き換え` |  |
| `# 旧 dnssec-keymgr ベースの cron job を削除` |  |
| `named-checkconf -p` | 再構文チェック |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `rndc reload` | ゾーン再読込 |
| `dig @localhost example.com` | DNS 解決確認 |

**関連**:

- 関連用語: [BIND](03-glossary.md), [DNS](03-glossary.md)
- 関連コマンド: `named-checkconf`, `rndc`, `dig`, `nslookup`

---

## NIM SPOT 作成時 missing image エラー {#inc-nim-spot-missing-image}

**症状**: nim -o define -t spot で「missing image: bos.net.nfs.client / bos.net.tcp.bootp / network boot image」  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `lsnim -l <lpp_source>` | LPP_SOURCE 内容確認 |
| `lsnim -l <spot>` | SPOT 状態確認 |
| `df /export/spot` | SPOT 用 FS 容量確認 |

**Step 2. 仮説**: LPP_SOURCE が base + update 混在で、image_data resource が未指定 / SPOT 領域不足

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `nim -o define -t image_data -a server=master -a location=/export/aix73tl3.image.data aix73tl3_image_data` | image_data resource 作成 |
| `nim -o define -t spot ... -a image_data=aix73tl3_image_data ...` | SPOT 再作成 with image_data |
| `# または SPOT 用 FS を拡張` | chfs -a size=+5G /export/spot |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `nim -o check <spot>` | SPOT が OK 状態 |
| `# テストクライアントでネットブート` |  |

**関連**:

- 関連用語: [NIM](03-glossary.md), [SPOT](03-glossary.md), [LPP_SOURCE](03-glossary.md)
- 関連設定値: `bosinst.data`, `image.data`
- 関連コマンド: `nim`, `lsnim`, `chfs`

---

## dsm.properties が migration 後に欠落 {#inc-dsm-properties-lost}

**症状**: dsmadmc / dsmc が「dsm.properties not found」で起動失敗  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `ls -l /etc/ibm/sysmgt/dsm/overrides/dsm.properties` | ファイル存在確認 |
| `lslpp -L dsm.core` | dsm.core fileset 確認 |

**Step 2. 仮説**: /etc/ibm/sysmgt/dsm/overrides/dsm.properties は dsm.core fileset の update / migration で上書きされる

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `# 事前バックアップから復元` | cp /backup/dsm.properties.YYYYMMDD /etc/ibm/sysmgt/dsm/overrides/dsm.properties |
| `# バックアップが無い場合、手動再作成（DB 接続情報・ノード名）` |  |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `dsmadmc -id=admin -pa=*** -se=server1` | TSM サーバ接続確認 |

**関連**:

- 関連コマンド: `dsmadmc`, `dsmc`, `installp`

---

## PowerSC Trusted Surveyor 残存で migration ブロック {#inc-powersc-ts-block}

**症状**: premigration script が「powersc.ts is not supported on AIX 7.3」と中断  [S35]

**Step 1. 確認コマンド**:

| コマンド | 確認内容 |
|---|---|
| `lslpp -L \| grep -i powersc` | PowerSC 関連 fileset |
| `lswpar \| xargs -I{} clogin {} lslpp -L \| grep -i powersc` | WPAR 内も含めて確認 |

**Step 2. 仮説**: AIX 7.3 で PowerSC Trusted Surveyor（powersc.ts）が非サポートになった

**Step 3. 対処コマンド**:

| コマンド | 説明 |
|---|---|
| `installp -u powersc.ts` | Global 環境から削除 |
| `# 各 WPAR でも同様に削除` | clogin <wpar> でログインして installp -u |
| `# premigration script 再実行` |  |

**Step 4. 検証**:

| コマンド | 確認内容 |
|---|---|
| `lslpp -L \| grep -i powersc.ts` | fileset がない |
| `/usr/lpp/bos/premigration` | OK 通過 |

**関連**:

- 関連用語: [WPAR](03-glossary.md)
- 関連コマンド: `installp`, `lswpar`, `clogin`

---

[← AIX 7.3 トップへ](index.md)