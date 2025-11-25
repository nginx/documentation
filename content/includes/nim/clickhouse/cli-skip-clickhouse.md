---
files:
- content/nim/install/vm-bare-metal/install.md
- content/nim/install/vm-bare-metal/install-with-bash-script-online.md
---

If you skip installing ClickHouse, you need NGINX Agent {{< lightweight-nim-nginx-agent-version >}}.

After installation, make sure to [disable metrics collection]({{< ref "nim/system-configuration/configure-clickhouse.md#disable-metrics-collection" >}}) in the `/etc/nms/nms.conf` file.
