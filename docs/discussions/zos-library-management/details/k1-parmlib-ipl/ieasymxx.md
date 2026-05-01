# IEASYMxx

**システムシンボルとシスプレックス定義**

*§K-1. PARMLIB 標準メンバ網羅 (1)  (3/12)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | &SYSNAME / &SYSPLEX / &SYSCLONE 等のシステムシンボル定義。サイト独自シンボルの追加もここで行う |
| **主要パラメータ** | SYSDEF SYSNAME(SYS1) / SYMDEF(&MYSYM='ABC') / HWNAME(LPAR1) / SYSPLEX(PLEX1) |
| **影響範囲** | IPL 必須・動的反映不可。誤りで他メンバのシンボル展開が失敗 |
| **関連メンバ** | 他メンバ全般 (シンボル参照される側), LOADxx (IEASYM= で選択) |
| **注意点** | シスプレックス名のミスマッチで XCF 接続不能。サイトカスタムシンボルの命名衝突に注意 |

---

[← IEASYSxx](ieasysxx.md) / [↑ §K-1. PARMLIB 標準メンバ網羅 (1)](../section-k1-parmlib-ipl.md) / [NUCLSTxx →](nuclstxx.md)
