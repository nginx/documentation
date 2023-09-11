---
docs: DOCS-1304
---

NGINX Plus advanced metrics are application-centric metrics collected by the NGINX Agent.

To enable advanced metrics, edit the `/etc/nginx-agent/nginx-agent.conf` file and add the following directives:

```yaml
extensions:
  - advanced-metrics
advanced_metrics:
  socket_path: /var/run/nginx-agent/advanced-metrics.sock
  aggregation_period: 1s
  publishing_period: 3s
  table_sizes_limits:
    staging_table_max_size: 1000
    staging_table_threshold: 1000
    priority_table_max_size: 1000
    priority_table_threshold: 1000
```

{{<see-also>}}See the [NGINX Agent CLI Flags & Usage]({{< relref "/nms/nginx-agent/install-nginx-agent.md#nginx-agent-cli-flags--usage" >}}) topic for a description of each of these flags.{{</see-also>}}
