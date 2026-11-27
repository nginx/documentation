---
f5-product: F5 NGINX Ingress Controller
f5-files:
- content/nic/integrations/waf/current/troubleshoot.md
- content/nic/integrations/waf/legacy/troubleshoot.md
---

When you make a change that requires NGINX to apply a new configuration, NGINX Ingress Controller reloads NGINX automatically. Without the F5 WAF for NGINX module turned on, typical reload times are around 150ms. If the F5 WAF for NGINX module is turned on and is being used by any number of Ingress resources, these reloads might take a few seconds instead.

If you are running more than one instance of NGINX Ingress Controller, the extended reload time may cause the NGINX configuration of your instances to be out of sync. This can occur because there is no order imposed on how NGINX Ingress Controller processes the Kubernetes resources. The configurations will be the same after all instances have completed the reload.

To reduce these inconsistencies, don't apply changes to multiple resources handled by NGINX Ingress Controller at the same time.
