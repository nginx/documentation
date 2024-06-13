To upgrade Instance Manager in an offline environment, take the following steps:

{{<tabs name="install_nim_offline">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the Instance Manager package files, or use the package provided by your NGINX Sales Team.

2. Upgrade the Instance Manager package:

   ```bash
   sudo yum -y --nogpgcheck update /home/user/nms-instance-manager_<version>.x86_64.rpm
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the Instance Manager package files, or use the package provided by your NGINX Sales Team.

2. Upgrade the Instance Manager package:

   ```bash
   sudo apt-get -y install -f /home/user/nms-instance-manager_<version>_amd64.deb
   ```

{{%/tab%}}
{{</tabs>}}

{{< note >}}
Note, if any NGINX Management Suite modules are installed, one of more of them may need to be upgraded to remain compatible with NGINX Instance Manager. The table of compatible versions can be found here:

- Security Monitoring: <https://docs.nginx.com/nginx-management-suite/security/releases/release-notes/>
- API Connectivity Manager: <https://docs.nginx.com/nginx-management-suite/acm/releases/release-notes/>
{{< /note >}}


3. Restart the NGINX Management Suite services:

    ```bash
    sudo systemctl restart nms
    sudo systemctl restart nms-core
    sudo systemctl restart nms-dpm
    sudo systemctl restart nms-ingestion
    sudo systemctl restart nms-integrations
    ```

4. To verify the NGINX Management Suite services are running, run the following command:

   ```bash
   ps aufx | grep nms
   ```

5. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

{{< include "nim/installation/nim-post-upgrade-steps.md" >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1048 -->