<#
.SYNOPSIS
Generates Go and Dart protobuf sources from api/TargetLib/targetlib.proto.

.EXAMPLE
.\scripts\generate.ps1
.\scripts\generate.ps1 -Language Go
#>
[CmdletBinding()]
param(
    [ValidateSet('All', 'Go', 'Dart')]
    [string]$Language = 'All'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$protoPath = 'api/TargetLib/targetlib.proto'
$protoc = Get-Command protoc -ErrorAction Stop

Push-Location $repositoryRoot
try {
    if ($Language -in @('All', 'Go')) {
        Get-Command protoc-gen-go -ErrorAction Stop | Out-Null
        Get-Command protoc-gen-go-grpc -ErrorAction Stop | Out-Null
        Write-Host 'Generating Go protobuf sources...' -ForegroundColor Cyan
        & $protoc.Source --proto_path=. --go_out=. --go_opt=paths=source_relative `
            --go-grpc_out=. --go-grpc_opt=paths=source_relative $protoPath
        if ($LASTEXITCODE -ne 0) { throw "Go protobuf generation failed with exit code $LASTEXITCODE" }
    }

    if ($Language -in @('All', 'Dart')) {
        $dartPlugin = Get-Command protoc-gen-dart -ErrorAction SilentlyContinue
        if (-not $dartPlugin) {
            $userProfile = [Environment]::GetFolderPath('UserProfile')
            $pluginName = if ($env:OS -eq 'Windows_NT') { 'protoc-gen-dart.bat' } else { 'protoc-gen-dart' }
            $pluginCandidates = @((Join-Path $userProfile ".pub-cache\bin\$pluginName"))
            if ($env:LOCALAPPDATA) {
                $pluginCandidates += (Join-Path $env:LOCALAPPDATA "Pub\Cache\bin\$pluginName")
            }
            $dartPluginPath = $pluginCandidates |
                Where-Object { Test-Path -LiteralPath $_ } |
                Select-Object -First 1
            if (-not $dartPluginPath) {
                throw 'protoc-gen-dart was not found. Install it with: dart pub global activate protoc_plugin'
            }
        } else {
            $dartPluginPath = $dartPlugin.Source
        }

        $dartOutput = Join-Path $repositoryRoot 'flutter\lib\src\generated'
        New-Item -ItemType Directory -Force -Path $dartOutput | Out-Null
        Write-Host 'Generating Dart protobuf sources...' -ForegroundColor Cyan
        & $protoc.Source --proto_path=. "--plugin=protoc-gen-dart=$dartPluginPath" `
            "--dart_out=grpc:$dartOutput" $protoPath
        if ($LASTEXITCODE -ne 0) { throw "Dart protobuf generation failed with exit code $LASTEXITCODE" }
    }
} finally {
    Pop-Location
}

Write-Host 'Generation completed.' -ForegroundColor Green
