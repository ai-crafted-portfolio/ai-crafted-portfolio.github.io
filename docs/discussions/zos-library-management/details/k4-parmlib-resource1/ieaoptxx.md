# IEAOPTxx

**WLM チューニング パラメータ**

*§K-4. PARMLIB 標準メンバ網羅 (4)  (1/10)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | WLM (Workload Manager) のチューニング。CPU 管理 / ストレージ管理 / I/O 管理 / Routing アルゴリズム |
| **主要パラメータ** | RCCPCPU=400 (CPU しきい値) / IFAHONORPRIORITY=YES (zAAP 優先) / MCCFXEPR=400 (キャッシュ管理) / HIPERDISPATCH=YES |
| **影響範囲** | SET OPT=xx で動的反映可 |
| **関連メンバ** | WLM ポリシー (本体は Couple Dataset 上) |
| **注意点** | 誤チューニングで応答時間悪化。性能評価チームのレビュー必須 |

---

[↑ §K-4. PARMLIB 標準メンバ網羅 (4)](../section-k4-parmlib-resource1.md) / [ALLOCxx →](allocxx.md)
