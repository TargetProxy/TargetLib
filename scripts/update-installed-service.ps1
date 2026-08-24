<#
.SYNOPSIS
Updates the TargetLib binary used by the installed Windows service.

.DESCRIPTION
Run this script from an elevated PowerShell after building TargetLib. It stops
the existing service, replaces its managed executable, and starts it again.

.EXAMPLE
.\scripts\update-installed-service.ps1
#>
[CmdletBinding()]
param(
    [string]$SourcePath,

    [string]$InstallPath,

    [string]$ServiceName = 'TargetLib'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($env:OS -ne 'Windows_NT') {
    throw 'This script only supports Windows services.'
}

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Administrator privileges are required. Open PowerShell as administrator and run this script again.'
}

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
if ([string]::IsNullOrWhiteSpace($SourcePath)) {
    $SourcePath = Join-Path $repositoryRoot 'build\TargetLib.exe'
} elseif (-not [System.IO.Path]::IsPathRooted($SourcePath)) {
    $SourcePath = Join-Path $repositoryRoot $SourcePath
}
$SourcePath = [System.IO.Path]::GetFullPath($SourcePath)

$service = Get-Service -Name $ServiceName -ErrorAction Stop
if ([string]::IsNullOrWhiteSpace($InstallPath)) {
    $serviceKey = "HKLM:\SYSTEM\CurrentControlSet\Services\$ServiceName"
    $imagePath = (Get-ItemProperty -LiteralPath $serviceKey -Name ImagePath).ImagePath
    $pathMatch = [regex]::Match(
        $imagePath,
        '^\s*(?:"([^"]+\.exe)"|(.+?\.exe))(?:\s|$)',
        [Text.RegularExpressions.RegexOptions]::IgnoreCase
    )
    if (-not $pathMatch.Success) {
        throw "Unable to resolve the executable from service ImagePath: $imagePath"
    }
    $InstallPath = if ($pathMatch.Groups[1].Success) {
        $pathMatch.Groups[1].Value
    } else {
        $pathMatch.Groups[2].Value
    }
} elseif (-not [System.IO.Path]::IsPathRooted($InstallPath)) {
    $InstallPath = Join-Path $repositoryRoot $InstallPath
}
$InstallPath = [System.IO.Path]::GetFullPath($InstallPath)

if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
    throw "Built TargetLib executable not found: $SourcePath"
}

$wasRunning = $service.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Stopped
if ($wasRunning) {
    Stop-Service -Name $ServiceName -Force
    $service.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Stopped, [TimeSpan]::FromSeconds(15))
}

$installDirectory = Split-Path -Parent $InstallPath
New-Item -ItemType Directory -Force -Path $installDirectory | Out-Null
Copy-Item -LiteralPath $SourcePath -Destination $InstallPath -Force

# Force the desktop app to recompute its source stamp on the next reinstall.
$stampPath = "$InstallPath.version"
if (Test-Path -LiteralPath $stampPath) {
    Remove-Item -LiteralPath $stampPath -Force
}

if ($wasRunning) {
    Start-Service -Name $ServiceName
    $service.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Running, [TimeSpan]::FromSeconds(15))
}

$hash = (Get-FileHash -LiteralPath $InstallPath -Algorithm SHA256).Hash
Write-Host "Updated $InstallPath"
Write-Host "SHA256 $hash"
