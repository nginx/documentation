---
nd-docs: "DOCS-1614"
---

Custom dimensions log entries feature refers to the new configuration in F5 WAF for NGINX, where the new directive called `app_protect_custom_log_attribute` is assigned to a particular location or server or http level in the `nginx.conf` file. The need is to be able to add custom identifiers to the respective location and/or server and identify requests in the Security Log by those identifiers.

The `app_protect_custom_log_attribute` directive will be used to track the assigned location/server/http dimension of each request by adding the `app_protect_custom_log_attribute` to the **Security Logs** a.k.a **Request Logs**. Since it is a custom attribute a customer can set, that custom attribute will appear for every request log entry that was handled by that location/server.