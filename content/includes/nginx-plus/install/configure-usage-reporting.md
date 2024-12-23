---
docs:
---

In the `nginx.conf` file, configure license reporting to F5 licensing endpoint using the
[`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block. By default, no configuration is required. However, it becomes necessary when your NGINX Plus instance is installed in a disconnected environment, uses NGINX Instance manager for usage reporting, or uses a custom path for the license file. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).