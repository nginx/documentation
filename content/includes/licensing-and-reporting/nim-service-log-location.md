---
f5-product: NGINX Instance Manager
f5-files:
- content/nim/licensing-and-reporting/report-usage-connected-deployment.md
- content/nim/licensing-and-reporting/report-usage-disconnected-deployment.md
---

All usage reporting logs are written by the `nms-integrations` process. Where you find them depends on your deployment:

{{<table>}}
| Deployment | Log location |
|------------|--------------|
| Linux (systemd) | `journalctl -u nms-integrations` or `/var/log/nms/nms.log` |
| Container | `docker logs <INTEGRATIONS_CONTAINER>` or `kubectl logs <POD_NAME> -c integrations` |
{{</table >}}
