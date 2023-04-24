---
aliases:
- /admin-guides/install/install/
authors: []
categories:
- installation
date: "2020-10-26T15:32:41-06:00"
description: This guide explains how to install and update NGINX Controller.
docs: DOCS-255
doctypes:
- tutorial
draft: false
journeys:
- getting started
menu:
  docs:
    parent: Installation
    weight: 30
personas:
- devops
- netops
- secops
roles:
- admin
tags:
- docs
title: Install NGINX Controller
toc: true
weight: 120
---

## Overview

NGINX Controller is NGINX's control-plane solution that manages the NGINX data plane. Built on a modular architecture, NGINX Controller enables you to manage the entire lifecycle of NGINX Plus, whether it's deployed as a load balancer, API gateway, or a proxy in a service mesh environment.

To get started, download and run the installer. The installer will:

* Perform prerequisite checks on your system and prompt for any missing dependencies.
* Prompt you to accept the terms of service agreement for NGINX Controller.
* Ask you for a series of parameters including Database, SMTP, Admin user, and FQDN settings.
* Place configuration and log files in appropriate file locations on your host system.
* Add extra repositories to the default package manager like `apt` or `yum` and install required packages.
* Launch NGINX Controller.

&nbsp;

---

### Open Source Software Dependencies

NGINX Controller uses a number of open source software packages in the product. You can find information about these dependencies in the [NGINX Controller Technical Specifications]({{< relref "/admin-guides/install/nginx-controller-tech-specs.md" >}}).

&nbsp;

---

## Before You Begin

Before installing NGINX Controller, review the following prerequisites.

{{< important >}}
NGINX Controller should be deployed on a secure, internal network only. We strongly recommend against exposing the NGINX Controller API to the internet.
{{< /important >}}

Things you'll need before installing NGINX Controller:

* The `controller-installer-<version>.tar.gz` package, downloaded from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads);

* A license file for NGINX Controller, accessible via the [MyF5 Customer Portal](https://account.f5.com/myf5);

* A dedicated environment (bare metal, VM, or cloud-hosted instance) on which to install NGINX Controller. For the supported Operating Systems and recommended specifications, see the [NGINX Controller Technical Specifications]({{< relref "admin-guides/install/nginx-controller-tech-specs" >}}) guide;

&nbsp;

---

## Install NGINX Controller Prerequisites

{{< include "controller/installer/helper-script/prereqs.md" >}}

&nbsp;

---

### Linux Utilities

The following Linux utilities are required by the installation script. The script will let you know if any of the utilities are missing.

* `awk`
* `bash` (4.0 or later)
* `conntrack`
* `coreutils`: `base64`, `basename`, `cat`, `comm`, `dirname`, `head`, `id`, `mkdir`, `numfmt`, `sort`, `tee`
* `curl` or `wget`
* `ebtables`
* `envsubst` (provided by the `gettext` package)
* `ethtool`
* `getent`
* `grep`
* `gunzip` (provided by the `gzip` package)
* `iproute`
* `iptables`
* `jq` (1.5 or later)
* `less`
* `openssl`
* `sed`
* `socat`
* `tar`
* `util-linux`
* `yum-plugin-versionlock` on RedHat/CentOS

&nbsp;

---

### Docker Requirements

If you have Internet access, NGINX Controller will install Docker for you as part of the installation process.

If you prefer to install Docker on the host yourself, install the following:

* [Docker Community Edition (CE)](https://docs.docker.com/engine/install/) 18.09
* [Containerd.io](https://containerd.io/) 1.2.10

If you are using Ubuntu-20.04 and want to install Docker on your own, choose the following versions instead:

* [Docker Community Edition (CE)](https://docs.docker.com/engine/install/ubuntu/) 19.03
* [Containerd.io](https://containerd.io/) 1.2.13

{{< see-also >}}
For instructions on installing Docker in offline scenarios on CentOS/RHEL 7, refer to the AskF5 [K84431427](https://support.f5.com/csp/article/K84431427) knowledge base article.{{< /see-also >}}

{{< important >}} You need to enable Docker log rotation to ensure that the logs don't consume all the free disk space on the server. For instructions on how to enable Docker log rotation, see the Docker guides [Configure logging drivers](https://docs.docker.com/config/containers/logging/configure/) and [JSON File logging driver](https://docs.docker.com/config/containers/logging/json-file/).{{< /important >}}&nbsp;

#### Red Hat Enterprise Linux

To create container images on Red Hat Enterprise Linux, Red Hat requires you to register and entitle the host computer on which you'll build them. In this case, the host is where you're installing NGINX Controller. Once the host is registered with Red Hat, you can install Docker from the Red Hat Enterprise Linux Extras repository. See the [Red Hat "Getting Started with Containers"](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html-single/getting_started_with_containers/index#getting_docker_in_rhel_7) guide for instructions.


&nbsp;

---

### Kubernetes Requirements

NGINX Controller ships with a required version of Kubernetes and will install Kubernetes for you. Be sure to install NGINX Controller on a dedicated node that **does not** already have Kubernetes configured.

The following table lists the Kubernetes versions that are  installed by NGINX Controller:

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>
| NGINX&nbsp;Controller | Kubernetes         |
|-----------------------|--------------------|
| v3.x                  | v1.15.5 |

The [Kubernetes Pod DNS config](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-dns-config) has a limit of six configured DNS search domain names. This is also the [`glibc` limit](https://man7.org/linux/man-pages/man5/resolv.conf.5.html). 

In NGINX Controller, Core-DNS creates three search domains that are determined at run-time and not in `/etc/resolv.conf`:

* `<namespace>.svc.cluster.local`
* `svc.cluster.local`
* `cluster.local <any host resolv.conf search paths>`

In general, changing the settings in NGINX Controller's underlying Kubernetes cluster is not recommended. However, if you do change the cluster's Pod config to allow additional search domains, **you should not add more than three domains**.


&nbsp;

---

### PostgreSQL (Optional)

When installing NGINX Controller, you can choose to have NGINX Controller install and manage a self-hosted -- also known as "embedded" -- [PostgreSQL](https://www.postgresql.org/) config database for you; this is the recommended implementation. If you choose to use the embedded, self-hosted config database, you can skip this section.

Alternatively, you can install your own PostgreSQL database for the config database, which you manage; this is sometimes referred to as an "external config database" because it is externally managed by you. Continue reading if you're providing your own PostgreSQL database.

Refer to the AskF5 KB article [K49481224](https://support.f5.com/csp/article/K49481224) for instructions on how to install PostgreSQL on CentOS 7 and Ubuntu 18.04 for use with NGINX Controller.

* NGINX Controller supports the following versions of PostgreSQL:

  * PostgreSQL 12.x -- works with NGINX Controller 3.9 and later.
  * PostgreSQL 9.5 -- works with NGINX Controller 3.0 and later.

* The PostgreSQL database must be accessible from the NGINX Controller server. You can use a DNS-resolvable name or an IP address to connect to the database server (names in `/etc/hosts` are not allowed).
* Create the user with the `Create DB` permission.
* Configure PostgreSQL to allow SSL connections; client certificates should also be used for user authentication.

  **We strongly discourage disabling SSL for PostgreSQL for security reasons.** Consult the *Secure TCP/IP Connections with SSL* topic in the PostgreSQL manual for instructions and details:

  * [PostgreSQL 9.5](https://www.postgresql.org/docs/9.5/ssl-tcp.html)
  * [PostgreSQL 12.x](https://www.postgresql.org/docs/12/ssl-tcp.html)

* When installed on external NFS or EFS volumes, the config database should support a throughput of 2 MiB/s or greater.


&nbsp;

---

## Install NGINX Controller

Install NGINX Controller on a dedicated node that **does not** already have Kubernetes configured. NGINX Controller does not support pre-configured Kubernetes implementations at this time. The installer for NGINX Controller will install and configure Kubernetes for you.

{{< important >}}Before installing NGINX Controller, you must **disable swap on the host**; this is required by Kubernetes in order for the kubelet to work properly. Refer to your Linux distribution documentation for specific instructions for disabling swap for your system. For more information about this requirement, see the AskF5 knowledge base article [K82655201](https://support.f5.com/csp/article/K82655201) and the [kubeadm installation guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin) in the Kubernetes documentation.{{< /important >}}

{{< caution >}}**For RHEL 8 deployments**, complete the additional prerequisite steps in the [Installing NGINX on RHEL 8]({{< relref "/admin-guides/install/install-nginx-controller-rhel-8.md" >}}) guide before installing NGINX Controller. RHEL 8 support is a **beta** feature.{{< /caution >}}

To install NGINX Controller, take the following steps:

1. Download the NGINX Controller installer package from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads).
1. Extract the installer package files:

    ```bash
    tar xzf controller-installer-<version>.tar.gz
    ```

1. Run the install script:

    ```bash
    cd controller-installer
    ./install.sh
    ```

    {{< important >}}Installing NGINX Controller as `root` is **not supported** on multi-node clusters. Instead, create a user with `sudo` permission for installing and performing all operations with NGINX Controller. Further, NGINX Controller scripts should also run with this dedicated user; scripts shouldn't be run as `sudo`, `sudo su`, or as the `root` user directly.{{< /important >}}

    {{< note >}}If an HTTPS proxy is configured for the whole system, you should disable the proxy for the IP address and hostname of the host that you're running the NGINX Controller install script on.
    For example, run the command `export NO_PROXY=<current_ip>,<current_hostname>`. {{< /note >}}

    The installation script walks through a series of steps and asks for the following input:

    - **Config database configuration**. Specify whether to use an embedded, self-hosted PostgreSQL database for the config database, or if you want to provide your own external PostgreSQL database. If you choose to provide your own database, make sure you've reviewed the [PostgreSQL prerequisites](#postgresql-optional).
    - **Config database volume type**: Specify the type of volume to use to store the config database: local, NFS, or AWS. We recommend choosing `local` only for demo and trial purposes.

      {{< see-also >}}Refer to the [NGINX Controller Technical Specifications Guide]({{< relref "admin-guides/install/nginx-controller-tech-specs.md#local-or-external-storage" >}}) for more information about the volume options and requirements.{{< /see-also >}}

    - **Analytics database volume type**: Specify the type of volume to use to store the analytics database: local, NFS, or AWS. We recommend choosing `local` for demo and trial purposes.
    - **EULA**: Read the end-user license agreement. Type either `y` to accept or `n` to exit.
    - **SMTP**
      - **SMTP Host**: Provide the host name or IP address of an SMTP server. This is used to send password recovery emails. For trial purposes, if you don't need to receive these communications, you can enter a value of "example.com" or something similar.
      - **SMTP Port**: The port of the SMTP server.
      - **SMTP Authentication**: Select `y` or `n` to authenticate when connecting to the SMTP server.
      - **Use TLS for SMTP Communication**: Select `y` or `n` to use SSL for SMTP server connections.
      - **Do not reply email address**: The sender's email address. For example, `donotreply@example.com`.
    - **Admin**
      - **First name**: The first name for the initial admin user.
      - **Last name**: The last name for the initial admin user.
      - **Email address**: The contact email address for the initial admin user.
      - **Password**: The initial admin's password. Passwords must be 6-64 characters long and must include letters and digits.
    - **FQDN**: Fully qualified domain name (FQDN) -- a resolvable domain name for the NGINX Controller server. The FQDN is used by Controller Agents when connecting to NGINX Controller.
    {{< note >}}We recommend setting the FQDN to a internal address when possible, to avoid exposing the traffic between the Agent and NGINX Controller. This also reduces the external traffic in cloud environments. {{< /note >}}
    - **SSL/TLS certificates**: Type `y` to generate and use self-signed certs for running NGINX Controller over HTTPS, or type `n` to provide your own certs.

        {{< important >}}If you provide your own SSL/TLS certificates, you'll need a complete certificate chain file, with the intermediate CA cert appended to the server cert; the server certificate must appear **before** the chained certificates in the combined file. If the certificate contains a wildcard Common Name (CN=*.example.com) it must also contain a Subject Alternate Name (SAN=nginx-controller.example.com). {{< /important >}}

1. Log in to the NGINX Controller browser interface by navigating to the DNS, FQDN, or IP address of the NGINX Controller host, for example, `https://<Controller-FQDN>/login`. Use the admin email address and password that you provided during the installation process.

1. Once the NGINX Controller installation has completed, you may safely delete the installer package that you downloaded and extracted.


&nbsp;

---

## License NGINX Controller

To add a license to NGINX Controller, take the following steps:

1. Go to `https://<Controller-FQDN>/platform/license` and log in.
1. In the **Upload a license** section, select an upload option:

    - **Upload license file** -- Locate and select your license file in the file explorer.
    - **Paste your Association Token or license file** -- Paste your customer Association Token or the contents of your NGINX Controller license file. These are available on the [MyF5 Customer Portal](https://account.f5.com/myf5).

1. Select **Save license**.

{{< see-also >}}
To add a license using the [NGINX Controller REST API]({{< relref "api/_index.md" >}}), send a PUT request to the `/platform/license` endpoint. Provide your CAT or NGINX Controller license as a base64-encoded string in the JSON request body.
{{< /see-also >}}


&nbsp;

---

## Back Up Cluster Config and Encryption Keys

After installing NGINX Controller, you should back up the cluster config and encryption keys. You'll need these if you ever need to restore the NGINX config database on top of a new NGINX Controller installation.

- To back up the NGINX Controller cluster configuration and encryption keys:

  ```bash
  /opt/nginx-controller/helper.sh cluster-config save
  ```

  The file is saved to `/opt/nginx-controller/cluster-config.tgz`.

- To restore the cluster's config and encryption keys, take the following steps:

  ```bash
  /opt/nginx-controller/helper.sh cluster-config load <filename>
  ```

&nbsp;

---

## Manage the NGINX Controller Process

You can use the `helper.sh` script to start, stop, restart, and check the status of the NGINX Controller process.

``` bash
/opt/nginx-controller/helper.sh controller start
/opt/nginx-controller/helper.sh controller stop
/opt/nginx-controller/helper.sh controller restart
/opt/nginx-controller/helper.sh controller status
```

&nbsp;

---

## Update NGINX Controller

{{< include "installer/install-guide/update-controller.md" >}}

{{< important >}} After you upgrade NGINX Controller, you also need to [update the NGINX Controller Agent]({{< relref "admin-guides/install/install-nginx-controller-agent" >}}) to the latest version. {{< /important >}}

&nbsp;

---

## Uninstall NGINX Controller

{{< include "installer/install-guide/uninstall-controller.md" >}}

&nbsp;

---

## Install NGINX Controller Agent
{{< see-also >}} If you want to run the NGINX Controller Agent as a non-root user, follow the alternative instructions in the [Install NGINX Controller Agent for Non-root User]({{< relref "/admin-guides/install/install-agent-non-root.md" >}}) guide instead of the steps provided in this section. {{< /see-also >}}

Install the Controller Agent on each NGINX Plus instance that you want to manage and monitor.

{{< include "controller/instances/add-existing-instance.md" >}}

&nbsp;

---

## Troubleshooting

If NGINX Controller isn't working how you expect, see the knowledge base article [K03263142](https://support.f5.com/csp/article/K03263142) for installation troubleshooting procedures.

### Create a Support Package

{{< include "installer/helper-script/create-support-package.md" >}}

&nbsp;

#### Support Package Details

{{< include "installer/helper-script/support-package-details.md" >}}

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}