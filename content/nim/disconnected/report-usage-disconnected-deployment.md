---
title: Report usage data to F5 (disconnected)
weight: 300
toc: true
nd-docs: DOCS-1658
nd-personas:
- devops
- netops
- secops
- support
nd-content-type: how-to
nd-product: NIMNGR
---

## Overview

In a disconnected environment without internet access, NGINX Plus sends usage data to NGINX Instance Manager. You’ll need to download the usage report from NGINX Instance Manager and submit it to F5 from a location with internet access. After F5 verifies the report, you can download the acknowledgement, which you must upload back to NGINX Instance Manager.

---

## Before you begin

Before submitting usage data to F5, first configure NGINX Plus to report telemetry data to NGINX Instance Manager.

### Configure NGINX Plus to report usage to NGINX Instance Manager

To configure NGINX Plus (R33 and later) to report usage data to NGINX Instance Manager:

{{< include "licensing-and-reporting/configure-nginx-plus-report-to-nim.md" >}}

---

## Submit usage report to F5 with NGINX Instance Manager 2.22 and later {#submit-usage-report}

{{< call-out "note" >}}Starting with NGINX Instance Manager 2.22, it's not possible to report usage with the REST API option.{{< /call-out >}}

{{<tabs name="submit-usage-report">}}

{{%tab name="bash script (recommended)"%}}

To submit the usage report in a disconnected environment, use the provided `offline_usage.sh` script. Run this script on a system that can access NGINX Instance Manager and connect to the `https://product.connect.nginx.com/api/nginx-usage/batch` on port `443`. Replace each placeholder with your specific values.

Download the {{<icon "download">}}[offline_usage.sh](/scripts/offline_usage.sh) script and make the script executable:

```shell
    chmod +x <PATH-TO-SCRIPT>/offline_usage.sh
```

### Download usage report

The download feature of the script takes the following arguments:
- `<USERNAME>`: The admin username for NGINX Instance Manager authentication.
- `<PASSWORD>`: The admin password for NGINX Instance Manager authentication.
- `<NIM-IP-ADDRESS>`: The IP address of the NGINX Instance Manager instance.

And uses the following environment variable:

| Variable | Description | Default value |
| --- | --- | --- |
| CURL_TIMEOUT | 30 | Connection timeout for curl requests in seconds |

To download the usage report from NGINX Instance Manager, run the following command:

```shell
./offline_usage.sh download <USERNAME> <PASSWORD> <NIM-IP-ADDRESS>
``` 
1. The script verifies connectivity to the NGINX Instance Manager instance over HTTPS.
1. Checks that the device is in DISCONNECTED mode (exits with an error if mode is CONNECTED).
1. Downloads the usage report as a ZIP file to `/tmp/response.zip`.

### Upload usage report

To upload the usage acknowledgment to NGINX One Console, run the following command:

```shell
./offline_usage.sh upload <FILE-PATH> --result-dir <DIR> [--endpoint-url <URL>]
```
Where:

| Argument | Description | Required |
| --- | --- | --- |
| `<FILE-PATH>` | The path to the usage acknowledgment ZIP file downloaded using the `download` operation. | Yes |
| --result-dir, -r <DIR> | Directory used to track uploaded files and store unzipped contents. | Yes |
| --endpoint-url, -e <URL> | Upload endpoint URL. Default: https://product.connect.nginx.com/api/nginx-usage/batch | No |

The script provides the following output:

| File | Description |
| --- | --- |
| `<RESULT-DIR>/uploaded_filex.txt` | A text file containing the names of the succesfully uploaded files. |
| `<RESULT-DIR>/unzip/` | Extracted contents of the usage report |
| `<RESULT-DIR>/upload_usage.log` | Detailed log of all upload attempts (in CWD) |

And returns one the following exit codes:

| Code | Description |
| --- | --- |
| 0 | Operation completed successfully |
| 1 | Error — missing arguments, connectivity failure, invalid file, wrong device mode, or upload failure |

{{%/tab%}}

{{%tab name="Web interface"%}}

Download usage report from the `https://<NIM_FQDN>/ui/nginx-plus` page. Replace `<NIM_FQDN>` with your NGINX Instance Manager's fully qualified domain name.

Move the file to a machine with internet access, run the bash script with upload option.

{{< call-out "note" "Behavior change" >}}Starting with NGINX Instance Manager 2.22, it's not necessary to reupload the usage acknowledgement file back to NGINX Instance Manager.{{< /call-out >}}

{{%/tab%}}

{{</tabs>}}

{{< call-out "note" "File size increase" >}}NGINX Instance Manager 2.22 and later have moved from reporting aggregated usage data to reporting the raw data that data planes send; the file sizes will be larger than before.{{< /call-out >}}

---

## Submit usage report to F5 with NGINX Instance Manager 2.21 and earlier {#submit-usage-report-2.21}

{{< call-out "tip" "Using the REST API" "" >}}{{< include "nim/how-to-access-nim-api.md" >}}{{</call-out>}}

<br>

{{<tabs name="submit-usage-report-2-21">}}

{{%tab name="bash script (recommended)"%}}

### Submit usage report with a bash script

To submit a usage report in a disconnected environment, use the provided `license_usage_offline.sh` script. Run this script on a system that can access NGINX Instance Manager and connect to `https://product.apis.f5.com/` on port `443`. Replace each placeholder with your specific values.

<br>

1. {{<icon "download">}}[Download license_usage_offline.sh](/scripts/license_usage_offline.sh).
1.	Run the following command to allow the script to run:

    ```shell
    chmod +x <path-to-script>/license_usage_offline.sh
    ```

1. Run the script. Replace each placeholder with your specific values:

    ```shell
    ./license_usage_offline.sh \
      -j <license-filename>.jwt \
      -i <NIM-IP-address> \
      -u admin \
      -p <password> \
      -s telemetry
    ```

    This command downloads the usage report (`report.zip`), submits the report to F5 for acknowledgment, and uploads the acknowledgment back to NGINX Instance Manager.

{{< include "nim/disconnected/license-usage-offline-script.md" >}}

{{%/tab%}}

{{%tab name="REST"%}}

### Submit usage report with curl

To submit a usage report using `curl`, complete each of the following steps in order.

Run these `curl` commands on a system that can access NGINX Instance Manager and connect to `https://product.apis.f5.com/` on port `443`. Replace each placeholder with your specific values.

{{< call-out "important" >}}The `-k` flag skips SSL certificate validation. Use this only if your NGINX Instance Manager is using a self-signed certificate or if the certificate is not trusted by your system.{{< /call-out >}}

1. **Prepare the usage report**:

    ```shell
    curl -k --location 'https://<NIM-FQDN>/api/platform/v1/report/download?format=zip&reportType=telemetry&telemetryAction=prepare' \
    --header 'accept: application/json' \
    --header 'authorization: Basic <base64-encoded-credentials>' \
    --header 'referer: https://<NIM-FQDN>/ui/settings/license'
    ```

1. **Download the usage report from NGINX Instance Manager**:

    ```shell
    curl -k --location 'https://<NIM-FQDN>/api/platform/v1/report/download?format=zip&reportType=telemetry&telemetryAction=download' \
    --header 'accept: */*' \
    --header 'authorization: Basic <base64-encoded-credentials>' \
    --output report.zip
    ```

1. **Submit the usage report to F5 for verification**:

    ```shell
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

    ```shell
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/status/<report-id>' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)"
    ```

1. **Download the usage acknowledgement from F5**:

    ```shell
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/download/<report-id>' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)" \
    --output <path-to-acknowledgement>.zip
    ```

1. **Upload the usage acknowledgement to NGINX Instance Manager**:

    ```shell
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
