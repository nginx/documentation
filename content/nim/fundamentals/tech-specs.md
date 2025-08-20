---
nd-docs: DOCS-805
title: Technical Specifications
toc: true
weight: 20
type:
- reference
---

## Overview

NGINX Instance Manager provides centralized management for NGINX Open Source and NGINX Plus instances across various environments, including bare metal, containers, public clouds (AWS, Azure, Google Cloud), and virtual machines. It supports several Linux distributions, including Amazon Linux, CentOS, Debian, RHEL, and Ubuntu. This guide outlines the technical specifications, minimum requirements, and supported platforms for deploying NGINX Instance Manager, ensuring optimal performance in both small and large environments.

## Supported deployment environments {#supported-environments}

You can deploy NGINX Instance Manager in the following environments:

- **Bare metal**
- **Container**
- **Public cloud**: AWS, Google Cloud Platform, Microsoft Azure
- **Virtual machine**

## Supported Linux Distributions {#supported-distributions}

{{< include "nim/tech-specs/supported-distros.md" >}}

## Supported NGINX Versions {#nginx-versions}

{{< include "nim/tech-specs/supported-nginx-versions.md" >}}

## Sizing recommendations for Managing NGINX Instances {#system-sizing}

The following recommendations provide the minimum guidelines for NGINX Instance Manager. These guidelines ensure adequate performance, but for optimal results, we strongly recommend using solid-state drives (SSDs) for storage. If you set up [deployments with NGINX App Protect](#system-sizing-app-protect), you may need additional memory and CPU.

### Standard NGINX configuration deployments

This section outlines the recommendations for NGINX Instance Manager deployments with data plane instances using standard configurations, without NGINX App Protect. **Standard configurations** typically support up to **40 upstream servers** with associated location and server blocks, and up to **350 certificates**. This is ideal for medium-sized environments or applications with moderate traffic.

We recommend using SSDs to enhance storage performance.

{{< bootstrap-table "table table-striped table-bordered" >}}
| Number of Data Plane Instances | CPU    | Memory   | Network   | Storage |
|--------------------------------|--------|----------|-----------|---------|
| 10                             | 2 vCPU | 4 GB RAM | 1 GbE NIC | 100 GB  |
| 100                            | 2 vCPU | 4 GB RAM | 1 GbE NIC | 1 TB    |
| 1000                           | 4 vCPU | 8 GB RAM | 1 GbE NIC | 3 TB    |
{{</ bootstrap-table >}}

These values represent the minimum resources needed for deployments that fall under standard configurations.

### Large NGINX configuration deployments

For environments requiring more resources, **large configurations** are suitable. These configurations can support up to **300 upstream servers** and are designed for enterprise environments or applications handling high traffic and complex configurations, without NGINX App Protect.

{{< bootstrap-table "table table-striped table-bordered" >}}
| Number of Data Plane Instances | CPU    | Memory   | Network   | Storage |
|--------------------------------|--------|----------|-----------|---------|
| 50                             | 4 vCPU | 8 GB RAM | 1 GbE NIC | 1 TB    |
| 250                            | 4 vCPU | 8 GB RAM | 1 GbE NIC | 2 TB    |
{{</ bootstrap-table >}}

### NGINX configuration deployments with NGINX App Protect {#system-sizing-app-protect}

If using NGINX App Protect features in NGINX Instance Manager, this requires additional CPU and Memory for policy compilation and security monitoring features. At a minimum, 8gb Memory and 4 CPUs are required for a standard NGINX App Protect use case (under 20 NGINX Plus instances). The requirements are heavily dependent on the number of policies being managed, the frequency of updates and the number of events being that occur in the security monitoring feature.

### Lightweight mode {#lightweight-mode}

(New in 2.20.0) You can run NGINX Instance Manager without installing ClickHouse. This setup is useful if you don’t need monitoring data or prefer a simpler deployment. It reduces system requirements and removes the need to manage a metrics database. You can add ClickHouse later if your needs change. For instructions, see [Disable metrics collection]({{< ref "nim/system-configuration/configure-clickhouse.md#disable-metrics-collection" >}}).

In Lightweight mode, we tested NGINX Instance Manager with ten managed NGINX instances and configuration publishing. It ran with as little as 1 CPU core and 1 GB of memory (without App Protect). When App Protect was enabled, we needed 2 CPU cores and 4 GB of memory to compile policies.

These figures are guidelines only. They reflect the minimum tested configuration and may cause performance issues depending on your setup. For better performance, consider allocating more system resources.


### License and usage reporting only {#reporting-sizing}

This section applies when you’ve set up NGINX Instance Manager to handle licensing and usage reporting only. In this setup, NGINX instances report license and usage data in an "unmanaged" way. Each instance sends periodic updates to NGINX Instance Manager for counting purposes only.

For details on how to configure this setup, see [Prepare your environment for reporting]({{< ref "/solutions/about-subscription-licenses.md#set-up-environment" >}}).

When used only for licensing and usage reporting, NGINX Instance Manager has minimal system requirements. We recommend using [Lightweight mode](#lightweight-mode) in this case to avoid the ClickHouse dependency, especially if you don’t plan to use other features.

{{<bootstrap-table "table table-striped table-bordered">}}
| Number of Data Plane Instances | CPU    | Memory   | Network   | Storage |
|--------------------------------|--------|----------|-----------|---------|
| n/a                            | 2 vCPU | 4 GB RAM | 1 GbE NIC | 20 GB   |
{{</bootstrap-table>}}

### Sizing benchmarks for storage

The following benchmarks focus on **disk storage** requirements for NGINX Instance Manager. Storage needs depend on the **number of instances** and **data retention periods** (in days). The benchmarks are divided into three configuration sizes:

- **Small configuration**: Typically supports about **15 servers**, **50 locations**, and **30 upstreams/backends**. Each instance generates **3,439 metrics per minute**.
- **Medium configuration**: Usually includes about **50 servers**, **200 locations**, and **200 upstreams/backends**. Each instance generates **16,766 metrics per minute**.
- **Generic Large configuration**: Handles up to **100 servers**, **1,000 locations**, and **900 upstreams/backends**. In **NGINX Plus**, each instance generates **59,484 metrics per minute**.

#### Storage requirements for NGINX Plus

The table below provides storage estimates for **NGINX Plus** based on configuration size, number of instances, and a 14-day data retention period. Larger configurations and longer retention periods will require proportionally more storage.

{{<bootstrap-table "table table-striped table-bordered">}}
| Config Size         | Instances | Retention (days) | Estimated Disk Usage (NGINX Plus) |
|---------------------|-----------|------------------|-----------------------------------|
| **Small Size**       | 10        | 14               | 5 GiB                             |
|                     | 50        | 14               | 25 GiB                            |
|                     | 100       | 14               | 45 GiB                            |
|                     | 1000      | 14               | 450 GiB                           |
| **Medium Size**      | 10        | 14               | 25 GiB                            |
|                     | 50        | 14               | 126 GiB                           |
|                     | 100       | 14               | 251 GiB                           |
|                     | 500       | 14               | 1.157 TiB                         |
| **Generic Large Size** | 10        | 14               | 100 GiB                           |
|                     | 50        | 14               | 426 GiB                           |
|                     | 100       | 14               | 850 GiB                           |
|                     | 250       | 14               | 2 TiB                             |
{{</bootstrap-table>}}

{{< call-out "note" >}}MiB (mebibyte), GiB (gibibyte), and TiB (tebibyte) are units of data storage. MiB equals 1,024^2 (2^20) bytes, GiB equals 1,024^3 (2^30) bytes, and TiB equals 1,024^4 (2^40) bytes. These are often used in computing to represent binary data storage capacities, as opposed to MB (megabyte), GB (gigabyte), and TB (terabyte), which use decimal units.{{< /call-out >}}

#### Storage requirements for NGINX OSS

**NGINX OSS** collects fewer metrics per instance compared to NGINX Plus. This is because NGINX OSS lacks the advanced features of NGINX Plus, such as the NGINX Plus API, which limits the amount of operational data collected and stored. For example, in the **Generic Large configuration**, NGINX OSS generates only **167 metrics per minute per instance**, compared to **59,484 metrics per minute** in NGINX Plus.

The table below shows the estimated storage requirements for **NGINX OSS**, based on the number of instances and a 14-day retention period.

{{<bootstrap-table "table table-striped table-bordered">}}
| Config Size           | Instances | Retention (days) | Estimated Disk Usage (NGINX OSS) |
|-----------------------|-----------|------------------|----------------------------------|
| **Generic Large Size** | 10        | 14               | 200 MiB                          |
|                       | 50        | 14               | 850 MiB                          |
|                       | 100       | 14               | 1.75 GiB                         |
|                       | 250       | 14               | 4 GiB                            |
{{</bootstrap-table>}}

#### ClickHouse Tunings {#Clickhouse-tuning}

The default configuration that comes with clickhouse works with NIM efficiently. But if you make any changes to the configuration and clickhouse is running out of memory, please follow below steps.
There are system tables in ClickHouse that provide logging and telemetry mechanisms to monitor and debug the behavior of the database. These logs are not typical event logs that store user activity but are internal logs designed for diagnostics and telemetry related to system operations.
Below is an explanation of three such tables which may cause an out of memory issue:

- **trace_log**:  The trace_log table records detailed execution traces and profiling information. It is mainly used for query debugging and performance analysis in ClickHouse. The logs here provide insight into CPU usage and stack traces for specific parts of query execution. Stores stack traces collected by query profilers and inserted into this table. You can modify the settings for trace_log under <trace_log> section in /etc/clickhouse-server/config.xml file.  The flush_interval_milliseconds controls the Interval for flushing data from the buffer in memory to the table and the default value is 7500. Any value below default can cause the excessive debug rows captured in the table and eventually eat up more memory.

Default settings for trace_log is as follows
```shell
<trace_log>
    <database>system</database>
    <table>trace_log</table>
    <partition_by>toYYYYMM(event_date)</partition_by>
    <flush_interval_milliseconds>7500</flush_interval_milliseconds>
    <max_size_rows>1048576</max_size_rows>
    <reserved_size_rows>8192</reserved_size_rows>
    <buffer_size_rows_flush_threshold>524288</buffer_size_rows_flush_threshold>
    <flush_on_crash>false</flush_on_crash>
    <symbolize>false</symbolize>
</trace_log>
```

You can use the below command to view the current memory occupied by each table in the clickhouse database using the below command from clickhouse-client.
```shell
SELECT
    database,
    table,
    formatReadableSize(sum(bytes_on_disk)) AS total_size
FROM system.parts
GROUP BY database, table
ORDER BY sum(bytes_on_disk) DESC;
```
If you observe that this table is utilizing more memory, you can configure the TTL to ensure that outdated records are removed after the specified TTL duration. The TTL configuration guarantees that your table does not expand excessively and automatically deletes old records following the TTL.

```shell
ALTER TABLE system.trace_log
MODIFY TTL event_time + INTERVAL 7 DAY;
```
You can also relieve the memory if its running very low using the below command. Change the interval in the command to how many days of records you want to retain and delete the remaining records.
```shell
ALTER TABLE system.trace_log DELETE WHERE event_time < now() - INTERVAL 30 DAY;
```
- **metric_log**:  The `system.metric_log` contains history of metrics values from tables system.metrics and system.events, periodically flushed to disk. It serves as a time-series table that periodically records historical data from system.metrics and system.events over time. This table acts like an essential tool providing historical tracking of captured metrics and event data, making it easier to debug performance trends, spikes, or irregularities. Too much of historical data in this table can occupy more memory and make the clickhouse run out of memory if not properly configured. 

Default settings for metric_log is as follows
```shell
<metric_log>
        <database>system</database>
        <table>metric_log</table>
        <flush_interval_milliseconds>7500</flush_interval_milliseconds>
        <max_size_rows>1048576</max_size_rows>
        <reserved_size_rows>8192</reserved_size_rows>
        <buffer_size_rows_flush_threshold>524288</buffer_size_rows_flush_threshold>
        <collect_interval_milliseconds>1000</collect_interval_milliseconds>
        <flush_on_crash>false</flush_on_crash>
    </metric_log>
```

You can use the below command to view the current memory occupied by each table in the clickhouse database using the below command from clickhouse-client.
```shell
SELECT
    database,
    table,
    formatReadableSize(sum(bytes_on_disk)) AS total_size
FROM system.parts
GROUP BY database, table
ORDER BY sum(bytes_on_disk) DESC;
```

If it is observed that system.metric_log table is taking more memory, you can set the TTL(Time to Live) so that old records will be deleted after the TTL time. The TTL setting makes sure your table does not grow uncontrollably and delete the old records automatically after the TTL.
```shell
ALTER TABLE system.metric_log
MODIFY TTL event_time + INTERVAL 7 DAY;
```

You can also relieve the memory immediately if its running very low using the below command. Change the interval in the command to how many days of records you want to retain and delete the remaining records.
```shell
ALTER TABLE system.metric_log DELETE WHERE event_time < now() - INTERVAL 30 DAY;
```
Note: We also have a table called nms.metrics table which stores the metrics collected from the data plane in NIM. Make sure you don't delete the records accidentally from nms.metrics table as deleting from nms.metrics will loose the metrics from the data planes.

- **text_log**: The text_log table contains general logging information, including warnings, errors, system messages, and query-processed events. It is a human-readable diagnostic log for operational debugging. The logging level which goes to this table can be limited to the text_log.level server setting as shown in the below xml snippet.
```shell
<text_log>
        <database>system</database>
        <table>text_log</table>
        <flush_interval_milliseconds>7500</flush_interval_milliseconds>
        <max_size_rows>1048576</max_size_rows>
        <reserved_size_rows>8192</reserved_size_rows>
        <buffer_size_rows_flush_threshold>524288</buffer_size_rows_flush_threshold>
        <flush_on_crash>false</flush_on_crash>
        <level>trace</level>
    </text_log>
```
You can use the below command to view the current memory occupied by each table in the clickhouse database using the below command from clickhouse-client.
```shell
SELECT
    database,
    table,
    formatReadableSize(sum(bytes_on_disk)) AS total_size
FROM system.parts
GROUP BY database, table
ORDER BY sum(bytes_on_disk) DESC;
```

If it is observed that this table is taking more memory, you can set the TTL(Time to Live) so that old records will be deleted after the TTL time. The TTL setting makes sure your table does not grow uncontrollably and delete the old records automatically after the TTL.
```shell
ALTER TABLE system.text_log
MODIFY TTL event_time + INTERVAL 7 DAY;
```
You can also relieve the memory immediately if its running very low using the below command. Change the interval in the command to how many days of records you want to retain and delete the remaining records.
```shell
ALTER TABLE system.text_log DELETE WHERE event_time < now() - INTERVAL 30 DAY;
```

## Firewall ports {#firewall}

NGINX Instance Manager and NGINX Agent use the Unix domain socket by default and proxy through the gateway on port `443`.

To ensure smooth communication, make sure port 443 is open on any firewalls between NGINX Instance Manager, NGINX Agent, and other systems they need to communicate with. This allows secure HTTPS traffic to pass through.

## Logging {#logging}

NGINX Instance Manager stores its log files in `/var/log/nms`. To prevent your system from running out of disk space as logs grow, we recommend either creating a separate partition for logs or enabling [log rotation](http://nginx.org/en/docs/control.html#logs).

## Supported Browsers {#supported-browsers}

The NGINX Instance Manager web interface works best on the latest versions of these browsers:

- [Google Chrome](https://www.google.com/chrome/)
- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [Safari](https://support.apple.com/downloads/safari)
- [Microsoft Edge](https://www.microsoft.com/en-us/edge)

## Support for NGINX App Protect WAF

{{< include "nim/tech-specs/nim-app-protect-support.md" >}}

## Security Monitoring Module {#security-monitoring}


### Dependencies with NGINX Instance Manager

#### Control plane requirements

{{< include "nim/tech-specs/security-management-plane-dependencies.md" >}}

### Dependencies with NGINX App Protect WAF and NGINX Plus

#### Data plane requirements

{{< include "nim/tech-specs/security-data-plane-dependencies.md" >}}

## NGINX Agent

#### Data plane requirements

- **Supported distributions**: The NGINX Agent can run on most environments. For the supported distributions, see the [NGINX Agent Technical Specs](https://docs.nginx.com/nginx-agent/technical-specifications/) guide.
