# IEAAPFxx

**APF 認可ライブラリ (旧形式)**

*§K-1. PARMLIB 標準メンバ網羅 (1)  (10/12)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | APF 認可されたデータセットのリスト。APF 認可は特権コード実行を許可するため SOX 監査対象 |
| **主要パラメータ** | SYS1.LINKLIB VOLSER1 / SYS1.LPALIB VOLSER1 / VENDOR.AUTHLIB VOLSER2 |
| **影響範囲** | IPL 必須。SETPROG APF で動的追加・削除は可能 |
| **関連メンバ** | PROGxx (APF 文への移行が推奨), LNKLSTxx |
| **注意点** | 旧形式。PROGxx APF ADD/DELETE 構文への移行が推奨。APF ライブラリへの WRITE 権限管理が監査の論点 |

---

[← LNKLSTxx](lnklstxx.md) / [↑ §K-1. PARMLIB 標準メンバ網羅 (1)](../section-k1-parmlib-ipl.md) / [PROGxx →](progxx.md)
