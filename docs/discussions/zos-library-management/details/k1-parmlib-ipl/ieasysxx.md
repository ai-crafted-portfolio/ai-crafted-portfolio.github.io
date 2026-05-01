# IEASYSxx

**システム起動パラメータの集約**

*§K-1. PARMLIB 標準メンバ網羅 (1)  (2/12)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | システム起動の中央集約メンバ。各サブメンバ (CMD/CON/SMF 等) の xx 指定を一括して与える |
| **主要パラメータ** | CMD=00 (COMMNDxx) / CON=00 (CONSOLxx) / GRS=STAR (GRS モード) / SCH=00 (SCHEDxx) / SMF=00 (SMFPRMxx) / SQA=20M / CSA=20M / CLPA (LPA 再構築) |
| **影響範囲** | 一部 IPL 必須、一部動的変更可 (SET CMD=xx 等)。設定ミスで多領域影響 |
| **関連メンバ** | ほぼ全メンバ参照のハブ。COMMNDxx, CONSOLxx, SMFPRMxx, SCHEDxx, IEASYMxx, PROGxx 等 |
| **注意点** | 誤変更時の影響範囲が広い。SET 命令で一部動的反映可だが、IEASYS 自体の編集は IPL 後の検証推奨 |

---

[← LOADxx](loadxx.md) / [↑ §K-1. PARMLIB 標準メンバ網羅 (1)](../section-k1-parmlib-ipl.md) / [IEASYMxx →](ieasymxx.md)
