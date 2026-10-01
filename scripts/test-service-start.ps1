$ErrorActionPreference = 'Stop'

Write-Host "Starting TargetLib service..."
try {
    Start-Service -Name TargetLib
    Start-Sleep -Seconds 3
    $service = Get-Service -Name TargetLib
    Write-Host "Service status: $($service.Status)"
} catch {
    Write-Host "Failed to start service: $_"

    # Check event log for the actual error
    $events = Get-EventLog -LogName System -Source 'Service Control Manager' -Newest 5 -ErrorAction SilentlyContinue
    $relevantEvent = $events | Where-Object { $_.Message -match 'TargetLib' } | Select-Object -First 1

    if ($relevantEvent) {
        Write-Host "`nService error from event log:"
        Write-Host $relevantEvent.Message
    }

    exit 1
}
