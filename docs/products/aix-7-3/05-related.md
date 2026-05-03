# AIX 7.3 — 関連製品連携

AIX 7.3 — 関連製品連携 / 依存関係

| 連携先製品 | 連携の種類 | 設定要点 | 出典 |
|---|---|---|---|
| PowerHA SystemMirror（RSCT 3.3.0.0 ベース） | 高可用性クラスタ（HA） | AIX 7.3 同梱の RSCT 3.3.0.0 上で稼働。Cluster Aware AIX リポジトリディスクを共有（TL3 から NVMe 対応）。VSD/LAPI 廃止に注意 | S34, S35, S6 |
| PowerVM (LPAR / DLPAR) | ハードウェア仮想化 | HMC からリソース動的増減。AIX 7.3 では HMC ベース LKU で TL3 から動的拡張対応。Live Partition Mobility (LPM) 利用時は cthags critical resource monitoring に注意 | S35, S72 |
| HMC (Hardware Management Console) | プラットフォーム管理コンソール | LPAR 構成・I/O slot 確認（144 slot 制約）・LKU トリガ・PowerHA との連携 | S35 |
| IBM Db2 11.1 FP5 | データベース | AIX 7.3 base media 同梱。Db2 10.5 / 10.1 / 9.7 から FP5 へアップグレード可（Upgrade to Db2 Version 11.1 ガイド参照） | S35 |
| IBM Security Verify Directory (旧 ISDS) v10.0 | ディレクトリサービス（LDAP） | TL2 で同梱、ISDS 6.4.0.25 → ISVD 10.0.0.1 へ upgrade。ISDS 6.4 EOS 2024年9月。Microsoft Active Directory 経由（SFU plug-in なし）の連携も TL3 で対応 | S34, S35 |
| Spectrum Scale（旧 GPFS） | 分散ファイルシステム / クラスタ FS | RSCT VSD/LAPI 廃止により VSD ベースの 3rd party 製品は Spectrum Scale へ置換が必要 | S35 |
| IBM Cloud Hyper Protect Crypto Services (HPCS) | クラウド HSM / 鍵管理 | AIX Key Manager / 暗号化LV/PV と連携 | S35 |
| Java 8 64-bit (java8_64) | Java ランタイム | AIX 7.3 base media に同梱、Java 6/7 は不同梱。/etc/environment PATH に java8_64 を含む | S35 |
| Python 3.9 / 3.11 | スクリプト言語 | Python 3.9 が既定（python3.9.base、上書き install で導入）。Python 3.11 は python3.11.base、pip 別途、ensurepip なし、--without-pip 必須 | S35 |
| OpenSSL 3.0.x / OpenSSH 9.7p1 | セキュア通信ライブラリ | TL3 SP1 = OpenSSL 3.0.15.1001 + OpenSSH 9.7p1 (OpenSSL 3.0.13 でビルド)。Power11 In-core 性能最適化 | S35 |
| PowerVC | クラウドプロビジョニング | RAW 形式 cloud-ready images に cloud-init 同梱。qcow2 形式は AIX 7.3 で廃止。TL3 で nimadm による複数 LPAR 並列マイグレーション対応 | S35 |
| Electronic Service Agent (ESA) | リモートサポート（コールホーム） | esagent fileset 同梱。HMC との連携も可 | S14 |
| CCA Cryptographic Coprocessor 4765 / 4767 | ハードウェア暗号アダプタ | cca4765_en / cca4767_en fileset 群。PCIe Crypto Coprocessor、PKS / AIX Key Manager との併用 | S4, S5 |
| IBM Workload Scheduler (z/OS 連携) | ジョブスケジューリング | EQQX9AIX exit を介して z/OS controller ↔ AIX tracker 通信。EQQEVPGM で job status を controller へ報告 | S35 |
| RDMA / RoCE | 高速ネットワーク | rdma_en fileset。InfiniBand 5283/5285 アダプタは AIX 7.3 で非サポートのため要件確認必須 | S29, S35 |
| DNF（AIX Toolbox） | RPM パッケージマネージャ | YUM 非サポート。DNF を AIX Toolbox から導入して RPM 管理 | S35 |

