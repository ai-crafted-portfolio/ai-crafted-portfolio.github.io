# IECIOSxx

**I/O サブシステム パラメータ**

*§K-4. PARMLIB 標準メンバ網羅 (4)  (7/10)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | I/O Supervisor (IOS) のチューニング — HOTIO 検出、Missing Interrupt Handler (MIH)、I/O Recovery |
| **主要パラメータ** | HOTIO=YES,LIMIT=20 / MIH TIME=00:30 / DCCF=ENABLE |
| **影響範囲** | SET IOS=xx で動的反映可 |
| **関連メンバ** | IOSDLBxx, DEVSUPxx |
| **注意点** | MIH タイマーが短すぎると false positive、長すぎると本物の I/O ハング検知遅延 |

---

[← DIAGxx](diagxx.md) / [↑ §K-4. PARMLIB 標準メンバ網羅 (4)](../section-k4-parmlib-resource1.md) / [IOSDLBxx →](iosdlbxx.md)
