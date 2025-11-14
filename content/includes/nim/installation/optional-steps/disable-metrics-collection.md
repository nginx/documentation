---
files:
- content/nim/deploy/vm-bare-metal/install.md
- content/nim/disconnected/offline-install-guide-manual.md
- content/nim/disconnected/offline-install-guide.md
---

If you’re not collecting metrics — because you didn’t install ClickHouse or don’t plan to use it — you must disable metrics collection in the `/etc/nms/nms.conf` and `/etc/nms/nms-sm-conf.yaml` files. This setup requires NGINX Agent version {{< lightweight-nim-nginx-agent-version >}}.

For instructions, see [Disable metrics collection]({{< ref "nim/system-configuration/configure-clickhouse.md#disable-metrics-collection" >}}).