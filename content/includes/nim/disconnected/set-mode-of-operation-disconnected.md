---
nd-docs: "DOCS-1663"
---

1. Open the `/etc/nms/nms.conf` file and add the following in the `integrations:license` section:

    ``` yaml
    integrations:
        license:
            mode_of_operation: disconnected
    ```

2.	Restart NGINX Instance Manager:

    ``` bash
    sudo systemctl restart nms
    ```
