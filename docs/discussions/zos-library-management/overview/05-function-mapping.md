# 全体観: Change Tracker 全 48 機能の判定結果

8 群に分け、各機能を等価実装するか割り切るかを個別判定した結果。

---

Change Tracker (S15) の機能を 8 群 (対象指定 / バックアップ / 比較 / ロック / リカバリ / 通知 / レポート / 運用基盤) に整理し、各機能を Excel/VBA + 3270 で等価実装可能か個別判定した。判定結果は以下の通り。

| 機能群 | 詳細章 | 総数 | 採用 | 割切 | 判定の概要 |
|---|---|---|---|---|---|
| 対象指定 / 保護管理 | [§C-T9](../details/section-c-t9.md) | 4 | 4 | 0 | PROTECT / EXPLICIT / PATTERN / EXCLUDE を Excel ワークシートで等価実装 |
| バックアップ / 世代管理 | [§C-T10](../details/section-c-t10.md) | 9 | 8 | 1 | リアルタイム監視 (STC 常駐) のみ割切。世代数・期限指定は Excel 列で対応 |
| 比較 / 差分検出 | [§C-T11](../details/section-c-t11.md) | 7 | 4 | 3 | テキスト diff・複数環境比較は採用。バイナリ・ボリューム・USS は割切 |
| ロック / Check-in/out | [§C-T12](../details/section-c-t12.md) | 5 | 4 | 1 | Excel ワークシート上の擬似 Check-out フラグで対応。z/OS 側強制力は割切 |
| リカバリ | [§C-T13](../details/section-c-t13.md) | 5 | 4 | 1 | Excel から TXT 出力 → 人手 3270 貼付の運用フロー。直接書き戻しは割切 |
| 通知 / ドキュメント強制 | [§C-T14](../details/section-c-t14.md) | 4 | 2 | 2 | 変更理由・運用ログは Excel 列で実装。EMAIL アラート・ISPF Edit 警告は外部依存 |
| レポート / 監査 | [§C-T15](../details/section-c-t15.md) | 6 | 5 | 1 | Excel ピボットで代替。Administrator/Auditor のロール分離は OS 側に委ねる |
| 運用 / 管理 | [§C-T16](../details/section-c-t16.md) | 8 | 1 | 7 | STC/WLM/SMP/E/z/OSMF/VSAM repository は SSOT ① で z/OS 側不設置のため不要 |
| **合計** | — | **48** | **32** | **16** | — |

---

次ページ → [§A 6 領域の判定詳細](../details/section-a-domains.md)
