#!/bin/bash

# F5, Inc 2026

# Copyright (C) 2026 F5, Inc.  All rights reserved.
# This script is for reference only. You should copy and modify it to suit your particular deployment.

# offline_usage.sh
# Downloads usage report from NGINX Instance Manager.
# Uploads usage report to NGINX One console.
#
# Usage:
#   ./offline_usage.sh download <username> <password> <nim_ip>
#   ./offline_usage.sh upload <file_path> --result-dir <dir> [--endpoint-url <url>]
#
# Arguments:
#   download: Requires operation, username, password, and nim_ip for NGINX Instance Manager
#   upload: Requires operation and file_path; flags are optional
#
# Output:
#   /tmp/response.zip - downloaded usage report (download)
#   upload_usage.log - log file for upload operation

set -euo pipefail

require_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Missing required command: $1" >&2; exit 1; }; } 
require_cmd unzip require_cmd jq
if [[ $# -lt 1 ]]; then
  echo "Usage:"
  echo "  $0 download <username> <password> <nim_ip>"
  echo "  $0 upload <file_path> --result-dir <dir> [--endpoint-url <url>]"
  exit 1
fi

OPERATION="$1"

if [[ "$OPERATION" == "download" ]]; then
  if [[ $# -lt 4 ]]; then
    echo "Usage:"
    echo "  $0 download <username> <password> <nim_ip>"
    exit 1
  fi
  USERNAME="$2"
  PASSWORD="$3"
  NIM_IP="$4"
  # Set timeouts for operations
  CURL_TIMEOUT=${CURL_TIMEOUT:-30}

  # Ensure /tmp directory exists (should always exist on Linux)
  if [ ! -d "/tmp" ]; then
    echo "/tmp directory does not exist. Creating it now..."
    mkdir -p /tmp || { echo "Failed to create /tmp directory. Exiting."; exit 1; }
  fi

  # Encode credentials for Basic Auth
  AUTH_HEADER=$(echo -n "$USERNAME:$PASSWORD" | base64)

  echo "Checking connectivity to NGINX Instance Manager using Curl ..."
  if ! curl -sk --output /dev/null --silent --fail --max-time "${CURL_TIMEOUT}" "https://$NIM_IP"; then
    echo "The NGINX Instance Manager UI is not reachable on $NIM_IP"
    exit 1
  fi

  # Send GET request and capture response and status code
  response=$(curl -sk -w "%{http_code}" -o /tmp/device_mode.json "https://$NIM_IP/api/platform/v1/report/device_mode" \
    -H 'accept: application/json' -H "Authorization: Basic $AUTH_HEADER")

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

  echo "Device mode is: $device_mode"

  if [[ "$device_mode" == "CONNECTED" ]]; then
    echo "Device mode is CONNECTED. This script is only for DISCONNECTED mode"
    exit 1
  fi

  # Download the usage report
  echo "Downloading usage report from NGINX Instance Manager at $NIM_IP..."
  HTTP_RESPONSE=$(curl -k -sS -w "\n%{http_code}" --location "https://$NIM_IP/api/platform/v1/report/download?format=zip" \
    --header "accept: application/json" \
    --header "authorization: Basic $AUTH_HEADER" \
    --header "content-type: application/json" \
    --header "origin: https://$NIM_IP" \
    --output /tmp/response.zip)

  HTTP_STATUS=$(echo "$HTTP_RESPONSE" | tail -n1)
  if [ "$HTTP_STATUS" -ne 200 ]; then
    echo "Failed to download usage report from NGINX Instance Manager. HTTP Status Code: $HTTP_STATUS" >&2
    echo "Please verify that NGINX Instance Manager is reachable and the credentials are correct." >&2
    echo "(or) Verify that NGINX Instance Manager is licensed before using the 'telemetry' flag (run it with 'initial' first)."
    exit 1
  fi

  echo "Usage report downloaded successfully to /tmp/response.zip"
  exit 0
fi

# Upload operation
if [[ "$OPERATION" == "upload" ]]; then
  LOG_FILE="upload_usage.log"
  # Only set permissions if file is newly created
  if [ ! -f "$LOG_FILE" ]; then
      touch "$LOG_FILE"
      chmod 600 "$LOG_FILE"
  fi

  FAILED_UPLOADS=()
  DEFAULT_ENDPOINT_URL="https://product.connect.nginx.com/api/nginx-usage/batch"

  # Argument parsing:
  #   upload <file_path> --result-dir <dir> [--endpoint-url <url>]
  if [ "$#" -lt 2 ]; then
      echo "Usage: $0 upload <file_path> --result-dir <dir> [--endpoint-url <url>]"
      echo "  <file_path>             Path to exported usage .zip file (required)"
      echo "  --endpoint-url, -e <u>  Upload endpoint URL (default: $DEFAULT_ENDPOINT_URL)"
      echo "  --result-dir,  -r <d>   Directory to track uploaded files (required)"
      exit 1
  fi

  EXPORTED_USAGE="$2"
  ENDPOINT_URL="$DEFAULT_ENDPOINT_URL"
  RESULT_DIR=""

  if [ ! -f "$EXPORTED_USAGE" ]; then
      echo "Error: upload file not found: $EXPORTED_USAGE" >&2
      exit 1
  fi

  # Basic validation that the provided file is a ZIP archive.
  # (Prefer a content check over relying only on the .zip extension.)
  if ! unzip -tq "$EXPORTED_USAGE" >/dev/null 2>&1; then
      echo "Error: upload file is not a valid .zip archive: $EXPORTED_USAGE" >&2
      exit 1
  fi

  shift 2
  while [ "$#" -gt 0 ]; do
      case "$1" in
          --endpoint-url|-e)
              if [ "$#" -lt 2 ]; then
                  echo "Error: $1 requires a value" >&2
                  exit 1
              fi
              ENDPOINT_URL="$2"
              shift 2
              ;;
          --result-dir|-r)
              if [ "$#" -lt 2 ]; then
                  echo "Error: $1 requires a value" >&2
                  exit 1
              fi
              RESULT_DIR="$2"
              shift 2
              ;;
          --help|-h)
              echo "Usage: $0 upload <file_path> --result-dir <dir> [--endpoint-url <url>]"
              echo "  <file_path>             Path to exported usage .zip file (required)"
              echo "  --endpoint-url, -e <u>  Upload endpoint URL (default: $DEFAULT_ENDPOINT_URL)"
              echo "  --result-dir,  -r <d>   Directory to track uploaded files (required)"
              exit 0
              ;;
          *)
              echo "Unknown argument: $1" >&2
              echo "Usage: $0 upload <file_path> --result-dir <dir> [--endpoint-url <url>]" >&2
              exit 1
              ;;
      esac
  done

  # result-dir is required
  if [ -z "$RESULT_DIR" ]; then
      echo "Error: --result-dir (or -r) is required" >&2
      echo "Usage: $0 upload <file_path> --result-dir <dir> [--endpoint-url <url>]" >&2
      exit 1
  fi

  UNZIP_DIR="$RESULT_DIR/unzip"

  mkdir -p "$RESULT_DIR"
  chmod 700 "$RESULT_DIR"
  mkdir -p "$UNZIP_DIR"
  chmod 700 "$UNZIP_DIR"
  mkdir -p "$RESULT_DIR"
  chmod 700 "$RESULT_DIR"

  # Display the contents of the directory
  unzip -o -q "$EXPORTED_USAGE" -d "$UNZIP_DIR"
  echo "Contents of the UNZIP_DIR directory '$UNZIP_DIR':"
  echo ""
  ls -alh "$UNZIP_DIR"
  echo ""

  while IFS= read -r -d '' TOKEN_DIR; do
      JWT_FILE="$TOKEN_DIR/jwt.txt"
      if [ ! -f "$JWT_FILE" ]; then
          echo "No jwt.txt found in $TOKEN_DIR, skipping."
          echo "$(date '+%Y-%m-%d %H:%M:%S') [SKIP] No jwt.txt found in $TOKEN_DIR" >> "$LOG_FILE"
          continue
      fi
      JWT=$(cat "$JWT_FILE")
      for GZIP_FILE in "$TOKEN_DIR"/usage*.gzip; do
          [ -e "$GZIP_FILE" ] || continue
          UPLOADED_LIST="$RESULT_DIR/uploaded_files.txt"
          if [ -f "$UPLOADED_LIST" ] && grep -Fxq "$GZIP_FILE" "$UPLOADED_LIST"; then
              echo "Already uploaded: $GZIP_FILE (listed in $UPLOADED_LIST), skipping."
              echo "$(date '+%Y-%m-%d %H:%M:%S') [SKIP] $GZIP_FILE already uploaded (listed in $UPLOADED_LIST)" >> "$LOG_FILE"
              continue
          fi
          RETRIES=0
          MAX_RETRIES=5
          SUCCESS=0
          while [ $RETRIES -lt $MAX_RETRIES ]; do
              CURL_CMD="curl -s -o /dev/null -w \"%{http_code}\" -X POST \"$ENDPOINT_URL\" --header \"Authorization: Bearer \$JWT\" --header \"Content-Type: application/gzip\" --data-binary @\"$GZIP_FILE\""
              echo "DEBUG: Posting with curl command: $CURL_CMD"
              echo "$(date '+%Y-%m-%d %H:%M:%S') [DEBUG] curl command: $CURL_CMD" >> "$LOG_FILE"
              HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
                  -X POST "$ENDPOINT_URL" \
                  --header @<(echo "Authorization: Bearer $JWT") \
                  --header "Content-Type: application/gzip" \
                  --data-binary @"$GZIP_FILE")
              echo "$(date '+%Y-%m-%d %H:%M:%S') [ATTEMPT] $GZIP_FILE -> $ENDPOINT_URL (HTTP $HTTP_CODE, attempt $((RETRIES+1)))" >> "$LOG_FILE"
              if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ] || [ "$HTTP_CODE" = "204" ]; then
                  SUCCESS=1
                  break
              elif [[ "$HTTP_CODE" =~ ^(401|403|413|400)$ ]]; then
                  REASON="unknown"
                  case "$HTTP_CODE" in
                      401) REASON="unauthorized";;
                      403) REASON="forbidden";;
                      413) REASON="request size too big";;
                      400) REASON="bad request";;
                  esac
                  SKIP_MSG="$(date '+%Y-%m-%d %H:%M:%S') [SKIP] $GZIP_FILE $REASON (HTTP $HTTP_CODE), skipping retries"
                  echo "$SKIP_MSG"
                  echo "$SKIP_MSG" >> "$LOG_FILE"
                  break
              else
                  # Retry backoff with small jitter (5–10ms)
                  JITTER_MS=$((RANDOM % 6))
                  SLEEP_MS=$((5 + JITTER_MS))
                  echo "Upload failed for $GZIP_FILE (HTTP $HTTP_CODE), retrying in $SLEEP_MS milliseconds..."
                  echo "$(date '+%Y-%m-%d %H:%M:%S') [RETRY] $GZIP_FILE failed (HTTP $HTTP_CODE), sleeping $SLEEP_MS milliseconds" >> "$LOG_FILE"
                  sleep "0.$(printf '%03d' "$SLEEP_MS")"
                  RETRIES=$((RETRIES+1))
              fi
          done
          if [ $SUCCESS -eq 1 ]; then
              # Small post-success delay to avoid hammering the endpoint.
              # Use milliseconds (2–5ms) via fractional seconds; supported by GNU/coreutils sleep.
              JITTER_SUCCESS_MS=$((RANDOM % 4))
              SLEEP_SUCCESS_MS=$((2 + JITTER_SUCCESS_MS))
              sleep "0.$(printf '%03d' "$SLEEP_SUCCESS_MS")"
              echo "$GZIP_FILE" >> "$UPLOADED_LIST"
              echo "Upload succeeded for $GZIP_FILE, path recorded in $UPLOADED_LIST"
              echo "$(date '+%Y-%m-%d %H:%M:%S') [SUCCESS] $GZIP_FILE uploaded, path recorded in $UPLOADED_LIST" >> "$LOG_FILE"
          else
              echo "Upload failed for $GZIP_FILE after $MAX_RETRIES retries."
              echo "$(date '+%Y-%m-%d %H:%M:%S') [FAIL] $GZIP_FILE failed after $MAX_RETRIES retries" >> "$LOG_FILE"
              FAILED_UPLOADS+=("$GZIP_FILE")
          fi
      done
  done < <(find "$UNZIP_DIR" -mindepth 2 -maxdepth 2 -type d -print0)

  echo "All uploads complete. Successful uploads recorded in $RESULT_DIR"
  echo "Log file: $LOG_FILE"

  if [ "${#FAILED_UPLOADS[@]}" -gt 0 ]; then
      echo ""
      echo "Summary of failed uploads:"
      for FILE in "${FAILED_UPLOADS[@]}"; do
          echo "  $FILE"
      done
      echo ""
      echo "See $LOG_FILE for details."
  else
      echo "All files uploaded successfully."
  fi
  exit 0
fi

echo "Invalid operation: $OPERATION"
echo "Valid operations are: download, upload"
exit 1
