---
# We use sentence case and present imperative tone
title: "Virtual machine or bare metal"
# Weights are assigned in increments of 100: determines sorting order
weight: 100
# Creates a table of contents and sidebar, useful for large documents
toc: true
nd-banner:
    enabled: true
    start-date: 2025-08-30
    md: /_banners/waf-virtual-restriction.md
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This page describes how to install F5 WAF for NGINX in a virtual machine or bare metal environment. 

## Before you begin

To complete this guide, you will need the following prerequisites:

- A [supported operating system]({{< ref "/waf/fundamentals/technical-specifications.md#supported-operating-systems" >}}).
- A working [NGINX Open Source]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-open-source.md" >}}) or [NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) instance.
- An active F5 WAF for NGINX subscription (Purchased or trial).

Depending on your deployment type, you may have additional requirements:

- [Docker](https://docs.docker.com/get-started/get-docker/) is required for NGINX Open Source or NGINX Plus type deployments.

You should read the [IP intelligence]({{< ref "/waf/policies/ip-intelligence.md" >}}) and [Secure traffic using mTLS]({{< ref "/waf/configure/secure-mtls.md" >}}) topics for additional set-up configuration if you want to use them immediately.

{{< include "waf/install-selinux-warning.md" >}}

## Platform-specific instructions

Navigate to your chosen operating system, which are alphabetically ordered.

### Alpine Linux

Add the F5 WAF for NGINX repository:

```shell
printf "https://pkgs.nginx.com/app-protect/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
printf "https://pkgs.nginx.com/app-protect-security-updates/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apk update
sudo apk add openssl ca-certificates app-protect
```

### Amazon Linux

Add the F5 WAF for NGINX repository:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-amazonlinux2023.repo
```

Add F5 WAF for NGINX dependencies:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.amazonlinux2023.repo
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect
```

### Debian

Add the F5 WAF for NGINX repositories:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect/debian `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list

printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apt-get update
sudo apt-get install app-protect
```

### Oracle Linux / RHEL / Rocky Linux 8

{{< call-out "important" >}}

The steps are identical for these platforms due to their similar architecture.

{{< /call-out >}}

Add the F5 WAF for NGINX repository:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo
```

Add F5 WAF for NGINX dependencies:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
```

Enable the _ol8_codeready_builder_ repository:

```shell
sudo dnf config-manager --set-enabled ol8_codeready_builder
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect
```

### RHEL / Rocky Linux 9

Add the F5 WAF for NGINX repository:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-9.repo
```

Add F5 WAF for NGINX dependencies:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
```

Enable F5 WAF for NGINX dependencies:

```shell
sudo dnf config-manager --set-enabled crb
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect
```

### Ubuntu

Add the F5 WAF for NGINX repositories:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list

printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apt-get update
sudo apt-get install app-protect
```

## Update configuration files

{{< include "waf/install-update-configuration.md" >}}

## Post-installation checks

{{< include "waf/install-post-checks.md" >}}

## Next steps

{{< include "waf/install-next-steps.md" >}}
