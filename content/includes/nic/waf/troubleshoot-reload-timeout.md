---
f5-product: F5 NGINX Ingress Controller
f5-files:
- content/nic/integrations/waf/current/troubleshoot.md
- content/nic/integrations/waf/legacy/troubleshoot.md
---

The first time NGINX Ingress Controller starts, or whenever there is a change that requires reloading NGINX, NGINX Ingress Controller verifies that the reload was successful. The timeout for this verification is typically 4 seconds. When F5 WAF for NGINX is turned on, this timeout increases to 20 seconds.

This timeout is typically enough to verify configurations. However, when NGINX Ingress Controller handles many Ingress resources with F5 WAF for NGINX turned on at the same time, you might need to extend the timeout further. For example:

- You need to apply a large number of Ingress resources at once.
- You are running NGINX Ingress Controller for the first time in a cluster where Ingress resources with F5 WAF for NGINX turned on are already present.

You can increase this timeout by setting the `nginx-reload-timeout` [command-line argument]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md#cmdoption-nginx-reload-timeout" >}}).
