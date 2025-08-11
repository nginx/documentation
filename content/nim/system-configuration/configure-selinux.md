---
nd-docs: DOCS-796
title: Configure SELinux
toc: true
weight: 250
type:
- how-to
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Overview

You can use the optional SELinux policy module included in the package to secure F5 NGINX Instance Manager operations with flexible, mandatory access control that follows the principle of least privilege.

The scope of the SELinux policy allows NGINX Instance Manager to perform all operations needed to support the default configuration. This includes inter-process communication on the default Unix sockets and TCP as an alternative. Other changes may require manual adjustments to the default policy for the application to work.

{{< call-out "important" >}}The SELinux policy module is optional. It is not loaded automatically during installation, even on SELinux-enabled systems. You must manually load the policy module using the steps below.{{< /call-out >}}

---

## Before you begin

Take these preparatory steps before configuring SELinux:

1. Enable SELinux on your system.
2. Install the tools `load_policy`, `semodule`, and `restorecon`.
3. [Install NGINX Instance Manager]({{< ref "/nim/deploy/_index.md" >}}) with SELinux module files in place.

{{< call-out "important" >}}SELinux can use `permissive` mode, where policy violations are logged instead of enforced. Verify which mode your configuration uses.{{< /call-out >}}

---

## Install NGINX Instance Manager policy {#selinux-install}

The NGINX Instance Manager installer places SELinux policy files in these locations:

- `/usr/share/selinux/packages/nms.pp` - loadable binary policy module
- `/usr/share/selinux/devel/include/contrib/nms.if` - interface definitions file
- `/usr/share/man/man8/nms_selinux.8.gz` - policy man page

You can load and configure the SELinux policy using the following steps.

### Load policy and set default labels {#selinux-server}

To load the SELinux policy included with NGINX Instance Manager:

1. Load the NGINX Instance Manager policy:

    ```bash
    sudo semodule -n -i /usr/share/selinux/packages/nms.pp
    sudo /usr/sbin/load_policy
    ```

2. Restore default SELinux labels for related files and directories:

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

3. Restart NGINX Instance Manager services:

    ```bash
    sudo systemctl restart nms
    ```

### Add ports to SELinux context {#selinux-ports-add}

NGINX Instance Manager uses the `nms_t` context in the policy module. To add new TCP ports to this context:

1. Add TCP ports `10000` and `11000` to the `nms_port_t` context:

    ```bash
    sudo semanage port -a -t nms_port_t -p tcp 10000
    sudo semanage port -a -t nms_port_t -p tcp 11000
    ```

2. If the port context is already defined, use `-m` to modify it:

    ```bash
    sudo semanage port -m -t nms_port_t -p tcp 10000
    sudo semanage port -m -t nms_port_t -p tcp 11000
    ```

3. Verify the port has the correct label:

    ```bash
    seinfo --portcon=10000
    seinfo --portcon=11000
    ```

### Remove ports from SELinux context {#selinux-ports-remove}

If you uninstall NGINX Instance Manager, remove the associated ports:

```bash
sudo semanage port -d -t nms_t 10000
sudo semanage port -d -t nms_t 11000
```

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
