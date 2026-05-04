# トラブルシュート早見表

> 掲載：**20 件**（定番のみ）。除外項目は [10. 対象外項目](10-out-of-scope.md) を参照。

| ID | 症状 | 原因 | 対処 | errpt label | 関連手順 |
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


---

## v10 補足: errpt label 早見表

v9 までは表の `ラベル` 列に label 名だけ載せていましたが、label の意味と初動アクションを v10 で別表として整理します。全 30 種、PERM = 永続障害 / TEMP = 一時 / INFO = 情報、重大度 H = ハードウェア / S = ソフト / U = ユーザ / I = 情報。

| Label | Type | Sev | 意味 | 初動 |
|---|---|---|---|---|
| `DISK_ERR1` | PERM | H | ディスク永続障害（媒体エラー） | errpt -aj <ID> で詳細 → ハードウェア交換検討 |
| `DISK_ERR2` | TEMP | H | ディスク一時エラー | 監視継続。頻発する場合は交換検討 |
| `DISK_ERR3` | PERM | H | ディスク I/O タイムアウト | MPIO パス確認 (lspath, lsmpio) |
| `DISK_ERR4` | PERM | H | SCSI コマンド失敗 | ファイバ/SAS ケーブル確認、HMC SRC 確認 |
| `FCS_ERR1` | PERM | H | FC アダプタリンクダウン | lsattr -El fcs0 / SAN スイッチ確認 |
| `FCS_ERR2` | TEMP | H | FC link bouncing | SFP / ケーブル / SAN switch ポート確認 |
| `FCS_ERR4` | PERM | H | FC RSCN 多発 | SAN ファブリック構成変更未完了の可能性 |
| `EPOW_RES_CHRP` | PERM | H | 電源復旧 (Reservation Lost) | HMC で電源履歴確認 |
| `EPOW_SUS_CHRP` | PERM | H | 電源喪失警告 | UPS / PSU 確認、HMC SRC 確認 |
| `MEMORY_DEALLOC` | INFO | I | 予防的メモリ無効化（Persistent Memory Deallocation） | DIMM 交換タイミング検討 |
| `CHECKSTOP` | PERM | H | ハードウェア重大障害 | 即 IBM ハードウェアサポート連絡、HMC SRC 必須 |
| `CORE_DUMP` | PERM | S | プロセスコアダンプ生成 | /var/adm/ras/core 等を dbx で解析 |
| `REBOOT_ID` | INFO | I | システム再起動記録 | shutdown -Fr / 異常リセットの区別を別 ID で確認 |
| `ERRLOG_ON` | INFO | I | errdemon 起動 | 起動シーケンスの基準点 |
| `MOUNTED` | INFO | I | ファイルシステムマウント記録 | df -k と整合確認 |
| `SRC` | INFO | I | SRC（System Resource Controller）動作 | lssrc -a / startsrc / stopsrc 履歴 |
| `LVM_SA_WRTERR` | PERM | H | VGSA 書き込み失敗 | varyoffvg → varyonvg で復旧、PV 障害確認 |
| `LVM_BBDIRBAD` | TEMP | H | Bad Block Directory 損傷 | PV 交換 / ALTERNATE_PHYSICAL_VOLUME |
| `LVM_HWREL` | INFO | I | ハードウェア リロケート | PV 上の bad block 自動回避済 |
| `ENT_ERR1` | PERM | H | Ethernet アダプタ障害 | entstat -d ent0 / SEA 確認 |
| `GOENT_ERR_RCV` | TEMP | U | Ethernet 受信エラー | ケーブル / VIOS SEA 確認 |
| `TCPIP_ERR` | PERM | S | TCP/IP スタック異常 | no -L で TCP パラメータ確認 |
| `SRC_RESTART` | INFO | I | サブシステム自動再起動 | lssrc -a で当該サブシステム確認 |
| `SYSPROC` | PERM | S | プロセス異常終了 | ps コマンド残骸確認、syslog と突合 |
| `DUMP_STATS` | INFO | I | ダンプ統計 | sysdumpdev -L で前回ダンプ情報確認 |
| `AUDIT_RESET` | INFO | I | 監査サブシステムリセット | audit start / shutdown の影響 |
| `FAIL_LOGIN` | INFO | I | ログイン失敗 | /etc/security/failedlogin 参照 |
| `J2_LOGREDO_ERR` | PERM | H | JFS2 ログ再実行失敗 | fsck -y で復旧、損傷軽微なら mount 可能 |
| `FS_FULL` | INFO | I | ファイルシステム満杯通知 | df -g / inc-fs-full 参照 |
| `DUMPCHK` | INFO | I | システムダンプデバイス確認 | sysdumpdev -e で容量足りるか確認 |

出典: AIX 7.3 Operating system management — Error logging


## v10 補足: HMC SRC コード初動表

Power Systems の HMC コンソールに表示される **SRC（System Reference Code）** の代表パターンと初動アクション。CEC（Central Electronics Complex）電源投入から AIX 起動までの典型的 SRC を記載。

| SRC パターン | 意味 | 初動 | 重大度 |
|---|---|---|---|
| `BA*` | Boot 進行中（Firmware 段階） | 正常な起動進捗。3 分以上同じ SRC が続く場合のみ HMC で確認 | INFO |
| `CA*` | AIX kernel 起動 | 正常な OS 起動。10 分以上停止する場合 HMC で boot list 確認 | INFO |
| `E1*` | Firmware 初期化（Power-on） | 正常。長時間止まる場合は CEC/PSU 確認 | INFO |
| `E2*` | OS Loader（Open Firmware） | 正常。AIX boot 直前。残る場合 boot disk / NIM 確認 | INFO |
| `8*` | AIX 起動完了状態 | 正常稼働中。LED 残留時は ras_state 等確認 | INFO |
| `LED 200` | LED ロックされている（IPL 失敗） | HMC で SRC 履歴確認 → 該当 FRU 交換 | ERROR |
| `LED 281` | Boot disk 見つからず | bootlist -m normal -o で boot list 確認、ハード接続確認 | ERROR |
| `LED 552` | LVM rootvg corrupt | Maintenance mode で起動、fsck → savevg restore | ERROR |
| `LED 553` | rootvg / 不整合 | Maintenance mode 起動、bosboot -ad /dev/hdiskN で再構築 | ERROR |
| `LED 888` | AIX kernel panic | HMC で system dump 取得、IBM サポート連絡 | FATAL |
| `B181 *` | FW configuration 問題 | HMC SRC 詳細確認、System Plan 再適用 | ERROR |
| `B153 *` | Service Processor 問題 | HMC で Service Processor 再起動 (Reset SP) 試行 | ERROR |
| `BA170010` | Boot disk on multipath で active path なし | lspath で全 path 確認、SAN/Fabric 異常確認 | ERROR |

出典: IBM Power Systems Hardware Management Console Operations Guide
<https://www.ibm.com/docs/en/power10/9080-HEX?topic=hmc-operations>
