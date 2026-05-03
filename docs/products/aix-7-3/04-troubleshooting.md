# AIX 7.3 — トラブルシュート

AIX 7.3 — トラブルシュート（既知の問題と対処）

| 症状 | 原因 | 対処手順 | 関連ログ・コマンド | 出典 |
|---|---|---|---|---|
| インストール時 hd5 拡張失敗メッセージ | hd5 が 40MB 未満かつディスク先頭 4GB 内の連続パーティションが確保できない | 1) `lspv` / `lsvg rootvg` で空き PP 確認  2) 既存 LV を移動して連続領域確保  3) インストールを再試行 | lspv, lsvg, lslv hd5 | S35 |
| 144 I/O slot 越えのデバイスから boot 不可 | ファームウェアメモリ容量制限 | HMC で I/O 列を Bus 順にソート、最初の 144 slot 内のアダプタを bootable パスとして利用。MPIO の場合は両アダプタとも 144 slot 内へ | bootlist, sysdumpdev | S35 |
| Java 8 32bit SR6FP35（VRMF 8.0.0.635）が AIX 7.3 でロードできない | Java 8 32bit SR6FP35 と AIX 7.3 ロード機構の互換性問題 | 1) より新しい Java 8 32bit へ更新（IBM Java SDK サイト）  2) 利用不可の場合 Expansion Pack の SR6FP30 (8.0.0.630) を強制インストール | java -version, installp -F | S35 |
| SDD ドライバ依存ストレージで AIX 7.3 起動後に multipath 不能 | AIX 7.3 で SDD（Subsystem Device Driver）が完全削除 | マイグレーション前に `manage_disk_drivers` で AIX_FCPARRAY → AIX_AAPCM へ変換、または SDDPCM へ移行（IBM Storage 技術サポート連絡） | manage_disk_drivers, lsdev -Cc disk | S35 |
| bos.net.tcp.sendmail 7.3.0.0 install 時 libcrypto エラー | LPP_SOURCE が base 7.3.0.0 + 7.3.3 update 混在で、初期 sendmail バイナリが libcrypto_compat.a を必要とするが OpenSSL 3.0 では削除済み | 1) sendmail を 7.3.3 レベルへ update_all で続行  2) インストール完了時にはエラーは解消 | installp -p, lslpp -L bos.net.tcp.sendmail | S35 |
| 低メモリ機器（4GB 以下）で多数同時 open file 障害 | AIX 7.3 で j2_inodeCacheSize 既定が 400 → 200 に変更された影響 | `ioo -p -o j2_inodeCacheSize=400 -o j2_metadataCacheSize=400` を実行（boot/current 両方反映） | ioo -L, vmstat -v, no -p -L | S35 |
| AIX 起動後に LDAP ホームディレクトリ作成失敗 | TL3 SP1 で defaulthomedirectory 等のフィールドが追加され ldap.cfg に未記入 | 1) /etc/security/ldap/ldap.cfg に defaulthomedirectory / defaultloginshell / pwdalgorithm を記述  2) secldapclntd を再起動 | stop-secldapclntd / start-secldapclntd, lsldap, mksecldap | S34 |
| LKU で IPsec 接続が切れる | ipsec_auto_migrate=no（既定 / 未設定）のため、LKU 時に IPsec が再ネゴシエーションされない | lvupdate.data に `ipsec_auto_migrate=yes` を追加して LKU を再実行 | geninstall -k, ikedb, ipsec.so | S35 |
| Trusted AIX を AIX 7.3 へ移行不能 | Trusted AIX、Trusted AIX LAS/EAL4+、BAS and EAL4+ Configuration が AIX 7.3 で全廃 | Domain RBAC で代替の権限分離設計を行う（roles / authorizations / privileges を細粒度で定義） | lsroles, lsauths, mkrole, swrole | S35 |
| dsm.properties が migration 後に欠落 | /etc/ibm/sysmgt/dsm/overrides/dsm.properties は dsm.core fileset の update / migration で上書きされる | 事前に手動バックアップ → migration 後に手動復元 | cp / installp -L dsm.core | S35 |

