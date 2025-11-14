---
nd-docs: "DOCS-1662"
---

{{< details summary="Full license_usage_offline.sh script" >}}

```shell
#!/bin/bash

# Enable strict mode for better error handling
set -euo pipefail
IFS=$'\n\t'

# Debug mode
if [[ "${DEBUG:-false}" == "true" ]]; then
  set -x  # Enable command tracing
  echo "Debug mode enabled"
  echo "Running in directory: $(pwd)"
  echo "Script arguments: $*"
  env | grep -E 'JWT_FILE|NIM_IP|USERNAME|PASSWORD|USE_CASE'
fi

# Set timeouts for operations
CURL_TIMEOUT=${CURL_TIMEOUT:-30}
API_POLL_TIMEOUT=${API_POLL_TIMEOUT:-60}

# Function to log with timestamp
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

log "Script started"

# Function to display usage
usage() {
  echo "Usage: $0 -j <JWT file> -i <NIM IP> -u <username> -p <password> -s <initial|telemetry>"
  echo
  echo "Options:"
  echo "  -j <JWT file>     Path to the JWT (JSON Web Token) file used for authentication."
  echo "  -i <NIM IP>       IP address of the NIM (NGINX Instance Manager) to connect to."
  echo "  -u <username>     Username for login/authentication to NIM (NGINX Instance Manager)."
  echo "  -p <password>     Password corresponding to the username for NIM (NGINX Instance Manager) authentication."
  echo "  -s <mode>         Script execution mode. One of the following:"
  echo "                      initial       - Perform Initial License Activation"
  echo "                      telemetry     - Perform telemetry submission: download usage report from NGINX Instance Manager and submit to F5."
  exit 1
}

# Parse command-line arguments
while getopts ":j:i:u:p:s:" opt; do
  case $opt in
    j) JWT_FILE="$OPTARG" ;;
    i) NIM_IP="$OPTARG" ;;
    u) USERNAME="$OPTARG" ;;
    p) PASSWORD="$OPTARG" ;;
    s) USE_CASE="$OPTARG" ;;
    *) usage ;;
  esac
done

# Check if all required arguments are provided
if [ -z "${JWT_FILE:-}" ] || [ -z "${NIM_IP:-}" ] || [ -z "${USERNAME:-}" ] || [ -z "${PASSWORD:-}" ] || [ -z "${USE_CASE:-}" ]; then
  usage
fi

echo "Running $USE_CASE report"

# Ensure /tmp directory exists or else create it and proceed
if [ ! -d "/tmp" ]; then
  echo "/tmp directory does not exist. Creating it now..."
  mkdir -p /tmp || { echo "Failed to create /tmp directory. Exiting."; exit 1; }
fi

# Read JWT contents
if [ ! -f "$JWT_FILE" ]; then
  echo -e "JWT file '$JWT_FILE' not found.$" >&2
  exit 1
fi
JWT_CONTENT=$(<"$JWT_FILE")

# Encode credentials
AUTH_HEADER=$(echo -n "$USERNAME:$PASSWORD" | base64)

# Check connectivity to NGINX Instance Manager IP and the F5 licensing server (product.apis.f5.com)
echo -e "Checking connectivity to NGINX Instance Manager and F5 licensing server..."

# Function to test ping
check_ping() {
  local host=$1
  echo "Pinging $host... "
  if ! ping -c 2 -W 2 "$host" > /dev/null 2>&1; then
    echo -e "Cannot reach $host. Please check your network, DNS or check if any proxy is set.$" >&2
    exit 1
  fi
  echo -e "$host is reachable."
}

# Call the function for each host
is_ipv4() {
  local ip=$1
  if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    IFS='.' read -r -a octets <<< "$ip"
    for octet in "${octets[@]}"; do
      if ((octet < 0 || octet > 255)); then
        return 1
      fi
    done
    return 0
  else
    return 1
  fi
}
echo "Checking connectivity to NGINX Instance Manager using Curl ..."
if ! curl -sk --output /dev/null --silent --fail --max-time $CURL_TIMEOUT "https://$NIM_IP"; then
  echo -e "The NGINX Instance Manager UI is not reachable on $NIM_IP"
  exit 1
fi 
echo "Checking connectivity to F5 licensing server..."
SERVER_RESPONSE=$(curl -v --max-time $CURL_TIMEOUT https://product.apis.f5.com 2>&1)

# Check if the server is reachable by verifying connection was established
if echo "$SERVER_RESPONSE" | grep -q "Connected to product.apis.f5.com" && echo "$SERVER_RESPONSE" | grep -q "server accepted"; then
  echo -e "The licensing server is reachable on product.apis.f5.com"
else
  echo -e "The licensing server is not reachable on product.apis.f5.com"
  echo -e "Connection details: $SERVER_RESPONSE"
  exit 1
fi 

# NGINX Instance Manager Version check 
VERSION_JSON=$(curl -sk -X GET "https://$NIM_IP/api/platform/v1/modules/versions" \
  --header "Content-Type: application/json" \
  --header "Authorization: Basic $AUTH_HEADER")
NIM_VER=$(echo "$VERSION_JSON" | sed -E 's/.*"nim"[ \t]*:[ \t]*"([0-9]+\.[0-9]+)(\.[0-9]+)?".*/\1/')
echo "Current version of NGINX Instance Manager is $NIM_VER"

# Construct JSON payload
JSON_PAYLOAD=$(cat <<EOF
  {
    "metadata": {
      "name": "license"
    },
    "desiredState": {
      "content": "$JWT_CONTENT"
    }
  }
EOF
)

# Send GET request and capture response and status code
response=$(curl -sk -w "%{http_code}" -o /tmp/device_mode.json "https://$NIM_IP/api/platform/v1/report/device_mode" -H 'accept: application/json' -H "Authorization: Basic $AUTH_HEADER")

# Extract status code and response body
http_code="${response: -3}"
body=$(cat /tmp/device_mode.json)

# Check response code
if [[ "$http_code" != "200" ]]; then
  echo "Request failed with status code $http_code"
  exit 1
fi

# Parse device_mode using jq
device_mode=$(echo "$body" | jq -r '.device_mode')

# Use the value
echo "Device mode is: $device_mode"

# Check value and act
if [[ "$device_mode" == "CONNECTED" ]]; then
  echo "Device mode is CONNECTED. This script is only for DISCONNECTED mode"
  exit 1
fi

ORIGIN="https://$NIM_IP"
REFERER="$ORIGIN/ui/settings/license"

if [[ "$USE_CASE" == "initial" ]]; then
  echo "Applying JWT license"
  sleep 5  
  RESPONSE=$(curl -sS -k --max-time 10 -w "\n%{http_code}" -X POST "https://$NIM_IP/api/platform/v1/license?telemetry=true" \
    -H "Origin: $ORIGIN" \
    -H "Referer: $REFERER" \
    -H "Content-Type: application/json" \
    -H "Authorization: Basic $AUTH_HEADER" \
    -d "$JSON_PAYLOAD")
  echo "Uploaded License"
  HTTP_BODY=$(echo "$RESPONSE" | sed '$d')
  HTTP_STATUS=$(echo "$RESPONSE" | tail -n1)
  if [ "$HTTP_STATUS" -ne 202 ]; then
    echo -e "HTTP request failed with status code $HTTP_STATUS.\nResponse: $HTTP_BODY$" >&2
    if echo "$HTTP_BODY" | jq -r '.message' | grep -q "failed to register token. already registered"; then
      echo -e "NGINX Instance Manager already registered and licensed.\nIf needed, terminate the current license manually in the NGINX Instance Manager UI and re-run the script with the correct license.\nhttps://docs.nginx.com/nginx-instance-manager/disconnected/add-license-disconnected-deployment/"
    fi
    exit 1
  fi
fi

if [[ "$NIM_VER" < "2.18" ]]; then
  echo "NGINX Instance Manager version $NIM_VER is not supported by this script. Please use NGINX Instance Manager 2.18 or later"
  exit 1
elif [[ "$NIM_VER" == "2.18" ]] || [[ "$NIM_VER" == "2.19" ]]; then
  echo "NGINX Instance Manager version $NIM_VER detected."
  ORIGIN="https://$NIM_IP"

  # Send the PUT request and separate body and status code
  PUT_RESPONSE_CODE=$(curl -k -s -w "%{http_code}" -o /tmp/put_response.json --location --request PUT "https://$NIM_IP/api/platform/v1/license?telemetry=true" \
    --header "Origin: $ORIGIN" \
    --header "Referer: https://$NIM_IP/ui/settings/license" \
    --header "Content-Type: application/json" \
    --header "Authorization: Basic $AUTH_HEADER" \
    --data '{
      "desiredState": {
          "content": "'"$JWT_CONTENT"'",
          "type": "JWT",
          "features": [
              {"limit": 0, "name": "NGINX_NAP_DOS", "valueType": ""},
              {"limit": 0, "name": "IM_INSTANCES", "valueType": ""},
              {"limit": 0, "name": "TM_INSTANCES", "valueType": ""},
              {"limit": 0, "name": "DATA_PER_HOUR_GB", "valueType": ""},
              {"limit": 0, "name": "NGINX_INSTANCES", "valueType": ""},
              {"limit": 0, "name": "NGINX_NAP", "valueType": ""},
              {"limit": 0, "name": "SUCCESSFUL_API_CALLS_MILLIONS", "valueType": ""},
              {"limit": 0, "name": "IC_PODS", "valueType": ""},
              {"limit": 0, "name": "IC_K8S_NODES", "valueType": ""}
          ]
      },
      "metadata": {
          "name": "license"
      }
    }')

  echo "Response status code: $PUT_RESPONSE_CODE"

  if [[ "$PUT_RESPONSE_CODE" == "200" ]]; then
    echo -e "(legacy): License applied successfully in DISCONNECTED mode for version $NIM_VER."
  else
    echo -e "(legacy): License PUT request failed. Status code: $PUT_RESPONSE_CODE$"
    echo "clear the license database and re-trigger the script again"
    exit 1
  fi
fi

if [[ "$USE_CASE" != "telemetry" ]]; then
  RESPONSE=$(curl -sS -k --max-time 10 -w "\n%{http_code}" -X POST "https://$NIM_IP/api/platform/v1/license?telemetry=true" \
    -H "Origin: $ORIGIN" \
    -H "Referer: $REFERER" \
    -H "Content-Type: application/json" \
    -H "Authorization: Basic $AUTH_HEADER" \
    -d "$JSON_PAYLOAD")

  HTTP_BODY=$(echo "$RESPONSE" | sed '$d')
  HTTP_STATUS=$(echo "$RESPONSE" | tail -n1)

  echo -e "License applied successfully in DISCONNECTED mode."
fi

sleep 5
echo "Executing telemetry tasks"
if [[ "$NIM_VER" == "2.18" ]] || [[ "$NIM_VER" == "2.19" ]]; then
  if [[ "$USE_CASE" == "initial" ]]; then
    HTTP_RESPONSE=$(curl -k -sS -w "\n%{http_code}" --location "https://$NIM_IP/api/platform/v1/report/download?format=zip&reportType=initial" \
      --header "accept: application/json" \
      --header "authorization: Basic $AUTH_HEADER" \
      --header "content-type: application/json" \
      --header "origin: https://$NIM_IP" \
      --output /tmp/response.zip)
  else
     prepare_usage_command="curl --insecure --location 'https://$NIM_IP/api/platform/v1/report/download?format=zip&reportType=telemetry&telemetryAction=prepare' \
          --header 'accept: application/json' \
          --header 'authorization: Basic $AUTH_HEADER' \
          --header 'referer: https://$NIM_IP/ui/settings/license'"
    report_save_path="${output_file:-/tmp/response.zip}"

    download_usage_command="curl --insecure --location 'https://$NIM_IP/api/platform/v1/report/download?format=zip&reportType=telemetry&telemetryAction=download' \
      --header 'accept: */*' \
      --header 'authorization: Basic $AUTH_HEADER' \
      --output \"$report_save_path\""
    
    if [ "$USE_CASE" == "telemetry" ]; then
      echo "Running telemetry stage: "
      response=$(eval $prepare_usage_command)
      sleep 2
      if echo "$response" | grep -q '"telemetry":"Report generation in progress"'; then
        echo -e "Success: Report generation is in progress."
      else
        echo -e "Failure: Report generation not in progress or unexpected response."
        exit 1
      fi
      echo "Running command: $download_usage_command"
      eval $download_usage_command
    else
      echo "Running command: $download_usage_command"
      eval $download_usage_command
    fi
  fi
else
  HTTP_RESPONSE=$(curl -k -sS -w "\n%{http_code}" --location "https://$NIM_IP/api/platform/v1/report/download?format=zip" \
  --header "accept: application/json" \
  --header "authorization: Basic $AUTH_HEADER" \
  --header "content-type: application/json" \
  --header "origin: https://$NIM_IP" \
  --output /tmp/response.zip)

  HTTP_STATUS=$(echo "$HTTP_RESPONSE" | tail -n1)
  if [ "$HTTP_STATUS" -ne 200 ]; then
    echo -e "Failed to download usage report from NGINX Instance Manager. HTTP Status Code: $HTTP_STATUS" >&2
    echo "Please verify that NGINX Instance Manager is reachable and the credentials are correct." >&2
    echo "(or) Verify that NGINX Instance Manager is licensed before using the 'telemetry' flag (run it with 'initial' first)."
    rm -f /tmp/response.zip
    exit 1
  fi
fi

echo -e "Usage report downloaded successfully as '/tmp/response.zip'."

echo "Uploading the usage report to F5 Licensing server"
TEEM_UPLOAD_URL="https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk"

UPLOAD_RESULT=$(curl -sS -w "\n%{http_code}" --location "$TEEM_UPLOAD_URL" \
  --header "Authorization: Bearer $JWT_CONTENT" \
  --form "file=@/tmp/response.zip")

UPLOAD_STATUS=$(echo "$UPLOAD_RESULT" | tail -n1)
UPLOAD_BODY=$(echo "$UPLOAD_RESULT" | sed '$d')

if [ "$UPLOAD_STATUS" -ne 202 ]; then
  echo -e "Usage report upload failed. HTTP Status: $UPLOAD_STATUS$" >&2
  echo "Response Body: $UPLOAD_BODY" >&2
  exit 1
fi

if ! echo "$UPLOAD_BODY" | jq empty >/dev/null 2>&1; then
  echo -e "Upload response is not valid JSON. Response: $UPLOAD_BODY$" >&2
  exit 1
fi

STATUS_LINK=$(echo "$UPLOAD_BODY" | jq -r '.statusLink // empty')
if [ -z "$STATUS_LINK" ]; then
  echo -e "Failed to extract statusLink from the upload response. Response: $UPLOAD_BODY$" >&2
  exit 1
fi

echo "StatusLink extracted: $STATUS_LINK"
STATUS_ID=$(echo "$STATUS_LINK" | sed 's|/ee/v1/entitlements/telemetry/bulk/status/||')

echo "Validating the report status"
echo "Validating report status using status ID: $STATUS_LINK"

STATUS_URL="https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/status/$STATUS_ID"

sleep 5
STATUS_RESPONSE=$(curl -k -sS -w "\n%{http_code}" --location "$STATUS_URL" \
  --header "Authorization: Bearer $JWT_CONTENT")

STATUS_BODY=$(echo "$STATUS_RESPONSE" | sed '$d')
STATUS_CODE=$(echo "$STATUS_RESPONSE" | tail -n1)

if [ "$STATUS_CODE" -ne 200 ]; then
  echo -e "Status check failed. HTTP Status: $STATUS_CODE$" >&2
  echo "Response Body: $STATUS_BODY" >&2
  exit 1
fi

if ! echo "$STATUS_BODY" | jq empty >/dev/null 2>&1; then
  echo -e "Invalid JSON in status body: $STATUS_BODY$" >&2
  exit 1
fi

PERCENTAGE_COMPLETE=$(echo "$STATUS_BODY" | jq -r '.percentageComplete')
PERCENTAGE_SUCCESSFUL=$(echo "$STATUS_BODY" | jq -r '.percentageSuccessful')
READY_FOR_DOWNLOAD=$(echo "$STATUS_BODY" | jq -r '.readyForDownload')

TIME_LIMIT=30
START_TIME=$(date +%s)

elapsed_time() {
  echo $(($(date +%s) - $START_TIME))
}

while true; do
  if [ "$PERCENTAGE_COMPLETE" -eq "100" ] && [ "$READY_FOR_DOWNLOAD" == "true" ]; then
    echo -e "Validating Report."
    break
  fi

  if [ $(elapsed_time) -ge "$TIME_LIMIT" ]; then
    echo -e "Time limit exceeded. Report validation failed."
    echo "  percentageComplete: $PERCENTAGE_COMPLETE"
    echo "  percentageSuccessful: $PERCENTAGE_SUCCESSFUL"
    echo "  readyForDownload: $READY_FOR_DOWNLOAD"
    echo "  F5 upload issue failed even after 30 seconds"
    echo "  re-run the script"
    exit 1
  fi

  echo -e "Report validation failed. Waiting for conditions to be met...$"
  echo "  percentageComplete: $PERCENTAGE_COMPLETE"
  echo "  percentageSuccessful: $PERCENTAGE_SUCCESSFUL"
  echo "  readyForDownload: $READY_FOR_DOWNLOAD"

  sleep 5
done

echo -e "Report validated successfully. All conditions met."

echo "Downloading report from F5 License server..."
DOWNLOAD_URL="https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/download/$STATUS_ID"
DOWNLOAD_RESPONSE=$(curl -sS -w "%{http_code}" --location "$DOWNLOAD_URL" \
  --header "Authorization: Bearer $JWT_CONTENT" \
  --output /tmp/response_teem.zip)

HTTP_STATUS=$(echo "$DOWNLOAD_RESPONSE" | tail -n1)
if [ "$HTTP_STATUS" -ne 200 ]; then
  echo -e "Failed to download the report from F5. HTTP Status Code: $HTTP_STATUS$" >&2
  exit 1
fi

echo -e "Report downloaded successfully from F5 as '/tmp/response_teem.zip'."

echo "Uploading the license acknowledgement to NGINX Instance Manager..."
UPLOAD_URL="https://$NIM_IP/api/platform/v1/report/upload"
UPLOAD_RESPONSE=$(curl -k -sS --location "$UPLOAD_URL" \
  --header "Authorization: Basic $AUTH_HEADER" \
  --form "file=@/tmp/response_teem.zip" \
  -w "%{http_code}" -o /tmp/temp_response.json)

HTTP_STATUS=$(echo "$UPLOAD_RESPONSE" | tail -n1)
UPLOAD_MESSAGE=$(cat /tmp/temp_response.json | jq -r '.message')

if ! [[ "$HTTP_STATUS" =~ ^[0-9]+$ ]]; then
  echo -e "Invalid HTTP status code. Response: $UPLOAD_RESPONSE$" >&2
  exit 1
fi

if [ "$UPLOAD_MESSAGE" != "Report uploaded successfully." ] || [ "$HTTP_STATUS" -ne 200 ]; then
  echo -e "Upload failed. Response: $UPLOAD_RESPONSE$" >&2
  exit 1
fi
echo -e "Acknowledgement uploaded successfully to NGINX Instance Manager."
```

{{< /details >}}
