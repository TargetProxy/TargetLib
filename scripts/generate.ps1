[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$goPath = (& go env GOPATH).Trim()
$env:PATH = "$(Join-Path $goPath 'bin');$env:PATH"

Push-Location $repositoryRoot
try {
    protoc -I . `
        --go_out=. --go_opt=paths=source_relative `
        --go-grpc_out=. --go-grpc_opt=paths=source_relative `
        api/TargetLib/targetlib.proto
    if ($LASTEXITCODE -ne 0) {
        throw "protoc failed with exit code $LASTEXITCODE"
    }
} finally {
    Pop-Location
}
