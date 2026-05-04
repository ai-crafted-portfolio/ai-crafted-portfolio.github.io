# コマンド一覧

> 掲載：**45 件**（定番のみ）。除外項目は [10. 対象外項目](10-out-of-scope.md) を参照。

AIX 管理者が現場で月1回以上触る定番コマンドのみ。C 言語サブルーチン、廃止コマンド、ニッチ上級コマンドは [10. 対象外項目](10-out-of-scope.md) 参照。

## ログ・診断（5 件）

| コマンド | 用途 | 構文 | 典型例 | 注意点 | 関連手順 |
|---|---|---|---|---|---|
| `errpt` | Error Logging サブシステムに記録されたエラーログを表示する。AIX 管理者が日々最初に確認するコマンド。 | `errpt [-a] [-d <Class>] [-s <mmddhhmmyy>] [-N <Resource>]` | <pre>errpt -a \| more  # 全エラー詳細表示<br>errpt -d H -s 0501000026  # 5/1 以降のハード障害だけ</pre> | HW=90日、SW=30日で自動削除。errdemon が停止していると新規ログが取れない。 | [inc-errpt-hardware-error](09-incident-procedures.md#inc-errpt-hardware-error), [cfg-errnotify](08-config-procedures.md#cfg-errnotify) |
| `errdemon` | Error Logging サブシステムのデーモン。/dev/error を監視してエラーログファイル（既定 /var/adm/ras/errlog）に書き込む。 | `errdemon [-l <ログ>] [-s <サイズ>] [-i <error_template_repository>]` | <pre>/usr/lib/errdemon -l  # 状態確認<br>errdemon  # 開始（通常 inittab で自動起動）</pre> | errpt が空を返すときはまずこのデーモンが動いているか確認。 | [inc-errpt-hardware-error](09-incident-procedures.md#inc-errpt-hardware-error) |
| `errclear` | errpt が読むエラーログから古いエントリを削除する。FS full の応急処置や定期メンテで使用。 | `errclear [-d <Class>] [-J <Label>] <Days>` | <pre>errclear 30  # 30 日より古いログを全削除<br>errclear -d S 7  # 7 日より古い SW エラーだけ削除</pre> | 0 を指定すると全削除。実運用では cron で定期削除。 | [inc-fs-full](09-incident-procedures.md#inc-fs-full) |
| `snap` | IBM サポート提供用にシステム情報・ログを一括収集する。pax.gz 形式で /tmp/ibmsupt 配下に出力。 | `snap [-a] [-c] [-o <output device>] [-r] <component>` | <pre>snap -ac  # 全情報収集して pax.gz に圧縮<br>snap -r  # 古い snap をクリア</pre> | 実行に時間がかかる（数分〜数十分）。/tmp に十分な空き必要。 | [inc-package-install-fail](09-incident-procedures.md#inc-package-install-fail), [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation) |
| `alog` | ブートログ（boot log）等の循環ログを表示・操作する。boot 失敗の調査で使う。 | `alog -t <type> -o   # 表示<br>alog -t boot -o     # ブートログ表示` | <pre>alog -t boot -o \| tail -200  # 最新 200 行<br>alog -L  # 定義済 alog タイプ一覧</pre> | boot ログは bos.rte.misc_cmds 同梱、cfgmgr の標準出力相当。 | [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led) |

## デバイス・LVM（9 件）

| コマンド | 用途 | 構文 | 典型例 | 注意点 | 関連手順 |
|---|---|---|---|---|---|
| `lsdev` | ODM に登録されたデバイス（ディスク、アダプタ等）の一覧を表示する。 | `lsdev [-C] [-c <Class>] [-t <Type>] [-s <Subclass>]` | <pre>lsdev -Cc disk     # 全ディスク<br>lsdev -Cc adapter  # 全アダプタ<br>lsdev -Cc tape     # テープ装置</pre> | Available（利用可）/ Defined（定義済）の状態欄に注意。Defined のままなら cfgmgr 等で構成必要。 | [inc-lv-not-recognized](09-incident-procedures.md#inc-lv-not-recognized), [cfg-disk-add](08-config-procedures.md#cfg-disk-add) |
| `lsattr` | デバイスの ODM 属性を表示する。MPIO の reserve_policy / queue_depth 等を見るときに必須。 | `lsattr -El <Device> [-a <Attribute>]` | <pre>lsattr -El hdisk0<br>lsattr -El sys0 -a realmem  # 物理メモリ<br>lsattr -El ent0 -a media_speed</pre> | True 列が表示用名、設定変更は chdev で実施。 | [cfg-mpio-tuning](08-config-procedures.md#cfg-mpio-tuning) |
| `chdev` | デバイス属性を変更する。ODM および実機（kernel）両方に反映可能。 | `chdev -l <Device> -a <Attribute>=<Value> [-P\|-T\|-U]` | <pre>chdev -l hdisk1 -a queue_depth=64 -U  # 動的反映（オープン中可）<br>chdev -l ent0 -a jumbo_frames=yes -P  # 次回 boot 反映</pre> | -U=動的反映、-P=ODM のみ更新（次回 boot で反映）、-T=実機のみ。誤った属性で chdev するとデバイスが Defined になることあり。 | [cfg-mpio-tuning](08-config-procedures.md#cfg-mpio-tuning), `cfg-network-jumbo` |
| `cfgmgr` | 新たに認識されたデバイスを構成する（Defined → Available）。新規ディスク追加後の必須コマンド。 | `cfgmgr [-v] [-l <Device>]` | <pre>cfgmgr -v  # 詳細メッセージ付きで全デバイス構成<br>cfgmgr -l fcs0  # FC アダプタ配下のみ再構成</pre> | 実行に時間かかる場合あり（FC SAN 等）。SCSI/FC 両方に対し全パスを再スキャン。 | [cfg-disk-add](08-config-procedures.md#cfg-disk-add) |
| `lspv` | Physical Volume（PV、ディスク）一覧と各 PV の VG 所属を表示する。 | `lspv  # 一覧<br>lspv <PV>  # 詳細` | <pre>lspv<br>lspv hdisk0  # PVID, VG 名, total/free PP<br>lspv -l hdisk0  # PV 上の LV 一覧</pre> | PVID が `none` のときは VG に未組み込み。`00000000...` なら chdev で PV 削除可能。 | [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv), [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror) |
| `lsvg` | Volume Group（VG）の一覧および詳細情報を表示する。 | `lsvg            # 全 VG 一覧<br>lsvg <VG>      # 詳細<br>lsvg -l <VG>   # LV 一覧<br>lsvg -p <VG>   # PV 一覧` | <pre>lsvg rootvg<br>lsvg -l datavg</pre> | VG が varyoff（オフライン）のときは情報が取れない。 | [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv) |
| `lslv` | Logical Volume（LV）の構成・物理配置・属性を表示する。 | `lslv <LV>       # 詳細<br>lslv -l <LV>    # PV 別配置<br>lslv -m <LV>    # PP マッピング` | <pre>lslv hd5  # boot LV<br>lslv -l hd2  # /usr の物理配置</pre> | ミラー状態の確認は `lslv -m` で同一 LP の PP1/PP2/PP3 が異なる PV にあるか見る。 | [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror), [inc-lv-not-recognized](09-incident-procedures.md#inc-lv-not-recognized) |
| `mkvg` | 新しい Volume Group を作成する。データ領域用ディスクの初期構築で必須。 | `mkvg [-S] [-y <VG>] [-s <PP_size>] <PV>` | <pre>mkvg -S -y datavg -s 64 hdisk1 hdisk2  # scalable VG, PP=64MB</pre> | -S = scalable VG（既定 1024 PV / 256 LV / 32768 PP）。AIX 7.3 では scalable VG 推奨。 | [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv) |
| `mklv` | VG 内に新しい Logical Volume を作成する。 | `mklv [-y <LV>] [-t <fstype>] [-c <copies>] <VG> <PPs> [<PV>...]` | <pre>mklv -y datalv -t jfs2 datavg 100  # 100 PP の jfs2 LV<br>mklv -c 2 -s s rootvg 16 hdisk1 hdisk2  # ミラー LV</pre> | -c 2 -s s で同期書き込み（safe）ミラー。-c 2 -s n = 順次。-c 2 -s p = parallel write（高速、デフォルト）。 | [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv), [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror) |

## ファイルシステム（3 件）

| コマンド | 用途 | 構文 | 典型例 | 注意点 | 関連手順 |
|---|---|---|---|---|---|
| `df` | ファイルシステムの容量と使用率を表示する。FS full 検知の最初のコマンド。 | `df [-g] [-k] [-m] [-i] [<FS>]` | <pre>df -g    # GB 単位<br>df -i    # i-node 使用率<br>df /var  # 個別 FS</pre> | df -k はブロック数（512 バイト）。-g で GB、-m で MB 表記が読みやすい。 | [inc-fs-full](09-incident-procedures.md#inc-fs-full), [cfg-fs-extend](08-config-procedures.md#cfg-fs-extend) |
| `chfs` | ファイルシステムを動的に変更（拡張、属性変更）する。FS full の対応で頻用。 | `chfs -a size=+<追加サイズ> <マウントポイント><br>chfs -a size=<絶対サイズ> <マウントポイント>` | <pre>chfs -a size=+1G /var      # 1GB 追加<br>chfs -a size=4G /opt       # 絶対値で 4GB に<br>chfs -a logname=INLINE /home  # JFS2 INLINE log 化</pre> | size の単位省略時は 512 バイトブロック数。基底 LV と JFS2 メタデータ両方を伸ばす。VG に空き PP 必要。 | [inc-fs-full](09-incident-procedures.md#inc-fs-full), [cfg-fs-extend](08-config-procedures.md#cfg-fs-extend) |
| `fsck` | ファイルシステムの整合性チェック。boot 失敗時や強制 unmount 後に必須。 | `fsck [-y] [-p] [-V <vfstype>] <FS><br>fsck -y /dev/lv01  # LV 直指定` | <pre>fsck -y /home  # 自動 yes<br>fsck -p /home  # 高速チェック</pre> | **実行前に必ず unmount**（/ や /usr 等は単独ユーザモード or boot 中のみ）。JFS2 は通常 INLINE log があるため fsck 不要だが、メタデータ破損疑い時は実施。 | [inc-fsck-required](09-incident-procedures.md#inc-fsck-required), [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led) |

## ネットワーク（5 件）

| コマンド | 用途 | 構文 | 典型例 | 注意点 | 関連手順 |
|---|---|---|---|---|---|
| `ifconfig` | ネットワークインターフェースの状態確認・一時設定変更。 | `ifconfig [<Interface>] [up\|down] [<IP> netmask <Mask>]` | <pre>ifconfig -a              # 全インターフェース<br>ifconfig en0             # 個別<br>ifconfig en0 down        # 一時停止<br>ifconfig en0 192.168.1.10 netmask 255.255.255.0 up</pre> | ifconfig での変更は揮発性。永続化は chdev -l en0 -a netaddr=... -P で行う。 | [cfg-hostname-ip](08-config-procedures.md#cfg-hostname-ip), [inc-network-down](09-incident-procedures.md#inc-network-down) |
| `netstat` | ネットワーク接続・統計情報を表示する。性能・障害切り分けで頻用。 | `netstat [-rn] [-an] [-i] [-s] [-v] [-D]` | <pre>netstat -rn   # ルーティングテーブル<br>netstat -an   # 全接続<br>netstat -i    # インターフェース統計<br>netstat -v    # ドライバ統計（エラー数）</pre> | netstat -i のエラー列が増え続けるなら NIC ハードウェア障害疑い。 | [inc-network-down](09-incident-procedures.md#inc-network-down), [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation) |
| `no` | TCP/IP ネットワーク tunable の表示・設定。 | `no -a                    # 全 tunable<br>no -L <Tunable>          # 詳細<br>no -p -o <T>=<V>         # 永続変更<br>no -d <T>                # 既定値復元` | <pre>no -L tcp_sendspace<br>no -p -o tcp_sendspace=262144</pre> | AIX 7.3 から restricted tunable（直接編集禁止のもの）は no -F が必要。NFS 系は nfso を使う（no ではない）。 | [cfg-tcp-buffers](08-config-procedures.md#cfg-tcp-buffers) |
| `nfso` | NFS 専用 tunable の表示・設定。`no` ではなくこちらで管理する。 | `nfso -a                  # 全 NFS tunable<br>nfso -L <T>              # 詳細<br>nfso -p -o <T>=<V>       # 永続` | <pre>nfso -L nfs_socketsize<br>nfso -p -o nfs_rfc1323=1</pre> | v3 で nfs_socketsize を `no` で扱った誤りを修正。NFS tunable は nfso 専用。 | [cfg-nfs-mount](08-config-procedures.md#cfg-nfs-mount) |
| `ping` | ICMP echo によるネットワーク到達性確認。 | `ping [-c <count>] [-s <size>] <Host>` | <pre>ping -c 4 192.168.1.1<br>ping -c 10 -s 8000 server.example.com  # MTU/jumbo frame 確認</pre> | AIX の ping は既定で連続送信。-c で回数指定するのが安全。 | [inc-network-down](09-incident-procedures.md#inc-network-down) |

## 性能・プロセス（5 件）

| コマンド | 用途 | 構文 | 典型例 | 注意点 | 関連手順 |
|---|---|---|---|---|---|
| `vmstat` | 仮想メモリ・CPU・I/O 統計を表示。性能ボトルネック切り分けの第一歩。 | `vmstat [<interval> [<count>]]<br>vmstat -v   # メモリ詳細` | <pre>vmstat 5 12  # 5 秒ごとに 12 回<br>vmstat -v    # ページング詳細<br>vmstat -s    # サマリ</pre> | wa（I/O 待ち）が常時 30%+ なら I/O ボトルネック、avm（active virtual memory）が増え続けるならメモリリーク疑い。 | [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation) |
| `iostat` | ディスク I/O 統計を表示。 | `iostat [-d] [<interval> [<count>]]<br>iostat -DRTl  # 詳細出力（read/write 別、レイテンシ）` | <pre>iostat 5 12   # 5 秒ごと<br>iostat -DRTl 5 12  # 詳細形式</pre> | %tm_act（busy 率）80%+ が継続するディスクは飽和。 | [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation) |
| `topas` | リアルタイム性能モニタ（CPU、メモリ、I/O、ネットワーク、プロセス）。Linux の top 相当。 | `topas [-i <interval>] [-P\|-D\|-L]` | <pre>topas         # 統合表示<br>topas -P      # プロセス詳細<br>topas -D      # ディスク詳細<br>topas -L      # LPAR 統計</pre> | topasrec で記録、topas -R で再生可能。SSH 経由でも動作。 | [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation), [inc-process-hung](09-incident-procedures.md#inc-process-hung) |
| `ps` | プロセス一覧表示。 | `ps -ef       # 全プロセス<br>ps aux       # BSD 形式<br>ps -eo pid,pcpu,pmem,user,args  # カスタム` | <pre>ps -ef \| grep db2<br>ps -eo pid,pcpu,pmem,args --sort=-pcpu \| head</pre> | AIX の ps は SVR4 系と BSD 系両方対応。-T <pid> でスレッド表示。 | [inc-process-hung](09-incident-procedures.md#inc-process-hung) |
| `kill` | プロセスにシグナルを送る。hung プロセス停止に使う。 | `kill [-<signal>] <pid>` | <pre>kill 12345        # SIGTERM<br>kill -9 12345     # SIGKILL（強制）<br>kill -HUP 12345   # 設定再読み込み</pre> | **いきなり -9 はしない**。SIGTERM → 数秒待つ → 効かなければ -9 が原則。-9 は OS のクリーンアップ処理を飛ばす。 | [inc-process-hung](09-incident-procedures.md#inc-process-hung) |

## チューニング（3 件）

| コマンド | 用途 | 構文 | 典型例 | 注意点 | 関連手順 |
|---|---|---|---|---|---|
| `ioo` | I/O 関連の VMM tunable（j2_inodeCacheSize 等）を表示・設定する。 | `ioo -a                   # 全表示<br>ioo -L <T>               # 詳細<br>ioo -p -o <T>=<V>        # 永続` | <pre>ioo -L j2_inodeCacheSize<br>ioo -p -o j2_inodeCacheSize=400 -o j2_metadataCacheSize=400</pre> | AIX 7.3 で j2_inodeCacheSize の既定が 400 → 200。低メモリで多数 open file する場合は要再設定。 | [cfg-ioo-tuning](08-config-procedures.md#cfg-ioo-tuning) |
| `vmo` | VMM（Virtual Memory Manager）の tunable を表示・設定する。 | `vmo -a<br>vmo -L <T><br>vmo -p -o <T>=<V>` | <pre>vmo -L minperm%<br>vmo -p -o minperm%=3 -o maxperm%=90</pre> | Restricted tunable は -F 必須。lru_file_repage は AIX 7.1 以降 effectively no-op。 | `cfg-vmo-tuning` |
| `schedo` | CPU スケジューラの tunable を表示・設定する。 | `schedo -a<br>schedo -L <T><br>schedo -p -o <T>=<V>` | <pre>schedo -L vpm_throughput_mode<br>schedo -p -o vpm_throughput_mode=2</pre> | Power10 共有プロセッサモードで vpm_throughput_mode=2 が既定。誤った値で性能劣化することあり。 | `cfg-schedo-tuning` |

## パッケージ管理（3 件）

| コマンド | 用途 | 構文 | 典型例 | 注意点 | 関連手順 |
|---|---|---|---|---|---|
| `lslpp` | インストール済 fileset 一覧と詳細情報を表示する。 | `lslpp -L                 # 全 fileset<br>lslpp -L <fileset>       # 個別<br>lslpp -h <fileset>       # 履歴<br>lslpp -f <fileset>       # 構成ファイル一覧` | <pre>lslpp -L bos.rte<br>lslpp -h bos.net.tcp.client  # 何時何が入ったか</pre> | VRMF（Version.Release.Modification.Fix）形式で表示。 | [cfg-package-install](08-config-procedures.md#cfg-package-install), [inc-package-install-fail](09-incident-procedures.md#inc-package-install-fail) |
| `installp` | BFF/RPM 形式の fileset をインストール・更新・削除する。 | `installp -aXd <Source> <Fileset>      # 適用<br>installp -u <Fileset>                 # 削除<br>installp -p -aXd <Source> <Fileset>   # プレビュー<br>installp -L                          # 適用済一覧` | <pre>installp -aXd /dev/cd0 bos.rte.man<br>installp -p -aXd . all > /tmp/preview.log</pre> | -X = 必要に応じて自動拡張、-a = 適用、-c = commit。-p = preview（試験のみ）。 | [cfg-package-install](08-config-procedures.md#cfg-package-install) |
| `instfix` | AIX のフィックス（APAR、TL、SP）が適用されているかを確認する。 | `instfix -i                       # 全フィックス<br>instfix -ik <APAR>               # APAR 単位<br>instfix -ivk <APAR>              # 詳細` | <pre>instfix -i \| grep ML  # ML 履歴<br>instfix -ivk IV12345  # 該当 APAR</pre> | ML（Maintenance Level）= 旧称、現在は TL。 | [cfg-package-install](08-config-procedures.md#cfg-package-install) |

## システム情報・起動（4 件）

| コマンド | 用途 | 構文 | 典型例 | 注意点 | 関連手順 |
|---|---|---|---|---|---|
| `oslevel` | AIX のリリースレベルを表示する。 | `oslevel -s                # 完全レベル（TL/SP）<br>oslevel -r                # TL<br>oslevel -q                # 既知レベル一覧` | <pre>oslevel -s<br># 出力例: 7300-04-00-2546（AIX 7.3 TL4 SP0）</pre> | AIX 7.3 の最新は 7.3.4 / TL4（2025-12 リリース）。 | [cfg-package-install](08-config-procedures.md#cfg-package-install) |
| `bootinfo` | システム起動に関する情報を取得する。 | `bootinfo -K   # カーネルビット数<br>bootinfo -s   # ディスクサイズ<br>bootinfo -y   # 32bit/64bit ハードウェア<br>bootinfo -p   # POWER モデル` | <pre>bootinfo -K  # 64<br>bootinfo -p  # chrp</pre> | trace facility が AIX 7.3 で root 限定化されているため、特権必要なオプションあり。 | [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led) |
| `bootlist` | 起動デバイスの順序を表示・変更する。boot 失敗対応で必須。 | `bootlist -m normal -o                       # 表示<br>bootlist -m normal hdisk0 hdisk1            # 設定<br>bootlist -m service hdisk0                  # サービスモード` | <pre>bootlist -m normal -o<br>bootlist -m normal hdisk0 hdisk1 cd0</pre> | `-m normal` = 通常起動、`-m service` = 診断モード。最大 5 デバイス指定可。 | [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led), [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror) |
| `bosboot` | ブートイメージ（BLV）を作成・更新する。カーネル変更後に必須。 | `bosboot -ad /dev/<bootdisk><br>bosboot -ad /dev/ipldevice  # 現在の boot ディスク` | <pre>bosboot -ad /dev/hdisk0<br># rootvg ミラー後は両方のディスクに対し実施</pre> | BLV 作成中はディスク I/O が走るため業務影響に注意。失敗すると次回起動不可になる。 | [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror), [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led) |

## バックアップ（2 件）

| コマンド | 用途 | 構文 | 典型例 | 注意点 | 関連手順 |
|---|---|---|---|---|---|
| `mksysb` | rootvg の bootable バックアップ（システムバックアップ）を作成する。 | `mksysb [-i] [-p] [-X] <Device\|File>` | <pre>mksysb -i /dev/rmt0     # テープへ<br>mksysb -i /backup/sysb.mksysb  # ファイルへ<br>smit mksysb              # SMIT 経由</pre> | -i = image.data 自動更新、-p = pack 圧縮無し、-X = FS 自動拡張。NIM 経由で別 LPAR を NIM クライアントとして bootable 復元可能。 | [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup) |
| `savevg` | rootvg 以外の VG をバックアップする。 | `savevg -i [-X] <Device\|File> <VG>` | <pre>savevg -if /backup/datavg.savevg datavg</pre> | 復元は restvg。データのみ、boot 不可（mksysb と違って bootable ではない）。 | [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup) |

## ユーザ・セキュリティ（3 件）

| コマンド | 用途 | 構文 | 典型例 | 注意点 | 関連手順 |
|---|---|---|---|---|---|
| `lsuser` | ユーザ属性を一覧・表示する。 | `lsuser [-a <attr>] ALL<br>lsuser <user>` | <pre>lsuser -a id home shell ALL<br>lsuser root  # root の属性詳細</pre> | /etc/security/user, /etc/security/passwd 等の組み合わせ。 | [cfg-user-add](08-config-procedures.md#cfg-user-add), [inc-login-locked](09-incident-procedures.md#inc-login-locked) |
| `passwd` | ユーザのパスワードを変更する。root は他ユーザのパスワードを設定できる。 | `passwd               # 自分のパスワード変更<br>passwd <user>        # 他ユーザ（root のみ）` | <pre>passwd alice<br># 旧パスワード入力 → 新パスワード 2 回<br><br># パスワードロック解除<br>chsec -f /etc/security/lastlog -a unsuccessful_login_count=0 -s alice</pre> | AIX 7.3 既定 hash は SSHA-256。試行失敗回数が loginretries 超でロックされる。 | [cfg-user-add](08-config-procedures.md#cfg-user-add), [inc-login-locked](09-incident-procedures.md#inc-login-locked) |
| `chsec` | セキュリティ stanza ファイル（/etc/security/* 配下）を編集する。 | `chsec -f <file> -a <attr>=<value> -s <stanza>` | <pre>chsec -f /etc/security/lastlog -a unsuccessful_login_count=0 -s alice  # ロック解除<br>chsec -f /etc/security/login.cfg -a logintimes=ALL:1700-2300 -s default</pre> | stanza ファイルを直接 vi で編集するより chsec を使う方が安全（構文エラー防止）。 | [cfg-user-add](08-config-procedures.md#cfg-user-add), [inc-login-locked](09-incident-procedures.md#inc-login-locked) |

## サービス管理（3 件）

| コマンド | 用途 | 構文 | 典型例 | 注意点 | 関連手順 |
|---|---|---|---|---|---|
| `lssrc` | SRC（System Resource Controller）配下のサブシステム状態を表示する。 | `lssrc -a                  # 全サブシステム<br>lssrc -s <Subsystem>      # 個別<br>lssrc -g <Group>          # グループ` | <pre>lssrc -s syslogd<br>lssrc -g tcpip</pre> | active = 起動済、inoperative = 停止。SRC 配下でない（SMIT で起動するもの等）は ps で見る。 | [cfg-syslog](08-config-procedures.md#cfg-syslog), [inc-cron-fail](09-incident-procedures.md#inc-cron-fail) |
| `startsrc` | SRC 配下のサブシステムを起動する。 | `startsrc -s <Subsystem><br>startsrc -g <Group>` | <pre>startsrc -s syslogd<br>startsrc -g nfs</pre> | stopsrc -s <Sub> で停止、refresh -s <Sub> で設定再読み込み（HUP 送信相当）。 | [cfg-syslog](08-config-procedures.md#cfg-syslog), [cfg-nfs-mount](08-config-procedures.md#cfg-nfs-mount) |
| `smit / smitty` | AIX 標準のメニュー型システム管理ツール。smit = X11、smitty = テキスト。 | `smitty                       # トップメニュー<br>smitty <fastpath>            # 直接入る` | <pre>smitty users          # ユーザ管理<br>smitty mksysb         # mksysb 取得<br>smitty chfs           # FS 拡張</pre> | 実行履歴は /smit.log（操作）と /smit.script（コマンド）に記録される。これを見ると smit が裏で何をしたか分かる。 | [cfg-user-add](08-config-procedures.md#cfg-user-add), [cfg-fs-extend](08-config-procedures.md#cfg-fs-extend), [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup) |


---

*出典 ID は [07. 出典一覧](07-sources.md) を参照。*
