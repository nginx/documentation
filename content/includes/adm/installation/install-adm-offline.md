#
{{<tabs name="install_adm_offline">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the App Delivery Manager package files, or use the package provided by your NGINX Sales Team.

2. Install the App Delivery Manager package:

   ```bash
   sudo yum --nogpgcheck install /home/user/nms-app-delivery-manager_<version>.x86_64.rpm
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the App Delivery Manager package files, or use the package provided by your NGINX Sales Team.

2. Install the App Delivery Manager package:

   ```bash
   sudo apt-get install -f /home/user/nms-app-delivery-manager_<version>_amd64.deb
   ```

{{%/tab%}}
{{</tabs>}}

3. (Optional) If you used a custom address, username, or password or enabled TLS when installing ClickHouse, follow the steps in the [Configure ClickHouse]({{< relref "/nms/admin-guides/configuration/configure-clickhouse.md" >}}) guide to update the `nms.conf` file that is installed in the `/etc/nms` directory. If you don't do so, NGINX Management Suite won't be able to connect to ClickHouse.

1. (Optional) If you use Vault, follow the steps in the [Configure Vault]({{< relref "/nms/admin-guides/configuration/configure-vault.md" >}}) guide to update the `nms.conf` file that is installed in the `/etc/nms` directory. If you don't do so, NGINX Management Suite won't be able to connect to Vault.

When installing App Delivery Manager, you may need a newer version of NGINX Management Suite. The installation process will notify you of any version requirements before installing App Delivery Manager and any dependent packages, including NGINX Management Suite. You may cancel the installation process if a backup of the NGINX Management Suite is needed before upgrading.

1. Enable the App Delivery services:

    ```bash
    sudo systemctl enable nms-adm
    ```

1. Start the App Delivery services:

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

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-000 -->
