---
title: Add a license (disconnected)
draft: false
description: ''
weight: 200
toc: true
nd-docs: DOCS-1657
personas:
- devops
- netops
- secops
- support
type:
- how-to
---

## Overview

This guide shows you how to add a license to NGINX Instance Manager in a disconnected (offline) environment. In this setup, systems don’t have internet access. You’ll download and apply your subscription’s JSON Web Token (JWT) license, then verify your entitlements with F5.

{{< call-out "tip" "Using the REST API" "" >}}{{< include "nim/how-to-access-nim-api.md" >}}{{</ call-out >}}


## Before you begin

### Set the operation mode to disconnected

To configure NGINX Instance Manager for a disconnected environment, you need to set the `mode_of_operation` to `disconnected` in the configuration file.

{{< include "nim/disconnected/set-mode-of-operation-disconnected.md" >}}

### Download the JWT license from MyF5 {#download-license}

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}


<br>

## Add license and submit initial usage report {#add-license-submit-initial-usage-report}


{{< tabs name="submit-usage-report" >}}

{{%tab name="Bash script (recommended)"%}}

### Add license and submit initial usage report with a bash script

To add a license and submit the initial usage report in a disconnected environment, use the provided `license_usage_offline.sh` script. Run this script on a system that can access NGINX Instance Manager and connect to `https://product.apis.f5.com/` on port `443`. Replace each placeholder with your specific values.

**Important**: The script to add a license won't work if a license has already been added.

<br>

1. {{<icon "download">}}[Download license_usage_offline.sh](/scripts/license_usage_offline.sh).
1.	Run the following command to allow the script to run:

    ```bash
    chmod +x <path-to-script>/license_usage_offline.sh
    ```

1. Run the script. Replace each placeholder with your specific values:

    ``` bash
    ./license_usage_offline.sh \
      -j <license-filename>.jwt \
      -i <NIM-IP-address> \
      -u admin \
      -p <password> \
      -s initial
    ```

    This command adds the license, downloads the initial usage report (`report.zip`), submits the report to F5 for acknowledgment, and uploads the acknowledgment back to NGINX Instance Manager.

{{< include "nim/disconnected/license-usage-offline-script.md" >}}

{{%/tab%}}

{{%tab name="REST"%}}

### Add license and submit initial usage report with curl

To license NGINX Instance Manager, complete each of the following steps in order.

**Important**: The `curl` command to add a license won't work if a license has already been added.

Run these `curl` commands on a system that can access NGINX Instance Manager and connect to `https://product.apis.f5.com/` on port `443`. Replace each placeholder with your specific values.

{{< call-out "important" >}}The `-k` flag skips SSL certificate validation. Use this only if your NGINX Instance Manager is using a self-signed certificate or if the certificate is not trusted by your system.{{< /call-out >}}

1. **Add the license to NGINX Instance Manager**:

    ``` bash
    curl -k --location 'https://<NIM-FQDN>/api/platform/v1/license?telemetry=true' \
    --header 'Origin: https://<NIM-FQDN>' \
    --header 'Referer: https://<NIM-FQDN>/ui/settings/license' \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Basic <base64-encoded-credentials>' \
    --data '{
      "metadata": {
        "name": "license"
      },
      "desiredState": {
        "content": "<JSON-web-token>"
      }
    }'
    ```

1. **Poll the license status on NGINX Instance Manager**:

   Use this command to check the current license status. Look for `INITIALIZE_ACTIVATION_COMPLETE` or `CONFIG_REPORT_READY` in the status field. Poll periodically if necessary.

    ```bash
    curl -k "https://<NIM-FQDN>/api/platform/v1/license" \
    --header "accept: application/json" \
    --header "authorization: Basic <base64-encoded-credentials>" \
    --header "referer: https://<NIM-FQDN>/ui/settings/license"
    ```

1. **Update the license configuration on NGINX Instance Manager (not required in 2.20 or later)**:

   This step ensures that the license configuration is fully applied.

    ```bash
    curl -k --location --request PUT "https://<NIM-FQDN>/api/platform/v1/license?telemetry=true" \
    --header "Origin: https://<NIM-FQDN>" \
    --header "Referer: https://<NIM-FQDN>/ui/settings/license" \
    --header "Content-Type: application/json" \
    --header "Authorization: Basic <base64-encoded-credentials>" \
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
    }'
    ```

1. **Download the initial usage report**:

    ```bash
    curl -k --location 'https://<NIM-FQDN>/api/platform/v1/report/download?format=zip&reportType=initial' \
    --header 'accept: */*' \
    --header 'Authorization: Basic <base64-encoded-credentials>' \
    --output report.zip
    ```

1. **Submit the usage report to F5 for verification**:

    ```bash
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)" \
    --form 'file=@"<path-to-report>.zip"'
    ```

    After running this command, look for the "statusLink" in the response. The `report-id` is the last part of the "statusLink" value (the UUID). For example:

      ```json
      {"statusLink":"/status/2214e480-3401-43a3-a54c-9dc501a01f83"}
      ```

    In this example, the `report-id` is `2214e480-3401-43a3-a54c-9dc501a01f83`.

    You’ll need to use your specific `report-id` in the following steps.

2. **Check the status of the usage acknowledgment**:

    Replace `<report-id>` with your specific ID from the previous response.

    ``` bash
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/status/<report-id>' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)"
    ```

3. **Download the usage acknowledgement from F5**:

    ``` bash
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/download/<report-id>' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)" \
    --output <path-to-acknowledgement>.zip
    ```

4. **Upload the usage acknowledgement to NGINX Instance Manager**:

    ``` bash
    curl -k --location 'https://<NIM-FQDN>/api/platform/v1/report/upload' \
    --header 'Authorization: Basic <base64-encoded-credentials>' \
    --form 'file=@"<path-to-acknowledgement>.zip"'
    ```

{{%/tab%}}

{{%tab name="Web interface"%}}

### Add license and submit initial usage report with the web interface

#### Add license

To add a license:

{{< include "nim/admin-guide/license/add-license-webui.md" >}}

#### Download initial usage report

Download the initial usage report to send to F5:

- On the **License > Overview** page, select **Download License Report**.


#### Submit usage report to F5

You need to submit the usage report to F5 and download the acknowledgment over REST. To do do, follow steps 5–7 in the [**REST**](#add-license-submit-initial-usage-report) tab in this section.

#### Upload the usage acknowledge to NGINX Instance Manager

To upload the the usage acknowledgement:

1. On the **License > Overview** page, select **Upload Usage Acknowledgement**.
2. Upload the acknowledgement by selecting **Browse** or dragging the file into the form.
3. Select **Add**.

{{%/tab%}}


{{</tabs>}}
