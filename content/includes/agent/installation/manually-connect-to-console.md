---
docs:
files:
   - content/nginx-one/agent/install-upgrade/install-from-github.md
   - content/nginx-one/agent/install-upgrade/install-from-oss-repo.md
   - content/nginx-one/agent/install-upgrade/install-from-plus-repo.md
---

If you have installed NGINX Agent manually, you will need to connect it to the
NGINX One Console to manage your NGINX instances.

1. Ensure NGINX Agent is installed

   ```shell
   nginx-agent -v
   ```

1. Locate the NGINX Agent Configuration File:

   ```shell
   /etc/nginx-agent/nginx-agent.conf
   ```

1. Open the NGINX Agent configuration file in a text editor like vim:

   ```shell
   sudo vim /etc/nginx-agent/nginx-agent.conf
   ```

1. Uncomment the command block, and set the token to your data plane key
1. Save the changes and close the editor
1. Restart the NGINX Agent service:

   ```shell
   sudo systemctl restart nginx-agent
   ```

1. Check the Agent log for `"Agent Connected"`

   ```shell
   sudo cat /var/log/nginx-agent/agent.log | grep "Agent connected"
   ```