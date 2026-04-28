---
title: Report usage data to F5 (disconnected)
description: "Prepare and submit usage reports from NGINX Instance Manager to F5 in a disconnected (offline) environment using the provided bash script or REST API."
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

In a disconnected environment, NGINX Plus sends usage data to NGINX Instance Manager. Download the usage report from NGINX Instance Manager and submit it to F5 from a system with internet access. After F5 verifies the report, download the acknowledgement and upload it back to NGINX Instance Manager.

---

## Before you begin

Before submitting usage data to F5, configure NGINX Plus to report to NGINX Instance Manager.

### Configure NGINX Plus to report usage to NGINX Instance Manager

To configure NGINX Plus (R33 and later) to report usage data to NGINX Instance Manager:

{{< include "licensing-and-reporting/configure-nginx-plus-report-to-nim.md" >}}

---

## Submit usage report to F5 with NGINX Instance Manager 2.22 and later {#submit-usage-report}

{{< call-out "note" >}}Starting with NGINX Instance Manager 2.22, it's not possible to report usage with the REST API option.{{< /call-out >}}

{{<tabs name="submit-usage-report">}}

{{%tab name="bash script (recommended)"%}}

To submit the usage report in a disconnected environment, use the `offline_usage.sh` script. Run it on a system that can reach NGINX Instance Manager and connect to `https://product.connect.nginx.com/api/nginx-usage/batch` on port `443`. Replace each placeholder with your values.

Download the {{<icon "download">}}[offline_usage.sh](/scripts/offline_usage.sh) script and make it executable:

```shell
    chmod +x <PATH_TO_SCRIPT>/offline_usage.sh
```

### Download usage report

The download option takes these arguments:
- `<USERNAME>`: The admin username for NGINX Instance Manager authentication.
- `<PASSWORD>`: The admin password for NGINX Instance Manager authentication.
- `<NIM_IP_ADDRESS>`: The IP address of the NGINX Instance Manager instance.

And uses this environment variable:

| Variable | Description | Default value |
| --- | --- | --- |
| CURL_TIMEOUT | 30 | Connection timeout for curl requests in seconds |

To download the usage report from NGINX Instance Manager:

```shell
./offline_usage.sh download <USERNAME> <PASSWORD> <NIM_IP_ADDRESS>
``` 
1. The script verifies connectivity to NGINX Instance Manager over HTTPS.
1. Checks that the device is in DISCONNECTED mode (exits with an error if mode is CONNECTED).
1. Downloads the usage report as a ZIP file to `/tmp/response.zip`.

### Upload usage report

To upload the usage acknowledgment to NGINX One Console:

```shell
./offline_usage.sh upload <FILE_PATH> --result-dir <DIR> [--endpoint-url <URL>]
```
Where:

| Argument | Description | Required |
| --- | --- | --- |
| `<FILE_PATH>` | The path to the usage acknowledgment ZIP file downloaded using the `download` operation. | Yes |
| --result-dir, -r <DIR> | Directory used to track uploaded files and store unzipped contents. | Yes |
| --endpoint-url, -e <URL> | Upload endpoint URL. Default: https://product.connect.nginx.com/api/nginx-usage/batch | No |

The script provides the following output:

| File | Description |
| --- | --- |
| `<RESULT_DIR>/uploaded_files.txt` | A text file containing the names of the successfully uploaded files. |
| `<RESULT_DIR>/unzip/` | Extracted contents of the usage report |
| `<RESULT_DIR>/upload_usage.log` | Detailed log of all upload attempts (in CWD) |

And returns one of the following exit codes:

| Code | Description |
| --- | --- |
| 0 | Operation completed successfully |
| 1 | Error — missing arguments, connectivity failure, invalid file, wrong device mode, or upload failure |

{{%/tab%}}

{{%tab name="Web interface"%}}

Download the usage report from `https://<NIM_FQDN>/ui/nginx-plus`. Replace `<NIM_FQDN>` with your NGINX Instance Manager's fully qualified domain name.

Move the file to a system with internet access and run the script with the upload option.

{{< call-out "note" "Behavior change" >}}In NGINX Instance Manager 2.22 and later, you don't need to re-upload the usage acknowledgement file to NGINX Instance Manager.{{< /call-out >}}

{{%/tab%}}

{{</tabs>}}

{{< call-out "note" "File size increase" >}}NGINX Instance Manager 2.22 and later report raw data instead of aggregated usage data. File sizes will be larger than before.{{< /call-out >}}

---

## Submit usage report to F5 with NGINX Instance Manager 2.21 and earlier {#submit-usage-report-2.21}

{{< call-out "tip" "Using the REST API" "" >}}{{< include "nim/how-to-access-nim-api.md" >}}{{</call-out>}}

<br>

{{<tabs name="submit-usage-report-2-21">}}

{{%tab name="bash script (recommended)"%}}

### Submit usage report with a bash script

To submit a usage report in a disconnected environment, use the `license_usage_offline.sh` script. Run it on a system that can reach NGINX Instance Manager and connect to `https://product.apis.f5.com/` on port `443`. Replace each placeholder with your values.

<br>

1. {{<icon "download">}}[Download license_usage_offline.sh](/scripts/license_usage_offline.sh).
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
      -s telemetry
    ```

    This command downloads the usage report (`report.zip`), submits it to F5 for acknowledgment, and uploads the acknowledgment back to NGINX Instance Manager.

{{< include "nim/disconnected/license-usage-offline-script.md" >}}

{{%/tab%}}

{{%tab name="REST"%}}

### Submit usage report with curl

To submit a usage report using `curl`, complete each step in order.

Run these commands on a system that can reach NGINX Instance Manager and connect to `https://product.apis.f5.com/` on port `443`. Replace each placeholder with your values.

{{< call-out "important" >}}The `-k` flag skips SSL certificate validation. Use this only if your NGINX Instance Manager is using a self-signed certificate or if the certificate is not trusted by your system.{{< /call-out >}}

1. **Prepare the usage report**:

    ```shell
    curl -k --location 'https://<NIM_FQDN>/api/platform/v1/report/download?format=zip&reportType=telemetry&telemetryAction=prepare' \
    --header 'accept: application/json' \
    --header 'authorization: Basic <BASE64_ENCODED_CREDENTIALS>' \
    --header 'referer: https://<NIM_FQDN>/ui/settings/license'
    ```

1. **Download the usage report from NGINX Instance Manager**:

    ```shell
    curl -k --location 'https://<NIM_FQDN>/api/platform/v1/report/download?format=zip&reportType=telemetry&telemetryAction=download' \
    --header 'accept: */*' \
    --header 'authorization: Basic <BASE64_ENCODED_CREDENTIALS>' \
    --output report.zip
    ```

1. **Submit the usage report to F5 for verification**:

    ```shell
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)" \
    --form 'file=@"<PATH_TO_REPORT>.zip"'
    ```

    After running this command, find the `statusLink` in the response. The `report-id` is the UUID at the end of the `statusLink` value. For example:

      ```json
      {"statusLink":"/status/2214e480-3401-43a3-a54c-9dc501a01f83"}
      ```

    In this example, the `report-id` is `2214e480-3401-43a3-a54c-9dc501a01f83`. Use your `report-id` in the following steps.

1. **Check the status of the usage acknowledgement**:

    Replace `<REPORT_ID>` with your specific ID from the previous response.

    ```shell
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/status/{report_id}' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)"
    ```

1. **Download the usage acknowledgement from F5**:

    ```shell
    curl --location 'https://product.apis.f5.com/ee/v1/entitlements/telemetry/bulk/download/{report_id}' \
    --header "Authorization: Bearer $(cat /path/to/jwt-file)" \
    --output <PATH_TO_ACKNOWLEDGEMENT>.zip
    ```

1. **Upload the usage acknowledgement to NGINX Instance Manager**:

    ```shell
    curl -k --location 'https://<NIM_FQDN>/api/platform/v1/report/upload' \
    --header 'Authorization: Basic <BASE64_ENCODED_CREDENTIALS>' \
    --form 'file=@"<PATH_TO_ACKNOWLEDGEMENT>.zip"'
    ```

{{%/tab%}}

{{%tab name="Web interface"%}}

### Submit usage report with the web interface

#### Download usage report

On the **License > Overview** page, select **Download License Report**.

#### Submit usage report to F5

To submit the report and download the acknowledgment, follow steps 3–5 in the [**REST**](#add-license-submit-initial-usage-report) tab.

#### Upload the usage acknowledgement

1. On the **License > Overview** page, select **Upload Usage Acknowledgement**.
1. Select **Browse** or drag the file into the form.
1. Select **Add**.

{{%/tab%}}


{{</tabs>}}

---

## What’s reported {#telemetry}

{{< include "licensing-and-reporting/reported-usage-data.md" >}}

---

## Error log location and monitoring {#log-monitoring}

{{< include "licensing-and-reporting/nim-service-log-location.md" >}}

Monitor the following log prefixes to identify issues generating and exporting offline usage reports.

**`[OfflineAggregator]`** — offline usage report packaging:

```text
[error] [OfflineAggregator] PullSubscribe failed consumer=<name>: <error>
[error] [OfflineAggregator] error fetching messages: <error>
[error] [OfflineAggregator] error processing message msg_index=<i>: <error> (skipping)
[warn]  [OfflineAggregator] proto.Unmarshal failed: <error> (data_len=<n>)
[warn]  [OfflineAggregator] message silently dropped (likely proto unmarshal failure) msg_index=<i>
[error] [OfflineAggregator] failed to delete stale consumer=<name>: <error>
[info]  [OfflineAggregator] aggregation complete: total_directories=<n> total_processed=<n> ...
[info]  [OfflineAggregator] empty fetch attempt <n>/<max> (total_processed_so_far=<n>)
[info]  [OfflineAggregator] <n> consecutive empty fetches, stream exhausted
```

{{< include "licensing-and-reporting/log-location-and-monitoring.md" >}}
