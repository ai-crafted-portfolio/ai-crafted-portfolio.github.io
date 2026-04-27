"""
GitHub Pages Research Publisher (MkDocs integration)

mcp-education の ChromaDB から特定トピックのチャンクを検索し、
Markdown レポートとして docs/research/ に保存して GitHub に push する。

push 後、GitHub Actions（.github/workflows/deploy.yml）が MkDocs build を実行し、
GitHub Pages に反映される。

Usage:
    python tools\\query_and_publish.py "<query>" [--product "<name>"] [--top-k N] [--push] [--dry-run]

Exit codes:
    0  OK
    2  Argument / usage error
    3  ChromaDB query failure
    4  Git operation failure
"""
from __future__ import annotations

import argparse
import datetime
import os
import re
import subprocess
import sys
from pathlib import Path

# === パス ===
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent
DOCS_DIR = PROJECT_ROOT / "docs"
RESEARCH_DIR = DOCS_DIR / "research"
RESEARCH_INDEX = RESEARCH_DIR / "index.md"

# === ChromaDB ===
CHROMA_PATH = Path(r"C:\mcp-education\chroma_data")
COLLECTION_NAME = "manual_docs"
EMBEDDING_MODEL = "all-MiniLM-L6-v2"

# === GitHub Pages URL ===
PAGES_BASE_URL = "https://ai-crafted-portfolio.github.io"

# === Exit codes ===
EXIT_OK = 0
EXIT_USAGE = 2
EXIT_CHROMA_FAIL = 3
EXIT_GIT_FAIL = 4


def log(msg: str, level: str = "INFO") -> None:
    ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    stream = sys.stderr if level in ("ERROR", "WARN") else sys.stdout
    print(f"[{ts}] [{level}] {msg}", flush=True, file=stream)


def slugify(text: str, maxlen: int = 50) -> str:
    s = re.sub(r"[^a-zA-Z0-9_-]+", "-", text.lower())
    s = re.sub(r"-+", "-", s).strip("-")
    return s[:maxlen] if s else "report"


def query_chroma(query: str, product: str | None, top_k: int):
    try:
        import chromadb
        from chromadb.utils import embedding_functions
    except ImportError as e:
        log(f"chromadb / sentence-transformers が import できません: {e}", "ERROR")
        log("pip install chromadb sentence-transformers --break-system-packages を実行してください", "ERROR")
        sys.exit(EXIT_CHROMA_FAIL)

    if not CHROMA_PATH.exists():
        log(f"ChromaDB パスが存在しません: {CHROMA_PATH}", "ERROR")
        sys.exit(EXIT_CHROMA_FAIL)

    try:
        client = chromadb.PersistentClient(path=str(CHROMA_PATH))
        ef = embedding_functions.SentenceTransformerEmbeddingFunction(
            model_name=EMBEDDING_MODEL
        )
        collection = client.get_collection(
            name=COLLECTION_NAME,
            embedding_function=ef,
        )
    except Exception as e:
        log(f"コレクションのロードに失敗: {e}", "ERROR")
        log("HNSW 破損の可能性があります。診断スクリプトを実行してください。", "ERROR")
        sys.exit(EXIT_CHROMA_FAIL)

    where = {"product": product} if product else None

    try:
        results = collection.query(
            query_texts=[query],
            n_results=top_k,
            where=where,
        )
    except Exception as e:
        log(f"ChromaDB クエリ失敗: {e}", "ERROR")
        sys.exit(EXIT_CHROMA_FAIL)

    return results


def render_report_md(
    query: str, product: str | None, top_k: int, results: dict
) -> tuple[str, str]:
    docs = (results.get("documents") or [[]])[0]
    metadatas = (results.get("metadatas") or [[]])[0]
    distances = (results.get("distances") or [[]])[0]
    ids = (results.get("ids") or [[]])[0]

    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    title = query
    if product:
        title = f"{query} ({product})"

    lines: list[str] = []
    lines.append(f"# {title}")
    lines.append("")
    lines.append("## メタ情報")
    lines.append("")
    lines.append("| 項目 | 値 |")
    lines.append("|---|---|")
    lines.append(f"| Query | `{query}` |")
    lines.append(f"| Product filter | `{product if product else '(none)'}` |")
    lines.append(f"| Top-K | {top_k} |")
    lines.append(f"| Generated | {timestamp} |")
    lines.append(f"| Chunks retrieved | {len(docs)} |")
    lines.append(f"| Source | mcp-education ChromaDB ({COLLECTION_NAME}) |")
    lines.append("")
    lines.append("## 検索結果")
    lines.append("")

    if not docs:
        lines.append("!!! warning")
        lines.append("    検索結果が0件でした。`--product` の表記揺れの可能性があります。")
        lines.append("")
        return "\n".join(lines), timestamp

    for i, (doc, meta, dist, cid) in enumerate(
        zip(docs, metadatas, distances, ids), start=1
    ):
        meta = meta or {}
        prod = str(meta.get("product", ""))
        src = str(meta.get("source", ""))
        page = str(meta.get("page", ""))
        cid_s = str(cid)

        lines.append(f"### #{i} — {prod}")
        lines.append("")
        lines.append(f"- **Source**: `{src}`")
        lines.append(f"- **Page**: {page}")
        lines.append(f"- **Distance**: {dist:.4f}")
        lines.append(f"- **Chunk ID**: `{cid_s}`")
        lines.append("")
        # チャンク本文を引用ブロックで表示
        for line in (doc or "").split("\n"):
            lines.append(f"> {line}" if line.strip() else ">")
        lines.append("")

    return "\n".join(lines), timestamp


def save_report(query: str, product: str | None, content: str) -> Path:
    RESEARCH_DIR.mkdir(parents=True, exist_ok=True)
    ts = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    base = slugify(query)
    if product:
        base = f"{slugify(product)}_{base}"
    filename = f"{ts}_{base}.md"
    out_path = RESEARCH_DIR / filename
    out_path.write_text(content, encoding="utf-8")
    return out_path


def regenerate_research_index() -> Path:
    """docs/research/ 配下の MD（index.md 除く）をスキャンして index.md を再生成する。"""
    items: list[tuple[str, str, str]] = []
    if RESEARCH_DIR.exists():
        for p in sorted(RESEARCH_DIR.glob("*.md"), reverse=True):
            if p.name == "index.md":
                continue
            try:
                first_h1 = ""
                with p.open(encoding="utf-8") as f:
                    for line in f:
                        if line.startswith("# "):
                            first_h1 = line.lstrip("# ").strip()
                            break
            except Exception:
                first_h1 = p.stem
            mtime = datetime.datetime.fromtimestamp(p.stat().st_mtime).strftime(
                "%Y-%m-%d %H:%M"
            )
            items.append((p.name, first_h1 or p.stem, mtime))

    lines: list[str] = []
    lines.append("# リサーチレポート")
    lines.append("")
    lines.append(
        "mcp-education ChromaDB（IBM 公式マニュアル）から検索・抽出したチャンクをまとめたレポート一覧。"
    )
    lines.append("")
    lines.append("| 日時 | タイトル |")
    lines.append("|---|---|")
    if items:
        for name, title, mtime in items:
            # MkDocs では .md は省略してリンクできる
            link_target = name[:-3] if name.endswith(".md") else name
            lines.append(f"| {mtime} | [{title}]({link_target}.md) |")
    else:
        lines.append("| - | (まだレポートがありません) |")
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append(
        "レポートは `tools/query_and_publish.py` で自動生成されています。"
        "詳細は `PROJECT_INSTRUCTIONS.md` を参照。"
    )
    lines.append("")

    RESEARCH_DIR.mkdir(parents=True, exist_ok=True)
    RESEARCH_INDEX.write_text("\n".join(lines), encoding="utf-8")
    return RESEARCH_INDEX


def run_git(args: list[str], cwd: Path) -> tuple[int, str, str]:
    log(f"$ git {' '.join(args)}")
    result = subprocess.run(
        ["git"] + args,
        cwd=str(cwd),
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    if result.stdout:
        sys.stdout.write(result.stdout)
    if result.stderr:
        sys.stderr.write(result.stderr)
    return result.returncode, result.stdout or "", result.stderr or ""


def git_publish(out_path: Path, query: str) -> int:
    cwd = PROJECT_ROOT

    rc, _, _ = run_git(["status", "--porcelain"], cwd)
    if rc != 0:
        log("git status 失敗", "ERROR")
        return EXIT_GIT_FAIL

    rc, _, _ = run_git(["add", "docs/research"], cwd)
    if rc != 0:
        log("git add 失敗", "ERROR")
        return EXIT_GIT_FAIL

    msg = f"Add research report: {query}"
    rc, _, stderr = run_git(["commit", "-m", msg], cwd)
    if rc != 0:
        if "nothing to commit" in (stderr or "").lower():
            log("変更なし。push をスキップ", "WARN")
            return EXIT_OK
        log("git commit 失敗", "ERROR")
        return EXIT_GIT_FAIL

    rc, _, _ = run_git(["push", "origin", "main"], cwd)
    if rc != 0:
        log("git push 失敗。PAT 期限切れの可能性。手動で push してください。", "ERROR")
        return EXIT_GIT_FAIL

    return EXIT_OK


def main() -> int:
    parser = argparse.ArgumentParser(
        description="mcp-education ChromaDB → MkDocs Markdown → GitHub Pages publisher",
    )
    parser.add_argument("query", help="検索クエリ（英語キーワード推奨）")
    parser.add_argument("--product", default=None, help="製品名フィルタ（完全一致）")
    parser.add_argument("--top-k", type=int, default=10, help="取得チャンク数（既定: 10）")
    parser.add_argument("--push", action="store_true", help="生成後に git add/commit/push する")
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="ファイル書き込みも git 操作も行わず、検索結果サマリのみ表示",
    )
    args = parser.parse_args()

    log(
        f"Query={args.query!r} Product={args.product!r} TopK={args.top_k} "
        f"Push={args.push} DryRun={args.dry_run}"
    )

    # 1. ChromaDB 照会
    results = query_chroma(args.query, product=args.product, top_k=args.top_k)
    docs = (results.get("documents") or [[]])[0]
    log(f"ChromaDB から {len(docs)} 件のチャンクを取得")

    # 2. Markdown 生成
    md_content, _ = render_report_md(args.query, args.product, args.top_k, results)

    if args.dry_run:
        log("dry-run: ファイル書き込み・git 操作はスキップ")
        log(f"would write {len(md_content)} bytes to docs/research/")
        for i, doc in enumerate(docs[:3], 1):
            preview = (doc or "")[:120].replace("\n", " ")
            log(f"  [{i}] {preview}...")
        return EXIT_OK

    if len(docs) == 0:
        log("検索結果が0件です。--product の表記揺れの可能性。", "WARN")

    # 3. ファイル保存
    out_path = save_report(args.query, args.product, md_content)
    log(f"レポート保存: {out_path.relative_to(PROJECT_ROOT)}")

    # 4. research/index.md 再生成
    index_path = regenerate_research_index()
    log(f"index.md 再生成: {index_path.relative_to(PROJECT_ROOT)}")

    # 5. git push
    if args.push:
        rc = git_publish(out_path, args.query)
        if rc != EXIT_OK:
            log("Git 操作に失敗。ローカルコミットは残っているか確認してください。", "ERROR")
            return rc
        log("GitHub への push 成功")
        # MkDocs URL: foo.md → /research/foo/
        slug = out_path.stem
        log(f"公開 URL（Pages ビルド完了後、数分待つ）: {PAGES_BASE_URL}/research/{slug}/")
    else:
        log("--push 未指定のため git 操作はスキップ")

    return EXIT_OK


if __name__ == "__main__":
    sys.exit(main())

(main())
