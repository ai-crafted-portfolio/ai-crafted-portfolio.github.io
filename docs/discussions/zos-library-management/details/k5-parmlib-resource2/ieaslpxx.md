# IEASLPxx

**SLIP コマンド事前定義**

*§K-5. PARMLIB 標準メンバ網羅 (5)  (6/9)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | SLIP (Serviceability Level Indication Processing) のテンプレ。特定のエラー条件でトラップ |
| **主要パラメータ** | SLIP SET,IF,J=jobname,COMP=0C4,A=SVCD,END |
| **影響範囲** | SET SLIP=xx で動的反映可 |
| **関連メンバ** | IEADMCxx |
| **注意点** | 誤った SLIP で本番ジョブが ABEND ループ、性能低下のリスク。SLIP は基本的に解析時の一時利用 |

---

[← IEAABDxx](ieaabdxx.md) / [↑ §K-5. PARMLIB 標準メンバ網羅 (5)](../section-k5-parmlib-resource2.md) / [COFVLFxx →](cofvlfxx.md)
