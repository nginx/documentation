To enable and start the NGINX Management Suite and App Delivery Manager services, take the following steps:

1. Enable the NGINX Management Suite services:

    ```bash
    sudo systemctl enable nms-adm
    ```

1. Start the NGINX Management Suite services:

    ```bash
    sudo systemctl start nms-adm
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

1. To verify the NGINX Management Suite services are running, run the following command:

    ```bash
    ps aufx | grep -e "^nms"
    ```
    You should see output similar to the following which shows the nms processes running:

    ```bash
    nms       523559  0.0  1.0 1355748 41580 ?       Ssl  14:39   0:03 /usr/bin/nms-adm server
    nms       523626  0.1  1.1 749056 47472 ?        Ssl  14:39   0:16 /usr/bin/nms-ingestion
    nms       523648  0.0  0.6 735608 26832 ?        Ssl  14:39   0:02 /usr/bin/nms-integrations
    nms       523656  0.2  5.6 944092 228080 ?       Ssl  14:39   0:30 /usr/bin/nms-dpm
    nms       523669  0.0  1.6 794052 66368 ?        Ssl  14:39   0:05 /usr/bin/nms-core
    ```

1. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

<details close>
<summary><i class="fa-solid fa-circle-info"></i> Overview: NGINX Management Suite services</summary>

{{< include "nms/nms-services.md" >}}

</details>

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-000 -->
