---
title: View recent NGINX usage
description: "View raw, per-record NGINX usage telemetry in NGINX Instance Manager to verify billing data and support compliance audits."
weight: 350
toc: true
f5-docs:
f5-personas:
- devops
- netops
- secops
- support
f5-content-type: how-to
f5-product: NGINX Instance Manager
f5-summary: >
  View and export raw, unaggregated NGINX usage telemetry for NGINX Plus, NGINX Ingress Controller, and NGINX Gateway Fabric instances in NGINX Instance Manager.
  This audit-grade record view lets you independently verify billing data and support compliance reviews, separately from the usage reports NGINX Instance Manager sends to F5.
---

## Overview

The **Recent Usage** screen shows the raw usage telemetry that F5 NGINX Instance Manager collects from your instances. This includes F5 NGINX Plus, F5 NGINX Ingress Controller, and F5 NGINX Gateway Fabric.

Each row is one telemetry record, exactly as your instance reported it. NGINX Instance Manager doesn't aggregate or transform records. Use this screen to independently verify the data behind your F5 billing and to support compliance audits.

This screen doesn't require NGINX Agent. Your instances report usage data directly.

### Instances and Clusters views

The screen has two views:

- **Instances**: Shows records from standalone NGINX Plus instances running on VMs or bare metal.
- **Clusters**: Shows records from NGINX deployments running in Kubernetes, including NGINX Ingress Controller and NGINX Gateway Fabric.

By default, the screen shows the last 7 days of records, sorted by end time with the most recent first. Records are available for the last 120 days by default. You can change this retention window. See [Configure the retention window](#configure-the-retention-window).

---

## Before you begin

Before you view usage records, make sure you have:

- **NGINX Plus R33 or later**: NGINX Plus R33 and later include the `ngx_mgmt_module` module. Earlier versions can't report usage to NGINX Instance Manager.
- **NGINX Plus configured to report usage**: Each NGINX Plus instance needs the `usage_report` directive set to your NGINX Instance Manager host. See [Configure NGINX Plus to report usage to NGINX Instance Manager]({{< ref "nim/licensing-and-reporting/report-usage-connected-deployment.md#configure-nginx-plus-to-report-usage-to-nginx-instance-manager" >}}).
- **The NGINX Plus Usage permission**: Your user account needs this RBAC permission to view usage records in the dashboard or through the API.

---

## View and filter usage records

### View records in the dashboard

To view raw usage records:

1. Log in to NGINX Instance Manager (`https://<NIM_FQDN>/ui/`).
2. In the left navigation, select **Usage**, then select **Recent Usage**.
3. Select the **Instances** or **Clusters** tab.

By default, the dashboard shows records from the last 7 days, sorted by end time with the most recent first.

{{< call-out class="note" title="Note: Fields not shown in the table" >}}
The dashboard's summary table does not display every field from a usage record — for example, reporting start time. Select a row to view the full record, including fields not shown as table columns.
{{< /call-out >}}

### View record details

Select a row to open a side panel showing all fields for that record.

### Filter records

Select **Add Filter** to narrow your results by:

{{<table>}}
| Filter | Description |
|---|---|
| Date range | Filters by reporting end time. Defaults to the last 7 days. Maximum range is 365 days. |
| NGINX Instance ID | Filters by a specific NGINX instance UUID. |
| Cluster ID | Filters by a Kubernetes cluster UUID. Available on the **Clusters** tab only. |
| Product type | Filters by product: NGINX Plus, NGINX Ingress Controller, NGINX Gateway Fabric, or Unspecified. Select multiple types. |
| Subscription token | Filters by JWT token ID (`jti`). |
{{</table>}}

#### Find filter values

If you don't already have the identifiers used in these filters:

- **NGINX Instance ID**: NGINX Plus stores this in `/var/lib/nginx/nginx.id` on each instance. You can also find it in the **NGINX UID** column, or by selecting a row to open the detail panel.
- **Cluster ID**: Visible in the **K8s Cluster ID** column on the Clusters tab. NGINX Ingress Controller and NGINX Gateway Fabric generate this ID at installation and store it in the deployment's Kubernetes secret.
- **Subscription token (jti)**: A claim inside your subscription JWT (`license.jwt`). Paste the JWT contents into [jwt.io](https://jwt.io) and look for the `jti` field. You can also find it in the **JWT ID** column.

### Export records as CSV

To export usage records for offline auditing or compliance:

1. Apply the filters you need.
2. Select **Export CSV**.

The CSV file downloads with all records matching your current filters. Field values in the export match the raw stored data exactly, with no rounding or aggregation.

(Optional) If the export is slow, apply additional filters to narrow the result set before exporting.

The following table lists which columns appear in each tab's CSV export.

{{<table>}}
| Field | Instances tab | Clusters tab |
|---|---|---|
| `nginx_uid` | Yes | Yes |
| `product_type` | Yes | Yes |
| `nginx_version` | Yes | Yes |
| `start_time` | Yes | Yes |
| `end_time` | Yes | Yes |
| `nap` | Yes | Yes |
| `jwt_token_id` | Yes | Yes |
| `jwt_expiration` | Yes | Yes |
| `jwt_order_type` | Yes | Yes |
| `workers` | Yes | Yes |
| `user_agent` | Yes | Yes |
| `uptime` | Yes | Yes |
| `reloads` | Yes | Yes |
| `installation_id` | No | Yes |
| `cluster_id` | No | Yes |
| `cluster_node_count` | No | Yes |
{{</table>}}

{{< call-out class="note" title="Note: If your export is truncated" >}}
See [CSV export produces a truncated file](#csv-export-produces-a-truncated-file).
{{< /call-out >}}

---

## Configure the retention window

NGINX Instance Manager automatically removes usage records older than the configured retention period. A background job runs once at startup and then every 24 hours to purge expired records.

{{<table>}}
| Setting | Value |
|---|---|
| Default retention | 120 days |
| Allowed range | 0–365 days |
| Configuration key | `nginx_raw_usage_retention_days` (under `dpm:`) |
{{</table>}}

To change the retention period:

1. Open `/etc/nms/nms.conf` on the NGINX Instance Manager server.
2. Add or update the setting under the `dpm:` block:

    ```yaml
        dpm:
        nginx_raw_usage_retention_days: 180
    ```

3. Restart NGINX Instance Manager:

    ```shell
        sudo systemctl restart nms
    ```

{{< call-out class="important" title="Important: Retention value limits" >}}
NGINX Instance Manager normalizes retention values on startup. It caps any value above 365 to 365 and ignores negative values, falling back to the default (120 days) instead. A value of 0 blocks local storage: NGINX Instance Manager doesn't write new records and purges existing records on the next run. This doesn't affect usage reporting to F5.
{{< /call-out >}}

If NGINX Instance Manager clamps or rejects your configured value, it logs a `[RAW-USAGE]` warning so you can confirm the value wasn't used as entered.

### Estimate storage for extended retention

{{< call-out class="important" title="Important: Content pending" >}}
Blocked on storage-size-per-instance figures from engineering (TECHDOCS-5506 open items, and the companion tech-specs.md ticket). Do not publish this page until this subsection is filled in — the story explicitly calls for covering 4–12 month retention, and customers extending retention need this to plan disk capacity.
{{< /call-out >}}

Storage usage grows with the number of NGINX instances reporting and the length of your retention window. Each instance generates approximately one record per hour.

<!-- TODO: Add a per-instance-count, per-retention-period storage table once engineering delivers sizing figures. Mirror the format of the "Sizing benchmarks for storage" tables in fundamentals/tech-specs.md. -->

---

## Validate a record from the CLI

{{< call-out class="important" title="Important: Content pending" >}}
Blocked on CLI validation commands from engineering (Kamal Chaturvedi or Amardeep Chawla — TECHDOCS-5506 open items). The runbook's REST API list/filter examples are a reasonable starting point, but the ticket specifically calls for validating a record's Cluster ID and nginx_uid for Kubernetes deployments, which needs a worked example we don't have — for example, confirming a cluster's ID from a running NGINX Gateway Fabric deployment and cross-checking it against a record returned by the API.
{{< /call-out >}}

<!-- TODO: Draft once engineering confirms CLI/API steps for correlating a specific record (particularly Cluster ID and nginx_uid for Kubernetes deployments) against on-instance state. -->

---

## What's shown

{{<table>}}
| Field | Description |
|---|---|
| NGINX Instance ID | UUID identifying the NGINX instance. |
| Product type | NGINX Plus, NGINX Ingress Controller, NGINX Gateway Fabric, or Unspecified. |
| NGINX version | The NGINX version string, for example `1.29.8`. |
| Reporting window | Start and end timestamps of the reporting period. |
| F5 WAF status | Whether F5 WAF for NGINX is active or inactive. |
| Subscription token | JWT token ID (`jti`) and expiration date. |
| Workers | Number of active NGINX worker processes. |
| Uptime | Seconds since the last NGINX restart. |
| Reloads | Number of configuration reloads during the reporting period. |
| Cluster ID | Kubernetes cluster identifier. Kubernetes deployments only. |
| Cluster node count | Number of nodes in the Kubernetes cluster. Kubernetes deployments only. |
{{</table>}}

{{< call-out class="note" title="Note: No personally identifiable information" >}}
Usage records contain only UUIDs, timestamps, and numeric counters. They don't include hostnames, IP addresses, or other personally identifiable information.
{{< /call-out >}}

---

## How this differs from usage reporting to F5

The **Recent Usage** screen is a local, on-demand audit view. It's different from the usage reports NGINX Instance Manager automatically sends to F5 for billing.

{{<table>}}
| | **Recent Usage** screen | Usage reporting to F5 |
|---|---|---|
| Purpose | Local audit and verification | Billing and entitlement |
| Data | Raw, per-record, unaggregated | Aggregated for submission |
| Retention | Configurable, 0–365 days (120 default) | Not applicable |
| Where to configure | This page | [Report usage data to F5 (connected)]({{< ref "nim/licensing-and-reporting/report-usage-connected-deployment.md" >}}) or [Report usage data to F5 (disconnected)]({{< ref "nim/licensing-and-reporting/report-usage-disconnected-deployment.md" >}}) |
{{</table>}}

Viewing or exporting records on this screen doesn't affect usage reporting to F5. The two pipelines operate independently.

This screen works the same way in connected and disconnected deployments. Your instances keep reporting locally, and existing records stay fully browsable, even without internet access.

---

## Troubleshooting

### No records appear in the dashboard

**Symptom**: The usage dashboard shows no records.

**Cause**: One of the following:

- NGINX Plus isn't configured to report usage to NGINX Instance Manager.
- Your NGINX Plus version is earlier than R33.
- The date range filter is too narrow.
- Your account doesn't have the NGINX Plus Usage permission.

**Fix**: Confirm the `usage_report` directive is set in the `mgmt` block of your NGINX Plus configuration. Confirm your NGINX Plus version is R33 or later. Expand the date range or reset it to the default (last 7 days). Confirm your RBAC role includes the NGINX Plus Usage permission.

### CSV export produces a truncated file

**Symptom**: The exported CSV file appears incomplete.

**Cause**: The CSV export streams data directly from the server. A dropped connection during the export leaves the file incomplete.

**Fix**: Re-export the file. Use narrower date filters to reduce the export size if your connection is slow or unreliable.

### A record's reporting window spans more than one hour

**Symptom**: A record's reporting window is longer than expected, for example 09:00–11:00 instead of 09:00–10:00.

**Cause**: A previous report failed. NGINX Plus combined the missed window with the next scheduled report. This is expected behavior. It ensures no usage data is lost.

**Fix**: No action needed. NGINX Instance Manager retains both the extended record and any partially persisted original record.

### Dashboard loads slowly with a large date range

**Symptom**: The dashboard takes several seconds to load with a wide date range or no filters applied.

**Cause**: Large date ranges return more records to retrieve and count, especially with thousands of instances.

**Fix**: Narrow the date range or apply additional filters, such as instance, cluster, or product type. The default 7-day view typically loads within a few seconds.

---

## References

- [Report usage data to F5 (connected)]({{< ref "nim/licensing-and-reporting/report-usage-connected-deployment.md" >}})
- [Report usage data to F5 (disconnected)]({{< ref "nim/licensing-and-reporting/report-usage-disconnected-deployment.md" >}})
- [Change telemetry settings]({{< ref "nim/licensing-and-reporting/change-telemetry-settings.md" >}})