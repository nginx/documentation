---
f5-docs: DOCS-199
f5-product: F5 NGINX Instance Manager
f5-files:
- content/nim/disconnected/offline-install-guide-manual.md
- content/nim/disconnected/offline-install-guide.md
- content/nim/licensing-and-reporting/add-license-disconnected-deployment.md
---

1. Open the `/etc/nms/nms.conf` file and add the following in the `integrations:license` section:

    ``` yaml
    integrations:
        license:
            mode_of_operation: disconnected
    ```

2.	Restart NGINX Instance Manager:

    ```shell
    sudo systemctl restart nms
    ```
