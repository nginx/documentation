After you've successfully upgraded Instance Manager, take the following steps to restart the services and optionally reapply SELinux Policies:

1. Reload NGINX:

   ```bash
   sudo nginx -s reload
   ```

2. (Optional) Reapply the SELinux policy if it's enabled:

   ```bash
   sudo semodule -n -i /usr/share/selinux/packages/nms.pp
   sudo /usr/sbin/load_policy
   sudo restorecon -F -R /usr/bin/nms-core
   sudo restorecon -F -R /usr/bin/nms-dpm
   sudo restorecon -F -R /usr/bin/nms-ingestion
   sudo restorecon -F -R /usr/lib/systemd/system/nms.service
   sudo restorecon -F -R /usr/lib/systemd/system/nms-core.service
   sudo restorecon -F -R /usr/lib/systemd/system/nms-dpm.service
   sudo restorecon -F -R /usr/lib/systemd/system/nms-ingestion.service
   sudo restorecon -F -R /var/lib/nms/modules/manager.json
   sudo restorecon -F -R /var/lib/nms/modules.json
   sudo restorecon -F -R /var/lib/nms/streaming
   sudo restorecon -F -R /var/lib/nms
   sudo restorecon -F -R /var/lib/nms/dqlite
   sudo restorecon -F -R /var/run/nms
   sudo restorecon -F -R /var/lib/nms/modules
   sudo restorecon -F -R /var/log/nms
   ```

3. Restart the Instance Manager services:

   ```bash
   sudo systemctl restart nms
   sudo systemctl restart nms-core
   sudo systemctl restart nms-dpm
   sudo systemctl restart nms-ingestion
   sudo systemctl restart nms-integrations
   ```

4. Make sure to [upgrade the NGINX Agent](#upgrade-nginx-agent) as well.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1046 -->