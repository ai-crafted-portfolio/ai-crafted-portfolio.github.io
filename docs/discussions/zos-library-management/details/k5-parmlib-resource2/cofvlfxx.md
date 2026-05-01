# COFVLFxx

**VLF (Virtual Lookaside Facility) キャッシュ**

*§K-5. PARMLIB 標準メンバ網羅 (5)  (7/9)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | VLF が管理する各クラスのキャッシュサイズ・最大エントリ数 |
| **主要パラメータ** | CLASS NAME(IRRACEE) / EMAJ(USR) / MAXVIRT(4096) |
| **影響範囲** | VLF 再起動 (S VLF) で反映 |
| **関連メンバ** | VLF PROC, COFDLFxx |
| **注意点** | RACF/HFS 等の VLF 利用先のパフォーマンスに影響。サイズ不足でキャッシュヒット率低下 |

---

[← IEASLPxx](ieaslpxx.md) / [↑ §K-5. PARMLIB 標準メンバ網羅 (5)](../section-k5-parmlib-resource2.md) / [COFDLFxx →](cofdlfxx.md)
