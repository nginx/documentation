Take the following steps to install the Security Monitoring module on your NGINX Instance Manager host.

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

1. Restart the NGINX Instance Manager services:

    ```bash
    sudo systemctl restart nms
    ```

    NGINX Instance Manager components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

1. To verify the NGINX Management Services are running, run the following command:

    ```bash
    ps aufx | grep nms
    ```

1. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

1. If running Security Monitoring v1.7.0 or higher, start the module:

  ```bash
  sudo systemctl start nms-sm
  ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1061 -->