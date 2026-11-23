<#
.SYNOPSIS
    Generates an HTML health report for a Windows PC.
.DESCRIPTION
    Collects OS, uptime, CPU, memory, disk, network and top-process information
    and saves it as a single HTML file. Read-only: it changes nothing on the system.
.PARAMETER OutputPath
    Folder where the report is saved. Defaults to the current user's Desktop.
.PARAMETER Open
    Opens the report in the default browser when finished.
.EXAMPLE
    .\Get-SystemHealthReport.ps1 -Open
#>
[CmdletBinding()]
param(
    [string]$OutputPath = [Environment]::GetFolderPath('Desktop'),
    [switch]$Open
)

$os     = Get-CimInstance Win32_OperatingSystem
$cs     = Get-CimInstance Win32_ComputerSystem
$cpu    = Get-CimInstance Win32_Processor | Select-Object -First 1
$uptime = (Get-Date) - $os.LastBootUpTime

$memTotal = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)   # KB -> GB
$memFree  = [math]::Round($os.FreePhysicalMemory / 1MB, 1)

$summary = [pscustomobject]@{
    ComputerName = $env:COMPUTERNAME
    User         = $env:USERNAME
    OS           = "$($os.Caption) (build $($os.BuildNumber))"
    Manufacturer = $cs.Manufacturer
    Model        = $cs.Model
    CPU          = $cpu.Name.Trim()
    'RAM (GB)'   = "$memFree free of $memTotal"
    Uptime       = '{0}d {1}h {2}m' -f $uptime.Days, $uptime.Hours, $uptime.Minutes
}

$disks = Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object {
    [pscustomobject]@{
        Drive       = $_.DeviceID
        'Size (GB)' = [math]::Round($_.Size / 1GB, 1)
        'Free (GB)' = [math]::Round($_.FreeSpace / 1GB, 1)
        'Free %'    = [math]::Round(($_.FreeSpace / $_.Size) * 100, 1)
    }
}

$procs = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 | ForEach-Object {
    [pscustomobject]@{
        Name          = $_.ProcessName
        Id            = $_.Id
        'Memory (MB)' = [math]::Round($_.WorkingSet64 / 1MB, 0)
    }
}

$net = Get-NetIPConfiguration | Where-Object { $_.IPv4Address } | ForEach-Object {
    [pscustomobject]@{
        Adapter = $_.InterfaceAlias
        IPv4    = $_.IPv4Address.IPAddress -join ', '
        Gateway = $_.IPv4DefaultGateway.NextHop -join ', '
        DNS     = $_.DNSServer.ServerAddresses -join ', '
    }
}

$css = '<style>body{font-family:Segoe UI,Arial,sans-serif;margin:2rem;color:#222}' +
       'table{border-collapse:collapse;margin-bottom:1.5rem}' +
       'th,td{border:1px solid #ccc;padding:6px 12px;text-align:left}' +
       'th{background:#0b2a55;color:#fff}h1,h2{color:#0b2a55}</style>'

$header = "<h1>System Health Report - $env:COMPUTERNAME</h1><p>Generated $(Get-Date -Format 'yyyy-MM-dd HH:mm')</p>"

$body = @($header) +
    ($summary | ConvertTo-Html -Fragment -As List  -PreContent '<h2>System</h2>') +
    ($disks   | ConvertTo-Html -Fragment           -PreContent '<h2>Disks</h2>') +
    ($procs   | ConvertTo-Html -Fragment           -PreContent '<h2>Top 5 processes by memory</h2>') +
    ($net     | ConvertTo-Html -Fragment           -PreContent '<h2>Network</h2>')

$file = Join-Path $OutputPath ('HealthReport_{0}_{1}.html' -f $env:COMPUTERNAME, (Get-Date -Format 'yyyyMMdd_HHmm'))
ConvertTo-Html -Title 'System Health Report' -Head $css -Body ($body -join "`n") |
    Out-File -FilePath $file -Encoding utf8

Write-Host "Report saved to $file" -ForegroundColor Green
if ($Open) { Start-Process $file }
