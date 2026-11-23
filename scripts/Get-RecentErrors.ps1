<#
.SYNOPSIS
    Summarises the most frequent critical/error events from the Windows logs.
.PARAMETER Hours
    How far back to look. Default 24.
.PARAMETER Top
    How many distinct errors to show. Default 10.
.EXAMPLE
    .\Get-RecentErrors.ps1 -Hours 48
#>
[CmdletBinding()]
param(
    [int]$Hours = 24,
    [int]$Top   = 10
)

$since  = (Get-Date).AddHours(-$Hours)
$events = Get-WinEvent -FilterHashtable @{
    LogName   = 'System', 'Application'
    Level     = 1, 2          # 1 = Critical, 2 = Error
    StartTime = $since
} -ErrorAction SilentlyContinue

if (-not $events) {
    Write-Host "No critical or error events in the last $Hours hours." -ForegroundColor Green
    return
}

$events | Group-Object ProviderName, Id | Sort-Object Count -Descending | Select-Object -First $Top |
    ForEach-Object {
        [pscustomobject]@{
            Count   = $_.Count
            Source  = $_.Group[0].ProviderName
            EventId = $_.Group[0].Id
            Example = ($_.Group[0].Message -split "`r?`n")[0]
        }
    } | Format-Table -AutoSize -Wrap
