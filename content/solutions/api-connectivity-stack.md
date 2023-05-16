---
title: "Install the API Connectivity Stack"
date: 2023-05-08T12:00:00-07:00
description: "This article explains how to download and install the products in the [F5 NGINX API Connectivity Stack](https://www.nginx.com/solutions/api-connectivity-stack/)."
# Assign weights in increments of 100
weight: 200
toc: true
tags: [ "docs" ]
versions: []
docs: 
---

## Overview
The API Connectivity Stack by F5 NGINX includes access to the following products:

- [F5 NGINX Plus as an API Gateway](https://www.nginx.com/products/nginx/api-gateway/)
- [F5 NGINX App Protect WAF and DoS](https://www.nginx.com/products/nginx-app-protect/)
- [F5 NGINX Management Suite Instance Manager](https://www.nginx.com/products/nginx-management-suite/instance-manager/)
- [F5 NGINX Management Suite Security Monitoring]({{< ref "nms/security" >}})
- [F5 NGINX Management Suite API Connectivity Manager](https://www.nginx.com/products/nginx-management-suite/api-connectivity-manager/)

## Installation Guide

### Install the Instance Manager module
NGINX Management Suite Instance Manager makes it easy to inventory, configure, monitor, and secure NGINX Open Source, NGINX Plus, and NGINX App Protect WAF instances.

1. [Download the products and distributions](https://my.f5.com/manage/s/downloads) you need from MyF5.
2. Choose your target deployment environment and follow the appropriate installation guide to setup NGINX Management Suite:
    - [Install on virtual machine or bare metal]({{< ref "install-guide" >}})
    - [Install in Kubernetes using Helm]({{< ref "nms-helm" >}})
3. Follow instructions to install the [Instance Manager module]({{< ref "install-guide#install-instance-manager" >}})
 
 {{< note >}}Skip step 3 if you’re using a Kubernetes installation (Instance Manager is included by default with the NGINX Management Suite Helm chart){{< /note >}}

### (Optional) Install the Security Monitoring module
NGINX Management Suite Security Monitoring provides global visibility into your fleet of NGINX App Protect WAF instances, including protection insights and the ability to analyze threats. Install this module if you plan to install NGINX App Protect WAF.

- [Install on virtual machine or bare metal]({{< ref "install-guide#install-nms-modules" >}})

{{< note >}}The Kubernetes Helm method does not support installation of the Security Monitoring module, and the module is not currently supported in Kubernetes.{{< /note >}}

### (Optional) Install the API Connectivity Manager module
NGINX Management Suite API Connectivity Manger makes it easy to manage, govern, and secure API gateways deployed across multi-cloud and hybrid environments. Install this module if you want to centrally manage your NGINX Plus API gateways.

- [Install on virtual machine or bare metal]({{< ref "install-guide#install-nms-modules" >}})
- [Install in Kubernetes using Helm]({{< ref "enable-modules-for-existing-deployments" >}})

### Install NGINX Plus as an API Gateway
NGINX Plus can be configured to act as an API gateway for monolithic applications and microservices. It is the data plane that transports application traffic and is operated by management plane tools like NGINX Management Suite API Connectivity Manager.

1.	[Download your credentials from MyF5](https://my.f5.com/), including your NGINX Plus Certificate and public key (`nginx-repo.crt` and `nginx-repo.key`).
2.	Follow the [NGINX Plus installation guide]({{< ref "installing-nginx-plus" >}}) to install it on a [supported operating system]({{< ref "nginx/technical-specs" >}})
3.	[Install and configure NGINX Agent]({{< ref "install-nginx-agent" >}}) on your NGINX Plus instance. 

If you plan to use API Connectivity Manager to manage NGINX Plus as an API Gateway, refer to the instructions about [how to set up an API gateway environment]({{< ref "add-api-gateway" >}}).

### (Optional) Install NGINX App Protect WAF
NGINX App Protect WAF is a lightweight, platform agnostic WAF that protects applications and APIs from layer 7 attacks. You can manage WAFs using the Instance Manager module and visualize them using the Security Monitoring module.

1.	[Download your credentials from MyF5](https://my.f5.com/), including your NGINX Plus Certificate and public key (`nginx-repo.crt` and `nginx-repo.key`).
2.	Follow the [NGINX App Protect WAF installation guide]({{< ref "nap-waf/admin-guide/install" >}}) for your Linux distribution

If you want to use NGINX App Protect WAF with the Security Monitoring and Instance Manager modules, you will need to complete a few additional steps. Refer to the [installation guide]({{< ref "nap-waf/admin-guide/install-nms" >}}) for using NGINX App Protect WAF with NGINX Management Suite.

### (Optional) Install NGINX App Protect DoS
NGINX App Protect DoS provides comprehensive protection against Layer 7 denial-of-service attacks on your apps and APIs. At this time, it is not integrated with Instance Manager or Security Monitoring modules.

1.	[Download your credentials from MyF5](https://my.f5.com/), including your NGINX Plus Certificate and public key (`nginx-repo.crt` and `nginx-repo.key`).
2.	Follow the [NGINX App Protect DoS installation guide]({{< ref "nap-dos/deployment-guide/learn-about-deployment" >}}) for your Linux distribution

## Next steps
Now that you’ve successfully deployed the API Connectivity Stack, use this free eBook to learn more about [deploying NGINX as an API gateway](https://www.nginx.com/resources/library/nginx-api-gateway-deployment/).
