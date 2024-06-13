---
description: Learn how to load the provided NGINX Management Suite SELinux policy
  to secure your NGINX Management Suite deployment.
docs: DOCS-796
doctypes:
- task
tags:
- docs
title: Configure SELinux
toc: true
weight: 250
---

{{< shortversions "2.0.0" "latest" "nimvers" >}}

## Overview

You can use the optional SELinux policy module included in the package to secure NGINX Management Suite operations with flexible, mandatory access control that follows the principle of least privilege.

The scope of the SELinux policy allows NGINX Management Suite to perform all operations needed to support the default configuration. This includes inter-process communication on the default Unix sockets and TCP as an alternative. Other changes may require manual adjustments to the default policy for the application to work.

{{< important >}}The attached SELinux policy module is optional. As such, the module is not loaded automatically during installation even on SELinux-enabled systems. You must manually load the policy module as detailed in the following steps.{{< /important >}}

---

## Before You Begin

To complete this tutorial, take the following preparatory steps:

1. Enable SELinux on your system.
2. Install the following tools: `load_policy`, `semodule`, and `restorecon`.
3. [Install NGINX Management Suite]({{< relref "/nms/installation/vm-bare-metal/_index.md" >}}) with SELinux module files in place.

{{< important >}}SELinux can be configured to use `permissive` mode. In `permissive` mode, policy violations are logged instead of enforced. Make sure you know which mode your SELinux configuration uses.{{< /important >}}

---

## Install NGINX Management Suite Policy {#selinux-install}

The NGINX Management Suite installer places the SELinux policy files in the following locations:

- `/usr/share/selinux/packages/nms.pp` - loadable binary policy module
- `/usr/share/selinux/devel/include/contrib/nms.if` - interface definitions file
- `/usr/share/man/man8/nms_selinux.8.gz` - policy man page

You can interact with these files to learn about the policy. See the following section for steps on how to load the policy.

### Load Policy and Set Default Labels {#selinux-server}

To use the SELinux policy that's included with NGINX Management Suite, take the following steps:

1. Load the NGINX Management Suite policy:

    ```bash
    sudo semodule -n -i /usr/share/selinux/packages/nms.pp
    sudo /usr/sbin/load_policy
    ```

1. Run the following commands to restore the default SELinux labels for the files and directories related to NGINX Management suite:

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

1. (API Connectivity Manager) If you installed API Connectivity Manager, run the following additional commands to restore the default SELinux labels for the following files and directories:

    ```bash
    sudo restorecon -F -R /usr/bin/nms-acm
    sudo restorecon -F -R /usr/lib/systemd/system/nms-acm.service
    sudo restorecon -F -R /var/lib/nms/modules/acm.json
    ```

1. Restart the NGINX Management Suite services:

    ```bash
    sudo systemctl restart nms
    ```

### Add Ports to SELinux Context {#selinux-ports-add}

NGINX Management Suite uses the `nms_t` context in the policy module. The following example shows how to add a new port to the context. You should add external ports to the firewall exception list. Note, as a system admin, you're responsible for any custom configurations that differ from the default policy.

To add TCP ports `10000` and `11000` to the `nmx_t` context, run the following commands:

```bash
sudo semanage port -a -t nms_port_t -p tcp 10000
sudo semanage port -a -t nms_port_t -p tcp 11000
```

If you've already defined the port context, use `-m`:

```bash
sudo semanage port -m -t nms_port_t -p tcp 10000
sudo semanage port -m -t nms_port_t -p tcp 11000
```

Verify the port has the correct label by running the the following `seinfo --portcon` commands:

``` bash
$ seinfo --portcon=10000

Portcon: 4
   portcon sctp 1024-65535 system_u:object_r:unreserved_port_t:s0
   portcon tcp 10000 system_u:object_r:nms_port_t:s0
   portcon tcp 1024-32767 system_u:object_r:unreserved_port_t:s0
   portcon udp 1024-32767 system_u:object_r:unreserved_port_t:s0

$ seinfo --portcon=11000

Portcon: 4
   portcon sctp 1024-65535 system_u:object_r:unreserved_port_t:s0
   portcon tcp 1024-32767 system_u:object_r:unreserved_port_t:s0
   portcon tcp 11000 system_u:object_r:nms_port_t:s0
   portcon udp 1024-32767 system_u:object_r:unreserved_port_t:s0
```

### Remove Ports from SELinux Context {#selinux-ports-remove}

If you uninstall NGINX Management Suite, you should remove the ports. To do this, run the following commands:

```bash
sudo semanage port -d -t nms_t 10000
sudo semanage port -d -t nms_t 11000
```

---

## Enabling SELinux for NGINX Agent {#selinux-agent}

The following SELinux files are added when installing the NGINX Agent package:

- `/usr/share/selinux/packages/nginx_agent.pp` - loadable binary policy module
- `/usr/share/selinux/devel/include/contrib/nginx_agent.if` - interface definitions file
- `/usr/share/man/man8/nginx_agent_selinux.8.gz` - policy man page

To load the NGINX Agent policy, run the following commands:

{{< include "installation/agent-selinux.md" >}}

### Add Ports to NGINX Agent SELinux Context

You can configure the NGINX Agent to work with SELinux. Make sure you add external ports to the firewall exception list.

The following example shows how to allow external ports outside the HTTPD context. You may need to enable NGINX to connect to these ports.

```bash
sudo setsebool -P httpd_can_network_connect 1
```

{{<see-also>}}For additional information on using NGINX with SELinux, refer to the guide [Using NGINX and NGINX Plus with SELinux](https://www.nginx.com/blog/using-nginx-plus-with-selinux/).{{</see-also>}}

---

## Recommended Resources

- <https://man7.org/linux/man-pages/man8/selinux.8.html>
- <https://www.redhat.com/en/topics/linux/what-is-selinux>
- <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux>
- <https://wiki.centos.org/HowTos/SELinux>
- <https://wiki.gentoo.org/wiki/SELinux>
- <https://opensource.com/business/13/11/selinux-policy-guide>
- <https://www.nginx.com/blog/using-nginx-plus-with-selinux/>
