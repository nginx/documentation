---
title: Configure SELinux
weight: 600
toc: true
nd-docs: DOCS-1880
---

## Overview

You can use the optional SELinux policy module included in the package to secure F5 NGINX Agent operations with flexible, mandatory access control that follows the principle of least privilege.

{{< important >}}The SELinux policy module is optional. It is not loaded automatically during installation, even on SELinux-enabled systems. You must manually load the policy module using the steps below.{{< /important >}}

## Before you begin

Take these preparatory steps before configuring SELinux:

1. Enable SELinux on your system.
2. Install the tools `load_policy`, `semodule`, and `restorecon`.
3. [Install NGINX Agent]({{< ref "/nginx-one/agent/install-upgrade/_index.md" >}}) with SELinux module files in place.

{{< important >}}SELinux can use `permissive` mode, where policy violations are logged instead of enforced. Verify which mode your configuration uses.{{< /important >}}

---

## Enable SELinux for NGINX Agent {#selinux-agent}

{{< include "/installation/enable-agent-selinux.md" >}}

### Add ports to NGINX Agent SELinux context

{{< include "/installation/add-ports-agent-selinux.md" >}}

---

## Recommended Resources

- <https://man7.org/linux/man-pages/man8/selinux.8.html>
- <https://www.redhat.com/en/topics/linux/what-is-selinux>
- <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux>
- <https://wiki.centos.org/HowTos/SELinux>
- <https://wiki.gentoo.org/wiki/SELinux>
- <https://opensource.com/business/13/11/selinux-policy-guide>
- <https://www.nginx.com/blog/using-nginx-plus-with-selinux/>