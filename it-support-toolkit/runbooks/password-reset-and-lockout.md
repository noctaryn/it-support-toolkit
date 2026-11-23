# Password reset and account lockout

**Applies to:** Windows / Active Directory user accounts

## Symptoms
- "Your account has been locked out" or "incorrect password" after several attempts
- User forgot their password

## Steps
1. **Verify the user's identity** before touching the account (employee ID, manager confirmation or your company's verification process). Never skip this.
2. Open **Active Directory Users and Computers**, find the user and open **Properties**.
3. On the **Account** tab, tick **Unlock account** if it is locked.
4. Right-click the user, choose **Reset Password**, set a temporary password and tick **User must change password at next logon**.
5. Share the temporary password through an approved channel (not by email or chat in plain text).
6. Ask the user to sign in and confirm it works.
7. Log the ticket: who was verified, what you did and when.

## If the account keeps locking
- Look for old sessions or saved passwords: mapped drives, phone mail apps, Wi-Fi profiles, scheduled tasks.
- Check the domain controller's security log for the source of the failed logons.

## Escalate when
- You cannot verify the user's identity
- The lockouts look like a password-guessing attack (many attempts, odd hours, unknown sources)
