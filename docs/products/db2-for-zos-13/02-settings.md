# 設定値一覧

> 掲載：**DSNZPARM マクロ 6 種 + tunable 21 件**（定番のみ）。除外項目は [11. 対象外項目](10-out-of-scope.md) を参照。

Db2 13 for z/OS のサブシステム挙動は **DSNZPARM**（インストール時に組み立てる load module）で制御される。DSNZPARM は次の 6 マクロから合成され、SYS1.PARMLIB ではなく **DSN.V13R1.SDSNSAMP** 配下のメンバを SMP/E ベースで管理する。

## DSNZPARM マクロ（6 種）

| マクロ | 用途 | 編集方法 | 反映タイミング | 関連手順 | 注意点 |
|---|---|---|---|---|---|
| `DSN6SYSP` | システム関連の中核（CTHREAD, CONDBAT, MAXDBAT, IDFORE, IDBACK, MAXKEEPD, CACHEPAC, EXTSEC など）。DSNZPARM の最大マクロ。 | DSNTIJUZ サンプル job 内の SDSNSAMP メンバ（DSN6SYSP セクション）を ISPF EDIT | DSNTIJUZ アセンブル → DB2 サブシステム再起動 or 一部 `-SET SYSPARM` で動的反映 | [cfg-dsnzparm-update](08-config-procedures.md#cfg-dsnzparm-update) | 多くは再起動必要。DECP（data-only）にあるパラメータは動的可。要約版は [Managing Performance, MAINPARM tables] に記載。 |
| `DSN6SPRM` | 処理関連（NUMLKTS, NUMLKUS, IRLMRWT, DEADLOK, RRULOCK, SECCDLY, AUTHCACH, MGEXTSZ, BIF_COMPATIBILITY, CHECK_FAST_REPLICATION, REORG_DROP_PBG_PARTS など）。性能・運用ポリシー系。 | DSNTIJUZ 経由 | DSN6SYSP と同様 | [cfg-dsnzparm-update](08-config-procedures.md#cfg-dsnzparm-update) | NUMLKTS / NUMLKUS は lock escalation の閾値、IRLMRWT は global lock timeout。 |
| `DSN6FAC` | 分散データ機能（DDF）関連（CMTSTAT, IDTHTOIN, MAXTYPE1, RESYNC_INTERVAL, TCPALVER, EXTSEC, DRDA_RESOLVE_TYPE, EXCLUDE_RACFGEN_TS など）。 | DSNTIJUZ 経由 | DDF 関連は `-STOP DDF` → DSN6FAC 再アセンブル → `-START DDF` で反映可能 | [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup) | CMTSTAT=INACTIVE が現代のデフォ（DBAT pool 化）。MAXDBAT/CONDBAT は DSN6SYSP 側に存在する点に注意。 |
| `DSN6LOGP` | アクティブログ関連（OUTBUFF, MAXLAGTM, CHECKFREQ, TWOACTV, TWOARCH, ARC2FRST, MAXARCH, COMPRESS_SPT01, DEALLCT など）。 | DSNTIJUZ 経由 | DB2 再起動必須（log 関連は基本的に IPL 級の再起動） | [cfg-log-archive](08-config-procedures.md#cfg-log-archive) | OUTBUFF=400000–4000000（KB）。CHECKFREQ で checkpoint 間隔。 |
| `DSN6ARVP` | アーカイブログ関連（UNIT, BLKSIZE, ARCRETN, ARCWTOR, ARCWRTC, ARCPFX1/2, ALCUNIT, COMPRESS_LOG など）。 | DSNTIJUZ 経由 | DB2 再起動 | [cfg-log-archive](08-config-procedures.md#cfg-log-archive) | UNIT は DASD or TAPE。ARCRETN（保管期限・日数）。 |
| `DSN6GRP` | データ共用グループ（GRPNAME, MEMBNAME, DSHARE, ASSIST, COORDNTR）。 | DSNTIJUZ（CRESTART でない、DSNTIJUZ で）| 新規 member 追加・group level 変更は計画的（メンテ時間枠内） | [cfg-datasharing-add-member](08-config-procedures.md#cfg-datasharing-add-member) | データ共用グループ内では全 member に同 GRPNAME 必須。 |

## チューナブル / パラメータ（21 件）

**種別の凡例**: サイジング = メモリ・領域配分、モード選択 = 動作切替、運用ポリシー = SLA / セキュリティ / 並列性、構成定義 = サブシステム構成、ランタイム = アプリ実行時。

| パラメータ名 | 種別 | マクロ | 既定値 | 取り得る値 | 反映タイミング | 関連手順 | 注意点 |
|---|---|---|---|---|---|---|---|
| `CTHREAD` | サイジング | DSN6SYSP | 200 | 1〜2000 | DB2 再起動 | [cfg-dsnzparm-update](08-config-procedures.md#cfg-dsnzparm-update) | ローカル接続（IMS, CICS, batch, TSO）の最大同時 thread 数。DDF は CONDBAT/MAXDBAT で別管理。 |
| `IDFORE` | サイジング | DSN6SYSP | 50 | 1〜CTHREAD | DB2 再起動 | [cfg-dsnzparm-update](08-config-procedures.md#cfg-dsnzparm-update) | foreground（TSO）からの最大同時 thread。CTHREAD の内数。 |
| `IDBACK` | サイジング | DSN6SYSP | 50 | 1〜CTHREAD | DB2 再起動 | [cfg-dsnzparm-update](08-config-procedures.md#cfg-dsnzparm-update) | background（batch）の最大同時 thread。CTHREAD の内数。 |
| `CONDBAT` | サイジング | DSN6SYSP | 10000 | 1〜200000 | DB2 再起動 | [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup) | DDF 経由のリモート接続の最大同時数（接続側上限、thread 化されてないものを含む）。 |
| `MAXDBAT` | サイジング | DSN6SYSP | 200 | 1〜CONDBAT | DB2 再起動 | [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup) | アクティブな DBAT（database access thread）の最大数。実 thread は CTHREAD ではなく MAXDBAT で制限。 |
| `IRLMRWT` | 運用ポリシー | DSN6SPRM | 30（秒） | 1〜3600 | DB2 / IRLM 再起動 or `F IRLMPROC,SET,TIMEOUT=(...)` | [cfg-dsnzparm-update](08-config-procedures.md#cfg-dsnzparm-update) | リソース待ちの timeout。`-911` SQLCODE のもと。長すぎは hung、短すぎは timeout 多発。 |
| `DEADLOK` | 運用ポリシー | DSN6SPRM | 1,1（local 検出間隔・global iteration 数） | 1〜10000（ms） / 1〜5 | IRLM 再起動 or `F IRLMPROC,SET,DEADLOK=(...)` | [inc-deadlock](09-incident-procedures.md#inc-deadlock) | デッドロック検出の頻度。短いほど検出は早いが overhead 増。 |
| `NUMLKTS` | 運用ポリシー | DSN6SPRM | 2000 | 0〜2147483647 | DB2 再起動 | [inc-lock-escalation](09-incident-procedures.md#inc-lock-escalation) | 1 トランザクションあたりの 1 テーブル空間の最大ロック数。超過で lock escalation（行→TS）。 |
| `NUMLKUS` | 運用ポリシー | DSN6SPRM | 10000 | 0〜2147483647 | DB2 再起動 | [inc-lock-escalation](09-incident-procedures.md#inc-lock-escalation) | 1 ユーザの全 TS 合計の最大ロック数。超過で SQLCODE -904（resource unavailable）。 |
| `MAXKEEPD` | サイジング | DSN6SYSP | 5000 | 0〜200000 | DB2 再起動 | [cfg-dsnzparm-update](08-config-procedures.md#cfg-dsnzparm-update) | 動的 SQL のキャッシュ（KEEPDYNAMIC）の最大ステートメント数。動的 SQL 中心アプリで増量。 |
| `CACHEPAC` | サイジング | DSN6SYSP | 32768（バイト） | 0〜2147483647 | DB2 再起動 | [cfg-bind-package](08-config-procedures.md#cfg-bind-package) | PACKAGE auth キャッシュサイズ。BIND 多発で大きく。 |
| `OUTBUFF` | サイジング | DSN6LOGP | 4000（KB、4MB） | 400〜400000 | DB2 再起動 | [cfg-log-archive](08-config-procedures.md#cfg-log-archive) | ログ出力バッファ（KB）。書込性能と memory のトレードオフ。 |
| `CHECKFREQ` | 運用ポリシー | DSN6LOGP | 5 分 | 1〜60（分）or LOGRECORDS 単位 | DB2 再起動 | [cfg-log-archive](08-config-procedures.md#cfg-log-archive) | checkpoint 間隔。短いと recovery 早い、長いと CPU 削減。 |
| `MAXARCH` | サイジング | DSN6LOGP | 1000 | 1〜10000 | DB2 再起動 | [cfg-log-archive](08-config-procedures.md#cfg-log-archive) | BSDS に登録する archive log エントリ数。長期 RECOVER 観点で大きめが安全。 |
| `TWOACTV` | モード選択 | DSN6LOGP | YES | YES / NO | DB2 再起動 | [cfg-log-archive](08-config-procedures.md#cfg-log-archive) | 二重アクティブログ（YES 推奨、production は必須相当）。 |
| `TWOARCH` | モード選択 | DSN6LOGP | YES | YES / NO | DB2 再起動 | [cfg-log-archive](08-config-procedures.md#cfg-log-archive) | 二重アーカイブログ。production 必須相当。 |
| `UNIT` (archive) | 構成定義 | DSN6ARVP | サイト依存（DASD or TAPE） | unit name | DB2 再起動 | [cfg-log-archive](08-config-procedures.md#cfg-log-archive) | DASD / TAPE / SMS managed の選択。最近は DASD + dump-to-tape が主流。 |
| `ARCRETN` | 運用ポリシー | DSN6ARVP | サイト依存（典型 30 / 90 / 365 日） | 0〜9999（日） | DB2 再起動 | [cfg-log-archive](08-config-procedures.md#cfg-log-archive) | アーカイブ保管期間。RECOVER 必要範囲に整合させる。 |
| `CMTSTAT` | モード選択 | DSN6FAC | INACTIVE | ACTIVE / INACTIVE | `-STOP DDF` → DSN6FAC → `-START DDF` | [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup) | INACTIVE で DBAT pool 化（接続→commit 後 DBAT を pool に戻す）。modern setup の標準。 |
| `IDTHTOIN` | 運用ポリシー | DSN6FAC | 120（秒） | 0〜9999 | DDF 再起動 | [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup) | inactive thread の自動切断 timeout。0 = 無効。 |
| `RESYNC_INTERVAL` | 運用ポリシー | DSN6FAC | 3（分） | 1〜99 | DDF 再起動 | [cfg-ddf-setup](08-config-procedures.md#cfg-ddf-setup) | indoubt thread の自動再同期試行間隔。 |

---

## 参考：DSNZPARM 適用フロー（要約）

1. `DSN.V13R1.SDSNSAMP(DSNTIJUZ)` を ISPF EDIT で複製、各マクロ（DSN6SYSP / DSN6SPRM / DSN6FAC / DSN6LOGP / DSN6ARVP / DSN6GRP）の値を変更
2. DSNTIJUZ サブミット → ASMA90 で MACRO assemble → IEWL でリンク、出力 = `DSN.V13R1.SDSNEXIT(DSNZPARM)` 等の load module
3. DB2 サブシステム再起動 `-STOP DB2 MODE(QUIESCE)` → `-START DB2 PARM(DSNZPARM)`
4. `DSN1` プレフィックスから `-DISPLAY ARCHIVE` 等で値確認

詳細手順は [cfg-dsnzparm-update](08-config-procedures.md#cfg-dsnzparm-update) を参照。

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
