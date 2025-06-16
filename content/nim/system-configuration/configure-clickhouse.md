---
description: ''
docs: DOCS-998
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
