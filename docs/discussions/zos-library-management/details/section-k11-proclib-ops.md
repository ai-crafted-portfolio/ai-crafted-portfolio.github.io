# §K-11. PROCLIB 標準 PROC 網羅 (4) — 運用 + 監視・通知

T30.4/.5/.6 の PROC を網羅する。

| # | PROC 名 | 役割 |
|---|---|---|
| 40 | BKUP* | バックアップ用 PROC (サイト命名 例: BKUPDB, BKUPCAT) |
| 41 | RCVR* | リカバリ用 PROC (サイト命名) |
| 42 | NIGHT* | 夜間バッチ用 PROC (サイト命名) |
| 43 | MAINT* | 保守バッチ用 PROC (サイト命名) |
| 44 | APP* | アプリ業務 PROC (アプリチーム命名、運用境界整理 T50) |
| 45 | RMF / RMFGAT | Resource Measurement Facility + Gather |
| 46 | SDSF / SDSFAUX | System Display and Search Facility |
| 47 | NETVIEW | NetView (運用自動化・監視) |
| 48 | ALERT* | 監視通知 PROC (サイト命名) |
| 49 | NOTIF* | 通知配信 PROC (サイト命名) |
| 50 | HEALTH* | ヘルスチェック PROC (サイト命名) |
| 51 | (その他サイト独自) | 命名規則からは予測不可。所有者属性管理 (T50) |

!!! warning "管理運用上の留意点 (T49, T51)"
    バッチ運用 (BKUP/RCVR/NIGHT*) は緊急修正が日常的。緊急変更フロー (事前簡易承認 + 事後正式レビュー) をサイト規程化。監視通知 (ALERT/NOTIF/HEALTH*) はテスト alert 機能を本ツール内で支援。

!!! info "PROCLIB PROC 網羅完了"
    §K-8〜§K-11 で PROCLIB 標準 PROC 約 50 種を網羅した。サブシステム起動 PROC はサイト命名と IBM 命名が混在するため、責任マトリクスでの境界整理が前提となる。

---

次ページ → [§K-12 運用資材 — 標準データセット類別 + サイト命名テンプレ](section-k12-operational-materials.md)
