---
docs:
files:
   - content/agent/install-upgrade/uninstall.md
   - content/nginx-one/agent/install-upgrade/uninstall.md
---

Complete the following steps on each host where you've installed NGINX agent:

1. Stop NGINX agent:

   ```shell
   sudo service nginx-agent stop
   ```

1. To uninstall NGINX agent, run the following command:

   ```shell
   sudo pkg delete nginx-agent
   ```