# IFAPRDxx

**Product Registration / 課金**

*§K-3. PARMLIB 標準メンバ網羅 (3)  (2/7)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | z/OS の priced feature や IBM 製品の有効化状態を宣言。価格付き機能 (例: Change Tracker) の有効化はここに記載 |
| **主要パラメータ** | PRODUCT OWNER('IBM CORP') NAME('z/OS') FEATURENAME('SDSF') STATE(ENABLED) |
| **影響範囲** | SET PROD=xx で動的反映可 |
| **関連メンバ** | LICEFLxx |
| **注意点** | 誤って有効化すると license 違反。逆に無効化すると製品利用不可。IBM への報告と整合させる |

---

[← IEFSSNxx](iefssnxx.md) / [↑ §K-3. PARMLIB 標準メンバ網羅 (3)](../section-k3-parmlib-subsystem.md) / [LICEFLxx →](liceflxx.md)
