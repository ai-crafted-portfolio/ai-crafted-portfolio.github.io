# トラブル早見表

> 掲載：**21 件**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

| ID | 症状 | 原因 | 対処（要約） | ラベル | 関連手順 |
|---|---|---|---|---|---|
| ts-01 | SQLCODE -911 / -913（lock timeout / deadlock victim） | IRLMRWT 超過、または deadlock cycle 内の victim | victim を retry、頻発なら `-DISPLAY THREAD(*) DETAIL`、IRLM `F IRLMPROC,DIAG,DEADLOCK` で解析。長時間ロック保持アプリの commit 頻度見直し | `-911 / -913 / DSNT500I` | [inc-lock-timeout](09-incident-procedures.md#inc-lock-timeout), [inc-deadlock](09-incident-procedures.md#inc-deadlock) |
| ts-02 | SQLCODE -904（resource unavailable） | NUMLKUS 超過、disk full、lock structure 枯渇 | reason code で資源特定（00C90088 = NUMLKUS、00C200A8 = lock structure full 等）。NUMLKUS 拡大、lock granularity 見直し | `-904 / DSNT408I` | [inc-lock-escalation](09-incident-procedures.md#inc-lock-escalation) |
| ts-03 | SQLCODE -805（DBRM/package not found in plan） | PACKAGE 不在、PKLIST 漏れ、collection 不一致 | SYSPACKAGE で存在確認、BIND PACKAGE / BIND PLAN PKLIST で再構成 | `-805 / DSNT408I` | [inc-package-notfound](09-incident-procedures.md#inc-package-notfound) |
| ts-04 | SQLCODE -204（object not found） | object 名 typo、SQLID 不一致、object drop 済 | `SET CURRENT SQLID` 確認、SYSTABLES で存在確認、access path 上の qualifier も再確認 | `-204` | [inc-package-notfound](09-incident-procedures.md#inc-package-notfound) |
| ts-05 | SQLCODE -551 / -552（privilege not held） | 必要権限が GRANT されていない、SECONDARY ID で取得していない | `SELECT * FROM SYSIBM.SYSTABAUTH WHERE GRANTEE='...'` で権限確認、GRANT で付与 | `-551 / -552` | [cfg-grant-permission](08-config-procedures.md#cfg-grant-permission) |
| ts-06 | アクティブログ満杯（DSNJ110E / DSNJ111E） | アーカイブ stalled（媒体不足、DASD full、TAPE drive 不足）| `-DISPLAY LOG`、`-DISPLAY ARCHIVE`、archive 宛先 disk/tape 確保。DSN6ARVP の UNIT と空き状況確認 | `DSNJ110E / DSNJ111E` | [inc-log-archive-fail](09-incident-procedures.md#inc-log-archive-fail) |
| ts-07 | テーブル空間 RESTP / CHKP 状態 | LOAD / REORG 後の post-processing 未完、ABEND 残骸 | `-DISPLAY DATABASE RESTRICT` で対象特定、CHECK DATA / RECOVER / -START DATABASE ACCESS(FORCE) で解除 | `RESTP / CHKP / RECP` | [inc-restp-recovery](09-incident-procedures.md#inc-restp-recovery) |
| ts-08 | テーブル空間損傷（IDC3009I / DSNI031I） | DASD I/O エラー、catalog inconsistency、power loss 後の不整合 | `-DISPLAY DATABASE RESTRICT`、SYSCOPY 確認、RECOVER TOLOGPOINT または最新 image copy から RECOVER | `DSNI031I / DSNI012I` | [inc-tablespace-corrupt](09-incident-procedures.md#inc-tablespace-corrupt) |
| ts-09 | DDF 接続不可（remote から CONNECT 失敗） | DDF 停止、port 競合、firewall、DRDA バージョン不一致 | サーバ側 `-DISPLAY DDF`、`-START DDF`、TCP port（既定 446）、SYSIBM.LOCATIONS、netstat | `DSNL004I / SQL30081N` | [inc-ddf-down](09-incident-procedures.md#inc-ddf-down) |
| ts-10 | DBAT 枯渇（QUEDBAT 増、INADBAT 高） | MAXDBAT/CONDBAT 不足、CMTSTAT=ACTIVE で接続が hold される | `-DISPLAY DDF DETAIL`、CMTSTAT=INACTIVE 化、IDTHTOIN 短縮、MAXDBAT 拡大 | `DSNL031I` | [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup) |
| ts-11 | indoubt thread が残る（再起動後も `-DISPLAY THREAD TYPE(INDOUBT)` で出る） | 2-phase commit 中の coordinator との通信断 | LUWID で coordinator 側の決定（COMMIT/ABORT）と突合、`-RECOVER INDOUBT(...) ACTION(COMMIT|ABORT)` | `DSNL435I` | [inc-indoubt-thread](09-incident-procedures.md#inc-indoubt-thread) |
| ts-12 | ユーティリティが進まない（PHASE が長時間同じ） | resource 待ち（lock / log / DASD）、SHRLEVEL CHANGE で drain 待ち | `-DISPLAY UTILITY` で phase / count、`-DISPLAY THREAD(*)` で待ち先確認、TIMEOUT で停止後 RESTART | `DSNU100I` | [inc-utility-stuck](09-incident-procedures.md#inc-utility-stuck) |
| ts-13 | BIND / REBIND で SQLCODE -727 / -8002（applcompat） | APPLCOMPAT が許容 SQL 機能と不整合（古い APPLCOMPAT で新機能 SQL を BIND） | `-DISPLAY GROUP DETAIL` で Function Level、APPLCOMPAT を BIND 句で適切な値（V13R1 等）に | `-727 / -8002` | [cfg-applcompat-set](08-config-procedures.md#cfg-applcompat-set) |
| ts-14 | バッファプール hit ratio が低い | VPSIZE 不足、シーケンシャル中心で BP 競合、PGSTEAL 不適 | `-DISPLAY BUFFERPOOL DETAIL` で statistics、VPSIZE 増、用途別に BP 分離（OLTP / 大量バッチ別） | `—` | [cfg-bufferpool-tune](08-config-procedures.md#cfg-bufferpool-tune) |
| ts-15 | RUNSTATS 後にアクセスパス劣化 | 統計更新で optimizer が別 access path を選択 | REBIND PACKAGE APREUSE(WARN/ERROR)、または STATISTICS PROFILE で stable 統計 | `—` | [cfg-runstats-schedule](08-config-procedures.md#cfg-runstats-schedule) |
| ts-16 | SQL DI（FL501）の AI 関数で SQLCODE -20471 等 | SQL DI 未有効（FL501 未活性、または学習未完）、対象表が未登録 | `-DISPLAY GROUP DETAIL` で FL 確認、SYSAIDB / SYSAIOBJECTS で model 状態確認、再学習 | `-20471 / -20472` | [cfg-sqldi-enable](08-config-procedures.md#cfg-sqldi-enable) |
| ts-17 | TRACE 取得不可（出力 SMF が空 / `-START TRACE` で IFCID 拒否） | TRACE class 設定不足、SMF type 100/101/102 が SMFPRMxx で記録対象外 | `-DISPLAY TRACE`、SMFPRMxx 修正、`-START TRACE(MON,STAT,ACCTG) CLASS(...)` で再起動 | `DSNW130I` | [cfg-audit-trace](08-config-procedures.md#cfg-audit-trace) |
| ts-18 | catalog の整合性問題（カタログ構造起因の anomaly） | CATMAINT 失敗の残骸、catalog level mismatch | `-DISPLAY GROUP DETAIL` で CATALOG LEVEL / FUNCTION LEVEL、CATMAINT 再実行（適切な FL 指定） | `DSNT408I（catalog level 関連）` | [cfg-functionlevel-activate](08-config-procedures.md#cfg-functionlevel-activate) |
| ts-19 | データ共用 GBP castout 遅延 / GBP 枯渇 | CF GBP size 不足、castout owner の writer 不足 | `-DISPLAY GROUPBUFFERPOOL`、CFRM policy で GBP size 拡大、CASTOUT thread 増設 | `DSNB325I / DSNB341I` | [cfg-datasharing-add-member](08-config-procedures.md#cfg-datasharing-add-member) |
| ts-20 | BSDS 損傷（DSNJ100I / DSNJ107I） | I/O エラー、誤った直接編集 | dual BSDS の片方から復元（DSNJU003 CHANGE LOG INVENTORY）、catalog 上の SYSCOPY と整合性確認 | `DSNJ100I / DSNJ107I` | [inc-bsds-corrupt](09-incident-procedures.md#inc-bsds-corrupt) |
| ts-21 | SQLCODE -922（authorization failure / connection failure） | RACF 認証 NG、Db2 接続権限不足、SECURITY (AUTH) 系 DSNZPARM 不整合、PASSWORD/PASSTICKET 失敗、DDF 接続元の SAF mapping 不在 | reason code で原因特定（後述表）→ SAF/RACF 側で確認 + Db2 SECURITY 系 DSNZPARM 確認。DDF 経由なら `-DISPLAY THREAD` の rc / DSNL031I/DSNL511I も併読 | `-922 / DSNT408I / DSNL031I` | [inc-auth-fail](09-incident-procedures.md#inc-auth-fail) |

### SQLCODE -922 reason code 早見表

`-922` は SQL の authentication / authorization 失敗の汎用コード。reason code（DSNT408I / SQLCA の sqlerrmc）で具体原因を特定する。

| Reason code | 意味 | 第一手 |
|---|---|---|
| `00F30040` | RACF passticket 検証失敗 | KEYR の鍵共有ずれ確認、time skew 確認 |
| `00F30041` | RACF user ID + password 検証失敗 | RACF passwd 期限・LIST USER 確認、`-DISPLAY THREAD` で接続経路特定 |
| `00F30083` | DDF からの接続で SAF/EIM mapping なし | SYSIBM.USERNAMES、Trusted Context、AT-TLS、AUTHEXIT_CHECK の値再確認 |
| `00F30085` | DBADM/SYSADM 権限不足、または `RESTRICT WHEN ALTERED` 違反 | DSN6SPRM の AUTHCACH、SECURITY 系 DSNZPARM、SYSTABAUTH/SYSPLANAUTH 確認 |
| `00F300xx`（汎用） | その他の認可失敗（GRANT 不在、role 不足） | `-DISPLAY THREAD(*) DETAIL` の AUTHID と SYSIBM.SYSAUTH 系で突合 |

詳細は IBM 公式 Codes（DSNCODES）を参照。本表は代表 reason のみ抜粋。
