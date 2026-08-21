<#
.SYNOPSIS
Builds the libbox C ABI from ffi/native.

.EXAMPLE
.\scripts\build-native.ps1

.EXAMPLE
.\scripts\build-native.ps1 -BuildMode c-archive -OutputPath dist\libbox.a
#>
[CmdletBinding()]
param(
    [ValidateSet('c-shared', 'c-archive')]
    [string]$BuildMode = 'c-shared',

    [string]$OutputPath,

    [string[]]$BuildTags = @(
        'with_gvisor',
        'with_quic',
        'with_wireguard',
        'with_utls',
        'with_naive_outbound',
        'with_purego',
        'with_clash_api',
        'badlinkname'
    ),

    [switch]$DebugBuild
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$goCommand = Get-Command go -ErrorAction Stop

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $extension = if ($BuildMode -eq 'c-shared') { '.dll' } else { '.a' }
    $OutputPath = Join-Path $repositoryRoot "build\libbox$extension"
} elseif (-not [System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath = Join-Path $repositoryRoot $OutputPath
}
$OutputPath = [System.IO.Path]::GetFullPath($OutputPath)
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutputPath) | Out-Null

$arguments = @(
    'build',
    '-trimpath',
    '-buildvcs=false',
    "-buildmode=$BuildMode",
    '-tags', ($BuildTags -join ','),
    '-o', $OutputPath
)
$linkerFlags = if ($DebugBuild) { '-checklinkname=0' } else { '-s -w -buildid= -checklinkname=0' }
$arguments += @('-ldflags', $linkerFlags)
$arguments += './ffi/native'

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
