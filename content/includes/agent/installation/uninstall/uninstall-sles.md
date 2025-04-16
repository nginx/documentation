---
docs:
files:
   - content/agent/install-upgrade/uninstall.md
   - content/nginx-one/agent/uninstall.md
---

Complete the following steps on each host where you've installed NGINX Agent:

1. Stop NGINX agent:

   ```shell
   sudo systemctl stop nginx-agent
   ```

1. To uninstall NGINX agent, run the following command:

   ```shell
   sudo zypper remove nginx-agent
   ```