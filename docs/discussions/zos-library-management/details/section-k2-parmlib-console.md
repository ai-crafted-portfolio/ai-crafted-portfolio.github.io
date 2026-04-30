# §K-2. PARMLIB 標準メンバ網羅 (2) — コンソール/運用

T29.2 のメンバを網羅する。

| # | メンバ名 | 役割 |
|---|---|---|
| 13 | CONSOLxx | コンソール定義。各 MCS/HMCS コンソールの装置・属性 |
| 14 | COMMNDxx | 自動コマンド。IPL 後に自動実行する MVS/JES コマンドリスト |
| 15 | MPFLSTxx | メッセージ抑止 (Message Processing Facility)。表示抑止メッセージリスト |
| 16 | IEACMD00 | システム自動コマンド (固定名)。IBM 提供、変更非推奨 |
| 17 | CNGRPxx | コンソール グループ定義 (alternates グループ等) |
| 18 | MSGFLDxx | メッセージ flooding 制御。同一メッセージ抑止 |
| 19 | MMSLSTxx | MVS Message Service。多言語メッセージのルックアップ表 |
| 20 | PFKTABxx | PFK テーブル。コンソール PFK キーの割当 |

!!! warning "管理運用上の留意点 (T41)"
    コンソール系メンバの変更は監視・運用ジョブの挙動に直結する。COMMNDxx の応答ループ静的検出、MPFLSTxx 抑止メッセージリストの監査出力機能を要検討。

---

次ページ → [§K-3 PARMLIB サブシステム認可](section-k3-parmlib-subsystem.md)
