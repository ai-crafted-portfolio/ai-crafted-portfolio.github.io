# IBM Spectrum Protect 8.1 — トラブルシュート

IBM Spectrum Protect 8.1 — トラブルシュート（ANR／ANE／ANS メッセージと既知の問題）

| 症状（メッセージ ID 等） | 原因 | 対処手順 | 関連ログ・コマンド | 出典 |
|---|---|---|---|---|
| ANR0010W: Unable to open message catalog for language ... | 指定言語のメッセージカタログが見つからず、デフォルト言語にフォールバック | 1) インストール時に該当言語パッケージが含まれていたか確認  2) 必要なら追加導入  3) 動作には影響しない（警告）ため放置可 | Server activity log、QUERY ACTLOG | S10 |
| ANR2034I: QUERY EVENT — No match found for this query. | QUERY EVENT に合致するスケジュールイベントが無い（命名・対象期間ミスマッチ） | 1) DEFINE SCHEDULE／DEFINE ASSOCIATION の名前と一致しているか QUERY SCHEDULE で確認  2) QUERY EVENT に BEGINDATE／ENDDATE／DOMAIN を指定し直す | QUERY SCHEDULE、QUERY EVENT、QUERY ASSOCIATION | S10 |
| ANR4397E: Certificate delivery failed due to incorrect password ... | サーバ間（cross-define／replication）のパスワードがパートナー側で誤っており証明書配信が失敗 | 1) パートナーサーバで UPDATE SERVER ... SERVERPASSWORD=... で正しいパスワードに更新  2) 自サーバのパスワード変更時は両サーバで合わせる  3) PING SERVER で疎通確認 | UPDATE SERVER、PING SERVER、QUERY STATUS | S10 |
| ANR4531I／ANR0297I／ANR4529I: Active log 利用率超過 | ACTIVELOGSIZE で指定した active log 容量を超過、もしくは閾値到達 | 1) サーバを halt  2) dsmserv.opt の ACTIVELOGSIZE を増加  3) サーバ再起動  4) ACTIVELOGDIRECTORY 配下の FS 容量も合わせて増加 | QUERY LOG、QUERY ACTLOG、dsmserv halt | S6 |
| ANR7869W: Unable to create volume <name> with format size <n> MB | OS の制限（FILE デバイスクラスの最大ファイルサイズ等）により、指定 FORMATSIZE での FILE ボリューム作成失敗 | 1) 対象 FS の最大ファイルサイズや quota を緩和（ulimit／FS 種別変更）  2) FORMATSIZE を縮小して再実行  3) AIX／Linux ともに発生し得る | DEFINE VOLUME、QUERY VOLUME | S10 |
| ANS1000E: An unsupported communications method was specified. | クライアントの dsm.opt／dsm.sys に該当 OS で未サポートの COMMMETHOD を記述 | 1) BA Client の OS マニュアルで対応 COMMMETHOD を確認（TCPIP／SHAREDMEM 等）  2) dsm.opt／dsm.sys を訂正  3) クライアント再起動 | dsm.opt、dsmc、ANS1000 系 | S15 |
| ANS1110E: The client help file <file> could not be opened. | DSM_DIR が指す現行プログラムファイルディレクトリにヘルプファイルが無い | 1) 環境変数 DSM_DIR を現行クライアントインストール先に設定  2) 直らない場合 BA Client を再導入  3) それでもダメなら IBM サポート | DSM_DIR、dsmc、再導入 | S15 |
| ANS1111E: The requested operation is not possible using the management class that was entered. | VVOL データストアのローカルバックアップで、管理クラスの Data Version Exists が 30 を超過 | 1) UPDATE COPYGROUP で VEREXISTS を 1〜30 の範囲に修正  2) ACTIVATE POLICYSET で再有効化  3) 操作再実行 | QUERY COPYGROUP、UPDATE COPYGROUP、ACTIVATE POLICYSET | S15 |
| ANS1113E: The snapshot cache location is not valid. | snapshot キャッシュ先が NTFS 以外のローカルボリュームを指している | 1) snapshot キャッシュ先を NTFS 形式のローカルボリュームに変更  2) dsm.opt の SNAPSHOTPROVIDERIMAGE／SNAPSHOTCACHELOCATION 等を見直す  3) 既定はバックアップ対象と同一ボリューム | dsm.opt、SNAPSHOT 系オプション | S15 |
| ANS1225E: Insufficient memory for file compression／expansion | 圧縮・展開を行うメモリが不足（特に他クライアントから large メモリ機で圧縮されたデータの restore） | 1) 一時的に他プロセスを止める／メモリ追加  2) restore は十分なメモリを持つマシンで実施  3) backup 時は COMPRESSION=NO で取得し直す方法も検討 | dsmsched.log、dsmerror.log、ANS1224E | S15 |
| ANS1226E: Destination file or directory is write locked | 復元先のファイル／ディレクトリが他プロセスによって書き込みロックされている | 1) 復元先を開いている他アプリケーションを停止  2) 別ディレクトリへ -subdir=yes で restore  3) ファイル単位で確認（chkdsk／lsof 等） | dsmc restore、lsof、procexp | S15 |
| ANS0107E: Error trying to read index for message <n> from repository <file> | メッセージリポジトリインデックス読み込み失敗（リポジトリファイル破損／権限不足／言語不一致） | 1) クライアント再導入で正しい言語のメッセージリポジトリを再配置  2) Windows: LANGUAGE オプションを dsm.opt に追加（例: LANGUAGE FRA）  3) UNIX／Linux: LANG 環境変数を対応コードに設定（例: LANG=fr_FR） | LANGUAGE オプション、LANG、dsm.opt | S15 |
| ANS5102I: Return Code 11 | 汎用 RC=11（コマンド失敗）。後続の ANRxxxx メッセージで詳細が示される | 1) ANS5102I の直後に出力された ANRxxxx 詳細メッセージを確認（例: ANR2034I QUERY EVENT 該当無し／ANRxxxx Storage pool not defined）  2) 個別の ANR メッセージに従って対処 | dsmsched.log、ANR メッセージ確認 | S10 |
| PROTECT STGPOOL／AUDIT CONTAINER で damaged extent 検出 | directory-container 内の data extent が破損（媒体エラー、bitrot、既往処理エラー） | 1) AUDIT CONTAINER STGPOOL=<name> ACTION=SCANDAMAGED で破損特定  2) 同 ACTION=REMOVEDAMAGED で DB から削除、または ACTION=MARKDAMAGED  3) PROTECT STGPOOL でターゲット側から REPAIR STGPOOL を実行し復旧 | AUDIT CONTAINER、REPAIR STGPOOL、QUERY DAMAGED | S3 |
| Operations Center: Spoke が表示されない／接続不可 | Hub からの cross-define に失敗、または cert.kdb／パスワード不整合 | 1) PING SERVER でサーバ間疎通確認  2) UPDATE SERVER ... SERVERPASSWORD で再同期  3) Hub 側 cert.kdb と Spoke 側 truststore を確認  4) ANR4397E が出ていないか activity log で確認 | PING SERVER、UPDATE SERVER、QUERY STATUS、cert.kdb | S10, S5 |

