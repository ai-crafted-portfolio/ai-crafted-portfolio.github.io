# マニュアル参照マップ

> 掲載：**22 テーマ（全 URL 必須）**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

| テーマ | 公式マニュアル | 参照章 | 出典 |
|---|---|---|---|
| 概要・新機能 | [z/OS 3.1 What's New](https://www.ibm.com/docs/en/zos/3.1.0?topic=overview-whats-new) | 新機能・変更点 | S_ZOS_WhatsNew |
| システム初期化（IPL） | [MVS Initialization and Tuning Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=mvs-initialization-tuning-reference) | IPL / NIP / PARMLIB members 全部 | S_ZOS_Init_Tuning |
| PARMLIB メンバ詳細 | [MVS Initialization and Tuning Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=reference-parameters-parmlib-members) | IEASYSxx, IEFSSNxx, BPXPRMxx, SMFPRMxx 等 | S_ZOS_Init_Tuning |
| オペレータコマンド | [MVS System Commands](https://www.ibm.com/docs/en/zos/3.1.0?topic=mvs-system-commands) | DISPLAY, VARY, START, STOP, MODIFY 等の全コマンド | S_ZOS_MVS_Cmds |
| JES2 詳細 | [JES2 Initialization and Tuning Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=jes2-initialization-tuning-reference) | INITDECK 全パラメータ・$ コマンド | S_ZOS_JES2 |
| JCL リファレンス | [MVS JCL Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=mvs-jcl-reference) | JOB / EXEC / DD / OUTPUT 等の全構文 | S_ZOS_JCL_Ref |
| TSO/E コマンド | [TSO/E Command Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=tsoe-command-reference) | ALLOCATE, LISTC, LISTDS, SUBMIT 等 | S_ZOS_TSO_Cmds |
| REXX プログラミング | [TSO/E REXX Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=tsoe-rexx-reference) | REXX 言語仕様 + TSO/E 関数 | S_ZOS_TSO_REXX |
| SDSF オペレーション | [SDSF Operation and Customization](https://www.ibm.com/docs/en/zos/3.1.0?topic=sdsf-operation-customization) | DA/ST/LOG/JOB/OUT 全パネル | S_ZOS_SDSF |
| DFSMS（データセット管理） | [DFSMS Using Data Sets](https://www.ibm.com/docs/en/zos/3.1.0?topic=dfsms-using-data-sets) | PS / PO / VSAM / SMS-managed | S_ZOS_DFSMS |
| SMS / ACS routine | [DFSMSdfp Storage Administration](https://www.ibm.com/docs/en/zos/3.1.0?topic=dfsmsdfp-storage-administration) | Storage Class / Data Class / ACS routine | S_ZOS_DFSMS |
| RACF セキュリティ | [Security Server RACF Security Administrator's Guide](https://www.ibm.com/docs/en/zos/3.1.0?topic=racf-security-administrators-guide) | USERID / PROFILE / PERMIT / SETROPTS | S_ZOS_RACF |
| USS（UNIX System Services） | [UNIX System Services Planning](https://www.ibm.com/docs/en/zos/3.1.0?topic=unix-system-services-planning) | BPXPRMxx / OMVS / HFS / zFS / OMVS Segment | S_ZOS_USS |
| USS シェルコマンド | [UNIX System Services Command Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=unix-system-services-command-reference) | POSIX 互換シェル + z/OS 拡張 | S_ZOS_USS |
| Communications Server TCP/IP | [Communications Server IP Configuration Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=cs-ip-configuration-reference) | PROFILE.TCPIP / TCPIP STC / FTP | S_ZOS_CommServer |
| VTAM / SNA | [Communications Server SNA Resource Definition Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=cs-sna-resource-definition-reference) | VTAM ATCSTRxx / ATCCONxx / APPL / Mode Table | S_ZOS_CommServer |
| Sysplex / Coupling Facility | [MVS Setting Up a Sysplex](https://www.ibm.com/docs/en/zos/3.1.0?topic=mvs-setting-up-sysplex) | COUPLExx / CFRM / SFM / Couple Data Sets | S_ZOS_Sysplex |
| GRS（排他制御） | [MVS Planning: Global Resource Serialization](https://www.ibm.com/docs/en/zos/3.1.0?topic=mvs-planning-global-resource-serialization) | GRS NONE/RING/STAR、GRSRNLxx | S_ZOS_Sysplex |
| SMF / 統計記録 | [MVS System Management Facilities (SMF)](https://www.ibm.com/docs/en/zos/3.1.0?topic=mvs-system-management-facilities-smf) | SMFPRMxx / Type 30, 70-79, 80, 89, 99 詳細 | S_ZOS_SMF |
| WLM（性能管理） | [MVS Planning: Workload Management](https://www.ibm.com/docs/en/zos/3.1.0?topic=mvs-planning-workload-management) | Service Class / Goal / Period / Resource Group | S_ZOS_WLM |
| SMP/E | [SMP/E Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=smpe-reference) | APPLY / ACCEPT / RESTORE / LIST 全コマンド | S_ZOS_SMPE |
| 問題判別（Problem Diagnosis） | [MVS Diagnosis: Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=mvs-diagnosis-reference) | ABEND コード / SVC dump / IPCS | S_ZOS_Diag |
