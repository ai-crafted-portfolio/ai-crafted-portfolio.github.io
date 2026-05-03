# Netcool OMNIbus V8.1 — 関連製品連携

Netcool/OMNIbus V8.1 — 関連製品連携 / 依存関係

| 連携先製品 | 連携の種類 | 設定要点 | 出典 |
|---|---|---|---|
| IBM Tivoli Netcool/Impact | イベントエンリッチメント / 自動アクション | Impact ポリシーから ObjectServer の alerts.status に対し SELECT/UPDATE を行いイベントを enrich。ObjectServer 側 trigger と Impact ポリシーで処理を分担し read/write 競合を最小化 | S1 |
| IBM Tivoli Monitoring (TEMS) / Tivoli Enterprise Portal | メトリクス・予兆連携 | ITM Agent for OMNIbus を介して ObjectServer の health/performance を Tivoli Enterprise Monitoring Server へ送信、Tivoli Enterprise Portal で可視化。Predictive Event 連携も EIF 経由で実施 | S3, S1 |
| Probe for Tivoli EIF (nco_p_tivoli_eif) | EIF イベント受信 | IBM Tivoli Monitoring 等の EIF 送信元から受信。eif_default.rules / tivoli_eif.rules で alerts.status マッピング、Predictive Event は predictive_event.rules を include して有効化 | S2, S3 |
| Jazz for Service Management / DASH | Web GUI 配置基盤 | DASH 上に Web GUI（AEL/Event Viewer/Gauges）をデプロイ。Tivoli 製品共通の SSO 基盤・ユーザ管理を共有。WebSphere Application Server 上で動作 | S1, S5 |
| WebSphere Application Server | Web GUI / DASH ホスト | Web GUI / DASH の実行基盤。Java Runtime Environment（JRE）が要件、TIPProfile などのプロファイルで運用 | S1 |
| IBM Operations Analytics - Log Analysis (SCALA) | ログ分析連携 | scala_triggers group の trigger を ObjectServer に投入し、Operations Analytics 連携で alerts.status をログ分析へ送出。$NCHOME/extensions/scala 配下に提供 | S1 |
| IBM Netcool Operations Insight (NOI) Event Analytics | イベント解析・チケット削減 | scope-based event grouping を強化し、関連イベントを自動グループ化してオペレータ負荷とチケット件数を削減 | S1 |
| Netcool MIB Manager | rules file 生成 | SNMP MIB から Probe 用 rules file を生成。Probe for SNMP / nco_p_mttrapd と組み合わせて利用 | S1 |
| GSKit (IBM Global Security Kit) | 暗号モジュール / SSL 証明書管理 | $NCHOME/bin に同梱、nc_gskcmd で証明書 (kdb) 操作。FIPS 140-2 モード時に必須。EIF SSL 接続でも利用 | S1, S2 |
| IBM Installation Manager (IM) | インストール／パッチ適用 | OMNIbus 本体と Web GUI のインストールと interim fix / fix pack 適用は IM で実施。Probe / Gateway は別ダウンロードで各々の install.txt に従う | S4, S1 |
| IBM Tivoli Application Dependency Discovery Manager (TADDM) | 資産情報連携 | Web GUI から TADDM Java console を Java Web Start (javaws) で起動。PATH に javaws を含む JRE が必要 | S1 |
| OpenLDAP / LDAP 認証基盤 | ユーザ認証外部化 | Web GUI / ObjectServer のユーザ認証を LDAP に外部化。Default groups + LDAP で運用ロールを統合管理 | S1 |
| Probe for SNMP / Probe for Syslog 等の各種 Probe | イベントソース統合 | 代表的な Probe: nco_p_mttrapd（SNMP Trap）、nco_p_syslog（Syslog）、nco_p_tivoli_eif（EIF）。各 Probe は別パッケージ配布で IM 適用または個別インストール | S1, S2 |

