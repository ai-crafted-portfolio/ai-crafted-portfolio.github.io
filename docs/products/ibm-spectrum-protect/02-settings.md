# IBM Spectrum Protect 8.1 — 主要設定項目

IBM Spectrum Protect 8.1 — 主要設定項目（dsmserv.opt／dsm.opt／Policy）

サーバ側 dsmserv.opt、クライアント側 dsm.opt／dsm.sys、Policy（DEFINE COPYGROUP 等）の主要パラメータ。

| パラメータ名 | 設定ファイル／コマンド | 既定値 | 取り得る値 | 影響範囲（再起動要否・動的反映可否） | 関連パラメータ | 出典 |
|---|---|---|---|---|---|---|
| TCPPORT | dsmserv.opt（Server） | 1500 | ポート番号 | サーバ再起動で反映 | TCPADMINPORT、SSLTCPPORT、TCPWINDOWSIZE | S3 |
| TCPADMINPORT | dsmserv.opt | TCPPORT と同一 | ポート番号 | サーバ再起動で反映 | 管理セッション専用ポート | S3 |
| SSLTCPPORT | dsmserv.opt | 未設定（明示指定） | ポート番号 | サーバ再起動で反映、SSL／TLS 専用待ち受け | SSLFIPSMODE、SSLTCPADMINPORT、cert.kdb | S3 |
| COMMMETHOD | dsmserv.opt | TCPIP（プラットフォームに依存） | TCPIP／SHAREDMEM／NAMEDPIPE 等 | サーバ再起動で反映 | TCPPORT、SSL | S3 |
| ACTIVELOGSIZE | dsmserv.opt | 16,384（MB、初期値、構成ウィザード推奨） | 正の整数（MB） | サーバ停止 → dsmserv.opt 編集 → 再起動で反映 | ARCHLOGDIRECTORY、Recovery Log | S6 |
| ACTIVELOGDIRECTORY | dsmserv format／dsmserv.opt | （インスタンス作成時に指定） | ファイルシステムパス | サーバ停止／インスタンス再構成で変更 | ARCHLOGDIRECTORY、MIRRORLOGDIRECTORY | S6 |
| ARCHLOGDIRECTORY | dsmserv format／dsmserv.opt | （インスタンス作成時に指定） | ファイルシステムパス | サーバ停止／インスタンス再構成で変更 | ACTIVELOGDIRECTORY、Failover log | S6 |
| DBPATH（dsmserv format） | dsmserv format コマンド引数 | （インスタンス作成時に指定） | 1 つ以上のディレクトリパス（カンマ区切り） | インスタンス作成時のみ | Db2 instance、ACTIVELOGDIRECTORY | S6 |
| FFDCNUMLOGS | dsmserv.opt（Miscellaneous） | 10 | 整数 | サーバ再起動で反映 | First Failure Data Capture | S3 |
| FIPSMODE／SSLFIPSMODE | dsmserv.opt | NO | YES／NO | サーバ再起動で反映、認証ライブラリ全体に影響 | TLS、cert.kdb | S3 |
| KEEPALIVE | dsmserv.opt | YES | YES／NO | サーバ再起動で反映 | TCP セッションの keepalive | S3 |
| FSUSEDTHRESHOLD | dsmserv.opt | プラットフォーム既定 | 整数（％） | サーバ再起動で反映、FILE／Container プールの空き監視 | Storage Pool 警告 | S3 |
| 3494SHARED | dsmserv.opt | NO | YES／NO | サーバ再起動で反映 | 3494 ライブラリ共有 | S3 |
| ACSACCESSID／ACSLOCKDRIVE | dsmserv.opt | 未設定 | ACS access id／YES,NO | サーバ再起動で反映 | ACSLS ライブラリ | S3 |
| NODENAME | dsm.opt（Client） | ホスト名（未指定時） | 登録済みノード名 | クライアント次回起動時に反映 | REGISTER NODE、PASSWORDACCESS | S16 |
| TCPSERVERADDRESS／TCPPORT | dsm.opt／dsm.sys | — | サーバホスト名／IP、ポート番号 | クライアント次回起動時に反映 | Server TCPPORT | S16 |
| PASSWORDACCESS | dsm.opt／dsm.sys | PROMPT | PROMPT／GENERATE | クライアント再起動で反映、GENERATE は無人スケジュール必須 | TSM password file（NODENAME） | S16 |
| INCLEXCL（include／exclude） | dsm.opt（Windows）／include-exclude file（UNIX） | 明示指定（既定パターン） | include／exclude ステートメント | クライアント再起動／schedule 単位で反映 | Management Class bind | S16 |
| SCHEDMODE | dsm.opt／dsm.sys（または UPDATE NODE） | POLLING | POLLING／PROMPTED | クライアント再起動で反映、UPDATE NODE／SET SCHEDMODES でサーバ強制可 | QUERYSCHEDPERIOD、Client Acceptor | S16 |
| QUERYSCHEDPERIOD／SET QUERYSCHEDPERIOD | dsm.opt／SET QUERYSCHEDPERIOD | 12（時間） | 正の整数（時間） | クライアント再起動で反映、SET QUERYSCHEDPERIOD でサーバ全体強制可 | POLLING モード | S16 |
| SCHEDLOGNAME／SCHEDLOGRETENTION | dsm.opt | dsmsched.log（クライアントディレクトリ） | ファイルパス／日数 | 次回 schedule 起動時に反映 | Scheduler サービス | S16 |
| MANAGEDSERVICES | dsm.opt | 未指定（OS サービスとして直接起動） | SCHEDULE／WEBCLIENT／NONE | Client Acceptor 再起動で反映 | Scheduler、Web Client | S16 |
| DEFINE COPYGROUP（Backup） VEREXISTS／VERDELETED | DEFINE COPYGROUP TYPE=BACKUP | VEREXISTS=2、VERDELETED=1 | 1〜9999、NOLIMIT | ACTIVATE POLICYSET 後即時反映 | RETEXTRA、RETONLY、Management Class | S3 |
| DEFINE COPYGROUP（Backup） RETEXTRA／RETONLY | DEFINE COPYGROUP TYPE=BACKUP | RETEXTRA=30、RETONLY=60（日） | 0〜9999、NOLIMIT | ACTIVATE POLICYSET 後即時反映 | VEREXISTS、VERDELETED | S3 |
| DEFINE COPYGROUP（Archive） RETVER | DEFINE COPYGROUP TYPE=ARCHIVE | 365（日） | 0〜30000、NOLIMIT | ACTIVATE POLICYSET 後即時反映 | Management Class、SET ARCHIVERETENTIONPROTECTION | S3 |
| DEFINE COPYGROUP DESTINATION | DEFINE COPYGROUP | （policy 設計時に指定） | プライマリ storage pool 名 | ACTIVATE POLICYSET 後即時反映 | Storage Pool | S3 |
| SET ARCHIVERETENTIONPROTECTION | 管理コマンド | OFF | ON／OFF | コマンド即時反映 | Archive Retention、Policy Domain | S3 |
| SET DRMxxx 系（PRIMSTGPOOL／COPYSTGPOOL／VAULTNAME／RPFEXPIREDAYS 等） | DRM SET コマンド群 | 未設定（既定値あり） | ストレージプール名／名称／日数 | コマンド即時反映、PREPARE で RPF に反映 | PREPARE、MOVE DRMEDIA、QUERY RPFCONTENT | S3 |
| SET BKREPLRULEDEFAULT／SET ARREPLRULEDEFAULT | 管理コマンド | ALL_DATA | ALL_DATA／ACTIVE_DATA／NONE | コマンド即時反映、REPLICATE NODE で参照 | Node Replication、UPDATE NODE REPLSTATE | S3 |
| REGISTER NODE／UPDATE NODE オプション | REGISTER NODE／UPDATE NODE | — | PASSWORDEXPIRE／SESSIONINITIATION／TCPCLIENTADDR 等 | コマンド即時反映 | Policy Domain、SCHEDULE 関連付け | S3, S16 |
| DEFINE STGPOOL POOLTYPE／DEDUPLICATE | DEFINE STGPOOL | POOLTYPE=PRIMARY、DEDUPLICATE=NO（pool タイプ依存） | PRIMARY／COPY／RETENTION 等、DEDUPLICATE=YES／NO | コマンド即時反映 | Storage Pool、Container | S3 |
| PROTECT STGPOOL MAXProcess／SCANALL／SCANDamaged | PROTECT STGPOOL | — | 1〜99、SCANALL／SCANDAMAGED 等 | コマンド即時反映 | REPAIR STGPOOL、AUDIT CONTAINER | S3 |

