# VIOS — 関連製品連携

VIOS — 関連製品連携 / 依存関係

| 連携先製品 | 連携の種類 | 設定要点 | 出典 |
|---|---|---|---|
| Hardware Management Console (HMC) | VIOS / クライアント LPAR の集中管理コンソール | Add VIOS Wizard / VIOS の更新 / VIOS バックアップ管理 / 仮想アダプタ作成（vSCSI / VFC / Virtual Ethernet）。HMC 9.2.950+ で VIOS イメージのバックアップ管理に対応。HMC 9 から HMC 経由 viosupgrade 実行が推奨経路の 1 つ。 | S11, S15, S16, S18 |
| PowerVM (Power Hypervisor) | ハードウェア仮想化基盤 | VIOS は PowerVM Editions の一部。POWER8 / POWER9 / POWER10（4.1.0.40 まで）/ POWER11（4.1.2.00〜）。Power Hypervisor が物理リソースを LPAR へ分割、VIOS が I/O 仮想化を担当。 | S7, S23, S25 |
| AIX 7.3 | VIOS 4.1.x の OS 基盤 | VIOS 4.1.2.00 = AIX 7300-04、4.1.1.10 = AIX 7300-03-01、4.1.1.00 = AIX 7300-02-02、4.1.0.40 = AIX 7300-02-04。NIM Master の AIX レベルは VIOS の AIX レベル以上必須。VIOS 上では AIX RBAC を流用しつつ padmin / ksh93 で運用。 | S23, S6, S5, S3 |
| AIX クライアント LPAR | VIOS が提供する vSCSI / NPIV / SEA を消費 | vSCSI イニシエータ、NPIV クライアント vfc、Virtual Ethernet を AIX 側で構成。AIX 7.3 TL 4 クライアントは VIOS 4.1.2.00 の Advanced IO Monitoring（fcstat）でホスト・ハイパーバイザ・VFC アダプタ層の追加情報取得可能。 | S7, S6, S25 |
| IBM i クライアント LPAR | VIOS 経由の vSCSI / NPIV | NPIV vfc / vSCSI 経由でストレージ提供。LPM 時の port-level validation を vfchost tunable でバイパス可能（4.1.2.00〜）。Suspend/Resume は POWER8 環境のみ。 | S7, S6, S25 |
| Linux on Power クライアント LPAR | VIOS 経由の vSCSI / NPIV | NPIV vfc / vSCSI 経由でストレージ提供。LPM 時の port-level validation を vfchost tunable でバイパス可能（4.1.2.00〜）。Suspend/Resume は POWER8 環境のみ。 | S7, S6, S25 |
| Live Partition Mobility (LPM) | 稼働中 LPAR の物理サーバ間移動 | VIOS が NPIV / vSCSI 経由で SAN ストレージを両系で見せられる構成が前提。port-level validation を VFC で行うが、4.1.2.00 以降 IBM i / Linux クライアントは vfchost tunable でバイパス可能（LUN が両 VIOS で見えていれば port が異なっても LPM 成功）。 | S6, S25 |
| PowerHA SystemMirror | 高可用性クラスタ | VIOS が提供する vSCSI / SEA / NPIV を経由してクラスタノード間で共有ストレージとネットワークパスを確保。VIOS 自身は二重化（Dual VIOS）して SPOF を回避するのが標準パターン。 | S8 |
| NIM (Network Installation Management) | ネットワーク経由インストール基盤 | viosupgrade NIM 版で複数 VIOS の集中 upgrade。NIM Master は VIOS の AIX レベル以上が必須。NIM 経由でカスタム mksysb を VIOS へ流し込む運用も可能。 | S18, S5, S3 |
| FLRT (Fix Level Recommendation Tool) | 推奨 ioslevel / Update / Upgrade の照会 | Server Machine-Type-Model + 現行 ioslevel から Recommended Update / Recommended Upgrade 取得。HIPER APAR 一覧も FLRT 経由で取得可能。 | S20 |
| Fix Central / ESS | Fix Pack 配信 / インストール媒体配布 | Fix Central から SP / Update を入手。VIOS 4.1 インストール媒体（DVD / Flash / ISO）は Entitled Systems Support (ESS) サイトから取得（Entitlement 要）。 | S20, S21, S18 |
| PowerVC | Power Cloud プロビジョニング | VIOS は PowerVC のストレージ／ネットワーク仮想化バックエンドとして稼働。RAW 形式 cloud-ready images / cloud-init は AIX 側で対応。 | S8 |
| IBM Tivoli Monitoring (ITM) | 監視（廃止済の連携） | VIOS 4.1.x 以降は ITM Agent を VIOS イメージに同梱しない。監視は HMC・代替 RMC ベースの仕組みへ移行。 | S23 |
| Resource Monitoring and Control (RMC) | HMC ↔ VIOS / クライアント LPAR の管理通信 | HMC からの『VIOS の更新』『各種 dynamic オペレーション』はアクティブな RMC 接続が前提。RMC が落ちている場合は HMC GUI が当該 VIOS を Update 候補から除外する。 | S15, S10 |
| AIX RBAC（VIOS 内部） | padmin の権限制御基盤 | VIOS 4.1.2.00 で mkitab/lsitab/rmitab/chitab および pvi（vios.file.read / vios.file.write）が RBAC 対応。setsecattr → setkst → pvi の順で /etc/syslog.conf 等の制限ファイルを編集。 | S25, S6 |
| OpenSSH / OpenSSL / IPsec / LDAP（AIX 由来） | セキュリティ基盤 | viosupgrade -g / viosbr で OpenSSH / OpenSSL / Kerberos 構成、LDAP クライアント設定、IPSec フィルタ・トンネルが新バージョンへ引き継がれる（VIOS 3.1.4.60 以降からの upgrade 時のみ完全保持）。 | S5, S23 |

