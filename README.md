# ai-crafted-portfolio.github.io

`Claude` を活用して作る技術ポートフォリオ（MkDocs Material サイト）。

公開先：<https://ai-crafted-portfolio.github.io/>

## このリポジトリでできること

`tools/query_and_publish.py` を実行すると、`mcp-education` の ChromaDB（IBM 公式マニュアル）から特定トピックのチャンクを検索し、Markdown レポートとして `docs/research/` に保存して GitHub に push する。GitHub Actions が MkDocs build を実行し、Pages に反映される。

```cmd
cd /d "C:\github-pages-work\GitHub Pages Research Publisher"
python tools\query_and_publish.py "<検索クエリ>" --product "<製品名>" --top-k 10 --push
```

詳しい運用ルールは [`PROJECT_INSTRUCTIONS.md`](PROJECT_INSTRUCTIONS.md) を参照。

## ファイル構成

- `docs/` ... MkDocs ソース（`docs/index.md` がサイトホーム、`docs/research/` がレポート群）
- `tools/query_and_publish.py` ... ChromaDB 照会 + MD 生成 + git push
- `mkdocs.yml` ... MkDocs 設定
- `.github/workflows/deploy.yml` ... MkDocs build → GitHub Pages デプロイ
- `PROJECT_INSTRUCTIONS.md` ... 運用ルール（Cowork カスタムインストラクション用）
- `cleanup_and_publish.ps1` ... 初回セットアップ用 PowerShell

## 初回セットアップ

```powershell
powershell -ExecutionPolicy Bypass -File "C:\github-pages-work\GitHub Pages Research Publisher\cleanup_and_publish.ps1"
```
