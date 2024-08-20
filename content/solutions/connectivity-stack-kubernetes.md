---
description: This article explains how to download and install the products in the
  [F5 NGINX Connectivity Stack for Kubernetes](https://www.nginx.com/solutions/kubernetes/).
docs: DOCS-1444
tags:
- docs
title: Install the Connectivity Stack for Kubernetes
toc: true
weight: 300
---

## Overview
The Connectivity Stack for Kubernetes by F5 NGINX includes access to the following products:

- [F5 NGINX Ingress Controller](https://www.nginx.com/products/nginx-ingress-controller/)
- [F5 NGINX App Protect WAF and DoS](https://www.nginx.com/products/nginx-app-protect/)

## Installation

NGINX Ingress Controller can be installed from pre-built images for three common installation patterns:

- [NGINX Ingress Controller]({{< ref "connectivity-stack-kubernetes/#install-nginx-ingress-controller" >}})
- [NGINX Ingress Controller with NGINX App Protect WAF]({{< ref "connectivity-stack-kubernetes/#install-install-nginx-ingress-controller-with-nginx-app-protect-waf" >}})
- [NGINX Ingress Controller with NGINX App Protect DoS]({{< ref "connectivity-stack-kubernetes/#install-install-nginx-ingress-controller-with-nginx-app-protect-dos" >}})

Deploying NGINX Ingress Controller is the same for all three patterns, but requires different pre-built images. Alternatively, you can choose to [build the Ingress Controller image](https://docs.nginx.com/nginx-ingress-controller/installation/building-ingress-controller-image/) using the source code.

### Install NGINX Ingress Controller
NGINX Ingress Controller manages app connectivity at the edge of a Kubernetes cluster with API gateway, identity, and observability features.

1. [Download the products and distributions](https://my.f5.com/manage/s/downloads) you need from MyF5, including the NGINX Ingress Controller certificate and the key (`nginx-repo.crt` and `nginx-repo.key`).
2. Choose your target deployment environment and method and follow the appropriate installation guide to install NGINX Ingress Controller:
    - [Installation with Manifests](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/)
    - [Installation with Helm](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/)
    - [Installation with NGINX Ingress Operator (Red Hat OpenShift)](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-operator/)
    - [Using NGINX Ingress Controller in AWS Marketplace](https://docs.nginx.com/nginx-ingress-controller/installation/using-aws-marketplace-image/)
3. For additional installation options, including building custom container images, refer to the [documentation for NGINX Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/installation/)

### Install NGINX Ingress Controller with NGINX App Protect WAF
NGINX App Protect WAF is a strong, lightweight WAF that protects against the OWASP Top 10 and provides PCI DDS compliance.

- Follow the instructions to [install NGINX Ingress Controller with NGINX App Protect WAF](https://docs.nginx.com/nginx-ingress-controller/app-protect-waf/installation/)

### Install NGINX Ingress Controller with NGINX App Protect DoS
NGINX App Protect DoS provides behavioral DoS detection and mitigation with consistent and adaptive protection across clouds and architectures.

- Follow the instructions to [install NGINX Ingress Controller with NGINX App Protect DoS](https://docs.nginx.com/nginx-ingress-controller/app-protect-dos/installation/)

## Next steps
Now that you’ve successfully deployed the Connectivity Stack for Kubernetes, use this free eBook to learn more about [managing Kubernetes connectivity with F5 NGINX](https://www.nginx.com/resources/library/managing-kubernetes-traffic-with-f5-nginx-practical-guide/).
