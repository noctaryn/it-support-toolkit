# Slow PC

**Applies to:** Windows 10 / 11 laptops and desktops

## Symptoms
- Slow startup, freezing apps, high fan noise

## Checks (in this order)
1. **Restart.** Ask when it was last restarted; uptime of many days is common.
2. Open **Task Manager** (Ctrl+Shift+Esc) and sort by CPU, Memory and Disk. Note the top offender.
3. Check disk space: under 10% free on C: causes slowdowns. Run `Clear-TempFiles.ps1 -WhatIf` first, then without `-WhatIf`.
4. Review **Startup apps** (Task Manager > Startup) and disable unneeded ones.
5. Run **Windows Update** and check for pending restarts.
6. Scan for malware with Windows Security.
7. Run `Get-SystemHealthReport.ps1` and attach the report to the ticket.

## Escalate when
- Disk shows 100% usage constantly (possible failing drive: back up data first)
- RAM is permanently maxed out (hardware upgrade needed)
- Malware is found
