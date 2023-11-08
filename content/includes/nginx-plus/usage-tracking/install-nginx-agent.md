---
docs:
---

When you install NGINX Agent on an NGINX instance, it will establish a connection with Instance Manager and begin transmitting usage data.

1. To install NGINX Agent on an NGINX instance, [follow these instructions]({{< relref "/nms/nginx-agent/install-nginx-agent.md" >}}).

1. (Optional) If you're using Instance Manager solely to track NGINX usage, add the following line to the NGINX Agent configuration file, `/etc/nginx-agent/nginx-agent.conf`. This setting limits NGINX Agent's activity to usage tracking to optimize system performance.

   ``` yaml
   features: registration,dataplane-status
   ```

   {{<note>}}If you upgrade to the full version of Instance Manager, remove the `features: registration,dataplane-status` line from the NGINX Agent configuration file if you added it. This change will enable NGINX Agent to collect and report a wide range of metrics and allow remote configuration management.{{</note>}}
