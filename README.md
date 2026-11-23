# IT Support Toolkit

A set of PowerShell scripts and troubleshooting runbooks for everyday help desk and IT support work on Windows. Each script solves one common support task, is documented with `Get-Help`, and is safe to run: the read-only ones change nothing, and the one that deletes files supports `-WhatIf` preview.

## Scripts

| Script | What it does |
|---|---|
| `Get-SystemHealthReport.ps1` | Builds an HTML report: OS, uptime, CPU/RAM, disks, top processes, network |
| `Test-NetworkHealth.ps1` | Tests adapter, gateway, internet, DNS and HTTPS, then gives a plain-English diagnosis |
| `Clear-TempFiles.ps1` | Removes old temp files to free space; preview first with `-WhatIf` |
| `Get-InstalledSoftware.ps1` | Exports installed applications to CSV for inventory |
| `Get-RecentErrors.ps1` | Summarises the most frequent critical/error events from the Windows logs |

## Runbooks

Step-by-step guides written the way a help desk knowledge base would be:

- [Password reset and account lockout](runbooks/password-reset-and-lockout.md)
- [Slow PC](runbooks/slow-pc.md)
- [No internet connection](runbooks/no-internet.md)
- [Printer not printing](runbooks/printer-not-printing.md)
- [Ticket template](runbooks/ticket-template.md)

## How to run

Requires Windows 10/11 with PowerShell 5.1 or later.

```powershell
# Allow scripts for this window only
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Run a script
.\scripts\Get-SystemHealthReport.ps1 -Open

# Preview before deleting anything
.\scripts\Clear-TempFiles.ps1 -WhatIf

# Built-in help for any script
Get-Help .\scripts\Test-NetworkHealth.ps1 -Full
```

## Skills shown

PowerShell scripting (parameters, error handling, `-WhatIf` support), Windows diagnostics (CIM, event logs, networking), troubleshooting methodology and technical documentation.

## Tested on

Windows 11 Pro (build 26200), Windows PowerShell 5.1
