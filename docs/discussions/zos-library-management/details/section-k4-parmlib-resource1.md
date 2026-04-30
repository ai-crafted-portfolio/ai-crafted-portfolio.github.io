# §K-4. PARMLIB 標準メンバ網羅 (4) — リソース管理 前半

T29.4 のメンバを網羅する (前半)。

| # | メンバ名 | 役割 |
|---|---|---|
| 29 | IEAOPTxx | WLM チューニング パラメータ。CPU・ストレージ・I/O 管理 |
| 30 | ALLOCxx | アロケーション デフォルト (UNIT/SPACE/EATTR 等) |
| 31 | GRSCNFxx | Global Resource Serialization (GRS) 構成 — STAR/RING モード |
| 32 | GRSRNLxx | GRS Resource Name List。SYSTEM/SYSTEMS/EXCLUSION リスト |
| 33 | SMFPRMxx | SMF レコード設定。記録するレコード TYPE、SMF データセット、SID |
| 34 | DIAGxx | Diagnostic ダンプ・トレース設定 (CTRACE 等) |
| 35 | IECIOSxx | I/O サブシステム パラメータ (HOTIO、MISSING INTERRUPT 等) |
| 36 | IOSDLBxx | I/O ループバック・サポート |

!!! warning "管理運用上の留意点 (T43)"
    WLM (IEAOPTxx) 変更はトランザクション応答時間に直結。SMF 記録量は監査要件とディスクコストのトレードオフ。事前評価チェックリストを整備すること。

---

次ページ → [§K-5 PARMLIB リソース管理 後半](section-k5-parmlib-resource2.md)
