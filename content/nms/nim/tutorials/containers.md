---
categories:
- examples
date: "2021-12-21T12:00:00-07:00"
description: This topic explains how to use Instance Manager with containers.
doctypes:
- tutorial
draft: false
journeys:
- getting started
- using
personas:
- devops
- netops
- secops
- support
tags:
- docs
title: Using Instance Manager with Containers
toc: true
versions: []
weight: 700
docs: "DOCS-823"
aliases:
- /nginx-instance-manager/tutorials/containers/
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