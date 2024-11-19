---
docs: DOCS-807
---

To enable and start the NGINX Instance Manager services for API Connectivity Manager, take the following steps:

1. Enable the NGINX Instance Manager services:

    ```bash
    sudo systemctl enable nms
    sudo systemctl enable nms-core
    sudo systemctl enable nms-dpm
    sudo systemctl enable nms-ingestion
    sudo systemctl enable nms-integrations
    sudo systemctl enable nms-acm
    ```

2. Start the NGINX Instance Manager services:

    ```bash
    sudo systemctl start nms
    ```

    NGINX Instance Manager components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

3. To verify the NGINX Instance Manager services are running, run the following command:

    ```bash
    ps aufx | grep nms
    ```
