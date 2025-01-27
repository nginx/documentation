---
title: "Report usage to F5 in a disconnected environment"
date: 2024-10-14T14:29:40-07:00
# Change draft status to false to publish doc.
draft: false
# Assign weights in increments of 100
weight: 300
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1658"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

## Overview

In a disconnected environment without internet access, NGINX Plus sends usage data to NGINX Instance Manager. You’ll need to download the usage report from NGINX Instance Manager and submit it to F5 from a location with internet access. After F5 verifies the report, you can download the acknowledgement, which you must upload back to NGINX Instance Manager.

---

## Before you begin

Before submitting usage data to F5, first configure NGINX Plus to report telemetry data to NGINX Instance Manager.

### Configure NGINX Plus to report usage to NGINX Instance Manager

To configure NGINX Plus (R33 and later) to report usage data to NGINX Instance Manger:

{{< include "licensing-and-reporting/configure-nginx-plus-report-to-nim.md" >}}

---

## Submit usage report to F5 {#submit-usage-report}

{{< call-out "tip" "Using the REST API" "" >}}{{< include "nim/how-to-access-nim-api.md" >}}{{</call-out>}}

<br>

{{<tabs name="submit-usage-report">}}

{{%tab name="bash script (recommended)"%}}

### Submit usage report with a bash script

To submit a usage report in a disconnected environment, use the provided `license_usage_offline.sh` script. Run this script on a system that can access NGINX Instance Manager and connect to `https://product.apis.f5.com/` on port `443`. Replace each placeholder with your specific values.

<br>

1. {{<fa "download">}}[Download license_usage_offline.sh](/scripts/license_usage_offline.sh).
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
      -o report.zip \
      -s telemetry
    ```

    This command downloads the usage report (`report.zip`), submits the report to F5 for acknowledgment, and uploads the acknowledgment back to NGINX Instance Manager.

{{< include "nim/disconnected/license-usage-offline-script.md" >}}

{{%/tab%}}

{{%tab name="REST"%}}

### Submit usage report with curl

To submit a usage report using `curl`, complete each of the following steps in order.

Run these `curl` commands on a system that can access NGINX Instance Manager and connect to `https://product.apis.f5.com/` on port `443`. Replace each placeholder with your specific values.

{{<important>}}The `-k` flag skips SSL certificate validation. Use this only if your NGINX Instance Manager is using a self-signed certificate or if the certificate is not trusted by your system.{{</important>}}

1. **Prepare the usage report**:

    ```bash
    curl -k --location 'https://<NIM-FQDN>/api/platform/v1/report/download?format=zip&reportType=telemetry&telemetryAction=prepare' \
    --header 'accept: application/json' \
    --header 'authorization: Basic <base64-encoded-credentials>' \
    --header 'referer: https://<NIM-FQDN>/ui/settings/license'
    ``` 

1. **Download the usage report from NGINX Instance Manager**:

    ```bash  
    curl -k --location 'https://<NIM-FQDN>/api/platform/v1/report/download?format=zip&reportType=telemetry&telemetryAction=download' \
    --header 'accept: */*' \
    --header 'authorization: Basic <base64-encoded-credentials>' \
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

1. **Check the status of the usage acknowledgement**:

    Replace `<report-id>` with your specific ID from the previous response.

    ```bash
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/status/<report-id>' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)"
    ```

1. **Download the usage acknowledgement from F5**:

    ```bash
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/download/<report-id>' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)" \
    --output <path-to-acknowledgement>.zip
    ```

1. **Upload the usage acknowledgement to NGINX Instance Manager**:

    ```bash
    curl -k --location 'https://<NIM-FQDN>/api/platform/v1/report/upload' \
    --header 'Authorization: Basic <base64-encoded-credentials>' \
    --form 'file=@"<path-to-acknowledgement>.zip"'
    ```

{{%/tab%}}

{{%tab name="Web interface"%}}

### Submit usage report with the web interface

#### Download usage report

Download the usage report to send to F5:

- On the **License > Overview** page, select **Download License Report**. 

#### Submit usage report to F5

You need to submit the usage report to F5 and download the acknowledgment over REST. To do do, follow steps 3–5 in the [**REST**](#add-license-submit-initial-usage-report) tab in this section.

#### Upload the usage acknowledgement to NGINX Instance Manager

To upload the the usage acknowledgement:

1. On the **License > Overview** page, select **Upload Usage Acknowledgement**.
2. Upload the acknowledgement by selecting **Browse** or dragging the file into the form.
3. Select **Add**. 

{{%/tab%}}


{{</tabs>}}

---

## What’s reported {#telemetry}

{{< include "licensing-and-reporting/reported-usage-data.md" >}}

---

## Error log location and monitoring {#log-monitoring}

{{< include "licensing-and-reporting/log-location-and-monitoring.md" >}}