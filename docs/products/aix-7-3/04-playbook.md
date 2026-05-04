# タスクプレイブック

> **22 セル**を詳細化（v9）。各セルが目的/前提/手順/検証/rollback の構造で、関連する 08-config-procedures / 09-incident-procedures / 11-special-features への直接リンクを含みます。

**マトリクス**: 習熟度（入門/中級/上級）× シーン（構築/日常運用/バックアップ/障害対応/性能/マイグレ/セキュリティ/スケーリング）

## マトリクス（クリックで該当セクションへ）

| 習熟度＼シーン | 構築 | 日常運用 | バックアップ | 障害対応 | 性能 | マイグレ | セキュリティ | スケーリング |
|---|---|---|---|---|---|---|---|---|
| **入門** | [OS インストール → ホスト名/IP/DNS/N](#入門-構築) | [errpt / df 定期チェック、syslog ](#入門-日常運用) | [mksysb で月次 rootvg バックアップ](#入門-バックアップ) | [boot 失敗・ログイン不可・FS full の三](#入門-障害対応) | [topas / vmstat / iostat の](#入門-性能) | — | [ユーザ追加とパスワードポリシー、SSH 鍵配置](#入門-セキュリティ) | — |
| **中級** | [VG/LV 設計、JFS2 FS 配置、rootv](#中級-構築) | [errnotify でメール通知、cron 自動化](#中級-日常運用) | [mksysb + savevg、NIM image](#中級-バックアップ) | [性能低下切り分け、NFS stale、core 解](#中級-障害対応) | [TCP バッファ・MPIO queue_depth](#中級-性能) | [AIX 7.x → 7.3.4 マイグレ（prem](#中級-マイグレ) | [errnotify 監査連動、syslog 集中転](#中級-セキュリティ) | [FS 拡張、PV 追加、新規 VG 作成](#中級-スケーリング) |
| **上級** | [NIM サーバ、CAA リポジトリ、PowerHA](#上級-構築) | [snap でサポート用情報定期取得、性能ベースライ](#上級-日常運用) | [NIM 連携の bootable mksysb、別](#上級-バックアップ) | [kdb / dbx でカーネル / プロセスダンプ](#上級-障害対応) | [ASO/DSO 利用、large page 適用、](#上級-性能) | [Live Kernel Update、Live L](#上級-マイグレ) | [RBAC 設計、Trusted Execution](#上級-セキュリティ) | [DLPAR でリソース動的増減、LPM で別物理機](#上級-スケーリング) |

!!! note "空セル"
    入門 × マイグレ、入門 × スケーリング は意図的に空（中級以降推奨）。

---

## 入門 × 構築: OS インストール → ホスト名/IP/DNS/NTP の基本設定 { #入門-構築 }

**目的**: 新規 LPAR を業務利用可能な最低限の状態まで構築する。

**前提**:

- PowerVM HMC で LPAR 作成済（CPU/メモリ/I/O 割当て）
- AIX 7.3 インストールメディア（DVD or NIM サーバ）アクセス可能
- 命名・IP 設計済み

**手順**:

1. **インストール媒体から boot**
   - HMC で LPAR を起動、SMS メニューで boot device 選択
   - インストーラの「Default Install」または「Custom Install」を選択

2. **基本ロケール・タイムゾーン設定**
   - ロケール: ja_JP.UTF-8（または C）
   - タイムゾーン: JST-9（日本時間）

3. **インストール完了後の root ログイン**
   - 初回ログイン時にパスワード設定要求

4. **ホスト名・IP 設定**
   - `chdev -l inet0 -a hostname=my-server.example.com`
   - `chdev -l en0 -a netaddr=192.168.10.10 -a netmask=255.255.255.0`
   - 詳細: [cfg-hostname-ip](08-config-procedures.md#cfg-hostname-ip)

5. **DNS リゾルバ設定**
   - `vi /etc/resolv.conf`（domain / search / nameserver 行追加）
   - 詳細: [cfg-dns](08-config-procedures.md#cfg-dns)

6. **NTP 時刻同期**
   - `vi /etc/ntp.conf`（server 行追加）
   - `startsrc -s xntpd`
   - `chrctcp -S -a xntpd`
   - 詳細: [cfg-ntp](08-config-procedures.md#cfg-ntp)


**検証**:

- `hostname` で新ホスト名が返る
- `ifconfig en0` で新 IP 表示
- `nslookup www.ibm.com` で DNS 解決成功
- `lssrc -ls xntpd` で synchronised 表示

**rollback**: 再 install または mksysb から restore。個別設定は各 cfg-* 手順の rollback 参照。

**関連**: [cfg-hostname-ip](08-config-procedures.md#cfg-hostname-ip), [cfg-dns](08-config-procedures.md#cfg-dns), [cfg-ntp](08-config-procedures.md#cfg-ntp)

---

## 入門 × 日常運用: errpt / df 定期チェック、syslog 設定 { #入門-日常運用 }

**目的**: 新人 AIX 管理者の日課 — エラー監視と容量監視。

**前提**:

- root 権限でログイン可能
- errpt サブシステム稼働（既定で起動）

**手順**:

1. **朝の errpt チェック**
   - `errpt | head -20`（最新 20 件）
   - `errpt -d H | head` （ハードウェアエラーのみ）
   - 新規ハードエラーがあれば inc-errpt-hardware-error の手順へ

2. **df で容量チェック**
   - `df -g`（GB 単位で全 FS 表示）
   - %Used 80% 超 → 容量対応検討
   - %Used 95% 超 → 緊急対応（cfg-fs-extend）

3. **syslog 出力確認**
   - `tail /var/log/messages`（直近のシステムログ）
   - 異常メッセージがあれば原因調査

4. **syslog 設定の一覧**
   - `cat /etc/syslog.conf`
   - 詳細設定: [cfg-syslog](08-config-procedures.md#cfg-syslog)

5. **プロセス確認**
   - `ps -ef | head -20`
   - `topas`（リアルタイム監視）

6. **errpt 古いログのクリア（月次）**
   - `errclear 30`（30 日より古いログを削除）


**検証**:

- errpt の新規ハードエラー件数を毎日記録
- df -g の使用率推移を週次レポート
- /var/log/messages サイズが想定範囲

**rollback**: 監視作業に rollback はない。誤って errclear した場合は restore 困難（バックアップから復元のみ）。

**関連**: [cfg-syslog](08-config-procedures.md#cfg-syslog), [inc-fs-full](09-incident-procedures.md#inc-fs-full), [inc-errpt-hardware-error](09-incident-procedures.md#inc-errpt-hardware-error)

---

## 入門 × バックアップ: mksysb で月次 rootvg バックアップ { #入門-バックアップ }

**目的**: DR 対策の最低限 — rootvg の bootable バックアップを定期取得。

**前提**:

- root 権限
- 保管先 FS（/backup 等）に rootvg 容量以上の空き

**手順**:

1. **保管先空き確認**
   - `df -g /backup`
   - rootvg 実使用量の 1.5 倍以上推奨

2. **mksysb 実行**
   - `mksysb -i -X -e /backup/$(hostname)_$(date +%Y%m%d).mksysb`
   - 数十分〜数時間（データ量による）

3. **完了確認**
   - 出力末尾: `0512-038 mksysb: Backup Completed Successfully.`
   - `ls -lh /backup/*.mksysb | tail`

4. **md5sum 取得**
   - `md5sum /backup/$(hostname)_$(date +%Y%m%d).mksysb > /backup/$(hostname)_$(date +%Y%m%d).md5`

5. **古いバックアップ削除（世代管理）**
   - 直近 3 世代保持、それ以前は削除:
   - `find /backup -name "*.mksysb" -mtime +90 -delete`

6. **詳細手順**: [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup)


**検証**:

- ファイルサイズが妥当（数 GB〜数十 GB）
- `restore -Tqf <mksysb>` で目次表示成功
- md5sum 値を別保管先と照合

**rollback**: 取得 mksysb の削除のみ（取得自体に rollback なし）。

**関連**: [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup)

---

## 入門 × 障害対応: boot 失敗・ログイン不可・FS full の三大障害 { #入門-障害対応 }

**目的**: AIX 管理者が最初に覚える 3 つの基本障害対応。

**前提**:

- root 権限（または別 root ユーザでアクセス可能）
- コンソール接続手段（HMC、シリアル等）

**手順**:

1. **boot 失敗（LED hang）**
   - HMC のオペレータパネルで LED コード記録
   - SMS メニュー進入 → boot device 確認
   - サービスモード boot → bosboot 再作成
   - 詳細: [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led)

2. **ログイン不可（user is locked）**
   - 別 root セッションから:
   - `lsuser -a unsuccessful_login_count account_locked alice`
   - `chsec -f /etc/security/lastlog -a unsuccessful_login_count=0 -s alice`
   - `chuser account_locked=false alice`
   - 詳細: [inc-login-locked](09-incident-procedures.md#inc-login-locked)

3. **FS 100%（disk full）**
   - `df -g | sort -k5 -r | head` で対象 FS 特定
   - 不要ファイル削除 or `chfs -a size=+1G /var` で拡張
   - 詳細: [inc-fs-full](09-incident-procedures.md#inc-fs-full)

4. **発生時の対応原則**
   - 慌てない（観察 → 仮説 → 対処）
   - 操作内容を全て記録（後の報告書用）
   - 不明な場合は IBM サポートに先に相談


**検証**:

- それぞれの個別手順の検証セクション参照

**rollback**: 個別手順の rollback セクション参照。

**関連**: [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led), [inc-login-locked](09-incident-procedures.md#inc-login-locked), [inc-fs-full](09-incident-procedures.md#inc-fs-full)

---

## 入門 × 性能: topas / vmstat / iostat の読み方 { #入門-性能 }

**目的**: 性能監視の基本コマンド 3 つを使えるようになる。

**前提**:

- root 権限（一般ユーザでも実行可能だが詳細情報には root 必要）

**手順**:

1. **topas でリアルタイム概観**
   - `topas`（5 秒間隔で更新）
   - 画面の見方:
     - 上部: CPU, Memory, Network, Disk のサマリ
     - 中部: Network/Disk 統計
     - 下部: プロセス一覧（CPU% 順）
   - q で終了

2. **vmstat で時系列観測**
   - `vmstat 5 12`（5 秒ごとに 12 回）
   - 重要列:
     - r = 実行待ちプロセス数（Runqueue）
     - b = ブロック中プロセス数
     - avm = active virtual memory
     - fre = free pages
     - pi/po = page in/out（paging 発生指標）
     - us/sy/id/wa = User/Kernel/Idle/Wait CPU%

3. **iostat でディスク I/O**
   - `iostat 5 6`（5 秒ごとに 6 回）
   - 重要列:
     - %tm_act = ディスクビジー率（80% 超で飽和）
     - tps = transactions per second
     - Kbps = throughput

4. **記録（後で参照する）**
   - `nmon -f -s 60 -c 30 -m /tmp` で 60 秒×30 = 30 分記録
   - .nmon ファイルを Excel で開ける

5. **詳細解析**: [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation)


**検証**:

- topas で平常時の値をメモ（ベースライン）
- vmstat の wa が常時 30%+ なら I/O ボトルネック疑い
- iostat の %tm_act が 80%+ 継続なら ディスク飽和

**rollback**: 監視作業に rollback なし。

**関連**: [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation)

---

## 入門 × セキュリティ: ユーザ追加とパスワードポリシー、SSH 鍵配置 { #入門-セキュリティ }

**目的**: セキュリティ運用の基本 — ユーザ管理と SSH 鍵認証。

**前提**:

- root 権限
- 新規ユーザ情報（名前、UID、グループ）

**手順**:

1. **新規ユーザ追加**
   - `mkuser id=2001 home=/home/alice shell=/usr/bin/ksh alice`
   - 詳細: [cfg-user-add](08-config-procedures.md#cfg-user-add)

2. **初期パスワード設定**
   - `passwd alice`
   - `pwdadm -f ADMCHG alice`（次回ログイン時に変更強制）

3. **パスワードポリシー設定**
   - `chuser maxage=12 minlen=12 minother=2 alice`
   - 全ユーザ default に: `chsec -f /etc/security/user -a minlen=12 -s default`

4. **SSH 鍵配置（鍵認証）**
   - alice の home に `.ssh/` 作成: `mkdir -p /home/alice/.ssh; chmod 700 /home/alice/.ssh`
   - 公開鍵を `/home/alice/.ssh/authorized_keys` に追加
   - 所有権・権限: `chown -R alice:staff /home/alice/.ssh; chmod 600 /home/alice/.ssh/authorized_keys`

5. **/etc/ssh/sshd_config 確認（パスワード認証無効化する場合）**
   - `PasswordAuthentication no`
   - `refresh -s sshd`

6. **ロック解除（試行回数超のとき）**
   - 詳細: [cfg-passwd-policy](08-config-procedures.md#cfg-passwd-policy)


**検証**:

- alice で ssh ログイン成功
- 鍵認証が効いている（パスワード入力なしで接続）
- `lsuser -a maxage minlen alice` でポリシー反映

**rollback**: `rmuser -p alice` でユーザ削除、`rm -rf /home/alice` で home 削除。

**関連**: [cfg-user-add](08-config-procedures.md#cfg-user-add), [cfg-passwd-policy](08-config-procedures.md#cfg-passwd-policy)

---

## 中級 × 構築: VG/LV 設計、JFS2 FS 配置、rootvg ミラー化 { #中級-構築 }

**目的**: 業務系 LPAR の本格構築 — ストレージ設計と冗長化。

**前提**:

- root 権限
- 新規 PV（または extendvg 用）
- 業務要件に基づく FS 設計（容量・配置）

**手順**:

1. **新規 VG 設計と作成**
   - 業務隔離するため datavg を新規作成
   - `mkvg -S -y datavg -s 64 hdisk1`（scalable VG、PP=64MB）
   - 詳細: [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv)

2. **業務 LV と FS の作成**
   - DB データ用: `mklv -y dblv -t jfs2 datavg 1000`（64GB）
   - DB ログ用: `mklv -y dbloglv -t jfs2 datavg 200`（12.8GB）
   - `crfs -v jfs2 -d dblv -m /db -A yes -p rw -a logname=INLINE`

3. **rootvg ミラー化**
   - 未使用 PV（hdisk1）を rootvg に追加
   - `extendvg rootvg hdisk1`
   - `mirrorvg -S rootvg hdisk1`（同期モード、数十分〜）
   - `bosboot -ad /dev/hdisk0; bosboot -ad /dev/hdisk1`
   - `bootlist -m normal hdisk0 hdisk1`
   - 詳細: [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror)

4. **MPIO 属性確認**
   - `lsattr -El hdiskN -a reserve_policy -a algorithm -a queue_depth`
   - HA/LPM 環境なら `reserve_policy=no_reserve` 必須
   - 詳細: [cfg-mpio-tuning](08-config-procedures.md#cfg-mpio-tuning)

5. **FS マウント自動化**
   - `chfs -A yes /db`（boot 時自動マウント）
   - `mount` で確認


**検証**:

- `lsvg datavg` で active、`lsvg -l rootvg` で全 LV が PPs=LPs*2
- `mount` で全 FS マウント済
- `bootlist -m normal -o` で hdisk0 hdisk1 両方表示

**rollback**: 個別手順の rollback セクション参照。VG 削除は `varyoffvg` → `exportvg`。

**関連**: [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv), [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror), [cfg-mpio-tuning](08-config-procedures.md#cfg-mpio-tuning)

---

## 中級 × 日常運用: errnotify でメール通知、cron 自動化、パッケージ更新管理 { #中級-日常運用 }

**目的**: 監視・通知の自動化と、パッケージ更新の管理ルーチン化。

**前提**:

- root 権限
- メールサーバ疎通可能
- cron デーモン稼働

**手順**:

1. **errnotify でメール通知設定**
   - ハードエラー（Class=H）発生時に admin@example.com へ通知
   - 詳細: [cfg-errnotify](08-config-procedures.md#cfg-errnotify)

2. **cron で定期ジョブ登録**
   - `crontab -e` で編集:
   ```
   # 朝 9 時に df 結果をメール
   0 9 * * * df -g | mailx -s "AIX df $(hostname)" admin@example.com
   # 月初に errclear
   0 0 1 * * /usr/bin/errclear 30
   # 週次 mksysb
   0 2 * * 0 /usr/bin/mksysb -i -X /backup/$(hostname)_$(date +%Y%m%d).mksysb
   ```

3. **パッケージ更新管理**
   - 月次で `oslevel -s` 確認、新 SP リリース確認
   - 適用前に必ず mksysb 取得
   - preview 実行: `installp -p -aXd <source> all`
   - 本適用: `installp -aXY -d <source> all`
   - 詳細: [cfg-package-install](08-config-procedures.md#cfg-package-install)

4. **トラブル時の対応**
   - メール送信失敗 → [inc-mail-fail](09-incident-procedures.md#inc-mail-fail)
   - cron ジョブ実行されず → [inc-cron-fail](09-incident-procedures.md#inc-cron-fail)


**検証**:

- メール通知のテスト（疑似 errlogger イベント）
- /var/adm/cron/log で cron 実行記録
- lslpp -L で適用済 fileset 確認

**rollback**: 個別手順の rollback セクション参照。

**関連**: [cfg-errnotify](08-config-procedures.md#cfg-errnotify), [cfg-package-install](08-config-procedures.md#cfg-package-install), [inc-cron-fail](09-incident-procedures.md#inc-cron-fail)

---

## 中級 × バックアップ: mksysb + savevg、NIM image 連携 { #中級-バックアップ }

**目的**: rootvg + 非 rootvg 両方のバックアップを取り、NIM 経由でリストア可能にする。

**前提**:

- root 権限
- NIM サーバ稼働
- 保管先 FS の十分な空き

**手順**:

1. **rootvg バックアップ**
   - `mksysb -i -X -e /backup/$(hostname)_rootvg_$(date +%Y%m%d).mksysb`
   - 詳細: [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup)

2. **datavg バックアップ**
   - `savevg -if /backup/$(hostname)_datavg_$(date +%Y%m%d).savevg datavg`
   - rootvg と違い bootable ではないが、データ復旧は可能

3. **NIM resource として登録**
   - NIM サーバ側で:
   ```
   nim -o define -t mksysb -a server=master \
       -a location=/backup/myhost_rootvg.mksysb \
       myhost_mksysb_$(date +%Y%m%d)
   ```
   - 確認: `lsnim -t mksysb`

4. **クライアント定義**
   - NIM サーバ側で対象 LPAR を NIM client として登録
   - `nim -o define -t standalone -a platform=chrp ...`

5. **bootable restore のテスト（DR 演習）**
   - HMC で別 LPAR を network boot
   - NIM 経由で `nim -o bos_inst -a source=mksysb ...`
   - restore 成功確認

6. **保管期間管理**
   - 直近 3 世代の rootvg/datavg バックアップを保持
   - `find /backup -name "*.mksysb" -mtime +90 -delete`


**検証**:

- ファイルサイズと md5sum 整合性
- DR 演習で別 LPAR への restore 成功
- NIM resource list に登録済

**rollback**: バックアップファイルの削除のみ。

**関連**: [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup)

---

## 中級 × 障害対応: 性能低下切り分け、NFS stale、core 解析 { #中級-障害対応 }

**目的**: 中級レベルの障害切り分け — 複数仮説を立てて検証する手法。

**前提**:

- 性能基準値（ベースライン）取得済み
- dbx / truss が使える

**手順**:

1. **性能低下の切り分け**
   - topas で CPU/Mem/Disk/Net の利用率を観察
   - vmstat / iostat / netstat で詳細統計
   - svmon -G でメモリ詳細
   - 詳細: [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation)
   - 特集: [feature-02-perf-investigation](11-special-features.md#feature-02-perf-investigation)

2. **NFS stale 解消**
   - `ls /mnt/nfsdata` で `Stale NFS file handle` エラー
   - `fuser -cuk /mnt/nfsdata` で使用プロセス確認
   - `umount -f /mnt/nfsdata` → `mount /mnt/nfsdata`
   - 詳細: [inc-nfs-stale](09-incident-procedures.md#inc-nfs-stale)

3. **core dump 解析**
   - `file <core>` で生成プロセス確認
   - `dbx <executable> <core>` で起動
   - `where` でスタックトレース表示
   - 詳細: [inc-core-dump](09-incident-procedures.md#inc-core-dump)

4. **記録と報告**
   - 切り分けの過程・仮説・検証結果を記録
   - 報告書作成（before/after 比較表）


**検証**:

- 性能ベースラインに復帰
- NFS マウントが通常動作
- core dump の真因特定（dbx の where 出力）

**rollback**: 個別手順の rollback セクション参照。

**関連**: [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation), [inc-nfs-stale](09-incident-procedures.md#inc-nfs-stale), [inc-core-dump](09-incident-procedures.md#inc-core-dump)

---

## 中級 × 性能: TCP バッファ・MPIO queue_depth・j2_inodeCacheSize 調整 { #中級-性能 }

**目的**: tunable 調整による性能改善。

**前提**:

- root 権限
- ベースライン値取得済み
- 業務影響を測定する手段（ツール）

**手順**:

1. **TCP 送受信バッファ拡大**
   - 高遅延 WAN や 10GbE 環境で効果
   - `no -p -o sb_max=4194304`
   - `no -p -o tcp_sendspace=1048576`
   - `no -p -o tcp_recvspace=1048576`
   - 詳細: [cfg-tcp-buffers](08-config-procedures.md#cfg-tcp-buffers)

2. **MPIO queue_depth 拡大**
   - DS8000 環境で `chdev -l hdiskN -a queue_depth=64 -U`
   - 詳細: [cfg-mpio-tuning](08-config-procedures.md#cfg-mpio-tuning)

3. **j2_inodeCacheSize 調整**
   - `ioo -p -o j2_inodeCacheSize=400 -o j2_metadataCacheSize=400`
   - 詳細: [cfg-ioo-tuning](08-config-procedures.md#cfg-ioo-tuning)

4. **効果測定**
   - ベースラインと比較（topas / vmstat / iostat / netperf）
   - 変更前後のスナップショット比較

5. **業務影響確認**
   - アプリのレスポンスタイム測定
   - スループット測定
   - エラー率確認


**検証**:

- tunable が CUR/BOOT に反映（ioo -L 等）
- 性能指標の改善（実測値）
- errpt にエラー新規発生なし

**rollback**: 各 tunable を `-d` オプションで既定値に戻す。

**関連**: [cfg-tcp-buffers](08-config-procedures.md#cfg-tcp-buffers), [cfg-mpio-tuning](08-config-procedures.md#cfg-mpio-tuning), [cfg-ioo-tuning](08-config-procedures.md#cfg-ioo-tuning)

---

## 中級 × マイグレ: AIX 7.x → 7.3.4 マイグレ（premigration script、廃止 fileset） { #中級-マイグレ }

**目的**: 旧 AIX バージョンから 7.3.4 への in-place マイグレーション。

**前提**:

- 現状 AIX バージョン確認（7.1 / 7.2 / 7.3.x）
- マイグレ前 mksysb 取得済
- 業務停止時間の調整済

**手順**:

1. **premigration script 実行**
   - 旧版上で `/usr/lpp/bos/premig_chk` 実行
   - チェック結果に従い廃止 fileset 削除等の準備

2. **廃止 fileset の事前削除**
   - `installp -u rsct.vsd` （VSD は AIX 7.3 で廃止）
   - `installp -u rsct.lapi.rte` （LAPI は AIX 7.3 で廃止）
   - `installp -u powersc.ts` （PowerSC Trusted Surveyor、WPAR 含めて）

3. **hd5 容量確保**
   - hd5 ≥ 40MB、ディスク先頭 4GB 内の連続 PP
   - 不足なら LV 移動で連続領域確保

4. **base media または NIM でマイグレーション開始**
   - SMS で boot device 選択
   - インストーラで `Migration Install` を選択
   - bos.dsc fileset を最初に installp（base media 利用時）

5. **個別問題への対処**
   - Java 8 32bit SR6FP35 ロード不能 → SR6FP30 強制降格
   - bos.net.tcp.sendmail libcrypto エラー → update_all で 7.3.3+ へ進める

6. **post-migration 確認**
   - `oslevel -s`
   - `lppchk -v`
   - 業務動作確認


**検証**:

- `oslevel -s` で 7300-04-XX-XXXX
- `lppchk -v` で整合エラーなし
- 業務アプリ動作確認

**rollback**: premigration 段階なら旧設定で続行。マイグレ実行後は mksysb から restore のみ。

**関連**: [cfg-package-install](08-config-procedures.md#cfg-package-install), [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup), [feature-03-patch-apply](11-special-features.md#feature-03-patch-apply)

---

## 中級 × セキュリティ: errnotify 監査連動、syslog 集中転送、LDAP クライアント { #中級-セキュリティ }

**目的**: セキュリティ監視の集約化と、認証基盤統合。

**前提**:

- root 権限
- 集中ログサーバ稼働
- LDAP サーバ（AD or ISVD 等）

**手順**:

1. **errnotify を監査ログに連動**
   - errnotify で USER_LOCKED 等のセキュリティイベントを集中ログサーバへ転送
   - 詳細: [cfg-errnotify](08-config-procedures.md#cfg-errnotify)

2. **syslog 集中転送**
   - `/etc/syslog.conf` に `*.info @logserver.example.com`
   - `refresh -s syslogd`
   - 詳細: [cfg-syslog](08-config-procedures.md#cfg-syslog)

3. **LDAP クライアント設定**
   - bos.net.tcp.client を含む base fileset インストール済確認
   - `/etc/security/ldap/ldap.cfg` 編集（LDAP サーバ IP、bind DN 等）
   - `mksecldap -c -h ldap-srv.example.com -a cn=admin,dc=example,dc=com -p adminpass`
   - `start-secldapclntd`
   - `lsuser -R LDAP <ldap-user>` で確認

4. **AD/LDAP 連携時の追加設定**
   - TL3 SP1 で defaulthomedirectory / pwdalgorithm / defaultloginshell 拡張あり
   - これらフィールドを ldap.cfg に追加


**検証**:

- errpt 重要イベントが集中ログサーバで受信
- /var/log/messages 相当のログがサーバ側で受信
- LDAP ユーザでログイン成功

**rollback**: 個別手順の rollback セクション参照。LDAP 連携は stop-secldapclntd で停止可。

**関連**: [cfg-errnotify](08-config-procedures.md#cfg-errnotify), [cfg-syslog](08-config-procedures.md#cfg-syslog)

---

## 中級 × スケーリング: FS 拡張、PV 追加、新規 VG 作成 { #中級-スケーリング }

**目的**: 業務拡大に伴うストレージ追加と容量拡張。

**前提**:

- ストレージ管理者から新 LUN 払い出し済
- 業務影響が許容される時間帯

**手順**:

1. **新規 PV の認識**
   - `cfgmgr -v` で新 hdisk 認識
   - `lspv` で hdisk2 等が現れる
   - PVID 付与: `chdev -l hdisk2 -a pv=yes`
   - 詳細: [cfg-disk-add](08-config-procedures.md#cfg-disk-add)

2. **既存 VG への追加**
   - `extendvg datavg hdisk2`
   - `lsvg datavg` で TOTAL PVs 増加確認

3. **新規 VG の作成**
   - 業務隔離する場合は別 VG:
   - `mkvg -S -y newvg -s 64 hdisk3`
   - 詳細: [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv)

4. **FS 拡張**
   - `chfs -a size=+5G /var`
   - 詳細: [cfg-fs-extend](08-config-procedures.md#cfg-fs-extend)

5. **特集記事**: [feature-01-disk-to-fs](11-special-features.md#feature-01-disk-to-fs)


**検証**:

- `lspv` に新 PV、active
- `lsvg <vg>` で TOTAL PPs 増加
- `df -g <fs>` で容量増加

**rollback**: 個別手順の rollback セクション参照。

**関連**: [cfg-disk-add](08-config-procedures.md#cfg-disk-add), [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv), [cfg-fs-extend](08-config-procedures.md#cfg-fs-extend)

---

## 上級 × 構築: NIM サーバ、CAA リポジトリ、PowerHA 連携、暗号化 rootvg { #上級-構築 }

**目的**: 高可用・大規模環境の基盤構築 — 上級者向けの専門手順群。

**前提**:

- root 権限
- PowerVM 仮想化環境
- ストレージ・ネットワーク・HA に関する設計知識

**手順**:

1. **NIM サーバ構築**
   - bos.sysmgt.nim.master fileset 導入
   - LPP_SOURCE 作成（base media + 必要 update を統合）
   - SPOT 作成（ramdisk/カーネルイメージ）
   - クライアント定義
   - `nim -o define -t standalone -a platform=chrp ...`

2. **CAA リポジトリ構築**
   - 共有ディスクを確保（NVMe ディスクは TL3 から対応）
   - `mkcluster -n mycluster -m node1,node2 -r hdisk_repos`
   - RSCT 3.3.0.0 稼働確認

3. **PowerHA 連携**
   - PowerHA SystemMirror インストール
   - service IP / boot IP / persistent IP 設計
   - リソースグループ定義

4. **PKS による rootvg 暗号化**
   - 新規/上書き install 時 BOS install メニューで暗号化対象 LV 選択
   - `pksctl` で初期化
   - `hdcryptmgr` で運用管理

5. **詳細手順**
   - 本サイトの 08-config-procedures では概要のみ。詳細は IBM Redbooks / 公式マニュアル参照。


**検証**:

- NIM 経由で別 LPAR に AIX install 成功
- CAA cluster: `lscluster -m` で全ノード active
- PowerHA: `clRGinfo` でリソースグループ稼働

**rollback**: 個別手順は環境依存。原則として事前バックアップから restore。

**関連**: [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup), [feature-03-patch-apply](11-special-features.md#feature-03-patch-apply)

---

## 上級 × 日常運用: snap でサポート用情報定期取得、性能ベースライン取得（nmon） { #上級-日常運用 }

**目的**: 上級運用の日課 — IBM サポート対応とトレンド分析の準備。

**前提**:

- /tmp /var/adm/ras に十分な空き
- 性能ツール（nmon analyser 等）使用可能

**手順**:

1. **月次 snap 取得**
   - `snap -r` で旧データクリア
   - `snap -ac` で全情報取得
   - `/tmp/ibmsupt/snap.pax.gz` を IBM ECurep アップロード（PMR がある場合）
   - 詳細: [inc-snap-collect](09-incident-procedures.md#inc-snap-collect)

2. **性能ベースライン取得**
   - 平日代表時間帯（朝 9:00-11:00、午後 14:00-16:00 等）に nmon 記録
   - `nmon -f -s 60 -c 60 -m /var/adm/perf -F baseline_$(hostname)_$(date +%Y%m%d).nmon`
   - .nmon ファイルを Excel + nmon analyser で可視化

3. **ベースライン値の記録**
   - CPU%, Memory%, Disk Busy%, Network throughput を月次記録
   - 増加トレンドがあれば容量計画に反映

4. **トラブル時の比較材料**
   - 性能劣化発生時にベースラインと比較
   - 詳細: [feature-02-perf-investigation](11-special-features.md#feature-02-perf-investigation)


**検証**:

- snap.pax.gz が定期生成（ファイルサイズ妥当）
- nmon ベースラインファイルが月次蓄積
- ベースライン値の月次変動を把握

**rollback**: snap データ削除のみ。

**関連**: [inc-snap-collect](09-incident-procedures.md#inc-snap-collect), [feature-02-perf-investigation](11-special-features.md#feature-02-perf-investigation)

---

## 上級 × バックアップ: NIM 連携の bootable mksysb、別 LPAR への restore リハーサル { #上級-バックアップ }

**目的**: DR 演習による実証 — mksysb から bootable restore できることを毎月確認。

**前提**:

- NIM サーバ稼働
- DR 用予備 LPAR 確保
- 業務影響最小限の時間帯

**手順**:

1. **mksysb 取得（本番）**
   - 詳細: [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup)

2. **NIM resource として登録**
   - NIM サーバ側で:
   - `nim -o define -t mksysb -a server=master -a location=... mksysb_resource_$(date +%Y%m%d)`

3. **DR LPAR を NIM 経由 bos_inst**
   - HMC で予備 LPAR を network boot
   - NIM サーバから `nim -o bos_inst -a source=mksysb ...` 実行
   - restore 完了まで数十分

4. **restore 後の動作確認**
   - OS 起動成功
   - hostname、IP が mksysb 取得時のものに復元
   - アプリ起動確認

5. **DR 演習レポート**
   - 取得→復元→起動までの所要時間記録
   - 失敗時の対処手順を更新


**検証**:

- 予備 LPAR で OS 起動成功
- 業務アプリ起動・動作確認
- RTO（復旧目標時間）達成確認

**rollback**: 予備 LPAR を削除（HMC で）。

**関連**: [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup), [feature-03-patch-apply](11-special-features.md#feature-03-patch-apply)

---

## 上級 × 障害対応: kdb / dbx でカーネル / プロセスダンプ解析、HMC SRC コード解析 { #上級-障害対応 }

**目的**: 上級レベルの障害解析 — カーネルダンプとハードウェア診断。

**前提**:

- root 権限
- kdb / dbx の使用経験
- HMC アクセス権

**手順**:

1. **カーネルダンプ取得確認**
   - `sysdumpdev -l` で primary が /dev/dumplv であること
   - 詳細: [cfg-dump-device](08-config-procedures.md#cfg-dump-device)

2. **kdb でカーネルダンプ解析**
   - `kdb /var/adm/ras/vmcore.0`
   - `(kdb) status`、`(kdb) stat`、`(kdb) th` 等で状態確認
   - スタックトレース、レジスタ、ロック状態確認

3. **dbx でプロセスダンプ解析**
   - `dbx <executable> <core>`
   - 詳細: [inc-core-dump](09-incident-procedures.md#inc-core-dump)

4. **HMC SRC コード解析**
   - HMC オペレータパネルで Service Reference Code (SRC) 確認
   - 例: `BA210000` = メモリ ECC エラー
   - SRC コード一覧から原因部位特定（IBM Power Systems Service Information）
   - IBM サポート連絡時に SRC を提示

5. **snap 取得 + IBM サポート提供**
   - `snap -ac`
   - 詳細: [inc-snap-collect](09-incident-procedures.md#inc-snap-collect)


**検証**:

- ダンプから真因特定（スタックトレース等）
- ハードウェア交換 → errpt に新規エラーなし
- 業務復旧

**rollback**: ハードウェア交換は IBM CE 対応。OS 側 rollback はない。

**関連**: [cfg-dump-device](08-config-procedures.md#cfg-dump-device), [inc-core-dump](09-incident-procedures.md#inc-core-dump), [inc-errpt-hardware-error](09-incident-procedures.md#inc-errpt-hardware-error), [inc-snap-collect](09-incident-procedures.md#inc-snap-collect)

---

## 上級 × 性能: ASO/DSO 利用、large page 適用、AIO チューニング、NUMA awareness { #上級-性能 }

**目的**: 上級性能チューニング — ハードウェア特性を活かした最適化。

**前提**:

- 性能ベースライン取得済み
- ASO/DSO・large page・AIO の概念理解

**手順**:

1. **ASO/DSO 有効化**
   - Active System Optimizer / Dynamic System Optimizer
   - `lssrc -s aso` で状態確認
   - 起動: `startsrc -s aso`
   - 自動最適化（large page、prefetch）

2. **large page（16MB pages）適用**
   - `vmo -L lgpg_size -L lgpg_regions`
   - DB 等の大量メモリプロセス向けに事前確保
   - `vmo -p -o lgpg_size=16777216 -o lgpg_regions=N`
   - アプリ起動時に LDR_CNTRL=LARGE_PAGE_DATA=Y で利用

3. **AIO チューニング**
   - `aioo -L`
   - DB（Oracle/Db2）等で AIO サーバ数調整
   - kernel I/O queue 最適化

4. **NUMA awareness**
   - Power10 で NUMA topology が重要
   - `lssrad -av` で NUMA 構成確認
   - WLM や プロセスの NUMA 配置最適化

5. **計測と効果確認**
   - ベースラインと比較
   - 詳細: [feature-02-perf-investigation](11-special-features.md#feature-02-perf-investigation)


**検証**:

- tunable が反映
- 性能指標の改善
- errpt にエラー新規発生なし

**rollback**: 各 tunable を `-d` で既定値に戻す。large page は再起動必要な場合あり。

**関連**: `cfg-vmo-tuning`, [feature-02-perf-investigation](11-special-features.md#feature-02-perf-investigation)

---

## 上級 × マイグレ: Live Kernel Update、Live Library Update、別 LPAR への nimadm migration { #上級-マイグレ }

**目的**: 業務無停止でのカーネル/ライブラリ更新と、別 LPAR への migration。

**前提**:

- AIX 7.2 / 7.3 で LKU 対応
- TL3 で LLU 新規導入
- NIM サーバ稼働（nimadm 用）

**手順**:

1. **Live Kernel Update (LKU)**
   - 業務無停止でカーネル更新
   - 互換性確認（TL/SP）
   - `vi /etc/lvupdate.data`（ipsec_auto_migrate=yes 等）
   - `geninstall` (LKU mode) または HMC ベース LKU
   - blackout 時間中、アプリは一時停止
   - TL3 で性能改善・blackout 短縮

2. **Live Library Update (LLU)**
   - TL3 新規導入
   - libc 等のライブラリを業務無停止で更新

3. **別 LPAR への nimadm migration**
   - 並列マイグレ（複数 LPAR を同時に）
   - PowerVC 連携で nimadm 自動化
   - TL3 で複数 LPAR 並列マイグレーション対応

4. **完了確認**
   - `oslevel -s` で新レベル
   - `lppchk -v` で整合性

5. **特集**: [feature-03-patch-apply](11-special-features.md#feature-03-patch-apply)


**検証**:

- 業務継続中に oslevel -s が新値
- lppchk -v で整合性 OK
- アプリ動作継続確認

**rollback**: LKU は事前 snapshot から戻し可能。nimadm はソース LPAR を使い続ける選択。

**関連**: [cfg-package-install](08-config-procedures.md#cfg-package-install), [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup)

---

## 上級 × セキュリティ: RBAC 設計、Trusted Execution + CHKSHOBJS、AIX Key Manager (PKS)、IPsec { #上級-セキュリティ }

**目的**: 上級セキュリティ — fine-grained 権限制御と暗号化機能。

**前提**:

- root 権限
- RBAC 設計経験
- PKS 鍵管理ポリシー策定済

**手順**:

1. **RBAC 設計**
   - 業務別 role 定義: `mkrole authorizations=aix.network.config.* netadmin`
   - ユーザに role 割当: `chuser roles=netadmin alice`
   - swrole で role 切替: `swrole netadmin`

2. **Domain RBAC（追加機能）**
   - リソースをドメイン別にグループ化
   - 詳細: AIX 7.3 Security ガイド

3. **Trusted Execution + CHKSHOBJS**
   - Trusted Signature Database（TSD）に実行ファイルハッシュ登録
   - `trustchk -s ON` で起動時検証有効化
   - TL3 SP1 で CHKSHOBJS（共有 .o 検証）追加

4. **AIX Key Manager (PKS)**
   - PKS 初期化: `pksctl init`
   - 暗号化 LV 用鍵管理
   - PowerVM Platform Keystore と連携

5. **IPsec 設定**
   - DH groups 14/19/20/21/24（TL3 で 20/21 追加）
   - SHA2_512 hash
   - `mkfilt` で IPsec フィルタ作成
   - LKU 時の IPsec 維持: `lvupdate.data` に `ipsec_auto_migrate=yes`


**検証**:

- role 切替後の権限確認
- trustchk で実行ファイル検証成功
- PKS 鍵が PowerVM platform keystore に保存

**rollback**: 個別機能ごとに rollback 手順あり。RBAC は role 削除、TE は trustchk -s OFF。

**関連**: [cfg-user-add](08-config-procedures.md#cfg-user-add), [cfg-passwd-policy](08-config-procedures.md#cfg-passwd-policy)

---

## 上級 × スケーリング: DLPAR でリソース動的増減、LPM で別物理機へ移動、scalable VG（1024 PV） { #上級-スケーリング }

**目的**: PowerVM 基盤を活かした動的スケーリング。

**前提**:

- PowerVM HMC アクセス
- scalable VG 設計
- LPM 用 VIOS 構成

**手順**:

1. **DLPAR でメモリ追加**
   - HMC でメモリ +XGB を実行
   - AIX 側で `prtconf -m` で認識確認
   - vmo tunable 見直し（minperm/maxperm 等）

2. **DLPAR で CPU 追加**
   - HMC で entitled processor units 増加
   - AIX 側で `lparstat` で確認

3. **LPM で別物理機へ移動**
   - 事前条件: reserve_policy=no_reserve（[cfg-mpio-tuning](08-config-procedures.md#cfg-mpio-tuning)）
   - HMC で migration 実行
   - 数分〜数十分で移動完了
   - cthags critical resource monitoring に注意

4. **scalable VG で大量 PV**
   - scalable VG（既定 1024 PV / 256 LV / 32768 PP）
   - 既存の original VG（32 PV 制限）からの拡張は不可、新規 VG として作成

5. **特集**: [feature-01-disk-to-fs](11-special-features.md#feature-01-disk-to-fs)


**検証**:

- DLPAR 後 prtconf -m / lparstat で増加確認
- LPM 後 hostname/IP 維持
- scalable VG: lsvg で MAX PVs=1024 表示

**rollback**: DLPAR は逆操作で減少。LPM は元物理機へ再 LPM。

**関連**: [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv), [cfg-disk-add](08-config-procedures.md#cfg-disk-add), [cfg-fs-extend](08-config-procedures.md#cfg-fs-extend), [cfg-mpio-tuning](08-config-procedures.md#cfg-mpio-tuning)

---

