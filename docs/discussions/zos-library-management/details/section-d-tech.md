# §D. 技術実現性

本ツールが運用資材を取得・取り込みする経路を確認する。

---

## D-1. z/OS 出力ユーティリティ (T26)

本ツールが運用資材を取得するための z/OS 側出力ユーティリティを特定する。

| ユーティリティ | 区分 | 出力内容 | 本ツール使い方 | 出典 |
|---|---|---|---|---|
| IEBPTPCH | DFSMSdfp 標準 | PDS のメンバ本体をテキスト形式で出力 (TYPORG=PO) | メンバ本体取得の主用途 | DFSMSdfp Utilities (S19) |
| IEHLIST | DFSMSdfp 標準 | PDS のディレクトリ情報 (メンバ名・サイズ等) を出力 | メンバ一覧取得の主用途 | DFSMSdfp Utilities (S19) |
| IDCAMS LISTCAT | Access Method Services | カタログ情報 (DSN・ボリューム・属性) を出力 | 補助的に使用 (対象 DSN の属性確認) | AMS Commands (S21) |

!!! success "T26 の判定結果"
    IEBPTPCH (メンバ本体取得) と IEHLIST (ディレクトリ取得) を主に使用、IDCAMS は補助的に使用する。

    **根拠強度=強** (IBM 公式ユーティリティとして明文化済み、出典 S19, S21)。本ツールはこれら 3 ユーティリティの実行 JCL を共通テンプレ化する。

---

## D-2. z/OS → Excel への取り込み経路 (T27)

PCOMM の IND$FILE による Shift-JIS テキスト転送。

| 手順 | 内容 | 依存 |
|---|---|---|
| 1. JCL 投入 | z/OS 上で IEBPTPCH/IEHLIST を実行し、シーケンシャルファイルに出力 | z/OS 標準機能 |
| 2. PCOMM 接続 | PC 側で PCOMM を起動、3270 セッションを z/OS にログオン | PCOMM Quick Beginnings (S20) |
| 3. IND$FILE 受信 | PCOMM の Receive File 機能で z/OS シーケンシャルを Shift-JIS 変換しつつ PC へ転送 | PCOMM 標準機能 (CONVERT=YES オプション) |
| 4. VBA 読込 | Excel/VBA で受信ファイルを Open For Input → Line Input で行単位読込 | VBA 公知機能 |
| 5. 履歴シートに反映 | VBA で履歴シートに行追加 → 前回版とテキスト比較 | 本ツール独自実装 |

!!! warning "T27 の判定結果"
    PCOMM の IND$FILE で Shift-JIS テキスト転送、VBA で読み込み可能と判断。

    **根拠強度=中** (PCOMM 公式機能 (S20) と VBA テキスト処理の組合せ。実装段階での試作検証が必要)。

    性能 (T28: 数千メンバ規模での所要時間) は試作で実測する。

---

次ページ → [§E 結論](section-e-conclusion.md)
