# IBM Guardium Data Protection 12.x — 概要

IBM Guardium Data Protection 12.x — 製品概要

本シートは ChromaDB 投入済みの IBM Guardium Data Protection 12.x マニュアル （1,296 chunks / 96 sources、IBM Docs Web 日本語＋英語）から構造化抽出した 製品サマリ。各記述末尾の [SX] は出典 ID（06_出典一覧 を参照）。

| 項目 | 内容 | 出典 |
|---|---|---|
| 製品名 | IBM Guardium Data Protection 12.x  [S1, S2] | S1, S2 |
| ベンダ | IBM Corporation  [S1] | S1 |
| 最新バージョン（ドキュメント反映時点） | IBM Guardium 12.2.2（12.2.1 / 12.2 / 12.1 / 12.0 が同 12.x ライン）  [S2, S3] | S2, S3 |
| 製品ライン | DAM (Database Activity Monitoring) と FAM (File Activity Monitoring) の 2 形態。 DAM はデータベース／データウェアハウス／Big Data の活動監視、 FAM はファイルサーバの活動監視を提供する。  [S1] | S1 |
| 提供形態 | IBM 出荷の事前構成済アプライアンス、または顧客プラットフォーム上のソフトウェアアプライアンス（仮想 / クラウド）  [S1, S2] | S1, S2 |
| 製品の役割 | 異種 DB / 文書共有基盤を継続監視し、機密データ・特権ユーザ・コンプライアンス対象データへの アクセスをポリシーで監視・制御する。集中監査リポジトリと監査ワークフロー自動化により、 PCI-DSS / SOX / HIPAA / NIST / NERC / DORA / NYDFS 等を含む各種規制への準拠を支援する。  [S1, S2, S89] | S1, S2, S89 |
| 主機能領域 | (1) Vulnerability Assessment（脆弱性評価）、 (2) Data discovery & classification（機密データ発見・分類）、 (3) Data protection（保管時／伝送時の保護）、 (4) Monitoring & analytics（監視と SIEM 連携）、 (5) Threat prevention（DDoS／SQL インジェクション等への対処）、 (6) Access management（特権ユーザ／ロール／RBAC）、 (7) Audit & compliance（中央集約監査とレポート）。  [S1, S28, S47, S8, S6, S19] | S1, S28, S47, S8, S6, S19 |
| 最大 Inspection Engine 数 | 1 アプライアンスあたり最大 50 Inspection Engine  [S84] | S84 |
| 想定読者 | DB セキュリティ管理者、コンプライアンス担当者、SOC 運用、DBA、監査人  [S1, S55] | S1, S55 |
| 典型的利用シーン | 特権 DB ユーザ監査、PCI-DSS / SOX 等の準拠証跡作成、機密データへの不正アクセス検知、 SIEM 連携によるリアルタイムインシデント対応、データ漏洩防止と脅威分析。  [S1, S48, S89, S62, S6] | S1, S48, S89, S62, S6 |
| サポート OS（Collector / Aggregator アプライアンス） | Linux ベースの Guardium 専用アプライアンス OS（事前構成済）。 仮想アプライアンスは VMware / KVM / Hyper-V / AWS / Azure / Red Hat OpenShift Virtualization 等で稼働。  [S2, S30] | S2, S30 |
| S-TAP 対応 OS | Linux / UNIX (AIX, Solaris, HP-UX) / Windows / IBM i / z/OS の各 S-TAP を提供  [S24, S35, S2, S25, S26, S27] | S24, S35, S2, S25, S26, S27 |
| ドキュメント形態 | IBM Docs Web（https://www.ibm.com/docs/en/gdp/12.x）— 96 トピック相当を ChromaDB に投入済  [S1] | S1 |
| 新世代モニタリング基盤 | Edge Gateway 2.x（Kubernetes ベース）— Linux/Windows/External S-TAP からのストリーミング、 AWS EKS / OpenShift / K3s 上で Terraform を用いた展開、Long-term retention（S3 互換）対応。  [S2] | S2 |
| 推奨保持期間（Guardium 推奨値） | Collector = 15 日、Aggregator = 30 日（実値はトラフィック量・S-TAP 数・ポリシー数に依存）  [S81] | S81 |

