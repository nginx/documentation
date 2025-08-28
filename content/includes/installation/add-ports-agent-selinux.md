---
docs:
files:
  - content/nginx-one/agent/configure-instances/configure-selinux.md
  - content/nim/system-configuration/configure-selinux.md
  - content/nms/nginx-agent/install-nginx-agent.md
---

Make sure to add external ports to the firewall exception list.

To allow external ports outside the HTTPD context, run:

```bash
sudo setsebool -P httpd_can_network_connect 1
```

{{< call-out "note" >}}For more information, see [Using NGINX and NGINX Plus with SELinux](https://www.nginx.com/blog/using-nginx-plus-with-selinux/).{{< /call-out>}}