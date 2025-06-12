---
docs:
---

The following SELinux files are added when you install the NGINX Agent package:

- `/usr/share/selinux/packages/nginx_agent.pp` - loadable binary policy module
- `/usr/share/selinux/devel/include/contrib/nginx_agent.if` - interface definitions file
- `/usr/share/man/man8/nginx_agent_selinux.8.gz` - policy man page

To load the NGINX Agent policy, run:

```bash
sudo semodule -n -i /usr/share/selinux/packages/nginx_agent.pp
sudo /usr/sbin/load_policy
sudo restorecon -R /usr/bin/nginx-agent
sudo restorecon -R /var/log/nginx-agent
sudo restorecon -R /etc/nginx-agent
```

### Add ports to NGINX Agent SELinux context

Make sure to add external ports to the firewall exception list.

To allow external ports outside the HTTPD context, run:

```bash
sudo setsebool -P httpd_can_network_connect 1
```

{{<see-also>}}For more information, see [Using NGINX and NGINX Plus with SELinux](https://www.nginx.com/blog/using-nginx-plus-with-selinux/).{{</see-also>}}
