Take the following steps to install the Security Monitoring module on your NGINX Management Suite host.

1. To install the latest version of the Security Monitoring module, run the following command:

   - CentOS, RHEL, RPM-Based

     ```bash
     sudo yum -y install nms-sm
     ```

   - Debian, Ubuntu, Deb-Based

     ```bash
     sudo apt-get update
     sudo apt-get install -y nms-sm
     ```

1. Restart the NGINX Management Suite services:

    ```bash
    sudo systemctl restart nms
    sudo systemctl restart nms-core
    sudo systemctl restart nms-dpm
    sudo systemctl restart nms-ingestion
    sudo systemctl restart nms-integrations
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

1. To verify the NGINX Management Services are running, run the following command:

    ```bash
    ps aufx | grep nms
    ```

1. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1061 -->