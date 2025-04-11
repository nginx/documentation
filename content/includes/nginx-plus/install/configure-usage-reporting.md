---
docs:
---

Make sure license reporting to F5 licensing endpoint is configured. By default, no configuration is required. However, it becomes necessary when NGINX Plus is installed in a disconnected environment, uses NGINX Instance Manager for usage reporting, or uses a custom path for the license file. Configuration can be done in the [`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block of the NGINX Plus configuration file (`/etc/nginx/nginx.conf`). For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).
