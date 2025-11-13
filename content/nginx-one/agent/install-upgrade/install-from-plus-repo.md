---
title: Install from NGINX Plus repo
toc: true
weight: 200
nd-content-type: how-to
nd-product: NGINX One
nd-docs: DOCS-1877
---

{{< call-out "note" >}}
If you are using [NGINX One Console]({{< ref "/nginx-one/getting-started.md" >}})
to manage your NGINX instances, NGINX Agent is installed automatically when you
add an NGINX instance to NGINX One Console.

For a quick guide on how to connect your instance to NGINX One Console see: [Connect to NGINX One Console]({{< ref "/nginx-one/connect-instances/add-instance.md" >}})
{{< /call-out >}}

## Overview

Follow the steps in this guide to install F5 NGINX Agent in your NGINX instance using
the NGINX Plus repository.

## Before you begin

{{< include "/agent/installation/prerequisites.md" >}}

## Manual installation using the NGINX Plus repository

Before you install NGINX Agent for the first time on your system, you need to
set up the `nginx-agent` packages repository. Afterward, you can install and update
NGINX Agent from the repository.

### Install NGINX Agent on Alpine Linux

{{< details summary="Expand instructions" >}}

{{< include "/agent/installation/plus/plus-alpine.md" >}}

{{< /details >}}

### Install NGINX Agent on Amazon Linux

{{< details summary="Expand instructions" >}}

{{< include "/agent/installation/plus/plus-amazon-linux.md" >}}

{{< /details >}}

### Install NGINX Agent on Debian

{{< details summary="Expand instructions" >}}

{{< include "/agent/installation/plus/plus-debian.md" >}}

{{< /details >}}

### Install NGINX Agent on RHEL, CentOS, Rocky Linux, AlmaLinux, and Oracle Linux

{{< details summary="Expand instructions" >}}

{{< include "/agent/installation/plus/plus-rhel.md" >}}

{{< /details >}}

### Install NGINX Agent on SLES

{{< details summary="Expand instructions" >}}

{{< include "/agent/installation/plus/plus-sles.md" >}}

{{< /details >}}

### Install NGINX Agent on Ubuntu

{{< details summary="Expand instructions" >}}

{{< include "/agent/installation/plus/plus-ubuntu.md" >}}

{{< /details >}}

### Manually connect NGINX Agent to NGINX One Console

{{< include "agent/installation/manually-connect-to-console" >}}

## Start, stop, and enable NGINX Agent

{{< include "/agent/installation/start-stop-agent.md" >}}

## Verify that NGINX Agent is running

{{< include "/agent/installation/verify-agent.md" >}}
