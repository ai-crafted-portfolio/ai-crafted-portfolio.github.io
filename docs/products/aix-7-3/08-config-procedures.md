# AIX 7.3 — 設定手順（12 手順）

代表的な設定変更シナリオ。各手順は **目的 / 前提 / コマンド+期待出力 / 検証 / ロールバック** の 5 部構成。

## 手順一覧

| ID | タイトル | 目的 |
|---|---|---|
| [cfg-mpio-defaults](#cfg-mpio-defaults) | MPIO 既定値の調整（reserve_policy / algorithm / queue_depth） | AIX 7.3 で変更された MPIO 既定値（reserve_policy=no_reserve / algorithm=shortest_queue / q |
| [cfg-vmm-tunables](#cfg-vmm-tunables) | VMM tunable 変更（minfree / maxfree / page_steal_method） | メモリ不足時の paging 挙動を調整。低メモリ機でのプロセス停止を回避、または高メモリ機でファイルキャッシュ偏重を避ける。 |
| [cfg-tcp-buffers](#cfg-tcp-buffers) | TCP バッファサイズの拡張（tcp_recvspace / tcp_sendspace） | 高遅延・広帯域ネットワーク（10GbE 以上、長距離接続）で TCP throughput を向上させる。tcp_dss が 1 でない場合に明示設定が必要。 |
| [cfg-encrypt-rootvg](#cfg-encrypt-rootvg) | rootvg の暗号化構築（PKS + passphrase） | ブートディスクを暗号化し、物理ディスク盗難時のデータ保護を実現する。AIX 7.3 から PKS により passphrase なし起動が可能。 |
| [cfg-ldap-client](#cfg-ldap-client) | LDAP クライアント設定（AIX 7.3 TL3 SP1 拡張フィールド対応） | LDAP / AD を AIX のユーザレジストリとして統合する。TL3 SP1 で defaulthomedirectory / pwdalgorithm / |
| [cfg-live-kernel-update](#cfg-live-kernel-update) | Live Kernel Update（LKU）実施 | 業務無停止でカーネル / libc を更新する（TL3 で性能改善・blackout 短縮・LLU 対応）。 |
| [cfg-trusted-execution](#cfg-trusted-execution) | Trusted Execution + CHKSHOBJS 有効化（TL3 SP1） | 実行ファイル + 共有オブジェクトの整合性検証を有効化し、改ざん検知を実現する。CHKSHOBJS は TL3 SP1 で追加。 |
| [cfg-ssh-hardening](#cfg-ssh-hardening) | OpenSSH の堅牢化（PermitRootLogin / Ciphers / GSSAPI） | AIX 既定 OpenSSH 9.7p1 で root login 禁止・脆弱 cipher 排除・GSSAPI 認証有効化を行う。 |
| [cfg-wpar-create](#cfg-wpar-create) | WPAR 作成 + WLM クラス連携 | OS レベル隔離環境（WPAR）を作成し、WLM クラスでリソース上限を強制する。 |
| [cfg-cluster-aware-aix](#cfg-cluster-aware-aix) | Cluster Aware AIX リポジトリディスク構築 | PowerHA の前提となる CAA リポジトリ + ノードメンバーシップを構築する。AIX 7.3 TL3 から NVMe 対応。 |
| [cfg-aixpert-policy](#cfg-aixpert-policy) | AIXPert で security policy 適用 | AIXPert で AIX システム全体のセキュリティ設定を一括適用（low/med/high/sox-cobit など） |
| [cfg-nim-server-build](#cfg-nim-server-build) | NIM サーバ構築 + LPP_SOURCE 整備 | AIX クライアントを集中管理する NIM master を構築。LPP_SOURCE と SPOT で複数クライアントを同期管理。 |

---

## MPIO 既定値の調整（reserve_policy / algorithm / queue_depth） {#cfg-mpio-defaults}

**目的**: AIX 7.3 で変更された MPIO 既定値（reserve_policy=no_reserve / algorithm=shortest_queue / queue_depth=64(DS8000) or 32(SVC/Flash)）を、ストレージ仕様に合わせて調整する。  [S35]

**前提**: 対象 hdisk が認識されている / ストレージベンダの推奨値を把握している / 業務影響を確認済み

**手順 (コマンド + 期待出力 / 説明)**:

| コマンド | 説明・期待出力 |
|---|---|
| `lsattr -El hdisk0` | 現状の MPIO 属性を全件表示 |
| `lsattr -El hdisk0 -a reserve_policy,algorithm,queue_depth` | 対象3属性のみ表示 |
| `chdev -l hdisk0 -a reserve_policy=no_reserve -a algorithm=shortest_queue -a queue_depth=64 -U` | -U で動的反映（オープン中も適用可） |
| `lsattr -El hdisk0 -a reserve_policy,algorithm,queue_depth` | 変更後の値を確認 |

**期待出力**: reserve_policy / algorithm / queue_depth が指定値に変わっていれば成功。queue_depth は -P で次回起動時反映の場合あり

**検証**: `iostat -D 1` で I/O が適切に分散しているか観察。MPIO 経路の負荷バランスを `lspath -l hdisk0` で確認

**ロールバック**: `chdev -l hdisk0 -a reserve_policy=single_path -a algorithm=fail_over -a queue_depth=8 -U` で旧既定に戻す（※ AIX 7.2 以前の既定）

**関連**:

- 関連用語: [MPIO](03-glossary.md), [PCM](03-glossary.md), [AAPCM](03-glossary.md)
- 関連設定値: `reserve_policy`, `algorithm`, `queue_depth`（[02-設定値一覧](02-settings.md)）
- 関連コマンド: `chdev`, `lsattr`, `lspath`（[01-コマンド一覧](01-commands.md)）

---

## VMM tunable 変更（minfree / maxfree / page_steal_method） {#cfg-vmm-tunables}

**目的**: メモリ不足時の paging 挙動を調整。低メモリ機でのプロセス停止を回避、または高メモリ機でファイルキャッシュ偏重を避ける。  [S25]

**前提**: vmstat -v でメモリ統計を把握 / ピーク負荷時のメモリ使用パターンを把握

**手順 (コマンド + 期待出力 / 説明)**:

| コマンド | 説明・期待出力 |
|---|---|
| `vmo -L \| head -50` | 現状値の一覧表示 |
| `vmo -L minfree -L maxfree -L page_steal_method` | 対象 tunable のみ |
| `vmo -p -o minfree=960 -o maxfree=1088` | 永続反映（boot/current 両方） |
| `vmo -p -o page_steal_method=1` | lru_file_repage の挙動を変更 |
| `vmo -L minfree -L maxfree` | 変更後の確認 |

**期待出力**: CUR / DEF / BOOT / MIN / MAX 列が新しい値で表示される。`vmstat -v` で fre / re / pi / po が安定するか観察

**検証**: `vmstat 1 60` でページング統計を 60 秒観察、pi/po がほぼ 0 なら正常

**ロールバック**: `vmo -d minfree -d maxfree -d page_steal_method` で各 tunable を既定に戻す

**関連**:

- 関連用語: [VMM](03-glossary.md), [page_steal_method](03-glossary.md), [lru_file_repage](03-glossary.md)
- 関連設定値: `minfree`, `maxfree`, `page_steal_method`, `lru_file_repage`（[02-設定値一覧](02-settings.md)）
- 関連コマンド: `vmo`, `vmstat`, `svmon`（[01-コマンド一覧](01-commands.md)）

---

## TCP バッファサイズの拡張（tcp_recvspace / tcp_sendspace） {#cfg-tcp-buffers}

**目的**: 高遅延・広帯域ネットワーク（10GbE 以上、長距離接続）で TCP throughput を向上させる。tcp_dss が 1 でない場合に明示設定が必要。  [S35]

**前提**: no -L tcp_recvspace で現状値を把握 / sb_max が新値以上であることを確認

**手順 (コマンド + 期待出力 / 説明)**:

| コマンド | 説明・期待出力 |
|---|---|
| `no -L tcp_recvspace -L tcp_sendspace -L sb_max` | 現状値 |
| `no -p -o tcp_recvspace=262144 -o tcp_sendspace=262144` | 永続反映 |
| `no -p -o sb_max=1048576` | sb_max を recvspace の 4 倍以上に |
| `no -L tcp_recvspace -L tcp_sendspace` | 変更確認 |

**期待出力**: CUR 列が指定値に。sb_max は静的（再起動要）の場合あり、no -h sb_max で確認

**検証**: `netstat -s | grep retrans` で再送数の減少を観察

**ロールバック**: `no -d tcp_recvspace -d tcp_sendspace -d sb_max` で既定値復元

**関連**:

- 関連用語: [TCP](03-glossary.md), [tcp_dss](03-glossary.md)
- 関連設定値: `tcp_recvspace`, `tcp_sendspace`, `sb_max`, `tcp_dss`（[02-設定値一覧](02-settings.md)）
- 関連コマンド: `no`, `netstat`（[01-コマンド一覧](01-commands.md)）

---

## rootvg の暗号化構築（PKS + passphrase） {#cfg-encrypt-rootvg}

**目的**: ブートディスクを暗号化し、物理ディスク盗難時のデータ保護を実現する。AIX 7.3 から PKS により passphrase なし起動が可能。  [S35]

**前提**: 新規 install または上書き install 時のみ / Power FW1030+ で PKS 推奨

**手順 (コマンド + 期待出力 / 説明)**:

| コマンド | 説明・期待出力 |
|---|---|
| `# (BOS install メニュー) Encryption Settings → 暗号化対象 LV を選択` | hd2/hd9var/hd3/hd1/hd10opt/hd11admin/dumplv |
| `# (BOS install メニュー) PKS 認証で初期化` | PKS keystore を使うか選択 |
| `# (起動完了後) hdcryptmgr authadd -k <kid> -t passphrase` | passphrase recovery method を追加 |
| `hdcryptmgr show` | 暗号化LV の鍵スロット一覧確認 |
| `hdcryptmgr authdelete -k <kid> -i <slot>` | 古い鍵スロットを削除 |

**期待出力**: hdcryptmgr show で 暗号化LV ごとに状態 (enabled / locked / unlocked) と鍵スロット ID が表示される

**検証**: 再起動後、PKS 経由で自動アンロックされブートが完了する。`hdcryptmgr show hd2` で unlocked になっていれば正常

**ロールバック**: 暗号化解除には rootvg 再構築が必要（多くの場合 mksysb 復元から再 install）。事前に必ず鍵 backup を取る

**関連**:

- 関連用語: [PKS](03-glossary.md), [EFS](03-glossary.md), [CCA](03-glossary.md)
- 関連設定値: `/etc/security/aixpert/log/aixpert.log`（[02-設定値一覧](02-settings.md)）
- 関連コマンド: `hdcryptmgr`, `pksctl`（[01-コマンド一覧](01-commands.md)）

---

## LDAP クライアント設定（AIX 7.3 TL3 SP1 拡張フィールド対応） {#cfg-ldap-client}

**目的**: LDAP / AD を AIX のユーザレジストリとして統合する。TL3 SP1 で defaulthomedirectory / pwdalgorithm / defaultloginshell が拡張された。  [S34]

**前提**: LDAP/AD サーバが稼働 / bindDN・bindPW が払い出し済 / SSL 証明書がある場合は配置済

**手順 (コマンド + 期待出力 / 説明)**:

| コマンド | 説明・期待出力 |
|---|---|
| `mksecldap -c -h ldap.example.com -a cn=admin,dc=example,dc=com -p ******* -d dc=example,dc=com` | クライアント初期化 |
| `vi /etc/security/ldap/ldap.cfg` | defaulthomedirectory / pwdalgorithm / defaultloginshell を追記 |
| `stop-secldapclntd` | デーモン停止 |
| `start-secldapclntd` | 再起動 |
| `lsldap -a cn=admin,dc=example,dc=com -p ****** -h ldap.example.com passwd` | クエリテスト |

**期待出力**: lsldap で LDAP 内ユーザリストが返る。`lsuser -R LDAP <user>` で個別取得も可

**検証**: テストユーザで `su - <user>` し、ホームディレクトリが defaulthomedirectory に従って作成されるか確認

**ロールバック**: `mksecldap -c -u` でクライアント設定削除。/etc/security/user の SYSTEM 属性を `compat` に戻す

**関連**:

- 関連用語: [LDAP](03-glossary.md), [ISVD](03-glossary.md), [ISDS](03-glossary.md)
- 関連設定値: `/etc/security/ldap/ldap.cfg`（[02-設定値一覧](02-settings.md)）
- 関連コマンド: `mksecldap`, `lsldap`（[01-コマンド一覧](01-commands.md)）

---

## Live Kernel Update（LKU）実施 {#cfg-live-kernel-update}

**目的**: 業務無停止でカーネル / libc を更新する（TL3 で性能改善・blackout 短縮・LLU 対応）。  [S35]

**前提**: TL/SP 互換性確認 / 必要 fileset が NIM master に配置 / IPsec 接続が業務クリティカルなら ipsec_auto_migrate=yes 設定

**手順 (コマンド + 期待出力 / 説明)**:

| コマンド | 説明・期待出力 |
|---|---|
| `oslevel -s` | 現 TL/SP 取得 |
| `vi /etc/lvupdate.data` | ipsec_auto_migrate=yes 等を記載 |
| `geninstall -k -p -d <NIM_LPP_SOURCE>` | preview（dry run） |
| `geninstall -k -d <NIM_LPP_SOURCE> all` | 本番 LKU 実行 |
| `oslevel -s` | 新 TL/SP 確認 |

**期待出力**: geninstall 実行中に「Live Update is in progress」 → blackout（短時間） → 「Live Update completed successfully」

**検証**: `audit query` で audit subsystem が STREAM mode で正常動作 / 業務アプリ TPS の連続性

**ロールバック**: LKU 失敗時は前回 boot LV から自動 fallback。boot 不能時は alt_disk_install 復元

**関連**:

- 関連用語: [LKU](03-glossary.md), [LLU](03-glossary.md), [IPsec](03-glossary.md)
- 関連設定値: `/etc/lvupdate.data`, `ipsec_auto_migrate`（[02-設定値一覧](02-settings.md)）
- 関連コマンド: `geninstall`, `oslevel`, `lkupdate`（[01-コマンド一覧](01-commands.md)）

---

## Trusted Execution + CHKSHOBJS 有効化（TL3 SP1） {#cfg-trusted-execution}

**目的**: 実行ファイル + 共有オブジェクトの整合性検証を有効化し、改ざん検知を実現する。CHKSHOBJS は TL3 SP1 で追加。  [S34]

**前提**: Trusted Signature DB（lib.tsd.dat）が存在 / 業務アプリの SO ライブラリ署名が登録済

**手順 (コマンド + 期待出力 / 説明)**:

| コマンド | 説明・期待出力 |
|---|---|
| `trustchk -p TE=ON` | Trusted Execution 全体を ON |
| `trustchk -p CHKEXEC=ON` | 実行ファイル整合性チェック ON |
| `trustchk -p CHKSHOBJS=ON` | 共有オブジェクトチェック ON（TL3 SP1） |
| `trustchk -p STOP_ON_CHKFAIL=ON` | 整合性失敗で停止 |
| `trustchk -n /usr/bin/ls` | 個別ファイルの検査 |

**期待出力**: trustchk -p で各ポリシーが ON 表示される。`trustchk -n /path` で OK / 失敗が確認可能

**検証**: 改ざんしたバイナリを `trustchk -n` で検査し失敗することを確認 / 業務アプリ正常起動を確認

**ロールバック**: `trustchk -p TE=OFF` で全体 OFF

**関連**:

- 関連用語: [TE](03-glossary.md), [TSD](03-glossary.md), [AIXPert](03-glossary.md)
- 関連設定値: `/etc/security/tepolicies.dat`, `/etc/security/lib.tsd.dat`（[02-設定値一覧](02-settings.md)）
- 関連コマンド: `trustchk`（[01-コマンド一覧](01-commands.md)）

---

## OpenSSH の堅牢化（PermitRootLogin / Ciphers / GSSAPI） {#cfg-ssh-hardening}

**目的**: AIX 既定 OpenSSH 9.7p1 で root login 禁止・脆弱 cipher 排除・GSSAPI 認証有効化を行う。  [S65]

**前提**: 代替の管理ユーザがいる / sshd_config の構文を `sshd -t` で検証する手順を把握

**手順 (コマンド + 期待出力 / 説明)**:

| コマンド | 説明・期待出力 |
|---|---|
| `vi /etc/ssh/sshd_config` | PermitRootLogin no, Ciphers aes256-gcm@openssh.com,chacha20-poly1305@openssh.com 等 |
| `/usr/sbin/sshd -t` | 構文チェック |
| `stopsrc -s sshd` | sshd 停止 |
| `startsrc -s sshd` | sshd 起動 |
| `ssh -vvv localhost` | 新接続でクライアント認証確認 |

**期待出力**: stopsrc / startsrc で「sshd subsystem successfully...」/ 新セッションで cipher 確認

**検証**: `netstat -an | grep :22` でリスナー確認 / `sshd -T | grep -i cipher` で実効値確認

**ロールバック**: /etc/ssh/sshd_config を git/RCS で 1 つ前に戻し、stopsrc/startsrc を再実行

**関連**:

- 関連用語: [SSH](03-glossary.md), [OpenSSH](03-glossary.md), [OpenSSL](03-glossary.md), [GSSAPI](03-glossary.md)
- 関連設定値: `/etc/ssh/sshd_config`（[02-設定値一覧](02-settings.md)）
- 関連コマンド: `sshd`, `ssh`, `stopsrc`, `startsrc`（[01-コマンド一覧](01-commands.md)）

---

## WPAR 作成 + WLM クラス連携 {#cfg-wpar-create}

**目的**: OS レベル隔離環境（WPAR）を作成し、WLM クラスでリソース上限を強制する。  [S75]

**前提**: WPAR 用 file system 作成済 / WLM クラス定義済 / PowerSC.ts は事前削除（AIX 7.3 で非サポート）

**手順 (コマンド + 期待出力 / 説明)**:

| コマンド | 説明・期待出力 |
|---|---|
| `mkwpar -n wpar1 -h wpar1.example.com -B /var/wpars/wpar1` | system WPAR 作成 |
| `wlmcntrl -a` | WLM 有効化 |
| `vi /etc/wlm/.regs` | WPAR にクラスを割当 |
| `startwpar wpar1` | WPAR 起動 |
| `clogin wpar1` | コンテナログイン |
| `lswpar` | WPAR 一覧確認 |

**期待出力**: lswpar で wpar1 が D (Defined) → A (Active) → R (Running) と遷移

**検証**: WPAR 内で `lparstat`, `vmstat` が WLM 制限を超えないことを確認

**ロールバック**: `stopwpar wpar1` → `rmwpar wpar1` で完全削除（base dir も削除される）

**関連**:

- 関連用語: [WPAR](03-glossary.md), [WLM](03-glossary.md)
- 関連設定値: `/etc/wlm/.regs`（[02-設定値一覧](02-settings.md)）
- 関連コマンド: `mkwpar`, `startwpar`, `clogin`, `lswpar`, `wlmcntrl`（[01-コマンド一覧](01-commands.md)）

---

## Cluster Aware AIX リポジトリディスク構築 {#cfg-cluster-aware-aix}

**目的**: PowerHA の前提となる CAA リポジトリ + ノードメンバーシップを構築する。AIX 7.3 TL3 から NVMe 対応。  [S6]

**前提**: RSCT 3.3.0.0 が稼働 / 共有ディスクが各ノードから見える / rsct.vsd・rsct.lapi.rte は削除済

**手順 (コマンド + 期待出力 / 説明)**:

| コマンド | 説明・期待出力 |
|---|---|
| `lspv \| grep -i caa` | リポジトリ用 PV を特定 |
| `clmgr add cluster mycluster REPOSITORIES=hdisk5 NODES=node1,node2` | クラスタ作成 |
| `lscluster -m` | クラスタメンバ確認 |
| `lscluster -i` | クラスタ ID 確認 |
| `clmgr query cluster mycluster` | 詳細プロパティ |

**期待出力**: lscluster -m で全ノードが UP 状態 / リポジトリディスクが Cluster Disk に変わる

**検証**: `lscluster -d` でリポジトリ I/O 統計、`lscluster -i` でクラスタ ID 取得

**ロールバック**: `clmgr delete cluster mycluster` で削除（リポジトリディスクは PV に戻る）

**関連**:

- 関連用語: [CAA](03-glossary.md), [RSCT](03-glossary.md), [PowerHA](03-glossary.md)
- 関連コマンド: `clmgr`, `lscluster`, `mkcluster`（[01-コマンド一覧](01-commands.md)）

---

## AIXPert で security policy 適用 {#cfg-aixpert-policy}

**目的**: AIXPert で AIX システム全体のセキュリティ設定を一括適用（low/med/high/sox-cobit など）  [S32]

**前提**: 適用前の現状を `aixpert -p` で取得済（差分比較用）

**手順 (コマンド + 期待出力 / 説明)**:

| コマンド | 説明・期待出力 |
|---|---|
| `aixpert -l h` | high level policy 適用 |
| `aixpert -l h -n -o /tmp/aixpert_high_dryrun.xml` | dry run（適用しない、XML 出力のみ） |
| `aixpert -p` | 現在の適用状態確認 |
| `aixpert -u` | 前回適用を undo |
| `more /etc/security/aixpert/log/aixpert.log` | 適用履歴ログ確認 |

**期待出力**: aixpert -l h 実行で「Processing AIX Security Expert Configuration: ...」と各項目の OK/SKIP 表示

**検証**: `lssec -f /etc/security/login.cfg -s default -a tpath` 等で個別設定が変わったか確認

**ロールバック**: `aixpert -u` で前回適用前に戻す。または XML を編集して再適用

**関連**:

- 関連用語: [AIXPert](03-glossary.md), [RBAC](03-glossary.md)
- 関連設定値: `/etc/security/aixpert/core/aixpertall.xml`, `/etc/security/login.cfg`（[02-設定値一覧](02-settings.md)）
- 関連コマンド: `aixpert`, `lssec`（[01-コマンド一覧](01-commands.md)）

---

## NIM サーバ構築 + LPP_SOURCE 整備 {#cfg-nim-server-build}

**目的**: AIX クライアントを集中管理する NIM master を構築。LPP_SOURCE と SPOT で複数クライアントを同期管理。  [S18]

**前提**: bos.sysmgt.nim.master fileset 入手 / LPP_SOURCE 用 FS に十分な空き / NIM サーバの IP 固定

**手順 (コマンド + 期待出力 / 説明)**:

| コマンド | 説明・期待出力 |
|---|---|
| `installp -acgYXd <media> bos.sysmgt.nim.master` | NIM master fileset インストール |
| `nim_master_setup -B -a mk_resource=no` | NIM master の初期化 |
| `nim -o define -t lpp_source -a server=master -a location=/export/lpp_src/aix73tl3 -a source=<media> aix73tl3_lpp` | LPP_SOURCE 作成 |
| `nim -o define -t spot -a server=master -a location=/export/spot -a source=aix73tl3_lpp aix73tl3_spot` | SPOT 作成 |
| `lsnim` | NIM オブジェクト一覧確認 |

**期待出力**: lsnim で master / lpp_source / spot が登録される / `nim -o check aix73tl3_spot` で OK

**検証**: テストクライアントで bootp 経由のネットワークインストール成功確認

**ロールバック**: `nim -o remove <object>` で個別削除、`nim_master_setup -B -a remove=yes` で完全初期化

**関連**:

- 関連用語: [NIM](03-glossary.md), [SPOT](03-glossary.md), [LPP](03-glossary.md), [LPP_SOURCE](03-glossary.md)
- 関連設定値: `bosinst.data`, `image.data`（[02-設定値一覧](02-settings.md)）
- 関連コマンド: `nim`, `lsnim`, `installp`, `nim_master_setup`（[01-コマンド一覧](01-commands.md)）

---

[← AIX 7.3 トップへ](index.md)