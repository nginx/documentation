---
description: This guide explains how to prepare your RHEL 8 system to install F5 NGINX
  Controller and the NGINX Controller Agent.
docs: DOCS-342
title: Install NGINX Controller on RHEL 8 (experimental)
toc: true
weight: 200
type:
- tutorial
---

## Preparing the F5 NGINX Controller Host

To install NGINX Controller on RHEL 8, you must complete the following steps to allow iptables-based routing for Kubernetes. Failure to complete these steps may cause the installation to hang.

### Update System Packages

1. Before completing any other steps, update the packages on your system:

    ```bash
    sudo yum -y upgrade
    ```

### Install and Configure Docker

Docker isn't available on RedHat 8 by default, so you'll need to add a Docker repository and install the required packages:

1. Add the Docker repo:

    ```bash
    sudo yum config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
    ```

1. Install the Docker packages:

    ```bash
    sudo yum install docker-ce-3:19.03.15-3.el8 docker-ce-cli-1:19.03.15-3.el8 containerd.io-1.3.9-3.1.el8
    ```

1. Set up the Docker daemon:

    ```bash
    sudo mkdir -p /etc/docker

    sudo vi /etc/docker/daemon.json
    ```

    Paste the following JSON snippet into `daemon.json`:

    ```json
    {
        "exec-opts": ["native.cgroupdriver=systemd"],
        "log-driver": "json-file",
        "log-opts": {
            "max-size": "10m",
            "max-file": "2"
        },
        "storage-driver": "overlay2"
    }
    ```

1. Run the following commands to set up the Docker service:

    ```bash
    sudo systemctl start docker.service

    sudo systemctl status docker.service

    sudo systemctl enable docker.service
    ```

### Install Required Packages and Kernel Modules

Take the following steps to install the required packages and kernel modules.

1. Install the traffic control utility:

    ``` bash
    sudo yum install iproute-tc
    ```

1. Run the following commands to ensure the required kernel modules are loaded at startup:

    ```bash
    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
    overlay
    br_netfilter
    iptable_nat
    EOF
    ```

1. To load the required kernel modules immediately, run the following commands:

    ```bash
    sudo modprobe overlay
    sudo modprobe br_netfilter
    sudo modprobe iptable_nat
    ```

1. Run the following commands exactly as shown to configure the network:

    ```bash
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-iptables = 1
    net.ipv4.ip_forward = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    EOF
    ```

1. Restart the system configuration:

    ```bash
    sudo sysctl --system
    ```

### Last Steps

Take the following steps to finish preparing the RHEL 8 control plane host for NGINX Controller:

1. When installing Docker on RHEL 8, the `FORWARD` rules in the iptables are reset and need to be corrected. To do this, run the following command:

    ```bash
    sudo iptables -P FORWARD ACCEPT
    ```

1. Finally, turn off swap:

    ```bash
    sudo swapoff -a
    ```

1. Complete the steps in the NGINX Controller Installation guide to [install NGINX Controller]({{< relref "/controller/admin-guides/install/install-nginx-controller.md#install-nginx-controller" >}}).

## Preparing the Data Plane Host

1. For the NGINX Controller Agent to work on RHEL 8, you need to install the following package on each data plane host:

    ``` bash
    sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    sudo dnf install -y xerces-c
    ```

2. Complete the steps in the NGINX Controller Agent Installation guide to [install the NGINX Controller Agent]({{< relref "/controller/admin-guides/install/install-nginx-controller-agent" >}}).

## Troubleshooting

You may encounter the following error when installing or updating NGINX Controller on RHEL 8:

``` text
Status code: 403 for https://cdn.redhat.com/content/dist/rhel8/8/x86_64/appstream/os/repodata/repomd.xml
```

In this case, update your subscription manager on each RHEL 8 host as follows:

```bash
sudo subscription-manager refresh
```
