```eval_rst
.. meta::
   :description: Technical specifications for NGINX Controller v2.
```

# Tech Specs for NGINX Controller v2

This guide lists the technical recommendations for NGINX Controller v2 and the Controller Agent. Review this guide before installing or updating NGINX Controller or the Controller Agent.

> **Note:** For the NGINX v3 technical recommendations, please see [Technical Specifications for NGINX Controller v3](https://docs.nginx.com/nginx-controller/v3/technical-specs/).

## Contents

- [NGINX Controller Technical Specifications](#nginx-controler-technical-specifications)
- [NGINX Controller Agent Technical Specifications](#controller-agent-technical-specifications)
- [Supported Distributions for App-Centric Metrics](#supported-distributions-for-app-centric-metrics)
- [Open-Source Licenses](#open-source-licenses)

---

## NGINX Controller Technical Specifications

### Supported Distributions

NGINX Controller v2 supports the following distributions and architectures.

- CentOS 7 (x86_64)
- Debian 8 (x86_64) -- Works only with NGINX Controller v2.7 and earlier
- Debian 9 (x86_64)
- Red Hat Enterprise Linux 7 (x86_64)
- Ubuntu 16.04 LTS (x86_64)
- Ubuntu 18.04 LTS (x86_64)

### Supported Deployment Environments

You can deploy NGINX Controller v2 into the following environments:

- Bare metal
- Public cloud: Amazon Web Services, Google Cloud Platform, Microsoft Azure
- Virtual Machine

### Supported NGINX Plus Versions

NGINX Controller v2 supports the following NGINX Plus versions:

- NGINX Plus R19
- NGINX Plus R18
- NGINX Plus R17
- NGINX Plus R16
- NGINX Plus R15

### Supported Browsers

NGINX Controller works best with the newest and the last prior version of these browsers with JavaScript, cookies, and SSL enabled:

- [Google Chrome](https://www.google.com/chrome/)
- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [Safari](https://support.apple.com/downloads/safari)
- [Internet Explorer](https://support.microsoft.com/en-us/help/17621/internet-explorer-downloads) and [Microsoft Edge](https://www.microsoft.com/en-us/edge)

### Hardware Specifications

NGINX Controller v2 requires the following minimum hardware specifications:

- RAM: 8 GB RAM
- CPU: 8-Core CPU @ 2.40 GHz or similar
- Disk space: 80 GB free disk space

### Firewall / IP Settings

- DB: Port 5432 TCP -- incoming to DB from NGINX Controller host
- NGINX Controller: Port 80 TCP -- incoming from NGINX Plus instances
- NGINX Controller: Port 443 TCP -- incoming from where you are accessing from a browser, for example, an internal network
- NGINX Controller: Port 8443 TCP -- incoming from NGINX Plus instances

> **NGINX Controller v2.8 and later**: If you have a firewall running on the NGINX Controller host, enable NAT (masquerade) and open the following ports. These ports are used for internal traffic only and don't need to be open to the outside.
>
> - NGINX Controller: 6443 TCP -- incoming requests to the Kubernetes master node; used for the Kubernetes API server
> - NGINX Controller: 10250 TCP -- incoming requests to the Kubernetes worker node; used for the Kubelet API
>
> For more information about these ports, see the Kubernetes guide [Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports).

---

## Controller Agent Technical Specifications

- NGINX Controller v2, using the NGINX Controller Agent, can monitor and manage up to 100 [NGINX Plus](https://www.nginx.com/products/nginx/) instances.
- The Controller Agent works only with Python 2.6 and 2.7. Python 3 is not supported.

### Supported Distributions

The Controller Agent supports the following distributions and architectures:

- Amazon Linux 2 (x86_64)
- Amazon Linux 2017.09 (x86_64)
- Debian 8 (i386, x86_64)
- Debian 9 (i386, x86_64)
- Red Hat Enterprise Linux/CentOS 6 (i386, x86_64)
- Red Hat Enterprise Linux/CentOS 7 (x86_64)
- Ubuntu 16.04 (i386, x86_64)
- Ubuntu 18.04 (x86_64)

<span id="open-source-licenses"></span>

## Open-Source Licenses

The list of open-source packages and their licenses used by NGINX Controller can be found in the downloaded file that is part of the NGINX Controller package. On your NGINX Controller host, see `controller-installer/files/license-controller.md`.

In addition, see the AskF5 KB article [Third-party software for NGINX Controller controller-datacollection-components](https://support.f5.com/csp/article/K30028643) for third-party software packages that may be used by or distributed with controller-datacollection-components. This information is not included in the `license-controller.md` that's mentioned above.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-335 -->