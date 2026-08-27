<#
.SYNOPSIS
Builds the TargetLib gRPC service.

.EXAMPLE
.\scripts\service.ps1
.\scripts\service.ps1 -GOOS linux -GOARCH amd64
.\scripts\service.ps1 -DebugBuild -OutputPath build\TargetLib.exe
#>
[CmdletBinding()]
param(
    [string]$OutputPath,
    [string]$GOOS,
    [string]$GOARCH,
    [switch]$DebugBuild
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$configuration = Import-PowerShellDataFile (Join-Path $PSScriptRoot 'build-config.psd1')
$goCommand = Get-Command go -ErrorAction Stop
$targetGOOS = if ($GOOS) { $GOOS } elseif ($env:GOOS) { $env:GOOS } else { & $goCommand.Source env GOOS }
$targetGOARCH = if ($GOARCH) { $GOARCH } elseif ($env:GOARCH) { $env:GOARCH } else { & $goCommand.Source env GOARCH }

if (-not $OutputPath) {
    $fileName = if ($targetGOOS -eq 'windows') { 'TargetLib.exe' } else { 'TargetLib' }
    $OutputPath = Join-Path $repositoryRoot "build\service\$targetGOOS-$targetGOARCH\$fileName"
} elseif (-not [System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath = Join-Path $repositoryRoot $OutputPath
}
$OutputPath = [System.IO.Path]::GetFullPath($OutputPath)
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutputPath) | Out-Null

$linkerFlags = if ($DebugBuild) { '-checklinkname=0' } else { '-s -w -buildid= -checklinkname=0' }
$arguments = @(
    'build'
    '-trimpath'
    '-buildvcs=false'
    '-pgo=auto'
    '-tags', ($configuration.BuildTags -join ',')
    '-ldflags', $linkerFlags
    '-o', $OutputPath
    './cmd/TargetLib'
)

$previousEnvironment = @{}
foreach ($name in @('GOOS', 'GOARCH', 'CGO_ENABLED')) {
    $previousEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
}
try {
    $env:GOOS = $targetGOOS
    $env:GOARCH = $targetGOARCH
    $env:CGO_ENABLED = '0'
    Push-Location $repositoryRoot
    try {
        & $goCommand.Source @arguments
        if ($LASTEXITCODE -ne 0) { throw "go build failed with exit code $LASTEXITCODE" }
    } finally {
        Pop-Location
    }
} finally {
    foreach ($name in $previousEnvironment.Keys) {
        if ($null -eq $previousEnvironment[$name]) {
            Remove-Item "env:$name" -ErrorAction SilentlyContinue
        } else {
            [Environment]::SetEnvironmentVariable($name, $previousEnvironment[$name])
        }
    }
}

if (-not (Test-Path -LiteralPath $OutputPath)) { throw "Build did not create $OutputPath" }
Write-Host "Built $OutputPath" -ForegroundColor Green
