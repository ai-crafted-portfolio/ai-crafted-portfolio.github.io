# §K-6. PARMLIB 標準メンバ網羅 (6) — 環境設定 前半

T29.5 のメンバを網羅する (前半)。

| # | メンバ名 | 役割 |
|---|---|---|
| 44 | IGDSMSxx | DFSMS 構成。Storage Class / Management Class / Data Class の定義有効化 |
| 45 | IKJTSOxx | TSO/E 構成。AUTHCMD/AUTHPGM/AUTHTSF、コマンドプロセッサ |
| 46 | SCHEDxx | スケジューラ・PPT (Program Properties Table) |
| 47 | DEVSUPxx | デバイス サポート (テープデバイス、DASD タイプ等) |
| 48 | CEEPRMxx | Language Environment ランタイム デフォルト |
| 49 | CLOCKxx | システム時刻設定 (TIME, ZONE, ETRMODE 等) |
| 50 | VATLSTxx | Volume Attribute List。DASD ボリュームの属性 |
| 51 | HZSPRMxx | Health Checker 設定 |
| 52 | GTZPRMxx | Generic Tracker 設定 (z/OS V2R3+) |
| 53 | FXEPRMxx | Predictive Failure Analysis (PFA) 設定 |

!!! warning "管理運用上の留意点 (T44)"
    IGDSMSxx / IKJTSOxx / SCHEDxx 等は影響範囲が広い (全データセット、全 TSO 利用者、全ジョブ実行)。利用者通知期間と変更時間帯制約をサイト規程と連動させること。

---

次ページ → [§K-7 PARMLIB 環境設定 後半 + サイト固有](section-k7-parmlib-env2.md)
