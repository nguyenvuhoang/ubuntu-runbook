param(
    [Parameter(Mandatory = $true)][string]$Category,
    [Parameter(Mandatory = $true)][string]$Slug,
    [string]$Title = "New Runbook Note"
)

$RootPath = Split-Path -Parent $PSScriptRoot
$TargetDir = Join-Path $RootPath "docs\$Category"
$TargetFile = Join-Path $TargetDir "$Slug.md"

if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

if (Test-Path $TargetFile) {
    Write-Host "File already exists: $TargetFile" -ForegroundColor Yellow
    exit 1
}

$Content = @"
# $Title

## When to use

Describe when this note is useful.

## Error message

````bash
paste error here
````

## Root cause

Explain the reason shortly.

## Fix

````bash
command here
````

## Verify

````bash
command here
````

## Tags

``$Category``, ``$Slug``
"@

$utf8NoBom = New-Object System.Text.UTF8Encoding -ArgumentList $false
[System.IO.File]::WriteAllText($TargetFile, $Content, $utf8NoBom)
Write-Host "Created: $TargetFile" -ForegroundColor Green