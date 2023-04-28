---

---

1. Install and load the policy:

    ```bash
    sudo semodule -n -i /usr/share/selinux/packages/nms.pp
    sudo /usr/sbin/load_policy
    ```

2. Label the necessary files according to their definitions:

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

3. Restart the NGINX Management Suite services:

    ```bash
    sudo systemctl restart nms
