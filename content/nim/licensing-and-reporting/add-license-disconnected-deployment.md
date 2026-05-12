---
title: Add a license (disconnected)
description: "Download a JWT license from MyF5 and apply it to F5 NGINX Instance Manager in a disconnected (offline) environment."
weight: 200
toc: true
f5-content-type: how-to
f5-product: NIMNGR
f5-docs: DOCS-1657
f5-summary: >
  Download a JWT license from MyF5 and apply it to F5 NGINX Instance Manager in a disconnected (offline) environment to unlock all features.
  In a disconnected environment, the license is applied manually and usage reports are submitted to F5 separately from a system with internet access.
---

## Overview

In a disconnected environment, systems don't have internet access. You'll download and apply your JSON Web Token (JWT) license to F5 NGINX Instance Manager, then verify your entitlements with F5.

{{< call-out "note" "NGINX Instance Manager 2.22 and later" >}}Starting with version 2.22, NGINX Instance Manager no longer requires a JWT license. All features are available immediately after installation. If you're running version 2.21 or earlier, follow the steps on this page.{{< /call-out >}}

{{< call-out "tip" "Using the REST API" "" >}}{{< include "nim/how-to-access-nim-api.md" >}}{{</ call-out >}}

## Before you begin

### Set the operation mode to disconnected

To set up NGINX Instance Manager for a disconnected environment, set `mode_of_operation` to `disconnected` in the configuration file.

{{< include "nim/disconnected/set-mode-of-operation-disconnected.md" >}}

### Download the JWT license from MyF5 {#download-license}

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

## Add license and submit initial usage report {#add-license-submit-initial-usage-report}

{{< tabs name="submit-usage-report" >}}

{{%tab name="Bash script (recommended)"%}}

### Add license and submit initial usage report with a bash script

To add a license and submit the initial usage report in a disconnected environment, use the `license_usage_offline.sh` script. Run this script on a system that can connect to NGINX Instance Manager and to `https://product.apis.f5.com/` on port `443`. Replace each placeholder with your specific values.

{{< call-out "important" >}} The script won't work if you've already added a license. {{< /call-out >}}

1. {{<icon "download">}} [Download license_usage_offline.sh](/scripts/license_usage_offline.sh).
1.	Run the following command to allow the script to run:

    ```shell
    chmod +x <PATH_TO_SCRIPT>/license_usage_offline.sh
    ```

1. Run the script. Replace each placeholder with your specific values:

    ```shell
    ./license_usage_offline.sh \
      -j <LICENSE_FILENAME>.jwt \
      -i <NIM_IP_ADDRESS> \
      -u admin \
      -p <PASSWORD> \
      -s initial
    ```

    This command adds the license, downloads the initial usage report (`report.zip`), submits the report to F5 for acknowledgment, and uploads the acknowledgment back to NGINX Instance Manager.

{{< include "nim/disconnected/license-usage-offline-script.md" >}}

{{%/tab%}}

{{%tab name="REST"%}}

### Add license and submit initial usage report with curl

To license NGINX Instance Manager, complete each of the following steps in order.

{{< call-out "important" >}} This command won't work if you've already added a license. {{< /call-out >}}

Run these `curl` commands on a system that can connect to NGINX Instance Manager and to `https://product.apis.f5.com/` on port `443`. Replace each placeholder with your specific values.

{{< call-out "important" "TLS certificate validation">}} The -k flag skips SSL certificate validation. Use this only if your NGINX Instance Manager is using a self-signed certificate or if the certificate is not trusted by your system. {{< /call-out >}}

1. **Add the license to NGINX Instance Manager**:

    ```shell
    curl -k --location 'https://<NIM_FQDN>/api/platform/v1/license?telemetry=true' \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Basic <BASE64_ENCODED_CREDENTIALS>' \
    --data '{
      "metadata": {
        "name": "license"
      },
      "desiredState": {
        "content": "<JSON_WEB_TOKEN>"
      }
    }'
    ```

1. **Poll the license status on NGINX Instance Manager**:

   Use this command to check the current license status. Look for `INITIALIZE_ACTIVATION_COMPLETE` or `CONFIG_REPORT_READY` in the status field. Poll periodically if necessary.

    ```shell
    curl -k "https://<NIM_FQDN>/api/platform/v1/license" \
    --header "accept: application/json" \
    --header "authorization: Basic <BASE64_ENCODED_CREDENTIALS>"
    ```

1. **Update the license configuration on NGINX Instance Manager (not required in 2.20 or later)**:

   This fully applies the license configuration.

    ```shell
    curl -k --location --request PUT "https://<NIM_FQDN>/api/platform/v1/license?telemetry=true" \
    --header "Content-Type: application/json" \
    --header "Authorization: Basic <BASE64_ENCODED_CREDENTIALS>" \
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

    ```shell
    curl -k --location 'https://<NIM_FQDN>/api/platform/v1/report/download?format=zip&reportType=initial' \
    --header 'accept: */*' \
    --header 'Authorization: Basic <BASE64_ENCODED_CREDENTIALS>' \
    --output report.zip
    ```

1. **Submit the usage report to F5 for verification**:

    ```shell
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)" \
    --form 'file=@"<PATH_TO_REPORT>.zip"'
    ```

    After running this command, look for the "statusLink" in the response. The `report-id` is the last part of the "statusLink" value (the UUID). For example:

      ```json
      {"statusLink":"/status/2214e480-3401-43a3-a54c-9dc501a01f83"}
      ```

    In this example, the `report-id` is `2214e480-3401-43a3-a54c-9dc501a01f83`.

    Use your specific `report-id` in the following steps.

2. **Check the status of the usage acknowledgment**:

    Replace `<REPORT_ID>` with your specific ID from the previous response.

    ```shell
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/status/{report_id}' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)"
    ```

3. **Download the usage acknowledgement from F5**:

    ```shell
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/download/{report_id}' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)" \
    --output <PATH_TO_ACKNOWLEDGEMENT>.zip
    ```

4. **Upload the usage acknowledgement to NGINX Instance Manager**:

    ```shell
    curl -k --location 'https://<NIM_FQDN>/api/platform/v1/report/upload' \
    --header 'Authorization: Basic <BASE64_ENCODED_CREDENTIALS>' \
    --form 'file=@"<PATH_TO_ACKNOWLEDGEMENT>.zip"'
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

Submit the usage report to F5 and download the acknowledgment over REST. Follow steps 5–7 on the [REST](#add-license-submit-initial-usage-report) tab.

#### Upload the usage acknowledgement to NGINX Instance Manager

To upload the usage acknowledgement:

1. On the **License > Overview** page, select **Upload Usage Acknowledgement**.
2. Select **Browse** or drag the file into the form.
3. Select **Add**.

{{%/tab%}}

{{</tabs>}}