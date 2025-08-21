---
description: ''
nd-docs: DOCS-998
title: Configure ClickHouse
toc: true
weight: 100
type:
- how-to
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Overview

NGINX Instance Manager uses ClickHouse to store metrics, events, alerts, and configuration data.
If your setup differs from the default configuration — for example, if you use a custom address, enable TLS, set a password, or turn off metrics — you need to update the `/etc/nms/nms.conf` file.

This guide explains how to update those settings so that NGINX Instance Manager can connect to ClickHouse correctly.

## Change default settings {#change-settings}

To change a ClickHouse setting:

1. Open the configuration file at `/etc/nms/nms.conf`.

2. In the `[clickhouse]` section, update the setting or settings you want to change.

3. Restart the NGINX Instance Manager service:

   ```shell
   sudo systemctl restart nms
   ```

Unless otherwise specified in the `/etc/nms/nms.conf` file, NGINX Instance Manager uses the following default values for ClickHouse:

{{< include "nim/clickhouse/clickhouse-defaults.md" >}}


## Disable metrics collection

Starting in version 2.20, NGINX Instance Manager can run without ClickHouse. This lightweight mode reduces system requirements and simplifies installation for users who don't need metrics. To use this setup, you must run NGINX Agent version `{{< lightweight-nim-nginx-agent-version >}}`.

To disable metrics collection after installing NGINX Instance Manager:

1. Open the config file at `/etc/nms/nms.conf`.

2. In the `[clickhouse]` section, set the following value:

   ```yaml
   clickhouse:
      enable = false
   ```

3. Open the `/etc/nms/nms-sm-conf.yaml` file and set:

   ```yaml
   clickhouse:
      enable = false
   ```

4. Restart the NGINX Instance Manager service:

   ```shell
   sudo systemctl restart nms
   ```

When metrics are turned off:

- The web interface no longer shows metrics dashboards. Instead, it displays a message explaining that metrics are turned off.
- Metrics-related API endpoints return a 403 error.
- All other NGINX Instance Manager features continue to work as expected.

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
