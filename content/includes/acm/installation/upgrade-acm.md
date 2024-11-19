#
{{<tabs name="upgrade_acm">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To upgrade to the latest version of API Connectivity Manager, run the following command:

   ```bash
   sudo yum update nms-api-connectivity-manager
   ```

    When installing API Connectivity Manager, you may need a newer version of NGINX Instance Manager. The installation process will notify you of any version requirements before installing API Connectivity Manager and any dependent packages, including NGINX Instance Manager. You may cancel the installation process if a backup of the NGINX Instance Manager is needed before upgrading.

2. Enable the API Connectivity Manager services:

    ```bash
    sudo systemctl enable nms-acm
    ```

3. Restart the API Connectivity Manager services:

    ```bash
    sudo systemctl restart nms-acm
    ```

    NGINX Instance Manager components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

4. To verify the NGINX Instance Manager services are running, run the following command:

    ```bash
    ps aufx | grep nms
    ```

5. Restart the NGINX web server:

    ```bash
    sudo systemctl restart nginx
    ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To upgrade to the latest version of API Connectivity Manager, run the following commands:

   ```bash
   sudo apt-get update
   sudo apt-get install --only-upgrade nms-api-connectivity-manager
   ```

   When installing API Connectivity Manager, you may need a newer version of NGINX Instance Manager. The installation process will notify you of any version requirements before installing API Connectivity Manager and any dependent packages, including NGINX Instance Manager. You may cancel the installation process if a backup of the NGINX Instance Manager is needed before upgrading.

2. Enable the API Connectivity Manager services:

    ```bash
    sudo systemctl enable nms-acm
    ```

3. Restart the API Connectivity Manager services:

    ```bash
    sudo systemctl restart nms-acm
    ```

    NGINX Instance Manager components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

4. To verify the NGINX Instance Manager services are running, run the following command:

    ```bash
    ps aufx | grep nms
    ```

5. Restart the NGINX web server:

    ```bash
    sudo systemctl restart nginx
    ```

   {{%/tab%}}
{{</tabs>}}


<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1021 -->
