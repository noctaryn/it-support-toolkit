<#
.SYNOPSIS
    Step-by-step network troubleshooting check with a plain-English diagnosis.
.DESCRIPTION
    Tests, in order: active adapter, default gateway, internet (by IP), DNS
    resolution and HTTPS. Stops short of changing anything; it only reports.
.PARAMETER Targets
    IP addresses or hosts to ping for the internet check.
.PARAMETER TestHost
    Host used for the DNS and HTTPS checks.
.EXAMPLE
    .\Test-NetworkHealth.ps1
#>
[CmdletBinding()]
param(
    [string[]]$Targets = @('1.1.1.1', '8.8.8.8'),
    [string]$TestHost  = 'microsoft.com'
)

function Write-Result {
    param([string]$Check, [bool]$Passed, [string]$Detail = '')
    $status = if ($Passed) { 'PASS' } else { 'FAIL' }
    $color  = if ($Passed) { 'Green' } else { 'Red' }
    Write-Host ('[{0}] {1} {2}' -f $status, $Check, $Detail) -ForegroundColor $color
}

Write-Host ("Network health check - {0}`n" -f (Get-Date -Format 'yyyy-MM-dd HH:mm'))

# 1. Adapter
$up = @(Get-NetAdapter | Where-Object Status -eq 'Up')
$adapterOk = $up.Count -gt 0
Write-Result 'Active network adapter' $adapterOk (($up.Name) -join ', ')

# 2. Gateway
$gw = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway } | Select-Object -First 1).IPv4DefaultGateway.NextHop
$gwOk = $false
if ($gw) {
    $gwOk = [bool](Test-Connection $gw -Count 2 -Quiet)
    Write-Result 'Default gateway reachable' $gwOk $gw
} else {
    Write-Result 'Default gateway configured' $false
}

# 3. Internet by IP
$pingOk = $false
foreach ($t in $Targets) {
    $r = [bool](Test-Connection $t -Count 2 -Quiet)
    if ($r) { $pingOk = $true }
    Write-Result "Ping $t" $r
}

# 4. DNS
try   { $null = Resolve-DnsName $TestHost -ErrorAction Stop; $dnsOk = $true }
catch { $dnsOk = $false }
Write-Result "DNS resolves $TestHost" $dnsOk

# 5. HTTPS
$https = Test-NetConnection -ComputerName $TestHost -Port 443 -WarningAction SilentlyContinue
Write-Result "HTTPS (port 443) to $TestHost" ([bool]$https.TcpTestSucceeded)

Write-Host "`nDiagnosis:" -ForegroundColor Cyan
if     (-not $adapterOk) { Write-Host 'No active adapter. Check the cable, Wi-Fi switch, airplane mode or adapter drivers.' }
elseif (-not $gwOk)      { Write-Host 'Cannot reach the gateway. Check Wi-Fi signal, router power and the IP settings (ipconfig /all).' }
elseif (-not $pingOk)    { Write-Host 'Local network works but the internet does not. Likely a router or ISP problem.' }
elseif (-not $dnsOk)     { Write-Host 'Internet reachable by IP but DNS fails. Try ipconfig /flushdns or set DNS to 1.1.1.1.' }
else                     { Write-Host 'All basic checks passed. If a site still fails, the problem is with that site or the browser.' }
