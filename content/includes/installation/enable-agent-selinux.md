---
files:
   - content/nginx-one/agent/configure-instances/configure-selinux.md
   - content/nim/system-configuration/configure-selinux.md
   - content/nms/nginx-agent/install-nginx-agent.md
---

The following SELinux files are added when you install the NGINX Agent package:

- `/usr/share/selinux/packages/nginx_agent.pp` - loadable binary policy module
- `/usr/share/selinux/devel/include/contrib/nginx_agent.if` - interface definitions file
- `/usr/share/man/man8/nginx_agent_selinux.8.gz` - policy man page

To load the NGINX Agent policy, run the following commands as root:

```bash
sudo semodule -n -i /usr/share/selinux/packages/nginx_agent.pp
sudo /usr/sbin/load_policy
sudo restorecon -R /usr/bin/nginx-agent
sudo restorecon -R /var/log/nginx-agent
sudo restorecon -R /etc/nginx-agent
```
