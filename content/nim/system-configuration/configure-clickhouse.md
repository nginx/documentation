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

## ClickHouse tuning {#clickhouse-tuning}

The default ClickHouse configuration works efficiently with NGINX Instance Manager. If you change the configuration and ClickHouse runs out of memory, use the following steps.

ClickHouse has system tables that provide logs and telemetry for monitoring and debugging. These are not user activity logs but internal diagnostic logs. The following tables can cause memory issues if not managed:

Records detailed execution traces and profiling data. Useful for query debugging and performance analysis.

You can change the settings for `trace_log` in `/etc/clickhouse-server/config.xml` under the `<trace_log>` section. The `flush_interval_milliseconds` setting controls how often data is flushed from memory to the table. The default is `7500`. Lowering this value can increase captured rows and use more memory.

Default settings for trace_log is as follows

```xml
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

To check memory use by each table:

```sql
SELECT
    database,
    table,
    formatReadableSize(sum(bytes_on_disk)) AS total_size
FROM system.parts
GROUP BY database, table
ORDER BY sum(bytes_on_disk) DESC;
```

To configure a time to live (TTL):

Update the interval value (for example, `7 DAY`) to set how long records are kept and prevent the table from growing too large:

```sql
ALTER TABLE system.trace_log
MODIFY TTL event_time + INTERVAL 7 DAY;
```

To free memory immediately:

Update the interval value (for example, `30 DAY`) to control how many records to delete.

```sql
ALTER TABLE system.trace_log DELETE WHERE event_time < now() - INTERVAL 30 DAY;
```

### metric_log

Stores historical metrics from `system.metrics` and `system.events`. Useful for analyzing performance trends. Too much historical data can cause memory issues.

Default settings:

```xml
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

Check table memory use:

```sql
SELECT
   database,
   table,
   formatReadableSize(sum(bytes_on_disk)) AS total_size
FROM system.parts
GROUP BY database, table
ORDER BY sum(bytes_on_disk) DESC;
```

Set TTL:

```sql
ALTER TABLE system.metric_log
MODIFY TTL event_time + INTERVAL 7 DAY;
```

Free memory immediately:

```sql
ALTER TABLE system.metric_log DELETE WHERE event_time < now() - INTERVAL 30 DAY;
```

### text_log

Stores general logs such as warnings, errors, system messages, and query events. You can control what is logged using the `text_log.level` server setting.

Default settings:

```xml
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

Check table memory use:

```sql
SELECT
   database,
   table,
   formatReadableSize(sum(bytes_on_disk)) AS total_size
FROM system.parts
GROUP BY database, table
ORDER BY sum(bytes_on_disk) DESC;
```

Set TTL:

```sql
ALTER TABLE system.text_log
MODIFY TTL event_time + INTERVAL 7 DAY;
```

Free memory immediately:

```sql
ALTER TABLE system.text_log DELETE WHERE event_time < now() - INTERVAL 30 DAY;
```
