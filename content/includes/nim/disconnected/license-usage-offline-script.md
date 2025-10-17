---
nd-docs: "DOCS-1662"
---

{{< details summary="Full license_usage_offline.sh script" >}}

```shell
#!/bin/bash

# Function to encode the username and password to base64
encode_base64() {
  echo -n "$1:$2" | base64
}

# Print help text and exit.
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo
  echo "Usage: $0 -j <path-to-JWT> -i <NIM-IP> -u <username> -p <password> -o <output zip file> -s <step>"
  echo
  echo "This script allows you to license NGINX Instance Manager and submit usage reports to F5 in a disconnected environment."
  echo "It needs to be run on a system that can reach NGINX Instance Manager and the following endpoint on port 443: https://product.apis.f5.com/"
  echo
  echo "If NGINX Instance Manager is connected to the internet (Connected Mode), please use the UI."
  echo "This script is only necessary if NGINX Instance Manager is set to Disconnected Mode."
  echo
  echo "For Licensing in Disconnected Mode:"
  echo "$0 -j my-jwt.jwt -i <NIM-IP> -u admin -p <password> -o report.zip -s initial"
  echo
  echo "For Usage Reporting in Disconnected Mode:"
  echo "$0 -j my-jwt.jwt -i <NIM-IP> -u admin -p <password> -o report.zip -s telemetry"
  echo
  echo "Note: Since NGINX Instance Manager comes with self-signed certificates by default, the --insecure flag is set in this script to run specific Curl commands."
  echo "You can alter this script if you wish to change from self-signed to verified certificates in Instance Manager."
  echo
  exit 1
fi

if ! command -v jq &> /dev/null; then
	echo -e "\nPlease install jq (https://jqlang.github.io/jq/) as it is required to run the script\n"
	exit 1
fi

# Parse command-line arguments
while getopts ":j:i:u:p:o:s:" opt; do
  case $opt in
    j) jwt_file="$OPTARG" ;;
    i) ip_address="$OPTARG" ;;
    u) username="$OPTARG" ;;
    p) password="$OPTARG" ;;
    o) output_file="$OPTARG" ;;
    s) step="$OPTARG" ;;
    \?) echo "Invalid option -$OPTARG" >&2 ;;
  esac
done


# Check if JWT_FILE is not empty and if the file exists
if [ -z "$jwt_file" ]; then
    echo "JWT file path is not defined. Please set the JWT_FILE variable."
    exit 1
elif [ ! -f "$jwt_file" ]; then
    echo "JWT file not found: $jwt_file"
    exit 1
else
    echo "JWT file found: $jwt_file"
fi


# Read the Bearer token from the file
bearer_token=$(<"$jwt_file")

# Encode the username and password to base64 for Basic Authorization
basic_auth=$(encode_base64 "$username" "$password")


# Initialize report_save_path if it's empty
report_save_path=${output_file:-"report.zip"}

############################################################################
# Step 1: Upload JWT to NGINX Instance Manager and Download telemetry report
############################################################################
echo "###################################################################"
echo "# (if not already licensed) Upload JWT and Download the Telemetry report from NGINX Instance Manager  #"
echo "###################################################################"
if [ "$step" == "initial" ]; then

    # Function to print banner
    print_banner() {
        echo "===================================="
        echo "$1"
        echo "===================================="
    }

    # Step 1: POST request
    print_banner "Executing Step 1: POST request"
    post_response=$(curl -k --location "https://$ip_address/api/platform/v1/license?telemetry=true" \
        --header "Origin: https://$ip_address" \
        --header "Referer: https://$ip_address/ui/settings/license" \
        --header "Content-Type: application/json" \
        --header "Authorization: Basic $basic_auth" \
        --data "{
            \"metadata\": {
                \"name\": \"license\"
            },
            \"desiredState\": {
                \"content\": \"$bearer_token\"
            }
        }")
    # Use jq to extract modeOfOperation
    modeOfOperation=$(jq -r '.currentStatus.modeOfOperation' <<< "$post_response")

    # Output the modeOfOperation
    echo "Mode of Operation: $modeOfOperation"

    # Parse the modeOfOperation from the response
    echo $modeOfOperation
    # Step 2: Polling for the license status with conditional logic based on modeOfOperation
    while true; do
        print_banner "Checking License Status"

        response=$(curl -k "https://$ip_address/api/platform/v1/license" \
            -H "accept: application/json" \
            -H "authorization: Basic $basic_auth" \
            -H "referer: https://$ip_address/ui/settings/license" \
            --insecure)
        fileType=$(jq -r '.currentStatus.state.currentInstance.fileType' <<< "$response")
        status=$(jq -r '.currentStatus.state.currentInstance.status' <<< "$response")
        telemetry=$(jq -r '.currentStatus.state.currentInstance.telemetry' <<< "$response")

        echo $fileType
        echo $status
        echo $telemetry
        if [[ "$modeOfOperation" == "CONNECTED" ]]; then
        if [[ "$fileType" == "JWT" && "$status" == "ACTIVATED" && "$telemetry" == "true" ]]; then
                echo "Connected mode: Desired response received!"
                break
            else
                echo "Connected mode: Waiting for the desired response..."
            fi
        elif [[ "$modeOfOperation" == "DISCONNECTED" ]]; then
            if [[ "$fileType" == "JWT" && "$status" == "INITIALIZE_ACTIVATION_COMPLETE" ]]; then
                echo "Disconnected mode: Desired response received!"
                break
            else
                echo "Disconnected mode: Waiting for the desired response..."
            fi
        fi

        sleep 5  # Poll every 5 seconds
    done

    # Step 3: PUT request
    print_banner "Executing Step 2: PUT request"
    put_response=$(curl -k --location --request PUT "https://$ip_address/api/platform/v1/license?telemetry=true" \
        --header "Origin: https://$ip_address" \
        --header "Referer: https://$ip_address/ui/settings/license" \
        --header "Content-Type: application/json" \
        --header "Authorization: Basic $basic_auth" \
        --data '{
            "desiredState": {
                "content": "",
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

    echo "Response from Step 2: PUT request:"

    # Step 4: Polling for the desired license status
    while true; do
        print_banner "Checking License Validation Status"

        response=$(curl -s "https://$ip_address/api/platform/v1/license" \
            -H "accept: application/json" \
            -H "authorization: Basic $basic_auth" \
            -H "referer: https://$ip_address/ui/settings/license" \
            --insecure)
        fileType=$(jq -r '.currentStatus.state.currentInstance.fileType' <<< "$response")
        status=$(jq -r '.currentStatus.state.currentInstance.status' <<< "$response")
        telemetry=$(jq -r '.currentStatus.state.currentInstance.telemetry' <<< "$response")


        if [[ "$modeOfOperation" == "CONNECTED" ]]; then
            if [[ "$fileType" == "JWT" && "$status" == "VALID" ]]; then
                echo "Connected mode: Desired response received!"
                break
            else
                echo "Connected mode: Current license response does not meet conditions. Retrying..."
            fi
        elif [[ "$modeOfOperation" == "DISCONNECTED" ]]; then
            if [[ "$fileType" == "JWT" && "$status" == "CONFIG_REPORT_READY" ]]; then
                echo "Disconnected mode: Desired response received!"
                break
            else
                echo "Disconnected mode: Current license response does not meet conditions. Retrying..."
            fi
        fi

        sleep 5
    done

    # Step 5: Loop to check if licensed
    while true; do
        print_banner "Checking Licensed Status"

        licensed_response=$(curl -s "https://$ip_address/api/platform/v1/modules/licensed" \
            -H "accept: application/json" \
            -H "authorization: Basic $basic_auth" \
            -H "referer: https://$ip_address/ui/settings/license" \
            --insecure)

        licensed_status=$(jq -r '.licensed' <<< "$licensed_response" )
        if [[ "$modeOfOperation" == "CONNECTED" ]]; then

            if [[ "$licensed_status" == "true" ]]; then
                echo "The system is licensed on connected mode!"
                break
            else
                echo "The system is not licensed yet. Retrying..."
            fi
        elif [[ "$modeOfOperation" == "DISCONNECTED" ]]; then
            if [[ "$licensed_status" == "false" ]]; then
                echo "Upload JWT success on disconnected mode"
                break
        fi
        fi

        sleep 5
    done

    echo "Requests executed successfully."

#################################################
# Step 2: Download the telemetry report from NGINX Instance Manager #
#################################################
echo "#################################################"
echo "# Download the telemetry report from NGINX Instance Manager #"
echo "#################################################"

  echo "Executing for step: initial"
  download_usage_command="curl --insecure --location 'https://$ip_address/api/platform/v1/report/download?format=zip&reportType=initial' \
          --header 'accept: */*' \
          --header 'authorization: Basic $basic_auth' \
          --output \"$report_save_path\""

elif [ "$step" == "telemetry" ]; then
  echo "Executing for step: telemetry"
  prepare_usage_command="curl --insecure --location 'https://$ip_address/api/platform/v1/report/download?format=zip&reportType=telemetry&telemetryAction=prepare' \
          --header 'accept: application/json' \
          --header 'authorization: Basic $basic_auth' \
          --header 'referer: https://$ip_address/ui/settings/license'"

  download_usage_command="curl --insecure --location 'https://$ip_address/api/platform/v1/report/download?format=zip&reportType=telemetry&telemetryAction=download' \
  --header 'accept: */*' \
  --header 'authorization: Basic $basic_auth' \
  --output \"$report_save_path\""
fi
if [ "$step" == "telemetry" ]; then
  echo "Running telemetry stage: "

  # Run the saved command and store the response
  response=$(eval $prepare_usage_command)

  # Print the response
  echo "Response: $response"
  sleep 2
  # Validate if the response contains "Report generation in progress"
  if echo "$response" | grep -q '"telemetry":"Report generation in progress"'; then
    echo "Success: Report generation is in progress."
  else
    echo "Failure: Report generation not in progress or unexpected response."
    exit 1
  fi

    echo "Running command: $download_usage_command"
    eval $download_usage_command
  else
    echo "Running command: $download_usage_command"
    eval $download_usage_command
  fi

############################################################
# Step 3: Upload the telemetry report to F5's licensing endpoint
############################################################
echo "############################################################"
echo "# Upload the telemetry report to F5's licensing endpoint  #"
echo "############################################################"

echo "Uploading $report_save_path to telemetry endpoint..."
upload_command="curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk' \
--header 'Authorization: Bearer $bearer_token' \
--form 'file=@\"$report_save_path\"'"

response=$(eval $upload_command)
echo "Response from upload: $response"

############################################################
# Step 4: Extract the status ID from the response
############################################################
echo "############################################################"
echo "# Extract status ID from the response#"
echo "############################################################"

status_link=$(jq -r '.statusLink | split("/") | last' <<< "$response")
if [ -z "$status_link" ]; then
  echo "Failed to extract status link from response. Please try again."
  exit 1
fi
echo "Extracted status link ID: $status_link"

##############################################################
# Step 5: Check the status to ensure the acknowledgement file is ready to download
############################################################
echo "############################################################"
echo "# Check the status to ensure the acknowledgement file is ready to download     #"
echo "############################################################"

# Initialize variables for the loop
max_attempts=10
attempt=0

# Loop to check the status until percentageComplete and percentageSuccessful are 100 or the max attempts is reached
while [ $attempt -lt $max_attempts ]; do
  echo "Checking status for the upload... (Attempt: $((attempt + 1)))"

  # Run the curl command to get the status
  status_command="curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/status/$status_link' --header 'Authorization: Bearer $bearer_token'"

  status_response=$(eval $status_command)

  # Extract values from the response
  percentage_complete=$(jq -r '.percentageComplete' <<< "$status_response")
  percentage_successful=$(jq -r '.percentageSuccessful' <<<  "$status_response")
  ready_for_download=$(jq -r '.readyForDownload' <<< "$status_response")

  echo "Percentage Complete: $percentage_complete"
  echo "Percentage Successful: $percentage_successful"
  echo "Ready for Download: $ready_for_download"

  # Check if the report is ready for download
  if [ "$percentage_complete" == "100" ] && [ "$percentage_successful" == "100" ] && [ "$ready_for_download" == "true" ]; then
    echo "File is ready for download."
    break
  else
    echo "File is not ready for download yet. Sleeping for 2 seconds..."
    sleep 2
  fi

  # Increment the attempt counter
  attempt=$((attempt + 1))
done

# If after 10 attempts it's still not ready, show a message
if [ $attempt -eq $max_attempts ]; then
  echo "Reached maximum attempts. The file is not ready for download."
  exit 1
fi

############################################################
# Step 6: Download the acknowledgement file from F5's licensing endpoint
############################################################
echo "############################################################"
echo "# Download the acknowledgement report from F5's licensing endpoint #"
echo "############################################################"

# Extract downloadLink
download_link=$(jq -r '.downloadLink | split("/") | last' <<< "$status_response")
echo $download_link
# Ensure the report_save_path is not empty
if [ -z "$report_save_path" ]; then
  # If the report_save_path is empty, set a default path and filename
  report_save_path="report_download.zip"
fi

echo "Downloading file from telemetry..."

download_command="curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/download/$download_link' \
        --header 'Authorization: Bearer $bearer_token' \
        --output '$report_save_path'"

curl --location "https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/download/$download_link" \
--header "Authorization: Bearer $bearer_token" \
--output "$report_save_path"

echo "Downloaded file saved as: $report_save_path"

############################################################
# Step 7: Upload the acknowledgement report to NGINX Instance Manager
############################################################
echo "############################################################"
echo "# Upload the acknowledgement report to NGINX Instance Manager   #"
echo "############################################################"

curl --insecure --location "https://$ip_address/api/platform/v1/report/upload" \
--header "Authorization: Basic $basic_auth" \
--form "file=@\"$report_save_path\"" \
--silent --output /dev/null

echo "Report acknowledgement successfully uploaded to NGINX Instance Manager $ip_address."
```

{{< /details >}}
