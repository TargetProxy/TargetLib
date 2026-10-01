$ErrorActionPreference = 'Continue'

Write-Host "=== Service Status ==="
Get-Service -Name TargetLib | Format-List Status,DisplayName,ServiceName

Write-Host "`n=== Process Info ==="
$proc = Get-Process -Name TargetLib -ErrorAction SilentlyContinue
if ($proc) {
    $proc | Format-List Id,ProcessName,Path,StartTime
} else {
    Write-Host "No TargetLib process found"
}

Write-Host "`n=== Network Listeners ==="
Get-NetTCPConnection -State Listen -LocalPort 19090,50051 -ErrorAction SilentlyContinue | Format-Table LocalAddress,LocalPort,OwningProcess

Write-Host "`n=== Recent Application Events ==="
Get-EventLog -LogName Application -Source TargetLib -Newest 3 -ErrorAction SilentlyContinue | Format-List TimeGenerated,EntryType,Message
