# SMFPRMxx

**SMF レコード設定**

*§K-4. PARMLIB 標準メンバ網羅 (4)  (5/10)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | SMF (System Management Facility) の記録対象タイプと出力先データセットを定義。監査・性能解析の基盤 |
| **主要パラメータ** | SYS(TYPE(0,5,6,7,...)) / DSNAME(SYS1.MAN1) / SID(&SYSCLONE.) / EXIT(IEFU83) |
| **影響範囲** | SET SMF=xx で動的反映可。SETSMF コマンドで個別パラメータ変更可 |
| **関連メンバ** | DIAGxx, IEAOPTxx, IEFOPZxx |
| **注意点** | 監査要件 (SOX 等) に応じた TYPE 選択。記録量とディスクコストのトレードオフ。EXIT ルーチンの認可必須 |

---

[← GRSRNLxx](grsrnlxx.md) / [↑ §K-4. PARMLIB 標準メンバ網羅 (4)](../section-k4-parmlib-resource1.md) / [DIAGxx →](diagxx.md)
