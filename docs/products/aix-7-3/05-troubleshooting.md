# AIX 7.3 — トラブルシュート早見表（15 件）

AIX 7.3 で頻発が想定される問題の早見表。詳細は出典マニュアル参照。

| ID | 症状 | 原因 | 対処 | 出典 |
|---|---|---|---|---|
| INSTALL-001 | インストール時 hd5 拡張失敗メッセージ | hd5 が 40MB 未満かつディスク先頭 4GB 内の連続パーティションが確保できない | lspv / lsvg rootvg で空き PP 確認 → 既存 LV を移動して連続領域確保 → install 再試行 | S35 |
| BOOT-002 | 144 I/O slot 越えのデバイスから boot 不可 | AIX 7.3 ファームウェアメモリ容量制限 | HMC で I/O 列を Bus 順にソート、最初の 144 slot 内のアダプタを bootable パスとして利用。MPIO の場合は両アダプタとも 144 slot 内へ | S35 |
| JAVA-003 | Java 8 32bit SR6FP35（VRMF 8.0.0.635）が AIX 7.3 でロードできない | Java 8 32bit SR6FP35 と AIX 7.3 ロード機構の互換性問題 | より新しい Java 8 32bit へ更新（IBM Java SDK サイト）→ 利用不可なら Expansion Pack の SR6FP30（8.0.0.630）強制インストール | S35 |
| STOR-004 | SDD ドライバ依存ストレージで AIX 7.3 起動後に multipath 不能 | AIX 7.3 で SDD（Subsystem Device Driver）が完全削除 | マイグレーション前に manage_disk_drivers で AIX_FCPARRAY → AIX_AAPCM へ変換、または SDDPCM へ移行 | S35 |
| SEND-005 | bos.net.tcp.sendmail 7.3.0.0 install 時 libcrypto エラー | LPP_SOURCE が base 7.3.0.0 + 7.3.3 update 混在で初期 sendmail が libcrypto_compat.a を必要とするが OpenSSL 3.0 では削除済み | sendmail を 7.3.3 レベルへ update_all で続行 → install 完了でエラー解消 | S35 |
| PERF-006 | 低メモリ機器（4GB 以下）で多数同時 open file 障害 | AIX 7.3 で j2_inodeCacheSize 既定が 400 → 200 に変更された影響 | ioo -p -o j2_inodeCacheSize=400 -o j2_metadataCacheSize=400 を実行（boot/current 両方反映） | S35 |
| LDAP-007 | AIX 起動後に LDAP ホームディレクトリ作成失敗 | TL3 SP1 で defaulthomedirectory 等のフィールドが追加され ldap.cfg に未記入 | /etc/security/ldap/ldap.cfg に defaulthomedirectory / defaultloginshell / pwdalgorithm を記述 → secldapclntd 再起動 | S34 |
| LKU-008 | LKU で IPsec 接続が切れる | ipsec_auto_migrate=no（既定/未設定）のため、LKU 時に IPsec が再ネゴシエーションされない | lvupdate.data に ipsec_auto_migrate=yes を追加して LKU を再実行 | S35 |
| SEC-009 | Trusted AIX を AIX 7.3 へ移行不能 | Trusted AIX、Trusted AIX LAS/EAL4+、BAS and EAL4+ Configuration が AIX 7.3 で全廃 | Domain RBAC で代替の権限分離設計（roles / authorizations / privileges を細粒度で定義） | S35 |
| DSM-010 | dsm.properties が migration 後に欠落 | /etc/ibm/sysmgt/dsm/overrides/dsm.properties は dsm.core fileset の update / migration で上書き | 事前に手動バックアップ → migration 後に手動復元 | S35 |
| MIG-011 | PowerSC Trusted Surveyor 残存で migration ブロック | AIX 7.3 で PowerSC Trusted Surveyor（powersc.ts）非サポート | 事前に powersc.ts を削除（WPAR 内も含む） | S35 |
| MIG-012 | rsct.vsd / rsct.lapi.rte が AIX 7.3 にインストール不能 | RSCT 3.3.0.0 で VSD / LAPI 機能が廃止 | 事前に rsct.vsd / rsct.lapi.rte を削除。VSD ベースの 3rd party 製品は Spectrum Scale へ置換 | S35 |
| NET-013 | NTPv3 デーモン起動失敗 | AIX 7.3 で NTPv3 サポート廃止 | /usr/sbin/ntp4/ 配下の ntpd4 へ移行（互換のため /usr/sbin/xntpd → ntp4/ntpd4 リンク済） | S35 |
| NET-014 | BIND 9.18 移行後に dnssec-coverage / dnssec-keymgr が見つからない | BIND 9.18 で dnssec-coverage / dnssec-keymgr / dnssec-checkds 削除 | BIND 9.16 以前の dnssec-policy 統合機能で代替（named.conf 編集） | S35 |
| NIM-015 | SPOT 作成時に missing image （network boot image / bos.net.nfs.client / bos.net.tcp.bootp） | LPP_SOURCE が base+update 混在 / SPOT 領域不足 | image_data resource を作成 / SPOT 用 FS の空き容量拡大 | S35 |

[← AIX 7.3 トップへ](index.md)
