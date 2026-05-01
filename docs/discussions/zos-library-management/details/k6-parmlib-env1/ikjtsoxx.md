# IKJTSOxx

**TSO/E 構成**

*§K-6. PARMLIB 標準メンバ網羅 (6)  (2/13)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | TSO/E の認可コマンド・認可プログラム・コマンドプロセッサ定義 |
| **主要パラメータ** | AUTHCMD NAMES(LISTC,LISTD,...) / AUTHPGM NAMES(IEHLIST,IDCAMS,...) / AUTHTSF NAMES(...) |
| **影響範囲** | PARMLIB UPDATE(xx) コマンドで動的反映可 |
| **関連メンバ** | IKJPRMxx, BPXPRMxx |
| **注意点** | 認可リストの誤りで TSO ユーザの権限不正昇格・降格が発生。SOX 監査対象 |

---

[← IGDSMSxx](igdsmsxx.md) / [↑ §K-6. PARMLIB 標準メンバ網羅 (6)](../section-k6-parmlib-env1.md) / [IKJPRMxx →](ikjprmxx.md)
