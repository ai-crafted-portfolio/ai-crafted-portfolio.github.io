# 本サイトの対象外項目

本サイトでは、AIX 管理者が日常的に使う**定番のみ**を掲載しています。
以下の項目は**意図的に除外**しています。それぞれの参照先（IBM 公式マニュアル等）も併記しているので、必要な場合はそちらをご確認ください。

## 章別サマリ

| 章 | 掲載 vs 除外 |
|---|---|
| コマンド | 本サイト掲載: 45 件 / 除外: 約 300 件 |
| 設定値 | 本サイト掲載: 40 件（tunable 20 + 設定ファイル 20） / 除外: 約 130 件 |
| 用語 | 本サイト掲載: 65 件 / 除外: 約 50 件 |
| 設定手順 | 本サイト掲載: 18 件（staple 15 + 補助 3） / 除外: 多数 |
| 障害対応 | 本サイト掲載: 18 件（staple 15 + 補助 3） / 除外: 多数 |

---

## コマンド

本サイト掲載: 45 件 / 除外: 約 300 件

### C 言語サブルーチン

- **概数**: 約 130 件
- **理由**: プログラマ向けの C ライブラリ関数で、AIX システム管理者の業務範囲外。Linux の man section 2/3 相当。
- **参照先**: [Base Operating System Technical Reference (Volume 1〜3)](https://www.ibm.com/docs/en/aix/7.3?topic=technical-references-base-operating-system)

**代表例（23 項目を抜粋）**:

- malloc / calloc / realloc / free
- fork / exec / execv / execve / wait / waitpid
- pthread_create / pthread_join / pthread_exit
- pthread_mutex_init / pthread_mutex_lock / pthread_mutex_unlock
- pthread_cancel / pthread_cond_wait / pthread_cond_signal
- open / close / read / write / lseek / dup / dup2
- fopen / fclose / fread / fwrite / fseek / fprintf / sscanf / fmemopen
- select / poll / epoll_*（AIX 独自版を含む）
- signal / sigaction / sigprocmask / kill (subroutine)
- msgget / msgsnd / msgrcv / shmget / shmat / shmdt / semget / semop
- stat / fstat / lstat / chmod / chown / unlink / link / symlink / readlink
- opendir / readdir / closedir / mkdir / rmdir / getcwd
- time / gettimeofday / localtime / strftime / mktime
- rand / srand / drand48
- strcpy / strncpy / strlen / strcmp / strcat / sprintf / snprintf
- memcpy / memset / memcmp
- sin / cos / exp / log / pow / sqrt（libm）
- socket / bind / listen / accept / connect / send / recv / setsockopt
- gethostbyname / getaddrinfo / inet_ntoa / inet_addr
- wlm_assign / wlm_endkey / wlm_set
- odm_open_class / odm_get_obj / odm_close_class
- perfstat_cpu / perfstat_memory / perfstat_disk
- （他、合計約 130 関数）

### 廃止・非推奨コマンド

- **概数**: 約 30 件
- **理由**: AIX 5L 以前で使われていたが現在は非推奨、または AIX 7.3 で削除済み。
- **参照先**: [AIX 7.3 Release Notes — Removed features](https://www.ibm.com/docs/en/aix/7.3.0?topic=notes-aix-73-release)

**代表例（17 項目を抜粋）**:

- csh（C シェル — bash/ksh 推奨）
- rcp / rsh / rlogin（暗号化なし — ssh/scp 推奨）
- ftp（クライアント — sftp 推奨）
- telnet（クライアント — ssh 推奨）
- tftpd（一般用途では非推奨）
- uucp 系（uucp / uux / uucico 等）
- NIS+ 関連（rpc.nis* 等 — LDAP 推奨）
- Trusted Computing Base 旧管理コマンド（一部）
- SDD / SDDPCM（→ AIX_AAPCM へ移行）
- bos.net.tcp.bind 旧系（→ bind.rte 9.18）
- InfiniBand 5283/5285 関連（AIX 7.3 で非サポート）
- PowerSC Trusted Surveyor（powersc.ts — AIX 7.3 で非サポート）
- rsct.vsd / rsct.lapi.rte（VSD/LAPI 廃止）
- qcow2 イメージ関連（PowerVC で廃止 — RAW 推奨）
- ntpd（NTPv3 — NTPv4 ntpd4 推奨）
- sendmail の libcrypto_compat 依存版（→ 7.3.3 update）
- （他、合計約 30 件）

### ニッチな上級コマンド

- **概数**: 約 80 件
- **理由**: CAA / Trusted Execution / NIM 内部 / kdb 等、年に 1 回触るかどうかの専門ツール。
- **参照先**: [AIX 7.3 Commands Reference (全 6 巻)](https://www.ibm.com/docs/en/aix/7.3?topic=reference-commands)

**代表例（20 項目を抜粋）**:

- clmgr / clcmd / cluster
- lscluster / mkcluster / rmcluster
- chrepos / chcomg
- nim / lsnim / nimadm / nimsh
- lsnimres / mkdef / chdef
- nim_master_setup / nim_clients_setup
- trustchk / trustchk -p
- tsdb 関連
- mkwpar / startwpar / stopwpar / clogin
- lswpar / chwpar / rmwpar
- wlmcntrl / mkclass / chclass
- hdcryptmgr / pksctl / efsenable / efskeymgr
- asoo / aso (daemon)
- genfilt / mkfilt / lsfilt / ikedb
- kdb / errdead
- diag / diagela / diag_subsystem
- trace / trcrpt / trcstop / trcon / trcoff（root 限定化）
- aioo / aio_*
- lparstat / mpstat / pmcycles
- （他、合計約 80 件）

### システム内部・サービス担当者向けコマンド

- **概数**: 約 60 件
- **理由**: 通常運用で触らないシステム内部コマンド。IBM Service Information 担当者用。
- **参照先**: [AIX Diagnostic Subsystem / Service Information](https://www.ibm.com/docs/en/aix/7.3?topic=availability-diagnostic-subsystem)

**代表例（12 項目を抜粋）**:

- diag / diagela 内部コマンド群
- snap 内部のサブコマンド（snap_* 各種）
- lsfware / lscfg -vp（詳細出力モード）
- lsmcode（マイクロコード一覧）
- uname -F / uname -L
- errupdate / errinstall（テンプレート操作）
- trace 各サブコマンド
- perfwb / svmon の内部モード
- lparstat -d / -i / -E / -H
- syscalls / kdb -m sub
- fbcheck / bootinfo -B / bootinfo -t
- （他、合計約 60 件）

---

## 設定値

本サイト掲載: 40 件（tunable 20 + 設定ファイル 20） / 除外: 約 130 件

### VMM / I/O ニッチ tunable

- **概数**: 約 30 件
- **理由**: 通常運用で触らない、または restricted（IBM サポート指示なしで変更非推奨）。
- **参照先**: [Tunable Parameters Reference (Performance management)](https://www.ibm.com/docs/en/aix/7.3?topic=concepts-tunable-parameters)

**代表例（12 項目を抜粋）**:

- lru_file_repage（AIX 7.1 以降 effectively no-op）
- strict_maxclient / strict_maxperm
- vmm_default_pspa / vmm_klock_mode
- page_steal_method
- low_ps_handling
- memory_affinity / numa_balancing
- scrub / scrubclean
- fork_policy / data_stagger_interval
- j2_atimeUpdateSymlink / j2_dynamicBufferPreallocation
- j2_minPageReadAhead / j2_maxPageReadAhead
- ioo の internal flags（pd_npages, lvm_bufcnt 等）
- （他、合計約 30 件）

### ネットワーク / NFS の上級 tunable

- **概数**: 約 25 件
- **理由**: 通常チューニングでは触らない、または特定ハード/ワークロード専用。
- **参照先**: [no command / nfso command](https://www.ibm.com/docs/en/aix/7.3.0?topic=n-no-command)

**代表例（11 項目を抜粋）**:

- tcp_init_window / tcp_finwait2
- tcp_keepidle / tcp_keepintvl / tcp_keepcnt
- tcp_low_rto / rto_high / rto_length / rto_limit / rto_low
- ndpqsize / ndp_mmaxtries / ndp_umaxtries
- udp_pmtu_discover / tcp_pmtu_discover
- ip6srcrouteforward / ip6_defttl
- ipfrag_max_used / ipfragttl
- extendednetstats / use_isno
- nfs_max_threads / nfs_v4_fail_over_timeout
- nfs_use_reserved_ports / nfs_iopace_pages
- （他、合計約 25 件）

### MPIO / デバイス内部属性

- **概数**: 約 25 件
- **理由**: AIX 7.3 から nondisplay 化（管理者は -P 等で参照）または特定ストレージ専用。
- **参照先**: [Device management — MPIO](https://www.ibm.com/docs/en/aix/7.3?topic=management-device)

**代表例（7 項目を抜粋）**:

- clr_q / q_err / q_type
- dist_err_pcnt / dist_tw_width
- lun_reset_spt / reassign_to / start_timeout
- rw_timeout / cmd_timeout
- max_transfer / pos / scbsy_dly
- FC adapter 内部: lg_term_dma, init_link, max_xfer_size 詳細値
- （他、合計約 25 件）

### セキュリティ・暗号系の細粒度設定

- **概数**: 約 30 件
- **理由**: Trusted Execution policy / IPsec policy / RBAC privilege 等、専門設計時のみ。
- **参照先**: [Security](https://www.ibm.com/docs/en/aix/7.3?topic=security)

**代表例（10 項目を抜粋）**:

- tepolicies.dat の各 CHKSHOBJS / CHKEXEC 等のフラグ
- lib.tsd.dat / Trusted Signature DB の細目
- /etc/security/audit/* (audit subsystem の objects/events/classes)
- /etc/security/pwdalg.cfg（password algorithm 個別設定）
- RBAC privilege 個別 (PV_*)
- Domain RBAC の domain 設計
- IPsec policy（mkfilt / IKE proposal / DH groups）
- PKS / hdcryptmgr の鍵管理詳細
- EFS の per-user キーストア設定
- （他、合計約 30 件）

### クラスタ・WPAR・LKU の専用設定

- **概数**: 約 20 件
- **理由**: CAA リポジトリ、WLM クラス、Live Update リソース等、年に数回触るかどうか。
- **参照先**: [Cluster Aware AIX / WPAR / Live Update](https://www.ibm.com/docs/en/aix/7.3?topic=availability-cluster-aware-aix-caa)

**代表例（7 項目を抜粋）**:

- /etc/cluster/rhosts
- Cluster repository disk 関連属性
- WLM tier / class / shares
- /etc/wlm/.regs
- /etc/lvupdate.data の各フィールド（ipsec_auto_migrate 以外）
- PowerSC AIXPert の policy
- （他、合計約 20 件）

---

## 用語

本サイト掲載: 65 件 / 除外: 約 50 件

### C プログラミング・ABI 用語

- **概数**: 約 20 件
- **理由**: コマンドの C subroutine 除外と整合。プログラマ向け。
- **参照先**: [General Programming Concepts](https://www.ibm.com/docs/en/aix/7.3?topic=programming-general)

**代表例（9 項目を抜粋）**:

- TLS（Thread Local Storage）
- TOC（Table of Contents — XCOFF）
- PIC（Position Independent Code）
- ABI（Application Binary Interface — 32bit/64bit）
- XCOFF（実行ファイル形式）
- ld scripts / linker options
- weak symbol
- lazy loading
- （他、合計約 20 件）

### ハードウェア低レベル用語

- **概数**: 約 15 件
- **理由**: POWER アーキテクチャの内部。OS 管理者は CHRP/POWER 程度知っていれば足りる。
- **参照先**: [POWER Processor Reference / OPAL firmware](https://www.ibm.com/support/pages/power-systems-firmware)

**代表例（8 項目を抜粋）**:

- OPAL（OpenPOWER Abstraction Layer）
- Hypervisor LPAR mode の詳細（dedicated / shared）
- VPM（Virtual Processor Management）の内部
- TPM 2.0 詳細
- Power System の SMT 設定詳細
- AME（Active Memory Expansion）の compression algorithm
- Hardware-Assisted Memory Mirror
- （他、合計約 15 件）

### AIX レガシ・歴史用語

- **概数**: 約 15 件
- **理由**: AIX 5L 以前の歴史用語、現行 AIX 7.3 では非推奨または別概念。
- **参照先**: [AIX 7.3 Release Notes — Removed features](https://www.ibm.com/docs/en/aix/7.3.0?topic=notes-aix-73-release)

**代表例（8 項目を抜粋）**:

- VxFS（Veritas — AIX 5L 時代の代替 FS、現在非サポート）
- DCE（Distributed Computing Environment）
- DFS（Distributed File System — DCE/DFS）
- PSSP（Parallel System Support Programs — クラスタ旧基盤）
- HACMP（PowerHA の旧称）
- Trusted Computing Base 旧用語
- AMS（Active Memory Sharing — PowerVM 機能）
- （他、合計約 15 件）

---

## 設定手順

本サイト掲載: 18 件（staple 15 + 補助 3） / 除外: 多数

### v3 で niche 偏重と批判された手順

- **概数**: 約 6 件
- **理由**: PKS rootvg 暗号化 / Trusted Execution+CHKSHOBJS / CAA リポジトリ / WPAR+WLM / NIM master / AIXPert は年に 1 回触るかどうか。
- **参照先**: [各機能の専門マニュアル](https://www.ibm.com/docs/en/aix/7.3)

**代表例（6 項目を抜粋）**:

- PKS による rootvg 暗号化（hdcryptmgr / pksctl）
- Trusted Execution + CHKSHOBJS ポリシー
- CAA リポジトリディスク構築（NVMe 対応含む）
- WPAR + Workload Manager 連携
- NIM master 構築 + LPP_SOURCE / SPOT
- AIXPert によるセキュリティ強化スクリプト

### OS マイグレーション系（別マニュアル参照）

- **概数**: （マニュアル参照）
- **理由**: AIX 7.x → 7.3.4 マイグレは IBM 公式 Migration Guide が決定版。本サイトでは概要のみ。
- **参照先**: [AIX Installation and migration](https://www.ibm.com/docs/en/aix/7.3?topic=migrating)

**代表例（6 項目を抜粋）**:

- premigration script 実行と廃止 fileset 確認
- rsct.vsd / rsct.lapi.rte の事前削除
- PowerSC Trusted Surveyor（powersc.ts）の事前削除
- Java 8 32bit SR6FP35 → SR6FP30 強制降格
- OpenSSL 1.x → 3.0 移行（旧 cnf 退避）
- BIND 9.18 (bind.rte) への置換

---

## 障害対応

本サイト掲載: 18 件（staple 15 + 補助 3） / 除外: 多数

### v3 で 7.3 移行プレチェック失敗ばかり集めていた事例

- **概数**: 約 10 件
- **理由**: 「日々の障害早見表」と銘打ちながら 7.3 移行ブロッカー集だった。これらは IBM 公式 Migration Guide または Release Notes を参照。
- **参照先**: [AIX 7.3 Release Notes](https://www.ibm.com/docs/en/aix/7.3.0?topic=notes-aix-73-release)

**代表例（11 項目を抜粋）**:

- hd5 拡張失敗（インストーラ）
- 144 I/O slot 越え boot 不可
- Java 8 32bit SR6FP35 ロード不能
- bos.net.tcp.sendmail 7.3.0.0 libcrypto エラー
- Trusted AIX 移行不能（v3 の事実誤認 — 実際は 7.3 にも現存）
- dsm.properties 欠落（migration 後）
- PowerSC TS 残存ブロック
- rsct.vsd ブロック
- NTPv3 起動失敗（AIX 7.3 で NTPv3 廃止表現は不正確 — 提供は継続）
- BIND 9.18 ツール欠落（dnssec-checkds 等）
- NIM SPOT missing image

### ハードウェア / ファームウェア系（IBM サポート連絡推奨）

- **概数**: （IBM サポート対応）
- **理由**: ハードウェア交換が必要な障害は OS 側手順より IBM サポート連絡が先。
- **参照先**: [IBM Support Portal](https://www.ibm.com/mysupport/)

**代表例（5 項目を抜粋）**:

- メモリ ECC 多発
- FC アダプタファームウェア不整合
- Power FW のバグ起因の hang
- PCI スロット不良
- EPOW（Environmental and Power Warning）

---

## 補足

本サイトは v3（348/167/104 の網羅型）の品質問題（C subroutine ノイズ、英語フラグメント、ファミリ固定文、niche 偏重、URL 不在、Trusted AIX に関する事実誤認、TL4 未反映等）を踏まえ、**件数を絞った定番集中・透明スコープ方針**で完全に書き直した v4 です。

「AIX 管理者が現場で月1回以上触るレベル」が選定基準で、それ以外は本章に列挙された参照先のいずれかをご確認ください。
