# GitHub Pages リサーチ自動公開プロジェクト

> このファイルは Cowork プロジェクトのカスタムインストラクション欄に貼り付けて使う。
> docs/ には置かないこと（MkDocs ビルドに含まれるのを避けるため、プロジェクトルート直下）。
> 末尾の「メンテナンス」セクションに更新履歴を残すこと。

---

## 1. このプロジェクトの目的

`mcp-education` の ChromaDB に蓄積された IBM 製品マニュアルから、
特定トピックに関するチャンクを検索して **MkDocs サイト** にレポートとして追加し、
GitHub Pages で公開する。スマホからの Dispatch 実行を主用途とする。

ユーザの典型的な依頼パターン：

- 「PowerHA のクラスタ起動手順を調べて公開して」
- 「Netcool の ObjectServer チューニングについてまとめて」
- 「VIOS の Shared Storage Pool 周辺を調査して」

---

## 2. 環境前提

| 項目 | 値 |
|---|---|
| OS | Windows |
| 作業フォルダ（プロジェクトルート） | `C:\github-pages-work\GitHub Pages Research Publisher` |
| Python | `C:\Users\81904\AppData\Local\Programs\Python\Python314\python.exe` |
| pip オプション | `--break-system-packages`（必須） |
| ChromaDB パス | `C:\mcp-education\chroma_data` |
| コレクション | `manual_docs` |
| 埋め込みモデル | `all-MiniLM-L6-v2` |
| GitHub リポジトリ | `https://github.com/ai-crafted-portfolio/ai-crafted-portfolio.github.io` |
| GitHub Pages 公開先 | `https://ai-crafted-portfolio.github.io/` |
| サイトビルド | MkDocs Material（`.github/workflows/deploy.yml`） |
| 出力先 | `docs/research/<timestamp>_<slug>.md`（MkDocs がレンダリング） |
| GitHub Pages ブランチ | `main` |
| Git 認証 | Git Credential Manager に PAT 保存済み（push 時パスワード不要） |

---

## 3. ファイル構成

```
C:\github-pages-work\GitHub Pages Research Publisher\
├── .git\                              # 既存リポを clone 済み
├── .github\
│   └── workflows\
│       └── deploy.yml                 # MkDocs build → Pages deploy（既存）
├── docs\                              # MkDocs ソース
│   ├── index.md                       # サイトホーム（既存）
│   └── research\                      # ★ レポート出力先（新規）
│       ├── index.md                   # 一覧ページ（自動生成）
│       └── <timestamp>_<slug>.md      # 各レポート（自動生成）
├── tools\
│   └── query_and_publish.py           # ChromaDB 照会 + MD 生成 + git push
├── mkdocs.yml                         # MkDocs 設定（research を nav に追加済み）
├── PROJECT_INSTRUCTIONS.md            # このファイル
├── README.md
├── cleanup_and_publish.ps1            # 初回セットアップ用スクリプト
└── .gitignore
```

---

## 4. 標準実行手順

ユーザから調査・公開系の依頼が来たら、原則として `tools\query_and_publish.py` を呼び出す。
独自にスクリプトを書き直したり、別経路で git 操作を行ったりしない。

### コマンドフォーマット

```cmd
cd /d "C:\github-pages-work\GitHub Pages Research Publisher"
python tools\query_and_publish.py "<検索クエリ>" --product "<製品名>" --top-k <件数> --push
```

### パラメータの決め方

- **`<検索クエリ>`**：ユーザ依頼文から技術用語を抽出。ChromaDB の登録ドキュメントは英語主体なので、日本語依頼でも英語キーワードに翻訳して投入する方が命中率が高い。日本語のまま投げて結果が薄い場合は英語で再実行する。
- **`--product`**：「6. 登録済み製品名」から完全一致するものを選ぶ。曖昧・横断調査の場合は省略する。
- **`--top-k`**：標準 10。概観なら 5、詳細なら 15〜20。
- **`--push`**：原則として常に付ける（このプロジェクトの目的が「公開」なので）。push を伴わない確認だけが必要なときは `--dry-run` を併用する。

### 動作フロー

1. ChromaDB に `query` を投げて Top-K チャンク取得
2. Markdown レポートを `docs/research/<timestamp>_<slug>.md` に保存
3. `docs/research/index.md`（一覧）を再生成
4. `git add docs/research`、`git commit`、`git push origin main`
5. GitHub Actions（`deploy.yml`）が起動、MkDocs build → Pages にデプロイ
6. 数分後に `https://ai-crafted-portfolio.github.io/research/<slug>/` で公開

---

## 5. Dispatch からの典型呼び出し例

| ユーザ依頼 | 実行コマンド |
|---|---|
| 「PowerHA のクラスタ起動手順を調査して公開」 | `python tools\query_and_publish.py "PowerHA cluster startup procedure" --product "IBM PowerHA SystemMirror 7.2 TL8" --top-k 10 --push` |
| 「Netcool の ObjectServer チューニング」 | `python tools\query_and_publish.py "Netcool ObjectServer tuning performance" --product "Netcool/OMNIbus V8.1" --top-k 10 --push` |
| 「VIOS と PowerHA を横断して Shared Storage Pool」 | `python tools\query_and_publish.py "VIOS shared storage pool PowerHA" --top-k 15 --push` |
| 「Guardium の S-TAP 設定について」 | `python tools\query_and_publish.py "Guardium S-TAP configuration DB2" --product "IBM Guardium GDP 12.x" --top-k 10 --push` |

---

## 6. mcp-education 登録済み製品名（暫定）

`--product` には下記のいずれかを完全一致で指定する。表記揺れがあるとヒット 0 件になる。

- `IBM MQ 9.0`
- `IBM Guardium GDP 12.x`
- `IBM PCOMM V15.0`
- `IBM PowerHA SystemMirror 7.2 TL8`
- `IBM VIOS 4.1.0`
- `Netcool/OMNIbus V8.1`
- `Symantec Endpoint Protection 14.3`
- `ESS REC 5.8.0`

### 実際の登録値を確認する

上記が古い／ずれている可能性がある場合、以下のワンライナーで実際の `metadata.product` 一覧を取得する：

```powershell
python -c "import chromadb; c=chromadb.PersistentClient(path=r'C:\mcp-education\chroma_data').get_collection('manual_docs'); print(sorted({m.get('product','') for m in c.get()['metadatas']}))"
```

差分があったら、このセクションを更新したうえで「メンテナンス」セクションに記録する。

---

## 7. 失敗時の分岐

### 7-1. ChromaDB 照会失敗（スクリプト終了コード 3）

`HNSW` 破損やインデックスロード失敗の典型症状。Dispatch では以下を行う：

1. **`git push` は実行しない**（中途半端な MD が残っていても無視）。
2. `$HOME\Downloads\HNSW詳細診断.py` を実行して、出力をユーザに報告。
3. **自動修復はしない**（`HNSW修復_再構築.py` は破壊的操作。ユーザの明示的承認後に実行）。
4. 修復後の再実行はユーザ指示を待つ。

### 7-2. git push 認証エラー（スクリプト終了コード 4）

PAT 期限切れまたは権限不足の可能性。

1. ローカルコミットは作成済みのまま残す（破棄しない）。
2. 「PAT を更新したあと、`cd /d "C:\github-pages-work\GitHub Pages Research Publisher" && git push origin main` を手動で実行してください」とユーザに報告。

### 7-3. 検索結果 0 件

`--product` 表記揺れの可能性が高い。

1. `--product` を外して再実行。
2. ヒットしたチャンクの `metadata.product` を確認。
3. 正しい表記で再実行。
4. 「6. 登録済み製品名」の更新が必要なら、メンテナンス記録に書き加えるようユーザに提案。

### 7-4. MkDocs ビルド失敗（GitHub Actions 側）

GitHub Pages の Actions タブで失敗ログを確認。よくある原因：

- レポート MD の構文エラー（テーブル列ズレなど）
- nav に存在しないファイル参照
- 文字コード問題

修復は次のレポート push で上書きされる場合もあるが、明らかな原因がある場合はユーザに報告。

### 7-5. PC スリープ・Dispatch切断

Dispatch は PC が起動してアプリが開いている間しか動作しない。
タスク途中で切れた場合は、再ペアリング後にユーザに「途中まで何をしたか」を最初に報告する。

---

## 8. 完了報告フォーマット

Dispatch への完了報告は必ず下記項目を含める：

```
[完了] <検索クエリ>
- 製品フィルタ: <product or なし>
- 取得チャンク数: <N>
- 出力 MD: docs/research/<filename>.md
- git push: 成功 / 失敗
- 公開 URL: https://ai-crafted-portfolio.github.io/research/<slug>/
  （Pages ビルドに数分かかるため即時 404 の場合あり）
```

失敗時は冒頭に `[失敗] <段階> <要約>` を置き、原因と次のアクション提案を続ける。

---

## 9. 禁止事項

- `git push --force` / `git push -f`（履歴破壊）
- `main` 以外のブランチへの push
- `.git` ディレクトリへの直接書き込み
- ChromaDB のチャンクに対する書き込み・削除（このプロジェクトは ChromaDB を**読み取り専用**として扱う）
- `tools\query_and_publish.py` 本体の自動修正（バグ発見時はユーザに報告し、修正は承認後）
- `mkdocs.yml` / `.github/workflows/deploy.yml` の自動編集（既存サイト構造を壊さないよう、変更は承認後）
- `docs/index.md` の上書き（既存サイトのトップページ。触らない）
- `docs/PROJECT_INSTRUCTIONS.md` を作る（MkDocs ビルドに含まれてしまう。ルート直下に置く）
- `--push` 実行時、`git status` の差分が想定外のファイル（`.gitignore` 等の意図しない変更）を含む場合のそのままの push（中断してユーザ確認）
- 100MB 超のファイルのコミット（GitHub の上限）
- 機密情報・社内固有情報・個人情報を含む可能性のあるテキストのチャンクに対する公開（IBM 公式マニュアルからの抽出のみが対象）

---

## 10. 自動化のヒント（任意）

- 同じトピックで定期更新したい場合、Cowork のスケジュールタスクで毎週同じ `query_and_publish.py` 実行を仕込める。
- `docs/research/index.md` はスクリプトが自動再生成するため、手作業での編集は不要（編集してもコミット時に上書きされる）。

---

## メンテナンス

| 日付 | 変更内容 | 変更者 |
|---|---|---|
| 2026-04-28 | 初版（既存 MkDocs サイト `ai-crafted-portfolio.github.io` への統合方式を確定） | Claude／Shuichi |
