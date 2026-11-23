# No internet connection

## Steps
1. Ask: is it just this device, or do other devices fail too?
2. Check Wi-Fi is on and airplane mode is off; reconnect to the network.
3. Run `Test-NetworkHealth.ps1` and read the diagnosis.
4. Depending on the result:
   - **No adapter:** check the cable, reseat or enable the adapter in Device Manager.
   - **Gateway unreachable:** restart the router; check the IP settings with `ipconfig /all` (a 169.254.x.x address means no DHCP).
   - **Gateway OK but no internet:** router or ISP issue; contact the ISP.
   - **IP pings work but DNS fails:** run `ipconfig /flushdns`, then set DNS to 1.1.1.1 if needed.
5. Confirm the user can browse, then close the ticket with the cause noted.

## Escalate when
- Several users are affected (likely network or ISP outage)
- The router needs a configuration change you are not authorised to make
