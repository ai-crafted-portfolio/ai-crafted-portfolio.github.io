# VIOS — 主要設定項目

VIOS — 主要設定項目（padmin コマンド・チューナブル・属性）

viosupgrade / updateios / chdev / viosecure / mkvopt 等の主要オプションと、ストレージ／NPIV／SSP 周辺の重要属性。

| パラメータ／オプション | コマンド・対象 | 既定値・取り得る値 | 意味・推奨値 | 影響範囲（再起動／動的） | 出典 |
|---|---|---|---|---|---|
| ioslevel（参照のみ） | padmin: ioslevel | 例: 4.1.2.00 | 現行 VIOS の VRMF。Update / Upgrade 後の到達点確認に必須。 | 参照のみ | S6, S5 |
| viosupgrade -F devname | padmin: viosupgrade（3.1.x → 4.1.x） | 既定: 4.1.0.40 以降は ON | vfchost / vhost / fcnvme / nvme / fscsi / iSCSI / hdisk / ent ネットワーク・アダプタのデバイス名を upgrade 後も保持。 | Upgrade 時に評価 | S3, S23 |
| viosupgrade -skipdevname | padmin: viosupgrade | 既定: 未指定（=デバイス名保持） | デバイス名保持を意図的にスキップしたい場合に指定（4.1.1.0 以降）。 | Upgrade 時に評価 | S4, S5 |
| viosupgrade -k / -o rerun | padmin: viosupgrade | — | pre-restore script の実行を制御（-k = キープ、-o rerun = 再実行）。viosbr 復元前のカスタムスクリプト運用に使用。 | Upgrade 時に評価 | S3, S23 |
| viosupgrade -i (mksysb / ISO) | padmin: viosupgrade（NIM / standalone 共通） | — | mksysb イメージ／ISO イメージ両対応で 1 ステップ upgrade 実行（4.1.1.0 以降）。 | Upgrade 時に評価 | S4, S5 |
| viosupgrade -noprompt | padmin: viosupgrade | — | 対話プロンプト（マイグレーション不可な LV を skip するか、third-party MPIO ソフトを検出した時など）に事前回答することで自動化。 | Upgrade 時に評価 | S5, S4 |
| viosupgrade -g | padmin: viosupgrade | — | 現行 VIOS のカスタム設定ファイル（タイムゾーン、cron、padmin プロファイル、ssh keys、tunable 等）を新 rootvg へ退避・復元。 | Upgrade 時に評価 | S18, S23 |
| updateios -altdisk | padmin: updateios（4.1.2.00〜） | — | 現行 rootvg を代替ディスクにクローン → 新規 update を代替側に適用。失敗時に元 rootvg へ容易にロールバック可能。 | Update 時に評価 | S6, S25 |
| updateios -listlang / -rmlang / -preserve | padmin: updateios（4.1.1.0〜） | — | インストール済言語メッセージ fileset を一覧／削除／保持。-rmlang 実行時は -preserve で残す言語を明示する。 | Update 時に評価 | S4, S5 |
| viosbr -skip security_config | padmin: viosbr -restore | 既定: 全 security 構成を復元 | viosbr リストア時に security 関連構成（user / RBAC / IPSec / LDAP / OpenSSH 等）の復元を意図的にスキップ。 | Restore 時に評価 | S5 |
| reserve_policy | padmin: chdev -dev hdiskX -attr reserve_policy=… | single_path / no_reserve / PR_exclusive / PR_shared 他 | viosupgrade で 4.1.1.x → 4.1.2.00 へ上げる際、SCSI ディスクの reserve_policy=single_path かつ algorithm=fail_over の組み合わせでないと新 rootvg ブート不可になる既知不具合あり。事前に明示設定を推奨。 | デバイス属性（chdev で動的可） | S6 |
| algorithm | padmin: chdev -dev hdiskX -attr algorithm=… | round_robin / fail_over / shortest_queue 他 | MPIO 経路選択アルゴリズム。4.1.1.x → 4.1.2.00 上げ時は fail_over 推奨（reserve_policy=single_path とセット）。 | デバイス属性（chdev で動的可） | S6 |
| num_local_cmds / bufs_per_cmd | VFC host adapter 属性（chdev） | 4.1.1.0 で導入 | VFC スタックの I/O コマンドタイムアウト改善とメモリ管理。256K 以上の大 IO 時の starvation 抑制を狙う。 | デバイス属性 | S4, S5 |
| vfchost tunables (LPM port validation バイパス) | VFC host 属性 | Linux / IBM i NPIV クライアント向け | LPM 時のストレージ port validation を IBM i / Linux クライアントに対してバイパス。LUN が両 VIOS で見えていれば、port が異なっても LPM 成功。 | デバイス属性 | S25, S6 |
| viosecure -firewall | padmin: viosecure -firewall | サブネットレンジ + IP アドレス（4.1.2.00〜） | サブネット単位で allow/deny ルールを定義。 | サービス再評価（即時反映） | S25, S6 |
| lsmap -npiv -cpname / -cpos | padmin: lsmap | — | NPIV マッピングをクライアント LPAR 名 (-cpname) または OS タイプ (-cpos) でフィルタ表示（4.1.2.00〜）。 | 参照コマンド | S6, S25 |
| mkvopt -nfslink | padmin: mkvopt -name <NAME> -file /mnt/<ISO> -nfslink -ro | — | NFS マウント済の ISO ファイルを Virtual Media Library にシンボリックリンクで登録。NFSv3 / v4 両対応、複数 VIOS で ISO を共用。 | リポジトリ登録時に評価 | S5, S4 |
| RBAC 認可（pvi 用） | padmin: setsecattr / setkst → pvi | vios.file.read / vios.file.write | /etc/syslog.conf 等の制限付き構成ファイルを pvi で表示・編集するための事前手順（4.1.2.00〜）。setsecattr で writeauths 付与 → setkst で適用 → pvi で編集。 | RBAC 構成（即時反映） | S6, S25 |
| rootvg 空き容量 | padmin: lsvg rootvg | ≥ 4 GB FREE PPs（4.1.0.40 update 時） | Update Release 適用前に rootvg ≥ 30 GB かつ 4 GB 以上の空き必須。lsvg で FREE PPs を事前確認。 | 事前確認 | S3 |
| 32Gb PCIe4 2-Port FC Adapter (EN1J / EN1K) microcode | アダプタ microcode（事前更新） | VIOS 4.1.0.40〜4.1.1.10: 7710812214105106.070115 / 4.1.2.00: 7710812214105106.070120 以上 | POWER10 で当該 FC アダプタを使用する場合、VIOS 更新前にアダプタ microcode を所定レベルへ更新必須。 | 事前作業 | S6, S5, S3 |
| SSP リポジトリディスク容量 | SSP クラスタ作成 | 10〜1016 GB（リポジトリ 1 本） | FC 接続ディスク 1 本をリポジトリとして専有。データ用に別途 1 本以上の FC ディスクが必要。 | クラスタ作成時に決定 | S3 |
| /var 容量（SSP） | SSP ノード OS 設定 | ≥ 3 GB 推奨 | SSP の logging 容量。SSP クラスタの正常な動作と障害時のログ採取のために 3 GB 以上を確保。 | 事前確認 | S3 |
| SEA mode (SSP 環境) | SEA 構成 | Threaded（既定） | SSP に参加する VIOS では SEA を Threaded mode で設定する必要がある。Interrupt mode は SSP 環境で非サポート。 | SEA 設定変更時 | S3 |
| Client LPAR FS（SSP 配下 vSCSI） | クライアント側ファイルシステム | JFS2（既定） | SSP から提供される vSCSI 上で JFS を使うとネットワーク断時にデータ破損リスクあり。JFS2 ほかを使用すること。 | クライアント設計時 | S3 |
| Client LPAR vSCSI Adapter『Any client partition can connect』 | HMC vSCSI Adapter 設定 | 非サポート（SSP 環境） | VIOS LPAR 用に vSCSI サーバアダプタを作る際、SSP 環境では『Any client partition can connect』オプションは非サポート。具体的な client partition ID を明示すること。 | vSCSI Adapter 作成時 | S3 |

