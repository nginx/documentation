---
f5-product: F5 NGINX Ingress Controller
f5-files:
- content/nic/integrations/waf/current/troubleshoot.md
- content/nic/integrations/waf/legacy/troubleshoot.md
---

F5 WAF for NGINX logs are part of NGINX Ingress Controller logs when the module is turned on. To check NGINX Ingress Controller logs, follow the steps in [Check NGINX Ingress Controller logs]({{< ref "/nic/troubleshooting/troubleshoot-common#check-nginx-ingress-controller-logs" >}}) of the Troubleshooting guide.

For F5 WAF for NGINX logs, look for messages starting with `APP_PROTECT`, for example:

```shell
2020/07/10 11:13:20 [notice] 17#17: APP_PROTECT { "event": "configuration_load_success", "software_version": "2.52.1", "completed_successfully":true,"attack_signatures_package":{"revision_datetime":"2020-06-18T10:11:32Z","version":"2020.06.18"}}
```
