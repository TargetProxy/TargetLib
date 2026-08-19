<#
.SYNOPSIS
Builds the Windows libbox native library.

.EXAMPLE
.\scripts\build.ps1

.EXAMPLE
.\scripts\build.ps1 -BuildMode c-archive -OutputPath dist\libbox.a `
  -Compiler C:\msys64\ucrt64\bin\gcc.exe

.DESCRIPTION
Builds the Go C ABI using the feature tags required by sing-box. The default
output is build\libbox.dll; Go also writes build\libbox.h beside it.
Use a GCC or Clang toolchain matching the target architecture. MSYS2 UCRT64
GCC is the supported Windows setup for the default amd64 target.
#>
[CmdletBinding()]
param(
    [ValidateSet('c-shared', 'c-archive')]
    [string]$BuildMode = 'c-shared',

    [string]$OutputPath,

    [Alias('CC')]
    [string]$Compiler,

    [string[]]$BuildTags = @(
        'with_gvisor',
        'with_quic',
        'with_wireguard',
        'with_utls',
        'with_naive_outbound',
        'with_purego',
        'with_clash_api',
        'badlinkname',
        'tfogo_checklinkname0'
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

$outputDirectory = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

if ([string]::IsNullOrWhiteSpace($Compiler)) {
    $Compiler = $env:CC
}
if ([string]::IsNullOrWhiteSpace($Compiler)) {
    foreach ($candidate in @('gcc', 'clang')) {
        $candidateCommand = Get-Command $candidate -ErrorAction SilentlyContinue
        if ($null -ne $candidateCommand) {
            $Compiler = $candidateCommand.Source
            break
        }
    }
}
if ([string]::IsNullOrWhiteSpace($Compiler)) {
    throw @"
No C compiler was found. Install MSYS2 UCRT64 GCC or LLVM Clang, then add it to PATH,
or invoke this script with -Compiler C:\path\to\gcc.exe.
"@
}

if ([System.IO.Path]::IsPathRooted($Compiler) -and -not (Test-Path -LiteralPath $Compiler)) {
    throw "The specified C compiler does not exist: $Compiler"
}
if (-not [System.IO.Path]::IsPathRooted($Compiler)) {
    $compilerCommand = Get-Command $Compiler -ErrorAction SilentlyContinue
    if ($null -eq $compilerCommand) {
        throw "The specified C compiler is not available on PATH: $Compiler"
    }
    $Compiler = $compilerCommand.Source
}

$previousCgoEnabled = $env:CGO_ENABLED
$previousCompiler = $env:CC
try {
    $env:CGO_ENABLED = '1'
    $env:CC = $Compiler

    $goOS = (& $goCommand.Source env GOOS).Trim()
    if ($goOS -ne 'windows') {
        throw "This script builds Windows artifacts only; GOOS is currently '$goOS'."
    }

    $arguments = @(
        'build',
        '-trimpath',
        '-buildvcs=false',
        "-buildmode=$BuildMode",
        '-tags', ($BuildTags -join ','),
        '-o', $OutputPath
    )
    if (-not $DebugBuild) {
        $arguments += @('-ldflags', '-s -w -buildid= -checklinkname=0')
    }
    $arguments += '.'

    Write-Host "Building $BuildMode artifact: $OutputPath"
    Write-Host "Using C compiler: $Compiler"
    Push-Location $repositoryRoot
    try {
        & $goCommand.Source @arguments
        if ($LASTEXITCODE -ne 0) {
            throw "go build failed with exit code $LASTEXITCODE"
        }
    } finally {
        Pop-Location
    }
} finally {
    $env:CGO_ENABLED = $previousCgoEnabled
    $env:CC = $previousCompiler
}

if (-not (Test-Path -LiteralPath $OutputPath)) {
    throw "Build completed without creating $OutputPath"
}

Write-Host "Built $OutputPath"
if ($BuildMode -eq 'c-shared') {
    $headerPath = [System.IO.Path]::ChangeExtension($OutputPath, '.h')
    if (-not (Test-Path -LiteralPath $headerPath)) {
        throw "Build completed without creating the cgo header $headerPath"
    }
    Write-Host "Generated C header: $headerPath"
}
