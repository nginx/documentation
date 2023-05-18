```eval_rst
.. meta::
   :description: This guide explains how to install NGINX Controller v2.
```

# NGINX Controller Installation Guide v2

Thank you for purchasing NGINX Controller! This guide will help you download, install, and run **NGINX Controller v2.10 and earlier**. The installation will result in a configured, working system ready for you to use to monitor and manage your NGINX Plus instances.

> **Note:** To install the latest version of NGINX Controller, please see [NGINX Controller Installation Guide v3](https://docs.nginx.com/nginx-controller/).

## Overview

NGINX Controller is NGINX's control-plane solution that manages the NGINX data plane. Built on a modular architecture, NGINX Controller enables you to manage the entire lifecycle of NGINX Plus, whether it's deployed as a load balancer, API gateway, or a proxy in a service mesh environment.

To get started, download and run the installer. The installer will:

* Perform prerequisite checks on your system and prompt for any missing dependencies.
* Prompt you to accept the terms of service agreement for NGINX Controller.
* Ask you for a series of parameters including Database, SMTP, Admin user, and FQDN settings.
* Place configuration and log files in appropriate file locations on your host system.
* Add extra repositories to the default package manager like `apt` or `yum` and install required packages.
* Launch NGINX Controller.

## Open Source Software Dependencies

NGINX Controller uses a number of open source software packages in the product. The full list and the license for each package can be found on the [NGINX Controller v2 Technical Specifications](./technical-specs.md) page.

## Prerequisites

<a id="secure-network">

> **Important:** The NGINX Controller should be deployed on a secure, internal network only. We strongly recommend against exposing the NGINX Controller API to the internet.

Before installing NGINX Controller, review the following general prerequisites. Additionally, review the specific requirements and recommendations for the version of NGINX Controller that you're installing, presented below.

Things you'll need before installing NGINX Controller:

* The `controller-installer-<version>.tar.gz` package, downloaded via the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads);

  > **Note**: If you have a trial subscription for NGINX Controller, use the image that was provided on the trial activation page. You don't need to log in to the NGINX Customer Portal.

* A license file for NGINX Controller, accessible at the [MyF5 Customer Portal](https://account.f5.com/myf5);

  > **Note**: If you have a trial subscription for NGINX Controller, use the license that was provided on the trial activation page. You don't need to log in to the NGINX Customer Portal.

* A dedicated environment (bare metal, VM, or cloud-hosted instance) on which to install NGINX Controller:
  * For the supported Operating Systems and recommended specifications, see the [NGINX Controller Technical Specifications](https://docs.nginx.com/nginx-controller/technical-specs/) guide;

* [PostgreSQL](https://www.postgresql.org/) 9.5:

  > For instructions on how to install PostgreSQL 9.5 on CentOS 7 and Ubuntu 18.04 for use with NGINX Controller, see the AskF5 KB article [K49481224](https://support.f5.com/csp/article/K49481224).

  > **Important**: Configure PostgreSQL to allow SSL connections; client certificates should also be used for user authentication. (We strongly discourage disabling SSL for PostgreSQL for security reasons.) See section [17.9 Secure TCP/IP Connections with SSL](https://www.postgresql.org/docs/9.5/ssl-tcp.html) of the PostgreSQL 9.5 manual for instructions and details.

  * The PostgreSQL database must be accessible from the NGINX Controller server. You can use a DNS-resolvable name or an IP address to connect to the database server (names in /etc/hosts are not allowed).
  * Create the user with the `Create DB` permission.

* The following Linux utilities are required by the installation script. The script will let you know if any of the utilities are missing.
  * `curl` or `wget`, `jq` (1.5 or later), `envsubst`
  * `awk`, `bash` (4.0 or later), `getent`, `grep`, `gunzip`, `less`, `openssl`, `sed`, `tar`
  * `base64`, `basename`, `cat`, `dirname`, `head`, `id`, `mkdir`, `numfmt`, `sort`, `tee`

* Docker Community Edition (CE) 18.09, if you're installing Docker yourself. If you don't have Docker installed, NGINX Controller will install it for you.

  > **Tip**: (NGINX Controller v2.8 and later) When you install NGINX Controller, if you allow NGINX Controller to install Docker for you, NGINX Controller sets `systemd` as the cgroup driver. This is recommended by Kubernetes to help protect against system instability. If you have Docker installed already, the Controller installer will warn you if you should change the cgroup driver to `systemd`. For background information regarding this recommendation, plus instructions on how to change the cgroup driver, see the Kubernetes doc [Container runtimes > Cgroup drivers](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cgroup-drivers).

## Additional Requirements for NGINX Controller v2.8 and Later

NGINX Controller v2.8 introduces Kubernetes as the orchestration tool for the NGINX Controller containers.

The following requirements are specific to NGINX Controller v2.8 and later and are in addition to those noted above:

* Disable swap on the NGINX Controller host; this is required by Kubernetes in order for the kubelet to work properly. Refer to your Linux distribution documentation for specific instructions for disabling swap for your system. For more information about this requirement, see the AskF5 knowledge base article [K82655201](https://support.f5.com/csp/article/K82655201) and the [kubeadm installation guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin) in the Kubernetes documentation.

* Enable log rotation for the Docker logs so that the logs don't consume all the free disk space on the server. For instructions on how to enable Docker log rotation, see the Docker guides [How to set up log rotation post installation](https://success.docker.com/article/how-to-setup-log-rotation-post-installation) and [JSON File logging driver](https://docs.docker.com/config/containers/logging/json-file/).

* The installer for NGINX Controller requires Internet access to download Kubernetes and perform the installation. If you prefer or need to install Kubernetes yourself, see the note about offline installations in the [Installing NGINX Controller](#installing-nginx-controller) section for important guidance.

* Install NGINX Controller on a dedicated node that **does not** already have Kubernetes configured.

### Docker and Kubernetes Version Requirements

NGINX Controller v2.8 and later requires the following versions of Kubernetes (client and server):

* NGINX Controller 2.8-2.9: requires Kubernetes 1.15.3

The installer for NGINX Controller v2.8 and later downloads the following items:

* /bin/kubelet -- v1.15.3
* /bin/kubeadm -- v1.15.3
* /bin/kubectl -- v1.15.3
* Flannel Deployment Configuration -- v1.15.3
* docker image k8s.gcr.io/coredns -- 1.3.1
* docker image k8s.gcr.io/etcd -- 3.3.10
* docker image quay.io/coreos/flannel -- v0.11.0-amd64
* docker image k8s.gcr.io/kube-apiserver -- v1.15.3
* docker image k8s.gcr.io/kube-controller-manager -- v1.15.3
* docker image k8s.gcr.io/kube-proxy -- v1.15.3
* docker image k8s.gcr.io/kube-scheduler -- v1.15.3
* docker image k8s.gcr.io/pause -- 3.1

**Note**: Docker images, configurations, and generated files will be removed during the installation cleanup. However, the tools `kubelet`, `kubeadm`, and `kubectl` will not be uninstalled.

### Additional Requirements for NGINX Controller 2.7 and Earlier

The following requirements are specific to NGINX Controller 2.7 and earlier and are in addition to those noted above:

* Docker Compose 1.18.0 or later. For OS-specific installation instructions, see the table in the **Install Compose** section of the [Compose overview](https://docs.docker.com/compose/install/#install-compose).

## Installing NGINX Controller

> **Offline Installations**: (NGINX Controller v2.8 and later) If you prefer or need to install Docker and Kubernetes yourself, then you should install the [required packages and Docker images first](#docker-and-kubernetes-requirements), and then allow the NGINX Controller installation script to configure Kubernetes for you.
>
> To manually download these prerequisites, see the steps in the following procedures:
>
> * [Manually Download Docker Images](#manually-download-docker-images)
> * [Retrieving URLs for All Packages and Dependencies](#retrieving-urls-for-all-packages-and-dependencies)

To install NGINX Controller, take the following steps:

1. Download the NGINX Controller installer package from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads).

    **Note**: If you have a trial subscription for NGINX Controller, use the image that was provided on the trial activation page. You don't need to log in to the NGINX Customer Portal.

2. Extract the installer package files:

    ```bash
    tar xzf controller-installer-<version>.tar.gz
    ```

3. Run the install script:

    ```bash
    cd controller-installer
    ./install.sh
    ```

    The installation script walks through a series of steps and prompts for the following input:

    * Acceptance of the terms of use (type `q` to finish reading it, then `y` to accept).
    * A dedicated platform on which to install NGINX Controller (type `q` to stop installing, then `y` to accept).
    * Database settings (you should configure your own [PostgreSQL](https://www.postgresql.org/) 9.5 database and add the connection credentials in this step).
    * SMTP settings (used to invite new users via email).
    * Fully qualified domain name (FQDN) - a resolvable domain name for your the NGINX Controller server, used to access NGINX Controller in the browser after installation.
    * Admin email, password, organization name, first name, and last name.
    * SSL/TLS certificates for running the web app over HTTPS; the installer can generate self-signed certs if you wish.

    **Note**: Keep the NGINX Controller instance running.

4. Log in to NGINX Controller at `https://<FQDN>/login`. Use the admin email address and password that you provided during the installation process.

5. Upload the NGINX Controller license provided by NGINX, Inc. You can access the license at the [MyF5 Customer Portal](https://account.f5.com/myf5).

    **Note**: If you have a trial subscription for NGINX Controller, use the license that was provided on the trial activation page. You don't need to log in to the NGINX Customer Portal.

    * To upload the license, go to `https://<FQDN>/account/license`. In the "Upload a license" section, select "Choose a file" to add your license file.

6. Lastly, if you're installing NGINX Controller v2.8 or later, make sure to exclude the following Kubernetes packages from package upgrades. Hold these packages at the version stipulated in the [Kubernetes Version Requirements](#kubernetes-version-requirements) table for your version of NGINX Controller:

    * `kubeadm`
    * `kubectl`
    * `kubelet`

    On CentOS or Red Hat Enterprise Linux:

      1. Install `yum-plugin-versionlock`:

         `yum install yum-plugin-versionlock`

      2. For each package to exclude, run `yum versionlock <package name>`.

   On Debian or Ubuntu:

     1. For each package to exclude, run `apt-mark hold <package name>`.
<br>
7. Cleanup

    Once the NGINX Controller installation has completed, you may safely delete the installer package that you downloaded and extracted.

### Documentation

The documentation for NGINX Controller is installed with the product and can be accessed at `https://<FQDN>/docs`.

## Managing the NGINX Controller Process

To start, stop, restart, and check the status of the NGINX Controller process, use the `helper.sh` script found at `/opt/nginx-controller/`:

```bash
./helper.sh controller start
./helper.sh controller stop
./helper.sh controller restart
./helper.sh controller status
```

## Updating NGINX Controller

To update the NGINX Controller software, download and run the newer installer package. You also need to update the Controller Agent software on each monitored NGINX Plus instance.

1. **Important**: We strongly recommend that you make a backup of the following information before updating the Controller:

    * DB: Back up all of the NGINX Controller databases
    * Configuration file: `agent.conf` (this file is on each NGINX Plus instance)
    * The installation directory `/opt/nginx-controller`. This directory contains important files like salt keys and certs.

2. Download the installer package from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads).

3. Extract the installer package files:

    ```bash
    tar xzf controller-installer-<version>.tar.gz
    ```

4. Run the update script:

    ```bash
    cd controller-installer
    ./update.sh
    ```

    **Note**: The update script requires you to confirm that you've backed up the NGINX Controller database.

    Once you've confirmed that you've backed up the database, the update script downloads and starts the updated NGINX Controller software.

5. If you are logged in to NGINX Controller using a web browser, sign out and log in again.

    * To sign out, select your username in the upper right-hand corner, and then select "Sign Out". For optimal performance, also flush your browser cache.

6. Restore your `agent.conf` file over the file in `/etc/controller-agent/agent.conf`.

## Installing the Controller Agent

Install the Controller Agent on each NGINX Plus instance that you want to manage and monitor. Also, after you upgrade NGINX Controller, you should update the Controller Agent to the latest version.

For instructions on how to install, update, and configure the Controller Agent, see the documentation that's installed with NGINX Controller by going to `https://<Controller-FQDN>/docs/infrastructure/agent` in your web browser.

## Uninstalling NGINX Controller

To uninstall NGINX Controller, run the uninstall script:

```bash
/opt/nginx-controller/uninstall.sh
```

In NGINX Controller v2.8 and later, to uninstall NGINX Controller along with Kubernetes (if installed), run the uninstall script with the `--yes-delete-k8s` option:

```bash
/opt/nginx-controller/uninstall.sh --yes-delete-k8s
```

## Troubleshooting

If NGINX Controller isn't working how you expect, try the following troubleshooting steps to help identify the problem. Additionally, if you're installing NGINX Controller v2.8 or later, review the specific troubleshooting steps for those versions, presented below.

* Check the configuration files in `/opt/nginx-controller`:
  * `certs/` (for the web app to run over HTTPS)
  * `docker-compose.yml` (this file is available only if you're running Controller 2.7 or earlier)
* View the log files:
  * If you're running NGINX Controller 2.7 or earlier, the log files for the Controller components are in `/var/log/nginx-controller/`.
  * If you're running NGINX Controller v2.8 or later, you can find the `nginx-controller-install.log` and `nginx-controller-update.log` files in `/var/log/nginx-controller/`. Additionally, if the Controller encounters an issue when installing or updating, the pod logs are extracted automatically to `/var/log/nginx-controller/failure/`.
* Run the `sudo docker ps` command to view the Docker containers.

---

## Additional Troubleshooting for NGINX Controller v2.8 and Later

If NGINX Controller v2.8 or later isn't working how you expect, see the knowledge base article [K03263142](https://support.f5.com/csp/article/K03263142) for additional installation troubleshooting procedures.

### Manually Download Docker images

NGINX Controller v2.8 or later may fail to install when images are not properly loaded from public Docker registries. To pull all images required by Kubernetes and save them into a single file that can be moved to the target host and loaded manually, perform the following procedure:

> **Impact of procedure**: Performing the following procedure should not have a negative impact on your system.

1. Enter the following script:

    ``` bash
    # pull and save Docker images
    # this list is obtained by running the following command:
    # update --kubernetes-version to match the Kubernetes version that's required by your version NGINX Controller
    # kubeadm config images list --kubernetes-version 1.15.3
    # yq -r '.spec.template.spec.containers, .spec.template.spec.initContainers | select( . != null) | .[].image' files/k8s/kube-flannel.yml | sort -u | grep amd64
    images=(
        k8s.gcr.io/kube-proxy:v1.15.3
        k8s.gcr.io/kube-apiserver:v1.15.3
        k8s.gcr.io/kube-controller-manager:v1.15.3
        k8s.gcr.io/kube-scheduler:v1.15.3
        k8s.gcr.io/coredns:1.3.1
        k8s.gcr.io/etcd:3.3.10
        k8s.gcr.io/pause:3.1
        quay.io/coreos/flannel:v0.11.0-amd64
    )
    for i in "${images[@]}"; do
        docker pull "$i"
    done
    docker save "${images[@]}" | gzip > k8s-images.tar.gz
    ```

2. Enter the following command to load the Docker images:

    `gunzip -c k8s-images.tar.gz | docker load`

### Retrieving URLs for All Packages and Dependencies

NGINX Controller v2.8 or later may fail to install packages from public repositories. To retrieve the list of URLs for all required packages and their dependencies, perform the following procedure:

> **Impact of procedure**: Performing the following procedure should not have a negative impact on your system.

1. Enter the following script for Debian packages - Ubuntu/Debian:

    ``` bash
    #!/bin/bash

    # run this as (assuming script is saved as $HOME/tmp/k8s-deb.sh):
    # docker run --rm -it -v $HOME/tmp:/src ubuntu:18.04 /src/k8s-deb.sh

    KUBE_VERSION=1.15.3
    packages=(
        "kubeadm=${KUBE_VERSION}-00"
        "kubelet=${KUBE_VERSION}-00"
        "kubectl=${KUBE_VERSION}-00"
    )
    apt-get update -qq && apt-get install -qq -y apt-transport-https curl gnupg2 >/dev/null
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list >/dev/null
    apt-get update -qq

    echo ""
    echo "Fetch the following files:"
    apt-get install --reinstall --print-uris -qq "${packages[@]}" | cut -d"'" -f2

    echo ""
    echo "Install packages:"
    echo "dpkg -i *.deb"
    ```

2. Enter the following script for RPM Packages - RedHat/CentOS:

    ``` bash
    #!/bin/bash

    # run this as:
    # docker run --rm -it -v $HOME/tmp:/src centos:7 /src/k8s-rpm.sh

    KUBE_VERSION=1.15.3
    packages=(
      "kubeadm-${KUBE_VERSION}-0.x86_64"
      "kubelet-${KUBE_VERSION}-0.x86_64"
      "kubectl-${KUBE_VERSION}-0.x86_64"
    )
    tee -a /etc/yum.repos.d/kubernetes.repo <<EOF 1>/dev/null
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    EOF
    yum install -y -q yum-utils 2>/dev/null

    echo ""
    echo "Fetch the following files:"
    yumdownloader -y -q --resolve --urls "${packages[@]}" 2>/dev/null

    echo ""
    echo "Install packages:"
    echo "rpm -i *.rpm"
    ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-334 -->