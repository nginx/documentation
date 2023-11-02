---
docs:
---

After setting up NGINX Instance Manager, your next step is to install NGINX Agent on every NGINX Plus instance you want to track. NGINX Agent will connect to Instance Manager and send tracking and usage data.

- To install NGINX Agent on each NGINX Plus instance, [follow these instructions]({{< relref "/nms/nginx-agent/install-nginx-agent.md" >}}).

**Optional Configuration for Improved Reporting**

For better reporting performance with NGINX Agent, add the following line to the NGINX Agent's configuration file. You'll find this file at _/etc/nginx-agent/nginx-agent.conf_:

``` yaml
features: registration,dataplane-status
```

