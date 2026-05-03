# VIOS — トラブルシュート

VIOS — トラブルシュート（既知の問題と対処）

| 症状 | 原因 | 対処手順 | 関連ログ・コマンド | 出典 |
|---|---|---|---|---|
| viosupgrade で 4.1.1.x → 4.1.2.00 後、新 rootvg からブートできない | SCSI ディスクの reserve_policy / algorithm 属性の組み合わせが不適切 | 事前または事後に SCSI ディスクへ chdev -dev hdiskX -attr reserve_policy=single_path algorithm=fail_over を実行 | chdev, lsattr, lspath, bootlist | S6 |
| viosupgrade 直後に padmin がログインできず password expired | VIOS 4.1.0.0 / 4.1.0.30 / 4.1.0.40 の既知不具合（premature password expiration） | viosupgrade 前に当該 ifix を適用。発生済の場合は HMC vterm から root でログインして chage / pwdadm で expiration をリセット | HMC vterm, chage, pwdadm, ioslevel | S3, S2 |
| NVMe over Fabric (SAN) ブートディスクからブート失敗 | ファブリックエラー応答時のブートロジック制約 | 1) SMS メニューから exit してブート継続を試行 2) SMS から boot LUN を再 discover してリトライ 3) ブートディスクは複数パスを持つ構成にする | SMS menu, bootlist | S6, S5, S4 |
| 32Gb PCIe4 2-Port FC Adapter (EN1J / EN1K) で VIOS 更新後に I/O 不安定 | アダプタ microcode が更新前提レベル未満 | VIOS 更新前に当該アダプタ microcode を所定レベル以上へ更新（4.1.0.40〜4.1.1.10: 7710812214105106.070115、4.1.2.00: 7710812214105106.070120） | lsmcode, diag, アダプタ Release Notes | S6, S5, S3 |
| SSP クラスタで 3.1.4.50 以上の混在環境から 4.1 へ upgrade できない | SSP クラスタ環境の upgrade 制約 | 1) クラスタ全ノードを 3.1.4.50 以上へ事前に揃える 2) 揃えた後 4.1.1.00 以上へ upgrade（4.1.0.x へは upgrade 不可） | cluster -status, ioslevel | S6, S5 |
| SSP 参加 VIOS で SEA failover が動作しない / SEA 構成不具合 | SEA を Interrupt mode で構成（SSP 環境では非サポート） | SEA を Threaded mode に変更（chdev -dev entX -attr thread=1）→ SEA を再作成 → failover 試験 | chdev, entstat -all, mkvdev -sea | S3 |
| padmin で 3.1.4.30/3.1.4.31 → 4.1 upgrade 後ログイン不可 | HIPER APAR IJ50326 未適用 | 1) viosupgrade 実行前に IJ50326 の interim fix を適用、または 3.1.4.40 へ事前 update 2) FLRT HIPER APAR Information for VIOS で current ioslevel に対応する HIPER 一覧確認 | HMC vterm, FLRT, emgr -l | S18 |
| viosupgrade で『lspv -free does not return any output』エラー | viosupgrade に必要な spare disk が rootvg ミラーに含まれていて空きと認識されない | 1) unmirrorios で rootvg を一時的に unmirror 2) reducevg で対象 hdisk を rootvg から除外 3) viosupgrade を再実行 4) 完了後 mirrorios で再ミラーリング | lspv, unmirrorios, reducevg, mirrorios | S18 |
| viosupgrade 後、追加ソフト（IBM 認可アプリ／第三者 MPIO／Expansion Pack 等）が消失 | viosupgrade は new and complete installation のため、追加ソフトはイメージに含まれない | カスタム mksysb を作成して viosupgrade -i で投入: ダミー VIOS 区画に 4.1 を新規 install → 必要な追加ソフトを install → backupios -file <NAME>.mksysb -mksysb で取得 → このカスタム mksysb で viosupgrade -i 実行 | backupios, viosupgrade -i | S18 |
| viosupgrade 後、device 番号（ent#, hdisk#, fcs#）が再連番されてしまう | デバイス名保持が無効化されている | viosupgrade 実行時に -F devname を指定（4.1.0.40 以降は既定で有効）。明示的にスキップする場合は -skipdevname | viosupgrade -F devname / -skipdevname | S3, S5 |
| AMS が構成された VIOS を 4.1.x へ upgrade すると失敗 / 動作不正 | VIOS 4.1.x は AMS をサポートしない、POWER10 自体も AMS 非サポート | 1) VIOS upgrade 前に AMS を un-configure 2) AMS 利用前提だった LPAR は CoD / Dedicated Memory へ設計変更 3) Paging VIOS Partition を停止 | HMC: AMS un-configure, lparstat | S7, S6 |
| viosbr -restore で security 構成が想定と異なる状態になる | ユーザ・RBAC・IPSec などが旧バージョンと新バージョンで非互換 | viosbr -restore 実行時に -skip security_config を併用、または事前に /usr/ios/security/saveconf/viosbr 配下の保存済構成を確認・手動マージ | viosbr -restore -skip, /usr/ios/security/saveconf | S5 |
| FLRT 推奨レベルへ直接更新できない | FLRT は『推奨終点』を返すが直接到達できる保証はない | 1) 対象 Fix Pack Release Notes の Upgrade 章で経由 SP / 中間 ioslevel 要件を確認 2) 中間段階を経由して順次 update / upgrade | FLRT, Fix Central, Fix Pack Release Notes | S20 |

