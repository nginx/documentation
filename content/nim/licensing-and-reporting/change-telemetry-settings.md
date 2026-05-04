---
title: Change telemetry settings
description: "Change advanced settings in /etc/nms/nms.conf to control how F5 NGINX Instance Manager processes and reports usage data."
weight: 400
toc: true
nd-content-type: how-to
nd-product: NIMNGR
nd-summary: >
  Adjust advanced telemetry settings in F5 NGINX Instance Manager to control how usage data is collected and reported to F5.
  These settings rarely need changing; modify them only when the defaults don't fit your connected or disconnected deployment.
---

## Overview

The telemetry settings in `/etc/nms/nms.conf` control how F5 NGINX Instance Manager collects, processes, and sends usage data to F5. You don't need to change these settings unless the defaults don't fit your environment.

Settings are grouped into two sections: connected mode and disconnected mode. To learn which mode you're running in, see your NGINX Instance Manager configuration file.

---

## Before you begin

- **NGINX Instance Manager 2.22 or later**: These settings are available in NGINX Instance Manager 2.22 and later.
- **Root or sudo access**: You need to edit `/etc/nms/nms.conf` on the NGINX Instance Manager server.

---

## Configure connected mode settings

To change a connected mode setting:

1. Open `/etc/nms/nms.conf`.
2. In the `integrations.telemetry` section, add or update the setting.
3. Restart NGINX Instance Manager:

   ```shell
   sudo systemctl restart nms
   ```

### integrations.telemetry.nc_api_url

**Default:** `https://product.connect.nginx.com/api`

The URL of the F5 NGINX Console API that NGINX Instance Manager sends usage data to in connected mode.

Change this only if you use a proxy or custom endpoint to relay traffic to F5. In almost all cases, leave it at the default.

```yaml
integrations:
  telemetry:
    nc_api_url: https://product.connect.nginx.com/api
```

### integrations.telemetry.usage_report_interval

**Default:** `5m` | **Allowed range:** `5m`–`24h`

How often NGINX Instance Manager processes and batches usage data from NGINX Plus instances. Lower values mean more frequent processing but higher resource usage.

To reduce load on the NGINX Instance Manager server, increase this toward `1h` or `24h`. Don't set it below `5m`.

```yaml
integrations:
  telemetry:
    usage_report_interval: 15m
```

### integrations.telemetry.max_retry_attempts

**Default:** `5`

How many times NGINX Instance Manager retries a failed API call to the F5 NGINX Console before giving up.

Increase this if your connection to `product.connect.nginx.com` is intermittent.

```yaml
integrations:
  telemetry:
    max_retry_attempts: 10
```

### integrations.telemetry.connected.batch_size

**Default:** `10000`

The number of usage records NGINX Instance Manager fetches from the internal queue per batch when sending data to F5.

Reduce this if NGINX Instance Manager is running on a resource-constrained server and you want to limit memory usage per processing cycle.

```yaml
integrations:
  telemetry:
    connected:
      batch_size: 5000
```

---

## Configure disconnected mode settings

To change a disconnected mode setting:

1. Open `/etc/nms/nms.conf`.
2. Add or update the setting in the appropriate section.
3. Restart NGINX Instance Manager:

   ```shell
   sudo systemctl restart nms
   ```

### integrations.telemetry.disconnected.export_batch_size

**Default:** `40000`

The number of usage records NGINX Instance Manager aggregates per batch when generating the offline export archive (ZIP file). Larger values produce fewer, larger files in the archive.

Reduce this if you see memory pressure during export. Increase it if you want fewer files in the ZIP archive.

```yaml
integrations:
  telemetry:
    disconnected:
      export_batch_size: 20000
```

### dpm.nats.stream.ack_wait

**Default:** `20m`

How long NGINX Instance Manager waits for a message to be acknowledged (processed and written to the export archive) before retrying. If export takes longer than this window, messages may be re-processed.

Increase this only if your NGINX Instance Manager server handles a large volume of usage data and the export regularly takes more than 20 minutes. This value must always be greater than your maximum expected export duration.

```yaml
dpm:
  nats:
    stream:
      ack_wait: 30m
```

### dpm.nats.stream.fetch_timeout

**Default:** `500ms`

How long NGINX Instance Manager waits when fetching a batch of usage messages from the internal NATS message queue. If the queue is slow to respond, NGINX Instance Manager may time out before reading all messages.

If you see warnings about empty fetch attempts in the logs and suspect slow disk I/O, increase this value — for example, `1s` or `2s`.

```yaml
dpm:
  nats:
    stream:
      fetch_timeout: 1s
```

---

## Troubleshooting

### Settings don't take effect after editing nms.conf

**Symptom**: Changed values in `/etc/nms/nms.conf` have no effect.

**Cause**: NGINX Instance Manager hasn't reloaded the configuration file.

**Fix**: Restart NGINX Instance Manager:

```shell
sudo systemctl restart nms
```

---

## References

- [Report usage data to F5 (connected)]({{< ref "/nim/licensing-and-reporting/report-usage-connected-deployment.md" >}})
- [Report usage data to F5 (disconnected)]({{< ref "/nim/licensing-and-reporting/report-usage-disconnected-deployment.md" >}})
