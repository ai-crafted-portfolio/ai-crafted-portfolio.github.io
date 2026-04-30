# §K-7. PARMLIB 標準メンバ網羅 (7) — 環境設定 後半 + サイト固有

T29.5 後半 + T29.6 のメンバを網羅する。

| # | メンバ名 | 役割 |
|---|---|---|
| 54 | BPXPRMxx | USS 設定。**[SSOT ④](../overview/01-ssot.md) により対象環境では USS 不在のため対象外** |
| 55 | OAMSPxx | Object Access Method (OAM) 設定 |
| 56 | IOEPRMxx | zFS パラメータ (USS 不在環境では未使用) |
| 57 | IEASVCxx | SVC 追加・置換 |
| 58 | TIMEZONE | 時刻ゾーン定義 (固定名) |
| 59 | UNICODE.IMAGE | Unicode 変換テーブル (固定名) |
| 60 | (サイト独自) T29.6 | サイトカスタムメンバ。命名規則からは予測不可。年次棚卸しと文書化が必要 (T45) |

!!! info "PARMLIB メンバ網羅完了"
    §K-1〜§K-7 で PARMLIB 標準メンバ約 60 種を網羅した。BPXPRMxx は対象外、IEAICSxx/IEAIPSxx は廃止予定。サイト独自メンバ (T29.6) は命名規則からは予測不可で、現場棚卸しでのみ把握可能。

---

次ページ → [§K-8 PROCLIB IPL/JES 起動](section-k8-proclib-ipl.md)
