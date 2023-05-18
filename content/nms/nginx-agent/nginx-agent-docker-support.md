---
title: NGINX Agent Docker Support
description: 'Learn how to use the NGINX Agent in a Docker environment.'
categories:
- installation
date: "2022-03-21T17:00:00+00:00"
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
toc: true
versions: []
weight: 200
docs: "DOCS-909"
aliases:
- /getting-started/installation/nginx-agent-docker-support/
---

{{< shortversions "2.1.0" "latest" "nimvers" >}}

## Supported cgroups

To collect metrics about the Docker container that the NGINX Agent is running in, the NGINX Agent uses the available cgroup files to calculate metrics like CPU and memory usage.

The NGINX Agent supports both versions of cgroups.

- https://www.kernel.org/doc/Documentation/cgroup-v1/ 
- https://www.kernel.org/doc/Documentation/cgroup-v2.txt 

## Metrics

### Unsupported Metrics

The following system metrics are not supported when running the NGINX Agent in a Docker container. The NGINX Agent returns no values for these metrics:

- system.cpu.idle
- system.cpu.iowait
- system.cpu.stolen
- system.mem.buffered
- system.load.1
- system.load.5
- system.load.15
- system.disk.total
- system.disk.used
- system.disk.free
- system.disk.in_use
- system.io.kbs_r
- system.io.kbs_w
- system.io.wait_r
- system.io.wait_w
- system.io.iops_r
- system.io.iops_w

### Memory Metrics

If no memory limit is set when starting the Docker container, then the memory limit that's shown in the metrics for the container will be the total memory of the Docker host system.

### Swap Memory Metrics

If a warning message similar to the following example is seen in the NGINX Agent logs, the swap memory limit for the Docker container is greater than the swap memory for the Docker host system:

```bash
Swap memory limit specified for the container, ... is greater than the host system swap memory ...
```

The `system.swap.total` metric for the container matches the total swap memory for the Docker host system instead of the swap memory limit specified when starting the Docker container.

If a warning message similar to the following example is seen in the NGINX Agent logs, the Docker host system does not have cgroup swap limit capabilities enabled. To enable these capabilities, follow the steps below.

```bash
Unable to collect Swap metrics because the file ... was not found
```

#### Enable cgroup swap limit capabilities

Run the following command to see if the cgroup swap limit capabilities are enabled:

```bash
$ docker info | grep swap
WARNING: No swap limit support
```

To enable cgroup swap limit capabilities, refer to this Docker guide: [Docker - Linux post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/#your-kernel-does-not-support-cgroup-swap-limit-capabilities).
