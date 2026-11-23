# Printer not printing

## Steps
1. Check the basics: power, paper, toner, cables or Wi-Fi, and any error on the printer's screen.
2. Confirm the right printer is selected, not "Save as PDF".
3. Open **Settings > Printers & scanners**, open the print queue and clear stuck jobs.
4. If the queue will not clear: restart the **Print Spooler** service (`services.msc`).
5. Make sure the printer is not set to **Use Printer Offline**.
6. Remove and re-add the printer; reinstall the driver from the manufacturer if needed.
7. Print a test page and confirm with the user.

## Escalate when
- The printer shows a hardware error (paper path, fuser, drum)
- Many users are affected (print server or network issue)
