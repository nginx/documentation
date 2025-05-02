---
description: This guide explains how to install and update F5 NGINX Controller.
docs: DOCS-255
title: Install NGINX Controller
toc: true
weight: 120
type:
- tutorial
---

## Overview

F5 NGINX Controller is NGINX's control-plane solution that manages the NGINX data plane. Built on a modular architecture, NGINX Controller enables you to manage the entire lifecycle of NGINX Plus, whether it's deployed as a load balancer, API gateway, or a proxy in a service mesh environment.

To get started, download and run the installer. The installer will:

- Perform prerequisite checks on your system and prompt for any missing dependencies.
- Prompt you to accept the terms of service agreement for NGINX Controller.
- Ask you for a series of parameters including Database, SMTP, Admin user, and FQDN settings.
- Place configuration and log files in appropriate file locations on your host system.
- Add extra repositories to the default package manager like `apt` or `yum` and install required packages.
- Launch NGINX Controller.

&nbsp;

---

### Open Source Software Dependencies

NGINX Controller uses a number of open source software packages in the product. You can find information about these dependencies in the [NGINX Controller Technical Specifications]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md" >}}).

&nbsp;

---

## Before You Begin

Before installing NGINX Controller, review the following prerequisites.

{{< important >}}
NGINX Controller should be deployed on a secure, internal network only. We strongly recommend against exposing the NGINX Controller API to the internet.
{{< /important >}}

Things you'll need before installing NGINX Controller:

- The `controller-installer-<version>.tar.gz` package, downloaded from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads);

- A license file for NGINX Controller, accessible via the [MyF5 Customer Portal](https://account.f5.com/myf5);

- A dedicated environment (bare metal, VM, or cloud-hosted instance) on which to install NGINX Controller. For the supported Operating Systems and recommended specifications, see the [NGINX Controller Technical Specifications]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs" >}}) guide;

&nbsp;

---

## Install NGINX Controller Prerequisites

You can use the NGINX Controller `helper.sh prereqs` command to install the required system packages and Docker CE.

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

| Options  | Description |
|----------|-------------|
| `base`  | Install the required Linux utilities. |
| `docker` | Install Docker CE. |
| `nfs` | Install NFS system packages. |

To install all of the NGINX Controller prerequisites for your system at the same time, take the following steps:

1. Download the NGINX Controller installer package from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads).

1. Extract the installer package files:

    ```bash
    tar xzf controller-installer-<version>.tar.gz
    ```

1. Run the helper script with the `prereqs` option:

    ```bash
    cd controller-installer
    ./helper.sh prereqs
    ```

{{< note >}}
After you've installed NGINX Controller, you can install any of the prerequisites by running the following command:

  ```bash
/opt/nginx-controller/helper.sh prereqs [base|docker|nfs]
```

{{< /note >}}

&nbsp;

---

### Linux Utilities

The following Linux utilities are required by the installation script. The script will let you know if any of the utilities are missing.

- `awk`
- `bash` (4.0 or later)
- `conntrack`
- `coreutils`: `base64`, `basename`, `cat`, `comm`, `dirname`, `head`, `id`, `mkdir`, `numfmt`, `sort`, `tee`
- `curl` or `wget`
- `ebtables`
- `envsubst` (provided by the `gettext` package)
- `ethtool`
- `getent`
- `grep`
- `gunzip` (provided by the `gzip` package)
- `iproute`
- `iptables`
- `jq` (1.5 or later)
- `less`
- `openssl`
- `sed`
- `socat`
- `tar`
- `util-linux`
- `yum-plugin-versionlock` on RedHat/CentOS

&nbsp;

---

### Docker Requirements

If you have Internet access, NGINX Controller will install Docker for you as part of the installation process.

If you prefer to install Docker on the host yourself, install the following:

- [Docker Community Edition (CE)](https://docs.docker.com/engine/install/) 18.09
- [Containerd.io](https://containerd.io/) 1.2.10

If you are using Ubuntu-20.04 and want to install Docker on your own, choose the following versions instead:

- [Docker Community Edition (CE)](https://docs.docker.com/engine/install/ubuntu/) 19.03
- [Containerd.io](https://containerd.io/) 1.2.13

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

- `<namespace>.svc.cluster.local`
- `svc.cluster.local`
- `cluster.local <any host resolv.conf search paths>`

In general, changing the settings in NGINX Controller's underlying Kubernetes cluster is not recommended. However, if you do change the cluster's Pod config to allow additional search domains, **you should not add more than three domains**.


&nbsp;

---

### PostgreSQL (Optional)

When installing NGINX Controller, you can choose to have NGINX Controller install and manage a self-hosted -- also known as "embedded" -- [PostgreSQL](https://www.postgresql.org/) config database for you; this is the recommended implementation. If you choose to use the embedded, self-hosted config database, you can skip this section.

Alternatively, you can install your own PostgreSQL database for the config database, which you manage; this is sometimes referred to as an "external config database" because it is externally managed by you. Continue reading if you're providing your own PostgreSQL database.

Refer to the AskF5 KB article [K49481224](https://support.f5.com/csp/article/K49481224) for instructions on how to install PostgreSQL on CentOS 7 and Ubuntu 18.04 for use with NGINX Controller.

- NGINX Controller supports the following versions of PostgreSQL:

  - PostgreSQL 12.x -- works with NGINX Controller 3.9 and later.
  - PostgreSQL 9.5 -- works with NGINX Controller 3.0 and later.

- The PostgreSQL database must be accessible from the NGINX Controller server. You can use a DNS-resolvable name or an IP address to connect to the database server (names in `/etc/hosts` are not allowed).
- Create the user with the `Create DB` permission.
- Configure PostgreSQL to allow SSL connections; client certificates should also be used for user authentication.

  **We strongly discourage disabling SSL for PostgreSQL for security reasons.** Consult the *Secure TCP/IP Connections with SSL* topic in the PostgreSQL manual for instructions and details:

  - [PostgreSQL 9.5](https://www.postgresql.org/docs/9.5/ssl-tcp.html)
  - [PostgreSQL 12.x](https://www.postgresql.org/docs/12/ssl-tcp.html)

- When installed on external NFS or EFS volumes, the config database should support a throughput of 2 MiB/s or greater.


&nbsp;

---

## Install NGINX Controller

Install NGINX Controller on a dedicated node that **does not** already have Kubernetes configured. NGINX Controller does not support pre-configured Kubernetes implementations at this time. The installer for NGINX Controller will install and configure Kubernetes for you.

{{< important >}}Before installing NGINX Controller, you must **disable swap on the host**; this is required by Kubernetes in order for the kubelet to work properly. Refer to your Linux distribution documentation for specific instructions for disabling swap for your system. For more information about this requirement, see the AskF5 knowledge base article [K82655201](https://support.f5.com/csp/article/K82655201) and the [kubeadm installation guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin) in the Kubernetes documentation.{{< /important >}}

{{< caution >}}**For RHEL 8 deployments**, complete the additional prerequisite steps in the [Installing NGINX on RHEL 8]({{< ref "/controller/admin-guides/install/install-nginx-controller-rhel-8.md" >}}) guide before installing NGINX Controller. RHEL 8 support is a **beta** feature.{{< /caution >}}

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

      {{< see-also >}}Refer to the [NGINX Controller Technical Specifications Guide]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#local-or-external-storage" >}}) for more information about the volume options and requirements.{{< /see-also >}}

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
To add a license using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a PUT request to the `/platform/license` endpoint. Provide your CAT or NGINX Controller license as a base64-encoded string in the JSON request body.
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

To update the NGINX Controller software, take the steps below. When complete, you must also update the Controller Agent software on each monitored NGINX Plus instance.

When updating NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

{{< warning >}} Do not update the nodes in a multi-node cluster in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

{{< caution >}}
We strongly recommend that you make a backup of the following information before proceeding, to avoid potential data and/or configuration loss:

- [Back up the NGINX Controller databases]({{< ref "/controller/admin-guides/backup-restore" >}}).
- Back up the NGINX Controller cluster configuration and encryption keys. These are required if you need to restore the config database on top of a new installation of NGINX Controller.

    ```bash
    /opt/nginx-controller/helper.sh cluster-config save
    ```

- Back up the Controller Agent `agent.conf` file by copying it from its current location to a new location. This file is present on each NGINX Plus instance.

    ```bash
    cp /etc/controller-agent/agent.conf <temporary location>
    ```

{{< /caution >}}

1. Download the installer package from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads).

1. Extract the installer package files:

    ```bash
    tar xzf controller-installer-<version>.tar.gz
    ```

1. Before updating, check the NGINX Controller status to confirm the installation is healthy.

    ```bash
    ./helper.sh controller status
    ```

    Resolve any degradations before updating.

1. Run the update script:

    ```bash
    cd controller-installer
    ./update.sh
    ```

    {{< note >}}If you're upgrading from an older version of NGINX Controller and you installed Controller as root user, use `--allow-with-root` flag when running an update script. {{< /note >}}

1. If you are logged in to NGINX Controller using a web browser, sign out and log in again.

    - To sign out, select your username in the upper right-hand corner, and then select "Sign Out". For optimal performance, also flush your browser cache.

{{< important >}} After you upgrade NGINX Controller, you also need to [update the NGINX Controller Agent]({{< ref "/controller/admin-guides/install/install-nginx-controller-agent" >}}) to the latest version. {{< /important >}}

&nbsp;

---

## Uninstall NGINX Controller

To uninstall NGINX Controller, run the uninstall script:

```bash
/opt/nginx-controller/uninstall.sh
```

&nbsp;

---

## Install NGINX Controller Agent
{{< see-also >}} If you want to run the NGINX Controller Agent as a non-root user, follow the alternative instructions in the [Install NGINX Controller Agent for Non-root User]({{< ref "/controller/admin-guides/install/install-agent-non-root.md" >}}) guide instead of the steps provided in this section. {{< /see-also >}}

Install the Controller Agent on each NGINX Plus instance that you want to manage and monitor.

Take the following steps to add an instance to NGINX Controller:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Infrastructure**.
3. On the **Infrastructure** menu, select **Instances** > **Overview**.
4. On the **Instances** overview page, select **Create**.
5. On the **Create Instance** page, select **Add an existing instance**.
6. Add a name for the instance. If you don't provide a name, the hostname of the instance is used by default.
7. To add the instance to an existing [Instance Group]({{< ref "/controller/infrastructure/instances/manage-instances.md#instance-groups" >}}), select an Instance Group from the list. Or to create an Instance Group, select **Create New**.
8. To add the instance to an existing Location, select a Location from the list. Or to create a Location, select **Create New**.

    {{< important >}}
Once set, the Location for an instance cannot be changed. If you need to change or remove the Location for an instance, you must [remove the instance from NGINX Controller]({{< ref "/controller/infrastructure/instances/manage-instances.md#delete-an-instance" >}}), and then add it back.
    {{< /important >}}

    {{< important >}}
Instances and the instance groups they belong to should specify the same location; however, this requirement is not currently enforced. If different locations are specified, the instance group's location takes precedence. This is important to remember when [assigning locations to workload groups]({{< ref "/controller/app-delivery/manage-apps.md#workload-groups">}}).
    {{< /important >}}

9. (Optional) By default, registration of NGINX Plus instances is performed over a secure connection. To use self-signed certificates with the Controller Agent, select **Allow insecure server connections to NGINX Controller using TLS**. For security purposes, we recommend that you secure the Controller Agent with signed certificates when possible.
10. Use SSH to connect and log in to the NGINX instance that you want to connect to NGINX Controller.
11. Run the `curl` or `wget` command that's shown in the **Installation Instructions** section on the NGINX instance to download and install the Controller Agent package. When specified, the `-i` and `-l` options for the `install.sh` script refer to the instance name and Location, respectively.

    {{< note >}}

Make sure you enter the commands to download and run the `install.sh` script on the NGINX Plus system, and not on the NGINX Controller.

NGINX Controller 3.6 and earlier require Python 2.6 or 2.7. You'll be prompted to install Python if it's not installed already. Python is not required for NGINX Controller v3.7 and later.

    {{< /note >}}

After a few minutes, the NGINX instance will appear on the **Instances** overview page.


&nbsp;

---

## Troubleshooting

If NGINX Controller isn't working how you expect, see the knowledge base article [K03263142](https://support.f5.com/csp/article/K03263142) for installation troubleshooting procedures.

### Create a Support Package

You can create a support package for NGINX Controller that you can use to diagnose issues.

{{< note >}}
You will need to provide a support package if you open a ticket with NGINX Support via the [MyF5 Customer Portal](https://account.f5.com/myf5).
{{< /note >}}&nbsp;

```bash
/opt/nginx-controller/helper.sh supportpkg [-o|--output <file name>] [-s|--skip-db-dump] [-t|--timeseries-dump <hours>]
```

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

| Options  | Description |
|----------|-------------|
| `-o` \| `--output`  | Save the support package file to `<file name>`. |
| `-s` \| `--skip-db-dump` | Don't include the database dump in the support package. |
| `-t` \| `--timeseries-dump <hours>` | Include the last `<n hours>` of timeseries data in the support package (default 12 hours). |

Take the following steps to create a support package:

1. Open a secure shell (SSH) connection to the NGINX Controller host and log in as an administrator.

1. Run the `helper.sh` utility with the `supportpkg` option:

    ```bash
    /opt/nginx-controller/helper.sh supportpkg
    ```

    The support package is saved to:

    `/var/tmp/supportpkg-<timestamp>.tar.gz`

    For example:

    `/var/tmp/supportpkg-20200127T063000PST.tar.gz`

1. Run the following command on the machine where you want to download the support package to:

    ``` bash
    scp <username>@<controller-host-ip>:/var/tmp/supportpkg-<timestamp>.tar.gz /local/path
    ```

&nbsp;

#### Support Package Details

The support package is a tarball that includes NGINX Controller configuration information, logs, and system command output. Sensitive information, including certificate keys, is not included in the support package.

The support package gathers information from the following locations:

```md
.
├── database
│   ├── common.dump                                - full dump of the common database
│   ├── common.dump_stderr                         - any errors when dumping the database
│   ├── common-apimgmt-api-client-api-keys.txt     - contents of apimgmt_api_client_api_keys table from the common database
│   ├── common-apimgmt-api-client-groups.txt       - contents of apimgmt_api_client_groups table from the common database
│   ├── common-email-verification.txt              - contents of email_verification table from the common database
│   ├── common-oauth-clients.txt                   - contents of oauth_clients table from the common database
│   ├── common-settings-license.txt                - contents of settings_license table from the common database
│   ├── common-settings-nginx-plus.txt             - contents of settings_nginx_plus table from the common database
│   ├── common-table-size.txt                      - list of all tables and their size in the common database
│   ├── data-table-size.txt                        - list of all tables and their size in the data database
│   ├── postgres-database-size.txt                 - size of every database
│   ├── postgres-long-running-queries.txt          - all queries running longer than 10 seconds
│   ├── system.dump                                - full dump of the system database
│   ├── system-account-limits.txt                  - contents of account_limits table from the system database
│   ├── system-accounts.txt                        - contents of accounts table from the system database
│   ├── system-deleted-accounts.txt                - contents of deleted_accounts table from the system database
│   ├── system-deleted-users.txt                   - contents of deleted_users table from the system database
│   ├── system-users.txt                           - contents of users table from the system database
│   └── system-table-size.txt                      - list of all tables and their size in the system database
├── k8s                                            - output of `kubectl cluster-info dump -o yaml` augmented with some extra info
│   ├── apiservices.txt                            - output of `kubectl get apiservice`
│   ├── kube-system                                - contents of the kube-system namespace
│   │   ├── coredns-5c98db65d4-6flb9
│   │   │   ├── desc.txt                           - pod description
│   │   │   ├── logs.txt                           - current logs
│   │   │   └── previous-logs.txt                  - previous logs, if any
│   │   ├── ...
│   │   ├── daemonsets.yaml                        - list of daemonsets
│   │   ├── deployments.yaml                       - list of deployments
│   │   ├── events.yaml                            - all events in this namespace
│   │   ├── namespace.yaml                         - details of the namespace, including finalizers
│   │   ├── pods.txt                               - output of `kubectl get pods --show-kind=true -o wide`
│   │   ├── pods.yaml                              - list of all pods
│   │   ├── replicasets.yaml                       - list of replicasets
│   │   ├── replication-controllers.yaml           - list of replication controllers
│   │   ├── resources.txt                          - all Kubernetes resources in this namespace
│   │   └── services.yaml                          - list of services
│   ├── nginx-controller                           - contents of the nginx-controller namespace
│   │   ├── apigw-8fb64f768-9qwcm
│   │   │   ├── desc.txt                           - pod description
│   │   │   ├── logs.txt                           - current logs
│   │   │   └── previous-logs.txt                  - previous logs, if any
│   │   ├── ...
│   │   ├── daemonsets.yaml                        - list of daemonsets
│   │   ├── deployments.yaml                       - list of deployments
│   │   ├── events.yaml                            - all events in this namespace
│   │   ├── namespace.yaml                         - details of the namespace, including finalizers
│   │   ├── pods.txt                               - output of `kubectl get pods --show-kind=true -o wide`
│   │   ├── pods.yaml                              - list of all pods
│   │   ├── replicasets.yaml                       - list of replicasets
│   │   ├── replication-controllers.yaml           - list of replication controllers
│   │   ├── resources.txt                          - all Kubernetes resources in this namespace
│   │   ├── services.yaml                          - list of services
│   ├── nodes.txt                                  - output of `kubectl describe nodes`
│   ├── nodes.yaml                                 - list of nodes
│   ├── resources.txt                              - all non-namespaced Kubernetes resources (including PersistentVolumes)
│   └── version.yaml                               - Kubernetes version
├── logs                                           - copy of /var/log/nginx-controller/
│   └── nginx-controller-install.log
├── os
│   ├── cpuinfo.txt                                - output of `cat /proc/cpuinfo`
│   ├── df-h.txt                                   - output of `df -h`
│   ├── df-i.txt                                   - output of `df -i`
│   ├── docker-container-ps.txt                    - output of `docker container ps`
│   ├── docker-images.txt                          - output of `docker images`
│   ├── docker-info.txt                            - output of `docker info`
│   ├── docker-stats.txt                           - output of `docker stats --all --no-stream`
│   ├── docker-version.txt                         - output of `docker version`
│   ├── du-mcs.txt                                 - output of `du -mcs /opt/nginx-controller/* /var/log /var/lib`
│   ├── env.txt                                    - output of `env`
│   ├── firewall-cmd.txt                           - output of `firewall-cmd --list-all`
│   ├── free.txt                                   - output of `free -m`
│   ├── hostname-all-fqdns.txt                     - output of `hostname --all-fqdns`
│   ├── hostname-fqdn.txt                          - output of `hostname --fqdn`
│   ├── hostname.txt                               - output of `hostname`
│   ├── hostsfile.txt                              - output of `cat /etc/hosts`
│   ├── ip-address.txt                             - output of `ip address`
│   ├── ip-neigh.txt                               - output of `ip neigh`
│   ├── ip-route.txt                               - output of `ip route`
│   ├── iptables-filter.txt                        - output of `iptables -L -n -v`
│   ├── iptables-mangle.txt                        - output of `iptables -L -n -v -t mangle`
│   ├── iptables-nat.txt                           - output of `iptables -L -n -v -t nat`
│   ├── iptables-save.txt                          - output of `iptables-save`
│   ├── journal-kubelet.txt                        - output of `journalctl -q -u kubelet --no-pager`
│   ├── lspci.txt                                  - output of `lspci -vvv`
│   ├── netstat-nr.txt                             - output of `netstat -nr`
│   ├── ps-faux.txt                                - output of `ps faux`
│   ├── pstree.txt                                 - output of `pstree`
│   ├── ps.txt                                     - output of `ps aux --sort=-%mem`
│   ├── resolvconf.txt                             - output of `cat /etc/resolv.conf`
│   ├── selinux-mode.txt                           - output of `getenforce`
│   ├── ss-ltunp.txt                               - output of `ss -ltunp`
│   ├── swapon.txt                                 - output of `swapon -s`
│   ├── sysctl.txt                                 - output of `sysctl -a --ignore`
│   ├── systemd.txt                                - output of `journalctl -q --utc`
│   ├── top.txt                                    - output of `top -b -o +%CPU -n 3 -d 1 -w512 -c`
│   ├── uname.txt                                  - output of `uname -a`
│   ├── uptime.txt                                 - output of `cat /proc/uptime`
│   └── vmstat.txt                                 - output of `cat /proc/vmstat`
├── timeseries
│   ├── table-sizes.stat                           - stat table containing controller table sizes
│   ├── events.csv                                 - events table dump in csv
│   ├── events.sql                                 - events table schema
│   ├── metrics_1day.csv                           - metrics_1day table dump in csv
│   ├── metrics_1day.sql                           - metrics_1day table schema
│   ├── metrics_1hour.csv                          - metrics_1hour table dump in csv
│   ├── metrics_1hour.sql                          - metrics_1hour table schema
│   ├── metrics_5min.csv                           - metrics_5min table dump in csv
│   ├── metrics_5min.sql                           - metrics_5min table schema
│   ├── metrics.csv                                - metrics table dump in csv
│   ├── metrics.sql                                - metrics table schema
│   ├── system-asynchronous-metrics.stat           - shows info about currently executing events or consuming resources
│   ├── system-events.stat                         - information about the number of events that have occurred in the system
│   ├── system-metrics.stat                        - system metrics
│   ├── system-parts.stat                          - information about parts of a table in the MergeTree family
│   ├── system-settings.stat                       - information about settings that are currently in use
│   └── system-tables.stat                         - information about all the tables
└── version.txt                                    - Controller version information
```


{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
