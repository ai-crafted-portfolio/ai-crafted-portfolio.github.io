# publish_tivoli_lfa_v1_auto.ps1 (ASCII-only)
# Tivoli Log File Agent 6.3 v1 publish:
#   - 13-chapter site for products/tivoli-lfa-6-3/
#   - Authored from LFA 6.3 User's Guide (S3 SC14-7484-04), ITM 6.3 ref (S2/S_ITM_*),
#     Netcool/OMNIbus 8.1 EIF Probe (S_NCO_*) and confirmed metadata via setgetweb mirror
#   - HNSW corruption blocked search_manual; existing knowledge + web fetch fallback used
#   - v1 = text-complete, image embeds deferred to v2 (IBM Docs SPA blocks plain fetch)
#   - mkdocs.yml nav updated to include Tivoli LFA 6.3 alongside Netcool 8.1
#   - products/index.md row updated from "(preparing)" to live link
#
# ASCII-only rule: PowerShell 5.x reads .ps1 as CP932 on JP Windows.

$ProjectRoot = "C:\github-pages-work\GitHub Pages Research Publisher"
$LogFile     = Join-Path $ProjectRoot "publish_tivoli_lfa_v1_auto.log"
$ResultFile  = Join-Path $ProjectRoot "publish_tivoli_lfa_v1_auto.result.txt"
$DocsDir     = Join-Path $ProjectRoot "docs\products\tivoli-lfa-6-3"

Set-Location $ProjectRoot
"" | Set-Content -Path $LogFile -Encoding UTF8
"" | Set-Content -Path $ResultFile -Encoding UTF8

function Add-Log {
    param([string]$line)
    $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    "[$stamp] $line" | Add-Content -Path $LogFile -Encoding UTF8
}
function Write-Result {
    param([string]$status, [string]$detail)
    Set-Content -Path $ResultFile -Value "$status $detail" -Encoding UTF8
    Add-Log "RESULT: $status $detail"
}
function Append-CommandOutput {
    param([scriptblock]$block, [string]$label)
    Add-Log "--- BEGIN $label ---"
    try { & $block 2>&1 | Out-String | Add-Content -Path $LogFile -Encoding UTF8 }
    catch { "EXCEPTION inside ${label}: $($_.Exception.Message)" | Add-Content -Path $LogFile -Encoding UTF8 }
    Add-Log "--- END   $label ---"
}

Add-Log "=== publish_tivoli_lfa_v1_auto.ps1 START (ASCII-only) ==="
Add-Log "ProjectRoot: $ProjectRoot"
Add-Log "DocsDir:     $DocsDir"

try {
    # branch verify
    $headFile = Join-Path $ProjectRoot ".git\HEAD"
    if (-not (Test-Path $headFile)) { Write-Result "FAIL" "missing .git/HEAD"; exit 1 }
    $headContent = (Get-Content $headFile -Raw).Trim()
    Add-Log "HEAD raw: $headContent"
    if ($headContent -match '^ref:\s*refs/heads/(.+)$') { $branch = $matches[1].Trim() } else { $branch = $headContent }
    Add-Log "branch: $branch"
    if ($branch -ne "main") { Write-Result "FAIL" "not on main (current: $branch)"; exit 1 }

    if (Test-Path ".git\index.lock") {
        Remove-Item -Force ".git\index.lock"
        Add-Log "Removed leftover .git\index.lock"
    }

    # Phase 1: presence of 13 MD files
    Add-Log "=== Phase 1: verify 13 Tivoli LFA MD files exist ==="
    $newFiles = @(
        "index.md",
        "01-commands.md",
        "02-settings.md",
        "03-glossary.md",
        "04-playbook.md",
        "05-troubleshooting.md",
        "06-manual-map.md",
        "07-sources.md",
        "08-config-procedures.md",
        "09-incident-procedures.md",
        "10-out-of-scope.md",
        "11-scenarios.md",
        "12-use-cases.md"
    )
    $missing = @()
    foreach ($f in $newFiles) {
        $p = Join-Path $DocsDir $f
        if (-not (Test-Path $p)) {
            $missing += $f
        } else {
            $size = (Get-Item $p).Length
            Add-Log "found: $f ($size bytes)"
        }
    }
    if ($missing.Count -gt 0) {
        Write-Result "FAIL" ("missing Tivoli LFA MD files: " + ($missing -join ","))
        exit 1
    }

    # Phase 2: per-chapter minimum size sanity check (each >= 4000 bytes)
    Add-Log "=== Phase 2: per-chapter size >= 4000 bytes ==="
    $undersized = @()
    foreach ($f in $newFiles) {
        $p = Join-Path $DocsDir $f
        $size = (Get-Item $p).Length
        if ($size -lt 4000) {
            $undersized += "$f($size)"
        }
    }
    if ($undersized.Count -gt 0) {
        Add-Log "WARN: chapters below 4000 bytes: $($undersized -join ', ')"
    }

    # Phase 3: incident hypothesis branching present in 09-incident-procedures.md
    Add-Log "=== Phase 3: A/B/C hypothesis branches >= 5 ==="
    $incPath = Join-Path $DocsDir "09-incident-procedures.md"
    $incContent = Get-Content $incPath -Raw
    $hypCount = ([regex]::Matches($incContent, '\| \*\*A\*\* \|')).Count
    Add-Log "hypothesis-A row count: $hypCount"
    if ($hypCount -lt 5) {
        Write-Result "FAIL" "09-incident missing A-hypothesis rows ($hypCount)"
        exit 1
    }

    # Phase 4: scenarios anchor count
    Add-Log "=== Phase 4: scenarios anchors >= 5 ==="
    $scnPath = Join-Path $DocsDir "11-scenarios.md"
    $scnContent = Get-Content $scnPath -Raw
    $scnCount = ([regex]::Matches($scnContent, '\{ #scn-')).Count
    if ($scnCount -lt 5) {
        Write-Result "FAIL" "11-scenarios fewer than 5 ($scnCount)"
        exit 1
    }
    Add-Log "scenario count: $scnCount"

    # Phase 5: usecase anchor count
    Add-Log "=== Phase 5: use-cases anchors >= 25 ==="
    $ucPath = Join-Path $DocsDir "12-use-cases.md"
    $ucContent = Get-Content $ucPath -Raw
    $ucCount = ([regex]::Matches($ucContent, '\{ #uc-')).Count
    if ($ucCount -lt 25) {
        Write-Result "FAIL" "12-use-cases fewer than 25 ($ucCount)"
        exit 1
    }
    Add-Log "usecase count: $ucCount"

    # Phase 6: nav check - mkdocs.yml must reference tivoli-lfa-6-3
    Add-Log "=== Phase 6: mkdocs.yml nav contains tivoli-lfa-6-3 ==="
    $navPath = Join-Path $ProjectRoot "mkdocs.yml"
    $navContent = Get-Content $navPath -Raw
    if (-not ($navContent -match 'products/tivoli-lfa-6-3/index\.md')) {
        Write-Result "FAIL" "mkdocs.yml nav missing tivoli-lfa-6-3 entry"
        exit 1
    }
    Add-Log "mkdocs.yml nav OK"

    # Phase 7: products/index.md row live-link check
    Add-Log "=== Phase 7: products/index.md live-link for Tivoli LFA ==="
    $prodIdxPath = Join-Path $ProjectRoot "docs\products\index.md"
    $prodIdxContent = Get-Content $prodIdxPath -Raw
    if (-not ($prodIdxContent -match 'tivoli-lfa-6-3/index\.md')) {
        Write-Result "FAIL" "products/index.md missing Tivoli LFA live link"
        exit 1
    }
    Add-Log "products/index.md live link OK"

    # Phase 8: cross-link sanity - each MD has at least 3 internal links to other chapters
    Add-Log "=== Phase 8: cross-link sanity ==="
    $crossLinkLow = @()
    foreach ($f in $newFiles) {
        if ($f -eq "index.md") { continue }
        $p = Join-Path $DocsDir $f
        $body = Get-Content $p -Raw
        $links = ([regex]::Matches($body, '\(\d{2}-[a-z\-]+\.md')).Count
        if ($links -lt 3 -and $f -ne "10-out-of-scope.md" -and $f -ne "04-playbook.md" -and $f -ne "05-troubleshooting.md" -and $f -ne "06-manual-map.md" -and $f -ne "07-sources.md") {
            $crossLinkLow += "$f($links)"
        }
    }
    if ($crossLinkLow.Count -gt 0) {
        Add-Log "WARN: low cross-link chapters: $($crossLinkLow -join ', ')"
    }

    # Phase 9: mkdocs build (no --strict due to pre-existing nav warnings)
    Add-Log "=== Phase 9: mkdocs build (no --strict, pre-existing warnings allowed) ==="
    $mkdocsCmd = Get-Command mkdocs -ErrorAction SilentlyContinue
    if ($mkdocsCmd) {
        Append-CommandOutput { mkdocs build --site-dir _site_tivoli_lfa_v1_check } "mkdocs build"
        if ($LASTEXITCODE -ne 0) { Write-Result "FAIL" "mkdocs build failed (RC=$LASTEXITCODE)"; exit 1 }
        if (Test-Path "_site_tivoli_lfa_v1_check") { Remove-Item -Recurse -Force "_site_tivoli_lfa_v1_check" -ErrorAction SilentlyContinue }
    } else {
        Add-Log "mkdocs not on PATH - skipping local build (Actions strict will run server-side)"
    }

    # Phase 10: git add / commit / push
    Add-Log "=== Phase 10: git add / commit / push ==="
    Append-CommandOutput { git status --short } "git status (before)"

    git add docs/products/tivoli-lfa-6-3 2>&1 | Out-String | Add-Content -Path $LogFile -Encoding UTF8
    if ($LASTEXITCODE -ne 0) { Write-Result "FAIL" "git add tivoli-lfa-6-3 failed"; exit 1 }

    git add mkdocs.yml 2>&1 | Out-String | Add-Content -Path $LogFile -Encoding UTF8
    if ($LASTEXITCODE -ne 0) { Write-Result "FAIL" "git add mkdocs.yml failed"; exit 1 }

    git add docs/products/index.md 2>&1 | Out-String | Add-Content -Path $LogFile -Encoding UTF8
    if ($LASTEXITCODE -ne 0) { Add-Log "WARN: git add docs/products/index.md non-zero (may already be committed)" }

    git add RUN_tivoli_lfa_v1.bat publish_tivoli_lfa_v1_auto.ps1 2>&1 | Out-String | Add-Content -Path $LogFile -Encoding UTF8
    if ($LASTEXITCODE -ne 0) { Add-Log "WARN: git add scripts non-zero (may already be committed)" }

    Append-CommandOutput { git status } "git status (after staging)"
    Append-CommandOutput { git --no-pager diff --cached --stat } "git diff --cached --stat"

    $stagedNames = git --no-pager diff --cached --name-only
    if (-not $stagedNames) {
        Write-Result "FAIL" "nothing staged (no diff between working tree and HEAD)"
        exit 1
    }

    $commitMessage = "Tivoli Log File Agent 6.3 v1: 13-chapter operational reference (commands 42 itmcmd/tacmd/agent/EIF/diag, settings .conf 22 + .fmt 8 + openv 10 = 40, glossary 62, troubleshoot 20, manual map 18, sources 24, config procedures 18 cfg-* anchors, incident procedures 18 inc-* anchors with A/B/C hypothesis on 5 S-tier, scenarios 6, usecases 30). Authored from LFA 6.3 User's Guide S3 SC14-7484-04 + ITM 6.3 reference + Netcool/OMNIbus 8.1 EIF Probe sources (HNSW corruption blocked search_manual, fallback to existing knowledge + web fetch). Image embeds deferred to v2 (IBM Docs SPA shell blocks plain fetch). mkdocs nav updated under monitoring section alongside Netcool/OMNIbus 8.1, products/index.md row promoted from preparing to live link."
    Add-Log "commit message: $commitMessage"
    git commit -m $commitMessage 2>&1 | Out-String | Add-Content -Path $LogFile -Encoding UTF8
    if ($LASTEXITCODE -ne 0) { Write-Result "FAIL" "git commit failed"; exit 1 }

    $sha = (git rev-parse HEAD).Trim()
    Add-Log "new commit sha: $sha"

    Add-Log "pushing origin main..."
    git push origin main 2>&1 | Out-String | Add-Content -Path $LogFile -Encoding UTF8
    if ($LASTEXITCODE -ne 0) { Write-Result "FAIL" "git push failed (commit $sha preserved locally)"; exit 1 }

    Add-Log "push success"
    Write-Result "OK" $sha
    Add-Log "=== publish_tivoli_lfa_v1_auto.ps1 END (success) ==="
    exit 0

} catch {
    $msg = $_.Exception.Message
    Write-Result "FAIL" ("exception: " + $msg)
    Add-Log "EXCEPTION: $msg"
    exit 1
}
