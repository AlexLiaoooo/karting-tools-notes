<#
.SYNOPSIS
    Mirror the Karting Tools design notes from the Obsidian vault into docs/.

.DESCRIPTION
    The Obsidian vault is the source of truth for these notes. This script
    copies them into docs/ byte-for-byte so the repository copy does not go
    stale. It never writes back to the vault, and it never commits.

    Run it before committing whenever you have edited the notes in Obsidian.

.PARAMETER Check
    Report drift without copying anything.

    Exit codes: 0 = up to date, 1 = stale, 2 = vault not found.
    The pre-commit hook relies on 2 being distinct so a machine without the
    vault is not blocked from committing.

.PARAMETER VaultPath
    Override the vault folder if the vault moves.

.EXAMPLE
    .\scripts\sync-docs.ps1
    Copy any new or changed notes into docs/.

.EXAMPLE
    .\scripts\sync-docs.ps1 -Check
    Report whether docs/ is stale, changing nothing.
#>
[CmdletBinding()]
param(
    [switch]$Check,
    [string]$VaultPath = 'C:\MY_FILES\Obsidian\Personal_Vault\Personal Projects\Karting tools'
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$docsDir  = Join-Path $repoRoot 'docs'

if (-not (Test-Path -LiteralPath $VaultPath)) {
    Write-Host "Vault folder not found:" -ForegroundColor Red
    Write-Host "  $VaultPath"
    Write-Host "Pass -VaultPath '<folder>' if the vault has moved."
    exit 2
}

if (-not (Test-Path -LiteralPath $docsDir)) {
    New-Item -ItemType Directory -Path $docsDir | Out-Null
}

$notes = @(Get-ChildItem -LiteralPath $VaultPath -Filter '*.md' -File)
if ($notes.Count -eq 0) {
    Write-Host "No .md notes found in $VaultPath" -ForegroundColor Yellow
    exit 0
}

if ($Check) {
    Write-Host "Checking docs/ against vault (no files will be written)" -ForegroundColor Cyan
} else {
    Write-Host "Syncing vault notes into docs/" -ForegroundColor Cyan
}
Write-Host "  vault: $VaultPath"
Write-Host ""

$newCount = 0
$changedCount = 0
$sameCount = 0

foreach ($note in $notes) {
    $target = Join-Path $docsDir $note.Name

    if (-not (Test-Path -LiteralPath $target)) {
        $status = 'new'
    } else {
        $srcHash = (Get-FileHash -LiteralPath $note.FullName -Algorithm SHA256).Hash
        $dstHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash
        if ($srcHash -eq $dstHash) { $status = 'same' } else { $status = 'changed' }
    }

    if ($status -eq 'new') {
        Write-Host "  new      $($note.Name)" -ForegroundColor Green
        $newCount++
    } elseif ($status -eq 'changed') {
        Write-Host "  changed  $($note.Name)" -ForegroundColor Yellow
        $changedCount++
    } else {
        Write-Host "  same     $($note.Name)" -ForegroundColor DarkGray
        $sameCount++
    }

    if ((-not $Check) -and ($status -ne 'same')) {
        Copy-Item -LiteralPath $note.FullName -Destination $target -Force
    }
}

# Notes that exist in docs/ but no longer in the vault: report, never delete.
$vaultNames = $notes | ForEach-Object { $_.Name }
$orphans = @(Get-ChildItem -LiteralPath $docsDir -Filter '*.md' -File |
    Where-Object { $vaultNames -notcontains $_.Name })

foreach ($orphan in $orphans) {
    Write-Host "  orphan   $($orphan.Name) (not in vault; left untouched)" -ForegroundColor Magenta
}

Write-Host ""
$stale = $newCount + $changedCount

if ($Check) {
    if ($stale -gt 0) {
        Write-Host "docs/ is STALE: $newCount new, $changedCount changed." -ForegroundColor Yellow
        Write-Host "Run .\scripts\sync-docs.ps1 to update it."
        exit 1
    }
    Write-Host "docs/ is up to date ($sameCount unchanged)." -ForegroundColor Green
    exit 0
}

if ($stale -eq 0) {
    Write-Host "Already up to date ($sameCount unchanged). Nothing to commit." -ForegroundColor Green
    exit 0
}

Write-Host "Copied $newCount new, $changedCount changed." -ForegroundColor Green
Write-Host ""
Write-Host "Pending changes:" -ForegroundColor Cyan
& git -C $repoRoot status --short -- docs
Write-Host ""
Write-Host "Review, then commit:" -ForegroundColor Cyan
Write-Host '  git add docs; git commit -m "Update design docs from vault"; git push'
