# 障害対応手順

> 掲載：**18 件（重要度 S/A/B/C × 用途、staple 15+ カバー）**（定番のみ）。除外項目は [10. 対象外項目](10-out-of-scope.md) を参照。

AIX 管理者が現場で遭遇する**日々の障害**を、**症状 → 確認 → 仮説 → 対処 → 検証 → 関連** の 6 部構成で記述。v3 で「7.3 移行プレチェック失敗ばかり」だった問題を是正し、LED hang / FS full / paging full / NFS stale / プロセス hung / login 不可 等の staple をカバー。

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

**重要度**: `A` / **用途**: ネットワーク

**目的**: errnotify や cron の通知メールが届かない場合の切り分け。

**前提**: sendmail 系 fileset インストール済。

**手順**:

1. **症状確認**: `mail admin@example.com` 送信後ログ追跡。
2. **sendmail 状態**:
   - `lssrc -s sendmail`
   - 停止していれば `startsrc -s sendmail`
3. **メールキュー確認**:
   - `mailq` または `sendmail -bp`
4. **DNS / SMTP 疎通**:
   - `nslookup -type=mx example.com`
   - `telnet example.com 25` で SMTP 応答
5. **/etc/sendmail.cf の relay host 確認**:
   - 検査: `grep DS /etc/sendmail.cf`
6. **個別問題: bos.net.tcp.sendmail 7.3.0.0 の libcrypto エラー**:
   - LPP_SOURCE が base+update 混在の場合、update_all で 7.3.3 へ進める


**期待出力**:

```
mailq が空、`mail` で送信したテストメールが届く。
```

**検証**: receiver 側で受信確認。

**ロールバック**: 誤った設定変更は前値に戻す。sendmail 再起動 `refresh -s sendmail`。

**関連**: `lssrc`, `mailq`

**出典**: S_AIX73_network

---

### inc-cron-fail: cron ジョブが実行されない { #inc-cron-fail }

**重要度**: `A` / **用途**: cron

**目的**: cron に登録したジョブが動かない場合の切り分け。

**前提**: 対象ユーザの crontab 編集済。

**手順**:

1. **症状確認**: 期待時刻にジョブ実行されず。
2. **cron デーモン状態**:
   - `lssrc -s cron`
   - 停止していれば `startsrc -s cron`
3. **crontab エントリ確認**:
   - `crontab -l -u <user>`
4. **時刻指定の構文確認**:
   - 5 列（分 時 日 月 曜日）+ コマンド
5. **実行ログ**:
   - `tail /var/adm/cron/log`
6. **/etc/cron.allow / /etc/cron.deny の制限**:
   - 該当ユーザが許可されているか
7. **テスト**:
   - 1 分後の時刻でテスト entry を仕掛けて待つ


**期待出力**:

```
/var/adm/cron/log に該当時刻の `CMD: ...` 行が出る。
```

**検証**: 実ジョブの結果ファイル / 出力を確認。

**ロールバック**: 誤った crontab を `crontab -e` で元に戻す（事前にバックアップ取得推奨）。

**関連**: `lssrc`, `crontab`

**出典**: S_AIX73_osmanagement

---

### inc-package-install-fail: fileset インストール失敗 { #inc-package-install-fail }

**重要度**: `A` / **用途**: パッケージ

**目的**: installp 失敗（依存関係、空き容量、署名等）の切り分け。

**前提**: ソース、root 権限。

**手順**:

1. **症状確認**: installp 出力に Error / Failure。
2. **プレビュー再実行**:
   - `installp -p -aXd <Source> <Fileset>`
3. **依存関係エラー**:
   - "Selected Filesets" / "Failed Filesets" を見て不足 fileset を特定
   - 必要 fileset を含めて再 install
4. **/usr 空き不足**:
   - `df -g /usr`
   - -X オプションで自動 FS 拡張、または手動 chfs
5. **lppchk で既存整合性**:
   - `lppchk -v`
6. **個別: bos.net.tcp.sendmail 7.3.0.0 → libcrypto エラー**:
   - LPP_SOURCE の update を含めて update_all で進める
7. **snap 取得（IBM 対応）**:
   - `snap -ac`


**期待出力**:

```
installp -p で SUCCESS のリスト。本番 install で `Installation Summary` に Result=SUCCESS。
```

**検証**: `lslpp -L <fileset>` で State=C/A。`lppchk -v` で整合エラーなし。

**ロールバック**: applied 状態は `installp -r <fileset>` で reject。committed は overlay で前バージョン入れ直し。

**関連**: `installp`, `lslpp`, `lppchk`

**出典**: S_AIX73_install

---

### inc-core-dump: プロセスが core dump { #inc-core-dump }

**重要度**: `A` / **用途**: 性能

**目的**: アプリが core ファイルを残して落ちた場合の調査開始手順。

**前提**: core が cwd または core_compress で保存される設定。

**手順**:

1. **症状確認**: cwd に `core` ファイル、または `coreadm` 設定先。
2. **どのプロセスか**:
   - `file core` → "AIX core file ..., from <process name>"
3. **シンボル情報**:
   - 実行ファイルとライブラリが必要
   - `dbx <executable> core`
   - `where` でスタックトレース表示
4. **truss / tprof で再現**:
   - `truss -f -o /tmp/truss.out <command>`
5. **大量 core が出る場合**:
   - `coreadm` の dump 先確認、ファイルサイズ制限 `ulimit -c`


**期待出力**:

```
dbx の where 出力でクラッシュ箇所のスタックフレームが表示。
```

**検証**: アプリ側でパッチ適用 → 再現テストで core が出ないこと。

**ロールバック**: core を削除する場合 rm core。dump 設定を変更したら元に戻す。

**関連**: `dbx`, `truss`, `coreadm`

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

**重要度**: `A` / **用途**: ログ監査

**目的**: IBM サポートに提供する診断データを正しく取得する。

**前提**: /tmp/ibmsupt に十分な空き（数 GB 〜）。

**手順**:

1. **空き確認**:
   - `df -g /tmp`
2. **古い snap をクリア**:
   - `snap -r`
3. **全情報取得**:
   - `snap -ac`
4. **特定コンポーネントのみ**:
   - `snap general tcpip`
5. **生成物確認**:
   - `ls -lh /tmp/ibmsupt/snap.pax.gz`
6. **送信**:
   - PMR / case にアップロード


**期待出力**:

```
/tmp/ibmsupt/snap.pax.gz が生成（数百 MB 〜 GB）。
```

**検証**: ファイルサイズが妥当（小さすぎる場合 snap が途中失敗）。`pax -zvf snap.pax.gz | head` で内容確認。

**ロールバック**: snap -r で削除。

**関連**: `snap`

**出典**: S_AIX73_osmanagement

---

### inc-package-uninstall-stuck: パッチ適用後に挙動不良（installp -r ロールバック） { #inc-package-uninstall-stuck }

**重要度**: `A` / **用途**: パッケージ

**目的**: 適用したパッチで業務影響が出た場合の切り戻し。

**前提**: applied 状態の fileset（committed 不可）。

**手順**:

1. **症状確認**: アプリ動作不良、特定 fileset 適用直後。
2. **状態確認**:
   - `lslpp -L <fileset>` → State=A（Applied）であること
   - State=C（Committed）の場合は前バージョンを overlay install するしかない
3. **reject 実行**:
   - `installp -r <fileset>`
4. **整合性確認**:
   - `lppchk -v`
5. **再起動が必要な場合**:
   - shutdown -Fr now


**期待出力**:

```
installp -r 完了後 `lslpp -L <fileset>` で前バージョン表示、State=C/A。
```

**検証**: アプリ動作復帰。問題が解消したことを業務側で確認。

**ロールバック**: 再 installp -aXd で再適用。

**関連**: `installp`, `lslpp`, `lppchk`

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

