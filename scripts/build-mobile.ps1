<#
.SYNOPSIS
Builds the Android native libraries consumed by the Flutter plugin.

.DESCRIPTION
Builds the Go shared library and JNI bridge for every selected ABI. All ABIs
are staged before the output directory is updated. Generated native artifacts
are intentionally ignored by Git.

.EXAMPLE
.\scripts\build-mobile.ps1
.\scripts\build-mobile.ps1 -ABIs arm64-v8a
.\scripts\build-mobile.ps1 -OutputDir build\mobile\android
#>
[CmdletBinding()]
param(
    [ValidateSet('arm64-v8a', 'x86_64')]
    [string[]]$ABIs = @('arm64-v8a', 'x86_64'),
    [string]$NDKRoot,
    [string]$OutputDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$configuration = Import-PowerShellDataFile (Join-Path $PSScriptRoot 'build-config.psd1')
$goCommand = Get-Command go -ErrorAction Stop
$cppSource = Join-Path $repositoryRoot 'flutter\android\src\main\cpp\targetlib_jni.cpp'

$ndkCandidates = @()
if ($NDKRoot) { $ndkCandidates += $NDKRoot }
if ($env:ANDROID_NDK_ROOT) { $ndkCandidates += $env:ANDROID_NDK_ROOT }
if ($env:ANDROID_HOME) { $ndkCandidates += (Join-Path $env:ANDROID_HOME 'ndk') }
if ($env:LOCALAPPDATA) { $ndkCandidates += (Join-Path $env:LOCALAPPDATA 'Android\Sdk\ndk') }

$ndk = $null
foreach ($candidate in $ndkCandidates) {
    if (-not (Test-Path -LiteralPath $candidate)) { continue }
    if (Test-Path -LiteralPath (Join-Path $candidate 'toolchains')) {
        $ndk = $candidate
    } else {
        $ndk = Get-ChildItem -LiteralPath $candidate -Directory -ErrorAction SilentlyContinue |
            Sort-Object Name -Descending |
            Select-Object -First 1 -ExpandProperty FullName
    }
    if ($ndk) { break }
}
if (-not $ndk -or -not (Test-Path -LiteralPath (Join-Path $ndk 'toolchains'))) {
    throw 'A valid Android NDK is required. Pass -NDKRoot or set ANDROID_NDK_ROOT/ANDROID_HOME.'
}

$hostGOOS = & $goCommand.Source env GOOS
$hostGOARCH = & $goCommand.Source env GOARCH
if ($hostGOOS -eq 'windows') { $hostDirectory = 'windows-x86_64' }
elseif ($hostGOOS -eq 'darwin' -and $hostGOARCH -eq 'arm64') { $hostDirectory = 'darwin-arm64' }
elseif ($hostGOOS -eq 'darwin') { $hostDirectory = 'darwin-x86_64' }
else { $hostDirectory = 'linux-x86_64' }

$prebuilt = Join-Path $ndk "toolchains\llvm\prebuilt\$hostDirectory"
$executableSuffix = if ($hostGOOS -eq 'windows') { '.exe' } else { '' }
$clang = Join-Path $prebuilt "bin\clang$executableSuffix"
$clangxx = Join-Path $prebuilt "bin\clang++$executableSuffix"
$jniInclude = Join-Path $prebuilt 'sysroot\usr\include'
foreach ($requiredPath in @($clang, $clangxx, (Join-Path $jniInclude 'jni.h'))) {
    if (-not (Test-Path -LiteralPath $requiredPath)) { throw "Android toolchain file not found: $requiredPath" }
}

if (-not $OutputDir) {
    $OutputDir = Join-Path $repositoryRoot 'flutter\android\src\main\jniLibs'
} elseif (-not [System.IO.Path]::IsPathRooted($OutputDir)) {
    $OutputDir = Join-Path $repositoryRoot $OutputDir
}
$OutputDir = [System.IO.Path]::GetFullPath($OutputDir)

$stagingRoot = Join-Path ([System.IO.Path]::GetTempPath()) "targetlib-mobile-$([guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Force -Path $stagingRoot | Out-Null
$previousEnvironment = @{}
foreach ($name in @('GOOS', 'GOARCH', 'CGO_ENABLED', 'CC', 'CXX')) {
    $previousEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
}

try {
    foreach ($abi in $ABIs) {
        $goarch = if ($abi -eq 'arm64-v8a') { 'arm64' } else { 'amd64' }
        $triple = if ($abi -eq 'arm64-v8a') { 'aarch64-linux-android' } else { 'x86_64-linux-android' }
        $compilerTarget = "$triple$($configuration.AndroidApiLevel)"
        $abiStaging = Join-Path $stagingRoot $abi
        $coreOutput = Join-Path $abiStaging 'libtargetlib.so'
        $jniOutput = Join-Path $abiStaging 'libtargetlib_jni.so'
        New-Item -ItemType Directory -Force -Path $abiStaging | Out-Null

        Write-Host "Building Android core for $abi..." -ForegroundColor Cyan
        $env:GOOS = 'android'
        $env:GOARCH = $goarch
        $env:CGO_ENABLED = '1'
        $env:CC = "$clang --target=$compilerTarget"
        $env:CXX = "$clangxx --target=$compilerTarget"
        $goArguments = @(
            'build', '-trimpath', '-buildvcs=false', '-pgo=auto'
            '-tags', ($configuration.BuildTags -join ',')
            '-buildmode', 'c-shared'
            '-ldflags', '-s -w -buildid= -checklinkname=0'
            '-o', $coreOutput
            './ffi/native'
        )
        Push-Location $repositoryRoot
        try {
            & $goCommand.Source @goArguments
            if ($LASTEXITCODE -ne 0) { throw "Go mobile build failed for $abi with exit code $LASTEXITCODE" }
        } finally {
            Pop-Location
        }

        Write-Host "Building JNI bridge for $abi..." -ForegroundColor Cyan
        & $clangxx --target=$compilerTarget -shared -fPIC -std=c++17 -I $jniInclude `
            -o $jniOutput $cppSource -L $abiStaging -ltargetlib
        if ($LASTEXITCODE -ne 0) { throw "JNI build failed for $abi with exit code $LASTEXITCODE" }
        foreach ($artifact in @($coreOutput, $jniOutput)) {
            if (-not (Test-Path -LiteralPath $artifact)) { throw "Build did not create $artifact" }
        }
    }

    foreach ($abi in $ABIs) {
        $targetDirectory = Join-Path $OutputDir $abi
        New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null
        Copy-Item -LiteralPath (Join-Path $stagingRoot "$abi\libtargetlib.so") -Destination $targetDirectory -Force
        Copy-Item -LiteralPath (Join-Path $stagingRoot "$abi\libtargetlib_jni.so") -Destination $targetDirectory -Force
        Write-Host "Built $targetDirectory" -ForegroundColor Green
    }
} finally {
    foreach ($name in $previousEnvironment.Keys) {
        if ($null -eq $previousEnvironment[$name]) {
            Remove-Item "env:$name" -ErrorAction SilentlyContinue
        } else {
            [Environment]::SetEnvironmentVariable($name, $previousEnvironment[$name])
        }
    }
    Remove-Item -LiteralPath $stagingRoot -Recurse -Force -ErrorAction SilentlyContinue
}
