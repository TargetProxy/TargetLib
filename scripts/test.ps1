<#
.SYNOPSIS
Runs static checks and tests for the Go core (and optionally the Flutter plugin).

.DESCRIPTION
Runs `go vet ./...` followed by `go test ./...` from the repository root.
Tests must use the same sing-box build tags as service.ps1: without
`http2legacy` the v2rayhttp transport fails to link, and without
`-checklinkname=0` the Go 1.24+ linker rejects sing-box's http2 linkname hook.

Pass -Short to skip long-running tests. Pass -Flutter to also run the Dart
unit tests inside flutter/ (requires a Flutter SDK).

.EXAMPLE
.\scripts\test.ps1
.\scripts\test.ps1 -Short
.\scripts\test.ps1 -Flutter
#>
[CmdletBinding()]
param(
    [switch]$Short,

    [switch]$Flutter,

    [string[]]$BuildTags
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$goCommand = Get-Command go -ErrorAction Stop
if (-not $BuildTags) {
    $configuration = Import-PowerShellDataFile (Join-Path $PSScriptRoot 'build-config.psd1')
    $BuildTags = $configuration.BuildTags
}

Push-Location $repositoryRoot
try {
    Write-Host '==> go vet ./...' -ForegroundColor Cyan
    & $goCommand.Source vet ./...
    if ($LASTEXITCODE -ne 0) {
        throw "go vet failed with exit code $LASTEXITCODE"
    }

    Write-Host '==> go test ./...' -ForegroundColor Cyan
    # Same tags as service.ps1 (http2legacy is required to link v2rayhttp)
    # plus -checklinkname=0 for sing-box's http2 linkname hook.
    $testArguments = @('test', '-tags', ($BuildTags -join ','), '-ldflags', '-checklinkname=0', './...')
    if ($Short) {
        $testArguments += @('-short', '-count=1')
    }
    & $goCommand.Source @testArguments
    if ($LASTEXITCODE -ne 0) {
        throw "go test failed with exit code $LASTEXITCODE"
    }
} finally {
    Pop-Location
}

if ($Flutter) {
    $flutterCommand = Get-Command flutter -ErrorAction Stop
    $flutterRoot = Join-Path $repositoryRoot 'flutter'
    Push-Location $flutterRoot
    try {
        Write-Host '==> flutter test' -ForegroundColor Cyan
        & $flutterCommand.Source test
        if ($LASTEXITCODE -ne 0) {
            throw "flutter test failed with exit code $LASTEXITCODE"
        }
    } finally {
        Pop-Location
    }
}

Write-Host 'All checks passed.' -ForegroundColor Green
