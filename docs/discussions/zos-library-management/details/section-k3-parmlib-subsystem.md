# §K-3. PARMLIB 標準メンバ網羅 (3) — サブシステム認可

T29.3 のメンバを網羅する。

| # | メンバ名 | 役割 |
|---|---|---|
| 21 | IEFSSNxx | サブシステム定義。JES2/Db2/MQ/CICS/RACF 等のサブシステム名と initialization routine |
| 22 | IFAPRDxx | Product Registration / 課金。priced feature の有効化状態 |
| 23 | LICEFLxx | License manager。z/OS feature の license 制御 |
| 24 | IRRPRMxx | RACF Database 名前変換テーブル |
| 25 | IEAICSxx | (旧) Installation Control Specification。WLM 移行で廃止予定 |
| 26 | IEAIPSxx | (旧) Installation Performance Specification。WLM 移行で廃止予定 |
| 27 | IEFOPZxx | Operator Auto-Reply 自動応答ルール |
| 28 | BLSCUSER | IPCS デフォルト exit ルーチン |

!!! warning "管理運用上の留意点 (T42)"
    APF/LNKLST/LPALST/PROGxx は SOX 監査対象。変更時に監査ログ自動付与、LNKLST 順序差分の強調表示を要検討。

---

次ページ → [§K-4 PARMLIB リソース管理 前半](section-k4-parmlib-resource1.md)
