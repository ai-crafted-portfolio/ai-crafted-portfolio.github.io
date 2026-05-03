# IBM Spectrum Protect 8.1 — 関連製品連携

IBM Spectrum Protect 8.1 — 関連製品連携／依存関係

| 連携先製品 | 連携の種類 | 設定要点 | 出典 |
|---|---|---|---|
| IBM Db2（サーバ DB として同梱） | 内部依存 | Spectrum Protect Server インストール時に Db2 インスタンスが自動構成される。Db2 instance owner directory および DB／log 配置 FS の NOSUID は無効化必須。db2start で起動確認、停止は dsmserv halt 経由が原則（直接 db2stop 非推奨） | S6 |
| IBM Cloud Object Storage（COS） | ストレージ階層 | cloud-container storage pool の保管先。CLOUDTYPE／CLOUDURL／IDENTITY／PASSWORD 等を DEFINE STGPOOL に指定。地理分散・暗号化・REST API。inline dedup／inline compression を併用しエグレス費用を抑制 | S5 |
| VMware vSphere（vStorage API／VMware vCenter Server） | VM バックアップ（IBM Spectrum Protect for VE） | Data Protection for VMware を介して vCenter／vSphere とプロキシ統合。VM レベルのスナップショット連携、Datacenter／Datastore／Virtual Machine 単位での復旧。BA Client の include／exclude も VM ファイルストレージに対応 | S5, S16 |
| Microsoft Hyper-V（Windows 2012 以降） | VM バックアップ | BA Client の Hyper-V 統合機能および Data Protection for Microsoft Hyper-V によりホストレベルでの VM バックアップ。CSV（Cluster Shared Volume）対応 | S16 |
| HCL Domino／Microsoft Exchange Server | メールアプリケーションバックアップ | IBM Spectrum Protect for Mail 経由（Data Protection for HCL Domino／Microsoft Exchange Server）。アプリ整合性スナップショット、ログトランケーション連携、メールボックス単位リストア | S5 |
| Microsoft Active Directory／IBM Security Verify Directory（LDAP） | 認証連携 | AUDIT LDAPDIRECTORY コマンドで Spectrum Protect 制御下の LDAP namespace を監査。LDAP サーバとの通信は TLS で保護。ノード／管理者の認証を AD／LDAP 側に委譲可能 | S3, S5 |
| GPFS（IBM Spectrum Scale） | 共有ファイルシステム／LAN-Free | Storage Agent 経由で GPFS 共有 FS にクライアントから直接書き込み（LAN-Free）。GPFS クラスタ内の複数クライアントを単一 client node 配下に集約可能 | S5 |
| IBM Tape Libraries（TS3500／TS4500／TS7700／3494／ACSLS） | テープ装置 | DEFINE LIBRARY／DEFINE DRIVE／DEFINE PATH／LABEL LIBVOLUME／CHECKIN LIBVOLUME で構成。3494 共有は 3494SHARED=YES、ACSLS は ACSACCESSID／ACSLOCKDRIVE で指定。MOVE DRMEDIA でオフサイト管理 | S3, S13 |
| Storage Agent（IBM Spectrum Protect for SAN 同梱） | LAN-Free データパス | クライアント側に dsmsta を配置し、SAN 経由でテープ／GPFS に書き込み。Server は library manager。GENERICTAPE は対象外。dsm.sys に LANFREECOMMMETHOD 等を追記 | S5, S16 |
| NDMP（NAS バックアップ） | NAS 装置との連携 | BACKUP NODE／RESTORE NODE 等を用い、NDMP プロトコルで NAS ファイラ（NetApp／IBM 等）を直接バックアップ。filer ↔ tape の dump 経路と filer ↔ Spectrum Protect Server の制御経路を分離 | S3, S5 |
| Application Programming Interface（dsmapi） | アプリ統合 | TDP for SAP HANA／Oracle／Db2、自社製 ISV ツールが dsmInit／dsmSendObj／dsmGetObj 等で Spectrum Protect inventory に直接書き込み・読み出し。BA Client と同じ管理クラス・policy 配下で運用可能 | S1 |
| Operations Center（Hub／Spoke） | 監視 GUI | 1 つの Hub サーバから複数 Spoke を CONFIGURE OC 等で登録、HTTPS（既定 11090）でブラウザアクセス。アラート集中監視。cert.kdb 必要 | S5 |
| Replication Target Server（Spectrum Protect 同士） | サーバ間複製 | DEFINE SERVER で双方向にサーバ登録、SET REPLSERVER で複製方向確定、REPLICATE NODE で実行。directory-container PROTECT STGPOOL を併用すると効率改善 | S3, S5 |
| PowerHA SystemMirror／RHEL HA add-on／WSFC | サーバ HA クラスタ | Spectrum Protect Server をクラスタ化し、Db2／共有ストレージ／仮想 IP をクラスタリソースとしてフェイルオーバー。Active log／Archive log／DB を共有 LV 上に配置 | S6, S7 |
| Disaster Recovery Manager (DRM)／オフサイト Vault | オフサイト保管 | DRM 機能（Extended Edition）で MOVE DRMEDIA／PREPARE／Recovery Plan File を生成。SET DRMVAULTNAME／SET DRMCOURIERNAME 等で運搬手順を文書化 | S3 |

