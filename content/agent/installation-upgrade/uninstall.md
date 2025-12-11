---
title: Uninstall NGINX Agent package
weight: 700
toc: true
nd-docs: DOCS-1230
nd-content-type: how-to
nd-product: NAGENT
---

## Overview

Learn how to uninstall NGINX Agent from your system.

## Prerequisites

- NGINX Agent installed [NGINX Agent installed](../installation-oss)
- The user following these steps will need `root` privilege

## Uninstalling NGINX Agent
Complete the following steps on each host where you’ve installed NGINX Agent


- [Uninstalling NGINX Agent on RHEL, CentOS, Rocky Linux, AlmaLinux, and Oracle Linux](#uninstalling-nginx-agent-on-rhel-centos-rocky-linux-almalinux-and-oracle-linux)
- [Uninstalling NGINX Agent on Ubuntu](#uninstalling-nginx-agent-on-ubuntu)
- [Uninstalling NGINX Agent on Debian](#uninstalling-nginx-agent-on-debian)
- [Uninstalling NGINX Agent on SLES](#uninstalling-nginx-agent-on-sles)
- [Uninstalling NGINX Agent on Alpine Linux](#uninstalling-nginx-agent-on-alpine-linux)
- [Uninstalling NGINX Agent on Amazon Linux](#uninstalling-nginx-agent-on-amazon-linux)
- [Uninstalling NGINX Agent on FreeBSD](#uninstalling-nginx-agent-on-freebsd)

### Uninstalling NGINX Agent on RHEL, CentOS, Rocky Linux, AlmaLinux, and Oracle Linux

{{< include "agent/installation/uninstall/uninstall-rhel.md" >}}

### Uninstalling NGINX Agent on Ubuntu

{{< include "agent/installation/uninstall/uninstall-ubuntu.md" >}}

### Uninstalling NGINX Agent on Debian

{{< include "agent/installation/uninstall/uninstall-debian.md" >}}

### Uninstalling NGINX Agent on SLES

{{< include "agent/installation/uninstall/uninstall-sles.md" >}}

### Uninstalling NGINX Agent on Alpine Linux

{{< include "agent/installation/uninstall/uninstall-alpine.md" >}}

### Uninstalling NGINX Agent on Amazon Linux

{{< include "agent/installation/uninstall/uninstall-amazon-linux.md" >}}

### Uninstalling NGINX Agent on FreeBSD

Complete the following steps on each host where you've installed NGINX agent:

1. Stop NGINX agent:

   ```bash
   sudo service nginx-agent stop
   ```

2. To uninstall NGINX agent, run the following command:

   ```bash
   sudo pkg delete nginx-agent
   ```
