# CONSOLxx

**MCS/HMCS コンソールの定義**

*§K-2. PARMLIB 標準メンバ網羅 (2)  (1/9)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | MVS Multi-Console Support (MCS) / HMC コンソールの装置・属性・ルートコード・コマンド権限を定義 |
| **主要パラメータ** | CONSOLE DEVNUM(0050) NAME(MASTER) AUTH(MASTER) ROUTCODE(ALL) / DEFAULT ROUTCODE(NONE) MSCOPE(*ALL) |
| **影響範囲** | SET CON=xx で動的反映可。CONSOLE 単位の動的追加・削除も可能 |
| **関連メンバ** | MPFLSTxx, COMMNDxx, CNGRPxx (alternate group), MSGFLDxx |
| **注意点** | MASTER 権限のコンソールが無いと運用不能。AUTOSWITCH と alternate 設定でフェイルオーバ確保 |

---

[↑ §K-2. PARMLIB 標準メンバ網羅 (2)](../section-k2-parmlib-console.md) / [COMMNDxx →](commndxx.md)
