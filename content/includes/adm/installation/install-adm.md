To install the latest version of App Delivery Manager, run the following command:

- CentOS, RHEL, RPM-Based

  ```bash
  sudo yum install nms-app-delivery-manager
  ```

- Debian, Ubuntu, Deb-Based

  ```bash
  sudo apt-get update
  sudo apt-get install nms-app-delivery-manager
  ```

When installing App Delivery Manager, you may need a newer version of NGINX Management Suite. The installation process will notify you of any version requirements before installing App Delivery Manager and any dependent packages, including NGINX Management Suite. You may cancel the installation process if a backup of the NGINX Management Suite is needed before upgrading.

On the data planes, you must install NGINX Plus (not NGINX OSS) to use the features provided by App Delivery Manager. Instance groups containing one or more NGINX OSS instances will not accept App Delivery Manager's configuration.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-000 -->
