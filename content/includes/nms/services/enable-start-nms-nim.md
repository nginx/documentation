To enable and start the NGINX Instance Manager platform services, take the following steps:

1. Enable the platform services:

    ```bash
    sudo systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations
    ```

1. Start the platform services:

    ```bash
    sudo systemctl start nms
    ```

1. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

<details close>
<summary><i class="fa-solid fa-circle-info"></i> Overview: NGINX Instance Manager services</summary>

<br>

{{< include "nms/nms-services.md" >}}

</details>

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1043 -->