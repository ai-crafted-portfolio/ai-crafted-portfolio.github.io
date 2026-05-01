# LOADxx

**IPL ロード制御の起点**

*§K-1. PARMLIB 標準メンバ網羅 (1)  (1/12)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | IPL 時に最初に読まれるメンバ。NUCLST、SYSPLEX 名、PARMLIB 連結、IODF (I/O 構成データセット) を指定し、IPL シーケンスの起点を決める |
| **主要パラメータ** | NUCLST=xx (Nucleus 選択) / SYSPLEX=PLEX1 (シスプレックス名) / IODF=01,SYS1 / PARMLIB=USER.PARMLIB (連結定義) / SYSCAT=ICFCAT (マスターカタログ) |
| **影響範囲** | IPL 必須・動的反映不可。誤りがあると IPL 失敗 |
| **関連メンバ** | IEASYSxx (LOAD パラメータ経由で参照), IEASYMxx (SYSPLEX 名連動), NUCLSTxx (NUCLST= 経由) |
| **注意点** | LOAD パラメータ (HMC ロードプロファイル) で xx を選択。誤変更は OS 起動不能 (リスク最大級)。世代退避必須、テスト LPAR で事前検証 |

---

[↑ §K-1. PARMLIB 標準メンバ網羅 (1)](../section-k1-parmlib-ipl.md) / [IEASYSxx →](ieasysxx.md)
