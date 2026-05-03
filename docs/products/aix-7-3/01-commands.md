# AIX 7.3 — コマンド一覧（網羅・348 件）

AIX マニュアル `Commands Reference Vol1/2/3` および man-page 相当 chunk から `<コマンド名> Command\nPurpose\n` パターンで自動抽出。Hallucinationを避けるため ChromaDB chunk 由来のテキストのみを使用しています。「種別」は kind + 名前から日本語カテゴリに分類、「用途」は英語マニュアル原文をルールベースで日本語化（接頭辞置換）したものです。

## カテゴリ別件数

| カテゴリ | 件数 |
|---|---|
| API・サブルーチン | 129 |
| その他システム管理 | 85 |
| ネットワーク | 17 |
| 一般 UNIX | 13 |
| インストール・更新 | 11 |
| プログラミング | 11 |
| クラスタ・HA | 10 |
| ユーザ・認証 | 9 |
| ストレージ・FS | 9 |
| デーモン | 9 |
| 障害対応・トレース | 9 |
| パフォーマンス監視 | 8 |
| X11・GUI | 7 |
| アカウンティング | 4 |
| デバイス管理・ODM | 3 |
| 印刷 | 3 |
| スケジューリング | 2 |
| セキュリティ | 2 |
| WPAR・仮想化 | 2 |
| バックアップ・リカバリ | 1 |
| メール | 1 |
| 国際化 | 1 |
| サブシステム制御 | 1 |
| 障害対応 | 1 |

## 全コマンド一覧

| コマンド名 | カテゴリ | 構文 | 用途（日本語） | 例 | 関連手順 | 出典 |
|---|---|---|---|---|---|---|
| `accel_decompress` | API・サブルーチン | #include <sys/types.h> #include <sys/vminfo.h>   int accel_decompress (void *c_buf, size_t c_len,  void *uc buf, size_t *uc_lenp, int flags) | Decompresses data by using hardware accelerated memory decompression or a slower software | — | — | S3 |
| `acct_wpar` | API・サブルーチン | — | 次を有効化する: and disables process accounting. | — | — | S3 |
| `acctrpt` | アカウンティング | — | 次を生成する: advanced accounting subsystem data reports. | — | — | S7 |
| `addrpnode` | クラスタ・HA | — | 次を追加する: one or more nodes to a peer domain definition. | — | — | S7 |
| `addssys` | API・サブルーチン | #include <sys/srcobj.h> #include <spc.h> int addssys ( SRCSubsystem ) struct SRCsubsys *SRCSubsystem; Description | 次を追加する: the SRCsubsys record to the subsystem object class. | — | — | S3 |
| `alt_disk_install` | バックアップ・リカバリ | Create Alternate Disk  alt_disk_install { -d device \| -C} [ -i image.data] [ -s script ] [ -R resolv_conf] [ -D]  [ -B] [ -V] [ -r] [ -O ] [ | 次をインストールする: an alternate disk with a mksysb install image or clones the currently running system to an | — | — | S7 |
| `amepat` | パフォーマンス監視 | amepat [{{[-c max_ame_cpuusage% ] \| [-C max_ame_cpuusage  ]}\|[  -e startexpfactor  [ :stopexpfactor [ :incexpfactor ]  ]]}][  -F  ][{[-t tgt | Active Memory Expansion Planning and Advisory Tool amepat reports Active Memory Expansion (AME) | — | — | S7 |
| `artexget` | スケジューリング | artexget [-v] [-d] [-p \| -r \| -n] [-l {dynamic \| disruptive \| reboot}] [-f {txt \|csv \| xml}] [-m comment] [-V version] [-g categories] [-g l | The artexget command lists the configuration and tuning parameter information from a specified profile | — | — | S7 |
| `audit` | セキュリティ | — | 次を制御する: system auditing. | — | — | S7 |
| `authqry` | ユーザ・認証 | — | Queries the usage of authorizations over a time period. | — | — | S7 |
| `bdftopcf` | その他システム管理 | — | 次を変換する: fonts from Bitmap Distribution Format (bdf) to Portable Compiled Format (pcf). | 1. To convert fonts into terminal fonts whenever possible, enter: | — | S7 |
| `bellmail` | ネットワーク | — | 次を送信する: messages to system users and displays messages from system users. | — | — | S7 |
| `bindprocessor` | WPAR・仮想化 | — | Binds or unbinds the kernel threads of a process to a processor. | — | — | S7 |
| `bootlist` | その他システム管理 | — | 次を表示する: and alters the list of boot devices available to the system. | — | [インストール時 hd5 拡張失敗の切り分け](09-incident-procedures.md#inc-install-hd5-fail)<br>[144 I/O slot 越えのデバイスから boot 不可](09-incident-procedures.md#inc-144slot-boot-fail) | S7 |
| `bsh` | 一般 UNIX | — | The bsh command invokes the Bourne shell. | — | — | S7 |
| `bugfiler` | メール | — | Automatically stores bug reports in specified mail directories. | — | — | S7 |
| `capture` | デバイス管理・ODM | cat [ - q ] [  -r ] [ - s ] [ - S ] [ - u ][ - Z ] [ - n [ - b ] ] [ - v [ - e ] [ - t ] ] [  - \| File ... ] | 次を許可する: terminal screens to be dumped to a file. | — | — | S7 |
| `cdc` | アカウンティング | — | 次を変更する: the comments in a SCCS delta. | — | — | S7 |
| `cdumount` | ストレージ・FS | cdutil { -l \| -r \| -s [ -k ] } [ -q ] [ -h \| -? ] DeviceName | 次をアンマウントする: a previously mounted file system on a device managed by cdromd. | — | — | S7 |
| `certlink` | ユーザ・認証 | — | certlink links a certificate in a remote repository to a user account. | — | — | S7 |
| `chcomg` | インストール・更新 | — | 次を変更する: a previously-defined communication group for a peer domain. | — | — | S7 |
| `chcosi` | インストール・更新 | — | 次を管理する: a Common Operating System Image (COSI). | — | — | S7 |
| `chdef` | インストール・更新 | — | 次を変更する: the default value of the predefined attribute. | — | — | S7 |
| `chedition` | インストール・更新 | — | 次を許可する: query or change of the current signature file on the system. | — | — | S7 |
| `chgroup` | ユーザ・認証 | — | 次を変更する: attributes for groups. | — | — | S7 |
| `chkey` | ユーザ・認証 | To Modify the Environment or Profile File Changing the Default Language Setting: chlang [  -u UID \| Uname ] [  -m MsgTransLst \|  -M ] Langua | 次を変更する: your encrypting key. | — | — | S7 |
| `chnlspath` | 国際化 | chown [  -f ] [ -h ] [  -R ] Owner [ :Group ] { File ... \| Directory ... } chown -R  [  -f ] [ -H \| -L \| -P ] Owner [ :Group ] { File ... \| | Modify the value of the secure NLSPATH system configuration variable. | — | — | S7 |
| `chrsrc` | クラスタ・HA | — | 次を変更する: the persistent attribute values of a resource or a resource class. | — | — | S7 |
| `chsmbcred` | ネットワーク | chsmbcred -s server_name -u user_name [-p password] Description When you run the chsmbcred command, you must specify a server name and a use | 次を変更する: the password for a specific server-user entry that is stored in the /etc/smbcred file to allow | To change the password that is stored in the /etc/smbcred file for user1 to mount the SMB client file system on the xxx. | — | S7 |
| `chsubserver` | サブシステム制御 | — | 次を変更する: the contents of the /etc/inetd.conf file or similar system configuration file. | — | — | S7 |
| `chtz` | その他システム管理 | chuser [ -R load_module ] Attribute=Value ... Name Description Attention: Do not use the chuser command if you have a Network Information Se | 次を変更する: the TimeZoneInfo (TZ) environment variable in the /etc/environment file. | — | — | S7 |
| `chvfs` | ストレージ・FS | — | 次を変更する: entries in the /etc/vfs file. | To change the FileSystemHelper for the vfs entry named newvfs, enter: chvfs "newvfs:::/etc/helper/testhelper" The missin | — | S7 |
| `chvg` | ストレージ・FS | — | 次を設定する: the characteristics of a volume group (VG). | — | — | S7 |
| `ckuseracct` | API・サブルーチン | #include <login.h> int ckuseracct ( Name,  Mode,  TTY) char *Name; int Mode; char *TTY; | 次を検査する: the validity of a user account. | — | — | S3 |
| `clcmd` | クラスタ・HA | — | Takes an AIX command and distributes it to a set of nodes that are members of a cluster. | 1. To send the ps command to the oscar-test-dev1 and oscar-test-dev2 nodes in the clusterabc cluster, enter the followin | — | S7 |
| `cmp` | 一般 UNIX | — | Compares the contents of two files and reports the first character that differs. | 1. To determine whether two files are identical, enter: cmp prog.o.bak prog.o This compares prog.o.bak and prog.o. If th | — | S7 |
| `color_content` | API・サブルーチン | #include <curses.h> color_content(Color,  R, G,  B) short   Color; short  *R, * G, * B; | 次を返す: the current intensity of the red, green, and blue (RGB) components of a color. | To obtain the RGB component information for color 10 (assuming the terminal supports at least 11 colors), use:  short *r | — | S3 |
| `colrm` | 一般 UNIX | comb [  -o ] [  -s ] [  -c List \|  -p SID ] File Description The comb command writes to standard output a shell procedure that can combine s | 次を抽出する: columns from a file. | — | — | S7 |
| `cpfile` | API・サブルーチン | #include <unistd.h> int cpfile(sfd, dfd, offset, nbytesp, flags) int        sfd; int        dfd; off64_t    offset; | Optimized copy operation of contents from the source file to the destination file. | — | — | S3 |
| `crfs` | ストレージ・FS | — | 次を追加する: a file system. | — | — | S7 |
| `crvfs` | ストレージ・FS | — | 次を作成する: entries in the /etc/vfs file. | To create a new vfs entry called newvfs, enter: crvfs "newvfs:4:none:/etc/helpers/newvfshelper" This creates the newvfs | — | S7 |
| `ctags` | プログラミング | — | Makes a file of tags to help locate objects in source files. | — | — | S7 |
| `ctcasd` | デーモン | ctcasd [-b] Description The ctcasd daemon is used by the cluster security services library when the RSCT HBA security mechanism is configure | 次を提供する: and authenticates the credentials of the RSCT host-based authentication (HBA) and enhanced | — | — | S7 |
| `ctsvhbal` | ネットワーク | ctsvhbal [ [ -d \| -h \| -m \| -s ] \| [ -e msgnum[,msgnum...] ] [ -l { 1 \| 2 \| 3 \| 4 } \| -b ] Description The ctsvhbal command is a verificatio | 次を表示する: the possible identities that the local system may use to identify itself in RSCT host-based | — | — | S7 |
| `ctsvhbar` | ネットワーク | ctsvhbar [ [ -d \| -h \| -m \| -s ] \| [ -e msgnum[,msgnum...] ] [ -l { 1 \| 2 \| 3 \| 4 } \| -b ] {hostname \| address} [hostname... \| address...] D | 次を返す: the host name that the RSCT host-based authentication (HBA) security mechanism uses on the | — | — | S7 |
| `cut` | 一般 UNIX | — | Helps split the lines of a file. | — | — | S7 |
| `dadmin` | スケジューリング | — | Used to query and modify the status of the DHCP server. | — | — | S7 |
| `dbts` | その他システム管理 | — | Debugs a thin server. | 1. To debug boot a thin server named lobo that is using a common image named cosi1, enter: dbts lobo A debug boot image | — | S7 |
| `deleteX11input` | X11・GUI | delta [ -r SID ] [ -s ] [ -n ] [ -g List ] [ -p ] [ -m ModificationRequestList ] [ -y [ Comment ] ] File ... Description The delta command i | Deletes an X11 input extension record from the ODM (Object Data Manager) database. | — | — | S7 |
| `delwin` | API・サブルーチン | #include <curses.h> int delwin(WINDOW  *win); Description The delwin subroutine deletes win, freeing all memory associated with it. The appl | Deletes a window. | To delete the user-defined window my_window and its subwindow my_sub_window, enter: WINDOW *my_sub_window, *my_window; d | — | S3 |
| `devrsrv` | デバイス管理・ODM | — | Queries and breaks the single-path and persistent reservations on a device. | — | — | S7 |
| `dhcpaction` | ネットワーク | — | 次を提供する: a script that runs every time that a client updates its lease. | — | — | S7 |
| `dhcpcd6` | ネットワーク | To start a DHCPv6 client by using the System Resource Controller (SRC): startsrc -s dhcpcd6 [-a Argument] ... To start a DHCPv6 client witho | Implements a Dynamic Host Configuration Protocol for IPv6 (DHCPv6) client. Obtains IPv6 addresses and | — | — | S7 |
| `diagrpt` | 障害対応・トレース | diagsetrto [ [ -a on \| off ] [ -d on \| off ] [ -l Size ] [ -m on \| off ] [ -n Days ] [ -p on \| off ] ] | 次を表示する: previous diagnostic results. | — | — | S7 |
| `diffmk` | その他システム管理 | — | Marks differences between files. | — | — | S7 |
| `dircmp` | 一般 UNIX | — | Compares two directories and the contents of their common files. | 1. To summarize the differences between the files in two directories, type the following: dircmp proj.ver1 proj.ver2 Thi | — | S7 |
| `dirname` | API・サブルーチン | #include <libgen.h> char *dirname (path) char *path Description Given a pointer to a character string that contains a file system path name, | 次を報告する: the parent directory name of a file path name. | A simple file name and the strings "." and ".." all have "." as their return value. Input string Output string /usr/lib | — | S3 |
| `dlclose` | API・サブルーチン | #include <dlfcn.h> char *dlerror(void); | Closes and unloads a module loaded by the dlopen subroutine. | — | — | S3 |
| `dnssec-importkey` | ネットワーク | dnssec-importkey [-K directory] [-L ttl] [-P date/offset] [-P sync date/offset] [-D date/offset] [-D sync date/offset] [-h] [-v level] [-V] | Imports the domain name server key (DNSKEY) records from external systems so that the records can be | — | — | S7 |
| `dnssec-signzone` | ネットワーク | — | Domain name system security extensions (DNSSEC) zone signing tool. | — | — | S7 |
| `dnssec-verify` | ネットワーク | — | 次を検証する: the Domain name system security extensions (DNSSEC) zone. | — | — | S7 |
| `dosdir` | その他システム管理 | — | 次を一覧表示する: the directory for DOS files. | — | — | S7 |
| `dslpsearch` | ユーザ・認証 | — | 次を検索する: directory for print system objects on a System V print subsystem. | — | — | S7 |
| `dtsession` | X11・GUI | — | 次を管理する: a CDE session. | — | — | S7 |
| `du` | 一般 UNIX | — | Summarizes disk usage. | — | — | S7 |
| `dumpctrl` | 障害対応・トレース | — | 次を管理する: system dumps and live dumps. | — | — | S7 |
| `efskstoldif` | ユーザ・認証 | — | 次を印刷する: certain EFS users or groups keystore that are defined locally to stdout in ldif format. | — | — | S7 |
| `entstat` | パフォーマンス監視 | — | Shows ethernet device driver and device statistics. | — | — | S7 |
| `errctrl` | 障害対応・トレース | errctrl [ -nru ] ComponentSelector ... subcommand ... errctrl -p [ -ru ] ComponentSelector ... subcommand ... errctrl -P [ -ru ] ComponentSe | 次を変更する: or displays the error-checking attributes of system components. Persistent attribute values can | — | — | S7 |
| `errdead` | 障害対応・トレース | — | 次を抽出する: error records from a system dump or live dump. | To capture error log information from a dump image that resides in the /var/adm/ras/vmcore.0 file, enter: /usr/lib/errde | — | S7 |
| `errdemon` | 障害対応 | — | 次を起動する: error logging daemon (errdemon) and writes entries to the error log. | — | — | S7 |
| `errmsg` | 障害対応・トレース | — | 次を追加する: a message to the error log message catalog. | — | — | S7 |
| `fc` | 障害対応・トレース | — | 次を処理する: the command history list. | — | — | S7 |
| `fcteststk` | 障害対応・トレース | — | 次をテストする: for the presence of a First Failure Data Capture Error Stack environment. | — | — | S7 |
| `fmemopen` | API・サブルーチン | #include <stdio.h> FILE *fmemopen (void *restrict buf, size_t size, const char *restrict mode); Description The fmemopen subroutine associat | Opens a memory buffer stream. | — | — | S3 |
| `fmtmsg` | API・サブルーチン | #include <fmtmsg.h> int fmtmsg (long Classification, const char *Label, int Severity, cont char *Text; | 次を表示する: a message in the specified format on standard error, the console, or both. | — | — | S3 |
| `folders` | 一般 UNIX | — | 次を一覧表示する: all folders and messages in the mail directory. | — | — | S7 |
| `frcactrl` | その他システム管理 | — | 次を制御する: and configures FRCA. | — | — | S7 |
| `freehostent` | API・サブルーチン | #include <netdb.h> void freehostent (ptr) struct hostent * ptr; Description The freehostent subroutine frees any dynamic storage pointed to | To free memory allocated by getipnodebyname and getipnodebyaddr. | — | — | S3 |
| `ftok` | API・サブルーチン | #include <sys/types.h> #include <sys/ipc.h> key_t ftok ( Path,  ID) char *Path; int ID; | 次を生成する: a standard interprocess communication key. | — | — | S3 |
| `ftp` | ネットワーク | — | Transfers files between a local and a remote host. | — | — | S7 |
| `ftpd` | デーモン | — | 次を提供する: the server function for the Internet FTP protocol. | — | — | S7 |
| `fwtmp` | アカウンティング | /usr/sbin/acct/fwtmp [ -i ] [ -c ] [ -X ] [ -L ] Description The fwtmp command manipulates the accounting records by reading binary records | Manipulates connect-time accounting records by reading binary records in wtmp format from standard | 1. To convert a binary record in wtmp format to an ASCII record called dummy.file, enter: /usr/sbin/acct/fwtmp < /var/ad | — | S7 |
| `fxfer` | その他システム管理 | — | Transfers files between a local system and a host computer connected by HCON. | — | — | S7 |
| `genld` | プログラミング | genld [ -h \| -l [ -d ] ] [ -a Area ] [-u] Description For each process currently running, the genld command prints a report consisting of th | The genld command collects the list of all processes currently running on the system, and optionally | • To obtain the list of loaded objects for each running process, enter the following command: genld -l • To obtain the l | — | S7 |
| `gentun` | ネットワーク | — | 次を作成する: a tunnel definition in the tunnel database. | — | — | S7 |
| `genxlt` | プログラミング | — | 次を生成する: a code set conversion table for use by the lconv library. | — | — | S7 |
| `get_malloc_log` | API・サブルーチン | #include <malloc.h> struct malloc_log* get_malloc_log_live (addr) void *addr; Description The get_malloc_log_live subroutine provides access | Retrieves information about the malloc subsystem. | — | — | S3 |
| `getauthattrs` | API・サブルーチン | #include <usersec.h> int getauthattrs(Auth, Attributes, Count)     char *Auth;     dbattr_t *Attributes;     int Count; | Retrieves multiple authorization attributes from the authorization database. | — | — | S3 |
| `getconfattrs` | API・サブルーチン | #include <usersec.h> #include <userconf.h> int getconfattrs (Sys, Attributes, Count) char * Sys; dbattr_t * Attributes; | Accesses system information in the system information database. | — | — | S3 |
| `getprivname` | API・サブルーチン | #include <userpriv.h> #include <sys/priv.h> char *getprivname(int priv) Description The getprivname subroutine converts a given privilege bi | 次を変換する: a privilege bit into a readable string. | — | — | S3 |
| `getprocs` | API・サブルーチン | #include <procinfo.h> #include <sys/types.h>  int getprocs ( ProcessBuffer,  ProcessSize,  FileBuffer,  FileSize,  IndexPointer,  Count) str | Gets process table entries. | — | — | S3 |
| `getsubsvr` | API・サブルーチン | #include <sys/srcobj.h> #include <spc.h> int getsubsvr(  SubserverName,  SRCSubserver) char *SubserverName; struct SRCSubsvr *SRCSubserver; | 次を読み取る: a subsystem record. | — | — | S3 |
| `getsyx` | API・サブルーチン | #include <curses.h> getsyx(Y, X)  int * Y, * X; Description The getsyx subroutine retrieves the current coordinates of the virtual screen cu | Retrieves the current coordinates of the virtual screen cursor. | — | — | S3 |
| `getuinfo` | API・サブルーチン | char *getuinfo ( Name) char *Name; Description The getuinfo subroutine finds a value associated with a user. This subroutine searches a user | 次を見つける: a value associated with a user. | — | — | S3 |
| `glob` | API・サブルーチン | #include <glob.h> int glob (Pattern, Flags, (Errfunc)(), Pglob) const char  *Pattern; int  Flags; int  *Errfunc (Epath, Eerrno) | 次を生成する: path names. | — | — | S3 |
| `globfree` | API・サブルーチン | #include <glob.h> void globfree ( pglob) glob_t *pglob; Description The globfree subroutine frees any memory associated with the pglob param | Frees all memory associated with the pglob parameter. | — | — | S3 |
| `grap` | プログラミング | — | Typesets graphs to be processed by the pic command. | — | — | S7 |
| `haemunlkrm` | クラスタ・HA | — | Unlocks and starts a resource monitor. | — | — | S7 |
| `hagsns` | クラスタ・HA | — | Gets group services name server information. | — | — | S7 |
| `HBA_GetNumberOfAdapters` | API・サブルーチン | #include <sys/hbaapi.h> HBA_UINT32 HBA_GetNumberOfAdapters () Description The HBA_GetNumberOfAdapters subroutine returns the number of HBAs | 次を返す: the number of adapters discovered on the system. | — | — | S3 |
| `HBA_ScsiInquiryV2` | API・サブルーチン | — | 次を送信する: a SCSI INQUIRY command to a remote end port. | — | — | S3 |
| `HBA_SendRNIDV2` | API・サブルーチン | — | Issues an RNID ELS to another FC_Port requesting a specified Node Identification Data Format. | — | — | S3 |
| `hpmcount` | パフォーマンス監視 | — | Measures application performance. | — | — | S7 |
| `hps_dump` | 障害対応・トレース | — | Dumps contents of Network Terminal Accelerator (NTX) adapter memory to a host file. | — | — | S7 |
| `ibm5585H-T` | インストール・更新 | ibm5587G [ -FDirectory] [ -quietly] [File ...] | 次を処理する: troff command output for the IBM 5585H-T printer. | — | — | S7 |
| `imake` | プログラミング | — | C preprocessor interface to the make command. | — | — | S7 |
| `indent` | プログラミング | — | Reformats a C language program. | — | — | S7 |
| `infocmp` | その他システム管理 | — | 次を管理する: terminfo descriptions. | — | — | S7 |
| `installbsd` | その他システム管理 | — | 次をインストールする: a command (BSD version of the install command). | To install a new command called fixit, enter: installbsd  -c o mike fixit /usr/bin This command sequence installs a new | — | S7 |
| `installp` | インストール・更新 | — | 次をインストールする: available software products in a compatible installation package. | — | [NIM サーバ構築 + LPP_SOURCE 整備](08-config-procedures.md#cfg-nim-server-build)<br>[Trusted AIX 残存で AIX 7.3 マイグレーション失敗](09-incident-procedures.md#inc-trusted-aix-migration-block)<br>[Java 8 32bit SR6FP35 がロード不能](09-incident-procedures.md#inc-java-sr6fp35-load-fail)<br>[bos.net.tcp.sendmail 7.3.0.0 install 時に libcrypto エラー](09-incident-procedures.md#inc-sendmail-libcrypto-fail)<br>[rsct.vsd / rsct.lapi.rte が AIX 7.3 で install 不能](09-incident-procedures.md#inc-rsct-vsd-block)<br>[dsm.properties が migration 後に欠落](09-incident-procedures.md#inc-dsm-properties-lost)<br>[PowerSC Trusted Surveyor 残存で migration ブロック](09-incident-procedures.md#inc-powersc-ts-block) | S7 |
| `inurid` | その他システム管理 | inurid [ -q \| -r ] Description The inurid command is used to remove files stored in the inst_root directories of installed software. The nam | 次を削除する: information that is used for the installation of diskless or dataless clients and workload | — | — | S7 |
| `inusave` | その他システム管理 | inusave ListFile ProductName Description The inusave command saves the files and archived files that are listed in the file specified by the | 次を保存する: files that are installed or updated during an installation procedure. This command is used by the | — | — | S7 |
| `inutoc` | インストール・更新 | inutoc [ Directory ] Description The inutoc command creates the .toc file in Directory. If a .toc file already exists, it is recreated with | 次を作成する: a .toc file for directories that have backup format file install images. This command is used by the | 1. To create the .toc file for the /usr/sys/inst.images directory, enter: inutoc 2. To create a .toc file for the /tmp/i | — | S7 |
| `inuumsg` | その他システム管理 | inuumsg Number [ Argument1 ] [ , Argument2 ] [ , Argument3 ] [ , Argument4 ] Description The inuumsg command displays error or diagnostic me | 次を表示する: specific error or diagnostic messages provided by a software product's installation procedures. | To see error message number 3, enter: inuumsg 3 Files Item Description | — | S7 |
| `keypasswd` | その他システム管理 | — | keypasswd manages the passwords which are used to access a user's private keystore. | 1. To change the password of the default private keystore that is owned by Bob, enter: $ keypasswd where the invoker is | — | S7 |
| `keysvrmgr` | その他システム管理 | keysvrmgr action -t server_type [-h] { -a attribute=value ... } server_name Description An encryption key server is used to securely store e | 次を管理する: the Object Data Manager (ODM) database entries that are associated with the encryption key | — | — | S7 |
| `krlogind` | デーモン | — | 次を提供する: the server function for the rlogin command. | — | — | S7 |
| `krs_alloc` | API・サブルーチン | — | 次を割り当てる: a resource set and returns its handle. | — | — | S21 |
| `krs_getrad` | API・サブルーチン | — | 次を返す: a system resource allocation domain (RAD) contained in an input resource set. | — | — | S21 |
| `LAPI_Gfence` | API・サブルーチン | — | Enforces order on LAPI calls across all tasks and provides barrier synchronization among them. | — | — | S3 |
| `LAPI_Init` | API・サブルーチン | — | 次を初期化する: a LAPI context. | — | — | S3 |
| `LAPI_Rmw` | API・サブルーチン | — | 次を提供する: data synchronization primitives. | — | — | S3 |
| `LAPI_Setcntr` | API・サブルーチン | — | Used to set a counter to a specified value. | — | — | S3 |
| `LAPI_Util` | API・サブルーチン | — | Serves as a wrapper function for such data gather/scatter operations as registration and reservation, | — | — | S3 |
| `LAPI_Waitcntr` | API・サブルーチン | — | Waits until a specified counter reaches the value specified. | — | — | S3 |
| `lastcomm` | アカウンティング | — | 次を表示する: information about the last commands executed. | 1. To display information about all previously executed commands recorded in the /var/adm/pacct file, enter: lastcomm 2. | — | S8 |
| `lbxproxy` | その他システム管理 | — | Low BandWidth X proxy. | — | — | S8 |
| `ldedit` | プログラミング | — | 次を変更する: an XCOFF executable file header. | — | — | S8 |
| `ldtbread` | API・サブルーチン | #include <stdio.h> #include <ldfcn.h> int ldtbread ( ldPointer,  SymbolIndex,  Symbol) LDFILE *ldPointer; long SymbolIndex; | 次を読み取る: an indexed symbol table entry of a common object file. | — | — | S3 |
| `learn` | その他システム管理 | — | 次を提供する: computer-aided instruction for using files, editors, macros, and other features. | — | — | S8 |
| `lecstat` | その他システム管理 | lecstat [ -a -c -q -r -s -t -v ] Device_Name Description This command displays ATM LAN Emulation Client (LEC) operational information gather | 次を表示する: operational information about an Asynchronous Transfer Mode network protocol (ATM) Local | — | — | S8 |
| `listea` | API・サブルーチン | — | 次を一覧表示する: the extended attributes associated with a file. | — | — | S3 |
| `locktrace` | その他システム管理 | — | 次を制御する: kernel lock tracing. | 1. To start tracing the SEM_LOCK_CLASS, enter the following command: locktrace -s SEM_LOCK_CLASS 2. To stop all lock tra | — | S8 |
| `loginfailed` | API・サブルーチン | #include <usersec.h> int loginfailed ( User,  Host,  Tty, Reason) char *User; char *Host; char *Tty; | Records an unsuccessful login attempt. | — | — | S3 |
| `lpar_set_resources` | API・サブルーチン | #include  <sys/dr.h> int lpar_set_resources ( lpar_resource_id,lpar_resource ) int lpar_resource_id; void *lpar_resource; Description | 次を変更する: the calling partition's characteristics. | — | — | S3 |
| `lphistory` | 印刷 | • To list a particular number of previously-issued commands: – On the local node: lphistory [ -u user_ID ] [ -m mapped_ID ] [ -C command_nam | 次を表示する: or clears the history list of least-privilege (LP) commands that have been run during the current | — | — | S8 |
| `lsCCadmin` | その他システム管理 | To Display Specific Data on all Systems lscfg [ -v ] [ -p ] [ -s ] [ -l Name ] Description If you run the lscfg command without any flags, i | 次を表示する: the name of the current Common Criteria enabled System Administrative Host. | — | — | S8 |
| `lsdom` | その他システム管理 | — | 次を表示する: domain attributes. | — | — | S8 |
| `lslpcmd` | その他システム管理 | — | 次を一覧表示する: information about the least-privilege (LP) resources on one or more nodes in a domain. | — | — | S8 |
| `lslprsacl` | その他システム管理 | — | 次を表示する: the access controls for the least-privilege (LP) Resource Shared ACL. | — | — | S8 |
| `lslv` | ストレージ・FS | — | 次を表示する: information about a logical volume. | — | [インストール時 hd5 拡張失敗の切り分け](09-incident-procedures.md#inc-install-hd5-fail) | S8 |
| `lssensor` | その他システム管理 | lssensor [-m] [ -a \| -n host1[,host2…] \| -N { node_file "–" } ] [ -l \| -t \| -d \| -D delimiter ] [-x] [-h] [ -v \| -V ] [ -A \| sensor_name1 [ | 次を表示する: information about sensors and microsensors that are defined to the resource monitoring and | — | — | S8 |
| `lsvg` | ストレージ・FS | — | 次を表示する: information about volume groups. | — | [インストール時 hd5 拡張失敗の切り分け](09-incident-procedures.md#inc-install-hd5-fail) | S8 |
| `lvm_querylv` | API・サブルーチン | #include <lvm.h> int lvm_querylv ( LV_ID,  QueryLV,  PVName) struct lv_id *LV_ID; struct querylv **QueryLV; char *PVName; | Queries a logical volume and returns all pertinent information. | — | — | S3 |
| `lvmo` | その他システム管理 | — | 次を管理する: lvm pbuf tunable parameters. | — | — | S8 |
| `lvupdateInit` | その他システム管理 | To add an entry to the /etc/inittab file in the surrogate partition, use the following syntax: lvupdateInit -a [-i Identifier] { [ Identifie | 次を管理する: the list of entries to be added to the /etc/inittab file that is used to start the surrogate | — | — | S8 |
| `lvupdateSafeKE` | その他システム管理 | lvupdateSafeKE  [ -a kext_path [-p] \| -r kext_path \| -l ] Description During a Live Update operation, a new logical partition (LPAR) is dyna | The lvupdateSafeKE command is a utility that manipulates the list of safe kernel extensions for the AIX | — | — | S8 |
| `macref` | プログラミング | — | Produces a cross-reference listing of macro files. | — | — | S8 |
| `mark` | プログラミング | — | Creates, modifies, and displays message sequences. | — | — | S8 |
| `mhmail` | ネットワーク | — | 次を送信する: or receives mail. | 1. To receive new mail and file it into the default mail folder, $USER/Mail/inbox, enter: mhmail The system displays a m | — | S8 |
| `MIO_close` | API・サブルーチン | #include <libmio.h> int MIO_close (FileDescriptor) int FileDescriptor; Description This subroutine is an entry point of the MIO library. Use | Close a file descriptor through the MIO library. | — | — | S3 |
| `mkcifsmnt` | ネットワーク | — | 次を追加する: a CIFS mount to the /etc/filesystems file and performs the mount. | — | — | S8 |
| `mkcimreg` | その他システム管理 | To register a class: mkcimreg [-I include_directory...] [-f] [-h] definition_file... To register a provider: mkcimreg [-I include_directory. | Registers Common Information Model (CIM) classes and Common Manageability Programming Interface | — | — | S8 |
| `mkitab` | インストール・更新 | — | Makes records in the /etc/inittab file. | — | — | S8 |
| `mkramdisk` | ストレージ・FS | — | 次を作成する: a RAM disk using a portion of RAM that is accessed through normal reads and writes. | — | — | S8 |
| `mksecldap` | ユーザ・認証 | To set up a server mksecldap -s -a adminDN -p adminpasswd -S schematype [ -d baseDN ] [ -n port ] [ -k  SSLkeypath ] [ -w SSLkeypasswd ] [ - | 次を設定する: up an AIX system as a Lightweight Directory Access Protocol (LDAP) server or client for security | — | [LDAP クライアント設定（AIX 7.3 TL3 SP1 拡張フィールド対応）](08-config-procedures.md#cfg-ldap-client) | S8 |
| `mkwpar` | WPAR・仮想化 | — | 次を作成する: a system workload partition (WPAR), or a WPAR specification file. | — | [WPAR 作成 + WLM クラス連携](08-config-procedures.md#cfg-wpar-create) | S8 |
| `mprotect` | API・サブルーチン | #include <sys/types.h> #include <sys/mman.h> int mprotect ( addr,  len,  prot) void *addr; size_t len; | 次を変更する: access protections for memory mapping or shared memory. | — | — | S3 |
| `mq_open` | API・サブルーチン | #include <mqueue.h> mqd_t mq_open (name, oflag [mode, attr]) const char *name; int oflag; mode_t mode; | Opens a message queue. | — | — | S3 |
| `mq_setattr` | API・サブルーチン | #include <mqueue.h> int mq_setattr (mqdes, mqstat, omqstat) mqd_t mqdes; const struct mq_attr *mqstat; struct mq_attr *omqstat; | 次を設定する: message queue attributes. | — | — | S3 |
| `mrouted` | デーモン | — | Forwards a multicast datagram. | — | — | S8 |
| `mvdir` | プログラミング | — | 次を移動する: (renames) a directory. | To rename or move a directory to another location, enter: mvdir appendixes manual If manual does not exist, this renames | — | S8 |
| `nanosleep` | API・サブルーチン | #include <time.h> int nanosleep (rqtp, rmtp) const struct timespec *rqtp; struct timespec *rmtp; Description | Causes the current thread to be suspended from execution. | — | — | S3 |
| `ndpd-host` | デーモン | — | Neighbor Discovery Protocol (NDP) daemon for a host. | — | — | S8 |
| `netrule` | その他システム管理 | — | Adds, removes, lists, or queries rules, flags and security labels for interfaces and hosts. | — | — | S8 |
| `newaliases` | ネットワーク | newform [ -s ] [ -f ] [ -a [ Number ] ] [ -b [ Number ] ] [ -c [ Character ] ] [ -e [ Number ] ] [ -i [ TabSpec ] ] [ -l [ Number ] ] [ -o [ | 次をビルドする: a new copy of the alias database from the mail aliases file. | — | — | S8 |
| `newpass` | API・サブルーチン | #include <usersec.h> #include <userpw.h> char *newpass( Password) struct userpw *Password; Description | 次を生成する: a new password for a user. | — | — | S3 |
| `newterm` | API・サブルーチン | #include <curses.h> SCREEN *newterm(  Type,   OutFile, InFile) char *Type; | 次を初期化する: curses and its data structures for a specified terminal. | 1. To initialize curses on a terminal represented by the lft device file as both the input and output terminal, open the | — | S3 |
| `nfs.clean` | ネットワーク | — | 次を停止する: NFS and NIS operations. | 1. To stop all NFS and NIS daemons, type: /etc/nfs.clean 2. To stop only NFS, type: /etc/nfs.clean -t nfs 3. To stop onl | — | S8 |
| `nfs4cl` | パフォーマンス監視 | — | 次を表示する: or modifies current NFSv4 statistics and properties. | — | — | S8 |
| `nfso` | パフォーマンス監視 | — | 次を管理する: the tuning parameters of the Network File System (NFS). | — | — | S8 |
| `nimadapters` | インストール・更新 | — | 次を定義する: Network Installation Management (NIM) secondary adapter definitions from a stanza file. | — | — | S8 |
| `nimadm` | インストール・更新 | Perform alternate disk migration nimadm -l lpp_source -c NIMClient -s SPOT -d TargetDisks [ -a PreMigrationScript ] [ -b  installp_bundle] [ | The nimadm (Network Installation Manager alternate disk migration) command is a utility that allows the | — | — | S8 |
| `nmon` | プログラミング | — | 次を表示する: local system statistics in interactive mode and records system statistics in recording mode. | — | — | S8 |
| `nohup` | パフォーマンス監視 | — | 次を実行する: a command without hangups. | 1. To run a command in the background after you log off, enter: $ nohup find / -print & After you enter this command, th | — | S8 |
| `nslookup` | その他システム管理 | — | Queries the internet Domain Name System (DNS) interactively. | — | [BIND 9.18 移行後に dnssec ツールが見つからない](09-incident-procedures.md#inc-bind-918-tools-missing) | S8 |
| `odm_unlock` | API・サブルーチン | #include <odmi.h> int odm_unlock ( LockID) int LockID; Description The odm_unlock subroutine releases a previously granted lock on a path na | Releases a lock put on a path name. | — | — | S3 |
| `odmshow` | デバイス管理・ODM | /usr/bin/on [ -i ] [ -d ] [ -n ] Host Command [ Argument ... ] Description The on command executes commands on other systems in an environme | 次を表示する: an object class definition on the screen. | — | — | S8 |
| `OS_install` | インストール・更新 | — | 次を実行する: network installation operations on OS_install objects. | — | — | S8 |
| `pagesize` | 一般 UNIX | — | 次を表示する: the system page size. | 1. To obtain the size system page, enter: pagesize The system returns the number of bytes, such as 4096. 2. To print the | — | S8 |
| `paginit` | その他システム管理 | — | 次を認証する: a user and create a PAG association. | paginit -R FPKI  The user is authenticated using the registry FPKI, which is defined in the /usr/lib/security/methods.cf | — | S8 |
| `pam_chauthtok` | API・サブルーチン | #include <security/pam_appl.h> int pam_chauthtok (PAMHandle, Flags) pam_handle_t *PAMHandle; int Flags; Description | 次を変更する: the user's authentication token (typically passwords). | — | — | S3 |
| `Parameter` | その他システム管理 | — | ip6srcrouteforward | — | — | S32 |
| `passwdexpired` | API・サブルーチン | — | 次を検査する: the user's password to determine whether it is expired. | — | — | S3 |
| `pause` | API・サブルーチン | #include <unistd.h> int pause (void) Description The pause subroutine suspends the calling process until it receives a signal. The signal mu | Suspends a process until a signal is received. | — | — | S3 |
| `pcap_datalink` | API・サブルーチン | #include <pcap.h> int pcap_datalink(pcap_t * p); Description The pcap_datalink subroutine returns the link layer type of the packet capture | Obtains the link layer type (data link type) for the packet capture device. | — | — | S3 |
| `pcap_open_live` | API・サブルーチン | #include <pcap.h> pcap_t *pcap_open_live( const char * device, const int snaplen, const int promisc, const int to_ms, char * ebuf); Descript | Opens a network device for packet capture. | — | — | S3 |
| `pdmode` | その他システム管理 | — | Invokes a command in the virtual or real partitioned, directory-access mode. | 1. To get the partitioned directory access mode, enter: pdmode 2. To run the ls command in the virtual mode, enter: pdmo | — | S8 |
| `penable` | その他システム管理 | — | 次を有効化する: or reports the availability of login ports. | To enable all normal ports listed in the /etc/inittab file, enter: penable -a Files Table 117. Files Item | — | S8 |
| `perfstat_cpu_total` | API・サブルーチン | #include <libperfstat.h> int perfstat_cpu_total (name, userbuff, sizeof_struct, desired_number) perfstat_id_t *name; perfstat_cpu_total_t *u | Retrieves global processor usage statistics. | — | — | S3 |
| `perfstat_fcstat` | API・サブルーチン | #include <libperfstat.h> int perfstat_fcstat (name, userbuff, sizeof_struct, desired_number) perfstat_id_t *name; perfstat_fcstat_t *userbuf | Retrieves the statistics of a Fibre Channel (FC) adapter. | — | — | S3 |
| `perfstat_memory_page` | API・サブルーチン | #include <libperfstat.h> int perfstat_memory_page ( psize, userbuff, sizeof_userbuff, desired_number ) perfstat_psize_t *psize; perfstat_mem | Retrieves usage statistics for multiple page sizes. | — | — | S3 |
| `perfstat_memory_page_wpar` | API・サブルーチン | #include <libperfstat.h> int perfstat_memory_page_wpar ( name, psize, userbuff, sizeof_userbuff, desired_number ) perfstat_id_wpar_t *name; | Retrieves use statistics for multiple page size for workload partitions (WPAR) | — | — | S3 |
| `perfstat_node_list` | API・サブルーチン | #include <libperfstat.h> int perfstat_node_list  ( name, userbuff, sizeof_userbuff, desired_number) perfstat_id_node_t *name; perfstat_node_ | Retrieves the list of nodes in a cluster. | — | — | S3 |
| `perfstat_ssp_ext` | API・サブルーチン | #include <libperfstat.h> int perfstat_ssp_ext (name, userbuff, sizeof_struct, desired_number, ssp_flag) perfstat_ssp_id_t * name; perfstat_s | Retrieves the tier, failure group, physical volume, and node data that are associated with shared storage | — | — | S3 |
| `perfstat_virtualdisktarget` | API・サブルーチン | #include <libperfstat.h> int perfstat_virtualdisktarget (name, userbuff, sizeof_struct, desired_number) perfstat_id_t * name; perfstat_disk_ | Retrieves the Virtual Target Device (VTD) usage statistics in Virtual I/O Server (VIOS). | — | — | S3 |
| `phold` | その他システム管理 | — | 次を無効化する: or reports the availability of login ports on hold. | To list the ports that are on hold, enter: phold Files Table 121. Files Item | — | S8 |
| `ping` | ネットワーク | — | 次を送信する: an ECHO_REQUEST to a network host. | — | — | S8 |
| `pioburst` | その他システム管理 | — | 次を生成する: burst pages (header and trailer pages) for printer output. | — | — | S8 |
| `pioout` | その他システム管理 | — | Printer backend's device driver interface program. | — | — | S8 |
| `pkgchk` | その他システム管理 | — | 次を検査する: the accuracy of an installation. | — | — | S8 |
| `pkginfo` | その他システム管理 | — | 次を表示する: software package and/or set information. | — | — | S8 |
| `pksctl` | セキュリティ | — | 次を実行する: administrative operations on the user-space Platform keystore (PKS) framework. | — | [rootvg の暗号化構築（PKS + passphrase）](08-config-procedures.md#cfg-encrypt-rootvg) | S8 |
| `plock` | API・サブルーチン | #include <sys/lock.h> int plock ( Operation) int Operation; Description The plock subroutine allows the calling process to lock or unlock it | Locks the process, text, or data in memory. | — | — | S3 |
| `pm_clear_ebb_handler` | API・サブルーチン | #include <pmapi.h> int pm_clear_ebb_handler (void ** old_handler, void ** old_data_area) Description The pm_clear_ebb_handler subroutine cle | Clears the Event-Based Branching (EBB) facility configured for the calling thread. | — | — | S3 |
| `pm_enable_bhrb` | API・サブルーチン | #include <pmapi.h> int pm_enable_bhrb (pm_bhrb_ifm_t ifm_mode) Description The pm_enable_bhrb subroutine enables the BHRB instructions such | 次を有効化する: all Branch History Rolling Buffer (BHRB) related instructions such as clrbhrb and mfbhrb in the | — | — | S3 |
| `pm_get_program_pthread` | API・サブルーチン | #include <pmapi.h>   int pm_set_program_pthread ( pid,  tid,  ptid,  *prog)  pid_t pid;  tid_t tid; ptid_t ptid; | Retrieves the Performance Monitor settings for a target pthread. | — | — | S3 |
| `pm_get_wplist` | API・サブルーチン | #include <pmapi.h>int pm_get_wplist (*name, *wp_list, *size) const char *name;  pm_wpar_ctx_info_t *wp_list;  int *size; Description | Retrieves the list of available workload partition contexts for Performance Monitoring. | — | — | S3 |
| `pm_set_program_pgroup` | API・サブルーチン | #include <pmapi.h>   int pm_set_program_pgroup ( pid,  tid,  ptid,  *prog)  pid_t pid;  tid_t tid; ptid_t ptid; | 次を設定する: Performance Monitor programmation for a target pthread and creates a counting group. | — | — | S3 |
| `pm_set_program_pthread` | API・サブルーチン | #include <pmapi.h>   int pm_set_program_pthread ( pid,  tid,  ptid,  *prog)  pid_t pid;  tid_t tid; ptid_t ptid; | 次を設定する: Performance Monitor programmation for a target pthread. | — | — | S3 |
| `pm_set_program_thread` | API・サブルーチン | #include <pmapi.h>   int pm_set_program_thread ( pid,  tid,  *prog)  pid_t pid;  tid_t tid;  pm_prog_t *prog; | 次を設定する: Performance Monitor programmation for a target thread. | — | — | S3 |
| `pmc_read_1to4` | API・サブルーチン | #include <pmapi.h> int pmc_read_1to4 (void * buffer) Description The pmc_read_1to4 subroutine reads the registers PMC 1 to PMC 4 into the ad | 次を読み取る: the performance monitoring counters (PMC) registers PMC 1 to PMC 4 in problem state. | — | — | S3 |
| `pmtu` | その他システム管理 | — | 次を表示する: and deletes Path MTU discovery related information. | 1. To display Ipv4 pmtu entries, type: pmtu display The output looks similar to the following: | — | S8 |
| `posix_trace_attr_getmaxdatasize` | API・サブルーチン | #include <sys/types.h> #include <trace.h> int posix_trace_attr_getmaxdatasize(attr, maxdatasize) const trace_attr_t *restrict attr; size_t * | Retrieves the maximum user trace event data size. | — | — | S3 |
| `posix_trace_attr_setstreamfullpolicy` | API・サブルーチン | #include <trace.h> int posix_trace_attr_setstreamfullpolicy(attr,streampolicy) const trace_attr_t *attr; int *streampolicy; Description | 次を設定する: the stream full policy. | — | — | S3 |
| `posix_trace_eventid_equal` | API・サブルーチン | #include <trace.h> int posix_trace_eventid_equal(trid, event1, event2) trace_id_t trid; trace_event_id_t event1; trace_event_id_t event2; | Compares two trace event type identifiers. | — | — | S3 |
| `posix_trace_get_attr` | API・サブルーチン | #include <trace.h> int posix_trace_get_attr(trid, attr) trace_id_t trid; trace_attr_t *attr; Description | Retrieve trace attributes. | — | — | S3 |
| `posix_trace_get_filter` | API・サブルーチン | #include <trace.h> int posix_trace_get_filter(trid, set) trace_id_t trid; trace_event_set_t *set; Description | Retrieves the filter of an initialized trace stream. | — | — | S3 |
| `posix_trace_get_status` | API・サブルーチン | #include <trace.h> int posix_trace_get_status(trid, statusinfo) trace_id_t trid; struct posix_trace_status_info *statusinfo; Description | Retrieves trace attributes or trace status. | — | — | S3 |
| `prctmp` | その他システム管理 | /usr/sbin/acct/prdaily [ -X ] [  -l ] [ mmdd ] [  -c ] Description The prdaily command is called by the runacct command to format an ASCII r | 次を表示する: the session record files. | — | — | S8 |
| `priv_clrall` | API・サブルーチン | #include <userpriv.h> #include <sys/priv.h> void priv_clrall(privg_t pv) Description The priv_clrall subroutine removes all of the privilege | 次を削除する: all of the privilege bits from the privilege set. | — | — | S3 |
| `priv_isnull` | API・サブルーチン | #include <userpriv.h> #include <sys/priv.h> int priv_isnull(privg_t pv) Description The priv_isnull subroutine determines whether the privil | 次の値・状態を決定する: if a privilege set is empty. | — | — | S3 |
| `privbit_clr` | API・サブルーチン | #include <userpriv.h> #include <sys/priv.h> void privbit_clr(privg_t pv, int priv) Description The privbit_clr subroutine removes the privil | 次を削除する: a privilege from a privilege set. | — | — | S3 |
| `proc_mobility_base_set` | API・サブルーチン | #include <sys/mobility.h> int  proc_mobility_base_set (pid , flag), pid_t pid; int flag; Description | 次を設定する: or unsets attributes used by AIX Live Update to indicate that the current process is a base process. | — | — | S3 |
| `proctree` | その他システム管理 | — | 次を印刷する: the process tree containing the specified process IDs or users. | — | — | S8 |
| `projdbfinit` | API・サブルーチン | <sys/aacct.h> projdbfinit(void *handle, char *file, int mode) Description The projdbfinit subroutine sets the specified handle to use the sp | 次を設定する: the handle to use a local project database as specified in the dbfile pointer and opens the file with | — | — | S3 |
| `ps` | その他システム管理 | X/Open Standards ps [ -A ] [ -M ] [ -N ] [ -Z ] [ -a ] [ -d ] [ -e ] [ -f ] [ -k ] [ -l ] [ -F format] [ -o  Format ] [ -c Clist ] [ -G Glis | Shows status of processes. This document describes the standard AIX ps command and the System V | — | — | S8 |
| `ps4014` | その他システム管理 | — | 次を変換する: a Tektronix 4014 file to PostScript format. | — | — | S8 |
| `ps630` | その他システム管理 | — | 次を変換する: Diablo 630 print files to PostScript format. | — | — | S8 |
| `psdanger` | API・サブルーチン | # include <signal.h> void psignal ( Signal,  String) int Signal; const char *String; void psiginfo ( Info,  String) | 次を定義する: the amount of free paging space available. | — | — | S3 |
| `pthread_barrier_wait` | API・サブルーチン | — | 次を同期する: threads at a barrier. | — | — | S3 |
| `pthread_cancel` | API・サブルーチン | #include <pthread.h> int pthread_cancel (thread) pthread_t thread; Description The pthread_cancel subroutine requests the cancellation of th | Requests the cancellation of a thread. | — | — | S3 |
| `pthread_condattr_getpshared` | API・サブルーチン | #include <pthread.h> int pthread_condattr_getpshared (attr, pshared) const pthread_condattr_t *attr; int *pshared; Description | 次を返す: the value of the pshared attribute of a condition attributes object. | — | — | S3 |
| `pthread_condattr_setpshared` | API・サブルーチン | #include <pthread.h> int pthread_condattr_setpshared (attr, pshared) pthread_condattr_t *attr; int pshared; Description | 次を設定する: the value of the pshared attribute of a condition attributes object. | — | — | S3 |
| `pthread_create` | API・サブルーチン | #include <pthread.h> int pthread_create (thread, attr, start_routine (void *), arg) pthread_t *thread; const pthread_attr_t *attr; void *(*s | 次を作成する: a new thread, initializes its attributes, and makes it runnable. | — | — | S3 |
| `pthread_getrusage_np` | API・サブルーチン | #include <pthread.h> int pthread_getrusage_np (Ptid, RUsage, Mode) pthread_t Ptid; struct rusage *RUsage; int Mode; | 次を有効化する: or disable pthread library resource collection, and retrieve resource information for any pthread in | — | — | S3 |
| `pthread_mutexattr_setkind_np` | API・サブルーチン | #include <pthread.h> int pthread_mutexattr_setkind_np ( attr,  kind) pthread_mutexattr_t *attr; int  kind; Description | 次を設定する: the value of the kind attribute of a mutex attributes object. | — | — | S3 |
| `pthread_rwlock_unlock` | API・サブルーチン | #include <pthread.h> int pthread_rwlock_unlock (rwlock) pthread_rwlock_t *rwlock; Description The pthread_rwlock_unlock subroutine is called | Unlocks a read-write lock object. | — | — | S3 |
| `ptpd` | デーモン | — | 次を起動する: the Precision Time Protocol (1588-2008) daemon (ptpd). | — | — | S8 |
| `qosadd` | その他システム管理 | — | 次を追加する: a QoS (Quality of Service) Service Category or Policy Rule. | — | — | S8 |
| `qosstat` | その他システム管理 | — | Show Quality of Service (QoS) status. | 1. qosstat Policy Rule handle 1: Filter specification for rule index 1:         PolicyRulePriority:                    0 | — | S8 |
| `qprt` | 印刷 | — | 次を起動する: a print job. | — | — | S8 |
| `qstatus` | 印刷 | — | 次を提供する: printer status for the print spooling system. | — | — | S8 |
| `quick_exit` | API・サブルーチン | #include <stdlib.h> _Noreturn void quick_exit(int status); Description The quick_exit subroutine causes normal program termination to occur. | This subroutine causes normal program termination to occur without completely cleaning the resources. | — | — | S3 |
| `quot` | その他システム管理 | — | Summarizes file system ownership. | 1. To display the number of files and bytes owned by each user in the /usr file system, enter: quot -f /usr | — | S8 |
| `rc.powerfail` | その他システム管理 | rc.powerfail [ -h ] \| [ [ -s ] [ -t [ mm ] ][-c [ ss ] ] ] Description The rc.powerfail command is started by the /etc/inittab file when ini | Handles RPA (RS/6000 Platform Architecture) specific EPOW (Environmental and POwer Warning) events | 1 These types of errors are considered non-critical cooling problems by the Operating System. rc.powerfail warns the use | — | S9 |
| `refrsrc` | クラスタ・HA | — | Refreshes the resources within the specified resource class. | — | — | S9 |
| `refsensor` | クラスタ・HA | — | Refreshes a sensor or a microsensor defined to the resource monitoring and control (RMC) subsystem. | — | — | S9 |
| `removevsd` | その他システム管理 | — | 次を削除する: a set of virtual shared disks. | To unconfigure and remove all defined virtual shared disks in a system or system partition, enter: removevsd -a -f | — | S9 |
| `replacepv` | その他システム管理 | — | Replaces a physical volume in a volume group with another physical volume. | 1. To replace physical partitions from hdisk1 to hdisk6, enter: | — | S9 |
| `rexecd` | デーモン | — | 次を提供する: the server function for the rexec command. | — | — | S9 |
| `rm` | 一般 UNIX | — | 次を削除する: (unlinks) files or directories. | — | — | S9 |
| `rmcondresp` | その他システム管理 | — | Deletes the link between a condition and one or more responses. | — | — | S9 |
| `rmdom` | その他システム管理 | — | 次を削除する: the domains from the domain database. | To remove the hrdom domain, type: rmdom hrdom rmf Command Purpose Removes folders and the messages they contain. | — | S9 |
| `rmiscsi` | その他システム管理 | — | 次を削除する: iSCSI target data. | — | — | S9 |
| `rmm` | その他システム管理 | — | 次を削除する: messages from active status. | — | — | S9 |
| `rmnfsmnt` | その他システム管理 | — | 次を削除する: an NFS mount. | 1. To unmount a file system, enter: rmnfsmnt -f /usr/man -N In this example, the /usr/man file system is unmounted. 2. T | — | S9 |
| `rmproj` | API・サブルーチン | <sys/aacct.h> rmproj(struct project *, int flag) Description The rmproj subroutine removes the definition of a project from kernel project r | 次を削除する: project definition from kernel project registry. | — | — | S3 |
| `rmprojdb` | API・サブルーチン | <sys/aacct.h> rmprojdb(void *handle, struct project *project, int flag) Description The rmprojdb subroutine removes the project definition s | 次を削除する: the specified project definition from the specified project database. | — | — | S3 |
| `rmrpdomain` | クラスタ・HA | — | 次を削除する: a peer domain that has already been defined. | — | — | S9 |
| `rmserver` | その他システム管理 | rmsmbcmnt -f MountPoint [-B \| -N \| -I] Description The rmsmbcmnt command removes an SMB client file system entry from the /etc/filesystems f | 次を削除する: a subserver definition from the Subserver Type object class. | — | — | S9 |
| `rmts` | その他システム管理 | — | 次を削除する: a thin server. | 1. To remove a thin server named lobo, enter: rmts lobo  Location /usr/sbin/rmts Files | — | S9 |
| `rmtun` | その他システム管理 | rmusil -R RelocatePath -r Description The rmusil command removes an existing USIL instance. | 次を無効化する: operational tunnel(s) and optionally removes tunnel definition(s). | — | — | S9 |
| `rmvirprt` | その他システム管理 | — | 次を削除する: a virtual printer. | To remove the attribute values for the mypro virtual printer associated with the proq print queue, type: rmvirprt  -d my | — | S9 |
| `rrestore` | その他システム管理 | — | 次をコピーする: previously backed up file systems from a remote machine's device to the local machine. | — | — | S9 |
| `rs_info` | API・サブルーチン | #include <sys/rset.h> long rs_info(void *out, long command, long arg1, long arg2) Description The rs_info subroutine returns affinity system | Retrieves system affinity information. | — | — | S3 |
| `rs_setpartition` | API・サブルーチン | include <sys/rset.h> int rs_setpartition(pid, rset, flags) pid_t pid; rsethandle_t rset; unsigned int flags; | 次を設定する: the partition resource set of a process. | — | — | S3 |
| `rtl_enable` | その他システム管理 | — | Relinks shared objects to enable the runtime linker to use them. | — | — | S9 |
| `rusers` | その他システム管理 | — | 次を報告する: a list of users logged on to remote machines. | 1. To produce a list of the users on your network that are logged in remote machines, enter: rusers 2. To produce a list | — | S9 |
| `sccs` | 一般 UNIX | — | Administration program for SCCS commands. | — | — | S9 |
| `sched_setscheduler` | API・サブルーチン | #include <sched.h> int sched_setscheduler (pid, policy, param) pid_t pid; int policy; const struct sched_param *param; | 次を設定する: the scheduling policy and parameters. | — | — | S3 |
| `sec_getsyslab` | API・サブルーチン | #include <sys/mac.h> int sec_getsyslab (minsl, maxsl, mintl, maxtl) sl_t *minsl; sl_t *maxsl; tl_t *mintl; | Gets the system sensitivity and integrity labels. | — | — | S3 |
| `sec_setmsglab` | API・サブルーチン | #include <sys/mac.h> #include <sys/ipc.h> #include <sys/msg.h> int sec_setmsglab (msgid, sl, tl) int msgid; | 次を設定する: the security attributes of an Interprocess Communication (IPC) message queue. | — | — | S3 |
| `sec_setsemlab` | API・サブルーチン | #include <sys/mac.h> #include <sys/ipc.h> #include <sys/sem.h> int sec_setsemlab (semid, sl, tl) int semid; | 次を設定する: the security attributes for a semaphore. | — | — | S3 |
| `sectoldif` | ユーザ・認証 | — | 次を印刷する: users and groups defined locally to stdout in ldif format. | 1. To print all users and groups defined locally, enter the following: sectoldif -d cn=aixsecdb,cn=aixdata -S rfc2307aix | — | S9 |
| `sem_destroy` | API・サブルーチン | #include <semaphore.h> int sem_destroy (sem) sem_t *sem; Description The sem_destroy subroutine destroys the unnamed semaphore indicated by | Destroys an unnamed semaphore. | — | — | S3 |
| `sem_open` | API・サブルーチン | #include <semaphore.h> sem_t * sem_open (const char *name, int oflag, mode_t mode, unsigned value) Description The sem_open subroutine estab | 次を初期化する: and opens a named semaphore. | — | — | S3 |
| `setcsmap` | API・サブルーチン | #include <sys/termios.h> int setcsmap (Path); char * Path; Description The setcsmap subroutine reads in a code-set map file. The path parame | 次を読み取る: a code-set map file and assigns it to the standard input device. | — | — | S3 |
| `setea` | API・サブルーチン | — | 次を設定する: an extended attribute value. | — | — | S3 |
| `setpenv` | API・サブルーチン | #include <usersec.h> int setpenv ( User,  Mode,  Environment,  Command) char *User; int Mode; char **Environment; char *Command; Description | 次を設定する: the current process environment. | — | — | S3 |
| `setuname` | 一般 UNIX | — | 次を設定する: the node name of the system. | 1. To temporarily change the node name to "orion", enter: setuname -t -n orion 2. To permanently change the node name to | — | S9 |
| `sh` | 一般 UNIX | shconf -d shconf -R -l Name shconf {-D [-O ] \| -E [-O ]} [-H] -l Name shconf -l Name [-a Attribute=Value] ... Description | Invokes the default shell. | — | — | S9 |
| `shell` | 一般 UNIX | — | 次を実行する: a shell with the user's default credentials and environment. | To re-initialize your session to your default credentials and environment after using the trusted shell (tsh), enter: sh | — | S9 |
| `shm_open` | API・サブルーチン | #include <sys/mman.h> int shm_open (name, oflag, mode) const char *name; int oflag; mode_t mode; | Opens a shared memory object. | — | — | S3 |
| `sigstack` | API・サブルーチン | #include <signal.h>   int sigstack ( InStack,  OutStack) struct sigstack *InStack, *OutStack; Description | 次を設定する: and gets signal stack context. | — | — | S3 |
| `snmptrap` | その他システム管理 | — | 次を生成する: a notification (trap) to report an event to the SNMP manager with the specified message. | 1. To send a trap with the message 'hello world' to the SNMP agent running on the local host, enter the following: | — | S9 |
| `SpmiDdsDelCx` | API・サブルーチン | #include sys/Spmidef.h int SpmiDdsDelCx(Area) char *Area; Description The SpmiDdsDelCx subroutine informs the SPMI that a previously added, | Deletes a volatile context. | — | — | S3 |
| `SpmiExit` | API・サブルーチン | #include sys/Spmidef.h void SpmiExit() Description A successful “SpmiInit Subroutine” on page 2019 or “SpmiDdsInit Subroutine” on page 2003 | 次を終了する: a dynamic data supplier (DDS) or local data consumer program's association with the SPMI, | — | — | S3 |
| `SpmiGetStat` | API・サブルーチン | #include sys/Spmidef.h struct SpmiStat *SpmiGetStat(StatHandle) SpmiStatHdl StatHandle; Description The SpmiGetStat subroutine returns a poi | 次を返す: a pointer to the SpmiStat structure corresponding to a specified statistic handle. | — | — | S3 |
| `SpmiGetStatSet` | API・サブルーチン | #include sys/Spmidef.h int SpmiGetStatSet(StatSet, Force); struct SpmiStatSet *StatSet; boolean Force; Description | Requests the SPMI to read the data values for all statistics belonging to a specified set. | — | — | S3 |
| `SpmiInstantiate` | API・サブルーチン | #include sys/Spmidef.h int SpmiInstantiate(CxHandle) SpmiCxHdl CxHandle; Description The SpmiInstantiate subroutine explicitly instantiates | Explicitly instantiates the subcontexts of an instantiable context. | — | — | S3 |
| `SpmiNextCx` | API・サブルーチン | #include sys/Spmidef.h struct SpmiCxLink *SpmiNextCx(CxLink )struct SpmiCxLink *CxLink; Description The SpmiNextCx subroutine locates the ne | Locates the next subcontext of a context. | — | — | S3 |
| `SpmiNextHot` | API・サブルーチン | #include sys/Spmidef.h struct SpmiHotVals *SpmiNextHot(HotSet, HotVals) struct SpmiHotSet *HotSet; struct SpmiHotVals *HotVals; Description | Locates the next set of peer statistics SpmiHotVals belonging to an SpmiHotSet. | — | — | S3 |
| `SpmiNextValue` | API・サブルーチン | #include sys/Spmidef.h struct SpmiStatVals*SpmiNextValue( StatSet, StatVal, value) struct SpmiStatSet *StatSet; struct SpmiStatVals *StatVal | 次を返す: either the first SpmiStatVals structure in a set of statistics or the next SpmiStatVals structure in | — | — | S3 |
| `SpmiPathAddSetStat` | API・サブルーチン | #include sys/Spmidef.h struct SpmiStatVals *SpmiPathAddSetStat(StatSet, StatName, Parent) struct SpmiStatSet *StatSet; char *StatName; | 次を追加する: a statistics value to a set of statistics. | — | — | S3 |
| `srcsrqt` | API・サブルーチン | #include <spc.h> srcsrqt(Host, SubsystemName, SubsystemPID, RequestLength, SubsystemRequest, ReplyLength, ReplyBuffer, StartItAlso,  Continu | 次を送信する: a request to a subsystem. | — | — | S3 |
| `srcstat_r` | API・サブルーチン | #include <spc.h> int srcstat_r(Host, SubsystemName, SubsystemPID, ReplyLength,                  StatusReply, Continued, SRCHandle) char * Ho | Gets short status on a subsystem. | — | — | S3 |
| `startrpdomain` | クラスタ・HA | — | Brings a peer domain that has already been defined online. | — | — | S9 |
| `stoprpdomain` | クラスタ・HA | — | Takes an online peer domain offline. | — | — | S9 |
| `strtune` | パフォーマンス監視 | strtune {-n name \| -q addr} -o tunable_name[=value] -o tunable_name[=value] ... strtune [-n name \| -q addr [-a]] -o trclevel[=value] strtune | This command has several related functions: | — | — | S9 |
| `struct` | その他システム管理 | — | Translates a FORTRAN program into a RATFOR program. | — | — | S9 |
| `subwin` | API・サブルーチン | #include <curses.h> WINDOW *subwin (ParentWindow, NumLines, NumCols,Line,Column) WINDOW * ParentWindow ; int NumLines, NumCols, Line, Column | 次を作成する: a subwindow within an existing window. | — | — | S3 |
| `svmon` | パフォーマンス監視 | — | Captures and analyzes a snapshot of virtual memory. | — | [VMM tunable 変更（minfree / maxfree / page_steal_method）](08-config-procedures.md#cfg-vmm-tunables)<br>[低メモリ機（4GB 以下）で多数同時 open file 障害](09-incident-procedures.md#inc-low-mem-cache-thrash) | S9 |
| `swap` | その他システム管理 | — | 次を提供する: a paging space administrative interface. | — | — | S9 |
| `swts` | その他システム管理 | — | Switches a thin server to a different COSI. | 1. To switch the cosi1 common image of a thin server named lobo to a common image named cosi2, enter: swts -c cosi2 lobo | — | S9 |
| `sysconf` | API・サブルーチン | #include <unistd.h> long int sysconf ( Name) int Name; Description The sysconf subroutine determines the current value of certain system par | 次の値・状態を決定する: the current value of a specified system limit or option. | — | — | S3 |
| `sysdumpstart` | 障害対応・トレース | — | 次を提供する: a command line interface to start a kernel dump to the primary or secondary dump device. | — | — | S9 |
| `tcbck` | ユーザ・認証 | — | Audits the security state of the system. | — | — | S9 |
| `tcsetattr` | API・サブルーチン | #include <termios.h> int tcsetattr (FileDescriptor, OptionalActions, TermiosPointer) int  FileDescriptor,  OptionalActions; const struct ter | 次を設定する: terminal state. | — | — | S3 |
| `tgoto` | API・サブルーチン | #include <curses.h> #include <term.h> char *tgoto( Capability,  Column,  Row) char *Capability; int Column, Row; | Duplicates the tparm subroutine. | — | — | S3 |
| `thrd_equal` | API・サブルーチン | #include <threads.h> int thrd_equal(thrd_t thr0, thrd_t thr1); Description The thrd_equal subroutine determines whether the thread identifie | This subroutine compares two threads. | — | — | S3 |
| `timed` | デーモン | — | Invokes the time server daemon. | — | — | S9 |
| `topsvcsctrl` | その他システム管理 | — | 次を起動する: the topology services subsystem. | — | — | S9 |
| `touchwin` | API・サブルーチン | #include <curses.h> touchwin( Window) WINDOW *Window; Description The touchwin (“touchwin Subroutine” on page 2196) subroutine forces every | Forces every character in a window's buffer to be refreshed at the next call to the wrefresh subroutine. | To refresh a user-defined parent window, parent_window, that has been edited through its subwindows, use: WINDOW *parent | — | S3 |
| `tpm_activate` | その他システム管理 | — | 次を変更する: the Trusted Platform Module (TPM) active states. | — | — | S9 |
| `tpm_createek` | その他システム管理 | tpm_enable [ -e ] [ -d ] [ -h ] [ -l [ none \| error \| info \| debug ] ] [ -o ] [ -s ] [ -u ] [ -v ] [ -z ] Description The tpm_enable command | 次を作成する: an endorsement key pair on the Trusted Platform Module (TPM). | — | — | S9 |
| `trc_strerror` | API・サブルーチン | #include <sys/libtrace.h> char *trc_strerror (handle, rv) void *handle; int rv; Description | 次を返す: the error message, or next error message, associated with a trace log object or trc_loginfo object. | 1. To retrieve all error messages from a call to the trc_open subroutine, call the trc_strerror subroutine as follows: { | — | S3 |
| `trcstop` | API・サブルーチン | # include <sys/trcmacros.h> # define TRCSTOP SERIAL 0x40000000 # define TRCSTOP DISCARDBUFS 0x20000000 int trcstop( Channel) int Channel; | 次を停止する: a trace session. | — | — | S3 |
| `trcupdate` | その他システム管理 | — | Adds, replaces, or deletes trace report format templates. | — | — | S9 |
| `trpt` | その他システム管理 | — | 次を実行する: protocol tracing on TCP sockets. | — | — | S9 |
| `truss` | その他システム管理 | truss [ -f] [ -c] [ -a] [ -l ] [ -d ] [ -D ] [ -e] [ -i] [ { -t \| -x} [!] Syscall [...] ] [ -s [!] Signal [...] ] [ { -m }[!] Fault  [...]] | Traces a process's system calls, dynamically loaded user level function calls, received signals, and | — | — | S9 |
| `turnoff` | その他システム管理 | turnon Description The turnon command sets the permission codes of files in the /usr/games directory. Root user authority is required to run | 次を設定する: the permission codes off for files in the /usr/games directory. | — | — | S9 |
| `twconvfont` | その他システム管理 | — | 次を変換する: other font files to a BDF font file. | To convert the font file USRFONT.C12 to a BDF font file of code page of type SOPS with the name user.bdf, enter: twconvf | — | S9 |
| `type` | その他システム管理 | — | 次を書き込む: a description of the command type. | 1. To learn whether the cd command is a base command or an alias or some other command type, enter: type cd The screen d | — | S9 |
| `tzupg.pl` | その他システム管理 | tzupg.pl Description The tzupg.pl command updates the time zone information on an AIX system based on the latest Olson time zone database fr | 次を更新する: the time zone database of the AIX system by using the latest Olson time zone database from the | The tzupg.pl tool displays the main menu and prompts you to select the following options from the main menu: $ tzupg.pl | — | S9 |
| `umountall` | ネットワーク | — | 次をアンマウントする: groups of dismountable devices or filesystems. | — | — | S9 |
| `units` | その他システム管理 | — | 次を変換する: units in one measure to equivalent units in another measure. | — | — | S9 |
| `unmirrorvg` | ストレージ・FS | — | 次を削除する: the mirrors that exist on volume groups or specified disks. | — | — | S9 |
| `unpack` | その他システム管理 | — | Expands files. | To unpack packed files: unpack chap1.z chap2 This expands the packed files chap1.z and chap2.z, and replaces them with f | — | S9 |
| `update_iscsi` | その他システム管理 | update_iscsi [ -l name ] Description The update_iscsi command lists and updates the devices for which configuration attributes are related t | 次を一覧表示する: and updates the configurations of devices for the iSCSI software initiator that is accessed through | — | — | S9 |
| `usermod` | その他システム管理 | — | 次を変更する: user attributes. | — | — | S9 |
| `usrinfo` | API・サブルーチン | #include <uinfo.h> int usrinfo ( Command,  Buffer,  Count) int Command; char *Buffer; int Count; | Gets and sets user information about the owner of the current process. | — | — | S3 |
| `usrrpt` | その他システム管理 | — | 次を報告する: the security capabilities of users. | — | — | S9 |
| `uutry` | その他システム管理 | uutry [  -xDebugLevel ] [  -r ] SystemName Description The uutry command contacts a remote system, specified by the SystemName parameter, us | Contacts a specified remote system with debugging turned on and allows the user to override the default | 1. To change the amount of detail the uutry command provides about the progress of the uucico operation, use the -x flag | — | S9 |
| `vwsprintf` | API・サブルーチン | #include <wchar.h> #include <stdarg.h> int vwsprintf (wcs, Format, arg) wchar_t * wcs; const char * Format; | 次を書き込む: formatted wide characters. | — | — | S3 |
| `watch` | その他システム管理 | — | Observes a program that might be untrustworthy. | — | — | S9 |
| `wcstok` | API・サブルーチン | #include <wchar.h> wchar_t *wcstok ( WcString1,  WcString2,  ptr) wchar_t *WcString1; const wchar_t *WcString2; wchar_t **ptr | 次を変換する: wide-character strings to tokens. | — | — | S3 |
| `wlm_assign` | API・サブルーチン | #include <sys/wlm.h> int wlm_assign ( args) struct wlm_assign *args; Description The wlm_assign subroutine: | Manually assigns processes to a class or cancels prior manual assignments for processes. | — | — | S3 |
| `wlm_endkey` | API・サブルーチン | #include sys/wlm.h int wlm_endkey(struct wlm_args *args, void *ctx) Description The wlm_endkey subroutine frees the classes to the keys tran | Frees the classes to keys translation table. | — | — | S3 |
| `writesrv` | デーモン | /usr/sbin/acct/wtmpfix [  File ... ] | 次を許可する: users to send messages to and receive messages from a remote system. | — | — | S9 |
| `wstring` | API・サブルーチン | #include <wstring.h>   wchar_t *wstrcat (“wstring Subroutine” on page 2388) (XString1, XString2) wchar_t *XString1, *XString2; | 次を実行する: operations on wide character strings. | — | — | S3 |
| `x_add_nfs_fpe` | X11・GUI | — | 次を追加する: a NFS/TFTP accessed font directory to a font path. | To add the fonts in /usr/lib/X11/fonts/100dpi to the network type x_st_mgr.ether, enter: x_add_nfs_fpe cedar /usr/lib/X1 | — | S9 |
| `xpr` | X11・GUI | — | Formats a window dump file for output to a printer. | — | — | S9 |
| `xrdb` | X11・GUI | — | X Server resource database utilities. | — | — | S9 |
| `xss` | X11・GUI | — | Improves the security of unattended workstations. | When running remotely and using the -display flag for the xss command, remember that you may also have to use the -displ | — | S9 |
| `xwud` | X11・GUI | — | Retrieves and displays the dumped image of an Enhanced X-Windows window. | — | — | S9 |
| `ypxfr` | その他システム管理 | — | Transfers a Network Information Services (NIS) map from an NIS server to a local host. | — | — | S9 |

[← AIX 7.3 トップへ](index.md)
