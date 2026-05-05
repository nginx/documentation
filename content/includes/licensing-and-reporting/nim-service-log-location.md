---
f5-product: NIMNGR
f5-files:
- content/nim/licensing-and-reporting/report-usage-connected-deployment.md
- content/nim/licensing-and-reporting/report-usage-disconnected-deployment.md
---

All usage reporting logs are written by the `nms-integrations` process. Where you find them depends on your deployment:

{{< bootstrap-table "table table-striped table-bordered" >}}
| Deployment | Log location |
|------------|--------------|
| Linux (systemd) | `journalctl -u nms-integrations` or `/var/log/nms/nms.log` |
| Container | `docker logs <integrations-container>` or `kubectl logs <pod> -c integrations` |
{{< /bootstrap-table >}}
