<#
.SYNOPSIS
Builds and reinstalls the TargetLib Windows service.

.DESCRIPTION
Builds TargetLib.exe, requests elevation, replaces the registered binary,
reinstalls the service, starts it, and verifies its state. Supported arguments
are migrated from an existing service; obsolete arguments are reported and removed.

.EXAMPLE
.\scripts\reinstall-service.ps1

.EXAMPLE
.\scripts\reinstall-service.ps1 -WhatIf

.EXAMPLE
.\scripts\reinstall-service.ps1 -SkipBuild -NoStart
#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
param(
    [string]$SourcePath,
    [string]$InstallPath,
    [string]$BasePath,
    [string]$WorkingPath,
    [string]$TempPath,
    [string]$Locale,
    [int]$LogMaxLines,
    [switch]$RuntimeDebug,
    [switch]$NoRuntimeDebug,
    [switch]$DebugBuild,
    [switch]$SkipBuild,
    [switch]$NoStart,
    [switch]$KeepBackup,
    [ValidateRange(5, 300)]
    [int]$TimeoutSeconds = 30,
    [Parameter(DontShow)]
    [switch]$Elevated
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$serviceName = 'TargetLib'
$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))

function Resolve-RepositoryPath {
    param([string]$Path, [string]$DefaultPath)
    $value = if ([string]::IsNullOrWhiteSpace($Path)) { $DefaultPath } else { $Path }
    if (-not [System.IO.Path]::IsPathRooted($value)) {
        $value = Join-Path $repositoryRoot $value
    }
    return [System.IO.Path]::GetFullPath($value)
}

function Get-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Split-ServiceImagePath {
    param([string]$ImagePath)
    $match = [regex]::Match(
        $ImagePath,
        '^\s*(?:"(?<exe>[^"]+?\.exe)"|(?<exe>.+?\.exe))(?<args>\s.*)?$',
        [Text.RegularExpressions.RegexOptions]::IgnoreCase
    )
    if (-not $match.Success) {
        throw "Unable to parse service ImagePath: $ImagePath"
    }
    if (-not ('TargetLib.NativeCommandLine' -as [type])) {
        Add-Type -TypeDefinition @'
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
namespace TargetLib {
    public static class NativeCommandLine {
        [DllImport("shell32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        private static extern IntPtr CommandLineToArgvW(string commandLine, out int argc);
        [DllImport("kernel32.dll")]
        private static extern IntPtr LocalFree(IntPtr value);
        public static string[] Split(string commandLine) {
            int count;
            IntPtr pointer = CommandLineToArgvW(commandLine, out count);
            if (pointer == IntPtr.Zero) throw new Win32Exception();
            try {
                string[] values = new string[count];
                for (int i = 0; i < count; i++) {
                    values[i] = Marshal.PtrToStringUni(Marshal.ReadIntPtr(pointer, i * IntPtr.Size));
                }
                return values;
            } finally { LocalFree(pointer); }
        }
    }
}
'@ | Out-Null
    }
    $argumentText = $match.Groups['args'].Value
    $arguments = if ([string]::IsNullOrWhiteSpace($argumentText)) {
        @()
    } else {
        @([TargetLib.NativeCommandLine]::Split("placeholder.exe$argumentText") | Select-Object -Skip 1)
    }
    return [pscustomobject]@{
        Executable = [System.IO.Path]::GetFullPath($match.Groups['exe'].Value)
        Arguments  = $arguments
    }
}

function Get-OldOption {
    param([string[]]$Arguments, [string]$Name)
    for ($index = 0; $index -lt $Arguments.Count; $index++) {
        if ($Arguments[$index] -eq $Name -and $index + 1 -lt $Arguments.Count) {
            return $Arguments[$index + 1]
        }
        $prefix = "$Name="
        if ($Arguments[$index].StartsWith($prefix, [StringComparison]::Ordinal)) {
            return $Arguments[$index].Substring($prefix.Length)
        }
    }
    return $null
}

function Get-UnknownArguments {
    param([string[]]$Arguments)
    $valueOptions = @('--base-path', '--working-path', '--temp-path', '--locale', '--log-max-lines')
    $flagOptions = @('--debug')
    $unknown = [Collections.Generic.List[string]]::new()
    for ($index = 0; $index -lt $Arguments.Count; $index++) {
        $argument = $Arguments[$index]
        if ($flagOptions -contains $argument) { continue }
        $matchedValue = $false
        foreach ($option in $valueOptions) {
            if ($argument -eq $option) {
                if ($index + 1 -lt $Arguments.Count) { $index++ }
                $matchedValue = $true
                break
            }
            if ($argument.StartsWith("$option=", [StringComparison]::Ordinal)) {
                $matchedValue = $true
                break
            }
        }
        if (-not $matchedValue) { $unknown.Add($argument) }
    }
    return $unknown.ToArray()
}

function Wait-ServiceState {
    param(
        [string]$Name,
        [ServiceProcess.ServiceControllerStatus]$Status,
        [int]$Seconds
    )
    $service = Get-Service -Name $Name -ErrorAction Stop
    try {
        $service.WaitForStatus($Status, [TimeSpan]::FromSeconds($Seconds))
        $service.Refresh()
        if ($service.Status -ne $Status) {
            throw "Service $Name did not reach $Status within ${Seconds}s."
        }
    } finally {
        $service.Dispose()
    }
}

function Wait-ServiceRemoved {
    param([string]$Name, [int]$Seconds)
    $deadline = [DateTime]::UtcNow.AddSeconds($Seconds)
    do {
        $service = Get-Service -Name $Name -ErrorAction SilentlyContinue
        if (-not $service) { return }
        $service.Dispose()
        Start-Sleep -Milliseconds 200
    } while ([DateTime]::UtcNow -lt $deadline)
    throw "Service $Name was not removed within ${Seconds}s."
}

function Remove-RegisteredService {
    param([string]$Name, [int]$Seconds)
    $service = Get-Service -Name $Name -ErrorAction SilentlyContinue
    if (-not $service) { return }
    if ($service.Status -ne [ServiceProcess.ServiceControllerStatus]::Stopped) {
        Stop-Service -Name $Name -Force
        Wait-ServiceState -Name $Name -Status Stopped -Seconds $Seconds
    }
    $service.Dispose()
    & sc.exe delete $Name | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "sc.exe delete $Name failed with exit code $LASTEXITCODE."
    }
    Wait-ServiceRemoved -Name $Name -Seconds $Seconds
}

function Invoke-DaemonAction {
    param([string]$Executable, [string]$Action, [string[]]$Arguments)
    & $Executable $Action @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$Executable $Action failed with exit code $LASTEXITCODE."
    }
}

function Invoke-ElevatedScript {
    param([hashtable]$Parameters)
    $serialized = [Management.Automation.PSSerializer]::Serialize($Parameters)
    $payload = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($serialized))
    $scriptLiteral = $PSCommandPath.Replace("'", "''")
    $outputPath = Join-Path ([System.IO.Path]::GetTempPath()) "targetlib-reinstall-$PID-$([Guid]::NewGuid().ToString('N')).log"
    New-Item -ItemType File -Path $outputPath -Force | Out-Null
    $outputLiteral = $outputPath.Replace("'", "''")
    $command = @"
`$ErrorActionPreference = 'Stop'
try {
    `$xml = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('$payload'))
    `$parameters = [Management.Automation.PSSerializer]::Deserialize(`$xml)
    & '$scriptLiteral' @parameters *>&1 | Out-File -LiteralPath '$outputLiteral' -Encoding utf8
    exit 0
} catch {
    `$_ | Out-File -LiteralPath '$outputLiteral' -Encoding utf8 -Append
    exit 1
}
"@
    $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($command))
    try {
        $process = Start-Process -FilePath 'powershell.exe' -Verb RunAs -Wait -PassThru -WindowStyle Hidden -ArgumentList @(
            '-NoLogo', '-NoProfile', '-NonInteractive', '-ExecutionPolicy', 'Bypass', '-EncodedCommand', $encoded
        )
        $output = Get-Content -LiteralPath $outputPath -Raw -ErrorAction SilentlyContinue
        if (-not [string]::IsNullOrWhiteSpace($output)) {
            Write-Host $output.TrimEnd()
        }
    } finally {
        Remove-Item -LiteralPath $outputPath -Force -ErrorAction SilentlyContinue
    }
    if ($process.ExitCode -ne 0) {
        throw "Elevated reinstall failed or UAC was canceled (exit code $($process.ExitCode))."
    }
}

if ($env:OS -ne 'Windows_NT') { throw 'This script only supports Windows services.' }
if ($RuntimeDebug -and $NoRuntimeDebug) { throw '-RuntimeDebug and -NoRuntimeDebug cannot be combined.' }

$SourcePath = Resolve-RepositoryPath -Path $SourcePath -DefaultPath (Join-Path $repositoryRoot 'build\TargetLib.exe')
$registeredService = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
$oldServiceExisted = $null -ne $registeredService
$oldExecutable = $null
$oldArguments = @()
$oldWasRunning = $false
if ($registeredService) {
    $oldImage = (Get-ItemProperty -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\$serviceName" -Name ImagePath).ImagePath
    $parsedImage = Split-ServiceImagePath -ImagePath $oldImage
    $oldExecutable = $parsedImage.Executable
    $oldArguments = @($parsedImage.Arguments)
    $oldWasRunning = $registeredService.Status -ne [ServiceProcess.ServiceControllerStatus]::Stopped
    $registeredService.Dispose()
}

if ([string]::IsNullOrWhiteSpace($InstallPath)) {
    $InstallPath = if ($oldExecutable) { $oldExecutable } else { Join-Path $env:ProgramData 'TargetLib\bin\TargetLib.exe' }
} elseif (-not [System.IO.Path]::IsPathRooted($InstallPath)) {
    $InstallPath = Join-Path $repositoryRoot $InstallPath
}
$InstallPath = [System.IO.Path]::GetFullPath($InstallPath)

$oldBasePath = Get-OldOption -Arguments $oldArguments -Name '--base-path'
$oldWorkingPath = Get-OldOption -Arguments $oldArguments -Name '--working-path'
$oldTempPath = Get-OldOption -Arguments $oldArguments -Name '--temp-path'
$oldLocale = Get-OldOption -Arguments $oldArguments -Name '--locale'
$oldLogMaxLines = Get-OldOption -Arguments $oldArguments -Name '--log-max-lines'
$effectiveBasePath = if ($PSBoundParameters.ContainsKey('BasePath')) { $BasePath } elseif ($oldBasePath) { $oldBasePath } else { Join-Path $env:ProgramData 'TargetLib' }
$effectiveWorkingPath = if ($PSBoundParameters.ContainsKey('WorkingPath')) { $WorkingPath } elseif ($oldWorkingPath) { $oldWorkingPath } else { '' }
$effectiveTempPath = if ($PSBoundParameters.ContainsKey('TempPath')) { $TempPath } elseif ($oldTempPath) { $oldTempPath } else { '' }
$effectiveLocale = if ($PSBoundParameters.ContainsKey('Locale')) { $Locale } elseif ($oldLocale) { $oldLocale } else { '' }
$effectiveLogMaxLines = if ($PSBoundParameters.ContainsKey('LogMaxLines')) { $LogMaxLines } elseif ($oldLogMaxLines) { [int]$oldLogMaxLines } else { 300 }
$effectiveRuntimeDebug = if ($RuntimeDebug) { $true } elseif ($NoRuntimeDebug) { $false } else { $oldArguments -contains '--debug' }

if ([string]::IsNullOrWhiteSpace($effectiveBasePath)) { throw 'BasePath cannot be empty.' }
if ($effectiveLogMaxLines -lt 1) { throw 'LogMaxLines must be greater than zero.' }

$serviceArguments = [Collections.Generic.List[string]]::new()
$serviceArguments.Add('--base-path')
$serviceArguments.Add([System.IO.Path]::GetFullPath($effectiveBasePath))
$serviceArguments.Add('--log-max-lines')
$serviceArguments.Add($effectiveLogMaxLines.ToString([Globalization.CultureInfo]::InvariantCulture))
foreach ($option in @(
    @('--working-path', $effectiveWorkingPath),
    @('--temp-path', $effectiveTempPath),
    @('--locale', $effectiveLocale)
)) {
    if (-not [string]::IsNullOrWhiteSpace($option[1])) {
        $serviceArguments.Add($option[0])
        $serviceArguments.Add($option[1])
    }
}
if ($effectiveRuntimeDebug) { $serviceArguments.Add('--debug') }

$unknownArguments = @(Get-UnknownArguments -Arguments $oldArguments)
Write-Host 'TargetLib service reinstall plan' -ForegroundColor Cyan
Write-Host "  Build source: $SourcePath"
Write-Host "  Install path: $InstallPath"
Write-Host "  Service arguments: $($serviceArguments -join ' ')"
if ($unknownArguments.Count -gt 0) {
    Write-Warning "Removing obsolete service arguments: $($unknownArguments -join ' ')"
}

if (-not $SkipBuild -and $PSCmdlet.ShouldProcess($SourcePath, 'Build TargetLib daemon')) {
    $buildParameters = @{ OutputPath = $SourcePath; SkipTargetSync = $true }
    if ($DebugBuild) { $buildParameters.DebugBuild = $true }
    & (Join-Path $PSScriptRoot 'build.ps1') @buildParameters
}
if (-not $WhatIfPreference -and -not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
    throw "TargetLib executable not found: $SourcePath"
}

if (-not (Get-IsAdministrator)) {
    if ($WhatIfPreference) {
        Write-Host 'WhatIf: Request UAC elevation and reinstall the service.'
        return
    }
    if ($Elevated) { throw 'The elevated process does not have administrator privileges.' }
    $forward = @{
        SourcePath = $SourcePath; InstallPath = $InstallPath; BasePath = $effectiveBasePath
        WorkingPath = $effectiveWorkingPath; TempPath = $effectiveTempPath; Locale = $effectiveLocale
        LogMaxLines = $effectiveLogMaxLines; SkipBuild = $true; NoStart = [bool]$NoStart
        KeepBackup = [bool]$KeepBackup; TimeoutSeconds = $TimeoutSeconds; Elevated = $true
    }
    if ($effectiveRuntimeDebug) { $forward.RuntimeDebug = $true } else { $forward.NoRuntimeDebug = $true }
    Write-Host 'Requesting administrator privileges (one UAC prompt).' -ForegroundColor Yellow
    Invoke-ElevatedScript -Parameters $forward
    return
}

if (-not $PSCmdlet.ShouldProcess($serviceName, "Reinstall service using $InstallPath")) { return }

$installDirectory = Split-Path -Parent $InstallPath
$stagedPath = "$InstallPath.new-$PID"
$backupPath = "$InstallPath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$hadInstalledFile = Test-Path -LiteralPath $InstallPath -PathType Leaf
$backupCreated = $false
try {
    Remove-RegisteredService -Name $serviceName -Seconds $TimeoutSeconds
    New-Item -ItemType Directory -Force -Path $installDirectory | Out-Null
    Copy-Item -LiteralPath $SourcePath -Destination $stagedPath -Force
    if ($hadInstalledFile) {
        Move-Item -LiteralPath $InstallPath -Destination $backupPath -Force
        $backupCreated = $true
    }
    Move-Item -LiteralPath $stagedPath -Destination $InstallPath -Force
    $stampPath = "$InstallPath.version"
    if (Test-Path -LiteralPath $stampPath) { Remove-Item -LiteralPath $stampPath -Force }

    Invoke-DaemonAction -Executable $InstallPath -Action 'install' -Arguments $serviceArguments.ToArray()
    if (-not $NoStart) {
        Start-Service -Name $serviceName
        Wait-ServiceState -Name $serviceName -Status Running -Seconds $TimeoutSeconds
    }
    $installedImage = (Get-ItemProperty -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\$serviceName" -Name ImagePath).ImagePath
    $installedExecutable = (Split-ServiceImagePath -ImagePath $installedImage).Executable
    if (-not [string]::Equals($installedExecutable, $InstallPath, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Service registered an unexpected executable: $installedExecutable"
    }

    $hash = (Get-FileHash -LiteralPath $InstallPath -Algorithm SHA256).Hash
    Write-Host 'TargetLib service reinstalled.' -ForegroundColor Green
    Write-Host "  Status: $((Get-Service -Name $serviceName).Status)"
    Write-Host "  SHA256: $hash"
    if ($backupCreated -and -not $KeepBackup) {
        Remove-Item -LiteralPath $backupPath -Force
        $backupCreated = $false
    } elseif ($backupCreated) {
        Write-Host "  Previous binary: $backupPath"
    }
} catch {
    $failure = $_
    Write-Warning "Reinstall failed; restoring the previous service: $($failure.Exception.Message)"
    try {
        Remove-RegisteredService -Name $serviceName -Seconds $TimeoutSeconds
        if (Test-Path -LiteralPath $InstallPath) { Remove-Item -LiteralPath $InstallPath -Force }
        if ($backupCreated -and (Test-Path -LiteralPath $backupPath)) {
            Move-Item -LiteralPath $backupPath -Destination $InstallPath -Force
            $backupCreated = $false
        }
        if ($oldServiceExisted -and (Test-Path -LiteralPath $InstallPath -PathType Leaf)) {
            Invoke-DaemonAction -Executable $InstallPath -Action 'install' -Arguments $oldArguments
            if ($oldWasRunning) {
                Start-Service -Name $serviceName
                Wait-ServiceState -Name $serviceName -Status Running -Seconds $TimeoutSeconds
            }
        }
        Write-Warning 'The previous service was restored.'
    } catch {
        Write-Warning "Automatic rollback failed: $($_.Exception.Message)"
    }
    throw $failure
} finally {
    if (Test-Path -LiteralPath $stagedPath) { Remove-Item -LiteralPath $stagedPath -Force }
}
