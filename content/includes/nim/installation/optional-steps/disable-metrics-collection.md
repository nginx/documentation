---
docs:
files:
- content/nim/deploy/vm-bare-metal/install.md
- content/nim/disconnected/offline-install-guide-deprecated.md
- content/nim/disconnected/offline-install-guide.md
---

If you are not collecting metrics—either because you did not install ClickHouse or no longer want to use it—you must disable metrics collection by editing the `/etc/nms/nms.conf` file.

For instructions, see [Disable metrics collection]({{< ref "nim/system-configuration/configure-clickhouse.md#disable-metrics-collection" >}}).