# 全体観: 本ツールの位置づけ

Change Tracker の劣化版でも上位互換でもない。対象顧客が違う別物。

---

本ツールと Change Tracker は、対象顧客 (組織規模) が異なる別製品として位置づける。

| 軸 | z/OS Change Tracker | 本ツール (Excel/VBA + 3270) |
|---|---|---|
| 対象組織規模 | 中〜大規模 (専任 z/OS 担当あり) | 小規模 (利用者単独〜5 人未満、専任なし) |
| 導入要件 | STC + VSAM repository + RACF プロファイル + priced feature | Excel/VBA + PCOMM のみ |
| z/OS 側設置物 | 常駐プログラム・データセット・ライセンス | なし |
| 対応機能数 | 48 機能 (フルセット) | 32 機能を等価実装、16 機能を割り切る |
| 対象データ形式 | PDS/PDSE バイナリ・テキスト両方、VSAM、ボリューム単位 | PDS/PDSE のメンバ単位テキストのみ |
| 差分検出のリアルタイム性 | STC 常駐によるリアルタイム監視可能 | PCOMM 経由のスナップショット差分のみ |
| 想定運用 | 監査要件のある中〜大規模システム | 公式管理空白を埋める軽量運用 |

---

!!! success "位置づけ宣言"
    本ツールは Change Tracker の代替品ではなく、Change Tracker を導入できない現場のための別製品。

---

次ページ → [Change Tracker 全 48 機能の判定結果](05-function-mapping.md)
