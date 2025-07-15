---
title: Install from NGINX Plus repo
toc: true
weight: 200
docs: DOCS-000
nd-docs: DOCS-1877
---

{{< call-out "note" >}}
If you are using [NGINX One Console]({{< ref "/nginx-one/getting-started.md" >}})
to manage your NGINX instances, NGINX Agent is installed automatically when you
add an NGINX instance to NGINX One Console.

For a quick guide on how to connect your instance to NGINX One Console see: [Connect to NGINX One Console]({{< ref "/nginx-one/connect-instances/add-instance.md" >}})
{{< /call-out >}}

## Overview

Follow the steps in this guide to install NGINX Agent in your NGINX instance using
the NGINX Plus repository.

## Before you begin

{{< include "/agent/installation/prerequisites.md" >}}

## Manual installation using the NGINX Plus repository

Before you install NGINX Agent for the first time on your system, you need to
set up the `nginx-agent` packages repository. Afterward, you can install and update
NGINX Agent from the repository.


<details>
<summary>Install NGINX Agent on RHEL, CentOS, Rocky Linux, AlmaLinux, and Oracle Linux</summary>

### Install NGINX Agent on RHEL, CentOS, Rocky Linux, AlmaLinux, and Oracle Linux<a name="install-nginx-agent-on-rhel-centos-rocky-linux-almalinux-and-oracle-linux-plus"></a>

{{< include "/agent/installation/plus/plus-rhel.md" >}}

</details>

<details>
<summary>Install NGINX Agent on Ubuntu</summary>

### Install NGINX Agent on Ubuntu<a name="install-nginx-agent-on-ubuntu-plus"></a>

{{< include "/agent/installation/plus/plus-ubuntu.md" >}}

</details>

<details>
<summary>Install NGINX Agent on Debian</summary>

### Install NGINX Agent on Debian<a name="install-nginx-agent-on-debian-plus"></a>

{{< include "/agent/installation/plus/plus-debian.md" >}}

</details>

<details>
<summary>Install NGINX Agent on SLES</summary>

### Install NGINX Agent on SLES<a name="install-nginx-agent-on-sles-plus"></a>

{{< include "/agent/installation/plus/plus-sles.md" >}}

</details>

<details>
<summary>Install NGINX Agent on Alpine Linux</summary>

### Install NGINX Agent on Alpine Linux<a name="install-nginx-agent-on-alpine-linux-plus"></a>

{{< include "/agent/installation/plus/plus-alpine.md" >}}

</details>
<details>
<summary>Install NGINX Agent on Amazon Linux</summary>

### Install NGINX Agent on Amazon Linux<a name="install-nginx-agent-on-amazon-linux-plus"></a>

{{< include "/agent/installation/plus/plus-amazon-linux.md" >}}

</details>

### Manually connect NGINX Agent to NGINX One Console

{{< include "agent/installation/manually-connect-to-console" >}}

## Start, stop, and enable NGINX Agent

{{< include "/agent/installation/start-stop-agent.md" >}}

## Verify that NGINX Agent is running

{{< include "/agent/installation/verify-agent.md" >}}
