#
{{<tabs name="upgrade_adm">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To upgrade to the latest version of App Delivery Manager, run the following command:

   ```bash
   sudo yum update -y nms-app-delivery-manager
   ```

   When installing App Delivery Manager, you may need a newer version of NGINX Management Suite. The installation process will notify you of any version requirements before installing App Delivery Manager and any dependent packages, including NGINX Management Suite. You may cancel the installation process if a backup of the NGINX Management Suite is needed before upgrading.

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To upgrade to the latest version of App Delivery Manager, run the following commands:

   ```bash
   sudo apt-get update
   sudo apt-get upgrade -y nms-app-delivery-manager
   ```

   When installing App Delivery Manager, you may need a newer version of NGINX Management Suite. The installation process will notify you of any version requirements before installing App Delivery Manager and any dependent packages, including NGINX Management Suite. You may cancel the installation process if a backup of the NGINX Management Suite is needed before upgrading.

   {{%/tab%}}
{{</tabs>}}

2. Enable the NGINX Management Suite services:

    ```bash
    sudo systemctl enable nms-adm
    ```

3. Start the NGINX Management Suite services:

    ```bash
    sudo systemctl restart nms-adm
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

4. To verify the NGINX Management Suite services are running, run the following command:

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

5. Restart the NGINX web server:

    ```bash
    sudo systemctl restart nginx
    ```


<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-000 -->
