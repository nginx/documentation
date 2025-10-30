---
# We use sentence case and present imperative tone
title: "Prerequisites"
# Weights are assigned in increments of 100: determines sorting order
weight: 50
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This page outlines the prerequisites and requirements for installing F5 WAF for NGINX across different deployment methods.

## Common prerequisites

The following prerequisites apply to all deployment methods:

### F5 WAF for NGINX subscription

- Active F5 NGINX App Protect WAF subscription in [MyF5](https://my.f5.com/manage/s/) (purchased or trial)

### Download your subscription credentials

{{< include "licensing-and-reporting/download-certificates-from-myf5.md" >}}

### Download your JSON Web Token

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

### NGINX instance

- Active F5 NGINX Plus/OSS instance - trial or licensed; optional if not yet installed (NGINX will be installed automatically during App Protect installation)
- [NGINX Plus JWT license]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#obtaining-and-installing-the-license" >}}) — required if NGINX Plus is used

### Registry access

- Docker registry credentials — needed to access private-registry.nginx.com
- Access to NGINX repo to pull the following container images:
  - `waf-enforcer` – inspects traffic and enforces security policies
  - `waf-config-mgr` – manages policy and logging configuration updates
  - `waf-compiler` – validates and compiles policies into a deployable format

### Default configuration

- Default security policy and logging profile - automatically applied on fresh install

{{< call-out "note" >}}

The default security policy and logging profile are automatically applied during installation. This provides immediate protection with standard security configurations.

{{< /call-out >}}

### Supported operating systems

To review supported operating systems, read the [Technical specifications]({{< ref "/waf/fundamentals/technical-specifications.md" >}}) topic.

## Prerequisites per deployment method

### Virtual machine or bare metal

- A [supported operating system]({{< ref "/waf/fundamentals/technical-specifications.md#supported-operating-systems" >}})
- A working [NGINX Open Source]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-open-source.md" >}}) or [NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) instance
- [Docker](https://docs.docker.com/get-started/get-docker/) is required for NGINX Open Source or NGINX Plus type deployments

### Docker deployment

- [Docker](https://docs.docker.com/get-started/get-docker/) (with [Docker Compose](https://docs.docker.com/compose/install/)) installed and running
- A [supported operating system]({{< ref "/waf/fundamentals/technical-specifications.md#supported-operating-systems" >}})

### Kubernetes deployment

#### Deploy NGINX App Protect WAF with Helm

- [Kubernetes cluster](https://kubernetes.io/docs/setup/)
- [Helm](https://helm.sh/docs/intro/install/) installed and configured

#### Deploy NGINX App Protect WAF with Manifests

- [Kubernetes cluster](https://kubernetes.io/docs/setup/)
- [kubectl CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/) configured and connected to your cluster
- Running [Docker Engine](https://docs.docker.com/engine/install/) (with [Docker Compose](https://docs.docker.com/compose/install/)) - required for running containers

## Additional requirements by feature

### IP Intelligence

If you plan to use the IP intelligence feature, review the [IP intelligence]({{< ref "/waf/policies/ip-intelligence.md" >}}) topic for additional setup requirements.

### mTLS

If you want to secure traffic using mTLS, review the [Secure traffic using mTLS]({{< ref "/waf/configure/secure-mtls.md" >}}) topic for certificate requirements and configuration steps.

### Kubernetes read-only filesystem

For Kubernetes deployments with enhanced security, see [Add a read-only filesystem for Kubernetes]({{< ref "/waf/configure/kubernetes-read-only.md" >}}) for additional configuration requirements.

## Next steps

Once you have verified all prerequisites for your chosen deployment method, proceed to the installation guide:

- [Virtual machine or bare metal]({{< ref "/waf/install/virtual-environment.md" >}})
- [Docker]({{< ref "/waf/install/docker.md" >}})
- [Kubernetes]({{< ref "/waf/install/kubernetes.md" >}})
- [Disconnected or air-gapped environments]({{< ref "/waf/install/disconnected-environment.md" >}})