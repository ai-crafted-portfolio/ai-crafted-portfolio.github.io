# トラブル早見表

> 掲載：**20 件**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

| ID | 症状 | 原因 | 対処（要約） | ラベル | 関連手順 |
|---|---|---|---|---|---|
| ts-01 | システムが IPL しない（LOAD パラメータ後 hang） | LOADxx 不正、IODF 不一致、PARMLIB チェーン破綻 | LOAD パラメータで別 LOADxx 指定、または別 IODF で IPL。詳細: inc-ipl-fail | `—（IPL コンソール上のメッセージ）` | [inc-ipl-fail](09-incident-procedures.md#inc-ipl-fail) |
| ts-02 | WTOR 大量で応答待ち、システム進まない | サブシステム起動失敗、I/O エラー等で複数 WTOR 蓄積 | D R,L で全 WTOR 表示。各 WTOR の意味確認後 R <id>,<reply> | `（各種 WTOR）` | [inc-wtor-response](09-incident-procedures.md#inc-wtor-response) |
| ts-03 | JES2 SPOOL 使用率 95% 超で SHORT | 完了済ジョブ未パージ、出力未印刷、ジョブ大量 | $D Q で確認、$P J<n> で不要ジョブ削除、SDSF ST/H で OUTPUT/HARDCOPY 整理 | `$HASP050 SHORT ON SPOOL SPACE` | [inc-jes2-spool-full](09-incident-procedures.md#inc-jes2-spool-full) |
| ts-04 | ジョブが ABEND（S0C4 / S0C7 / S322 / B37 等） | プログラムエラー、データセット領域不足、CPU 時間超過 | SDSF ST → S でジョブ詳細、SYSOUT で ABEND コード詳細確認、IPCS で SVC dump 解析 | `S0C4 / S0C7 / S322 / B37 等` | [inc-job-abend](09-incident-procedures.md#inc-job-abend) |
| ts-05 | ページング枯渇（PLPA, COMMON, LOCAL） | ワークロード過大、ページデータセット容量不足 | D ASM で確認、PAGEADD で動的追加、または不要 STC 停止 | `ILR005E AUXILIARY STORAGE SHORTAGE` | [inc-paging-shortage](09-incident-procedures.md#inc-paging-shortage) |
| ts-06 | RACF アクセス拒否（ICH408I） | ユーザに必要 ACCESS 権限なし、PROFILE が discrete でカバー外 | RLIST で profile 確認、PERMIT で権限付与、refresh （必要なら） | `ICH408I` | [inc-racf-access-denied](09-incident-procedures.md#inc-racf-access-denied) |
| ts-07 | SMF レコードが取得されない | SMFPRMxx の TYPE 指定漏れ、SMF データセット FULL | D SMF で現状確認、SETSMF で動的変更、DUMP で空ける | `IFA040E` | [inc-smf-collect-fail](09-incident-procedures.md#inc-smf-collect-fail) |
| ts-08 | Sysplex 分断（XCF 通信断） | CDS 障害、CF 障害、ネットワーク断 | D XCF,COUPLE で状態確認、SETXCF で対処 | `IXC101I, IXC102I 等` | [inc-sysplex-split](09-incident-procedures.md#inc-sysplex-split) |
| ts-09 | TCP/IP 通信不能 | TCPIP STC 停止、PROFILE.TCPIP 設定不正、OSA リンク断 | D TCPIP, NETSTAT HOME, NETSTAT DEV で診断 | `EZA*, EZD*` | [inc-tcpip-down](09-incident-procedures.md#inc-tcpip-down) |
| ts-10 | USS マウント FS が満杯 | zFS aggregate 容量不足 | df -k で確認、zfsadm grow で拡張、または不要ファイル削除 | `—` | [inc-uss-fs-full](09-incident-procedures.md#inc-uss-fs-full) |
| ts-11 | ジョブが INIT 状態で進まない | JES2 イニシエータ不足、対象 CLASS の Initiator 全て busy | $DI でイニシエータ状態確認、$S I,CLASS=x で追加起動 | `—` | [inc-jes2-spool-full](09-incident-procedures.md#inc-jes2-spool-full) |
| ts-12 | STC（Started Task）が hung | STC 内部デッドロック、I/O 待ち | DA → S で詳細、DUMP で SVC dump 取得、P/C で停止 | `—` | [inc-stc-hung](09-incident-procedures.md#inc-stc-hung) |
| ts-13 | OPERLOG / SYSLOG 取得不全 | LOGREC FULL、Logger 設定不正 | D OPERLOG で状態確認、IFASMFDP / IXGCONN で対処 | `IXG231I, IFB050I` | [inc-syslog-investigation](09-incident-procedures.md#inc-syslog-investigation) |
| ts-14 | VSAM open エラー（IDC3009I） | Catalog 不整合、share option 違反、容量不足 | LISTCAT で構造確認、IDCAMS REPRO で回復、share オプション再設定 | `IDC3009I` | [inc-vsam-open-fail](09-incident-procedures.md#inc-vsam-open-fail) |
| ts-15 | PARMLIB 変更後 IPL 失敗 | syntax エラー、必須パラメータ漏れ、PARMLIB チェーン破綻 | 別 LOADxx 指定で IPL、SYS1.PARMLIB を直前バックアップから復元 | `—（NIP メッセージ）` | [inc-ipl-fail](09-incident-procedures.md#inc-ipl-fail) |
| ts-16 | コンソール応答なし（hung） | MASTER コンソール障害、CONSOLE STC hung | 代替コンソールから VARY CN コマンド、必要なら EMCS 経由 | `IEA404A` | [inc-console-hung](09-incident-procedures.md#inc-console-hung) |
| ts-17 | SMP/E APPLY 失敗 | 依存 PTF 不足、HOLDDATA 警告、target zone 容量不足 | ++HOLD 確認、prerequisite PTF を APPLY GROUPEXTEND | `GIM*` | [inc-smpe-apply-fail](09-incident-procedures.md#inc-smpe-apply-fail) |
| ts-18 | TCPIP HOME IP 重複 | PROFILE.TCPIP の HOME ステートメント重複定義 | VARY TCPIP,,OBEYFILE で修正版適用、または TCPIP STC 再起動 | `EZZ4327I` | [cfg-tcpip-profile](08-config-procedures.md#cfg-tcpip-profile) |
| ts-19 | GRS Latch contention（D GRS,LATCH,C） | ENQ holder の長時間保持、デッドロック | D GRS,LATCH,C で contender 表示、原因 STC を P/C | `ISG343I` | [inc-stc-hung](09-incident-procedures.md#inc-stc-hung) |
| ts-20 | WLM Service Class が discretionary に転落 | Goal 達成不能、CPU リソース不足 | WLM ISPF で Service Class 定義見直し、Importance 調整 | `—` | [cfg-wlm-policy](08-config-procedures.md#cfg-wlm-policy) |
