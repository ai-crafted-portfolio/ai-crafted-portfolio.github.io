# 設定手順

> 掲載：**18 件（重要度 S/A/B/C × 用途）**（定番のみ）。除外項目は [10. 対象外項目](10-out-of-scope.md) を参照。

AIX 管理者が日常的に必要な設定変更を、**目的 → 前提 → 手順 → 期待出力 → 検証 → ロールバック → 関連** の 7 部構成で記述。

## 重要度 × 用途 マトリクス

| 重要度＼用途 | ストレージFS | ネットワーク | バックアップ | パッケージ | ユーザ認証 | ログ監査 | 性能 |
|---|---|---|---|---|---|---|---|
| **S** | [cfg-nfs-mount](#cfg-nfs-mount)<br>[cfg-vg-lv](#cfg-vg-lv)<br>[cfg-rootvg-mirror](#cfg-rootvg-mirror)<br>[cfg-fs-extend](#cfg-fs-extend)<br>[cfg-disk-add](#cfg-disk-add) | [cfg-hostname-ip](#cfg-hostname-ip)<br>[cfg-dns](#cfg-dns)<br>[cfg-ntp](#cfg-ntp) | [cfg-mksysb-backup](#cfg-mksysb-backup) | [cfg-package-install](#cfg-package-install) | [cfg-user-add](#cfg-user-add)<br>[cfg-passwd-policy](#cfg-passwd-policy) | [cfg-syslog](#cfg-syslog) | — |
| **A** | — | — | — | — | — | [cfg-errnotify](#cfg-errnotify)<br>[cfg-dump-device](#cfg-dump-device) | [cfg-mpio-tuning](#cfg-mpio-tuning)<br>[cfg-tcp-buffers](#cfg-tcp-buffers)<br>[cfg-ioo-tuning](#cfg-ioo-tuning) |
| **B** | — | — | — | — | — | — | — |
| **C** | — | — | — | — | — | — | — |

---

## 詳細手順

### cfg-hostname-ip: ホスト名と IP アドレスの変更 { #cfg-hostname-ip }

**重要度**: `S` / **用途**: ネットワーク

**目的**: AIX システムのホスト名と IP アドレスを変更する。本番系の移行・統合で必須。

**前提**: root 権限。変更する NIC（en0 等）が事前に Available。/etc/hosts に新 IP 追記が DNS なしで動かす場合は必要。

**手順**:

1. 現状確認:
   - `hostname`
   - `ifconfig -a`
   - `lsattr -El inet0 -a hostname`
2. ホスト名変更（恒久）:
   - `chdev -l inet0 -a hostname=<new-host>`
3. IP 変更（恒久）:
   - `chdev -l en0 -a netaddr=<new-ip> -a netmask=<new-mask>`
4. /etc/hosts 更新（直接 vi）:
```
192.168.10.20   new-host  new-host.example.com
```
5. 確認:
   - `hostname`
   - `ifconfig en0`


**期待出力**:

```
# hostname
new-host
# ifconfig en0
en0: flags=...
        inet 192.168.10.20 netmask 0xffffff00 broadcast 192.168.10.255

```

**検証**: 新 IP に対し別ホストから `ssh new-host` で接続できること、`ping new-host` で応答があること。

**ロールバック**: 上記手順を旧値で再実行。chdev は -P で次回 boot 反映に切り替え可能。

**関連**: [cfg-dns](08-config-procedures.md#cfg-dns), `/etc/hosts`, `/etc/resolv.conf`

**出典**: S_AIX73_network

---

### cfg-dns: DNS リゾルバ設定 { #cfg-dns }

**重要度**: `S` / **用途**: ネットワーク

**目的**: AIX を DNS クライアントとして設定する。

**前提**: 上位 DNS サーバの IP が分かっていること。

**手順**:

1. /etc/resolv.conf を作成（vi）:
```
domain example.com
search example.com sub.example.com
nameserver 192.168.10.1
nameserver 192.168.10.2
```
2. /etc/netsvc.conf で参照順を制御（vi）:
```
hosts=local,bind
```
3. 即時反映確認:
   - `nslookup www.ibm.com`


**期待出力**:

```
# nslookup www.ibm.com
Server:   192.168.10.1
Address:  192.168.10.1#53

Non-authoritative answer:
Name:    www.ibm.com
Address: ...

```

**検証**: `host www.ibm.com` および `dig www.ibm.com`（bind.rte 導入時）でも引けること。

**ロールバック**: /etc/resolv.conf を空にして元に戻すか、`hosts=local` のみで運用。

**関連**: `/etc/resolv.conf`, `/etc/netsvc.conf`, `BIND 9.18`

**出典**: S_AIX73_network

---

### cfg-nfs-mount: NFS マウントの設定 { #cfg-nfs-mount }

**重要度**: `S` / **用途**: ストレージFS

**目的**: リモート NFS サーバの export を AIX クライアントにマウントする。

**前提**: NFS サーバが起動済みで、対象 FS が export 済み。クライアントは bos.net.nfs.client fileset 必須。

**手順**:

1. NFS クライアントデーモン起動確認:
   - `lssrc -g nfs`
   - 停止していれば `startsrc -g nfs`
2. NFS サーバの export 確認:
   - `showmount -e <NFS server>`
3. マウントポイント作成:
   - `mkdir -p /mnt/nfsdata`
4. 一時マウントテスト:
   - `mount -o vers=3 <NFS server>:/export/data /mnt/nfsdata`
5. 永続化（/etc/filesystems に登録）:
   - `mknfsmnt -f /mnt/nfsdata -d /export/data -h <NFS server> -A -m -t rw`
6. 確認:
   - `mount`
   - `df -g /mnt/nfsdata`


**期待出力**:

```
# showmount -e nfssrv
export list for nfssrv:
/export/data  (everyone)

# mount
... nfssrv:/export/data  /mnt/nfsdata  nfs3 ...

```

**検証**: `ls /mnt/nfsdata` でファイルが見えること、`touch /mnt/nfsdata/test.txt` で書き込めること（rw マウント時）。

**ロールバック**: `umount /mnt/nfsdata` → `rmnfsmnt -f /mnt/nfsdata` で /etc/filesystems からも削除。

**関連**: [cfg-dns](08-config-procedures.md#cfg-dns), `nfso`

**出典**: S_AIX73_network

---

### cfg-ntp: NTP 時刻同期 { #cfg-ntp }

**重要度**: `S` / **用途**: ネットワーク

**目的**: NTP サーバと時刻同期する。HA クラスタ・ログ突合・Kerberos 等で必須。

**前提**: NTP サーバが疎通可能。AIX 7.3 では NTPv4 が既定。

**手順**:

1. /etc/ntp.conf 編集（vi）:
```
server ntp1.example.com prefer
server ntp2.example.com
driftfile /etc/ntp.drift
```
2. デーモン状態確認:
   - `lssrc -s xntpd`
3. 起動・自動起動有効化:
   - `startsrc -s xntpd`
   - `chrctcp -S -a xntpd`（次回 boot から自動起動）
4. 同期確認:
   - `lssrc -ls xntpd` → "synchronised to NTP server" を含むか


**期待出力**:

```
# lssrc -ls xntpd
Program name:        /usr/sbin/xntpd
...
synchronised to NTP server (192.168.10.5) at stratum 3
   time correct to within 50 ms

```

**検証**: 10 分ほど待ってから `ntpq -p` を実行し、reach 列が 17/377 等に進んでいること、offset が ms オーダー以下であること。

**ロールバック**: `stopsrc -s xntpd` → `chrctcp -d xntpd` で自動起動無効化。

**関連**: `/etc/ntp.conf`, `/etc/rc.tcpip`

**出典**: S_AIX73_network

---

### cfg-syslog: syslog 出力先の設定 { #cfg-syslog }

**重要度**: `S` / **用途**: ログ監査

**目的**: syslogd でログ出力先を設定する。集中ログサーバ転送、facility 別ファイル分離など。

**前提**: root 権限。

**手順**:

1. /etc/syslog.conf 編集（vi、フィールド区切りは TAB）:
```
*.info	/var/log/messages
mail.*	/var/log/maillog
local0.*	@logserver.example.com
```
2. 出力ファイル作成:
   - `touch /var/log/messages /var/log/maillog`
3. 設定再読み込み:
   - `refresh -s syslogd`
4. テストログ出力:
   - `logger -p local0.info "test from $(hostname)"`
5. 確認:
   - `tail /var/log/messages`


**期待出力**:

```
# tail /var/log/messages
... date ... hostname syslogd: restart
... date ... hostname user: test from new-host

```

**検証**: logger コマンドで送ったメッセージが指定先に出ていること。集中ログサーバ転送なら、サーバ側 tcpdump や受信ログで確認。

**ロールバック**: /etc/syslog.conf を元に戻し `refresh -s syslogd`。

**関連**: `syslogd`, `/etc/syslog.conf`

**出典**: S_AIX73_osmanagement

---

### cfg-errnotify: errnotify によるエラー通知 { #cfg-errnotify }

**重要度**: `A` / **用途**: ログ監査

**目的**: errpt 重要エラー検出時にメール通知する。staple な監視自動化。

**前提**: sendmail/MTA が動作。root 権限。

**手順**:

1. notify stanza ファイル作成 /tmp/errnotify_hw.add（vi）:
```
errnotify:
  en_name = "hw_alert"
  en_persistenceflg = 1
  en_class = "H"
  en_method = "/usr/bin/echo 'AIX hw error: $9' | mail -s 'AIX errpt' admin@example.com"
```
2. ODM に登録:
   - `odmadd /tmp/errnotify_hw.add`
3. 登録確認:
   - `odmget -q "en_name=hw_alert" errnotify`
4. テスト（疑似ログ生成）:
   - `errlogger -m "test hw alert from $(hostname)"`


**期待出力**:

```
# odmget -q "en_name=hw_alert" errnotify

errnotify:
        en_pid = 0
        en_name = "hw_alert"
        en_persistenceflg = 1
        en_class = "H"
        ...

```

**検証**: メール受信を確認。実際のハードエラー（疑似でなく）は HMC や `errpt -d H` でも見える。

**ロールバック**: `odmdelete -q "en_name=hw_alert" -o errnotify`

**関連**: `errpt`, `ODM`, `errnotify`

**出典**: S_AIX73_osmanagement

---

### cfg-dump-device: システムダンプデバイスの設定 { #cfg-dump-device }

**重要度**: `A` / **用途**: ログ監査

**目的**: クラッシュ時の kernel dump の出力先 LV を設定・確保する。

**前提**: root 権限。dump を格納できる十分なサイズの LV または PV。

**手順**:

1. 現状確認:
   - `sysdumpdev -l`
   - `sysdumpdev -e`（最小必要サイズ表示）
2. 専用 LV 作成（推奨。/dev/sysdumpnull は実行録音されない）:
   - `mklv -y dumplv -t sysdump rootvg <PP数>`
3. 一次 dump device に指定:
   - `sysdumpdev -P -p /dev/dumplv`
4. 確認:
   - `sysdumpdev -l`
5. 必要に応じてダンプ圧縮を有効化（デフォルト ON）:
   - `sysdumpdev -C`


**期待出力**:

```
# sysdumpdev -l
primary              /dev/dumplv
secondary            /dev/sysdumpnull
copy directory       /var/adm/ras
forced copy flag     TRUE
always allow dump    FALSE
dump compression     ON

```

**検証**: `sysdumpdev -e` の必要サイズが LV サイズより小さいこと。FW Dump イベントを HMC から発生させるテストはサポートと相談。

**ロールバック**: `sysdumpdev -P -p /dev/sysdumpnull` で無効化、`rmlv dumplv` で LV 削除。

**関連**: `snap`, `mklv`

**出典**: S_AIX73_osmanagement

---

### cfg-vg-lv: VG / LV の作成 { #cfg-vg-lv }

**重要度**: `S` / **用途**: ストレージFS

**目的**: 新規データディスクから VG を作成し、LV と JFS2 FS を切る。

**前提**: 新規 PV が cfgmgr で Available。`lspv` で hdiskN として見える。

**手順**:

1. 対象 PV の確認:
   - `lspv`
   - `lspv hdisk1` （PVID 確認、none なら chdev -l hdisk1 -a pv=yes）
2. scalable VG 作成（PP=64MB）:
   - `mkvg -S -y datavg -s 64 hdisk1 hdisk2`
3. LV 作成（100 PP = 6.4GB）:
   - `mklv -y datalv -t jfs2 datavg 100`
4. JFS2 FS 作成・マウント:
   - `crfs -v jfs2 -d datalv -m /data -A yes`
   - `mount /data`
5. 確認:
   - `lsvg datavg`
   - `df -g /data`


**期待出力**:

```
# lsvg datavg
VOLUME GROUP:    datavg                   VG IDENTIFIER: ...
VG STATE:        active                   PP SIZE:        64 megabyte(s)
...
TOTAL PVs:       2                        VG DESCRIPTORS: 3
...

# df -g /data
Filesystem    GB blocks  Free  %Used  Mounted on
/dev/datalv        6.25  6.20    1%   /data

```

**検証**: `mount` 出力に /data あり。`touch /data/test.txt` で書き込めること。reboot 後も自動マウントされること（-A yes）。

**ロールバック**: `umount /data` → `rmfs /data` → `rmvg datavg` の順に削除。

**関連**: `lspv`, `lsvg`, `mklv`, `chfs`

**出典**: S_AIX73_lvm

---

### cfg-rootvg-mirror: rootvg のミラー化 { #cfg-rootvg-mirror }

**重要度**: `S` / **用途**: ストレージFS

**目的**: rootvg を 2 ディスクにミラーリングして起動ディスク冗長化。

**前提**: 未使用 PV が 1 本（hdisk1 等）、サイズが既存 rootvg の hdisk0 以上。

**手順**:

1. PV を rootvg に追加:
   - `extendvg rootvg hdisk1`
2. 全 LV をミラー（同期 sync）:
   - `mirrorvg -S rootvg hdisk1`
   - 大きい rootvg だと数十分かかる
3. 同期完了確認:
   - `lsvg -l rootvg | awk '$5!="open/syncd"{print}'`
4. ブートイメージを両 PV に作成:
   - `bosboot -ad /dev/hdisk0`
   - `bosboot -ad /dev/hdisk1`
5. ブートリスト更新:
   - `bootlist -m normal hdisk0 hdisk1`
   - `bootlist -m normal -o`


**期待出力**:

```
# lsvg -l rootvg
rootvg:
LV NAME    TYPE    LPs  PPs  PVs  LV STATE     MOUNT POINT
hd5        boot      1    2    2  closed/syncd  N/A
hd6        paging  ...
hd8        jfs2log ...
... (全 LV が PPs=LPs*2、syncd)

```

**検証**: `lsvg rootvg | grep STALE` の値が 0、`bootlist -m normal -o` で hdisk0 hdisk1 両方が表示されること。片方の PV を擬似的に offline にして boot できるか HMC で alt boot テスト推奨。

**ロールバック**: `unmirrorvg rootvg hdisk1` → `reducevg rootvg hdisk1` → bosboot/bootlist を hdisk0 のみに戻す。

**関連**: `mklv`, `bosboot`, `bootlist`

**出典**: S_AIX73_lvm

---

### cfg-fs-extend: ファイルシステムの拡張 { #cfg-fs-extend }

**重要度**: `S` / **用途**: ストレージFS

**目的**: FS 容量不足時に動的に拡張する。staple な日常作業。

**前提**: VG に空き PP がある。なければ extendvg で PV 追加。

**手順**:

1. 現状確認:
   - `df -g /var`
   - `lsvg rootvg | grep FREE`（空き PP 数）
2. 1GB 追加:
   - `chfs -a size=+1G /var`
3. 確認:
   - `df -g /var`


**期待出力**:

```
# df -g /var
Filesystem    GB blocks  Free %Used  Mounted on
/dev/hd9var       2.00  1.45   28%   /var
# chfs -a size=+1G /var
Filesystem size changed to 6291456
# df -g /var
Filesystem    GB blocks  Free %Used  Mounted on
/dev/hd9var       3.00  2.45   19%   /var

```

**検証**: df の GB blocks が増えていること。アプリ側からも空き容量増加を確認。

**ロールバック**: 縮小は `chfs -a size=<小さい絶対値>`。データ破損リスクがあるので事前バックアップ必須。

**関連**: `df`, `chfs`, `lsvg`

**出典**: S_AIX73_jfs2

---

### cfg-user-add: ユーザ追加とパスワードポリシー { #cfg-user-add }

**重要度**: `S` / **用途**: ユーザ認証

**目的**: 新規ユーザを追加し、パスワードポリシー（試行回数・有効期限）を設定する。

**前提**: root 権限。

**手順**:

1. ユーザ追加:
   - `mkuser -a id=2001 home=/home/alice shell=/usr/bin/ksh alice`
2. 初期パスワード設定（次回ログイン時に変更を要求）:
   - `passwd alice`
   - 入力後: `pwdadm -f ADMCHG alice`
3. パスワードポリシー（個別ユーザに反映）:
   - `chuser maxage=12 maxrepeats=3 minlen=10 minother=2 alice`
4. 全ユーザのデフォルトに反映する場合:
   - `chsec -f /etc/security/user -a maxage=12 -a minlen=10 -s default`
5. 確認:
   - `lsuser -a id home shell maxage minlen alice`


**期待出力**:

```
# lsuser -a id home shell maxage minlen alice
alice id=2001 home=/home/alice shell=/usr/bin/ksh maxage=12 minlen=10

```

**検証**: alice でログイン → 初回 password 変更要求が出ること。`/usr/bin/ksh` が PATH に出ること。

**ロールバック**: `rmuser -p alice`（home/メールも削除する場合は `rmuser -p alice && rm -rf /home/alice`）。

**関連**: `lsuser`, `passwd`, `chsec`, `/etc/security/user`

**出典**: S_AIX73_security

---

### cfg-package-install: fileset のインストール / 更新 { #cfg-package-install }

**重要度**: `S` / **用途**: パッケージ

**目的**: BFF パッケージ（fileset）の適用。TL/SP 適用や個別 fileset 追加で必須。

**前提**: ソース（DVD、NFS、ローカルディレクトリ）が用意されている。/usr に十分な空き。

**手順**:

1. 事前プレビュー（preview のみ）:
   - `installp -p -aXd /mnt/lpp_source bos.adt.libm`
2. 実適用:
   - `installp -aXd /mnt/lpp_source bos.adt.libm`
3. すべての update を適用（update_all）:
   - `installp -aXd /mnt/lpp_source all`
4. インストール状態確認:
   - `lslpp -L bos.adt.libm`
   - `instfix -i | grep -i sp`


**期待出力**:

```
# lslpp -L bos.adt.libm
  Fileset                      Level  State  Type  Description
  ----------------------------------------------------------------
  bos.adt.libm               7.3.4.0  C     F    Base Application Development ...

```

**検証**: State 列が C（committed）または A（applied）。lppchk -v でファイル整合性も確認。

**ロールバック**: applied 状態なら `installp -r <fileset>` で reject 可能。committed は再 install 不可（前バージョンを上書き install する必要あり）。

**関連**: `lslpp`, `instfix`, `oslevel`

**出典**: S_AIX73_install

---

### cfg-mksysb-backup: mksysb による rootvg バックアップ { #cfg-mksysb-backup }

**重要度**: `S` / **用途**: バックアップ

**目的**: rootvg の bootable バックアップを取得する。月次・更新前必須。

**前提**: 保管先（テープ、NFS、ローカル FS）に rootvg 容量以上の空き。

**手順**:

1. 保管先 FS の空き確認:
   - `df -g /backup`
2. mksysb 実行（image.data 自動更新、FS 自動拡張）:
   - `mksysb -i -X /backup/$(hostname)_$(date +%Y%m%d).mksysb`
3. 完了後ファイルサイズ確認:
   - `ls -lh /backup/`
4. （NIM サーバ利用時）NIM resource として登録:
   - NIM サーバ側で `nim -o define -t mksysb ...`


**期待出力**:

```
Backup in progress, please wait...
Creating list of files to back up.
Backing up files...
0512-038 mksysb: Backup Completed Successfully.

# ls -lh /backup/
-rw-r--r--   1 root  system  3.2G  May 04 10:30  myhost_20260504.mksysb

```

**検証**: ファイルサイズが妥当（数 GB 〜 数十 GB）であること。NIM サーバ経由で別 LPAR に restore できれば確実。`restore -Tqf /backup/...mksysb` で目次表示も可能。

**ロールバック**: 古いバックアップを削除する場合のみ `rm /backup/<old>.mksysb`。当該バックアップ自体に取り消し概念はない。

**関連**: `savevg`, `NIM`, `image.data`

**出典**: S_AIX73_install

---

### cfg-passwd-policy: パスワードロック解除（強制リセット） { #cfg-passwd-policy }

**重要度**: `S` / **用途**: ユーザ認証

**目的**: loginretries 超でロックされたユーザのカウンタをリセットする。staple な日常作業。

**前提**: root 権限。

**手順**:

1. ロック状態確認:
   - `lsuser -a unsuccessful_login_count alice`
2. カウンタリセット:
   - `chsec -f /etc/security/lastlog -a unsuccessful_login_count=0 -s alice`
3. account_locked が true ならフラグも解除:
   - `chuser account_locked=false alice`
4. パスワード期限切れの場合:
   - `pwdadm -c alice`（password expiration をリセット）
5. 確認:
   - `lsuser -a unsuccessful_login_count account_locked alice`


**期待出力**:

```
# lsuser -a unsuccessful_login_count account_locked alice
alice unsuccessful_login_count=0 account_locked=false

```

**検証**: alice からログイン試行 → 通ること。

**ロールバック**: 通常不要。誤ってロック解除した場合は、再度 chuser account_locked=true alice。

**関連**: `lsuser`, `chsec`, `/etc/security/lastlog`, `/etc/security/login.cfg`

**出典**: S_AIX73_security

---

### cfg-disk-add: 新規ディスクの認識（cfgmgr） { #cfg-disk-add }

**重要度**: `S` / **用途**: ストレージFS

**目的**: SAN/SCSI で割り当てた新規 LUN を AIX に認識させる。

**前提**: ストレージ側で割り当て・マッピング済。FC スイッチの zoning OK。

**手順**:

1. 認識前のディスク数確認:
   - `lspv | wc -l`
2. cfgmgr 実行（詳細出力付き）:
   - `cfgmgr -v`
3. 認識後の確認:
   - `lspv`
   - 新 hdiskN が Available として現れる
4. PVID 割り当て:
   - `chdev -l hdisk2 -a pv=yes`
5. lsattr で MPIO 属性確認（AIX 7.3 既定: no_reserve / shortest_queue / queue_depth=64 など）:
   - `lsattr -El hdisk2`


**期待出力**:

```
# cfgmgr -v
Calling Configuration Manager...
Method "/usr/lib/methods/cfgsisscsia -l hdisk2 ..." invoked
Configuration Manager finished.

# lspv
hdisk0  00f6f5d05a1b2c3d  rootvg  active
hdisk1  00f6f5d05a1b2c4e  datavg  active
hdisk2  none              None

```

**検証**: lspv に新 hdisk が出ていること。lsattr -El hdiskN で reserve_policy=no_reserve であること（PowerHA/LPM 環境必須）。

**ロールバック**: 誤って認識してしまった場合は `rmdev -dl hdiskN` で ODM から削除。

**関連**: `lspv`, `lsattr`, `chdev`, `MPIO`

**出典**: S_AIX73_devicemanagement

---

### cfg-mpio-tuning: MPIO 属性のチューニング { #cfg-mpio-tuning }

**重要度**: `A` / **用途**: 性能

**目的**: AIX 7.3 で reserve_policy / algorithm / queue_depth の既定値が変更されたため、業務影響に応じて調整。

**前提**: 対象 hdisk が Available。

**手順**:

1. 現状確認:
   - `lsattr -El hdisk1 -a reserve_policy -a algorithm -a queue_depth`
2. queue_depth を 64 に変更（DS8000 推奨）— 動的反映:
   - `chdev -l hdisk1 -a queue_depth=64 -U`
3. reserve_policy を no_reserve（HA/LPM 必須）— 動的反映:
   - `chdev -l hdisk1 -a reserve_policy=no_reserve -U`
4. algorithm = shortest_queue（既定）に戻す:
   - `chdev -l hdisk1 -a algorithm=shortest_queue -U`
5. 確認:
   - `lsattr -El hdisk1 | egrep 'reserve_policy|algorithm|queue_depth'`


**期待出力**:

```
# lsattr -El hdisk1 -a reserve_policy -a algorithm -a queue_depth
reserve_policy  no_reserve       Reserve Policy        True
algorithm       shortest_queue   Algorithm             True
queue_depth     64               Queue DEPTH           True

```

**検証**: iostat -DRTl で当該 hdisk のレイテンシが許容範囲内、エラー数が増えていないこと。

**ロールバック**: chdev で前値に戻す。

**関連**: `lsattr`, `chdev`, `MPIO`

**出典**: S_AIX73_devicemanagement

---

### cfg-tcp-buffers: TCP 送受信バッファチューニング { #cfg-tcp-buffers }

**重要度**: `A` / **用途**: 性能

**目的**: 高遅延 WAN や 10GbE 環境で TCP throughput を上げる。

**前提**: root 権限。

**手順**:

1. 現状確認:
   - `no -L sb_max -L tcp_sendspace -L tcp_recvspace -L rfc1323`
2. 値を変更（永続）:
   - `no -p -o sb_max=4194304`
   - `no -p -o tcp_sendspace=1048576`
   - `no -p -o tcp_recvspace=1048576`
   - `no -p -o rfc1323=1`
3. 確認:
   - `no -a | egrep 'sb_max|tcp_sendspace|tcp_recvspace|rfc1323'`


**期待出力**:

```
# no -p -o tcp_sendspace=1048576
Setting tcp_sendspace to 1048576
Setting tcp_sendspace to 1048576 in nextboot file

```

**検証**: 新規接続から有効。`netperf` 等で実 throughput 計測。既存接続は再接続が必要。

**ロールバック**: `no -d <tunable>` で既定値復元。

**関連**: `no`, `netstat`

**出典**: S_AIX73_performance

---

### cfg-ioo-tuning: j2_inodeCacheSize の調整 { #cfg-ioo-tuning }

**重要度**: `A` / **用途**: 性能

**目的**: AIX 7.3 で既定 200 になった j2_inodeCacheSize を、低メモリ機で多数 open file する場合に増やす。

**前提**: root 権限。低メモリ警告（vmstat -v に inode buf extends/lookup increases）が観測される。

**手順**:

1. 現状確認:
   - `ioo -L j2_inodeCacheSize -L j2_metadataCacheSize`
2. inode 関連メトリクス確認:
   - `vmstat -v | grep -i inode`
3. 値を 400 に戻す（永続）:
   - `ioo -p -o j2_inodeCacheSize=400 -o j2_metadataCacheSize=400`
4. 確認:
   - `ioo -L j2_inodeCacheSize | head -3`


**期待出力**:

```
# ioo -L j2_inodeCacheSize
NAME                      CUR    DEF    BOOT   MIN    MAX    UNIT     TYPE
                          DEPENDENCIES
--------------------------------------------------------------------------------
j2_inodeCacheSize         400    200    400    1      1000   numeric    D

```

**検証**: vmstat -v の `extends to inode buffers` 等の増加が止まる。アプリ側の open file 失敗が解消。

**ロールバック**: `ioo -d j2_inodeCacheSize -d j2_metadataCacheSize` で既定 200 に戻す。

**関連**: `ioo`, `vmstat`, `JFS2`

**出典**: S_AIX73_performance

---

