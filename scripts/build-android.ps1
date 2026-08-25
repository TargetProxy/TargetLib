<#
.SYNOPSIS
Builds the Android Go C-shared library and its small JNI adapter without gomobile.

.EXAMPLE
.\scripts\build-android.ps1 -NdkPath "$env:LOCALAPPDATA\Android\Sdk\ndk\27.2.12479018"
#>
[CmdletBinding()]
param(
    [string]$NdkPath,
    [int]$AndroidApi = 24,
    [string]$OutputRoot,
    [string[]]$Abis = @('arm64-v8a', 'x86_64'),
    [string[]]$BuildTags = @(
        'with_gvisor', 'with_quic', 'with_wireguard', 'with_utls',
        'with_naive_outbound', 'with_purego', 'with_clash_api',
        'badlinkname', 'http2legacy', 'netgo', 'osusergo'
    ),
    [switch]$DebugBuild
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$go = (Get-Command go -ErrorAction Stop).Source
if ([string]::IsNullOrWhiteSpace($NdkPath)) {
    $sdk = if ($env:ANDROID_HOME) { $env:ANDROID_HOME } else { $env:ANDROID_SDK_ROOT }
    if ($sdk) {
        $ndkRoot = Join-Path $sdk 'ndk'
        if (Test-Path $ndkRoot) {
            $NdkPath = (Get-ChildItem $ndkRoot -Directory | Sort-Object Name -Descending | Select-Object -First 1).FullName
        }
    }
}
if ([string]::IsNullOrWhiteSpace($NdkPath) -or -not (Test-Path $NdkPath)) {
    throw 'Android NDK not found. Pass -NdkPath or set ANDROID_HOME/ANDROID_SDK_ROOT.'
}
$NdkPath = [System.IO.Path]::GetFullPath($NdkPath)
$hostTag = if ($env:OS -eq 'Windows_NT') { 'windows-x86_64' } elseif ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX)) { 'darwin-x86_64' } else { 'linux-x86_64' }
$toolchain = Join-Path $NdkPath "toolchains\llvm\prebuilt\$hostTag"
$sysroot = Join-Path $toolchain 'sysroot'
if (-not (Test-Path $sysroot)) { throw "Invalid Android NDK: $toolchain" }
function Find-NdkTool([string]$name) {
    foreach ($suffix in @('.cmd', '.exe', '')) {
        $candidate = Join-Path $toolchain "bin\$name$suffix"
        if (Test-Path $candidate) { return $candidate }
    }
    throw "NDK tool not found: $name"
}
if ([string]::IsNullOrWhiteSpace($OutputRoot)) {
    $OutputRoot = Join-Path $root 'flutter\android\src\main\jniLibs'
} elseif (-not [System.IO.Path]::IsPathRooted($OutputRoot)) {
    $OutputRoot = Join-Path $root $OutputRoot
}
$OutputRoot = [System.IO.Path]::GetFullPath($OutputRoot)

$targets = @{
    'arm64-v8a' = @{ GoArch = 'arm64'; GoArm = ''; Triple = 'aarch64-linux-android' }
    'armeabi-v7a' = @{ GoArch = 'arm'; GoArm = '7'; Triple = 'armv7a-linux-androideabi' }
    'x86_64' = @{ GoArch = 'amd64'; GoArm = ''; Triple = 'x86_64-linux-android' }
    'x86' = @{ GoArch = '386'; GoArm = ''; Triple = 'i686-linux-android' }
}
$old = @($env:GOOS, $env:GOARCH, $env:GOARM, $env:CGO_ENABLED, $env:CC)
try {
    foreach ($abi in $Abis) {
        if (-not $targets.ContainsKey($abi)) { throw "Unsupported Android ABI: $abi" }
        $target = $targets[$abi]
        $abiDir = Join-Path $OutputRoot $abi
        New-Item -ItemType Directory -Force -Path $abiDir | Out-Null
        $triple = $target.Triple
        $cc = Find-NdkTool "${triple}${AndroidApi}-clang"
        $cxx = Find-NdkTool "${triple}${AndroidApi}-clang++"

        $env:GOOS = 'android'; $env:GOARCH = $target.GoArch; $env:GOARM = $target.GoArm
        $env:CGO_ENABLED = '1'; $env:CC = $cc
        $goArgs = @('build', '-trimpath', '-buildvcs=false', "-buildmode=c-shared", '-tags', ($BuildTags -join ','), '-o', (Join-Path $abiDir 'libtargetlib.so'))
        $goArgs += @('-ldflags', $(if ($DebugBuild) { '-checklinkname=0' } else { '-s -w -buildid= -checklinkname=0' }), './ffi/native')
        Push-Location $root
        try { & $go @goArgs; if ($LASTEXITCODE -ne 0) { throw "Go Android build failed for $abi" } }
        finally { Pop-Location }
        $generatedHeader = Join-Path $abiDir 'libtargetlib.h'
        if (Test-Path $generatedHeader) { Remove-Item -LiteralPath $generatedHeader -Force }

        & $cxx '-shared' '-fPIC' '-std=c++17' '-O2' '-static-libstdc++' '-I' (Join-Path $sysroot 'usr\include') '-I' (Join-Path $sysroot "usr\include\$triple") (Join-Path $root 'flutter\android\src\main\cpp\targetlib_jni.cpp') '-L' $abiDir '-ltargetlib' '-Wl,-soname,libtargetlib_jni.so' '-o' (Join-Path $abiDir 'libtargetlib_jni.so')
        if ($LASTEXITCODE -ne 0) { throw "JNI build failed for $abi" }
        Write-Host "Built Android ${abi}: $abiDir"
    }
}
finally {
    $env:GOOS = $old[0]; $env:GOARCH = $old[1]; $env:GOARM = $old[2]; $env:CGO_ENABLED = $old[3]; $env:CC = $old[4]
}
