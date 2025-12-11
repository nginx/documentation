---
nd-docs: DOCS-1663
nd-files:
- content/nim/license/add-license-offline.md
- content/nim/disconnected/offline-install-guide-manual.md
- content/nim/disconnected/offline-install-guide.md
---

1. Open the `/etc/nms/nms.conf` file and update the `integrations.license` section as follows:

    ```yaml
    integrations:
      license:
        mode_of_operation: disconnected
    ```

1. Restart the NGINX Instance Manager service:

    ```bash
    sudo systemctl restart nms
    ```

This setting disables online license checks and allows NGINX Instance Manager to operate in a disconnected environment.
