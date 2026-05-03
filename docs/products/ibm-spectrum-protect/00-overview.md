# IBM Spectrum Protect 8.1 — 概要

IBM Spectrum Protect 8.1 — 製品概要

本シートは ChromaDB 投入済みの IBM Spectrum Protect 8.1 マニュアル （10,539 chunks / 16 sources、全て英語版 PDF）から構造化抽出した製品サマリ。 各記述末尾の [SX] は出典 ID（06_出典一覧 を参照）。

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM Spectrum Protect 8.1.15（旧名 IBM Tivoli Storage Manager / TSM）  [S5] | S5 |
| ベンダ | IBM Corporation  [S5] | S5 |
| プロダクト番号 | 5725-W98 / 5725-W99 / 5725-X15（バージョン 8.1.15）  [S5] | S5 |
| 本資料が前提とするバージョン | 8.1.15（2022 年版マニュアル準拠。8.1.x ファミリの最終的な機能セットを反映）  [S5] | S5 |
| 対応サーバ OS | AIX、Linux（Red Hat Enterprise Linux / SUSE Linux Enterprise）、Microsoft Windows。Server プラットフォームごとに別 Installation Guide / Administrator's Reference を提供  [S6, S7, S8, S2, S4] | S6, S7, S8, S2, S4 |
| 対応クライアント OS | AIX、Linux、Solaris、HP-UX、Mac OS X、Windows（Backup-Archive Client）。UNIX/Linux 系と Windows 系で別 User's Guide を提供  [S14, S16] | S14, S16 |
| 製品の役割 | エンタープライズ向け統合バックアップ／アーカイブ／ディザスタリカバリ製品。 サーバ／クライアント／記憶媒体の 3 階層モデルでクライアントデータを集中管理し、 ディスク（directory-container / FILE / DISK）、テープ、Cloud Object Storage に階層化保存する。 進歩的増分（progressive incremental）バックアップ、インライン重複排除、 インライン圧縮、ノード複製（node replication）、Disaster Recovery Manager（DRM） により大規模環境でのデータ保護とリカバリを提供する。  [S5] | S5 |
| 想定読者 | バックアップ運用管理者、ストレージ管理者、データ保護設計者、災害対策担当者、IBM Spectrum Protect サーバ／クライアント運用 SE  [S5, S3] | S5, S3 |
| 典型的利用シーン | ファイルサーバ／DB／VM／メールアプリケーションの集中バックアップ、 法令・コンプライアンス向けの長期アーカイブ（archive retention protection）、 二拠点／三拠点間の node replication、ディザスタリカバリ計画（DRM）、 LAN-Free（SAN 経由）バックアップ、テープへの階層化保存、Cloud Object Storage への階層化保存。 単拠点ディスク重視構成（Single-Site Disk Solution）と多拠点重複排除構成（Multisite Disk Solution）の各リファレンス構成も IBM 公式ガイドで提供。  [S5, S13, S9, S12] | S5, S13, S9, S12 |
| 管理インタフェース | Operations Center（Web／モバイル GUI、複数サーバ統合監視）、 dsmadmc（コマンドライン管理クライアント）、SQL 管理インタフェース（SELECT 等）、 Backup-Archive Client GUI／CLI（dsmc）、API（dsmapi）。  [S5, S1] | S5, S1 |
| 主要バックアップ方式 | Progressive Incremental Backup（初回フル＋以降の差分のみ転送、 増分／差分バックアップに比べネットワーク帯域・ストレージ・処理時間を削減）。 選択／フル／インクリメンタル／イメージバックアップを補完的に提供。  [S5] | S5 |
| 重複排除・圧縮 | インライン重複排除（directory-container / cloud-container ストレージプール）、 クライアントサイド重複排除、インライン圧縮、クライアントサイド圧縮を提供。 重複排除済みデータは圧縮可能、圧縮済みデータは重複排除不可。 サーバは encrypted データを圧縮できない。  [S5] | S5 |
| ストレージ形態 | Disk（DISK／FILE／directory-container）、Tape（物理テープライブラリ・VTL）、 Cloud（IBM Cloud Object Storage 等の cloud-container）、NAS（NDMP）、SAN 共有テープ。 storage pool は階層化可能（disk → tape）。  [S5] | S5 |
| 認証・暗号化 | ノード認証はパスワード／SSL 証明書／LDAP（Microsoft Active Directory／IBM Security Verify Directory） を使用。サーバ⇔クライアント通信は TLS（旧 SSL）で保護。テープドライブハードウェア暗号化に対応。  [S5] | S5 |
| 高可用性・DR 機能 | Node Replication（ターゲットサーバへの非同期複製）、 Container-Copy Storage Pool（directory-container のコピー保護、テープ書き出し可）、 Disaster Recovery Manager (DRM)（テープ環境向け復旧計画自動生成、Extended Edition のみ）、 DB Backup／Storage Pool Backup、Active Log のミラーリング。  [S5, S3] | S5, S3 |
| ライセンス形態 | Standard Edition（Server＋BA Client、基本機能）／Extended Edition（DRM・NDMP 等を追加）／for SAN（Storage Agent による LAN-Free 機能を追加）／for VE（VMware／Hyper-V）／for Mail／for Databases などのアドオンモジュール  [S5] | S5 |
| ドキュメント形態 | Concepts／Installation（OS 別）／Administrator's Reference（OS 別）／BA Client（Windows・UNIX/Linux）／API／Solutions（Single-Site Disk・Multisite Disk・Tape）／Performance Tuning／Server Messages／BA Client Messages の各 PDF（V8.1.15 時点 16 文書）  [S5] | S5 |
| 関連製品（密結合） | IBM Db2（サーバ DB エンジンとして同梱）、IBM Spectrum Protect Plus（VM／コンテナ向け補完製品）、IBM Cloud Object Storage、PowerHA／RHEL HA add-on（HA クラスタ）、VMware vSphere（vStorage API）、Microsoft Active Directory／IBM Security Verify Directory（LDAP 認証）、IBM Tape Libraries（TS3500／TS4500／TS7700）、Storage Agent（LAN-Free）  [S5, S6] | S5, S6 |

