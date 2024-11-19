To enable and start the API Connectivity Manager services, take the following steps:

1. Enable the API Connectivity Manager services:

    ```bash
    sudo systemctl enable nms-acm
    ```

2. Start the API Connectivity Manager services:

    ```bash
    sudo systemctl start nms-acm
    ```

    NGINX Instance Manager components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

3. To verify the NGINX Instance Manager services are running, run the following command:

    ```bash
    ps aufx | grep nms
    ```

4. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

<details close>
<summary><i class="fa-solid fa-circle-info"></i> Overview: NGINX Instance Manager services</summary>

{{< include "nms/nms-services.md" >}}

</details>

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1010 -->