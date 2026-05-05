# IBM Tivoli Log File Agent 6.3

!!! info "本ページの位置付け / 関連ページ"
    本ページは **IBM Tivoli Log File Agent 6.3（以下 LFA 6.3、product number 5724-C04、edition SC14-7484-04）公式マニュアル系の運用リファレンス**（13 章）。日々の運用で「どの itmcmd / tacmd を叩くか」「`.conf` / `.fmt` のどのディレクティブを変えるか」「Probe for Tivoli EIF への中継が止まったときの切り分け」を引く用途に最適化。

    関連ページ：

    - **[Netcool/OMNIbus 8.1](../netcool-omnibus-8-1/)** — LFA から EIF Probe（`nco_p_tivoli_eif`）経由でイベントを受ける側のリファレンス。LFA 単体ではなく Netcool 連携前提で組む場合に併読。
    - **[AIX 7.3](../aix-7-3/)** — AIX 上で LFA を動かすときの OS 側リソース（`/var/log` / errlog 連携 / syslogd / inode 監視）。
    - **[z/OS 3.1](../z-os-3-1/)** — メインフレーム側のシステムログ。LFA 6.3 は z/OS の SYSLOG / OPERLOG を直接読まないため、z/OS 側ログを LFA で扱う場合は USS 経由 / EIF 連携設計が必要（[10. 対象外項目](10-out-of-scope.md) 参照）。

> IBM Tivoli Monitoring（ITM）6.3 ファミリの **ログファイル監視エージェント**。任意のテキストログファイル（syslog、ミドルウェアログ、アプリケーションログ）を継続的に追尾し、`.fmt`（フォーマットファイル、正規表現でログ行を解析）と `.conf`（設定ファイル、監視対象ファイル指定とランタイム挙動）の組合せでイベント化。生成イベントは **Hub TEMS（Tivoli Enterprise Monitoring Server）経由で TEP（Tivoli Enterprise Portal）に表示**、または **EIF（Event Integration Facility）プロトコルで Netcool/OMNIbus の Probe for Tivoli EIF に中継** できる。**13 章構成** で staple な itmcmd / tacmd / `.conf` / `.fmt` の用法・サブノード設計・EIF 中継・トラブル対応を整理。**v1（LFA 6.3.0 / FP4 系、2013 年版 SC14-7484-04 ベース）に対応**。

**カテゴリ**: 監視・運用 系 / ログファイル監視エージェント

## 構成（13 章）

| セクション | 内容 |
|---|---|
| **01. 製品概要** | 製品の役割（本ページ下部） |
| [02. コマンド一覧](01-commands.md) | itmcmd / tacmd / klogagent 系 / EIF / pdcollect 系 **42 件** |
| [03. 設定値一覧](02-settings.md) | `.conf` ディレクティブ **22 件** + `.fmt` 構文 **8 件** + Operating Environment 変数 **10 件** = **40 件** |
| [04. 用語集](03-glossary.md) | LFA / ITM 6.3 固有 **62 件**（agent / TEMS / TEPS / KUL / `lo` / EIF / RegexCache / Subnode / FCAStartTime 等） |
| [05. プレイブック](04-playbook.md) | 7 シーン × 3 習熟度 = **21 セル** |
| [06. トラブル早見表](05-troubleshooting.md) | 症状起点の早見 **20 件** |
| [07. マニュアル参照マップ](06-manual-map.md) | **18 テーマ** |
| [08. 出典一覧](07-sources.md) | **24 件**（IBM Docs / User's Guide / IBM Tech Notes / Redpaper / Netcool 連携） |
| [09. 設定手順](08-config-procedures.md) | **18 件** + S 級は実機期待出力サンプル付き |
| [10. 障害対応手順](09-incident-procedures.md) | **18 件** + S 級は A/B/C 仮説分岐付き |
| [11. 対象外項目](10-out-of-scope.md) | カテゴリ別整合（30 ユースケース + 6 シナリオに対応） |
| [12. シナリオ別ガイド](11-scenarios.md) | **6 本**（新規導入 / マルチサブノード / Netcool EIF 連携 / TEP 監視統合 / クラスタ配置 / 障害切り分けフロー） |
| [13. ユースケース集](12-use-cases.md) | **30 件**（独立タスク粒度） |

各章の関連エントリには、設定手順 / 障害対応手順 / 用語 / ユースケースへの双方向リンクを付与。

---

## 01. 製品概要

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM Tivoli Log File Agent（IBM Tivoli Monitoring 6.3 配下のエージェント） | S1, S3 |
| 製品番号 / 版 | product number 5724-C04 / SC14-7484-04（Version 6.3） | S3 |
| 主要バージョン | 6.3.0 GA / Fix Pack 1 / FP2 / FP3 / FP4。Interim Fix（IF）が随時 Fix Central で公開 | S3, S_IF04 |
| ベンダ | IBM Corporation | S1 |
| 対応 OS | AIX、Linux on x86_64 / s390x / ppc64le、Solaris、HP-UX、Windows Server。各 OS の対応版は ITM 6.3 「Supported operating systems」に従う | S1, S2 |
| 想定読者 | ITM 管理者、ログ監視運用者、ミドルウェア運用者、Netcool/OMNIbus 連携設計者、SOC / SRE | S3 |
| 中核アーキテクチャ | DB サーバ / アプリサーバ上で **エージェントプロセス**（`klogagent` / agent code `lo`）が動作し、`.conf` で指定されたログファイルを継続的に tail。`.fmt` の REGEX で行を解析して属性化、Hub TEMS（または Remote TEMS）を経由して TEP に表示。EIF 出力指定があれば並行して Netcool/OMNIbus の **Probe for Tivoli EIF** に中継 | S1, S3, S_NCO_EIF |
| エージェントコード | 内部識別 `lo`（`itmcmd agent start lo`、`$CANDLEHOME/<arch>/lo/`）。プロセス名は環境により `klogagent` / `kfaagent` 等 | S3 |
| 主要設定ファイル | **`.conf`**（agent 動作と監視対象指定、`LogSources`/`FormatFile`/`NumEventsToCatchUp`/`MaxEventQueueDepth`/`EventFloodThreshold`/`NewLinePattern`/`EventMaxSize`/`FQDomain`/`FileComparisonMode` 等）と **`.fmt`**（REGEX パターン → LogfileEvents 属性のマッピング）。サンプルは `$CANDLEHOME/<arch>/lo/examples/` 配下 | S3 |
| 主要属性グループ | `LogfileEvents`（生成イベント本体）、`LogfileRegexStatistics`（REGEX マッチ統計）、`LogfileProfileEvents`（プロファイル別イベント）、`LogfileMonitor` / `LogfileFileStatus`（自己監視）、`PerformanceObjectStatus` | S3 |
| 主要環境変数 / パス | `$CANDLEHOME`（UNIX、既定 `/opt/IBM/ITM`）、`%CANDLE_HOME%`（Windows、既定 `C:\IBM\ITM`）、`$CANDLEHOME/logs`（agent ログ）、`$CANDLEHOME/<arch>/lo/`（agent root）、`KBB_RAS1`（トレース）、`CTIRA_HOSTNAME` / `CTIRA_SUBSYSTEM_ID`（subnode 識別） | S3 |
| 通信ポート（既定） | TEMS との通信 = `KDC_FAMILIES`（IP.PIPE / IP.SPIPE / IP.UDP）+ `1918/tcp`（既定）。EIF 中継 = Probe for Tivoli EIF の `ServerLocation` / `ServerPort`（既定 `5529/tcp`）。`.conf` の `EIFServer` / `EIFPort` / `EIFCachePath` で指定 | S3, S_NCO_EIF |
| 管理 GUI | Tivoli Enterprise Portal（TEP）— ブラウザ版 + Java Web Start 版。LFA 用ナビゲーション「Log File Agent」配下に Workspace / Situation / 履歴 | S3 |
| 管理 CLI | `itmcmd agent {start\|stop\|config\|status} lo`（UNIX）/ Windows サービス + Manage Tivoli Enterprise Monitoring Services（MTEMS）GUI。Hub TEMS 側からは `tacmd login` → `tacmd listsystems` / `tacmd putfile` / `tacmd configurePortalServer` / `tacmd addBundles` / `tacmd createNode` / `tacmd configureSystem` 等 | S3, S_ITM_CMD |
| サブノード | 1 ホストで **複数の独立ログ群** を別 subnode として扱える設計。`kfaenv`（UNIX：`$CANDLEHOME/config/lo.ini` 系）+ subnode ごとの `.conf` + `.fmt` ペア。TEP では subnode が一階層下に表示 | S3 |
| EIF 連携 | `.conf` 内の `EIFServer` / `EIFPort` / `EIFCachePath` / `EIFHeartbeatInterval` 指定で、TEMS 経由の通常パスと並行して Netcool/OMNIbus の **Probe for Tivoli EIF** にイベントを送信。EIF 受信側の `tivoli_eif.rules` / `eif_default.rules` で alerts.status へ整形 | S3, S_NCO_EIF, S_NCO_BP |
| 高可用性 | エージェント自体は active-passive 想定（同一インスタンス重複起動非推奨）。クラスタ環境では **共有 CANDLEHOME** + フェイルオーバ時のリスタート、または各ノードで独立配置 + EIF キャッシュ運用 | S3 |
| トレース | `KBB_RAS1` 環境変数（例：`ERROR (UNIT:klog STATE)`、`ERROR (UNIT:logfile_agent ALL)`）。トレースログは `$CANDLEHOME/logs/<host>_lo_<timestamp>.log`。`pdcollect` で IBM サポート向け診断アーカイブを一括収集 | S3 |
| ドキュメント形態 | IBM Documentation（旧 Knowledge Center）「Tivoli Monitoring 6.3 / Log File Agent」配下、PDF（`logfileagent63_user.pdf`）も提供 | S1, S3 |
| 関連製品（密結合） | **IBM Tivoli Monitoring 6.3**（必須、TEMS / TEPS / TEP）、**Netcool/OMNIbus 8.1**（EIF 受信側）、IBM Operations Analytics - Log Analysis（SCALA）/ Netcool Operations Insight（NOI、Event Analytics 連携）、Netcool/Impact（Netcool 経由連携）、IBM Tivoli Composite Application Manager（ITCAM、別エージェント） | S1, S3, S_NCO_BP |

!!! note "v1 の特徴"
    **z/OS 3.1 v4 / Db2 13 v1.1 / Netcool 8.1 v1.2 / Guardium DP 12.x v1 と同一の 13 章フレームワーク** で書き起こした初版。Tivoli LFA 6.3 は GA から年数が経ち IBM Docs の SPA 化で個別ページの直接 fetch が困難になった製品のため、**`.conf` / `.fmt` の主要ディレクティブと、TEMS / EIF への 2 経路出力の運用メカニズム解説に重点**。S 級 5 件の設定手順 + S 級 5 件の障害対応 + 30 件の独立ユースケースで深掘り。

!!! warning "AI 生成と人手の併用"
    本ページは公式マニュアル等の公開情報のみを根拠に整理した二次資料。AI 生成と人手の併用で作成しているため、情報の正確性は保証しない。実装・適用前には公式情報での再確認を推奨。

!!! info "v1 の図表方針"
    本サイト v1 は「テキスト網羅優先」で、IBM Docs / User's Guide PDF 由来の図表埋込は v2 以降に拡張する方針（IBM Docs の SPA 化と Redbook PDF の 403 制約あり）。各章の章末注に出典 ID を記載しているため、必要に応じて元 PDF（[08. 出典一覧](07-sources.md) 参照）の図を直接参照可能。

---

## 用途別の入り口

- **「これから新規に LFA を導入したい」** → [12. シナリオ別ガイド > scn-new-deployment](11-scenarios.md#scn-new-deployment)
- **「1 つのホストで複数のログ群を別管理にしたい（subnode 設計）」** → [12. scn-multi-subnode](11-scenarios.md#scn-multi-subnode) + [09. cfg-subnode-multi](08-config-procedures.md#cfg-subnode-multi)
- **「LFA イベントを Netcool/OMNIbus に流したい」** → [12. scn-eif-to-netcool](11-scenarios.md#scn-eif-to-netcool) + [09. cfg-eif-target](08-config-procedures.md#cfg-eif-target)
- **「`.fmt` の REGEX が一致しない（イベントが上がらない）」** → [10. inc-regex-mismatch](09-incident-procedures.md#inc-regex-mismatch) + [13. uc-fmt-write](12-use-cases.md#uc-fmt-write)
- **「ログローテーション後にイベントが落ちる」** → [10. inc-rotation-missed](09-incident-procedures.md#inc-rotation-missed)
- **「EIF が Netcool に届かない」** → [10. inc-eif-not-delivered](09-incident-procedures.md#inc-eif-not-delivered)
- **「特定の単発タスクだけやりたい（拾い読み）」** → [13. ユースケース集](12-use-cases.md)

---

*出典 ID は [08. 出典一覧](07-sources.md) を参照。*
