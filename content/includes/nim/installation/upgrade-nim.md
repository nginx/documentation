#
{{<tabs name="upgrade_nim">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To upgrade to the latest version of the Instance Manger, run the following command:

   ```bash
   sudo yum update -y nms-instance-manager
   ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To upgrade to the latest version of the Instance Manager, run the following command:

   ```bash
   sudo apt-get update
   sudo apt-get install -y --only-upgrade nms-instance-manager
   ```

{{%/tab%}}
{{</tabs>}}

{{< note >}}
Note, if any NGINX Management Suite modules are installed, one of more of them may need to be upgraded to remain compatible with NGINX Instance Manager. The table of compatible versions can be found here:

- Security Monitoring: <https://docs.nginx.com/nginx-management-suite/security/releases/release-notes/>
- API Connectivity Manager: <https://docs.nginx.com/nginx-management-suite/acm/releases/release-notes/>
{{< /note >}}


2. Restart the NGINX Management Suite services:

    ```bash
    sudo systemctl restart nms
    sudo systemctl restart nms-core
    sudo systemctl restart nms-dpm
    sudo systemctl restart nms-ingestion
    sudo systemctl restart nms-integrations
    ```

3. To verify the NGINX Management Services are running, run the following command:

    ```bash
    ps aufx | grep nms
    ```

4. Restart the NGINX web server:

    ```bash
    sudo systemctl restart nginx
    ```

{{< include "nim/installation/nim-post-upgrade-steps.md" >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1047 -->