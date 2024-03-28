---
description: NGINX Instance Manager history.
docs: DOCS-626
doctypes:
- tutorial
tags:
- docs
title: About Us
toc: true
weight: 400
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document describes NGINX Instance Manager.

{{%heading "configure"%}}

## Vision {#vision}

Make NGINX even simpler to configure, scale, and maintain.

## Audience {#audience}

NGINX Instance Manager is designed for anyone who uses NGINX and has seen an nginx.conf file before.

## Why Instance Manager? {#why}

NGINX is an [amazing](https://www.nginx.com/resources/wiki/community/why_use_it/) proxy and web server (and more) and does these functions well. It handles heavy traffic, is lightweight and compact, and uses resources very carefully. What it does, it does well.

NGINX users have requested additional features, and we created Instance Manager to help deliver them (not inclusive):

- API for NGINX to push and pull configuration changes (ideally gRPC)
- Instance management of NGINX Open Source (and custom compiled versions)
- Adopting existing running NGINX instances and handling anything they can run
- Integration into existing CI/CD pipelines
- Utilization of native Linux tools and processes (systemd, selinux, rpm/apt packages)
- High instance count (10,000+) support
- Fast and lightweight (like NGINX)
- Certificate Expiration

## What is Instance Manager? {#what}

NGINX Instance Manager is a centralized control plane for NGINX data plane instances. Instance Manager provides an API, configuration management, and metrics for NGINX instances, Open Source and Plus. Instance Manager works with existing tools and processes you already have.

### Can't someone else do it?

If another tool can provide functionality, we utilize it first before building it into Instance Manager directly. This allows immediate functionality and flexibility for you to choose the tools you want to use. As we learn more about required functions, we will build more into the server.

### Playing well with others

Instance Manager does not expect to be the single source of truth. You likely have something else (perhaps git) functioning as your source of conf files. Instance Manager will respect any other tool owning the configuration files and expects changes to happen outside of Instance Manager.

### Use NGINX

We believe NGINX is the best tool to place in front of web applications, and we place NGINX Plus in front of Instance Manager. NGINX Plus provides several authentication and encryption options you can use. In addition, it allows you to present the API, user interface, and agent connections as you desire. All traffic uses the HTTP context (including agent to server traffic).

### Secure by default

Instance Manager installs using localhost only (not exposed to the outside by default). The conf files specify certificates and keys expecting mTLS to be used.

### If NGINX can run it, we can handle it

We expect to handle many variations with NGINX. Operating systems, custom compiled versions, and the use of LUA scripts are all expected for Instance Manager. We focus on not breaking any combination first and then focus on parsing and adding value to features second.

### We choose speed

Instance Manager is designed to be fast. The install is in seconds, the config update is about 1 second and metrics should be able to be gathered in up to 1s intervals.
