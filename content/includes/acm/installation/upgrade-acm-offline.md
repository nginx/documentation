To upgrade API Connectivity Manager in an offline environment, take the following steps:

{{<tabs name="upgrade_acm_offline">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the API Connectivity Manager package files, or use the package provided by your NGINX Sales Team.

2. Upgrade the API Connectivity Manager package:

   ```bash
   sudo yum --nogpgcheck update /home/user/nms-api-connectivity-manager_<version>.x86_64.rpm
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the API Connectivity Manager package files, or use the package provided by your NGINX Sales Team.

2. Upgrade the API Connectivity Manager package:

   ```bash
   sudo apt-get install -f /home/user/nms-api-connectivity-manager_<version>_amd64.deb
   ```

{{%/tab%}}
{{</tabs>}}

When installing API Connectivity Manager, you may need a newer version of NGINX Instance Manager. The installation process will notify you of any version requirements before installing API Connectivity Manager and any dependent packages, including NGINX Instance Manager. You may cancel the installation process if a backup of the NGINX Instance Manager is needed before upgrading.

3. Enable the API Connectivity Manager services:

    ```bash
    sudo systemctl enable nms-acm
    ```

4. Restart the API Connectivity Manager services:

    ```bash
    sudo systemctl restart nms-acm
    ```

    NGINX Instance Manager components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

5. To verify the NGINX Instance Manager services are running, run the following command:

    ```bash
    ps aufx | grep nms
    ```

6. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx  
   ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1020 -->
