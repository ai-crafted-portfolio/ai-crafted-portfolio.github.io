# トラブルシュート早見表

> 掲載：**20 件**（定番のみ）。除外項目は [10. 対象外項目](10-out-of-scope.md) を参照。

AIX 管理者が日々遭遇する staple な症状を症状/原因/対処/errpt label の 4 列で整理。詳細手順は各行の「関連手順」リンク先（[09. 障害対応手順](09-incident-procedures.md)）。

| ID | 症状 | 原因 | 対処（要約） | errpt label / コード | 関連手順 |
|---|---|---|---|---|---|
| ts-01 | システムが起動しない（HMC で LED コード残る） | BLV 破損、ブートディスク認識不可、ハードウェア障害 | サービスモード boot → bosboot -ad → bootlist 再設定。詳細手順: inc-boot-fail-led | `—（HMC SRC: BA*、E1*）` | [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led) |
| ts-02 | ログインができない（user is locked） | loginretries 超で account_locked=true、または unsuccessful_login_count 超 | chsec -f /etc/security/lastlog -a unsuccessful_login_count=0 -s <user> | `3004-303` | [inc-login-locked](09-incident-procedures.md#inc-login-locked) |
| ts-03 | ファイルシステム 100%（no space left on device） | 古いログ、core dump、テンポラリファイル蓄積、または容量不足 | df -g で特定 → 削除 or chfs -a size=+1G で拡張 | `JFS2_FS_FULL` | [inc-fs-full](09-incident-procedures.md#inc-fs-full) |
| ts-04 | プロセス hung（無応答） | ループ、I/O 待ち、デッドロック、NFS stale | topas で CPU/IO 確認 → procstack → kill（先に SIGTERM、効かなければ -9） | `—` | [inc-process-hung](09-incident-procedures.md#inc-process-hung) |
| ts-05 | 性能低下（応答時間悪化） | CPU/メモリ/ディスク/ネットワークいずれかのボトルネック | topas → vmstat → iostat → netstat の順で切り分け | `—` | [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation) |
| ts-06 | 外部に通信できない | リンクダウン、IP 設定不正、ルーティング不正、DNS 解決失敗 | entstat -d en0 → ifconfig → netstat -rn → nslookup の順で確認 | `—` | [inc-network-down](09-incident-procedures.md#inc-network-down) |
| ts-07 | Stale NFS file handle | NFS サーバ側の export 変更、ネットワーク断後の長時間放置 | fuser -cuk /mnt → umount -f → mount で再接続 | `—` | [inc-nfs-stale](09-incident-procedures.md#inc-nfs-stale) |
| ts-08 | FS マウント失敗（fsck required） | 強制電源断、I/O エラー後のメタデータ不整合 | fsck -y /dev/<lv> → mount | `—` | [inc-fsck-required](09-incident-procedures.md#inc-fsck-required) |
| ts-09 | メールが届かない（errnotify 等から） | sendmail 停止、relay host 未設定、DNS MX 解決失敗 | lssrc -s sendmail → mailq → MX 確認 | `—` | [inc-mail-fail](09-incident-procedures.md#inc-mail-fail) |
| ts-10 | cron ジョブが実行されない | cron デーモン停止、構文エラー、cron.deny で除外 | lssrc -s cron → /var/adm/cron/log → crontab -l | `—` | [inc-cron-fail](09-incident-procedures.md#inc-cron-fail) |
| ts-11 | installp が失敗する | 依存 fileset 不足、/usr 空き不足、libcrypto 等の互換問題 | installp -p でプレビュー → 不足を補充 → df -g /usr | `0503-005, 0504-201` | [inc-package-install-fail](09-incident-procedures.md#inc-package-install-fail) |
| ts-12 | core ファイル多発 | アプリのバグ、ライブラリ ABI 不整合（OpenSSL 3.0 への移行等） | dbx <executable> core で where → 開発ベンダ提供パッチ | `—` | [inc-core-dump](09-incident-procedures.md#inc-core-dump) |
| ts-13 | errpt にハードウェアエラー多発 | ディスク・FC・メモリ等のハードウェア不良 | errpt -aj <ID> で詳細、HMC SRC 確認、IBM サポート連絡 | `DISK_ERR1, FCS_ERR1, EPOW_*` | [inc-errpt-hardware-error](09-incident-procedures.md#inc-errpt-hardware-error) |
| ts-14 | VG/LV を認識しない | LPAR 移動・ディスク交換後 importvg 未実施 | lspv で hdisk 確認 → importvg -y <vg> hdisk → varyonvg | `—` | [inc-lv-not-recognized](09-incident-procedures.md#inc-lv-not-recognized) |
| ts-15 | Paging space 枯渇（malloc 失敗） | メモリリーク、過大ワークロード、minfree 過小 | lsps -a → svmon -G → chps で hd6 拡張 | `—` | [inc-paging-full](09-incident-procedures.md#inc-paging-full) |
| ts-16 | snap データを IBM に提出する必要がある | サポートケースで指示 | snap -r → snap -ac → /tmp/ibmsupt/snap.pax.gz | `—` | [inc-snap-collect](09-incident-procedures.md#inc-snap-collect) |
| ts-17 | パッチ適用後にアプリ動作不良 | 新パッチによる回帰、または互換性問題 | lslpp -L で State=A 確認 → installp -r で reject | `—` | [inc-package-uninstall-stuck](09-incident-procedures.md#inc-package-uninstall-stuck) |
| ts-18 | rootvg ミラー片方故障 | ハードウェア劣化、ケーブル断 | lspv -p で missing PV 確認 → unmirrorvg → reducevg → rmdev → 物理交換 → cfgmgr → extendvg → mirrorvg → bosboot → bootlist | `DISK_ERR1` | [inc-disk-replace](09-incident-procedures.md#inc-disk-replace) |
| ts-19 | OS 時刻が大きくずれている（NTP 同期失敗） | NTPv4 デーモン停止、上位 NTP サーバ疎通不能、firewall ブロック | lssrc -s xntpd → ntpq -p → ping NTP server → /etc/ntp.conf 確認 | `—` | [cfg-ntp](08-config-procedures.md#cfg-ntp) |
| ts-20 | errpt が空（記録されない） | errdemon が停止している、または errlog 自体が破損 | ps -ef \| grep errdemon → 停止していれば /usr/lib/errdemon -l で状態確認、起動 | `—` | [inc-errpt-hardware-error](09-incident-procedures.md#inc-errpt-hardware-error) |
