---
title: "Enforce Security with SELinux Policy"
date: 2021-12-21T12:00:00-07:00
draft: false
description: ""
# Assign weights in increments of 100
weight: 700
toc: true
tags: [ "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["security"]
doctypes: ["task"]
docs: "DOCS-796"
aliases:
- /nginx-instance-manager/admin-guide/selinux-guide/
---

{{< shortversions "2.0.0" "latest" "nimvers" >}}
## Overview

You can use the optional SELinux policy module that's included in the package to secure Instance Manager operations with flexible, mandatory access control that follows the principle of least privilege.

The scope of the SELinux policy allows Instance Manager to perform all the operations needed to support the default configuration, including inter-process communication on the default Unix sockets and TCP as an alternative. Other changes may need manual adjustments to the default policy for the application to work.

{{< important >}}The attached SELinux policy module is optional. As such, the module will not be loaded automatically during an installation even if you are using an SELinux-enabled system and requires manual action to become active.{{< /important >}}

## Before You Begin

To complete this tutorial, take the following preparatory steps:

1. Enable SELinux on your system.
2. Install the following tools: `load_policy`, `semodule`, and `restorecon`.  
3. [Install Instance Manager]({{< relref "/nms/admin-guides/installation/on-prem/install-guide.md" >}}) with SELinux module files in place.

{{< important >}}SELinux can be configured to use `permissive` mode. In `permissive` mode, policy violations are logged instead of enforced. Make sure you know which mode your SELinux configuration uses.{{< /important >}}

## Install the SELinux policy module {#selinux-install}

The Instance Manager installer places the SELinux policy files in the following locations:

- `/usr/share/selinux/packages/nms.pp` - loadable binary policy module
- `/usr/share/selinux/devel/include/contrib/nms.if` - interface definitions file
- `/usr/share/man/man8/nms_selinux.8.gz` - policy man page

You can interact with these files to learn about the policy. See the following section for steps on how to load the policy.

### Load SELinux policy module {#selinux-server}

To use the SELinux policy with Instance Manager, take the following steps before starting the services:

1. Install and load the policy:

    ```bash
    sudo semodule -n -i /usr/share/selinux/packages/nms.pp
    sudo /usr/sbin/load_policy
    ```

2. Label the necessary files according to their definitions:

    ```bash
    sudo restorecon -F -R /usr/bin/nms-core
    sudo restorecon -F -R /usr/bin/nms-dpm
    sudo restorecon -F -R /usr/bin/nms-ingestion
    sudo restorecon -F -R /usr/lib/systemd/system/nms.service
    sudo restorecon -F -R /usr/lib/systemd/system/nms-core.service
    sudo restorecon -F -R /usr/lib/systemd/system/nms-dpm.service
    sudo restorecon -F -R /usr/lib/systemd/system/nms-ingestion.service
    sudo restorecon -F -R /var/lib/nms/modules/manager.json
    sudo restorecon -F -R /var/lib/nms/modules.json
    sudo restorecon -F -R /var/lib/nms/streaming
    sudo restorecon -F -R /var/lib/nms
    sudo restorecon -F -R /var/lib/nms/dqlite
    sudo restorecon -F -R /var/run/nms
    sudo restorecon -F -R /var/lib/nms/modules
    sudo restorecon -F -R /var/log/nms
    ```

3. Restart the Instance Manager services if they are already running.

    ```bash
    sudo systemctl restart nms
    ```

### Add ports to SELinux context {#selinux-ports-add}

Instance Manager uses the `nms_t` context in the policy module. The following example shows how to add a new port to the context. You should add external ports to the firewall exceptions. Note, as a system admin, you're responsible for any custom configurations that differ from the default policy.

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

### Remove ports from SELinux context {#selinux-ports-remove}

If you uninstall Instance Manager, you should remove the ports. To do this, run the following commands:

```bash
sudo semanage port -d -t nms_t 10000
sudo semanage port -d -t nms_t 11000
```

## Enabling SELinux for NGINX Agent {#selinux-agent}

The following SELinux files are added when installing the NGINX Agent package:

- `/usr/share/selinux/packages/nginx_agent.pp` - loadable binary policy module
- `/usr/share/selinux/devel/include/contrib/nginx_agent.if` - interface definitions file
- `/usr/share/man/man8/nginx_agent_selinux.8.gz` - policy man page

You can follow the same steps above to [load the SELinux policy](#selinux-server) for the NGINX Agent.

## Recommended Resources

- https://man7.org/linux/man-pages/man8/selinux.8.html
- https://www.redhat.com/en/topics/linux/what-is-selinux
- https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux
- https://wiki.centos.org/HowTos/SELinux
- https://wiki.gentoo.org/wiki/SELinux
- https://opensource.com/business/13/11/selinux-policy-guide
- https://www.nginx.com/blog/using-nginx-plus-with-selinux/
