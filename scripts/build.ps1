<##
.SYNOPSIS
Builds the TargetLib service for the host platform.

.DESCRIPTION
This is the CI and release entry point for TargetLib. The implementation lives
in service.ps1 so local service packaging and CI builds use the same flags,
build tags, rule-set staging, and output validation.

.PARAMETER OutputPath
Path of the generated executable. Relative paths are resolved from the
TargetLib repository root.

.PARAMETER SkipTargetSync
Retained for compatibility with older CI callers. TargetLib is now built from
the checked-out source, so there is no separate target synchronization step.

.EXAMPLE
.\scripts\build.ps1 -OutputPath build\TargetLib.exe -SkipTargetSync
#>
[CmdletBinding()]
param(
    [string]$OutputPath,
    [switch]$SkipTargetSync
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$serviceScript = Join-Path $PSScriptRoot 'service.ps1'
if (-not (Test-Path -LiteralPath $serviceScript -PathType Leaf)) {
    throw "TargetLib build implementation not found: $serviceScript"
}

if (-not $OutputPath) {
    $go = Get-Command go -ErrorAction Stop
    $goos = (& $go.Source env GOOS).Trim()
    $goarch = (& $go.Source env GOARCH).Trim()
    $fileName = if ($goos -eq 'windows') { 'TargetLib.exe' } else { 'TargetLib' }
    $OutputPath = Join-Path $repositoryRoot "build\$fileName"
}

$serviceArguments = @{}
if ($OutputPath) { $serviceArguments.OutputPath = $OutputPath }
& $serviceScript @serviceArguments
if ($LASTEXITCODE -ne 0) {
    throw "TargetLib service build failed with exit code $LASTEXITCODE"
}

Write-Host 'TargetLib build completed.' -ForegroundColor Green
