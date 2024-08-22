---
description: This topic explains how to use F5 NGINX Instance Manager with containers.
docs: DOCS-823
doctypes:
- tutorial
draft: true
tags:
- docs
title: Using Instance Manager with Containers
toc: true
weight: 700
---

{{< shortversions "2.1.0" "latest" "nimvers" >}}

Instance Manager utilizes the NGINX Agent, which runs as a process or binary. There are at least three methods for using Instance Manager with containers:

- Use systemd in a container
- Layer the NGINX Agent on top of NGINX
- Run multiple binaries on CMD

## Before You Begin {#prerequisites}

To complete this tutorial, you need the following:

- A working knowledge of Docker and how to build and extend containers.
- Instance Manager is installed, configured, and running.

## Build and run NGINX Agent containers

For information on how to build and run NGINX Agent containers see [NGINX Agent: Docker Images](https://docs.nginx.com/nginx-agent/docker-images/)

## Next Steps {#next}

You can combine this example with certificates and advanced configurations.

<br>
