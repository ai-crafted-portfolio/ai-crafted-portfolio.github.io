# 運用 JCL バックアップ・リカバリ (T31.2)

**BKUP/RCVR/NIGHT/MAINT 系運用 JCL**

*§K-12. 運用資材  (2/9)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | 運用部門が直接所有するバックアップ・リカバリ・夜間・保守用 JCL |
| **主要パラメータ** | DFDSS BACKUP / IDCAMS BACKUP / IEBCOPY / ADRDSSU 等の運用ユーティリティ呼出 |
| **影響範囲** | 実行頻度低 (週次・月次が多い) → 変更後のテスト機会少。リカバリ時に初めて問題発覚するリスク |
| **関連メンバ** | DFHSM, BKUP*/RCVR* PROC (T30.4) |
| **注意点** | リカバリリハーサル時に自動 syntax / 参照整合性チェック (T53)。退役データセット参照の検出。緊急変更フロー (事前簡易承認 + 事後正式レビュー) |

---

[← 業務 JCL (T31.1)](業務-jcl-t31-1.md) / [↑ §K-12. 運用資材](../section-k12-operational-materials.md) / [REXX exec / ISPF マクロ (T31.3) →](rexx-exec-ispf-マクロ-t31-3.md)
