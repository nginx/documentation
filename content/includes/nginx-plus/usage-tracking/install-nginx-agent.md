---
nd-docs: DOCS-1354
---

When you install NGINX Agent on an NGINX Plus instance, it will establish a connection with Instance Manager and begin transmitting usage data.

1. To install NGINX Agent, [follow these instructions]({{< ref "/nms/nginx-agent/install-nginx-agent.md" >}}).

2. (Optional) If you're using Instance Manager primarily for tracking NGINX Plus usage, you can optimize performance by modifying the NGINX Agent configuration. Add this line to _/etc/nginx-agent/nginx-agent.conf_:

   ``` yaml
   features: registration,dataplane-status
   ```

   {{< call-out "note" >}}If you upgrade to the full version of Instance Manager later, remove the `features: registration,dataplane-status` line from the configuration. This change will enable NGINX Agent to collect a broader range of metrics and manage configurations remotely.{{< /call-out >}}
