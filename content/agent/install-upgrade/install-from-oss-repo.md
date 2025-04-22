---
title: Install from Open Source repo
toc: true
weight: 100
docs: DOCS-000
---

{{< note>}}
If you are using [NGINX One Console]({{< ref "/nginx-one/getting-started.md" >}})
to manage your NGINX instances, NGINX Agent is installed automatically when you
add an NGINX instance to NGINX One Console.

For a quick guide on how to connect your instance to NGINX One Console see: [Connect to NGINX One Console]({{< ref "/nginx-one/how-to/nginx-configs/add-instance" >}})
{{< /note >}}

## Overview

Follow the steps in this guide to install NGINX Agent in your NGINX instance using
the NGINX Open Source repository.

## Before you begin

{{< include "/agent/installation/prerequisites.md" >}}

## Manual installation using the NGINX Open Source repository

Before you install NGINX Agent for the first time on your system, you need to set
up the `nginx-agent` packages repository. Afterward, you can install and update
NGINX Agent from the repository.

<details>
<summary>{{< fa "brands fa-centos" >}} Install NGINX Agent on RHEL, CentOS, Rocky Linux, AlmaLinux, and Oracle Linux</summary>

### Install NGINX Agent on RHEL, CentOS, Rocky Linux, AlmaLinux, and Oracle Linux

{{< include "/agent/installation/oss/oss-rhel.md" >}}

</details>

<details>
<summary>{{< fa "brands fa-ubuntu" >}} Install NGINX Agent on Ubuntu</summary>

### Install NGINX Agent on Ubuntu

{{< include "/agent/installation/oss/oss-ubuntu.md" >}}

</details>

<details>
<summary>{{< fa "brands fa-debian" >}} Install NGINX Agent on Debian</summary>

### Install NGINX Agent on Debian

{{< include "/agent/installation/oss/oss-debian.md" >}}

</details>

<details>
<summary>{{< fa "brands fa-suse" >}} Install NGINX Agent on SLES</summary>

### Install NGINX Agent on SLES

{{< include "/agent/installation/oss/oss-sles.md" >}}

</details>

<details>
<summary>{{< fa "solid fa-mountain-sun" >}} Install NGINX Agent on Alpine Linux</summary>

### Install NGINX Agent on Alpine Linux

{{< include "/agent/installation/oss/oss-alpine.md" >}}

</details>

<details>
<summary>{{< fa "brands fa-aws" >}} Install NGINX Agent on Amazon Linux</summary>

### Install NGINX Agent on Amazon Linux

{{< include "/agent/installation/oss/oss-amazon-linux.md" >}}

</details>
<details>
<summary>{{< fa "brands fa-freebsd" >}} Install NGINX Agent on FreeBSD</summary>

### Install NGINX Agent on FreeBSD

{{< include "/agent/installation/oss/oss-freebsd.md" >}}

</details>

### Manually connect NGINX Agent to NGINX One Console

{{< include "agent/installation/manually-connect-to-console" >}}

## Start, stop, and enable NGINX Agent

{{< include "/agent/installation/start-stop-agent.md" >}}

## Verify that NGINX Agent is running

{{< include "/agent/installation/verify-agent.md" >}}
