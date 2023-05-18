NGINX Controller may fail to install packages from public repositories. To retrieve the list of URLs for all required packages and their dependencies, take the following steps:

1. Run the following script for Debian packages - Ubuntu/Debian:

    ``` bash
    #!/bin/bash

    # (assuming script is saved as $HOME/tmp/k8s-deb.sh)
    # run this as:
    # docker run --rm -it -v $HOME/tmp:/src ubuntu:18.04 /src/k8s-deb.sh

    KUBE_VERSION=1.15.5
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

2. Run the following script for RedHat Enterprise Linux and CentOS:

    ``` bash
    #!/bin/bash

    # run this as:
    # docker run --rm -it -v $HOME/tmp:/src centos:7 /src/k8s-rpm.sh

    KUBE_VERSION=1.15.5
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
<!-- DOCS-359 -->