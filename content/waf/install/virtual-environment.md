---
# We use sentence case and present imperative tone
title: "Virtual machine or bare metal"
# Weights are assigned in increments of 100: determines sorting order
weight: 100
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

The disconnected/air-gapped installation use case has very similar steps.

I'm identifying shared steps for it: depending on how large the steps might be, it might re-appear as a section on a page or have its own page.

- [v4]({{< ref "/nap-waf/v4/admin-guide/install.md#offline-installation" >}})
- [v5]({{< ref "/nap-waf/v5/admin-guide/install.md#air-gap-install-secure-offline-installation" >}})

{{</ call-out >}}

This page describes how to install F5 WAF for NGINX in a virtual machine or bare metal environment. 

## Before you begin

To complete this guide, you will need the following prerequisites:

- A [supported operating system]({{< ref "/waf/fundamentals/technical-specifications.md#supported-operating-systems" >}}).
- A working [NGINX Open Source]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-open-source.md" >}}) or [NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) instance.
- An active F5 WAF for NGINX subscription (Purchased or trial).

Depending on your deployment type, you may have additional requirements:

- [Docker](https://docs.docker.com/get-started/get-docker/) is required for NGINX Open Source or NGINX Plus type deployments.

You should read the [IP intelligence]({{< ref "/waf/policies/ip-intelligence.md" >}}) and [Secure traffic using mTLS]({{< ref "/waf/configure/secure-mtls.md" >}}) topics for additional set-up configuration if you want to use them immediately.

## Platform-specific instructions

Navigate to your chosen operating system, which are alphabetically ordered.

### Alpine Linux

{{< tabs name="alpine-instructions" >}}

{{% tab name="NGINX Open Source" %}}

Add the F5 WAF for NGINX repository:

```shell
printf "https://pkgs.nginx.com/app-protect-x-oss/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apk update
sudo apk add app-protect-module-oss
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

Add the F5 WAF for NGINX repository:

```shell
printf "https://pkgs.nginx.com/app-protect-x-plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apk update
sudo apk add openssl ca-certificates app-protect-module-plus
```

{{% /tab %}}

{{% tab name="V4" %}}

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

{{% /tab %}}

{{< /tabs >}}

### Amazon Linux

{{< tabs name="amazon-instructions" >}}

{{% tab name="NGINX Open Source" %}}

Create a file for the F5 WAF for NGINX repository:

**/etc/yum.repos.d/app-protect-x-oss.repoo**

```shell
[app-protect-x-oss]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-oss/amzn/2023/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect-module-oss
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

Create a file for the F5 WAF for NGINX repository:

**/etc/yum.repos.d/app-protect-x-plus.repo**

```shell
[app-protect-x-plus]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-plus/amzn/2023/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect-module-plus
```

{{% /tab %}}

{{% tab name="V4" %}}

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

{{% /tab %}}

{{< /tabs >}}

### Debian

{{< tabs name="debian-instructions" >}}

{{% tab name="NGINX Open Source" %}}

Add the F5 WAF for NGINX repository:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect-x-oss/debian `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apt-get update
sudo apt-get install app-protect-module-oss
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

Add the F5 WAF for NGINX repository:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect-x-plus/debian `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apt-get update
sudo apt-get install app-protect-module-plus
```

{{% /tab %}}

{{% tab name="V4" %}}

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

{{% /tab %}}

{{< /tabs >}}


### Oracle Linux / RHEL / Rocky Linux 8

{{< call-out "important" >}}

The steps are identical for these platforms due to their similar architecture.

{{< /call-out >}}

{{< tabs name="oracle-instructions" >}}

{{% tab name="NGINX Open Source" %}}

Create a file for the F5 WAF for NGINX repository:

**/etc/yum.repos.d/app-protect-x-oss.repo**

```shell
[app-protect-x-oss]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-oss/centos/7/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo yum install app-protect-module-oss
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

Create a file for the F5 WAF for NGINX repository:

**/etc/yum.repos.d/app-protect-x-plus.repo**

```shell
[app-protect-x-plus]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/8/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect-module-plus
```

{{% /tab %}}

{{% tab name="V4" %}}

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

{{% /tab %}}

{{< /tabs >}}

### Ubuntu

{{< tabs name="ubuntu-instructions" >}}

{{% tab name="NGINX Open Source" %}}

Add the F5 WAF for NGINX repositories:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect-x-oss/ubuntu `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apt-get update
sudo apt-get install app-protect-module-oss
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

Add the F5 WAF for NGINX repositories:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect-x-plus/ubuntu `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
```

Update the repository, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apt-get update
sudo apt-get install app-protect-module-plus
```

{{% /tab %}}

{{% tab name="V4" %}}

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

{{% /tab %}}

{{< /tabs >}}

### RHEL / Rocky Linux 9

{{< tabs name="rhel-instructions" >}}

{{% tab name="NGINX Open Source" %}}

Create a file for the F5 WAF for NGINX repository:

**/etc/yum.repos.d/app-protect-x-oss.repo**

```shell
[app-protect-x-oss]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-oss/centos/7/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo yum install app-protect-module-oss
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

Create a file for the F5 WAF for NGINX repository:

**/etc/yum.repos.d/app-protect-x-plus.repo**

```shell
[app-protect-x-plus]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/8/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect-module-plus
```

{{% /tab %}}

{{% tab name="V4" %}}

Add the F5 WAF for NGINX repository:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-9.repo
```

Add F5 WAF for NGINX dependencies:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
```

Enable the _codeready-builder_ repository:

```shell
sudo subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect
```

{{% /tab %}}

{{< /tabs >}}

## Update configuration files

{{< include "waf/install-update-configuration.md" >}}

{{< call-out "note" >}}

If you're using a V4 package, you have finished installing F5 WAF for NGINX and can look at [Post-installation checks](#post-installation-checks).

{{< /call-out >}}

## Configure Docker services

{{< include "waf/install-services-docker.md" >}}

### Configure Docker for the F5 Container Registry

{{< include "waf/install-services-registry.md" >}}

### Download Docker images

{{< include "waf/install-services-images.md" >}}

### Create and run a Docker Compose file

{{< include "waf/install-services-compose.md" >}}

## Post-installation checks

{{< include "waf/install-post-checks.md" >}}

## Next steps

{{< include "waf/install-next-steps.md" >}}