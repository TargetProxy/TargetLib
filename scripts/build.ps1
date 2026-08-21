<#
.SYNOPSIS
Builds the standalone Desktop TargetLib gRPC daemon.

.EXAMPLE
.\scripts\build.ps1

.EXAMPLE
.\scripts\build.ps1 -OutputPath dist\targetlibd.exe -DebugBuild
#>
[CmdletBinding()]
param(
    [string]$OutputPath,

    [string[]]$BuildTags = @(
        'with_gvisor',
        'with_quic',
        'with_wireguard',
        'with_utls',
        'with_naive_outbound',
        'with_purego',
        'with_clash_api',
        'badlinkname',
        'http2legacy',
        'netgo',
        'osusergo'
    ),

    [switch]$DebugBuild
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$goCommand = Get-Command go -ErrorAction Stop

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $extension = if ($env:OS -eq 'Windows_NT') { '.exe' } else { '' }
    $OutputPath = Join-Path $repositoryRoot "build\targetlibd$extension"
} elseif (-not [System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath = Join-Path $repositoryRoot $OutputPath
}
$OutputPath = [System.IO.Path]::GetFullPath($OutputPath)
$outputDirectory = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

$arguments = @(
    'build',
    '-trimpath',
    '-buildvcs=false',
    '-pgo=auto',
    '-tags', ($BuildTags -join ','),
    '-o', $OutputPath
)
$linkerFlags = if ($DebugBuild) { '-checklinkname=0' } else { '-s -w -buildid= -checklinkname=0' }
$arguments += @('-ldflags', $linkerFlags)
$arguments += './cmd/targetlibd'

# Strip + perf env (no priority, apply directly)
if (-not $DebugBuild) {
    $env:CGO_ENABLED = '0'
    if ($env:GOARCH -eq 'amd64' -or [string]::IsNullOrWhiteSpace($env:GOARCH)) {
        $env:GOAMD64 = 'v3'
    }
}

Push-Location $repositoryRoot
try {
    & $goCommand.Source @arguments
    if ($LASTEXITCODE -ne 0) {
        throw "go build failed with exit code $LASTEXITCODE"
    }
} finally {
    Pop-Location
}

if (-not (Test-Path -LiteralPath $OutputPath)) {
    throw "Build completed without creating $OutputPath"
}
Write-Host "Built $OutputPath"
