# 本サイトの対象外項目

本サイトでは、z/OS 管理者が日常的に使う **定番のみ** を掲載しています。以下は意図的に除外しています。

## 章別サマリ

| 章 | 掲載 vs 除外 |
|---|---|
| コマンド | 本サイト掲載: 45 コマンド / 除外: 多数（z/OS には数百のコマンド + サブコマンドあり） |
| 設定値 | 本サイト掲載: 39 件（PARMLIB 19 + tunable 20）/ 除外: 数百 |
| 用語 | 本サイト掲載: 70 件 / 除外: 多数 |
| ユースケース | 本サイト掲載: 30 ユースケース（12-use-cases.md）+ 6 シナリオ別ガイド（11-scenarios.md）/ 除外: 多数 |

---

## コマンド

本サイト掲載: 45 コマンド / 除外: 多数（z/OS には数百のコマンド + サブコマンドあり）

### DFSORT / SYNCSORT 制御文

- **概数**: 100+ ステートメント
- **理由**: ソート処理は専門書籍多数、本サイトでは扱わない
- **参照先**: [DFSORT Application Programming Guide](https://www.ibm.com/docs/en/zos/3.1.0?topic=dfsort-application-programming-guide)

**代表例**:

- SORT FIELDS=...
- INCLUDE COND=(...)
- OUTREC FIELDS=(...)
- JOINKEYS
- OMIT COND=(...)

### IDCAMS（VSAM 管理）コマンド

- **概数**: 50+
- **理由**: VSAM 専門領域、別途 IDCAMS 専門書籍参照
- **参照先**: [DFSMS Access Method Services Commands](https://www.ibm.com/docs/en/zos/3.1.0?topic=dfsms-access-method-services-commands)

**代表例**:

- DEFINE CLUSTER
- REPRO
- PRINT
- ALTER
- EXPORT/IMPORT
- EXAMINE
- DELETE
- VERIFY

### ISPF Edit / Browse のラインコマンド

- **概数**: 数十
- **理由**: 対話編集機能で本サイトの管理コマンドの範囲外
- **参照先**: [ISPF Edit Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=ispf-edit-reference)

**代表例**:

- I (Insert)
- D (Delete)
- C/M/A (Copy/Move/After)
- F/L (First/Last)
- X/S (eXclude/Show)
- CHANGE
- FIND

### RMF Monitor I/II/III サブコマンド

- **概数**: 30+
- **理由**: 性能管理専門領域
- **参照先**: [RMF User's Guide](https://www.ibm.com/docs/en/zos/3.1.0?topic=rmf-users-guide)

**代表例**:

- RMF MONITOR I
- RMF MONITOR II ...
- PP（Postprocessor）

### DFSMShsm コマンド

- **概数**: 100+
- **理由**: HSM 運用専門
- **参照先**: [DFSMShsm Storage Administration Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=dfsmshsm-storage-administration-reference)

**代表例**:

- HSEND ...
- HMIGRATE
- HRECALL
- HBACKDS
- HALTERDS

---

## 設定値

本サイト掲載: 39 件（PARMLIB 19 + tunable 20）/ 除外: 数百

### PARMLIB 全メンバ（80+）

- **概数**: 80+
- **理由**: z/OS PARMLIB は約 100 メンバ、本サイトは staple 19 のみ
- **参照先**: [MVS Initialization and Tuning Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=mvs-initialization-tuning-reference)

**代表例**:

- ALLOCxx
- ANTMINxx
- ANTXINxx
- APPCPMxx
- ASCHPMxx
- AUTOR00
- AXR00
- BLSCECT
- CEEPRMxx
- CLOCKxx
- COFVLFxx
- CONFIGxx
- COUPLExx
- CSQ4ZPRM
- CSVLLAxx
- CTncccxx
- DEVSUPxx
- DFLTxx
- DIAGxx
- EPHWP00
- 他 60+

### JES2 INITDECK の全パラメータ（200+）

- **概数**: 200+
- **理由**: JES2 専門領域、サイト staple 範囲外
- **参照先**: [JES2 Initialization and Tuning Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=jes2-initialization-tuning-reference)

**代表例**:

- APPL(...)
- CKPTSPACE
- CONNECT
- DESTID
- ESTLNCT
- ESTPAGE
- ESTPUN
- FSSDEF
- JOBPRTY
- MASDEF
- NJEDEF
- NUM_JOE
- NUM_RES
- OUTPRTY
- PCEDEF
- PRINTDEF
- PRT(n)
- 他 150+

### RACF SETROPTS 全オプション

- **概数**: 50+
- **理由**: RACF 専門領域
- **参照先**: [RACF Command Language Reference SETROPTS](https://www.ibm.com/docs/en/zos/3.1.0?topic=racf-setropts-set-racf-options)

**代表例**:

- ADDCREATOR
- AUDIT
- CATDSNS
- CLASSACT
- ENCRYPT
- GENERIC
- GLOBAL
- GRPLIST
- INITSTATS
- JES
- LOGOPTIONS
- MLACTIVE
- PASSWORD(MIXEDCASE)
- PROTECTALL

### SMF 全 record type

- **概数**: 200+
- **理由**: Type 0-255 の全レコード仕様、本サイトは主要 type のみ
- **参照先**: [SMF Reference](https://www.ibm.com/docs/en/zos/3.1.0?topic=mvs-system-management-facilities-smf)

**代表例**:

- Type 0 (IPL)
- Type 14/15 (Read/Write)
- Type 17/18 (Delete/Rename)
- Type 23 (SMF)
- Type 60-69 (VSAM)
- Type 88 (Logger)
- Type 119 (TCP/IP)
- Type 120 (WebSphere)
- Type 245 (DFSMS)

---

## 用語

本サイト掲載: 70 件 / 除外: 多数

### DB2/IMS/CICS 専用用語

- **概数**: 数百
- **理由**: 個別製品用語は各製品の公式 glossary 参照
- **参照先**: [各製品の Knowledge Center](https://www.ibm.com/docs/en/)

**代表例**:

- Db2 Data Sharing Group
- IMS DBD/PSB
- CICS TS Region
- MQ Queue Manager

### アセンブラ・低レベル用語

- **概数**: 数十
- **理由**: アセンブラ言語専門、システムプログラマ範囲
- **参照先**: [MVS Programming: Assembler Services Guide](https://www.ibm.com/docs/en/zos/3.1.0?topic=mvs-programming-assembler-services-guide)

**代表例**:

- TCB / SRB
- PSW
- CVT
- ASCB / ASXB
- PCB / DEB
- RB / IRB

---

## ユースケース

本サイト掲載: 30 ユースケース（12-use-cases.md）+ 6 シナリオ別ガイド（11-scenarios.md）/ 除外: 多数

### アプリケーション開発系

- **概数**: 多数
- **理由**: プログラミング言語 (COBOL/PL/I/Java) は別途専門書籍参照
- **参照先**: [各言語の Programming Guide](https://www.ibm.com/docs/en/zos/3.1.0)

**代表例**:

- COBOL コンパイル + バインド
- PL/I 開発
- Java バッチ
- DB2 Plan/Package 作成

### ミドルウェア構築系（CICS/IMS/Db2）

- **概数**: 多数
- **理由**: 個別製品の専門領域
- **参照先**: [各製品 InstallationGuide](https://www.ibm.com/docs/en/)

**代表例**:

- CICS リージョン定義
- IMS データベース定義
- Db2 サブシステム作成

---

