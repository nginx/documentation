---
title: Run without root privileges
weight: 450
toc: true
nd-content-type:
  - how-to
product: Agent
nd-docs: DOCS-1781
---

## Overview

If the policies of your organization do not allow running processes as root, you can run NGINX Agent under a user without root privileges.

This also aligns with the principle of least privilege, which is a security concept that limits the access rights of users to the bare minimum permissions they need to perform their work.

---

## Before you begin

Please note that **root access is required to install NGINX Agent**. The agent can be run under a non-root user after the installation.

---

## Installation

The installation process involves installing NGINX Plus without root privileges and then installing NGINX Agent:

### Install NGINX Plus without root privileges

You can install NGINX Plus without root privileges following the steps on the [NGINX Plus installation page]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus/#unpriv_install" >}}). The steps include a script that will allow you to install NGINX Plus in a non-root environment.

{{< call-out "note" >}}
NGINX Agent has its own user group (`nginx-agent`) which is created when NGINX Agent is installed. The user NGINX is running under is added to this user group during the installation of NGINX Agent. If you change the NGINX user after installing NGINX Agent, you will need to [manually add the new NGINX user]({{< ref "/agent/configuration/configure-nginx-agent-group.md" >}}) to the `nginx-agent` group.
{{< /call-out >}}

### Install NGINX Agent

After installing NGINX Plus, you can install NGINX agent following the steps on the [NGINX Agent installation page]({{< ref "/agent/installation-upgrade/installation-oss.md" >}}).

### Start NGINX Agent

Run the command corresponding to your operating system to start NGINX Agent:


| Operating System                                      | Command(s)                                      |
|------------------------------------------------------|------------------------------------------------|
| RHEL, CentOS,<br>Rocky Linux, AlmaLinux,<br>Oracle Linux, Ubuntu,<br>Debian, SLES, Amazon Linux | ```sudo systemctl start nginx-agent``` |
| Alpine Linux                                        | ```sudo rc-service nginx-agent start```<br>or<br>```sudo /etc/init.d/nginx-agent start``` |
| FreeBSD                                             | ```sudo service nginx-agent start``` |

You can confirm that NGINX Agent is running under the same user as NGINX Plus by running the following command:

```bash
ps aux | grep nginx-agent
```
