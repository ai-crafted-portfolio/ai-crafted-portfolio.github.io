# AIX 7.3 — 設定値一覧（網羅・167 件）

ioo / no / schedo / vmo / chdev tunable と /etc/* 配下の主要設定ファイル。Default / Values は ChromaDB chunk 由来のもののみ記載。

## tunable（108 件）

| パラメータ名 | 設定コマンド | デフォルト | 取り得る値 | 影響範囲 | 関連 | 出典 |
|---|---|---|---|---|---|---|
| j2_inodeCacheSize | ioo -p -o | of the j2_inodeCacheSize tunable parameter was changed from 400 to 200 | of the j2_inodeCacheSize tunable parameter was changed from 400 to 200 | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S30, S35, S35 |
| j2_metadataCacheSize | ioo -p -o | — | for the j2_inodeCacheSize and the j2_metadataCacheSize tunable parameters from 2 | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S30, S35, S35 |
| j2_dynamicBufferAllocation | ioo -p -o | — | — | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S25 |
| j2_maxPageReadAhead | ioo -p -o | — | of the | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S25 |
| j2_minPageReadAhead | ioo -p -o | — | — | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S25 |
| j2_nBufferPerPagerDevice | ioo -p -o | — | — | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S25 |
| j2_nPagesPerWriteBehindCluster | ioo -p -o | — | — | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S25 |
| j2_atimeUpdateSymlink | ioo -p -o | — | — | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S25 |
| j2_unmarkInodeWithDirInUse | ioo -p -o | — | — | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S25 |
| j2_implicitFileSyncEnabled | ioo -p -o | — | — | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S25 |
| j2_disableAtimeUpdate | ioo -p -o | — | — | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S25 |
| j2_xRefSyncBlocks | ioo -p -o | — | — | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S25 |
| fs_drf | ioo -p -o | — | — | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S25 |
| sync_release_ilock | ioo -p -o | — | — | ioo -L で確認、要再起動・動的反映どちらかは個別 | JFS2 / VMM I/O tunable | S25 |
| enhanced_affinity_balance | schedo -p -o | — | — | schedo -L、動的反映 | Scheduler tunable | S25 |
| enhanced_affinity_vmpool_limit | schedo -p -o | — | ="10"/> | schedo -L、動的反映 | Scheduler tunable | S24, S25 |
| smt_snooze_delay | schedo -p -o | — | — | schedo -L、動的反映 | Scheduler tunable | S25 |
| enhanced_memory_affinity | schedo -p -o | — | — | schedo -L、動的反映 | Scheduler tunable | S25 |
| vpm_xvcpus | schedo -p -o | — | — | schedo -L、動的反映 | Scheduler tunable | S25 |
| vpm_throughput_mode | schedo -p -o | of the | of the | schedo -L、動的反映 | Scheduler tunable | S30, S30 |
| vpm_fold_policy | schedo -p -o | — | — | schedo -L、動的反映 | Scheduler tunable | S25 |
| fixed_pri_global | schedo -p -o | characteristics by executing the | is greater than one, these threads must wait their turn | schedo -L、動的反映 | Scheduler tunable | S25, S25 |
| fork_policy | schedo -p -o | — | — | schedo -L、動的反映 | Scheduler tunable | S25 |
| maxfree | vmo -p -o | of minfree) for several reasons | ="0" applyType="nextboot" reboot="true" /> | vmo -L、動的反映 | VMM memory tunable | S19, S19, S24 |
| minfree | vmo -p -o | of the minfree parameter is increased to 960 per memory pool and the default val | for minfree and maxfree parameters | vmo -L、動的反映 | VMM memory tunable | S19, S19, S25 |
| mbpool | vmo -p -o | — | — | vmo -L、動的反映 | VMM memory tunable | S25 |
| numperm | unknown | — | — | — | — | S19, S25, S26 |
| maxperm | vmo -p -o | — | , the VMM normally steals only file pages, but if the repaging rate for file pag | vmo -L、動的反映 | VMM memory tunable | S19, S19, S19 |
| maxclient | vmo -p -o | s of the minfree and maxfree parameters depend on the memory size of the machine | , the VMM normally steals only file pages, but if the repaging rate for file pag | vmo -L、動的反映 | VMM memory tunable | S19, S19, S25 |
| minperm | vmo -p -o | — | , the VMM normally steals only file pages, but if the repaging rate for file pag | vmo -L、動的反映 | VMM memory tunable | S19, S19, S19 |
| page_steal_method | vmo -p -o | — | — | vmo -L、動的反映 | VMM memory tunable | S25 |
| lru_file_repage | vmo -p -o | — | — | vmo -L、動的反映 | VMM memory tunable | S25 |
| memory_affinity | vmo -p -o | memory allocation policy rotates among the MCMs | — | vmo -L、動的反映 | VMM memory tunable | S25 |
| maxpin | vmo -p -o | — | of the | vmo -L、動的反映 | VMM memory tunable | S25, S25, S25 |
| maxuproc | vmo / sys0 | — | — | /etc/security/limits との関係に注意 | システム全体の最大値・サイズ系 | S32, S32 |
| maxfilesp | vmo / sys0 | — | — | /etc/security/limits との関係に注意 | システム全体の最大値・サイズ系 | S25 |
| maxbufs | vmo / sys0 | — | — | /etc/security/limits との関係に注意 | システム全体の最大値・サイズ系 | S25 |
| nbpf | unknown | — | — | — | — | S25 |
| maxfiles | vmo / sys0 | — | — | /etc/security/limits との関係に注意 | システム全体の最大値・サイズ系 | S25 |
| max_logname | vmo / sys0 | when the output is not | from the | /etc/security/limits との関係に注意 | システム全体の最大値・サイズ系 | S8, S32, S32 |
| max_realmem | vmo / sys0 | — | — | /etc/security/limits との関係に注意 | システム全体の最大値・サイズ系 | S25 |
| maxdata | vmo / sys0 | is 0 | is saved in the auxiliary header and | /etc/security/limits との関係に注意 | システム全体の最大値・サイズ系 | S8 |
| maxstack | vmo / sys0 | is the autoexp | Sets the MAXSTACK value | /etc/security/limits との関係に注意 | システム全体の最大値・サイズ系 | S8, S8 |
| maxread | vmo / sys0 | — | — | /etc/security/limits との関係に注意 | システム全体の最大値・サイズ系 | S25 |
| tunablerev | vmo / sys0 | — | — | /etc/security/limits との関係に注意 | システム全体の最大値・サイズ系 | S25 |
| tcp_recvspace | no -p -o | for use_isno is 1 | for these parameters override the system-wide | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S22, S22, S24 |
| tcp_sendspace | no -p -o | for use_isno is 1 | for these parameters override the system-wide | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S22, S22, S24 |
| udp_recvspace | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| udp_sendspace | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| sb_max | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| somaxconn | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| rfc1323 | no -p -o | for use_isno is 1 | for these parameters override the system-wide | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S22, S22 |
| tcp_keepidle | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_keepintvl | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_keepcnt | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_finwait2 | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_TIME_WAIT | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_mss | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_pmtu | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_dss | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S35 |
| tcp_init | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_low | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_high | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_recvbuf | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_sendbuf | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_nagle | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| tcp_nodelay | no -p -o | for use_isno is 1 | for these parameters override the system-wide | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S22, S22 |
| tcp_timewait | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| ipv6_forwarding | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| ipv6_def_hop_limit | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| ipsendredirects | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| ipforwarding | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| ipignoreredirects | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| sack | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| nfs_v3_pdts | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| nfs_v4_pdts | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| nfs_repeat_messages | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| nfs_max_threads | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| nfs_socketsize | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| biod_count | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| nbiod_count | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| nfsd_count | no -p -o | — | — | no -L、ほとんど動的反映 | TCP/IP / NFS network tunable | S25 |
| aio_minservers | ioo -p -o | — | for Asynchronous I/O | AIX 7.x で常時有効、aioo は廃止 | Async I/O tunable | S20 |
| aio_maxservers | ioo -p -o | — | for Asynchronous I/O | AIX 7.x で常時有効、aioo は廃止 | Async I/O tunable | S20 |
| aio_maxreqs | ioo -p -o | — | — | AIX 7.x で常時有効、aioo は廃止 | Async I/O tunable | S25 |
| aio_max_per_user | ioo -p -o | — | — | AIX 7.x で常時有効、aioo は廃止 | Async I/O tunable | S25 |
| aio_kproc_per_user | ioo -p -o | — | — | AIX 7.x で常時有効、aioo は廃止 | Async I/O tunable | S25 |
| aio_server_inactivity | ioo -p -o | A | for Asynchronous I/O | AIX 7.x で常時有効、aioo は廃止 | Async I/O tunable | S20 |
| posix_aio | ioo -p -o | — | — | AIX 7.x で常時有効、aioo は廃止 | Async I/O tunable | S25 |
| reserve_policy | chdev -a | of the throughput mode for | take effect | デバイス再オープンで反映、-U で動的可 | Disk / FC adapter ODM 属性 | S12, S12, S30 |
| algorithm | chdev -a | of none is | for the -e flag is entered, the default value of none is | デバイス再オープンで反映、-U で動的可 | Disk / FC adapter ODM 属性 | S3, S3, S3 |
| queue_depth | chdev -a | of the throughput mode for | is changed to no_reserve | デバイス再オープンで反映、-U で動的可 | Disk / FC adapter ODM 属性 | S30, S30, S35 |
| num_cmd_elems | chdev -a | — | : | デバイス再オープンで反映、-U で動的可 | Disk / FC adapter ODM 属性 | S30, S35 |
| rw_timeout | chdev -a | of 30 seconds | of 30 seconds | デバイス再オープンで反映、-U で動的可 | Disk / FC adapter ODM 属性 | S12 |
| max_xfer_size | chdev -a | — | — | デバイス再オープンで反映、-U で動的可 | Disk / FC adapter ODM 属性 | S25 |
| reserve_lock | chdev -a | — | — | デバイス再オープンで反映、-U で動的可 | Disk / FC adapter ODM 属性 | S25 |
| max_target | chdev -a | — | — | デバイス再オープンで反映、-U で動的可 | Disk / FC adapter ODM 属性 | S25 |
| fc_err_recov | chdev -a | — | — | デバイス再オープンで反映、-U で動的可 | Disk / FC adapter ODM 属性 | S6 |
| dyntrk | chdev -a | — | — | デバイス再オープンで反映、-U で動的可 | Disk / FC adapter ODM 属性 | S6 |
| fast_fail | chdev -a | — | — | デバイス再オープンで反映、-U で動的可 | Disk / FC adapter ODM 属性 | S6 |
| fc_fail | chdev -a | — | — | デバイス再オープンで反映、-U で動的可 | Disk / FC adapter ODM 属性 | S25 |
| ame_min_ucpool_size | vmo -p -o | — | — | vmo -L、動的反映 | VMM memory tunable | S24, S25 |
| ame_mpsize_support | vmo -p -o | — | — | vmo -L、動的反映 | VMM memory tunable | S25 |
| ipsec_auto_migrate | /etc/lvupdate.data | — | — | LKU 実行時のみ評価 | Live Update 用設定 | S34, S35, S35 |
| AIX_CWD_CACHE | 環境変数 | — | — | プロセス起動時に評価 | プロセス環境変数 | S35 |
| LDR_CNTRL | 環境変数 | address-space model, and they will break if they are run using the large address | is obtained either from the LDR_CNTRL | プロセス起動時に評価 | プロセス環境変数 | S9, S16 |
| mt_qk_io_recov | chdev -a | — | — | デバイス属性、chdev で反映 | デバイス属性 | S25, S34 |
| queues_rx | chdev -a | — | — | デバイス属性、chdev で反映 | デバイス属性 | S35 |

## 設定ファイル（59 件）

| 設定ファイル | 用途 | 出典 |
|---|---|---|
| `/etc/environment` | — | S15 |
| `/etc/profile` | — | S15 |
| `/etc/security/login.cfg` | — | S32 |
| `/etc/security/user` | — | S32, S32 |
| `/etc/security/limits` | — | S15 |
| `/etc/security/passwd` | — | S32, S32 |
| `/etc/security/group` | — | S32, S32 |
| `/etc/security/audit/config` | — | S9 |
| `/etc/security/audit/events` | — | S15 |
| `/etc/security/audit/objects` | — | S15 |
| `/etc/security/ldap/ldap.cfg` | — | S15 |
| `/etc/security/sysck.cfg` | — | S15 |
| `/etc/security/roles` | — | S15 |
| `/etc/security/authorizations` | — | S15 |
| `/etc/security/privcmds` | — | S15 |
| `/etc/security/privfiles` | — | S15 |
| `/etc/security/privdevs` | — | S15 |
| `/etc/security/domobjs` | — | S15 |
| `/etc/security/domains` | — | S15 |
| `/etc/security/aixpert/core/aixpertall.xml` | — | S15 |
| `/etc/inittab` | — | S15 |
| `/etc/inetd.conf` | — | S15 |
| `/etc/services` | — | S15 |
| `/etc/hosts` | — | S23 |
| `/etc/resolv.conf` | — | S15 |
| `/etc/netsvc.conf` | — | S15 |
| `/etc/passwd` | — | S32, S32 |
| `/etc/group` | — | S32 |
| `/etc/motd` | — | S15 |
| `/etc/issue` | — | S15 |
| `/etc/filesystems` | — | S15 |
| `/etc/exports` | — | S15 |
| `/etc/exclude.rootvg` | — | S15 |
| `/etc/qconfig` | — | S15 |
| `/etc/aliases` | — | S15 |
| `/etc/sendmail.cf` | — | S15 |
| `/etc/rc.tcpip` | — | S15 |
| `/etc/rc.net` | — | S15 |
| `/etc/rc.nfs` | — | S15 |
| `/etc/objrepos` | — | S32, S32 |
| `/etc/syslog.conf` | — | S15 |
| `/etc/ssh/sshd_config` | — | S15 |
| `/etc/ssh/ssh_config` | — | S15 |
| `/etc/ipsec.conf` | — | S15 |
| `/etc/ntp.conf` | — | S15 |
| `/etc/dlpar/dr.conf` | — | S15 |
| `/etc/wlm/.regs` | — | S15 |
| `/var/ssl/openssl.cnf` | — | S15 |
| `/etc/security/audit/streamcmds` | — | S15 |
| `/etc/objrepos/CuDv` | — | S15 |
| `/etc/objrepos/CuAt` | — | S15 |
| `/etc/objrepos/PdDv` | — | S15 |
| `/etc/objrepos/PdAt` | — | S15 |
| `/etc/security/aixpert/log/aixpert.log` | — | S15 |
| `/usr/lib/objrepos/PdDv` | — | S15 |
| `/etc/lvupdate.data` | — | S15 |
| `/etc/security/tepolicies.dat` | — | S15 |
| `/etc/security/lib.tsd.dat` | — | S15 |
| `/etc/snmpdv3.conf` | — | S15 |

[← AIX 7.3 トップへ](index.md)
