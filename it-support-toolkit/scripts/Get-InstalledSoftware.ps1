<#
.SYNOPSIS
    Exports a list of installed applications to CSV (software inventory).
.PARAMETER OutputPath
    CSV file to create. Defaults to InstalledSoftware.csv on the Desktop.
.EXAMPLE
    .\Get-InstalledSoftware.ps1
#>
[CmdletBinding()]
param(
    [string]$OutputPath = (Join-Path ([Environment]::GetFolderPath('Desktop')) 'InstalledSoftware.csv')
)

$keys = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'

$apps = Get-ItemProperty $keys -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName } |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
    Sort-Object DisplayName -Unique

$apps | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
Write-Host ('{0} applications exported to {1}' -f @($apps).Count, $OutputPath) -ForegroundColor Green
