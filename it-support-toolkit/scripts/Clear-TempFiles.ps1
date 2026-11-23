<#
.SYNOPSIS
    Deletes old temporary files to free disk space. Supports -WhatIf.
.DESCRIPTION
    Removes files older than the given number of days from the user's TEMP folder
    and C:\Windows\Temp (the second needs an elevated PowerShell). Always run with
    -WhatIf first to preview what would be deleted.
.PARAMETER OlderThanDays
    Only files not modified for this many days are touched. Default 7.
.EXAMPLE
    .\Clear-TempFiles.ps1 -WhatIf
.EXAMPLE
    .\Clear-TempFiles.ps1 -OlderThanDays 14
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [ValidateRange(1, 3650)]
    [int]$OlderThanDays = 7
)

$paths  = @($env:TEMP, "$env:SystemRoot\Temp") | Select-Object -Unique
$cutoff = (Get-Date).AddDays(-$OlderThanDays)
$bytes  = 0
$count  = 0

foreach ($p in $paths) {
    if (-not (Test-Path $p)) { continue }
    Get-ChildItem -Path $p -Recurse -Force -File -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt $cutoff } |
        ForEach-Object {
            $size = $_.Length
            if ($PSCmdlet.ShouldProcess($_.FullName, 'Delete')) {
                try {
                    Remove-Item -LiteralPath $_.FullName -Force -ErrorAction Stop
                    $bytes += $size; $count++
                } catch { }   # file in use or access denied: skip it
            } else {
                $bytes += $size; $count++   # preview mode: count only
            }
        }
}

$verb = if ($WhatIfPreference) { 'Would free' } else { 'Freed' }
Write-Host ('{0} {1} MB across {2} files (older than {3} days).' -f $verb, [math]::Round($bytes / 1MB, 1), $count, $OlderThanDays) -ForegroundColor Green
