---
docs: DOCS-1240
---

1. Load the NGINX Management Suite policy:

    ```bash
    sudo semodule -n -i /usr/share/selinux/packages/nms.pp
    sudo /usr/sbin/load_policy
    ```

1. Run the following commands to set the SELinux contexts for the following files and directories to their default values:

   ```bash
   sudo restorecon -F -R /usr/bin/nms-core
   sudo restorecon -F -R /usr/bin/nms-dpm
   sudo restorecon -F -R /usr/bin/nms-ingestion
   sudo restorecon -F -R /usr/bin/nms-integrations
   sudo restorecon -F -R /usr/lib/systemd/system/nms.service
   sudo restorecon -F -R /usr/lib/systemd/system/nms-core.service
   sudo restorecon -F -R /usr/lib/systemd/system/nms-dpm.service
   sudo restorecon -F -R /usr/lib/systemd/system/nms-ingestion.service
   sudo restorecon -F -R /usr/lib/systemd/system/nms-integrations.service
   sudo restorecon -F -R /var/lib/nms/modules/manager.json
   sudo restorecon -F -R /var/lib/nms/modules.json
   sudo restorecon -F -R /var/lib/nms/streaming
   sudo restorecon -F -R /var/lib/nms
   sudo restorecon -F -R /var/lib/nms/dqlite
   sudo restorecon -F -R /var/run/nms
   sudo restorecon -F -R /var/lib/nms/modules
   sudo restorecon -F -R /var/log/nms
   ```

1. (API Connectivity Manager) If you installed API Connectivity Manager, run the following additional commands to set the SELinux contexts for the following files and directories to their default values:

    ```bash
    sudo restorecon -F -R /usr/bin/nms-acm
    sudo restorecon -F -R /usr/lib/systemd/system/nms-acm.service
    sudo restorecon -F -R /var/lib/nms/modules/acm.json
    ```

1. (App Delivery Manager) If you installed App Connectivity Manager, run the following additional commands to set the SELinux contexts for the following files and directories to their default values:

    ```bash
    sudo restorecon -F -R /usr/bin/nms-adm
    sudo restorecon -F -R /usr/lib/systemd/system/nms-adm.service
    sudo restorecon -F -R /var/lib/nms/modules/adm.json
    ```

1. Restart the NGINX Management Suite services:

    ```bash
    sudo systemctl restart nms
    ```

