# IBM Workload Automation — トラブルシュート

IBM Workload Automation — 典型的な障害と対処

各エラーは Troubleshooting Guide / Release Notes / Administration の章別に整理。

| 症状 / メッセージ | 発生コンポーネント | 推定原因 | 対処手順 | 確認コマンド / ログ | 出典 |
|---|---|---|---|---|---|
| JnextPlan fails to start | MDM / Plan 生成 | pobox 既定 10MB が不足、ネットワーク要件と齟齬 | pobox サイズを基準に増加。pobox メッセージ滞留調査 (TWA_DATA_DIR/pobox/*.msg) | TWS log, JnextPlan stdout | S15 |
| JnextPlan fails: transaction log for the database is full | DB (DB2/Oracle/MSSQL) | DB トランザクションログサイズ不足 (一括更新時に発生) | DB のトランザクションログ容量を拡張 → 再実行。Oracle/DB2 で恒久対処を検討 | DB2 db2diag.log, Oracle alert log | S15 |
| JnextPlan fails: Java out-of-memory error | JnextPlan (Java) | プラン規模に対し Java heap が不足 | JnextPlan の JVM オプションで -Xmx を増加。並行 deploy frequency 見直し | JnextPlan log | S15 |
| JnextPlan fails - AWSJPL017E: The production plan cannot be created | MDM / Planner | preproduction plan が壊れている、stageman 直前に異常終了 | planman showinfo で破損確認 → optman の cf 設定見直し → 必要なら preproduction plan を再生成 | AWSJPL017E in MDM log, planman showinfo | S15 |
| JnextPlan fails with DB2 error: nullDSRA0010E | DB2 接続 | DB2 データソース接続障害、JDBC ドライバ不整合 | DB2 サービス確認 → datasource 再構成 → Liberty 再起動 → 再実行 | WebSphere Liberty FFDC, db2diag | S15 |
| Symphony file is corrupt on a lower level domain manager / FTA | FTA / Symphony | ファイル破損 (ディスク障害・強制停止) で Symphony / Sinfonia が読めない | 1) MDM 側で Symphony/Sinfonia/*.msg が一致していることを確認<br>2) MDM で当該 FTA を unlink<br>3) FTA 上の Symphony / Sinfonia / *.msg をリネーム退避<br>4) MDM の Symphony を Sinfonia として転送 (MDM → FTA)<br>5) FTA を再起動 → conman link で再リンク | conman unlink/link, ls -l Symphony Sinfonia | S15 |
| Fault-tolerant agents not linking to master domain manager | FTA / Network | MDM と FTA の TLS バージョン不一致 / 証明書不整合 / netman 停止 | 1) localopts ssl tls12 cipher と Liberty 側を一致<br>2) Root CA を FTA truststore に import<br>3) FTA 側 conman shut;wait → StartUp で netman 再起動<br>4) MDM 側 conman link <ws> でリンク確認 | conman ; sc, netman stdlist | S15, S33 |
| Agents not linking after first JnextPlan on HP-UX | HP-UX FTA | HP-UX 固有のネットワーク権限 / file descriptor 不足 | HP-UX のソケット/file desc を増加 → JnextPlan 再実行 → conman link | netman stdlist, ulimit -n | S15 |
| AWSITA245E - Agent is down but jobmanager is running | Dynamic Agent | JobManager プロセスは生きているが Agent コンポーネントが down | 1) ITA トレース (level=1000) を採取<br>2) JobManager.Logging.cclog のトレース確認<br>3) ResourceAdvisorConfig.properties / JobDispatcherConfig.properties の不整合修正<br>4) Agent 再起動 | JobManager.Logging.cclog, ITA トレース | S15, S7 |
| AWSITA104E Unable to perform the system scan | Dynamic Agent | SystemScanner が OS 情報取得不可 | SystemScanner プロパティ確認、OS 権限/プロセス制限を緩和、Agent 再起動 | SystemScanner log | S15 |
| Composer not authorized to access server error | Composer CLI | useropts の credential が古い / role-based security から外れた | composer の useropts を更新 → role/security 定義 (DWC > Manage workload security) を確認 | useropts, security file | S15 |
| Composer dependency error with interdependent object definitions | Composer / DB | オブジェクト間の循環参照、添字不整合 | 依存ツリーをトポロジ順に分割登録、composer add 順序を制御 | composer log | S15, S7 |
| Conman: AWSDEQ024E message is received on Windows | Conman (Windows) | DCOM / 権限不足 (Windows サービス LocalSystem ではないアカウント) | Windows サービスのログオンアカウント見直し → conman 再実行 | Windows event log | S15 |
| Conman: Job log not displayed | Conman / FTA | stdlist が writer 経由で MDM へ届いていない / 圧縮設定不整合 | wr enable compression を MDM/FTA で揃える、wr unlink 期間延長、stdlist 直接配置確認 | TWA_DATA_DIR/stdlist | S15 |
| Possible IWS compatibility issues with Liberty 24.0.0.8 or higher | DWC / Liberty | WebSphere Liberty 24.0.0.8 以上で SSL/OpenID 周りの非互換 | ssl_config.xml (configDropins/overrides) の twaSSLSettings に verifyHostname="false" を追記。V10.2.3 以降では恒久解消済み | Liberty messages.log | S33 |
| Switcheventprocessor で event rule が動作停止 | Event Processor | BMDM 側が back-level (V9.4) の場合の互換性問題 | BMDM を MDM と同一バージョンに揃える → switcheventprocessor 再実行 → planman deploy 再配布 | switcheventprocessor stdout | S33 |
| Solution Manager: Wrong filter for Job Monitoring setup | DWC Solution Manager | ワークステーションをフィルタとして指定すると Plan 検索結果ゼロになる | ワークステーション削除 / ワイルドカード指定で回避。本問題は workaround のみ | DWC log | S33 |
| Folder management limitations | Composer / DB | V9.5 由来のフォルダ管理制約 | 9.4 以前の agent からはフォルダ参照不可、folder 名/workstation 名 rename 後の旧 ID 引用不可 | composer li ws @;showid | S33, S11 |
| On AIX: 100+ 同時 job submit で core dump or resource temporarily unavailable | AIX FTA / Dynamic Agent | AIX のリソース上限 (proc/file) に達して fork 失敗 | AIX の ulimit / maxuproc を増加。AIX V10.2.3 以降は MDM 自体非対応のため計画移行も検討 | AIX errpt, syslog | S15, S34 |
| Cluster: IP validation error on Netman stdlist (Windows) | Windows Cluster | Cluster 切替時の仮想 IP と netman 設定の不整合 | twsClusterAdm で再構成、IP リソース順序確認、Cluster Administrator 拡張で resource dependency を整える | Netman stdlist (Windows) | S14 |
| Desktop heap size problems on workstations with more than three agents (Windows) | Windows OS | 1 ホストに 3 つ以上の Agent を入れた際の Windows desktop heap 不足 | 1) Windows レジストリで desktop heap (SubSystems\Windows) を増加<br>2) Windows サービスを Local System で起動<br>3) localopts に共有 desktop 名を設定して再利用<br>4) tws cluster 構成では twsClusterAdm の oprions を見直し | Windows registry, services.msc | S14 |
| z/OS Agent: tracking events が拾えない | Z Workload Scheduler Agent | EELUX000 / event writer の設定誤り、SMF パラメータ未更新 | Performing problem determination for tracking events 章 (12_Scheduling_Agent_zOS) の手順で MAXECSA / SMF / event writer ログを順に確認 | agent message log, SMF dump | S12, S19 |

