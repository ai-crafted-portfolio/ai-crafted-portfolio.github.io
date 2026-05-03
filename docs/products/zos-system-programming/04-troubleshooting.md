# z/OS システムプログラミング (ABCs) — トラブルシュート

Sysprog 視点の典型障害カテゴリ × 参照 Vol/章

Sysprog が遭遇する代表的な障害類型と、ABCs シリーズで対応する診断手順・解説章。 個別の WTOR メッセージや IPCS コマンド出力例の網羅は公式 'MVS System Messages' / 'IPCS Commands' を参照すること。

| 障害カテゴリ | 代表症状 | ABCs 参照 Vol/章 | Sysprog 初動 | 切り分け観点 | 出典 |
|---|---|---|---|---|---|
| IPL 失敗 | Wait State Code (WSC), IEA xxx Severe error, Catalog open failure | Vol 2 Ch1 (z/OS implementation) / Vol 8 Ch3 (Common problem types) | HMC 'IPL Information' で Wait State Code 確認 → MVS System Codes で意味解読 → LOADxx/SYS1.NUCLEUS 整合性確認。 | PARMLIB syntax / Master Catalog / DASD volser | S2, S8 |
| ABEND（System / User） | S0Cx / S0F4 / U2728 等 | Vol 8 Ch3（Common problem types）/ Ch4（Dump processing）/ Ch6（IPCS） | SDSF H / DA で出力確認 → SVC Dump があれば IPCS で SUMMARY/STATUS, VERBX LOGDATA → 該当製品の MVS System Codes 参照。 | PSW / TCB / Module loadlist | S8 |
| Sysplex 通信途絶 | IXC102I / IXC402I, ISGNQXIT 競合, GRS contention | Vol 5 Ch1（Sysplex）/ Ch4（GRS）/ Vol 8 Ch3 | D XCF, D GRS,C で contention 確認 → CFRM Policy / CF Structure 状態 → SFM ISOLATETIME 設定確認。 | CF link / SFM / Logger 連鎖障害 | S5, S8 |
| Logger 障害 | IXG251I / IXG252I, Offload 失敗, Staging DS フル | Vol 5 Ch2（System Logger） | D LOGGER,C / D LOGGER,L で Logstream 状態確認 → STAGING/Offload DS 容量・属性確認 → LOGGER address space 再起動可否判断。 | Logstream type / Coupling vs DS-only | S5 |
| RACF 認可失敗 | ICH408I, ABEND913, RACF Database I/O 失敗 | Vol 6 Ch3（RACF） | ICH408I の Class/Profile/User/Access を読み解き → RLIST/SEARCH で Profile 確認 → SETROPTS RACLIST REFRESH の必要性判定。 | Class active / Generic vs Discrete / RACLIST 鮮度 | S6 |
| ICSF / 暗号化エラー | CSF reason code, CKDS が Open しない, Master Key Mismatch | Vol 6 Ch5（Cryptographic Services） | D ICSF / CSFEUTIL で MK 状態 → CKDS/PKDS Re-encipher 履歴確認 → 必要に応じ Master Key Re-load。 | Pass Phrase Init / TKE / Coprocessor mode | S6 |
| ストレージ枯渇 / DASD I/O エラー | B14 ABEND, IEC036I, IEC614I | Vol 3 Ch4-5（DFSMS）/ Vol 8 Ch3 | ISMF Storage Group 利用率確認 → ACS routine の SG 振り分け再評価 → DFSMShsm Migration 状況点検。 | Storage Group / Volser / DSCB chain | S3, S8 |
| USS / zFS 障害 | BPXFxxxI, EZB Resolver Fail, zFS aggregate offline | Vol 9 Ch9（Managing file systems）/ Vol 9 Ch16（Performance, debugging, recovery） | D OMVS,F で MOUNT 状態 → zfsadm aggrinfo / lsaggr → BPXPRMxx の整合性 → ROOT 再 MOUNT 可否判定。 | Sysplex-aware mount / RWSHARE / zFS log | S9 |
| 印刷障害 | Infoprint Server stop, IP PrintWay 停止, JES Spool あふれ | Vol 7 Ch3-Ch6（Infoprint / IP PrintWay / NetSpool） | F AOPSTART/PRD ディスパッチ確認 → AOP ログ確認 → JES Spool の SPOOL OFFLOAD 退避要否判定。 | USS 起動状態 / WTRPRC / SAP 経路 | S7 |
| WLM 目標未達 | PI > 1.0 継続, Discretionary swap, Velocity 低下 | Vol 11 Ch2 + Vol 12 Ch3（WLM goal management） | RMF Mon III SYSWKM/Workload で Service Class ごと PI/Velocity 確認 → CPU 過負荷 vs I/O wait 判定 → WLM Policy 調整。 | PI / Velocity / Importance / Discretionary | S11, S12 |
| 性能急変・スパイク | RMF Mon III で CPU 100% / SRB high | Vol 11 Ch3（RMF）/ Vol 8 Ch9（SDSF and RMF） | RMF Mon III で CPU/Storage/IO のいずれが Bottleneck か特定 → SMF Type 30/72 等で時系列比較 → 起因 ASID 特定。 | Mon I vs III / SMF lag / Capture ratio | S11, S8 |
| TCP/IP 接続障害 | EZZ4202I, Stack lost, AT-TLS handshake fail | Vol 4 Ch3-Ch5 + Vol 6 Ch4 (Integrated Security Services) | D TCPIP,,N で Stack 状態 → Resolver/PROFILE.TCPIP 整合性 → Policy Agent ログ参照（AT-TLS の場合）。 | Resolver / OSA-Express / IDS | S4, S6 |
| HCD / I/O 構成不一致 | IOS xxx, Device offline, Channel fail | Vol 10 Ch3-Ch4 / Vol 8 Ch3 | D IOS,CONFIG で Active IODF 確認 → HCD で Pending Activate 状態 → IOS001-099 メッセージから Channel/PChid 特定。 | IODF active vs work / IOCDS / CHPID | S10, S8 |

