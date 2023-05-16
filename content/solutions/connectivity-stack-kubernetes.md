---
title: "Install the Connectivity Stack for Kubernetes"
date: 2023-05-08T12:00:00-07:00
description: "This article explains how to download and install the products in the [F5 NGINX Connectivity Stack for Kubernetes](https://www.nginx.com/solutions/kubernetes/)."
# Assign weights in increments of 100
weight: 300
toc: true
tags: [ "docs" ]
versions: []
docs: 
---

## Overview
The Connectivity Stack for Kubernetes by F5 NGINX includes access to the following products:

- [F5 NGINX Ingress Controller](https://www.nginx.com/products/nginx-ingress-controller/)
- [F5 NGINX App Protect WAF and DoS](https://www.nginx.com/products/nginx-app-protect/)

## Installation

### Install NGINX Ingress Controller
NGINX Ingress Controller manages app connectivity at the edge of a Kubernetes cluster with API gateway, identity, and observability features.

1. [Download the products and distributions](https://my.f5.com/manage/s/downloads) you need from MyF5, including the NGINX Ingress Controller certificate and the key (`nginx-repo.crt` and `nginx-repo.key`).
2. Choose your target deployment environment and method and follow the appropriate installation guide to install NGINX Ingress Controller:
    - [Installation with Manifests](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/)
    - [Installation with Helm](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/)
    - [Installation with NGINX Ingress Operator (Red Hat OpenShift)](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-operator/)
    - [Using NGINX Ingress Controller in AWS Marketplace](https://docs.nginx.com/nginx-ingress-controller/installation/using-aws-marketplace-image/)
3. For additional installation options, including building custom container images, refer to the [documentation for NGINX Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/installation/)

### (Optional) Install NGINX App Protect WAF
NGINX App Protect WAF is a strong, lightweight WAF that protects against the OWASP Top 10 and provides PCI DDS compliance.

- Follow the instructions to [install NGINX Ingress Controller with NGINX App Protect WAF](https://docs.nginx.com/nginx-ingress-controller/app-protect-waf/installation/)

### (Optional) Install NGINX App Protect DoS
NGINX App Protect DoS provides behavioral DoS detection and mitigation with consistent and adaptive protection across clouds and architectures.

- Follow the instructions to [install NGINX Ingress Controller with NGINX App Protect DoS](https://docs.nginx.com/nginx-ingress-controller/app-protect-dos/installation/)

## Next steps
Now that you’ve successfully deployed the Connectivity Stack for Kubernetes, use this free eBook to learn more about [managing Kubernetes connectivity with F5 NGINX](https://www.nginx.com/resources/library/managing-kubernetes-traffic-with-f5-nginx-practical-guide/).
