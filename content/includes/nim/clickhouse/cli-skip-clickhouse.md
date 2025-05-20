---
docs:
files:
- content/nim/deploy/vm-bare-metal/install.md
- content/nim/disconnected/offline-install-guide.md
---

{{< call-out "note" "Optional: Disable metrics collection" "" >}}
To skip downloading and installing ClickHouse, add the `-s` flag to the script. This is useful if you do not plan to collect metrics.

If you skip ClickHouse, make sure to [disable metrics collection]({{< ref "nim/system-configuration/configure-clickhouse.md#disable-metrics-collection" >}}) in the `/etc/nms/nms.conf` configuration file after installing NGINX Instance Manager.
{{< /call-out >}}
