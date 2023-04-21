#

<br>

{{<tabs name="install_nim_offline">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the Instance Manager package files, or use the package provided by your NGINX Sales Team.

2. Install the Instance Manager package:

   ```bash
   sudo yum -y --nogpgcheck install /home/<user>/nms-instance-manager_<version>.x86_64.rpm
   ```

   {{< instance-manager-password >}}

3. (Optional) If you used a custom address, username, or password or enabled TLS when installing ClickHouse, follow the steps in the [Configure ClickHouse]({{< relref "admin-guides/getting-started/configure-clickhouse.md" >}}) guide to update the `nms.conf` file. If you don't do so, NGINX Management Suite won't be able to connect to ClickHouse.

4. (Optional) If you use Vault, follow the steps in the [Configure Vault]({{< relref "admin-guides/getting-started/configure-vault.md" >}}) guide to update the `nms.conf` file. If you don't do so, NGINX Management Suite won't be able to connect to Vault.

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the Instance Manager package files, or use the package provided by your NGINX Sales Team.

2. Install the Instance Manager package:

   ```bash
   sudo apt-get -y install -f /home/user/nms-instance-manager_<version>_amd64.deb
   ```

   {{< instance-manager-password >}}

3. (Optional) If you used a custom address, username, or password or enabled TLS when installing ClickHouse, follow the steps in the [Configure ClickHouse]({{< relref "admin-guides/getting-started/configure-clickhouse.md" >}}) guide to update the `nms.conf` file. If you don't do so, NGINX Management Suite won't be able to connect to ClickHouse.

4. (Optional) If you use Vault, follow the steps in the [Configure Vault]({{< relref "admin-guides/getting-started/configure-vault.md" >}}) guide to update the `nms.conf` file. If you don't do so, NGINX Management Suite won't be able to connect to Vault.

{{%/tab%}}
{{</tabs>}}

5. Enable and start the NGINX Management Suite services:

    ```bash
    sudo systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now
    ```

6. Some systems don't support the `--now` option, so you may need to explicitly start the NGINX Management Suite services:

   ```bash
   sudo systemctl start nms
   sudo systemctl start nms-core
   sudo systemctl start nms-dpm
   sudo systemctl start nms-ingestion
   sudo systemctl start nms-integrations
   ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

7. To verify the NGINX Management Services are running, run the following command:

   ```bash
   ps aufx | grep nms
   ```

8. Restart the NGINX web server:

    ```bash
    sudo systemctl restart nginx
    ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1044 -->