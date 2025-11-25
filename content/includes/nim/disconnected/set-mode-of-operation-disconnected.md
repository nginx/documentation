---
nd-docs: DOCS-1663
nd-files:
- content/nim/disconnected/add-license-disconnected-deployment.md
- content/nim/disconnected/offline-install-guide-manual.md
- content/nim/disconnected/offline-install-guide.md
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
