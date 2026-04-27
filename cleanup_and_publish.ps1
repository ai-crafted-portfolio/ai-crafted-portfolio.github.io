# Cleanup and initial publish for MkDocs integration
#
# What this does:
#   1. Restore original .gitignore and docs/index.md from git index
#   2. Delete obsolete files (test_write.txt, index.html, assets/, research/, etc.)
#   3. Show git status for review
#   4. After confirmation, commit and push everything
#
# How to run (PowerShell):
#   powershell -ExecutionPolicy Bypass -File "C:\github-pages-work\GitHub Pages Research Publisher\cleanup_and_publish.ps1"
#
# Note: $ErrorActionPreference is intentionally NOT "Stop" because git writes to stderr.

# === Configuration ===
$ROOT = $PSScriptRoot
if (-not $ROOT) { $ROOT = (Get-Location).Path }

Write-Host ""
Write-Host "================================================================"
Write-Host " Research Publisher - MkDocs Integration Cleanup & Publish"
Write-Host "================================================================"
Write-Host " Project root: $ROOT"
Write-Host "================================================================"
Write-Host ""

# Verify git is available
$gitCmd = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitCmd) {
    Write-Host "ERROR: git command not found. Install Git for Windows." -ForegroundColor Red
    exit 1
}

Set-Location -LiteralPath $ROOT

# Verify .git is here and points to ai-crafted-portfolio.github.io
if (-not (Test-Path -LiteralPath "$ROOT\.git")) {
    Write-Host "ERROR: .git folder not found in $ROOT" -ForegroundColor Red
    Write-Host "  Run setup_windows.ps1 first, or clone the repo manually." -ForegroundColor Red
    exit 1
}

# === Step 1: Restore original files from git ===
Write-Host "[1/5] Restoring original files from git..."

$filesToRestore = @(".gitignore", "docs/index.md")
foreach ($f in $filesToRestore) {
    Write-Host "      git restore $f"
    & git restore $f
    if ($LASTEXITCODE -ne 0) {
        Write-Host "      WARNING: git restore $f exited with code $LASTEXITCODE (file may already match HEAD)" -ForegroundColor Yellow
    }
}

# === Step 2: Delete obsolete files ===
Write-Host ""
Write-Host "[2/5] Removing obsolete files..."

$obsoletePaths = @(
    "test_write.txt",
    "index.html",
    "assets",
    "research",
    "setup_windows.ps1",
    "docs\PROJECT_INSTRUCTIONS.md"
)

foreach ($p in $obsoletePaths) {
    $full = Join-Path $ROOT $p
    if (Test-Path -LiteralPath $full) {
        Write-Host "      Removing: $p"
        Remove-Item -LiteralPath $full -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path -LiteralPath $full) {
            Write-Host "      WARNING: failed to remove $p (in use?)" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "      Not present: $p (skip)"
    }
}

# === Step 3: Verify expected files are in place ===
Write-Host ""
Write-Host "[3/5] Verifying expected files..."

$expectedFiles = @(
    ".gitignore",
    "mkdocs.yml",
    "README.md",
    "PROJECT_INSTRUCTIONS.md",
    "cleanup_and_publish.ps1",
    "docs\index.md",
    "docs\research\index.md",
    "tools\query_and_publish.py",
    ".github\workflows\deploy.yml"
)

$missing = @()
foreach ($f in $expectedFiles) {
    $full = Join-Path $ROOT $f
    if (Test-Path -LiteralPath $full) {
        Write-Host "      OK: $f"
    }
    else {
        Write-Host "      MISSING: $f" -ForegroundColor Red
        $missing += $f
    }
}

if ($missing.Count -gt 0) {
    Write-Host ""
    Write-Host "ERROR: Some expected files are missing. Cannot proceed." -ForegroundColor Red
    exit 1
}

# === Step 4: Show git status ===
Write-Host ""
Write-Host "[4/5] Showing git status..."
Write-Host "----------------------------------------------------------------"
& git status
Write-Host "----------------------------------------------------------------"
Write-Host ""

Write-Host "Expected diff:"
Write-Host "  Modified:    .github/workflows/deploy.yml (removed --strict)"
Write-Host "  Modified:    mkdocs.yml (added research/index.md to nav)"
Write-Host "  Untracked:   PROJECT_INSTRUCTIONS.md, README.md (new)"
Write-Host "  Untracked:   cleanup_and_publish.ps1 (new)"
Write-Host "  Untracked:   docs/research/ (new dir with index.md)"
Write-Host "  Untracked:   tools/ (new dir with query_and_publish.py)"
Write-Host "  Unchanged:   .gitignore, docs/index.md (restored from git)"
Write-Host ""

$ans = Read-Host "[5/5] Proceed with add / commit / push? (y/N)"

if ($ans -ne "y" -and $ans -ne "Y") {
    Write-Host ""
    Write-Host "Aborted. You can commit later by running:"
    Write-Host '  cd "C:\github-pages-work\GitHub Pages Research Publisher"'
    Write-Host '  git add -A'
    Write-Host '  git commit -m "Add research publisher"'
    Write-Host '  git push origin main'
    exit 0
}

Write-Host ""
Write-Host "Running git add -A ..."
& git add -A
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: git add failed" -ForegroundColor Red
    exit 1
}

Write-Host "Running git commit ..."
& git commit -m "Add research publisher integration with MkDocs"
$commitExit = $LASTEXITCODE
if ($commitExit -ne 0) {
    Write-Host "WARNING: git commit failed or no changes. Continuing." -ForegroundColor Yellow
}

Write-Host "Running git push origin main ..."
& git push origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: git push failed. PAT may have expired." -ForegroundColor Red
    Write-Host "  Action: Update credentials in Git Credential Manager and run 'git push origin main' manually."
    exit 1
}

Write-Host ""
Write-Host "================================================================"
Write-Host " Done!"
Write-Host "================================================================"
Write-Host " Pages URL: https://ai-crafted-portfolio.github.io/"
Write-Host " Research:  https://ai-crafted-portfolio.github.io/research/"
Write-Host " (GitHub Actions will build the site. Wait a few minutes.)"
Write-Host "================================================================"
Write-Host ""
Write-Host "Next: try a dry-run of the publisher script:"
Write-Host '  python tools\query_and_publish.py "PowerHA cluster startup" --product "IBM PowerHA SystemMirror 7.2 TL8" --top-k 5 --dry-run'
Write-Host ""
