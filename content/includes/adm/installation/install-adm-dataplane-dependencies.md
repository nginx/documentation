---
docs: DOCS-1233
---

Complete the following steps for each data plane instance you want to use with App Delivery Manager:

   {{< important >}}
   ADM expects that even individual data plane instances are added as part of an [Instance Group]({{< relref "/public/nginx-management-suite/nim/how-to/nginx/manage-instance-groups" >}}).
    {{< /important >}}

1. [Install NGINX Plus R24 or later](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/)
2. [Install the NGINX Agent]({{< relref "/nms/nginx-agent/install-nginx-agent.md" >}}) on your data plane instances to register them with NGINX Management Suite.
3. [Install NGINX Plus Metrics Module]({{< relref "/nms/nginx-agent/install-nginx-plus-advanced-metrics.md" >}})

