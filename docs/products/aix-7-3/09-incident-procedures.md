# 障害対応手順

> 掲載：**18 件（A 級 6 が詳細版、B/C 級は概要版）**（定番のみ）。除外項目は [10. 対象外項目](10-out-of-scope.md) を参照。

**v9 から: 重要度 A 級 6 件が詳細版（100-200 行）。S 級は概要版（既存）、B/C 級も概要版。**

## 重要度 × 用途 マトリクス

| 重要度＼用途 | cron | ストレージFS | ネットワーク | パッケージ | ユーザ認証 | ログ監査 | 性能 | 起動停止 |
|---|---|---|---|---|---|---|---|---|
| **S** | — | [inc-fs-full](#inc-fs-full)<br>[inc-nfs-stale](#inc-nfs-stale)<br>[inc-fsck-required](#inc-fsck-required)<br>[inc-lv-not-recognized](#inc-lv-not-recognized)<br>[inc-disk-replace](#inc-disk-replace) | [inc-network-down](#inc-network-down) | — | [inc-login-locked](#inc-login-locked) | [inc-errpt-hardware-error](#inc-errpt-hardware-error) | [inc-process-hung](#inc-process-hung)<br>[inc-perf-degradation](#inc-perf-degradation)<br>[inc-paging-full](#inc-paging-full) | [inc-boot-fail-led](#inc-boot-fail-led) |
| **A** | [inc-cron-fail](#inc-cron-fail) | — | [inc-mail-fail](#inc-mail-fail) | [inc-package-install-fail](#inc-package-install-fail)<br>[inc-package-uninstall-stuck](#inc-package-uninstall-stuck) | — | [inc-snap-collect](#inc-snap-collect) | [inc-core-dump](#inc-core-dump) | — |
| **B** | — | — | — | — | — | — | — | — |
| **C** | — | — | — | — | — | — | — | — |

---

## 詳細手順

### inc-boot-fail-led: 起動失敗（LED hang / SMS 進入できず） { #inc-boot-fail-led }

**重要度**: `S` / **用途**: 起動停止

**目的**: 電源 ON 後 OS が立ち上がらず LED に特定コードが残る、または SMS メニュー以前で停止する場合の切り分け。

**前提**: HMC または直結コンソール。

**手順**:

1. **症状確認**: HMC のオペレータパネルで LED コードを記録（例: 0c31, 0c32, 888）。
2. **仮説 A: ブートデバイスが見えない**:
   - SMS メニューに進入（電源 ON 直後 F1 / 1 / 5）
   - "Select Boot Options" → "List All Devices"
   - 期待した hdisk が出ているか
   - 出ていなければ FC zoning / SAS 結線を疑う
3. **仮説 B: BLV 破損**:
   - サービスモードで boot（DVD/NIM）
   - rootvg を import → `bosboot -ad /dev/ipldevice` で BLV 再作成
   - `bootlist -m normal hdisk0 hdisk1` 再設定
4. **仮説 C: alog で boot 履歴調査**:
   - サービスモードで `alog -t boot -o | tail -200`


**期待出力**:

```
alog -t boot 出力に Configuration Manager の進行が止まった行が見える。仮説に応じてエラーメッセージ（Cannot open / Missing fileset 等）が手がかり。
```

**検証**: 対応後、通常モードで boot し `who -r` で run level 2 表示、`oslevel -s` が返ること。

**ロールバック**: ハードウェア交換が必要な場合は IBM サポート連絡（snap で診断データ取得後）。

**関連**: `bosboot`, `bootlist`, `alog`, `SMS`

**出典**: S_AIX73_install

---

### inc-login-locked: ログイン不可（root locked / パスワード失敗超過） { #inc-login-locked }

**重要度**: `S` / **用途**: ユーザ認証

**目的**: ユーザがログインできない場合の切り分け（パスワード忘れ・lock・shell 不正）。

**前提**: 別の root 権限ユーザでアクセス可能、または single-user mode で boot。

**手順**:

1. **症状確認**: ssh/console で "3004-007 You entered an invalid login name or password" or "3004-303 Your account has been locked"。
2. **仮説 A: パスワード失敗カウンタ超過**:
   - `lsuser -a unsuccessful_login_count account_locked alice`
   - `chsec -f /etc/security/lastlog -a unsuccessful_login_count=0 -s alice`
   - `chuser account_locked=false alice`
3. **仮説 B: パスワード期限切れ**:
   - `pwdadm -c alice`（カウンタ復元）または `passwd alice`（root が新パス設定）
4. **仮説 C: shell や home が不正**:
   - `lsuser -a shell home alice`
   - shell 実体存在確認: `ls -l /usr/bin/ksh`
   - home が umount されていないか: `df -g /home`
5. **仮説 D: root 自身がロックされた**:
   - HMC から service mode で boot → fsck → /etc/security/lastlog 編集


**期待出力**:

```
上記いずれかで原因特定。`lsuser -a unsuccessful_login_count account_locked alice` で unsuccessful_login_count=0 / account_locked=false。
```

**検証**: alice で再ログイン成功。

**ロールバック**: 意図しないロック解除なら chuser account_locked=true alice で再ロック。

**関連**: [cfg-passwd-policy](08-config-procedures.md#cfg-passwd-policy), `lsuser`, `chsec`, `pwdadm`

**出典**: S_AIX73_security

---

### inc-fs-full: ファイルシステム満杯（FS 100%） { #inc-fs-full }

**重要度**: `S` / **用途**: ストレージFS

**目的**: df -g で 100% / disk full エラーが出ている FS の特定と即時対応。

**前提**: root 権限。

**手順**:

1. **症状確認**: アプリログ "no space left on device" / `df -g` で %Used=100。
2. **どの FS か特定**:
   - `df -g | sort -k5 -r | head`
3. **仮説 A: 単純に古いログ・dump が残っている**:
   - `find /var -size +100M -type f -mtime +7 | xargs ls -lh`
   - `errclear 30` で errlog 古いものを削除
   - `find /tmp -mtime +7 -type f -exec ls -lh {} \;` → 確認後 rm
4. **仮説 B: i-node 枯渇**:
   - `df -i /var`（%Iused が 100% になっていないか）
   - 不要小ファイルを削除する以外なし（FS 拡張だけでは inode は増えない、ただし JFS2 は dynamic inode）
5. **仮説 C: 拡張する**:
   - `chfs -a size=+1G /var`
6. **確認**:
   - `df -g /var`


**期待出力**:

```
df -g /var の Free 列が 0 以外になる。アプリ側のエラーが解消。
```

**検証**: `tail -f /var/adm/messages` で disk full エラーが止まる。アプリの再起動が必要な場合あり。

**ロールバック**: 拡張は通常戻さない（縮小は危険）。削除したファイルが必要だった場合はバックアップから復元。

**関連**: [cfg-fs-extend](08-config-procedures.md#cfg-fs-extend), `df`, `chfs`, `errclear`

**出典**: S_AIX73_jfs2

---

### inc-process-hung: プロセス hung（応答なし） { #inc-process-hung }

**重要度**: `S` / **用途**: 性能

**目的**: 特定プロセスが CPU 100% / I/O wait / 無応答状態になった場合の切り分け。

**前提**: root 権限。

**手順**:

1. **症状確認**: アプリ無応答、`ps -ef | grep <name>` で SI=100 等。
2. **CPU か I/O か**:
   - `topas` → CPU% / Wait%
   - 該当プロセスを `ps -mo THREAD -p <pid>` で詳細
3. **仮説 A: CPU 100% でループ**:
   - `procstack <pid>`（procstack -F でフルスタック）
   - core 取得 → `kill -ABRT <pid>`（core dump 生成）
4. **仮説 B: ディスク I/O 待ち（D state）**:
   - `iostat -DRTl 5 6`
   - 該当 hdisk のレイテンシ確認 → ストレージ側障害疑い
5. **仮説 C: NFS stale**:
   - `mount | grep nfs` → 該当 NFS マウントを `umount -f`
6. **最終手段（順序厳守）**:
   - `kill <pid>` → 数秒待つ → 効かなければ `kill -9 <pid>`


**期待出力**:

```
procstack でハング箇所特定。多くの場合 IO 待ち or 内部 mutex。kill 後に topas から CPU%・PID が消える。
```

**検証**: アプリ再起動 → 通常応答。topas で異常 CPU/IO がない。

**ロールバック**: kill 後にデータ整合性確認（DB なら recover、ファイル書き込みアプリなら直前ファイル確認）。

**関連**: `ps`, `kill`, `topas`, `procstack`

**出典**: S_AIX73_performance

---

### inc-perf-degradation: 性能低下（応答時間悪化） { #inc-perf-degradation }

**重要度**: `S` / **用途**: 性能

**目的**: 全体的にレスポンスが悪化したときの切り分け（CPU / メモリ / I/O / ネットワーク）。

**前提**: 性能基準値（平常時の topas / vmstat 値）が分かっていること。

**手順**:

1. **症状確認**: `topas` で CPU/Mem/Disk/Net の利用率を観察。
2. **CPU**:
   - `vmstat 5 12` の us+sy が常時 80%+ → CPU bound
   - `topas -P` で top プロセス特定
3. **メモリ**:
   - `vmstat -v | head` で page in/out、computational page steals の増加
   - `svmon -G` で free real memory
   - メモリ不足 → ページング → ディスク I/O 増加の連鎖
4. **ディスク I/O**:
   - `iostat -DRTl 5 6` で %tm_act 80%+ のディスクを特定
5. **ネットワーク**:
   - `netstat -v | grep -i error` でエラーカウンタ
   - `entstat -d en0` で詳細
6. **データ取得（IBM 対応）**:
   - `nmon -f -s 30 -c 120` で 30 秒×120 = 1 時間記録
   - `snap -ac` でフル取得


**期待出力**:

```
vmstat / iostat / netstat の組み合わせで bottleneck（CPU / Mem / Disk / Net）特定。
```

**検証**: 原因解消後、平常時のメトリクス値に戻る。

**ロールバック**: 誤った tunable 変更が原因なら `vmo -d`/`no -d`/`schedo -d` で既定値復元。

**関連**: `vmstat`, `iostat`, `topas`, `nmon`

**出典**: S_AIX73_performance

---

### inc-network-down: ネットワーク疎通不能 { #inc-network-down }

**重要度**: `S` / **用途**: ネットワーク

**目的**: 外部に通信できない場合の切り分け。

**前提**: root 権限。

**手順**:

1. **症状確認**: ping/ssh が通らない、アプリが connect 失敗。
2. **物理リンク**:
   - `entstat -d en0 | grep -i link`（Link Status: Up/Down）
   - 物理ケーブル / NIC LED 確認
3. **IP 設定**:
   - `ifconfig en0` → inet アドレス・netmask 確認
   - 設定がない / 不正 → `chdev -l en0 -a netaddr=... -a netmask=... -P`
4. **ルーティング**:
   - `netstat -rn` でデフォルトゲートウェイ確認
   - なければ `route add default <gw>`
5. **DNS**:
   - `nslookup www.ibm.com`
   - 失敗なら /etc/resolv.conf を確認
6. **ファイアウォール / IPsec**:
   - `lssrc -s ipsec_v4`
   - `genfilt -v 4`（IPsec フィルタ）


**期待出力**:

```
ping <gw> 通る → ping 8.8.8.8 通る → nslookup ibm.com 通る、の順に進めば疎通確認完了。
```

**検証**: 業務アプリの通信再開を確認。

**ロールバック**: 誤った chdev は -P で次回 boot に切り替えるか、元値で再 chdev。

**関連**: `ifconfig`, `netstat`, `ping`, `/etc/resolv.conf`

**出典**: S_AIX73_network

---

### inc-nfs-stale: NFS マウントが stale { #inc-nfs-stale }

**重要度**: `S` / **用途**: ストレージFS

**目的**: ls 等で `Stale NFS file handle` エラーが出るマウントの解消。

**前提**: root 権限。NFS サーバ側の状況把握。

**手順**:

1. **症状確認**: `ls /mnt/nfsdata` → "Stale NFS file handle"。
2. **アクセス中プロセス確認**:
   - `fuser -cuk /mnt/nfsdata`（プロセス kill 警告）
3. **マウント情報確認**:
   - `mount | grep /mnt/nfsdata`
4. **強制 umount**:
   - `umount -f /mnt/nfsdata`
   - 効かなければ `umount -F /mnt/nfsdata`
5. **NFS サーバ側を確認**:
   - サーバで `exportfs` / 該当 FS のマウント状態
6. **再マウント**:
   - `mount /mnt/nfsdata`


**期待出力**:

```
umount 後 mount 再実行で `ls /mnt/nfsdata` が通常通り返る。
```

**検証**: ファイル read/write が正常。アプリエラーが消える。

**ロールバック**: stale 自体に戻す概念はない。umount/mount で正常化。

**関連**: `mount`, `umount`, `fuser`, `exportfs`

**出典**: S_AIX73_network

---

### inc-fsck-required: fsck が必要な FS（マウント不能） { #inc-fsck-required }

**重要度**: `S` / **用途**: ストレージFS

**目的**: 強制電源 OFF や I/O エラー後に FS マウント不能になった場合の修復。

**前提**: 対象 FS が unmount 済（root の場合は service mode）。

**手順**:

1. **症状確認**: mount /data → "Filesystem is not clean - run fsck"。
2. **対象 FS 特定**:
   - `lsfs /data`（基底 LV を確認）
3. **fsck 実行（自動 yes）**:
   - `fsck -y /dev/datalv`
4. **JFS2 の場合は INLINE log のリプレイ**:
   - JFS2 は通常自動的に INLINE log でリプレイされるので fsck 不要が普通
   - メタデータ破損疑いなら `fsck -p /dev/datalv`
5. **再マウント**:
   - `mount /data`


**期待出力**:

```
fsck 終了時に `FILE SYSTEM IS NOW CLEAN` 等のメッセージ。マウントが通る。
```

**検証**: df /data が通常表示。重要ファイル open 試行で問題なし。

**ロールバック**: fsck で取り戻せないファイルは lost+found に移動される（手動復元 or バックアップから戻す）。

**関連**: `fsck`, `mount`, `JFS2`

**出典**: S_AIX73_jfs2

---

### inc-mail-fail: sendmail でメール送信失敗 { #inc-mail-fail }

**重要度**: `A 級詳細版` / **用途**: ネットワーク

#### 目的

errnotify や cron の通知メールが届かない場合の切り分け。

#### 前提条件

- root 権限
- sendmail 系 fileset インストール済（lslpp -L bos.net.tcp.sendmail）

#### 手順

##### Step 1: sendmail 状態確認

**コマンド**:

```
lssrc -s sendmail
```

**期待される出力**:

```
Subsystem         Group            PID          Status
 sendmail         tcpip            12345        active
```

**注意点**:

- Status=inoperative なら startsrc -s sendmail で起動。

##### Step 2: メールキュー確認

**コマンド**:

```
mailq
```

**期待される出力**:

```
Mail queue is empty
（または）
                /var/spool/mqueue (1 request)
-----Q-ID----- --Size-- -----Q-Time----- ------------Sender/Recipient-----------
gA12345         1234 Mon May  4 10:00 root@my-server
                                         admin@example.com
```

**注意点**:

- キューにメッセージが残っているなら配信失敗中。
- sendmail -bp は mailq と同じ。

##### Step 3: DNS / SMTP 疎通確認

**コマンド**:

```
nslookup -type=mx example.com
telnet example.com 25
```

**期待される出力**:

```
example.com    mail exchanger = 10 mx1.example.com.

Trying 192.168.10.20...
Connected to mx1.example.com.
220 mx1.example.com ESMTP
```

**注意点**:

- MX レコード解決失敗 → DNS 設定確認。
- SMTP 220 応答なし → ファイアウォール、メールサーバ停止確認。

##### Step 4: /etc/sendmail.cf の relay host 確認

**コマンド**:

```
grep '^DS' /etc/sendmail.cf
```

**期待される出力**:

```
DSmx1.example.com
```

**注意点**:

- DS 行（または DSMX）で relay host 指定。
- relay host 経由送信の組織では設定必須。

##### Step 5: テストメール送信

**コマンド**:

```
echo 'test' | mail -s 'test from $(hostname)' admin@example.com
```

**期待される出力**:

```
（出力なし、配信開始）
```

**注意点**:

- /var/log/syslog または /var/spool/mqueue でログ確認。

#### 検証

- mailq が空
- 受信側でテストメール受信確認
- /var/spool/mqueue 配下のキューファイル消失

#### ロールバック

設定変更がある場合のみ巻き戻し。

通常は問題解決の方向で対応。

#### 関連エントリ

- **用語**: [TCP/IP](#tcp-ip), [SRC](#src)
- **コマンド**: [`lssrc`](01-commands.md#lssrc), [`startsrc`](01-commands.md#startsrc), [`refresh`](01-commands.md#refresh), [`mailq`](01-commands.md#mailq), [`nslookup`](01-commands.md#nslookup)
- **設定**: /etc/sendmail.cf, /etc/aliases
- **関連手順**: [cfg-syslog](08-config-procedures.md#cfg-syslog), [cfg-dns](08-config-procedures.md#cfg-dns)

#### 典型的な障害パターン

**症状**: AIX 7.3 の bos.net.tcp.sendmail で libcrypto エラー

- **原因**: OpenSSL 3.0 で libcrypto_compat 削除、古い sendmail が依存
- **対処**: update_all で 7.3.3+ へ進める

**症状**: mailq に大量蓄積

- **原因**: relay host 不通、または送信先 DNS 解決失敗
- **対処**: telnet で SMTP 疎通、nslookup -type=mx で MX 確認

**症状**: 送信は成功するが受信側が spam 判定

- **原因**: 送信元 IP の逆引き / SPF / DKIM 未設定
- **対処**: 受信側管理者に確認、DNS 側で設定

**出典**: S_AIX73_network

---

### inc-cron-fail: cron ジョブが実行されない { #inc-cron-fail }

**重要度**: `A 級詳細版` / **用途**: cron

#### 目的

cron に登録したジョブが期待時刻に動かない場合の切り分け。

#### 前提条件

- root 権限または対象ユーザ権限
- 対象ユーザの crontab 編集済

#### 手順

##### Step 1: cron デーモン状態

**コマンド**:

```
lssrc -s cron
```

**期待される出力**:

```
Subsystem         Group            PID          Status
 cron             cron             12345        active
```

**注意点**:

- Status=inoperative なら startsrc -s cron で起動。
- PID 表示なしの場合は inittab で起動制御確認。

##### Step 2: crontab エントリ確認

**コマンド**:

```
crontab -l -u alice
crontab -l   # 自分の
```

**期待される出力**:

```
0 9 * * * /home/alice/scripts/daily_report.sh
*/30 * * * * /home/alice/scripts/check.sh > /tmp/check.log 2>&1
```

**注意点**:

- 5 列（分 時 日 月 曜日）+ コマンド。
- コメント行は # で。

##### Step 3: 実行ログ確認

**コマンド**:

```
tail -50 /var/adm/cron/log
ls -la /var/adm/cron/log
```

**期待される出力**:

```
! root started CMD: /home/alice/scripts/daily_report.sh
! alice started CMD: /home/alice/scripts/check.sh > /tmp/check.log 2>&1
```

**注意点**:

- log ファイルに該当 CMD 行があれば cron は実行を試みた。
- なければ cron が認識していない。

##### Step 4: /etc/cron.allow と /etc/cron.deny の確認

**コマンド**:

```
ls -la /etc/cron.allow /etc/cron.deny 2>&1
cat /etc/cron.allow /etc/cron.deny 2>/dev/null
```

**期待される出力**:

```
-rw-r--r--    1 root     system          50 May 04 10:00 /etc/cron.allow

# /etc/cron.allow:
root
alice
```

**注意点**:

- /etc/cron.allow があれば、リスト掲載ユーザのみ cron 利用可。
- /etc/cron.deny があれば、リスト掲載ユーザは cron 利用不可。
- 両方ない場合: AIX 既定で root 以外は不可。

##### Step 5: テスト実行（1 分後）

**コマンド**:

```
# 1 分後の時刻でテスト
crontab -e
# 追加: * * * * * date >> /tmp/cron_test.log
# 1 分待って:
ls -la /tmp/cron_test.log
cat /tmp/cron_test.log
```

**期待される出力**:

```
-rw-r--r--    1 alice    staff           29 May  4 10:35 /tmp/cron_test.log

Mon May  4 10:35:00 JST 2026
```

**注意点**:

- ファイルに時刻行があれば cron 動作中。
- なければ Step 1〜4 のいずれかで問題。

#### 検証

- /var/adm/cron/log に該当 CMD 行
- 期待した時刻にスクリプトの結果ファイル更新
- アプリ側の処理結果確認

#### ロールバック

誤った crontab エントリを `crontab -e` で削除。

事前に `crontab -l > /tmp/crontab.bak.$(date +%Y%m%d)` で保管しておくこと。

#### 関連エントリ

- **用語**: [SRC](#src)
- **コマンド**: [`lssrc`](01-commands.md#lssrc), [`crontab`](01-commands.md#crontab), [`at`](01-commands.md#at)
- **設定**: /var/spool/cron/crontabs/, /etc/cron.allow, /etc/cron.deny, /var/adm/cron/log
- **関連手順**: [cfg-syslog](08-config-procedures.md#cfg-syslog)

#### 典型的な障害パターン

**症状**: /var/adm/cron/log に CMD 行はあるが結果ファイル無し

- **原因**: コマンド実行時にエラー（PATH 不足、権限、依存ファイル無し）
- **対処**: コマンドを `>> /tmp/log.out 2>&1` で stderr 含めてリダイレクト、PATH を crontab 先頭に PATH=... 形式で明示

**症状**: cron デーモンが頻繁に inoperative

- **原因**: cron プロセスのリソース問題、または log ファイル満杯
- **対処**: /var/adm/cron/log を rotate、free space 確認

**症状**: crontab -e で `you (alice) are not authorized`

- **原因**: cron.allow に未登録、または cron.deny に登録
- **対処**: root が /etc/cron.allow に該当ユーザ追加

**出典**: S_AIX73_osmanagement

---

### inc-package-install-fail: fileset インストール失敗 { #inc-package-install-fail }

**重要度**: `A 級詳細版` / **用途**: パッケージ

#### 目的

installp 失敗（依存関係、空き容量、署名等）の切り分け。

#### 前提条件

- ソース、root 権限
- /tmp /usr の空き容量

#### 手順

##### Step 1: プレビュー再実行

**コマンド**:

```
installp -p -aXd /export/lpp_source bos.adt.libm
```

**期待される出力**:

```
SUCCESSES                          ← 成功時
---------
  Selected Filesets
  -----------------
  bos.adt.libm                  7.3.4.0     # ...

（または）

FAILURES                          ← 失敗時
---------
  Selected fileset requisites are missing.
  bos.adt.include 7.3.4.0 is required
```

**注意点**:

- 本番 install 前に必ず -p でプレビュー。
- FAILURES セクションで原因特定。

##### Step 2: 依存関係エラーの場合

**コマンド**:

```
# 不足 fileset を抽出
grep "is required" /tmp/preview_*.log
# その fileset を含めて再 install
installp -aXd /export/lpp_source bos.adt.libm bos.adt.include
```

**期待される出力**:

```
Selected Filesets リストに依存も含まれる
```

**注意点**:

- -g オプションで依存自動取り込み。
- 依存元 fileset がソースに存在することを ls で確認。

##### Step 3: /usr 空き不足

**コマンド**:

```
df -g /usr
chfs -a size=+1G /usr   # 拡張
```

**期待される出力**:

```
Filesystem    GB blocks      Free %Used    Mounted on
/dev/hd2           5.00      4.00   20%   /usr
```

**注意点**:

- -X オプション付きで installp 実行すれば自動拡張。
- VG に空き PP がない場合は extendvg で PV 追加が事前必要。

##### Step 4: lppchk で既存整合性

**コマンド**:

```
lppchk -v
```

**期待される出力**:

```
（出力なし＝整合 OK）

または:
lppchk:  0504-206 ファイル ... が見つかりません
```

**注意点**:

- 整合性問題があれば該当 fileset を再 install で修復。

##### Step 5: 個別ケース: bos.net.tcp.sendmail 7.3.0.0 で libcrypto エラー

**コマンド**:

```
# update_all で 7.3.3+ へ進める
installp -aXd /export/lpp_source_7300_03 all
```

**期待される出力**:

```
Result=SUCCESS
```

**注意点**:

- AIX 7.3.0.0 + OpenSSL 3.0 の既知問題。SP 適用で解決。

##### Step 6: snap 取得（IBM サポート対応）

**コマンド**:

```
snap -ac
```

**期待される出力**:

```
/tmp/ibmsupt/snap.pax.gz 生成
```

**注意点**:

- IBM サポートに提供する診断データ。
- 事前に snap -r で旧データクリア。

#### 検証

- installp -p でプレビュー成功
- 本 install で Installation Summary に Result=SUCCESS
- lslpp -L で State=C/A
- lppchk -v で整合エラーなし

#### ロールバック

applied 状態なら installp -r <fileset> で reject。

committed 状態なら旧 version の lpp_source から overlay install。

事前に mksysb 取得済の場合は restore も選択肢。

#### 関連エントリ

- **用語**: [fileset](#fileset), [LPP](#lpp), [VRMF](#vrmf)
- **コマンド**: [`installp`](01-commands.md#installp), [`lslpp`](01-commands.md#lslpp), [`lppchk`](01-commands.md#lppchk), [`snap`](01-commands.md#snap)
- **設定**: /usr/lib/objrepos
- **関連手順**: [cfg-package-install](08-config-procedures.md#cfg-package-install), [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup)

#### 典型的な障害パターン

**症状**: preview で Selected fileset requisites are missing

- **原因**: 依存 fileset が lpp_source にない
- **対処**: Failures に列挙された fileset を追加、-g オプションで自動取り込み

**症状**: /usr 容量不足

- **原因**: -X オプション忘れ、または VG 空き PP なし
- **対処**: -X 追加、または事前 chfs で拡張

**症状**: Installation Summary に Result=FAILED

- **原因**: ディスクエラー、署名検証失敗、依存解決失敗等
- **対処**: tail -100 /var/adm/ras/installp.summary.log で詳細確認

**出典**: S_AIX73_install

---

### inc-core-dump: プロセスが core dump { #inc-core-dump }

**重要度**: `A 級詳細版` / **用途**: 性能

#### 目的

アプリが core ファイルを残して落ちた場合の調査開始手順。

#### 前提条件

- core が cwd または coreadm で保存される設定
- 実行ファイルとライブラリへのアクセス権

#### 手順

##### Step 1: どのプロセスか特定

**コマンド**:

```
file /opt/myapp/core
```

**期待される出力**:

```
/opt/myapp/core: AIX core file 64-bit, fulldump - Wed May  4 10:20:00 2026, from "myapp_main"
```

**注意点**:

- core ファイルから生成プロセス名と日時取得。
- fulldump = メモリ全部、partial = 一部のみ。

##### Step 2: シンボル情報を読む

**コマンド**:

```
dbx /opt/myapp/myapp_main /opt/myapp/core
(dbx) where
(dbx) print errno
(dbx) thread
(dbx) quit
```

**期待される出力**:

```
Type 'help' for help.
[reading symbolic information]
[using memory image in /opt/myapp/core]
Segmentation fault in __memcpy at 0x10001234
0x10001234 (__memcpy+0x14)  90840000          stw    r4,0x0(r4)

(dbx) where
__memcpy(...) at 0x10001234
my_function(...), line 45 in "myapp_main.c"
main(...), line 12 in "myapp_main.c"
```

**注意点**:

- where でクラッシュ箇所のスタックフレーム表示。
- 実行ファイルが strip されていなければ関数名が出る。
- ライブラリの symbol も必要なら dbx -a <pid> で attach する別手法も。

##### Step 3: truss で再現調査

**コマンド**:

```
truss -f -o /tmp/truss.out /opt/myapp/myapp_main
```

**期待される出力**:

```
truss 出力に system call トレース:
open("/etc/myapp.conf", O_RDONLY) = 3
read(3, ..., 4096) = 1234
close(3) = 0
... 中略 ...
SIGSEGV (Segmentation fault, dumped core)
```

**注意点**:

- -f で子プロセスも追跡。
- クラッシュ直前の system call が手がかり。

##### Step 4: 大量 core が出る場合の制御

**コマンド**:

```
coreadm   # 設定確認
ulimit -c unlimited   # core サイズ無制限
ulimit -c 0           # core 取得禁止
```

**期待される出力**:

```
     global core file pattern: /var/cores/core.%n.%f.%p
     init core file pattern: core
        global core dumps: enabled
   per-process core dumps: enabled
```

**注意点**:

- coreadm は dump 設定（保存先パターン）。
- ulimit はサイズ制限（プロセス単位）。

#### 検証

- dbx where でクラッシュ箇所特定
- 真因（NULL pointer / 配列 overrun / signal 等）が分かる
- アプリ側でパッチ適用 → 再現テストで core 出ないこと

#### ロールバック

core 削除: rm /opt/myapp/core

dump 設定変更したら元に戻す: coreadm -d 設定削除

#### 関連エントリ

- **用語**: sysdump, [kdb](#kdb)
- **コマンド**: [`dbx`](01-commands.md#dbx), [`truss`](01-commands.md#truss), [`coreadm`](01-commands.md#coreadm), [`snap`](01-commands.md#snap), [`kill`](01-commands.md#kill)
- **設定**: /var/cores, ulimit -c
- **関連手順**: [inc-process-hung](09-incident-procedures.md#inc-process-hung), [inc-snap-collect](09-incident-procedures.md#inc-snap-collect)

#### 典型的な障害パターン

**症状**: dbx で `cannot find symbol`

- **原因**: 実行ファイルが strip 済（symbol 削除）
- **対処**: 開発元から非 strip 版を入手、または .debug ファイル併用

**症状**: core が空（0 byte）

- **原因**: ulimit -c 0、または FS full
- **対処**: ulimit -c unlimited、df -g で空き確認

**症状**: core dump がそもそも生成されない

- **原因**: プロセスが SIGKILL 受信（dump フェーズ前に終了）
- **対処**: kill -9 を避ける、SIGTERM で待つ

**出典**: S_AIX73_kerneldebugger

---

### inc-errpt-hardware-error: errpt にハードウェアエラー多発 { #inc-errpt-hardware-error }

**重要度**: `S` / **用途**: ログ監査

**目的**: errpt -d H で大量にディスク・FC・メモリエラーが出ている場合の切り分け。

**前提**: root 権限、HMC アクセス。

**手順**:

1. **症状確認**: `errpt -d H | head -20` で集中して同種エラー。
2. **詳細表示**:
   - `errpt -aj <ERROR_ID>`
   - LABEL, RESOURCE_NAME, SENSE_DATA を記録
3. **ハードディスクなら**:
   - `lsattr -El hdiskN` で path 状態
   - `lspath -l hdiskN` で MPIO 状態
4. **FC アダプタなら**:
   - `errpt -aj <ID> | grep -A5 'Error Description'`
   - HMC 側で該当 LPAR のリソース確認
5. **メモリなら**:
   - HMC で Service Reference Code (SRC) 確認、IBM サポート要連絡
6. **データ取得（IBM 対応）**:
   - `snap -ac` → 提供


**期待出力**:

```
errpt -aj 出力に詳細メッセージ。SENSE_DATA からハードウェア部位特定。
```

**検証**: ハードウェア交換後 errpt 新規記録なし。`errclear` で古いエラー削除。

**ロールバック**: ハードウェア側問題は通常 IBM 対応。OS 側で抑制するのは推奨されない。

**関連**: `errpt`, `snap`, `errclear`

**出典**: S_AIX73_osmanagement

---

### inc-lv-not-recognized: LV / VG 認識せず（importvg 失敗） { #inc-lv-not-recognized }

**重要度**: `S` / **用途**: ストレージFS

**目的**: ディスク交換・LPAR 移動後に VG が認識されない場合の対応。

**前提**: 対象 PV が `lspv` で見える。

**手順**:

1. **症状確認**: `lsvg` に当該 VG なし、`mount` できない。
2. **PV の状態確認**:
   - `lspv` で対象 hdisk が見えるか
   - 見えなければ `cfgmgr -v`
3. **VG をインポート**:
   - `importvg -y datavg hdisk1`
   - VGDA から自動的に LV を取り込む
4. **varyon**:
   - `varyonvg datavg`
5. **マウント**:
   - `mount /data`
6. **整合性**:
   - `lsvg -l datavg` で LV 一覧、すべて open/syncd


**期待出力**:

```
importvg 後 `lsvg datavg` で active 表示。`lsvg -l datavg` で全 LV 列挙。
```

**検証**: df /data 表示、ファイル一覧が出る。

**ロールバック**: 誤って importvg した場合は `varyoffvg datavg` → `exportvg datavg`。

**関連**: `lspv`, `importvg`, `varyonvg`, `exportvg`

**出典**: S_AIX73_lvm

---

### inc-paging-full: Paging Space 枯渇 { #inc-paging-full }

**重要度**: `S` / **用途**: 性能

**目的**: /dev/hd6 等 paging が満杯近くになり性能劣化・OOM-kill 状態の対応。

**前提**: root 権限。

**手順**:

1. **症状確認**: `lsps -a` で %Used が高い、アプリ malloc 失敗。
2. **状況確認**:
   - `lsps -a`
   - `vmstat -v | grep -i paging`
3. **どのプロセスがメモリ食いか**:
   - `svmon -G`
   - `svmon -P -O sortentity=pgsp,sortseg=pgsp -t 10`
4. **paging space 拡張（即時）**:
   - 既存 paging を拡張: `chps -s <PP数> hd6`
   - または新規: `mkps -s <PP数> -a -n rootvg`
5. **メモリリークアプリは再起動**:
   - 影響 PID を `kill` で再起動
6. **恒久対策**:
   - LV 拡張、メモリ増設、tunable 見直し（minperm%、minfree）


**期待出力**:

```
lsps -a の %Used が下がる。アプリ malloc 失敗が消える。
```

**検証**: topas で free real memory が回復、paging in/out が正常範囲。

**ロールバック**: 拡張は通常戻さない。新規 paging は `swapoff /dev/<新>` → `rmps`。

**関連**: `lsps`, `svmon`, `mkps`, `chps`

**出典**: S_AIX73_performance

---

### inc-snap-collect: snap でサポート用データ取得 { #inc-snap-collect }

**重要度**: `A 級詳細版` / **用途**: ログ監査

#### 目的

IBM サポートに提供する診断データを正しく取得する。

#### 前提条件

- /tmp/ibmsupt に十分な空き（数 GB〜）
- root 権限

#### 手順

##### Step 1: 空き確認

**コマンド**:

```
df -g /tmp
```

**期待される出力**:

```
Filesystem    GB blocks      Free %Used    Mounted on
/dev/hd3           5.00      3.50   30%   /tmp
```

**注意点**:

- /tmp に最低 2GB 程度の空き必要。
- 不足なら chfs -a size=+2G /tmp で拡張。

##### Step 2: 古い snap をクリア

**コマンド**:

```
snap -r
```

**期待される出力**:

```
removed: /tmp/ibmsupt/general
removed: /tmp/ibmsupt/lvm
... (略)
```

**注意点**:

- 前回の snap データを削除。
- yes プロンプトに対して y で承認。

##### Step 3: 全情報取得

**コマンド**:

```
snap -ac
```

**期待される出力**:

```
Checking and initializing directory structure...
Gathering general system information...
Gathering kernel information...
... (数分〜数十分)
Compressing into snap.pax.gz...
Compression complete.

snap.pax.gz is at /tmp/ibmsupt/snap.pax.gz
```

**注意点**:

- -a = all（全コンポーネント）、-c = compress（pax.gz 化）。
- 実行に数分〜数十分かかる場合あり。

##### Step 4: 特定コンポーネントのみ

**コマンド**:

```
snap general tcpip      # general + tcpip
snap general nfs        # general + nfs
snap general printer    # general + printer
```

**期待される出力**:

```
/tmp/ibmsupt/<component>/ 配下に出力
```

**注意点**:

- サポートが特定コンポーネントだけ要求した場合に使用。
- 全部取るより高速。

##### Step 5: 生成物確認

**コマンド**:

```
ls -lh /tmp/ibmsupt/snap.pax.gz
ls -la /tmp/ibmsupt/
```

**期待される出力**:

```
-rw-r--r--    1 root     system  234M  May 04 10:30  /tmp/ibmsupt/snap.pax.gz
```

**注意点**:

- ファイルサイズが 0 や極端に小さい場合は失敗。
- 通常 100MB〜数 GB。

##### Step 6: サポートへのアップロード

**コマンド**:

```
# IBM ECurep にアップロード
# https://www.ecurep.ibm.com/ で PMR/case 番号指定して送信
# または ftp で
ftp testcase.boulder.ibm.com
> user anonymous
> cd /toibm/aix
> bin
> put snap.pax.gz <PMR>.snap.pax.gz
> bye
```

**期待される出力**:

```
アップロード完了
```

**注意点**:

- ECurep 利用が標準。ftp は緊急時の代替。
- ファイル名にチケット番号を含める。

#### 検証

- /tmp/ibmsupt/snap.pax.gz が生成（数百 MB 〜 GB）
- pax -zvf snap.pax.gz | head で内容確認
- IBM サポートへのアップロード完了

#### ロールバック

snap -r で削除。

#### 関連エントリ

- **用語**: sysdump
- **コマンド**: [`snap`](01-commands.md#snap), [`errpt`](01-commands.md#errpt), [`df`](01-commands.md#df)
- **設定**: /tmp/ibmsupt
- **関連手順**: [inc-errpt-hardware-error](09-incident-procedures.md#inc-errpt-hardware-error), [cfg-dump-device](08-config-procedures.md#cfg-dump-device)

#### 典型的な障害パターン

**症状**: snap 中に `Cannot create temporary file`

- **原因**: /tmp 空き不足
- **対処**: df -g /tmp で確認、不要ファイル削除または chfs で拡張

**症状**: snap.pax.gz サイズが極端に小さい

- **原因**: コンポーネント収集が部分的に失敗
- **対処**: snap 出力ログ確認、個別コンポーネント別に再取得

**症状**: snap が中断（Ctrl+C 等）

- **原因**: ユーザ操作
- **対処**: snap -r で部分データ削除後、再 snap -ac

**出典**: S_AIX73_osmanagement

---

### inc-package-uninstall-stuck: パッチ適用後に挙動不良（installp -r ロールバック） { #inc-package-uninstall-stuck }

**重要度**: `A 級詳細版` / **用途**: パッケージ

#### 目的

適用したパッチで業務影響が出た場合の切り戻し。

#### 前提条件

- applied 状態の fileset（committed は不可）
- 当該 fileset の依存関係を満たす状態が直前にあったこと

#### 手順

##### Step 1: 状態確認

**コマンド**:

```
lslpp -L <fileset>
```

**期待される出力**:

```
  Fileset                      Level  State  Type  Description
  ----------------------------------------------------------------
  bos.adt.libm               7.3.4.0  A     F    Base Application Develop...
```

**注意点**:

- State=A（Applied）→ reject 可能。
- State=C（Committed）→ reject 不可、overlay install 必要。
- State=B（Broken）→ 整合性問題、修復後 reject。

##### Step 2: 履歴確認

**コマンド**:

```
lslpp -h <fileset>
```

**期待される出力**:

```
Fileset         Level     Action       Status       Date         Time
----------------------------------------------------------------------
Path: /usr/lib/objrepos
bos.adt.libm
                7.3.3.0   COMMIT       COMPLETE     04/15/26     08:00:00
                7.3.4.0   APPLY        COMPLETE     05/04/26     10:00:00
```

**注意点**:

- 前回の COMMIT level (7.3.3.0) に戻る。
- APPLY 後の操作履歴を全て確認。

##### Step 3: reject 実行

**コマンド**:

```
installp -r <fileset>
```

**期待される出力**:

```
Pre-deinstallation Verification...
... 中略 ...
+-----------------------------------------------------------------------------+
                            Installation Summary
+-----------------------------------------------------------------------------+
Name                        Level           Part        Event       Result
-------------------------------------------------------------------------------
bos.adt.libm                7.3.4.0         USR         REJECT      SUCCESS
```

**注意点**:

- Result=SUCCESS で reject 完了。
- 依存関係でブロックされた場合は -e で詳細 log 取得。

##### Step 4: 整合性確認

**コマンド**:

```
lppchk -v
```

**期待される出力**:

```
（出力なしなら OK）
```

**注意点**:

- 出力があれば整合性問題、修復必要。
- lppchk -c <fileset> で個別チェック。

##### Step 5: 再起動が必要な場合

**コマンド**:

```
# bosboot 必要か確認
bosboot -q
# 必要なら
bosboot -ad /dev/ipldevice
shutdown -Fr now
```

**期待される出力**:

```
bosboot: Boot image is 99008 512 byte blocks.
```

**注意点**:

- カーネル fileset reject の場合は bosboot + 再起動必要。
- 再起動後に oslevel -s で旧レベル確認。

#### 検証

- lslpp -L で前 version、State=C/A
- アプリ動作復帰、業務側で確認
- errpt に新規エラーが出ていない

#### ロールバック

再 installp -aXd で再適用（rollback の rollback）。

mksysb 取得済なら restore も選択肢。

#### 関連エントリ

- **用語**: [fileset](#fileset), [VRMF](#vrmf)
- **コマンド**: [`installp`](01-commands.md#installp), [`lslpp`](01-commands.md#lslpp), [`lppchk`](01-commands.md#lppchk), [`bosboot`](01-commands.md#bosboot)
- **関連手順**: [cfg-package-install](08-config-procedures.md#cfg-package-install), [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup)

#### 典型的な障害パターン

**症状**: installp -r で `Cannot reject committed fileset`

- **原因**: fileset が committed 状態
- **対処**: 旧 version の lpp_source から overlay install、または mksysb から restore

**症状**: reject で別 fileset の依存関係エラー

- **原因**: 他 fileset が当該 fileset の新 version に依存
- **対処**: 依存元も同時に reject、または依存元を旧 version 互換にロールバック

**症状**: 新規 fileset を applied → reject すると消える

- **原因**: 新規 install を reject すると完全削除（仕様）
- **対処**: 事前に mksysb 取得、または再 install の準備

**出典**: S_AIX73_install

---

### inc-disk-replace: 故障ディスクの交換（rootvg ミラー環境） { #inc-disk-replace }

**重要度**: `S` / **用途**: ストレージFS

**目的**: rootvg ミラー構成で 1 本のディスク（hdisk1）が故障した場合の交換手順。

**前提**: rootvg がミラー化済（cfg-rootvg-mirror 完了済）、HMC アクセス可能。

**手順**:

1. **症状確認**: `errpt | head` でディスクハードエラー、`lsvg -l rootvg` で stale PP。
2. **故障ディスクの確認**:
   - `lspv -p hdisk1` → missing
3. **ミラー解除**:
   - `unmirrorvg rootvg hdisk1`
   - `reducevg rootvg hdisk1`
4. **ODM から削除**:
   - `rmdev -dl hdisk1`
5. **物理交換** (HMC で OS 停止せず DLPAR remove → 物理交換 → DLPAR add)
6. **新ディスク認識**:
   - `cfgmgr -v`
   - `lspv` で新 hdisk1 確認
7. **再ミラー**:
   - `extendvg rootvg hdisk1`
   - `mirrorvg -S rootvg hdisk1`
   - `bosboot -ad /dev/hdisk1`
   - `bootlist -m normal hdisk0 hdisk1`


**期待出力**:

```
lsvg -l rootvg で全 LV が PPs=LPs*2、open/syncd。bootlist -m normal -o で hdisk0 hdisk1 表示。
```

**検証**: 片方ディスク(hdisk0)を擬似 offline にしても OS が動作継続できること（テスト環境で）。

**ロールバック**: 誤って正常ディスクを抜いた場合は同手順を逆順実行。

**関連**: [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror), `lspv`, `unmirrorvg`, `mirrorvg`, `bosboot`

**出典**: S_AIX73_lvm

---

