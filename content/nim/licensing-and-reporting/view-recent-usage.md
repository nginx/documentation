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
  Use this audit-grade record view to independently verify billing data and support compliance reviews, separately from the usage reports NGINX Instance Manager sends to F5.
---

## Overview

The **Usage Overview** page shows the raw usage telemetry that F5 NGINX Instance Manager collects from your instances. This includes F5 NGINX Plus, F5 NGINX Ingress Controller, and F5 NGINX Gateway Fabric. NGINX Open Source instances don't appear in usage records. They don't include the `ngx_mgmt_module` that NGINX Plus uses to report usage.

Each row is one telemetry record, exactly as your instance reported it. NGINX Instance Manager doesn't aggregate or transform records. Use this page to independently verify the data behind your F5 billing and to support compliance audits.

NGINX Agent isn't required. Your instances send usage data directly to NGINX Instance Manager.

### Instances and Clusters tabs

The page has two tabs:

- **Instances**: Shows records from standalone NGINX Plus instances that run on VMs or bare metal.
- **Clusters**: Shows records from NGINX deployments that run in Kubernetes. This includes records from NGINX Ingress Controller and NGINX Gateway Fabric.

By default, the page shows the last 7 days of records, sorted by end time with the most recent first. NGINX Instance Manager keeps records for the last 120 days by default. You can change this retention period. See [Configure the retention period](#configure-the-retention-period).

---

## Before you begin

Before you view usage records, make sure you have:

- **NGINX Plus R33 or later**: NGINX Plus R33 and later include the `ngx_mgmt_module` module. Earlier versions can't report usage to NGINX Instance Manager.
- **NGINX Plus configured to report usage**: Each NGINX Plus instance needs the `usage_report` directive set to your NGINX Instance Manager host. See [Configure NGINX Plus to report usage to NGINX Instance Manager]({{< ref "nim/licensing-and-reporting/report-usage-connected-deployment.md#configure-nginx-plus-to-report-usage-to-nginx-instance-manager" >}}).
- **The NGINX Plus Usage permission**: Your user account needs this role-based access control (RBAC) permission to view usage records in the dashboard or through the API.

---

## View and filter usage records

### View records in the dashboard

To view raw usage records:

1. Log in to NGINX Instance Manager (`https://<NIM_FQDN>/ui/`).
2. In the left navigation, select **Usage > Usage Overview**.
3. Select the **Instances** or **Clusters** tab.

By default, the dashboard shows records from the last 7 days, sorted by end time with the most recent first.

{{< call-out class="note" title="Note: Fields not shown in the table" >}}
The dashboard's summary table doesn't show every field from a usage record. For example, it doesn't show the reporting start time. Select a row to view the full record and see every field.
{{< /call-out >}}

### View record details

Select a row to open a side panel that shows all fields for that record.

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

- **NGINX Instance ID**: NGINX Plus stores this in `/var/lib/nginx/nginx.id` on each instance. You can also find it in the **NGINX UID** column or in the detail panel.
- **Cluster ID**: Visible in the **K8s Cluster ID** column on the Clusters tab. NGINX Ingress Controller and NGINX Gateway Fabric generate this ID at installation and store it in the deployment's Kubernetes secret.
- **Subscription token (jti)**: A claim inside your subscription JWT (`license.jwt`). Paste the JWT contents into [jwt.io](https://jwt.io) and look for the `jti` field. You can also find it in the **JWT ID** column.

### Export usage records to a file

To export usage records for an offline review or compliance check:

1. Apply the filters you need.
2. Select **Export CSV**.

The exported file downloads in CSV (comma-separated values) format. It includes all records matching your current filters, with no rounding or aggregation.

If the export is slow, apply additional filters to narrow the result set before you export.

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
See [An exported file is truncated](#an-exported-file-is-truncated).
{{< /call-out >}}

---

## Configure the retention period

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

A retention change takes effect after this restart. Because the purge job runs immediately on startup, it removes records outside the new window right away, not on the next scheduled 24-hour cycle.

{{< call-out class="important" title="Important: Retention value limits" >}}
NGINX Instance Manager normalizes retention values on startup. It caps any value above 365 to 365. It ignores negative values and uses the default (120 days) instead. A value of 0 blocks local storage: NGINX Instance Manager doesn't write new records and purges existing records on the next run. This doesn't affect usage reporting to F5.
{{< /call-out >}}

If NGINX Instance Manager clamps or rejects your configured value, it logs a `[RAW-USAGE]` warning so you know the configured value wasn't applied.

### Estimate storage for extended retention

Storage and memory scale with your instance count and configured retention period. Each usage record takes about 0.9 KB on disk. This estimate includes the database index.

The following table shows estimated storage and working memory at two retention periods: the default 120 days, and the maximum 365 days (1 year). These figures assume the default NGINX Plus reporting cadence of one report per instance per hour.

{{<table>}}
| Instances | 120-day storage | 120-day working memory | 1-year storage | 1-year working memory |
|---|---|---|---|---|
| 50 | ~0.13 GB | ~2.4 GB | ~0.4 GB | ~2.9 GB |
| 100 | ~0.26 GB | ~2.6 GB | ~0.8 GB | ~3.5 GB |
| 500 | ~1.3 GB | ~4.2 GB | ~4.0 GB | ~8.3 GB |
| 800 | ~2.1 GB | ~5.4 GB | ~6.3 GB | ~11.7 GB |
| 1,000 | ~2.6 GB | ~6.2 GB | ~7.9 GB | ~14.1 GB |
{{</table>}}

{{< call-out class="note" title="Note: Tested range" >}}
NGINX Instance Manager's scale testing for 1-year retention covered up to 800 instances. The 1,000-instance figures in this table extrapolate beyond that tested point.
{{< /call-out >}}

For retention periods between 120 days and 1 year, storage and working memory scale roughly linearly with the number of days you configure. If you halve your retention period, you roughly halve both storage and memory.

To size a host:

- **Memory**: Provision enough RAM to cover the working memory estimate for your fleet size and retention period. Size by RAM, not by a specific vendor instance type.
- **Disk**: Budget headroom beyond the storage estimate for database indexes, snapshots, write-ahead logs, and NGINX Instance Manager's other services. For large fleets at extended retention, budget tens of GB of SSD storage.
- **Alternative to over-provisioning**: Lower `nginx_raw_usage_retention_days` rather than add more host resources. If you reduce retention, you shrink stored data and memory use proportionally. This doesn't affect usage reporting to F5.

This sizing applies even in Lightweight mode. NGINX Instance Manager stores usage records independently of ClickHouse. As a result, instance count and retention affect your storage needs, even in deployments used only for licensing and usage reporting.

---

## Validate a record from the command line

Use the REST API to retrieve usage records and confirm the identifiers in a specific record. All endpoints are available at `/api/platform/v1/usage-records`.

### Retrieve records for a specific instance or cluster

Query by `nginxUid` to retrieve every record for a specific NGINX Plus instance:

```shell
curl -k -u <USERNAME>:<PASSWORD> \
  "https://<NIM_FQDN>/api/platform/v1/usage-records?deploymentType=vm&nginxUid=<NGINX_INSTANCE_UUID>"
```

Query by `clusterId` to retrieve every record for a specific Kubernetes cluster:

```shell
curl -k -u <USERNAME>:<PASSWORD> \
  "https://<NIM_FQDN>/api/platform/v1/usage-records?deploymentType=cluster&clusterId=<CLUSTER_UUID>"
```

### What each identifier means

{{<table>}}
| Field | Description | Where it comes from | Applies to |
|---|---|---|---|
| `nginx_uid` | UUID that uniquely identifies the NGINX Plus instance. | Generated by NGINX Plus. | All records |
| `product_type` | Integration type: `NGINX_PLUS`, `NIC`, `NGF`, or `UNSPECIFIED`. | Reported by the instance. | All records |
| `jwt_token_id` | The `jti` claim of the F5 subscription token the instance uses for reporting. | Derived from the F5 subscription token. | Records with subscription metadata |
| `jwt_expiration` | Subscription end date from the F5 subscription token. | Derived from the F5 subscription token. | Records with subscription metadata |
| `cluster_id` | UUID of the Kubernetes cluster where the instance runs. | Provided by NGINX Ingress Controller or NGINX Gateway Fabric. | Kubernetes records |
| `installation_id` | UUID identifying an individual NGINX Ingress Controller or NGINX Gateway Fabric installation. | Provided by NGINX Ingress Controller or NGINX Gateway Fabric. | Kubernetes records |
| `cluster_node_count` | Number of nodes in the Kubernetes cluster. | Provided by NGINX Ingress Controller or NGINX Gateway Fabric. | Kubernetes records |
{{</table>}}

NGINX Instance Manager stores and displays these values exactly as your instances report them. It doesn't generate or modify them.

{{< call-out class="note" title="Note: To confirm an identifier on a running instance" >}}
This page shows you how to view identifiers as NGINX Instance Manager received them. To independently confirm a value like Cluster ID directly on a running Kubernetes deployment, see the NGINX Ingress Controller or NGINX Gateway Fabric documentation for that identifier.
{{< /call-out >}}

---

## What's shown

{{<table>}}
| Field | Description |
|---|---|
| NGINX Instance ID | UUID that identifies the NGINX instance. |
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

The **Usage Overview** page is a local, on-demand audit view. It's different from the usage reports NGINX Instance Manager automatically sends to F5 for billing.

{{<table>}}
| | **Usage Overview** page | Usage reporting to F5 |
|---|---|---|
| Purpose | Local audit and verification | Billing and entitlement |
| Data | Raw, per-record, unaggregated | Aggregated for submission |
| Retention | Configurable, 0–365 days (120 default) | Not applicable |
| Where to configure | This page | [Report usage data to F5 (connected)]({{< ref "nim/licensing-and-reporting/report-usage-connected-deployment.md" >}}) or [Report usage data to F5 (disconnected)]({{< ref "nim/licensing-and-reporting/report-usage-disconnected-deployment.md" >}}) |
{{</table>}}

When you view or export records on this page, usage reporting to F5 doesn't change. The two pipelines operate independently.

This page works the same way in connected and disconnected deployments. Your instances keep reporting locally, and existing records stay fully browsable, even without internet access.

---

## Troubleshooting

### No records appear in the dashboard

**Symptom**: The usage dashboard shows no records.

**Cause**: One of the following:

- NGINX Plus isn't configured to report usage to NGINX Instance Manager.
- Your NGINX Plus version is earlier than R33.
- The date range filter is too narrow.
- Your account doesn't have the NGINX Plus Usage permission.

**Fix**: Make sure the `usage_report` directive is set in the `mgmt` block of your NGINX Plus configuration. Make sure your NGINX Plus version is R33 or later. Expand the date range or reset it to the default (last 7 days). Make sure your RBAC role includes the NGINX Plus Usage permission.

### An exported file is truncated

**Symptom**: The exported CSV file appears incomplete.

**Cause**: The CSV export streams data directly from the server. A dropped connection during the export leaves the file incomplete.

**Fix**: Re-export the file. If your connection is slow or unreliable, use narrower date filters to reduce the export size.

### A record's reporting window spans more than one hour

**Symptom**: A record's reporting window is longer than expected, for example 09:00–11:00 instead of 09:00–10:00.

**Cause**: A previous report failed. NGINX Plus combined the missed window with the next scheduled report. This is expected behavior. No usage data is lost.

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
- [System requirements for licensing and usage reporting only]({{< ref "nim/fundamentals/tech-specs.md#reporting-sizing" >}})