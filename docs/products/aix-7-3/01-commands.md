# コマンド一覧

> 掲載：**45 コマンド / 710 全オプション説明**（定番のみ）。除外項目は [10. 対象外項目](10-out-of-scope.md) を参照。

AIX 管理者が現場で月1回以上触る定番コマンドのみ。**全オプション**を IBM AIX 7.3 Commands Reference の Flags セクションから抽出（合計 710 件）。

C 言語サブルーチン、廃止コマンド等は [10. 対象外項目](10-out-of-scope.md) 参照。

## 目次（カテゴリ別 45 コマンド）

- **ログ・診断**（5 件）: [`errpt`](#errpt), [`errdemon`](#errdemon), [`errclear`](#errclear), [`snap`](#snap), [`alog`](#alog)
- **デバイス・LVM**（9 件）: [`lsdev`](#lsdev), [`lsattr`](#lsattr), [`chdev`](#chdev), [`cfgmgr`](#cfgmgr), [`lspv`](#lspv), [`lsvg`](#lsvg), [`lslv`](#lslv), [`mkvg`](#mkvg), [`mklv`](#mklv)
- **ファイルシステム**（3 件）: [`df`](#df), [`chfs`](#chfs), [`fsck`](#fsck)
- **ネットワーク**（5 件）: [`ifconfig`](#ifconfig), [`netstat`](#netstat), [`no`](#no), [`nfso`](#nfso), [`ping`](#ping)
- **性能・プロセス**（5 件）: [`vmstat`](#vmstat), [`iostat`](#iostat), [`topas`](#topas), [`ps`](#ps), [`kill`](#kill)
- **チューニング**（3 件）: [`ioo`](#ioo), [`vmo`](#vmo), [`schedo`](#schedo)
- **パッケージ管理**（3 件）: [`lslpp`](#lslpp), [`installp`](#installp), [`instfix`](#instfix)
- **システム情報・起動**（4 件）: [`oslevel`](#oslevel), [`bootinfo`](#bootinfo), [`bootlist`](#bootlist), [`bosboot`](#bosboot)
- **バックアップ**（2 件）: [`mksysb`](#mksysb), [`savevg`](#savevg)
- **ユーザ・セキュリティ**（3 件）: [`lsuser`](#lsuser), [`passwd`](#passwd), [`chsec`](#chsec)
- **サービス管理**（3 件）: [`lssrc`](#lssrc), [`startsrc`](#startsrc), [`smit / smitty`](#smit---smitty)

---

## ログ・診断（5 件）

### `errpt` { #errpt }

**用途**: Error Logging サブシステムに記録されたエラーログを表示する。AIX 管理者が日々最初に確認するコマンド。

**構文**:

```
errpt [-a] [-d <Class>] [-s <mmddhhmmyy>] [-N <Resource>]
```

**全オプション一覧**（27 件）:

| オプション | 説明 |
|---|---|
| `-@ wpar_name` | 指定 WPAR 名のエラーエントリのみ選択。 |
| `-a` | 詳細形式で表示。-t と併用時はテンプレート全情報を表示。 |
| `-A` | 詳細レポートの省略版（label/date/type/resource/desc/data のみ）。-a/-g/-t と併用不可。 |
| `-c` | concurrent モード。エラー記録時にリアルタイム表示。 |
| `-d <ErrorClassList>` | クラスでフィルタ。H=ハードウェア、S=ソフトウェア、O=オペレータ、U=未定義。 |
| `-D` | 重複エラーを集約（数と最初/最後の発生時刻を表示）。-c/-g/-l/-t/-P と併用不可。 |
| `-e <EndDate>` | 指定日時 mmddhhmmyy 以前のレコードを表示。 |
| `-F <FlagList>` | Flag によるフィルタ（softerr 等）。 |
| `-g` | アンフォーマット形式の ASCII 表示。 |
| `-i <File>` | 代替エラーログファイルを指定。 |
| `-I <File>` | 代替エラーレコードテンプレートリポジトリを指定。 |
| `-j <ErrorID>` | 指定 error ID（カンマ区切り可）でフィルタ。 |
| `-J <ErrorLabel>` | 指定 LABEL（例: J2_FS_FULL）でフィルタ。 |
| `-k <ErrorID>` | 指定 error ID 以外を表示（exclusion）。 |
| `-K <ErrorLabel>` | 指定 LABEL 以外を表示（exclusion）。 |
| `-l <SequenceNumber>` | 指定シーケンス番号のレコードを表示。 |
| `-m <Machine>` | 指定マシン ID のレコードを表示。 |
| `-n <Node>` | 指定ノードのレコードを表示。 |
| `-N <ResourceNameList>` | 指定リソース（例: hdisk1）のエラーのみ表示。 |
| `-P` | エラー診断パススルー（pass-through）モード。 |
| `-R <ResourceTypeList>` | 指定リソースタイプでフィルタ。 |
| `-s <StartDate>` | 指定日時 mmddhhmmyy 以降のレコードを表示。 |
| `-S <ResourceClassList>` | 指定リソースクラスでフィルタ。 |
| `-t` | Error Record Template Repository から表示（実エラーログでなく）。 |
| `-T <ErrorTypeList>` | タイプでフィルタ。INFO / PEND / PERM / PERF / TEMP / UNKN。 |
| `-y <File>` | 代替エラーレコードテンプレートを使用。 |
| `-z <File>` | 代替エラーレコードテンプレートファイルを指定。 |

**典型例**:

```
errpt -a | more  # 全エラー詳細表示
errpt -d H -s 0501000026  # 5/1 以降のハード障害だけ
```

**注意点**: HW=90日、SW=30日で自動削除。errdemon が停止していると新規ログが取れない。

**関連手順**: [inc-errpt-hardware-error](09-incident-procedures.md#inc-errpt-hardware-error), [cfg-errnotify](08-config-procedures.md#cfg-errnotify)

**関連用語**: errlog, errdemon, errnotify

**出典**: S_AIX73_commands1

---

### `errdemon` { #errdemon }

**用途**: Error Logging サブシステムのデーモン。/dev/error を監視してエラーログファイル（既定 /var/adm/ras/errlog）に書き込む。

**構文**:

```
errdemon [-l <ログ>] [-s <サイズ>] [-i <error_template_repository>]
```

**全オプション一覧**（9 件）:

| オプション | 説明 |
|---|---|
| `-B <BufferSize>` | errlog ファイルのバッファサイズを指定（バイト）。 |
| `-d` | 重複エラー集約を無効化。 |
| `-D` | 重複エラー集約を有効化（既定）。 |
| `-i <File>` | Error Record Template Repository ファイルを指定。 |
| `-l` | 現在の状態（log path、サイズ、buffer 等）を表示。 |
| `-m <MaxDups>` | 重複として集約する最大数を指定。 |
| `-R <enable\|disable>` | errlog の自動 rotate を有効/無効化。 |
| `-s <LogSize>` | errlog ファイルの最大サイズ（バイト）を指定。 |
| `-t <Time>` | 重複として扱う時間ウィンドウ（秒）を指定。 |

**典型例**:

```
/usr/lib/errdemon -l  # 状態確認
errdemon  # 開始（通常 inittab で自動起動）
```

**注意点**: errpt が空を返すときはまずこのデーモンが動いているか確認。

**関連手順**: [inc-errpt-hardware-error](09-incident-procedures.md#inc-errpt-hardware-error)

**関連用語**: errlog, errpt

**出典**: S_AIX73_commands1

---

### `errclear` { #errclear }

**用途**: errpt が読むエラーログから古いエントリを削除する。FS full の応急処置や定期メンテで使用。

**構文**:

```
errclear [-d <Class>] [-J <Label>] <Days>
```

**全オプション一覧**（15 件）:

| オプション | 説明 |
|---|---|
| `-d <ErrorClassList>` | クラスでフィルタ削除（H/S/O/U）。 |
| `-i <File>` | 代替エラーログファイル指定。 |
| `-j <ErrorID>` | 指定 error ID のエントリを削除。 |
| `-J <ErrorLabel>` | 指定 LABEL のエントリを削除。 |
| `-k <ErrorID>` | 指定 error ID 以外を削除（exclusion）。 |
| `-K <ErrorLabel>` | 指定 LABEL 以外を削除（exclusion）。 |
| `-l <SequenceNumber>` | 指定シーケンス番号のエントリを削除。 |
| `-m <Machine>` | 指定マシン ID のエントリを削除。 |
| `-n <Node>` | 指定ノードのエントリを削除。 |
| `-N <ResourceNameList>` | 指定リソース（hdisk1 等）のエントリを削除。 |
| `-R <ResourceTypeList>` | 指定リソースタイプのエントリを削除。 |
| `-S <ResourceClassList>` | 指定リソースクラスのエントリを削除。 |
| `-T <ErrorTypeList>` | 指定エラータイプのエントリを削除。 |
| `-y` | 削除確認プロンプトをスキップ。 |
| `<Days>` | 指定日数より古いエントリを削除（0 で全削除）。 |

**典型例**:

```
errclear 30  # 30 日より古いログを全削除
errclear -d S 7  # 7 日より古い SW エラーだけ削除
```

**注意点**: 0 を指定すると全削除。実運用では cron で定期削除。

**関連手順**: [inc-fs-full](09-incident-procedures.md#inc-fs-full)

**関連用語**: errlog

**出典**: S_AIX73_commands1

---

### `snap` { #snap }

**用途**: IBM サポート提供用にシステム情報・ログを一括収集する。pax.gz 形式で /tmp/ibmsupt 配下に出力。

**構文**:

```
snap [-a] [-c] [-o <output device>] [-r] <component>
```

**全オプション一覧**（33 件）:

| オプション | 説明 |
|---|---|
| `-a` | 全コンポーネントの情報を収集。 |
| `-A` | ATM 関連情報を収集。 |
| `-b` | SSA 関連情報を収集。 |
| `-B` | Boot 関連情報を収集。 |
| `-c` | 収集後に pax.gz 形式で圧縮。 |
| `-C` | コアファイルを収集。 |
| `-d <Dir>` | 出力先ディレクトリを指定（既定 /tmp/ibmsupt）。 |
| `-D` | ダンプ情報を収集。 |
| `-e` | HACMP 関連情報を収集。 |
| `-f` | ファイルシステム情報を収集。 |
| `-F` | WPAR 情報を収集。 |
| `-g` | general 情報を収集（軽量）。 |
| `-G` | GPFS 情報を収集。 |
| `-i` | InfoExplorer 情報を収集。 |
| `-I` | 印刷関連情報を収集。 |
| `-k` | Kerberos 関連情報を収集。 |
| `-l` | LPP 情報を収集。 |
| `-L` | LVM 情報を収集。 |
| `-n` | NFS 情報を収集。 |
| `-N` | ハードウェア構成情報を含めない（高速化）。 |
| `-o <Device>` | テープなどのデバイスへ直接書き出し。 |
| `-p` | 印刷情報を収集。 |
| `-P <PIDs>` | 指定プロセス ID の情報を収集。 |
| `-r` | 前回の snap データを削除（クリア）。 |
| `-R <Dir>` | 指定ディレクトリの内容を pax.gz 化。 |
| `-s` | SNA 関連情報を収集。 |
| `-S` | SSA 関連情報を収集。 |
| `-t` | TCP/IP 関連情報を収集。 |
| `-T <File>` | テープファイル名を指定。 |
| `-v <Component>` | verbose 出力で指定コンポーネントの情報を収集。 |
| `-w` | Web 関連情報を収集。 |
| `-X` | X11 関連情報を収集。 |
| `-z` | 圧縮レベルを指定。 |

**典型例**:

```
snap -ac  # 全情報収集して pax.gz に圧縮
snap -r  # 古い snap をクリア
```

**注意点**: 実行に時間がかかる（数分〜数十分）。/tmp に十分な空き必要。

**関連手順**: [inc-package-install-fail](09-incident-procedures.md#inc-package-install-fail), [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation)

**関連用語**: errlog, ras

**出典**: S_AIX73_commands1

---

### `alog` { #alog }

**用途**: ブートログ（boot log）等の循環ログを表示・操作する。boot 失敗の調査で使う。

**構文**:

```
alog -t <type> -o   # 表示
alog -t boot -o     # ブートログ表示
```

**全オプション一覧**（10 件）:

| オプション | 説明 |
|---|---|
| `-C` | ログをクリアする（current ログをリセット）。 |
| `-f <FileName>` | 対象ログファイルを直接指定。 |
| `-L` | 定義済みの全 alog タイプ一覧を表示。 |
| `-o` | 指定タイプのログ内容を表示する。 |
| `-O` | 出力時に古いほうから新しいほうへの順に表示。 |
| `-q` | 標準入力をログに書き込む（パイプ用）。 |
| `-s <Size>` | ログファイルの最大サイズ（バイト）を指定。 |
| `-t <Type>` | ログタイプを指定（boot / bosinst / cfg / console / nim 等）。 |
| `-V` | 現在のバッファサイズと出力ファイルを表示。 |
| `-w <FileName>` | alog ファイル属性を再構成。 |

**典型例**:

```
alog -t boot -o | tail -200  # 最新 200 行
alog -L  # 定義済 alog タイプ一覧
```

**注意点**: boot ログは bos.rte.misc_cmds 同梱、cfgmgr の標準出力相当。

**関連手順**: [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led)

**関連用語**: boot log

**出典**: S_AIX73_commands1

---

## デバイス・LVM（9 件）

### `lsdev` { #lsdev }

**用途**: ODM に登録されたデバイス（ディスク、アダプタ等）の一覧を表示する。

**構文**:

```
lsdev [-C] [-c <Class>] [-t <Type>] [-s <Subclass>]
```

**全オプション一覧**（14 件）:

| オプション | 説明 |
|---|---|
| `-c <Class>` | クラスでフィルタ（disk / adapter / tape / printer 等）。 |
| `-C` | Customized デバイス（ODM 登録済み）を表示（既定）。 |
| `-f <File>` | コマンド入力をファイルから取得。 |
| `-F <Format>` | カスタム列フォーマットで出力（コロン区切り）。 |
| `-h` | ヘッダ行を表示。 |
| `-H` | ヘッダ行を表示（標準形式）。 |
| `-l <Device>` | 個別デバイスを指定（例: hdisk0）。 |
| `-p <Parent>` | 指定親デバイス配下の子デバイスを表示。 |
| `-P` | Predefined デバイス（カーネル既知）を表示。 |
| `-r <ColumnName>` | 指定列の値の重複なしリストを表示。 |
| `-R` | リソースのリストを再帰的に表示。 |
| `-s <Subclass>` | サブクラスでフィルタ。 |
| `-S <State>` | 状態でフィルタ（Available / Defined / Stopped）。 |
| `-t <Type>` | タイプでフィルタ（fcp / scsi 等）。 |

**典型例**:

```
lsdev -Cc disk     # 全ディスク
lsdev -Cc adapter  # 全アダプタ
lsdev -Cc tape     # テープ装置
```

**注意点**: Available（利用可）/ Defined（定義済）の状態欄に注意。Defined のままなら cfgmgr 等で構成必要。

**関連手順**: [inc-lv-not-recognized](09-incident-procedures.md#inc-lv-not-recognized), [cfg-disk-add](08-config-procedures.md#cfg-disk-add)

**関連用語**: ODM, cfgmgr

**出典**: S_AIX73_commands1

---

### `lsattr` { #lsattr }

**用途**: デバイスの ODM 属性を表示する。MPIO の reserve_policy / queue_depth 等を見るときに必須。

**構文**:

```
lsattr -El <Device> [-a <Attribute>]
```

**全オプション一覧**（16 件）:

| オプション | 説明 |
|---|---|
| `-a <Attribute>` | 特定属性のみ表示（複数指定可）。 |
| `-c <Class>` | クラス指定（-P と併用）。 |
| `-D` | default（出荷時）値を表示。 |
| `-E` | 現在の effective 値を表示（最も使うモード）。 |
| `-f <File>` | コマンド入力をファイルから取得。 |
| `-F <Format>` | カスタム列フォーマットで出力。 |
| `-h` | ヘッダ行を表示。 |
| `-H` | ヘッダ行を表示（標準形式）。 |
| `-l <Device>` | 対象デバイスを指定（必須）。 |
| `-O` | コロン区切り形式で出力（スクリプト用）。 |
| `-P` | Predefined デバイスの属性を表示。 |
| `-q <Match>` | 属性値マッチで絞り込み。 |
| `-R` | 属性の許容値範囲を表示。 |
| `-s <Subclass>` | サブクラス指定（-P と併用）。 |
| `-t <Type>` | タイプ指定（-P と併用）。 |
| `-Z` | 属性が NULL の場合 Z を表示。 |

**典型例**:

```
lsattr -El hdisk0
lsattr -El sys0 -a realmem  # 物理メモリ
lsattr -El ent0 -a media_speed
```

**注意点**: True 列が表示用名、設定変更は chdev で実施。

**関連手順**: [cfg-mpio-tuning](08-config-procedures.md#cfg-mpio-tuning)

**関連用語**: ODM, MPIO

**出典**: S_AIX73_commands1

---

### `chdev` { #chdev }

**用途**: デバイス属性を変更する。ODM および実機（kernel）両方に反映可能。

**構文**:

```
chdev -l <Device> -a <Attribute>=<Value> [-P|-T|-U]
```

**全オプション一覧**（10 件）:

| オプション | 説明 |
|---|---|
| `-a <Attr>=<Val>` | 属性と値を指定（複数指定可）。 |
| `-f <File>` | 属性定義ファイルから一括変更。 |
| `-h` | コマンド使用法を表示。 |
| `-l <Device>` | 対象デバイスを指定（必須）。 |
| `-p <ParentName>` | 指定親デバイスにアタッチ。 |
| `-P` | ODM のみ更新、次回 boot で実機反映。 |
| `-q` | quiet モード（メッセージ最小化）。 |
| `-Q` | サブクラス変更時の確認スキップ。 |
| `-T` | 実機（カーネル）のみ更新、ODM は変更しない。 |
| `-U` | ODM と実機を動的に同時更新（オープン中も可）。 |

**典型例**:

```
chdev -l hdisk1 -a queue_depth=64 -U  # 動的反映（オープン中可）
chdev -l ent0 -a jumbo_frames=yes -P  # 次回 boot 反映
```

**注意点**: -U=動的反映、-P=ODM のみ更新（次回 boot で反映）、-T=実機のみ。誤った属性で chdev するとデバイスが Defined になることあり。

**関連手順**: [cfg-mpio-tuning](08-config-procedures.md#cfg-mpio-tuning), `cfg-network-jumbo`

**関連用語**: ODM, MPIO

**出典**: S_AIX73_commands1

---

### `cfgmgr` { #cfgmgr }

**用途**: 新たに認識されたデバイスを構成する（Defined → Available）。新規ディスク追加後の必須コマンド。

**構文**:

```
cfgmgr [-v] [-l <Device>]
```

**全オプション一覧**（8 件）:

| オプション | 説明 |
|---|---|
| `-f` | ファースト boot 用 first boot phase 1 のみ実行。 |
| `-i <Source>` | デバイスドライバの追加 source を指定。 |
| `-l <Device>` | 特定デバイス配下のみ再構成。 |
| `-p <Phase>` | 実行フェーズを指定（1=base, 2=disk, 3=others）。 |
| `-s` | Phase 1 後に停止（最小構成のみ）。 |
| `-S` | ファースト boot 用 stripped モード。 |
| `-T <Timeout>` | I/O タイムアウト値を秒単位で指定。 |
| `-v` | 詳細メッセージを表示しながら実行。 |

**典型例**:

```
cfgmgr -v  # 詳細メッセージ付きで全デバイス構成
cfgmgr -l fcs0  # FC アダプタ配下のみ再構成
```

**注意点**: 実行に時間かかる場合あり（FC SAN 等）。SCSI/FC 両方に対し全パスを再スキャン。

**関連手順**: [cfg-disk-add](08-config-procedures.md#cfg-disk-add)

**関連用語**: ODM, MPIO

**出典**: S_AIX73_commands1

---

### `lspv` { #lspv }

**用途**: Physical Volume（PV、ディスク）一覧と各 PV の VG 所属を表示する。

**構文**:

```
lspv  # 一覧
lspv <PV>  # 詳細
```

**全オプション一覧**（10 件）:

| オプション | 説明 |
|---|---|
| `（引数なし）` | 全 PV の一覧（hdisk名・PVID・所属VG・状態）を表示。 |
| `<PV>` | 個別 PV の詳細情報を表示。 |
| `-l <PV>` | PV 上に配置されている LV 一覧を表示。 |
| `-L <PV>` | PV 上の LV のロック情報を表示。 |
| `-M <PV>` | PP の物理マッピング詳細を表示。 |
| `-n <DescriptorPV>` | 代替 VGDA を持つ PV を指定。 |
| `-p <PV>` | PV の PP マッピング（どの LV/LP に割当て済か）を表示。 |
| `-P` | PV の物理ボリュームグループ情報を表示。 |
| `-u` | PV の UUID 形式 ID を表示。 |
| `-v <VGid>` | 指定 VG の PV のみ表示。 |

**典型例**:

```
lspv
lspv hdisk0  # PVID, VG 名, total/free PP
lspv -l hdisk0  # PV 上の LV 一覧
```

**注意点**: PVID が `none` のときは VG に未組み込み。`00000000...` なら chdev で PV 削除可能。

**関連手順**: [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv), [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror)

**関連用語**: PV, PVID, VG

**出典**: S_AIX73_commands1

---

### `lsvg` { #lsvg }

**用途**: Volume Group（VG）の一覧および詳細情報を表示する。

**構文**:

```
lsvg            # 全 VG 一覧
lsvg <VG>      # 詳細
lsvg -l <VG>   # LV 一覧
lsvg -p <VG>   # PV 一覧
```

**全オプション一覧**（12 件）:

| オプション | 説明 |
|---|---|
| `（引数なし）` | 全 VG 一覧を表示。 |
| `<VG>` | 個別 VG の詳細（PP サイズ、空き PP 数、状態等）を表示。 |
| `-i` | VG リストを標準入力から読む。 |
| `-l <VG>` | VG 内の LV 一覧と状態（open/syncd, stale 等）を表示。 |
| `-L <VG>` | VG のロック取得を試行しない（読み取り専用）。 |
| `-m <VG>` | PP の物理マッピングを表示。 |
| `-M <VG>` | VG の詳細マッピングを表示。 |
| `-n <DescriptorPV>` | 代替 VGDA を持つ PV を指定。 |
| `-o` | varyon 状態の VG のみ表示。 |
| `-p <VG>` | VG 内の PV 一覧と各 PV の状態を表示。 |
| `-P` | VG プールの情報を表示。 |
| `-T` | VG タイプ情報を表示。 |

**典型例**:

```
lsvg rootvg
lsvg -l datavg
```

**注意点**: VG が varyoff（オフライン）のときは情報が取れない。

**関連手順**: [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv)

**関連用語**: VG, VGDA, VGSA

**出典**: S_AIX73_commands1

---

### `lslv` { #lslv }

**用途**: Logical Volume（LV）の構成・物理配置・属性を表示する。

**構文**:

```
lslv <LV>       # 詳細
lslv -l <LV>    # PV 別配置
lslv -m <LV>    # PP マッピング
```

**全オプション一覧**（6 件）:

| オプション | 説明 |
|---|---|
| `<LV>` | LV の詳細（type、サイズ、ミラー、ポリシー等）を表示。 |
| `-l <LV>` | PV 別の LP/PP 配置を表示。 |
| `-L <LV>` | LV のロック状態を表示（lock 取得しない）。 |
| `-m <LV>` | 各 LP がどの PV のどの PP にあるか詳細マッピング表示。 |
| `-n <DescriptorPV>` | 代替 VGDA を持つ PV を指定。 |
| `-p <PV> <LV>` | 指定 PV における LV の物理配置を表示。 |

**典型例**:

```
lslv hd5  # boot LV
lslv -l hd2  # /usr の物理配置
```

**注意点**: ミラー状態の確認は `lslv -m` で同一 LP の PP1/PP2/PP3 が異なる PV にあるか見る。

**関連手順**: [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror), [inc-lv-not-recognized](09-incident-procedures.md#inc-lv-not-recognized)

**関連用語**: LV, LP, PP, LVCB

**出典**: S_AIX73_commands1

---

### `mkvg` { #mkvg }

**用途**: 新しい Volume Group を作成する。データ領域用ディスクの初期構築で必須。

**構文**:

```
mkvg [-S] [-y <VG>] [-s <PP_size>] <PV>
```

**全オプション一覧**（25 件）:

| オプション | 説明 |
|---|---|
| `-B` | Big VG として作成（旧形式、現在は -S 推奨）。 |
| `-c` | 並行（concurrent）アクセス VG を作成（HACMP 用）。 |
| `-C` | Enhanced concurrent capable VG を作成。 |
| `-d <MaxPVs>` | 最大 PV 数を指定（scalable VG 用）。 |
| `-f` | 強制作成（PV が他 VG に所属していても上書き）。 |
| `-G <Pool>` | VG プールを指定。 |
| `-i` | VG 名のリストを標準入力から読む。 |
| `-I` | ノードロック VG として作成。 |
| `-l` | ロック付き VG として作成。 |
| `-L <Ltgsize>` | Logical Track Group サイズ（KB）を指定。 |
| `-M` | ミラープール対応 VG として作成。 |
| `-n` | varyon を実行しない（後で手動 varyonvg）。 |
| `-N` | Quorum 維持なしで varyon。 |
| `-O` | 上書きモードで varyon。 |
| `-p` | プライマリパス指定。 |
| `-P <MaxPP>` | scalable VG の最大 PP 数を指定。 |
| `-Q` | Quorum 不要で動作する VG を作成（クリティカル VG）。 |
| `-r <FactorRPV>` | Remote PV 設定。 |
| `-R <RemotePool>` | Remote プール指定。 |
| `-s <Size>` | PP サイズを指定（MB 単位、2 のべき乗）。 |
| `-S` | scalable VG として作成（既定 1024 PV / 256 LV / 32768 PP）。 |
| `-t <Factor>` | 従来 VG の PP 数倍率指定。 |
| `-V <MajorNum>` | VG メジャー番号を指定。 |
| `-x <PP数>` | scalable VG の最大 PP 数を指定。 |
| `-y <VG>` | 作成する VG 名を指定。 |

**典型例**:

```
mkvg -S -y datavg -s 64 hdisk1 hdisk2  # scalable VG, PP=64MB
```

**注意点**: -S = scalable VG（既定 1024 PV / 256 LV / 32768 PP）。AIX 7.3 では scalable VG 推奨。

**関連手順**: [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv)

**関連用語**: VG, scalable VG

**出典**: S_AIX73_commands1

---

### `mklv` { #mklv }

**用途**: VG 内に新しい Logical Volume を作成する。

**構文**:

```
mklv [-y <LV>] [-t <fstype>] [-c <copies>] <VG> <PPs> [<PV>...]
```

**全オプション一覧**（28 件）:

| オプション | 説明 |
|---|---|
| `-a <Position>` | PV 上の物理位置（c=center、e=edge、m=middle、ie=inner edge、im=inner middle）。 |
| `-b <Bbrelocation>` | bad block relocation（y/n）。 |
| `-c <Copies>` | ミラーコピー数（1〜3）。 |
| `-C <Stripes>` | stripe 幅（PV 数）を指定。 |
| `-d <Schedule>` | ミラーの書き込みスケジュール（p=parallel、s=sequential、ps=parallel sequential）。 |
| `-e <Range>` | PV 範囲（x=maximum、m=minimum）。 |
| `-i` | LV 名リストを標準入力から読む。 |
| `-G <FailGroup>` | 障害グループを指定。 |
| `-L <Label>` | LV ラベルを指定。 |
| `-m <MapFile>` | PV 配置の map file を指定。 |
| `-M <Mirror>` | ミラープール名を指定。 |
| `-N <FirstNode>` | 最初のノード割当を指定。 |
| `-o <off\|on>` | シリアライゼーション on/off。 |
| `-p <Permission>` | アクセス権限（rw / r）。 |
| `-r <Relocation>` | 再配置可否（y / n）。 |
| `-R <PreferredCopy>` | 希望コピー番号を指定。 |
| `-s <Strict>` | ミラー strict ポリシー（s=同 PV 不可、p=parallel、n=non-strict）。 |
| `-S <Stripsize>` | stripe サイズを指定。 |
| `-t <Type>` | LV タイプ（jfs2 / jfs / sysdump / paging / boot 等）。 |
| `-T <Strict>` | Inter-physical volume policy。 |
| `-u <Upperbound>` | ミラーで使う PV の最大数。 |
| `-U <UserID>` | LV 所有ユーザ ID を指定。 |
| `-v <Verify>` | verify writes（y/n）。 |
| `-w <Mwc>` | Mirror Write Consistency 設定（active/passive/off）。 |
| `-W <Wait>` | wait 設定。 |
| `-x <MaxLPs>` | LV の最大 LP 数を指定。 |
| `-y <LV>` | LV 名を指定（省略時は自動採番 lv00 等）。 |
| `-Y <Prefix>` | LV 名のプレフィックス指定。 |

**典型例**:

```
mklv -y datalv -t jfs2 datavg 100  # 100 PP の jfs2 LV
mklv -c 2 -s s rootvg 16 hdisk1 hdisk2  # ミラー LV
```

**注意点**: -c 2 -s s で同期書き込み（safe）ミラー。-c 2 -s n = 順次。-c 2 -s p = parallel write（高速、デフォルト）。

**関連手順**: [cfg-vg-lv](08-config-procedures.md#cfg-vg-lv), [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror)

**関連用語**: LV, LP, mirror

**出典**: S_AIX73_commands1

---

## ファイルシステム（3 件）

### `df` { #df }

**用途**: ファイルシステムの容量と使用率を表示する。FS full 検知の最初のコマンド。

**構文**:

```
df [-g] [-k] [-m] [-i] [<FS>]
```

**全オプション一覧**（16 件）:

| オプション | 説明 |
|---|---|
| `-A` | 全ファイルシステムタイプを含めて表示。 |
| `-c` | 出力区切りに `:` を使用（スクリプト用）。 |
| `-F <vfstype>` | 指定 vfstype の FS のみ表示。 |
| `-g` | GB 単位で表示（最も読みやすい）。 |
| `-i` | inode 使用率のみ表示。 |
| `-I` | inode 使用率を含めて表示。 |
| `-k` | KB（1024 バイト）単位で表示。 |
| `-l` | ローカル FS のみ表示。 |
| `-m` | MB 単位で表示。 |
| `-n` | FS タイプも表示。 |
| `-P` | POSIX 出力フォーマット。 |
| `-s` | サマリ表示。 |
| `-t` | FS タイプを表示。 |
| `-T` | 詳細出力（タイプ列付き）。 |
| `-v` | 全 FS 情報（マウント済 + 未マウント）を表示。 |
| `<FS>` | 個別 FS（または対象パス）のみ表示。 |

**典型例**:

```
df -g    # GB 単位
df -i    # i-node 使用率
df /var  # 個別 FS
```

**注意点**: df -k はブロック数（512 バイト）。-g で GB、-m で MB 表記が読みやすい。

**関連手順**: [inc-fs-full](09-incident-procedures.md#inc-fs-full), [cfg-fs-extend](08-config-procedures.md#cfg-fs-extend)

**関連用語**: JFS2

**出典**: S_AIX73_commands1

---

### `chfs` { #chfs }

**用途**: ファイルシステムを動的に変更（拡張、属性変更）する。FS full の対応で頻用。

**構文**:

```
chfs -a size=+<追加サイズ> <マウントポイント>
chfs -a size=<絶対サイズ> <マウントポイント>
```

**全オプション一覧**（8 件）:

| オプション | 説明 |
|---|---|
| `-a <Attr>=<Val>` | 属性=値（size/logname/quota/frag/nbpi/options 等）を変更。 |
| `-A <yes\|no>` | boot 時自動マウントの有無を切り替え。 |
| `-d <Attr>` | 指定属性を削除する。 |
| `-m <NewMount>` | マウントポイントを変更。 |
| `-n <NodeName>` | ノード名を変更（クラスタ FS）。 |
| `-p <Permission>` | FS 権限を変更（ro/rw）。 |
| `-t <yes\|no>` | 外付け FS 設定（yes=外部、no=内部）。 |
| `-u <MountGroup>` | マウントグループを変更。 |

**典型例**:

```
chfs -a size=+1G /var      # 1GB 追加
chfs -a size=4G /opt       # 絶対値で 4GB に
chfs -a logname=INLINE /home  # JFS2 INLINE log 化
```

**注意点**: size の単位省略時は 512 バイトブロック数。基底 LV と JFS2 メタデータ両方を伸ばす。VG に空き PP 必要。

**関連手順**: [inc-fs-full](09-incident-procedures.md#inc-fs-full), [cfg-fs-extend](08-config-procedures.md#cfg-fs-extend)

**関連用語**: JFS2, LV

**出典**: S_AIX73_commands1

---

### `fsck` { #fsck }

**用途**: ファイルシステムの整合性チェック。boot 失敗時や強制 unmount 後に必須。

**構文**:

```
fsck [-y] [-p] [-V <vfstype>] <FS>
fsck -y /dev/lv01  # LV 直指定
```

**全オプション一覧**（10 件）:

| オプション | 説明 |
|---|---|
| `-c` | JFS の logredo を実行。 |
| `-f` | 強制チェック（前回 unmount が clean でも実行）。 |
| `-i <File>` | 代替 i-node テーブルファイルを使用。 |
| `-n` | 全ての修復確認に no と回答（チェックのみ、変更しない）。 |
| `-o <Options>` | FS 別オプションを渡す（例: full,nolog）。 |
| `-p` | 高速モード。修復不要なら何もしない。 |
| `-t <File>` | 代替テンプファイルを指定。 |
| `-V <vfstype>` | FS タイプを指定（jfs2 / jfs 等）。 |
| `-y` | 全ての修復確認に yes と回答（自動修復）。 |
| `<FS>` | 対象 FS（マウントポイントまたは LV パス）。 |

**典型例**:

```
fsck -y /home  # 自動 yes
fsck -p /home  # 高速チェック
```

**注意点**: **実行前に必ず unmount**（/ や /usr 等は単独ユーザモード or boot 中のみ）。JFS2 は通常 INLINE log があるため fsck 不要だが、メタデータ破損疑い時は実施。

**関連手順**: [inc-fsck-required](09-incident-procedures.md#inc-fsck-required), [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led)

**関連用語**: JFS2

**出典**: S_AIX73_commands1

---

## ネットワーク（5 件）

### `ifconfig` { #ifconfig }

**用途**: ネットワークインターフェースの状態確認・一時設定変更。

**構文**:

```
ifconfig [<Interface>] [up|down] [<IP> netmask <Mask>]
```

**全オプション一覧**（14 件）:

| オプション | 説明 |
|---|---|
| `-a` | 全インターフェースを表示。 |
| `-l` | 現在動作中のインターフェース名のリストを表示。 |
| `-d` | down 状態のインターフェースのみ表示。 |
| `-u` | up 状態のインターフェースのみ表示。 |
| `up` | インターフェースを有効化する。 |
| `down` | インターフェースを無効化する。 |
| `<IP> netmask <Mask>` | IP とサブネットマスクを設定（一時的）。 |
| `alias <IP>` | IP エイリアス（追加 IP）を割り当てる。 |
| `delete <IP>` | IP エイリアスを削除する。 |
| `mtu <Size>` | MTU サイズを変更する。 |
| `detach` | インターフェースを ODM から切り離す。 |
| `arp` | ARP プロトコルを有効化（既定）。 |
| `-arp` | ARP プロトコルを無効化。 |
| `media <Type>` | メディアタイプを指定（auto/100_full 等）。 |

**典型例**:

```
ifconfig -a              # 全インターフェース
ifconfig en0             # 個別
ifconfig en0 down        # 一時停止
ifconfig en0 192.168.1.10 netmask 255.255.255.0 up
```

**注意点**: ifconfig での変更は揮発性。永続化は chdev -l en0 -a netaddr=... -P で行う。

**関連手順**: [cfg-hostname-ip](08-config-procedures.md#cfg-hostname-ip), [inc-network-down](09-incident-procedures.md#inc-network-down)

**関連用語**: TCP/IP

**出典**: S_AIX73_commands1

---

### `netstat` { #netstat }

**用途**: ネットワーク接続・統計情報を表示する。性能・障害切り分けで頻用。

**構文**:

```
netstat [-rn] [-an] [-i] [-s] [-v] [-D]
```

**全オプション一覧**（29 件）:

| オプション | 説明 |
|---|---|
| `-a` | 全 socket（LISTEN 含む）を表示。 |
| `-A` | プロトコル制御ブロックアドレスを表示。 |
| `-b` | システム socket バッファ統計を表示。 |
| `-B` | buffer 詳細を表示。 |
| `-c` | メモリプール統計を表示。 |
| `-C` | ルーティングテーブルを cluster 形式で表示。 |
| `-d` | ドロップパケット統計を表示。 |
| `-D` | デバイス別 dropped パケット統計を表示。 |
| `-e` | 拡張イーサネット統計を表示。 |
| `-f <AddressFamily>` | 指定アドレスファミリ（inet/inet6/unix）に絞る。 |
| `-g` | ip マルチキャストグループメンバシップを表示。 |
| `-i` | インターフェース統計（パケット数、エラー数）を表示。 |
| `-I <Interface>` | 指定インターフェースの統計を表示。 |
| `-m` | mbuf（メモリバッファ）使用状況を表示。 |
| `-M` | ルートマルチキャスト情報を表示。 |
| `-n` | 数値形式（DNS 解決しない）で表示。 |
| `-o <Interval>` | ip フラグメント情報を指定間隔で表示。 |
| `-p <Proto>` | 特定プロトコル（tcp/udp/ip 等）に絞る。 |
| `-P <PluginName>` | プラグイン情報を表示。 |
| `-Q` | qos socket 情報を表示。 |
| `-r` | ルーティングテーブルを表示。 |
| `-R` | ルーティング更新情報を表示。 |
| `-s` | プロトコル別統計を表示。 |
| `-S` | ステートで詳細表示。 |
| `-t` | TCP socket のみ表示。 |
| `-T` | TCP 接続のタイマ情報を表示。 |
| `-u` | UDP socket のみ表示。 |
| `-v` | ドライバ詳細統計を表示。 |
| `-V` | VIPA 情報を表示。 |

**典型例**:

```
netstat -rn   # ルーティングテーブル
netstat -an   # 全接続
netstat -i    # インターフェース統計
netstat -v    # ドライバ統計（エラー数）
```

**注意点**: netstat -i のエラー列が増え続けるなら NIC ハードウェア障害疑い。

**関連手順**: [inc-network-down](09-incident-procedures.md#inc-network-down), [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation)

**関連用語**: TCP/IP

**出典**: S_AIX73_commands1

---

### `no` { #no }

**用途**: TCP/IP ネットワーク tunable の表示・設定。

**構文**:

```
no -a                    # 全 tunable
no -L <Tunable>          # 詳細
no -p -o <T>=<V>         # 永続変更
no -d <T>                # 既定値復元
```

**全オプション一覧**（11 件）:

| オプション | 説明 |
|---|---|
| `-a` | 全 tunable と現在値を表示。 |
| `-c` | 実機と nextboot の値を比較表示。 |
| `-d <T>` | tunable を既定値に戻す。 |
| `-D` | 全 tunable を既定値に戻す。 |
| `-F -o <T>=<V>` | restricted tunable を変更する（強制）。 |
| `-h <T>` | tunable のヘルプを表示。 |
| `-L <Tunable>` | tunable の詳細（CUR/DEF/BOOT/MIN/MAX/UNIT/TYPE）を表示。 |
| `-o <T>=<V>` | tunable を変更（実機のみ、再起動で消える）。 |
| `-p -o <T>=<V>` | 実機 + nextboot ファイルに永続保存。 |
| `-r -o <T>=<V>` | nextboot のみ変更（次回起動から有効）。 |
| `-x` | stanza 形式で全 tunable を表示。 |

**典型例**:

```
no -L tcp_sendspace
no -p -o tcp_sendspace=262144
```

**注意点**: AIX 7.3 から restricted tunable（直接編集禁止のもの）は no -F が必要。NFS 系は nfso を使う（no ではない）。

**関連手順**: [cfg-tcp-buffers](08-config-procedures.md#cfg-tcp-buffers)

**関連用語**: tunable, restricted tunable

**出典**: S_AIX73_performance

---

### `nfso` { #nfso }

**用途**: NFS 専用 tunable の表示・設定。`no` ではなくこちらで管理する。

**構文**:

```
nfso -a                  # 全 NFS tunable
nfso -L <T>              # 詳細
nfso -p -o <T>=<V>       # 永続
```

**全オプション一覧**（10 件）:

| オプション | 説明 |
|---|---|
| `-a` | 全 NFS tunable と現在値を表示。 |
| `-c` | 実機と nextboot の値を比較表示。 |
| `-d <T>` | tunable を既定値に戻す。 |
| `-D` | 全 NFS tunable を既定値に戻す。 |
| `-h <T>` | tunable のヘルプを表示。 |
| `-L <T>` | tunable の詳細（CUR/DEF/BOOT/MIN/MAX/UNIT/TYPE）を表示。 |
| `-o <T>=<V>` | tunable を変更（実機のみ）。 |
| `-p -o <T>=<V>` | 実機 + nextboot に永続保存。 |
| `-r -o <T>=<V>` | nextboot のみ変更。 |
| `-x` | stanza 形式で全 tunable を表示。 |

**典型例**:

```
nfso -L nfs_socketsize
nfso -p -o nfs_rfc1323=1
```

**注意点**: v3 で nfs_socketsize を `no` で扱った誤りを修正。NFS tunable は nfso 専用。

**関連手順**: [cfg-nfs-mount](08-config-procedures.md#cfg-nfs-mount)

**関連用語**: NFS, tunable

**出典**: S_AIX73_nfso

---

### `ping` { #ping }

**用途**: ICMP echo によるネットワーク到達性確認。

**構文**:

```
ping [-c <count>] [-s <size>] <Host>
```

**全オプション一覧**（22 件）:

| オプション | 説明 |
|---|---|
| `-A` | Audible（応答音）モード。 |
| `-c <Count>` | 送信回数を指定。 |
| `-d` | ソケット debugging を有効化。 |
| `-D` | DF（Don't Fragment）ビット設定。 |
| `-f` | flood ping（高速連続送信）— root 権限必要。 |
| `-i <Interval>` | 送信間隔（秒）を指定。 |
| `-I <Interface>` | 送信元インターフェースを指定。 |
| `-l <Preload>` | preload 数（最初の連続送信回数）を指定。 |
| `-L` | マルチキャスト loop back を抑止。 |
| `-n` | 数値形式（DNS 解決しない）。 |
| `-p <Pattern>` | 送信パターンを 16 進数で指定。 |
| `-P` | Path MTU Discovery モード。 |
| `-q` | quiet モード（最終統計のみ表示）。 |
| `-r` | ローカルネットワークに直接送信（gateway 経由しない）。 |
| `-R` | Record route を要求。 |
| `-s <Size>` | 送信パケットサイズ（バイト）を指定。 |
| `-S <Source>` | 送信元 IP を指定（複数 NIC 環境）。 |
| `-t <TTL>` | TTL（time to live）を指定。 |
| `-T <Timestamp>` | Timestamp option を要求。 |
| `-v` | verbose 出力（ICMP packet 全表示）。 |
| `-V` | version 情報を表示。 |
| `-w <Timeout>` | 応答待機タイムアウト（秒）。 |

**典型例**:

```
ping -c 4 192.168.1.1
ping -c 10 -s 8000 server.example.com  # MTU/jumbo frame 確認
```

**注意点**: AIX の ping は既定で連続送信。-c で回数指定するのが安全。

**関連手順**: [inc-network-down](09-incident-procedures.md#inc-network-down)

**関連用語**: ICMP, TCP/IP

**出典**: S_AIX73_commands1

---

## 性能・プロセス（5 件）

### `vmstat` { #vmstat }

**用途**: 仮想メモリ・CPU・I/O 統計を表示。性能ボトルネック切り分けの第一歩。

**構文**:

```
vmstat [<interval> [<count>]]
vmstat -v   # メモリ詳細
```

**全オプション一覧**（16 件）:

| オプション | 説明 |
|---|---|
| `-c` | コンテンキストスイッチ統計を表示。 |
| `-f` | fork/vfork 統計を表示。 |
| `-h` | hypervisor 関連統計を表示。 |
| `-i` | デバイス割り込み統計を表示。 |
| `-I` | I/O 待ちプロセス数を含めて表示。 |
| `-l` | large page 統計を含める。 |
| `-p <PageSize>` | 特定ページサイズに絞る。 |
| `-P all` | 全ページサイズの統計を表示。 |
| `-s` | 起動時からの累積統計サマリを表示。 |
| `-S` | page size を別に集計。 |
| `-t` | 各行にタイムスタンプを付与。 |
| `-T` | 詳細タイムスタンプを表示。 |
| `-v` | メモリ詳細統計（pin、computational pages、free 等）を表示。 |
| `-w` | wide 出力モード（カラム幅を広げる）。 |
| `-W` | より詳細な wide モード（worker thread 含む）。 |
| `<Interval> <Count>` | 間隔（秒）と回数を指定して定期表示。 |

**典型例**:

```
vmstat 5 12  # 5 秒ごとに 12 回
vmstat -v    # ページング詳細
vmstat -s    # サマリ
```

**注意点**: wa（I/O 待ち）が常時 30%+ なら I/O ボトルネック、avm（active virtual memory）が増え続けるならメモリリーク疑い。

**関連手順**: [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation)

**関連用語**: VMM, paging

**出典**: S_AIX73_performance

---

### `iostat` { #iostat }

**用途**: ディスク I/O 統計を表示。

**構文**:

```
iostat [-d] [<interval> [<count>]]
iostat -DRTl  # 詳細出力（read/write 別、レイテンシ）
```

**全オプション一覧**（26 件）:

| オプション | 説明 |
|---|---|
| `-a` | アダプタ別統計を表示。 |
| `-A` | AIO 統計を表示。 |
| `-b <Buffer>` | I/O blocks 表示。 |
| `-d` | ディスク統計のみ表示（CPU 統計を省略）。 |
| `-D` | 詳細ディスク統計（read/write 別、レイテンシ）を表示。 |
| `-e` | エラー統計を含めて表示。 |
| `-E <Stats>` | 拡張統計を表示。 |
| `-f <FsName>` | 指定 FS の統計を表示。 |
| `-F` | ファイルシステム統計を表示。 |
| `-l` | long listing（フィールド多め）。 |
| `-L` | ロック競合統計を表示。 |
| `-m` | MPIO 統計を表示。 |
| `-M` | Multi-path 詳細統計を表示。 |
| `-N` | NFS 統計を表示。 |
| `-p <Period>` | Period 別に集計。 |
| `-P` | PV 別の活動を表示。 |
| `-q` | quiet モード（ヘッダ抑止）。 |
| `-Q` | QoS 統計を表示。 |
| `-R` | 間隔ごとに統計をリセット。 |
| `-s <Sys>` | システム別の統計。 |
| `-t` | TTY 統計を表示。 |
| `-T` | 各行にタイムスタンプを付与。 |
| `-V` | vSCSI 統計を表示。 |
| `-X` | 詳細サマリ統計。 |
| `-z` | 起動時からの統計をリセット（root のみ）。 |
| `<Interval> <Count>` | 間隔（秒）と回数を指定。 |

**典型例**:

```
iostat 5 12   # 5 秒ごと
iostat -DRTl 5 12  # 詳細形式
```

**注意点**: %tm_act（busy 率）80%+ が継続するディスクは飽和。

**関連手順**: [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation)

**関連用語**: disk I/O

**出典**: S_AIX73_performance

---

### `topas` { #topas }

**用途**: リアルタイム性能モニタ（CPU、メモリ、I/O、ネットワーク、プロセス）。Linux の top 相当。

**構文**:

```
topas [-i <interval>] [-P|-D|-L]
```

**全オプション一覧**（23 件）:

| オプション | 説明 |
|---|---|
| `-a` | AIO 表示モード。 |
| `-c <Lines>` | プロセス表示行数を指定。 |
| `-C` | クロスパーティション（HMC 経由）モニタ。 |
| `-d <Disks>` | ディスクモニタ表示。 |
| `-D` | ディスク詳細表示モード。 |
| `-f <Lines>` | ファイルシステム表示行数。 |
| `-F <FilterValue>` | フィルタ値を指定。 |
| `-h` | ヘルプ表示。 |
| `-i <Interval>` | 更新間隔（秒）を指定。 |
| `-I` | I/O 待ちのプロセスを表示。 |
| `-L` | LPAR 統計表示モード。 |
| `-m` | メモリページング情報を表示。 |
| `-n <Networks>` | ネットワーク表示行数。 |
| `-N` | NFS 統計表示。 |
| `-p <Procs>` | プロセス表示数。 |
| `-P` | プロセス詳細表示モード。 |
| `-q` | qos 統計を含めて表示。 |
| `-R <FileName>` | topasrec ファイルを再生する。 |
| `-T <Lines>` | TTY 統計表示行数。 |
| `-U` | ユーザ別 CPU 利用率表示。 |
| `-V` | version 情報を表示。 |
| `-w <WLM>` | WLM クラス統計表示。 |
| `-W` | WPAR 統計表示モード。 |

**典型例**:

```
topas         # 統合表示
topas -P      # プロセス詳細
topas -D      # ディスク詳細
topas -L      # LPAR 統計
```

**注意点**: topasrec で記録、topas -R で再生可能。SSH 経由でも動作。

**関連手順**: [inc-perf-degradation](09-incident-procedures.md#inc-perf-degradation), [inc-process-hung](09-incident-procedures.md#inc-process-hung)

**関連用語**: performance

**出典**: S_AIX73_performance

---

### `ps` { #ps }

**用途**: プロセス一覧表示。

**構文**:

```
ps -ef       # 全プロセス
ps aux       # BSD 形式
ps -eo pid,pcpu,pmem,user,args  # カスタム
```

**全オプション一覧**（30 件）:

| オプション | 説明 |
|---|---|
| `-a` | セッションリーダ以外の全プロセスを表示（terminal 付き）。 |
| `-A` | 全プロセスを表示（-e と同じ）。 |
| `-c <CmdName>` | 指定コマンド名のプロセスを表示。 |
| `-d` | セッションリーダ以外の全プロセスを表示。 |
| `-e` | 全プロセスを表示。 |
| `-f` | 完全（full）形式で表示（UID, PPID, STIME 等）。 |
| `-F <Format>` | カスタムフォーマットで表示。 |
| `-g <PgrpList>` | 指定プロセスグループのプロセスを表示。 |
| `-G <GroupList>` | 指定グループのプロセスを表示。 |
| `-H` | Hyperthread CPU 情報を表示。 |
| `-j` | JID/PID/PGID/PPID/Job ID を表示。 |
| `-k` | カーネルプロセスを含めて表示。 |
| `-l` | long 形式で表示（NI, SZ 等）。 |
| `-L` | Light Weight Process（LWP）情報を表示。 |
| `-m` | プロセス内のスレッドも表示。 |
| `-mo THREAD` | 全プロセスのスレッド構造を表示。 |
| `-M <Mode>` | 64bit プロセスのみまたは 32bit プロセスのみ。 |
| `-n <NameList>` | 代替プロセスデータベースを使用。 |
| `-o <Format>` | カスタム列フォーマット（pid,pcpu,pmem,user,args 等）。 |
| `-p <PIDList>` | 指定 PID のみ表示。 |
| `-P` | 親 PID を含めて表示。 |
| `-r` | RBAC 関連情報を表示。 |
| `-s <SidList>` | 指定セッション ID のプロセスを表示。 |
| `-t <Term>` | 指定端末のプロセスを表示。 |
| `-T <PID>` | プロセス内のスレッド一覧を表示。 |
| `-u <UIDList>` | 指定ユーザのプロセスを表示（既定 = 自分）。 |
| `-U <UIDList>` | 指定ユーザ ID のプロセスを表示。 |
| `-w` | wide 出力（コマンドライン全体表示）。 |
| `-X` | 拡張プロセス情報を表示。 |
| `-Z` | WPAR 名を表示。 |

**典型例**:

```
ps -ef | grep db2
ps -eo pid,pcpu,pmem,args --sort=-pcpu | head
```

**注意点**: AIX の ps は SVR4 系と BSD 系両方対応。-T <pid> でスレッド表示。

**関連手順**: [inc-process-hung](09-incident-procedures.md#inc-process-hung)

**関連用語**: process

**出典**: S_AIX73_commands1

---

### `kill` { #kill }

**用途**: プロセスにシグナルを送る。hung プロセス停止に使う。

**構文**:

```
kill [-<signal>] <pid>
```

**全オプション一覧**（14 件）:

| オプション | 説明 |
|---|---|
| `-l` | シグナル一覧を表示。 |
| `-s <Signal>` | シグナル名指定（例: -s TERM）。 |
| `<PID>` | デフォルト SIGTERM（15）を送信。 |
| `-1 <PID>` | SIGHUP（設定再読み込み）を送信。 |
| `-2 <PID>` | SIGINT（Ctrl+C 相当）を送信。 |
| `-3 <PID>` | SIGQUIT（core dump 付き終了）を送信。 |
| `-9 <PID>` | SIGKILL を送信（強制終了、復旧不可）。 |
| `-15 <PID>` | SIGTERM 明示送信（クリーン終了要求）。 |
| `-HUP <PID>` | SIGHUP（設定再読み込み）を送信。 |
| `-INT <PID>` | SIGINT（割り込み）を送信。 |
| `-USR1 <PID>` | SIGUSR1（アプリ独自処理）を送信。 |
| `-USR2 <PID>` | SIGUSR2（アプリ独自処理）を送信。 |
| `-STOP <PID>` | プロセスを一時停止（再開は -CONT）。 |
| `-CONT <PID>` | 停止中プロセスを再開。 |

**典型例**:

```
kill 12345        # SIGTERM
kill -9 12345     # SIGKILL（強制）
kill -HUP 12345   # 設定再読み込み
```

**注意点**: **いきなり -9 はしない**。SIGTERM → 数秒待つ → 効かなければ -9 が原則。-9 は OS のクリーンアップ処理を飛ばす。

**関連手順**: [inc-process-hung](09-incident-procedures.md#inc-process-hung)

**関連用語**: signal

**出典**: S_AIX73_commands1

---

## チューニング（3 件）

### `ioo` { #ioo }

**用途**: I/O 関連の VMM tunable（j2_inodeCacheSize 等）を表示・設定する。

**構文**:

```
ioo -a                   # 全表示
ioo -L <T>               # 詳細
ioo -p -o <T>=<V>        # 永続
```

**全オプション一覧**（11 件）:

| オプション | 説明 |
|---|---|
| `-a` | 全 I/O tunable と現在値を表示。 |
| `-c` | 実機と nextboot の値を比較表示。 |
| `-d <T>` | tunable を既定値に戻す。 |
| `-D` | 全 I/O tunable を既定値に戻す。 |
| `-F -o <T>=<V>` | restricted tunable を強制変更。 |
| `-h <T>` | ヘルプ（tunable 説明）を表示。 |
| `-L <T>` | tunable の詳細を表示。 |
| `-o <T>=<V>` | tunable を変更（実機のみ）。 |
| `-p -o <T>=<V>` | 実機 + nextboot に永続保存。 |
| `-r -o <T>=<V>` | nextboot のみ変更。 |
| `-x` | stanza 形式で全 tunable を表示。 |

**典型例**:

```
ioo -L j2_inodeCacheSize
ioo -p -o j2_inodeCacheSize=400 -o j2_metadataCacheSize=400
```

**注意点**: AIX 7.3 で j2_inodeCacheSize の既定が 400 → 200。低メモリで多数 open file する場合は要再設定。

**関連手順**: [cfg-ioo-tuning](08-config-procedures.md#cfg-ioo-tuning)

**関連用語**: tunable, VMM, JFS2

**出典**: S_AIX73_performance

---

### `vmo` { #vmo }

**用途**: VMM（Virtual Memory Manager）の tunable を表示・設定する。

**構文**:

```
vmo -a
vmo -L <T>
vmo -p -o <T>=<V>
```

**全オプション一覧**（11 件）:

| オプション | 説明 |
|---|---|
| `-a` | 全 VMM tunable と現在値を表示。 |
| `-c` | 実機と nextboot の値を比較表示。 |
| `-d <T>` | tunable を既定値に戻す。 |
| `-D` | 全 VMM tunable を既定値に戻す。 |
| `-F -o <T>=<V>` | restricted tunable を強制変更。 |
| `-h <T>` | ヘルプを表示。 |
| `-L <T>` | tunable の詳細を表示。 |
| `-o <T>=<V>` | tunable を変更（実機のみ）。 |
| `-p -o <T>=<V>` | 実機 + nextboot に永続保存。 |
| `-r -o <T>=<V>` | nextboot のみ変更。 |
| `-x` | stanza 形式で全 tunable を表示。 |

**典型例**:

```
vmo -L minperm%
vmo -p -o minperm%=3 -o maxperm%=90
```

**注意点**: Restricted tunable は -F 必須。lru_file_repage は AIX 7.1 以降 effectively no-op。

**関連手順**: `cfg-vmo-tuning`

**関連用語**: VMM, tunable

**出典**: S_AIX73_performance

---

### `schedo` { #schedo }

**用途**: CPU スケジューラの tunable を表示・設定する。

**構文**:

```
schedo -a
schedo -L <T>
schedo -p -o <T>=<V>
```

**全オプション一覧**（11 件）:

| オプション | 説明 |
|---|---|
| `-a` | 全スケジューラ tunable と現在値を表示。 |
| `-c` | 実機と nextboot の値を比較表示。 |
| `-d <T>` | tunable を既定値に戻す。 |
| `-D` | 全スケジューラ tunable を既定値に戻す。 |
| `-F -o <T>=<V>` | restricted tunable を強制変更。 |
| `-h <T>` | ヘルプを表示。 |
| `-L <T>` | tunable の詳細を表示。 |
| `-o <T>=<V>` | tunable を変更（実機のみ）。 |
| `-p -o <T>=<V>` | 実機 + nextboot に永続保存。 |
| `-r -o <T>=<V>` | nextboot のみ変更。 |
| `-x` | stanza 形式で全 tunable を表示。 |

**典型例**:

```
schedo -L vpm_throughput_mode
schedo -p -o vpm_throughput_mode=2
```

**注意点**: Power10 共有プロセッサモードで vpm_throughput_mode=2 が既定。誤った値で性能劣化することあり。

**関連手順**: `cfg-schedo-tuning`

**関連用語**: scheduler, tunable

**出典**: S_AIX73_performance

---

## パッケージ管理（3 件）

### `lslpp` { #lslpp }

**用途**: インストール済 fileset 一覧と詳細情報を表示する。

**構文**:

```
lslpp -L                 # 全 fileset
lslpp -L <fileset>       # 個別
lslpp -h <fileset>       # 履歴
lslpp -f <fileset>       # 構成ファイル一覧
```

**全オプション一覧**（22 件）:

| オプション | 説明 |
|---|---|
| `-a` | 全エントリ（applied/committed 両方）を表示。 |
| `-B <BlackList>` | ブラックリストファイルを指定。 |
| `-c` | コロン区切り出力（スクリプト用）。 |
| `-d <Fileset>` | fileset の依存関係（依存される側）を表示。 |
| `-e <FilesetList>` | 指定 fileset 以外を表示（exclusion）。 |
| `-f <Fileset>` | fileset に含まれるファイル一覧を表示。 |
| `-h <Fileset>` | fileset の install/update 履歴を表示。 |
| `-i <Fileset>` | fileset 情報（説明等）を表示。 |
| `-I` | 詳細情報を表示。 |
| `-J` | JSON 形式で出力。 |
| `-L` | Software Vital Product Data 形式で表示（最も標準）。 |
| `-l` | 簡易リスト形式で表示。 |
| `-m <Fileset>` | fileset の Distributor の情報を表示。 |
| `-O <Source>` | 代替 install ソースを表示。 |
| `-p <Fileset>` | fileset の前提（prerequisites）を表示。 |
| `-q` | quiet モード（ヘッダ抑止）。 |
| `-r` | RPM パッケージのみ表示。 |
| `-s <Fileset>` | fileset のサイズを表示。 |
| `-S <Type>` | Type 別の表示（C=committed, A=applied）。 |
| `-u <Fileset>` | fileset の supersede 情報を表示。 |
| `-w <File>` | 指定ファイルがどの fileset に属するかを表示。 |
| `-X` | 拡張情報を含めて表示。 |

**典型例**:

```
lslpp -L bos.rte
lslpp -h bos.net.tcp.client  # 何時何が入ったか
```

**注意点**: VRMF（Version.Release.Modification.Fix）形式で表示。

**関連手順**: [cfg-package-install](08-config-procedures.md#cfg-package-install), [inc-package-install-fail](09-incident-procedures.md#inc-package-install-fail)

**関連用語**: fileset, VRMF

**出典**: S_AIX73_commands1

---

### `installp` { #installp }

**用途**: BFF/RPM 形式の fileset をインストール・更新・削除する。

**構文**:

```
installp -aXd <Source> <Fileset>      # 適用
installp -u <Fileset>                 # 削除
installp -p -aXd <Source> <Fileset>   # プレビュー
installp -L                          # 適用済一覧
```

**全オプション一覧**（36 件）:

| オプション | 説明 |
|---|---|
| `-a` | 適用（apply）モード。 |
| `-A` | fileset の前提も含めて apply。 |
| `-b` | broker mode（NIM 用）。 |
| `-B` | broker mode（NIM 用、別動作）。 |
| `-c` | commit モード（applied → committed）。 |
| `-C` | fileset の cleanup モード。 |
| `-d <Source>` | ソース（DVD、ディレクトリ等）を指定。 |
| `-D <Device>` | 代替デバイスを指定。 |
| `-e <Log>` | ログファイル指定。 |
| `-E` | ライセンス受諾を確認モードで表示。 |
| `-f <File>` | fileset リストをファイルから取得。 |
| `-F` | force install（既存より古いバージョンも上書き）。 |
| `-g` | 事前要件 fileset を自動 install。 |
| `-G` | GUI モードを起動。 |
| `-i` | i 状態（installed）の fileset を出力。 |
| `-j <Function>` | specific 関数のみ実行。 |
| `-J` | ライセンス情報を表示。 |
| `-l` | fileset リストをローカルから収集。 |
| `-L` | 適用済 fileset 情報を出力。 |
| `-M <Platform>` | プラットフォーム指定（POWER/RS6K 等）。 |
| `-N` | fileset の整合性チェックを抑止。 |
| `-O { r \| s \| u }` | Operation: r=reject, s=show status, u=undo。 |
| `-p` | preview のみ実行（試験）。 |
| `-q` | quiet モード。 |
| `-Q` | Quiet を抑止して全メッセージ表示。 |
| `-r` | reject モード（applied 状態を取消）。 |
| `-R` | 代替 base directory を指定。 |
| `-S` | save サイズを抑制。 |
| `-t <SaveDir>` | 保存ディレクトリ指定（commit 前）。 |
| `-u` | uninstall（fileset 削除）。 |
| `-V <Verbosity>` | 詳細レベルを指定（0=最小、4=最大）。 |
| `-w` | wait しない（バッチ用）。 |
| `-X` | FS が小さければ自動拡張する。 |
| `-Y` | ライセンス受諾を自動 yes。 |
| `-z <Block>` | block サイズ指定。 |
| `<Fileset>` | 対象 fileset 名（all で全 update）。 |

**典型例**:

```
installp -aXd /dev/cd0 bos.rte.man
installp -p -aXd . all > /tmp/preview.log
```

**注意点**: -X = 必要に応じて自動拡張、-a = 適用、-c = commit。-p = preview（試験のみ）。

**関連手順**: [cfg-package-install](08-config-procedures.md#cfg-package-install)

**関連用語**: fileset, BFF, LPP

**出典**: S_AIX73_commands1

---

### `instfix` { #instfix }

**用途**: AIX のフィックス（APAR、TL、SP）が適用されているかを確認する。

**構文**:

```
instfix -i                       # 全フィックス
instfix -ik <APAR>               # APAR 単位
instfix -ivk <APAR>              # 詳細
```

**全オプション一覧**（16 件）:

| オプション | 説明 |
|---|---|
| `-a` | ABSTRACT（説明文）を含めて表示。 |
| `-c` | コロン区切り形式（スクリプト用）。 |
| `-d <Source>` | 適用前にソース内の fix 情報を確認。 |
| `-f <File>` | ファイルから fix リストを取得。 |
| `-F` | 全 fix 情報を表示（強制）。 |
| `-i` | 全フィックス情報を表示。 |
| `-I` | fix の詳細情報を含む表示。 |
| `-k <APAR>` | 特定 APAR が適用されているか確認。 |
| `-K <APAR>` | APAR install を確認（exclusion 含む）。 |
| `-p` | preview only（実 install しない）。 |
| `-q` | quiet モード。 |
| `-r` | リクエストされた fix を表示。 |
| `-S` | SP 情報を表示。 |
| `-T` | TL 情報を表示。 |
| `-v` | 詳細表示モード。 |
| `-y` | auto yes 確認スキップ。 |

**典型例**:

```
instfix -i | grep ML  # ML 履歴
instfix -ivk IV12345  # 該当 APAR
```

**注意点**: ML（Maintenance Level）= 旧称、現在は TL。

**関連手順**: [cfg-package-install](08-config-procedures.md#cfg-package-install)

**関連用語**: APAR, TL, SP, ML

**出典**: S_AIX73_commands1

---

## システム情報・起動（4 件）

### `oslevel` { #oslevel }

**用途**: AIX のリリースレベルを表示する。

**構文**:

```
oslevel -s                # 完全レベル（TL/SP）
oslevel -r                # TL
oslevel -q                # 既知レベル一覧
```

**全オプション一覧**（14 件）:

| オプション | 説明 |
|---|---|
| `-g` | 現行レベルの全 fileset を表示。 |
| `-l <Level>` | 指定レベルに不足している fileset を表示。 |
| `-p` | preview モード（test）。 |
| `-q` | 既知レベル一覧を表示。 |
| `-r` | TL レベルのみ表示（例: 7300-04）。 |
| `-rf <File>` | ファイルからレベル情報を取得。 |
| `-rg` | TL 全 fileset を表示。 |
| `-rl <Level>` | TL レベルに不足する fileset を表示。 |
| `-rq` | TL 既知レベル一覧。 |
| `-s` | 完全レベル（TL/SP 含む）を表示（例: 7300-04-00-2546）。 |
| `-sf <File>` | ファイルから SP レベルを取得。 |
| `-sg` | SP の全 fileset を表示。 |
| `-sl <Level>` | SP レベルに不足する fileset を表示。 |
| `-sq` | SP 既知レベル一覧。 |

**典型例**:

```
oslevel -s
# 出力例: 7300-04-00-2546（AIX 7.3 TL4 SP0）
```

**注意点**: AIX 7.3 の最新は 7.3.4 / TL4（2025-12 リリース）。

**関連手順**: [cfg-package-install](08-config-procedures.md#cfg-package-install)

**関連用語**: TL, SP, VRMF

**出典**: S_AIX73_commands1

---

### `bootinfo` { #bootinfo }

**用途**: システム起動に関する情報を取得する。

**構文**:

```
bootinfo -K   # カーネルビット数
bootinfo -s   # ディスクサイズ
bootinfo -y   # 32bit/64bit ハードウェア
bootinfo -p   # POWER モデル
```

**全オプション一覧**（22 件）:

| オプション | 説明 |
|---|---|
| `-a` | ROM IPL アドレスを表示。 |
| `-b` | 前回の boot ディスクを表示。 |
| `-B <Disk>` | ディスクが boot 可能か確認（0=可、1=不可）。 |
| `-c` | コア dump device 情報を表示。 |
| `-e <Disk>` | ディスクのエンディアン情報を表示。 |
| `-k` | 稼働中カーネルのビット数を返す（32/64）。 |
| `-K` | 稼働中カーネルのビット数（32/64）を表示。 |
| `-L` | ルーフサイズ（lapi）を表示。 |
| `-m` | 稼働中マシンタイプを表示。 |
| `-M` | MCA バス情報を表示。 |
| `-o` | OEM model 情報。 |
| `-p` | POWER モデルタイプ（chrp 等）を表示。 |
| `-P` | プラットフォーム情報。 |
| `-q <Disk>` | ディスクの容量（KB）を表示。 |
| `-r <hdisk>` | ディスクの実 PP サイズを表示。 |
| `-R` | 実装メモリ情報。 |
| `-s <hdisk>` | 指定ディスクのサイズ（MB）を表示。 |
| `-T` | ハードウェアタイプを表示。 |
| `-u` | ユーザブル メモリ容量を表示。 |
| `-v` | Vital Product Data を表示。 |
| `-y` | システムが 32bit/64bit ハードかを表示。 |
| `-z` | セキュア boot mode 情報。 |

**典型例**:

```
bootinfo -K  # 64
bootinfo -p  # chrp
```

**注意点**: trace facility が AIX 7.3 で root 限定化されているため、特権必要なオプションあり。

**関連手順**: [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led)

**関連用語**: boot, kernel

**出典**: S_AIX73_commands1

---

### `bootlist` { #bootlist }

**用途**: 起動デバイスの順序を表示・変更する。boot 失敗対応で必須。

**構文**:

```
bootlist -m normal -o                       # 表示
bootlist -m normal hdisk0 hdisk1            # 設定
bootlist -m service hdisk0                  # サービスモード
```

**全オプション一覧**（9 件）:

| オプション | 説明 |
|---|---|
| `-i` | bootlist を invalidate（無効化）。 |
| `-m <Mode>` | モードを指定（normal / service / both / prevboot）。 |
| `-o` | 現在の bootlist を表示。 |
| `-O` | 詳細なフォーマットで表示。 |
| `-r` | bootlist を初期化（クリア）。 |
| `-v` | 詳細表示モード。 |
| `-w <Filename>` | boot 候補をファイルに書き出す。 |
| `<Devices>` | boot 順に並べたデバイスリスト（最大 5 デバイス）。 |
| `blv=<BLV>` | BLV（boot logical volume）を指定。 |

**典型例**:

```
bootlist -m normal -o
bootlist -m normal hdisk0 hdisk1 cd0
```

**注意点**: `-m normal` = 通常起動、`-m service` = 診断モード。最大 5 デバイス指定可。

**関連手順**: [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led), [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror)

**関連用語**: boot, hd5

**出典**: S_AIX73_commands1

---

### `bosboot` { #bosboot }

**用途**: ブートイメージ（BLV）を作成・更新する。カーネル変更後に必須。

**構文**:

```
bosboot -ad /dev/<bootdisk>
bosboot -ad /dev/ipldevice  # 現在の boot ディスク
```

**全オプション一覧**（13 件）:

| オプション | 説明 |
|---|---|
| `-a` | BLV を新規作成する（既存を上書き）。 |
| `-b <File>` | boot file を指定。 |
| `-D` | デバッグ情報入りの BLV を作成。 |
| `-d <Device>` | 対象 boot ディスク（例: /dev/hdisk0）を指定。 |
| `-I` | ramdisk image を作成しない。 |
| `-k <KernelName>` | 代替カーネル名を指定。 |
| `-l <File>` | ログファイルを指定。 |
| `-L` | Live update 用の BLV を作成。 |
| `-M <Mode>` | モード指定（boot / disk）。 |
| `-q` | BLV のサイズを照会するだけ（実作成しない）。 |
| `-r <File>` | ramdisk file system を指定。 |
| `-T <Type>` | ハードウェアタイプを指定（chrp 等）。 |
| `-w` | 新しい BLV にスキップ。 |

**典型例**:

```
bosboot -ad /dev/hdisk0
# rootvg ミラー後は両方のディスクに対し実施
```

**注意点**: BLV 作成中はディスク I/O が走るため業務影響に注意。失敗すると次回起動不可になる。

**関連手順**: [cfg-rootvg-mirror](08-config-procedures.md#cfg-rootvg-mirror), [inc-boot-fail-led](09-incident-procedures.md#inc-boot-fail-led)

**関連用語**: BLV, hd5

**出典**: S_AIX73_commands1

---

## バックアップ（2 件）

### `mksysb` { #mksysb }

**用途**: rootvg の bootable バックアップ（システムバックアップ）を作成する。

**構文**:

```
mksysb [-i] [-p] [-X] <Device|File>
```

**全オプション一覧**（18 件）:

| オプション | 説明 |
|---|---|
| `-A` | image.data を保存しない。 |
| `-b <Blocks>` | ブロックファクタ指定（テープ用）。 |
| `-B` | boot ブロックを除外（古いオプション、非推奨）。 |
| `-C <Compression>` | 圧縮レベル指定。 |
| `-e` | exclude.rootvg ファイルに従い特定ファイルを除外。 |
| `-F` | tape device を強制使用。 |
| `-G` | WPAR 含めずに backup。 |
| `-i` | image.data を自動生成・更新する。 |
| `-m` | image.data に map file を含める。 |
| `-M` | rootvg 以外も含めて mksysb を作成（multi-VG）。 |
| `-p` | ファイル圧縮（pack）を行わない。 |
| `-P` | プレビューのみ。 |
| `-T` | テストモード（詳細表示）。 |
| `-v` | verbose 出力（tar ヘッダ詳細）。 |
| `-V` | tar ヘッダ詳細表示。 |
| `-X` | FS が不足したら自動拡張する。 |
| `-Z` | ZX ファイルを除外。 |
| `<Device\|File>` | 出力先（テープ /dev/rmt0、ファイル /backup/foo.mksysb）。 |

**典型例**:

```
mksysb -i /dev/rmt0     # テープへ
mksysb -i /backup/sysb.mksysb  # ファイルへ
smit mksysb              # SMIT 経由
```

**注意点**: -i = image.data 自動更新、-p = pack 圧縮無し、-X = FS 自動拡張。NIM 経由で別 LPAR を NIM クライアントとして bootable 復元可能。

**関連手順**: [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup)

**関連用語**: mksysb, image.data, NIM

**出典**: S_AIX73_commands1

---

### `savevg` { #savevg }

**用途**: rootvg 以外の VG をバックアップする。

**構文**:

```
savevg -i [-X] <Device|File> <VG>
```

**全オプション一覧**（17 件）:

| オプション | 説明 |
|---|---|
| `-A` | image.data を保存しない。 |
| `-b <Blocks>` | ブロックファクタ指定（テープ用）。 |
| `-c` | 圧縮を無効化。 |
| `-e` | 除外ファイルリスト（/etc/exclude.<vg>）を適用。 |
| `-f <Device>` | 出力先を指定。 |
| `-i` | image.data を自動生成。 |
| `-l` | ログ取得モード。 |
| `-m` | map file を含めて保存。 |
| `-p` | ファイル圧縮（pack）を行わない。 |
| `-P` | preview モード。 |
| `-r <FileList>` | raw 部分指定。 |
| `-T` | テストモード。 |
| `-v` | verbose 出力。 |
| `-V` | tar ヘッダ詳細を表示。 |
| `-X` | FS が不足したら自動拡張。 |
| `-Z` | ZX ファイル除外。 |
| `<VG>` | 対象 VG 名（例: datavg）。 |

**典型例**:

```
savevg -if /backup/datavg.savevg datavg
```

**注意点**: 復元は restvg。データのみ、boot 不可（mksysb と違って bootable ではない）。

**関連手順**: [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup)

**関連用語**: savevg, restvg

**出典**: S_AIX73_commands1

---

## ユーザ・セキュリティ（3 件）

### `lsuser` { #lsuser }

**用途**: ユーザ属性を一覧・表示する。

**構文**:

```
lsuser [-a <attr>] ALL
lsuser <user>
```

**全オプション一覧**（7 件）:

| オプション | 説明 |
|---|---|
| `-a <Attrs>` | 表示する属性を指定（id, home, shell, maxage 等）。 |
| `-c` | コロン区切り形式（スクリプト用）。 |
| `-C` | コロン区切り形式（拡張）。 |
| `-f` | スタンザ形式で表示（chsec 編集用）。 |
| `-R <Module>` | 認証モジュール（files / LDAP / DCE 等）を指定。 |
| `ALL` | 全ユーザを表示。 |
| `<User>` | 個別ユーザの全属性を表示。 |

**典型例**:

```
lsuser -a id home shell ALL
lsuser root  # root の属性詳細
```

**注意点**: /etc/security/user, /etc/security/passwd 等の組み合わせ。

**関連手順**: [cfg-user-add](08-config-procedures.md#cfg-user-add), [inc-login-locked](09-incident-procedures.md#inc-login-locked)

**関連用語**: RBAC, user

**出典**: S_AIX73_commands1

---

### `passwd` { #passwd }

**用途**: ユーザのパスワードを変更する。root は他ユーザのパスワードを設定できる。

**構文**:

```
passwd               # 自分のパスワード変更
passwd <user>        # 他ユーザ（root のみ）
```

**全オプション一覧**（6 件）:

| オプション | 説明 |
|---|---|
| `-a` | 全モジュール（compat, LDAP, NIS）でパスワード変更。 |
| `-f` | GECOS（フルネーム等）情報を変更。 |
| `-R <Module>` | 認証モジュール（files / LDAP）を指定。 |
| `-s` | ログインシェルを変更。 |
| `（引数なし）` | 自分のパスワードを変更。 |
| `<User>` | 他ユーザのパスワードを変更（root のみ）。 |

**典型例**:

```
passwd alice
# 旧パスワード入力 → 新パスワード 2 回

# パスワードロック解除
chsec -f /etc/security/lastlog -a unsuccessful_login_count=0 -s alice
```

**注意点**: AIX 7.3 既定 hash は SSHA-256。試行失敗回数が loginretries 超でロックされる。

**関連手順**: [cfg-user-add](08-config-procedures.md#cfg-user-add), [inc-login-locked](09-incident-procedures.md#inc-login-locked)

**関連用語**: user, login

**出典**: S_AIX73_commands1

---

### `chsec` { #chsec }

**用途**: セキュリティ stanza ファイル（/etc/security/* 配下）を編集する。

**構文**:

```
chsec -f <file> -a <attr>=<value> -s <stanza>
```

**全オプション一覧**（4 件）:

| オプション | 説明 |
|---|---|
| `-a <Attr>=<Val>` | 属性と値を指定（複数指定可）。 |
| `-f <File>` | 対象 stanza ファイル（/etc/security/* 配下）。 |
| `-s <Stanza>` | 対象 stanza 名（ユーザ名や default 等）。 |
| `（例）-f /etc/security/lastlog -a unsuccessful_login_count=0 -s alice` | alice のログイン失敗カウンタをリセット。 |

**典型例**:

```
chsec -f /etc/security/lastlog -a unsuccessful_login_count=0 -s alice  # ロック解除
chsec -f /etc/security/login.cfg -a logintimes=ALL:1700-2300 -s default
```

**注意点**: stanza ファイルを直接 vi で編集するより chsec を使う方が安全（構文エラー防止）。

**関連手順**: [cfg-user-add](08-config-procedures.md#cfg-user-add), [inc-login-locked](09-incident-procedures.md#inc-login-locked)

**関連用語**: RBAC, stanza

**出典**: S_AIX73_commands1

---

## サービス管理（3 件）

### `lssrc` { #lssrc }

**用途**: SRC（System Resource Controller）配下のサブシステム状態を表示する。

**構文**:

```
lssrc -a                  # 全サブシステム
lssrc -s <Subsystem>      # 個別
lssrc -g <Group>          # グループ
```

**全オプション一覧**（13 件）:

| オプション | 説明 |
|---|---|
| `-a` | 全サブシステムの状態を表示。 |
| `-c` | 通信タイプを含めて表示。 |
| `-d` | デフォルト configuration 表示。 |
| `-g <Group>` | サブシステムグループ（tcpip 等）の状態を表示。 |
| `-G <Group>` | グループ詳細表示。 |
| `-h <Host>` | リモートホストの SRC 情報を表示。 |
| `-l` | long 形式（詳細）で表示。 |
| `-p <PID>` | 指定 PID のサブシステム情報を表示。 |
| `-r` | raw 出力フォーマット。 |
| `-s <Subsystem>` | 個別サブシステム（syslogd 等）の状態を表示。 |
| `-S` | SRC 自身の管理情報を表示。 |
| `-t <Type>` | サブサーバタイプを表示。 |
| `-T` | 全サブサーバ表示。 |

**典型例**:

```
lssrc -s syslogd
lssrc -g tcpip
```

**注意点**: active = 起動済、inoperative = 停止。SRC 配下でない（SMIT で起動するもの等）は ps で見る。

**関連手順**: [cfg-syslog](08-config-procedures.md#cfg-syslog), [inc-cron-fail](09-incident-procedures.md#inc-cron-fail)

**関連用語**: SRC, srcmstr

**出典**: S_AIX73_commands1

---

### `startsrc` { #startsrc }

**用途**: SRC 配下のサブシステムを起動する。

**構文**:

```
startsrc -s <Subsystem>
startsrc -g <Group>
```

**全オプション一覧**（8 件）:

| オプション | 説明 |
|---|---|
| `-a <Args>` | 起動時引数を指定。 |
| `-e <Env>` | 環境変数を指定。 |
| `-g <Group>` | グループ単位で起動（例: nfs グループ）。 |
| `-h <Host>` | リモートホストで起動。 |
| `-i <Subserver>` | サブサーバ起動。 |
| `-p <PID>` | 指定 PID の SRC 設定で起動。 |
| `-s <Subsystem>` | 個別サブシステムを起動。 |
| `-t <Type>` | サブサーバ起動時のタイプを指定。 |

**典型例**:

```
startsrc -s syslogd
startsrc -g nfs
```

**注意点**: stopsrc -s <Sub> で停止、refresh -s <Sub> で設定再読み込み（HUP 送信相当）。

**関連手順**: [cfg-syslog](08-config-procedures.md#cfg-syslog), [cfg-nfs-mount](08-config-procedures.md#cfg-nfs-mount)

**関連用語**: SRC

**出典**: S_AIX73_commands1

---

### `smit / smitty` { #smit---smitty }

**用途**: AIX 標準のメニュー型システム管理ツール。smit = X11、smitty = テキスト。

**構文**:

```
smitty                       # トップメニュー
smitty <fastpath>            # 直接入る
```

**全オプション一覧**（20 件）:

| オプション | 説明 |
|---|---|
| `-c <File>` | 代替 customization ファイルを指定。 |
| `-C` | ColdStart モード（ODM 不在でも起動）。 |
| `-D` | デバッグモード（コマンド実行を表示するだけ）。 |
| `-d` | 代替 ODM directory を指定。 |
| `-e <Env>` | 環境変数を指定。 |
| `-f` | 保存済み既定値を読み込む。 |
| `-h` | ヘルプ表示。 |
| `-i <File>` | 指定ファイルを起動時に読み込み。 |
| `-l <File>` | ログファイルを指定（既定 ~/smit.log）。 |
| `-m` | メニューラベルからフラグ生成（dev 用）。 |
| `-M` | メッセージ表示モード。 |
| `-n <ID>` | メニュー ID を直接指定。 |
| `-r <RoleList>` | ロールリストでフィルタ。 |
| `-s <File>` | スクリプトファイルを指定（既定 ~/smit.script）。 |
| `-t <Theme>` | X11 テーマ指定。 |
| `-v` | verbose モード。 |
| `-x` | ログ出力をしない。 |
| `-X` | X11 セッション継続。 |
| `<fastpath>` | 特定機能に直接移動（users / mksysb / chfs 等）。 |
| `（引数なし）` | メインメニューを表示。 |

**典型例**:

```
smitty users          # ユーザ管理
smitty mksysb         # mksysb 取得
smitty chfs           # FS 拡張
```

**注意点**: 実行履歴は /smit.log（操作）と /smit.script（コマンド）に記録される。これを見ると smit が裏で何をしたか分かる。

**関連手順**: [cfg-user-add](08-config-procedures.md#cfg-user-add), [cfg-fs-extend](08-config-procedures.md#cfg-fs-extend), [cfg-mksysb-backup](08-config-procedures.md#cfg-mksysb-backup)

**関連用語**: SMIT, fastpath

**出典**: S_AIX73_commands1

---


*出典 ID は [07. 出典一覧](07-sources.md) を参照。*


---

## 関連コマンド（参照 stub - v11 追加）

本ページ上部 45 件の主要コマンドの他に、08 章 / 09 章 / 11 章から参照される関連コマンド 38 件の anchor を補完。各 stub は IBM 公式コマンドリファレンスへのリンクのみ（要約は当該マニュアルの 1 行抜粋系）。詳細は IBM Docs 参照。

<a id="cmd-hostname"></a>
### `hostname` { #hostname }

**用途**: システムホスト名の表示・設定

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=h-hostname-command>

---

<a id="cmd-nslookup"></a>
### `nslookup` { #nslookup }

**用途**: DNS 名前解決問い合わせ（対話・非対話）

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=n-nslookup-command>

---

<a id="cmd-host"></a>
### `host` { #host }

**用途**: DNS ホスト情報照会

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=h-host-command>

---

<a id="cmd-dig"></a>
### `dig` { #dig }

**用途**: DNS 詳細問い合わせ

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=d-dig-command>

---

<a id="cmd-mount"></a>
### `mount` { #mount }

**用途**: ファイルシステムマウント（NFS/JFS2 等）

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=m-mount-command>

---

<a id="cmd-umount"></a>
### `umount` { #umount }

**用途**: ファイルシステムアンマウント

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=u-umount-command>

---

<a id="cmd-showmount"></a>
### `showmount` { #showmount }

**用途**: NFS エクスポート/マウント状況表示

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=s-showmount-command>

---

<a id="cmd-fuser"></a>
### `fuser` { #fuser }

**用途**: ファイル・FS を使用中のプロセス特定

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=f-fuser-command>

---

<a id="cmd-ntpq"></a>
### `ntpq` { #ntpq }

**用途**: NTP サーバ状態問い合わせ

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=n-ntpq-command>

---

<a id="cmd-stopsrc"></a>
### `stopsrc` { #stopsrc }

**用途**: SRC 経由でサブシステム停止

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=s-stopsrc-command>

---

<a id="cmd-refresh"></a>
### `refresh` { #refresh }

**用途**: SRC 経由でサブシステム設定再読み込み

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=r-refresh-command>

---

<a id="cmd-logger"></a>
### `logger` { #logger }

**用途**: syslogd へメッセージ送出

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=l-logger-command>

---

<a id="cmd-errlogger"></a>
### `errlogger` { #errlogger }

**用途**: errpt へ独自メッセージ書き込み

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=e-errlogger-command>

---

<a id="cmd-odmadd"></a>
### `odmadd` { #odmadd }

**用途**: ODM クラスへ stanza 追加

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=o-odmadd-command>

---

<a id="cmd-odmget"></a>
### `odmget` { #odmget }

**用途**: ODM クラスから stanza 取得

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=o-odmget-command>

---

<a id="cmd-odmdelete"></a>
### `odmdelete` { #odmdelete }

**用途**: ODM クラスから stanza 削除

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=o-odmdelete-command>

---

<a id="cmd-sysdumpdev"></a>
### `sysdumpdev` { #sysdumpdev }

**用途**: システムダンプデバイス管理

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=s-sysdumpdev-command>

---

<a id="cmd-rmlv"></a>
### `rmlv` { #rmlv }

**用途**: Logical Volume 削除

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=r-rmlv-command>

---

<a id="cmd-crfs"></a>
### `crfs` { #crfs }

**用途**: ファイルシステム作成

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=c-crfs-command>

---

<a id="cmd-extendvg"></a>
### `extendvg` { #extendvg }

**用途**: Volume Group に PV 追加

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=e-extendvg-command>

---

<a id="cmd-mirrorvg"></a>
### `mirrorvg` { #mirrorvg }

**用途**: VG の LV をミラー化

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=m-mirrorvg-command>

---

<a id="cmd-unmirrorvg"></a>
### `unmirrorvg` { #unmirrorvg }

**用途**: VG ミラーを解除

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=u-unmirrorvg-command>

---

<a id="cmd-syncvg"></a>
### `syncvg` { #syncvg }

**用途**: VG ミラーの同期

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=s-syncvg-command>

---

<a id="cmd-lsfs"></a>
### `lsfs` { #lsfs }

**用途**: ファイルシステム一覧・属性表示

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=l-lsfs-command>

---

<a id="cmd-mkuser"></a>
### `mkuser` { #mkuser }

**用途**: ユーザ追加

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=m-mkuser-command>

---

<a id="cmd-rmuser"></a>
### `rmuser` { #rmuser }

**用途**: ユーザ削除

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=r-rmuser-command>

---

<a id="cmd-chuser"></a>
### `chuser` { #chuser }

**用途**: ユーザ属性変更

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=c-chuser-command>

---

<a id="cmd-pwdadm"></a>
### `pwdadm` { #pwdadm }

**用途**: パスワード管理（管理者モード）

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=p-pwdadm-command>

---

<a id="cmd-lppchk"></a>
### `lppchk` { #lppchk }

**用途**: fileset 整合性チェック

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=l-lppchk-command>

---

<a id="cmd-restore"></a>
### `restore` { #restore }

**用途**: backup コマンドで取得したアーカイブから復元

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=r-restore-command>

---

<a id="cmd-lsmksysb"></a>
### `lsmksysb` { #lsmksysb }

**用途**: mksysb イメージ内容一覧

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=l-lsmksysb-command>

---

<a id="cmd-lspath"></a>
### `lspath` { #lspath }

**用途**: MPIO パス状態一覧

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=l-lspath-command>

---

<a id="cmd-rmdev"></a>
### `rmdev` { #rmdev }

**用途**: デバイスを ODM から削除（または unconfigure）

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=r-rmdev-command>

---

<a id="cmd-mailq"></a>
### `mailq` { #mailq }

**用途**: sendmail メールキュー表示

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=m-mailq-command>

---

<a id="cmd-crontab"></a>
### `crontab` { #crontab }

**用途**: cron ジョブ表編集

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=c-crontab-command>

---

<a id="cmd-at"></a>
### `at` { #at }

**用途**: 1 回限りジョブ予約

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=a-at-command>

---

<a id="cmd-dbx"></a>
### `dbx` { #dbx }

**用途**: ソースレベルデバッガ

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=d-dbx-command>

---

<a id="cmd-truss"></a>
### `truss` { #truss }

**用途**: システムコール / シグナルトレース

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=t-truss-command>

---

<a id="cmd-coreadm"></a>
### `coreadm` { #coreadm }

**用途**: コアダンプ生成パターン管理

**公式リファレンス**: <https://www.ibm.com/docs/en/aix/7.3?topic=c-coreadm-command>

---

