# z/OS システムプログラミング (ABCs) — 関連製品連携

Vol 横断の関連製品・サブシステム連携

Sysprog が関わる主要サブシステム同士が ABCs シリーズ内でどう連携・依存しているかを整理。 ABCs では深掘りされない外部製品（Db2, IMS, CICS, MQ など）は本表に列挙しない。

| 連携テーマ | 登場サブシステム | 主担当 Vol | 従担当 Vol | 連携の概要 | 出典 |
|---|---|---|---|---|---|
| JES2 ⇄ SDSF | JES2, SDSF, Output Subsystem | Vol 2 | Vol 1, Vol 8 | Vol 2 Ch3 で JES2 Job/Output 管理を解説、Vol 1 Ch3 で SDSF の使い方、Vol 8 Ch9 で SDSF/RMF 並用診断手順。Sysprog の毎日のオペは SDSF DA/SR/H の循環。 | S2, S1, S8 |
| SMP/E ⇄ DFSMS | SMP/E, SMPCSI, SYS1.LINKLIB, DFSMShsm | Vol 2 | Vol 3 | SMP/E ZONE は VSAM KSDS（DFSMS 配下）として配置・バックアップ。SYSMOD Apply 後の LNKLST/LPA refresh は Vol 2 Ch4 を参照。 | S2, S3 |
| RACF ⇄ USS | RACF Profile, OMVS Segment, UNIXPRIV, FACILITY | Vol 6 | Vol 9 | RACF User Profile に OMVS Segment（uid/home/program）が必須。UNIXPRIV Class で superuser 相当権限を最小化。Vol 9 Ch6 と Vol 6 Ch3 を併読。 | S6, S9 |
| Sysplex ⇄ WLM | WLM, CFRM, Sysplex-wide Service Class, IRD | Vol 5 | Vol 11, Vol 12 | WLM Service Definition は Sysplex 単位で適用、CFRM が CF を制御。IRD で LPAR 重みを自動再配分する場合は WLM-PR/SM 連携が必要。 | S5, S11, S12 |
| Logger ⇄ RRS / OPERLOG | System Logger, RRS, OPERLOG, LOGREC, CICS/Db2 | Vol 5 | Vol 8 | OPERLOG / LOGREC は Logger Logstream で運用、RRS の RM data も Logger に保存。Logger 障害は連鎖的に多サブシステムへ影響するため Vol 5 Ch2 必読。 | S5, S8 |
| TCP/IP ⇄ AT-TLS / RACF | TCP/IP, Policy Agent, AT-TLS, RACF DIGTCERT, ICSF | Vol 4 | Vol 6 | AT-TLS は Policy Agent + RACF Certificate + ICSF の 3 レイヤを跨ぐ。Vol 4 Ch3 と Vol 6 Ch4 (Integrated Security Services) を組み合わせ参照。 | S4, S6 |
| Infoprint ⇄ USS | Infoprint Server, AOPSTART, USS daemon, JES Spool | Vol 7 | Vol 9 | Infoprint Server は USS daemon (aopstart) として常駐、JES Spool への取り込みは Print Interface 経由。USS 環境（BPXPRMxx）が前提。 | S7, S9 |
| HCD ⇄ HMC / SE | HCD ダイアログ, IOCDS, HMC Activate, IODF | Vol 10 | Vol 2 | HCD で生成した IODF を HMC 側 IOCDS に書き込み、Activate で z/OS PROD IODF を切替。Sysprog は LOADxx の IODF= keyword を Vol 2 で確認。 | S10, S2 |
| RMF ⇄ SMF ⇄ WLM | RMF Mon I/II/III, SMF Type 70-79, WLM Service Class | Vol 11 | Vol 12, Vol 8 | RMF Mon I は SMF を介してバッチ後処理、Mon III は SMF 経由なしの即時データ。WLM の Service Class 単位サマリは Mon III の SYSWKM/SYSCFC で見る。 | S11, S12, S8 |
| GDPS ⇄ Sysplex / DASD Mirroring | GDPS/PPRC, GDPS/HM, CF mirror, DS8000 PPRC | Vol 5 | Vol 10 | GDPS/PPRC は Sysplex 構成（CFRM, SFM, Logger）と DS8000 PPRC を統合制御。Vol 5 Ch7 で概念、DS8000 接続は Vol 10 Ch3 で。 | S5, S10 |
| GRS ⇄ Catalog / VSAM | GRS, ENQ/DEQ, ICF Master Catalog, VSAM RLS | Vol 5 | Vol 3 | Sysplex 内データセット共用は GRS Star + ICF Master Catalog 共用が前提。VSAM RLS は別系統だが GRS contention の影響を受ける。 | S5, S3 |
| ICSF ⇄ PKI Services / RACF | ICSF, PKI Services, RACF DIGTCERT, CCA | Vol 6 | — | PKI Services が発行する証明書の鍵は ICSF（CKDS/PKDS）に保管され、RACF DIGTCERT で User/Server に紐付け。Vol 6 Ch3-Ch5 を一連で参照。 | S6 |

