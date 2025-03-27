---
title: Configure SELinux
weight: 600
---

## Overview

You can use the optional SELinux policy module included in the package to secure F5 NGINX Agent operations with flexible, mandatory access control that follows the principle of least privilege.

{{< important >}}The SELinux policy module is optional. It is not loaded automatically during installation, even on SELinux-enabled systems. You must manually load the policy module using the steps below.{{< /important >}}

---

## Before you begin

Take these preparatory steps before configuring SELinux:

1. Enable SELinux on your system.
2. Install the tools `load_policy`, `semodule`, and `restorecon`.
3. [Install NGINX Agent]({{< relref "/agent/install-upgrade/install.md" >}}) with SELinux module files in place.

{{< important >}}SELinux can use `permissive` mode, where policy violations are logged instead of enforced. Verify which mode your configuration uses.{{< /important >}}

---

## Enable SELinux for NGINX Agent {#selinux-agent}

The following SELinux files are added when you install the NGINX Agent package:

- `/usr/share/selinux/packages/nginx_agent.pp` - loadable binary policy module
- `/usr/share/selinux/devel/include/contrib/nginx_agent.if` - interface definitions file
- `/usr/share/man/man8/nginx_agent_selinux.8.gz` - policy man page

To load the NGINX Agent policy, run:

{{< include "installation/agent-selinux.md" >}}

{{<see-also>}}For more information, see [Using NGINX and NGINX Plus with SELinux](https://www.nginx.com/blog/using-nginx-plus-with-selinux/).{{</see-also>}}

---

## Recommended Resources

- <https://man7.org/linux/man-pages/man8/selinux.8.html>
- <https://www.redhat.com/en/topics/linux/what-is-selinux>
- <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux>
- <https://wiki.centos.org/HowTos/SELinux>
- <https://wiki.gentoo.org/wiki/SELinux>
- <https://opensource.com/business/13/11/selinux-policy-guide>
- <https://www.nginx.com/blog/using-nginx-plus-with-selinux/>
