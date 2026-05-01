# COMMNDxx

**IPL 後の自動コマンド**

*§K-2. PARMLIB 標準メンバ網羅 (2)  (2/9)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | IPL 完了後に自動実行する MVS/JES コマンドのリスト。サブシステム起動、ジョブ投入等を記述 |
| **主要パラメータ** | COM='S JES2' / COM='V CN(*),AUTH(MASTER)' / COM='S TCPIP' |
| **影響範囲** | IPL 必須・SET CMD=xx で動的に追加コマンド実行は可能 |
| **関連メンバ** | IEFSSNxx (起動するサブシステム定義), IEACMD00 (固定名) |
| **注意点** | 誤った S コマンドで起動順序が崩れるとサブシステム連鎖障害。RACF 権限が伴うコマンドはタイミング依存 |

---

[← CONSOLxx](consolxx.md) / [↑ §K-2. PARMLIB 標準メンバ網羅 (2)](../section-k2-parmlib-console.md) / [MPFLSTxx →](mpflstxx.md)
