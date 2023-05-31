---
title: NGINX Agent in a Container Environment
description: 'Learn how to use the NGINX Agent in a containerized environment.'
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

## Container Support
The NGINX Agent is a companion daemon for NGINX Open Source or NGINX Plus instances and must run in the same container to work. The NGINX Agent repository includes [Dockerfiles](https://github.com/nginx/agent/tree/main/scripts/docker) that can be used to build custom container images. Images are created with an NGINX Open Source or NGINX Plus instance and are available for various Operating Systems.

The NGINX Agent bundled with NGINX Open Source Dockerfiles is available for the following base images:
- Alma Linux (8, 9)
- Alpine (3.14, 3.15, 3.16, 3.17)
- Amazon Linux (2)
- Oracle Linux (7, 8, 9)
- Rocky Linux (8, 9)
- Ubuntu (18.04, 20.04, 22.04)

The NGINX Agent bundled with NGINX Plus Dockerfiles is available for the following base images:
- Alpine Linux (3.13, 3.14, 3.15, 3.16)
- Amazon Linux (2)
- CentOS (7)
- Debian (bullseye-slim, buster-slim)
- Oracle Linux (7, 8)
- RHEL (7, 8, 9)
- SUSE (sles12sp5, sle15)
- Ubuntu (18.04, 20.04, 22.04)

## Clone the NGINX Agent Repository
Using your preferred method, clone the NGINX Agent repository into your development directory. See [Cloning a GitHub Repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) for additional help.

Use the following command to clone the repository using the HTTPS method.

```
$ git clone https://github.com/nginx/agent.git
$ cd agent
```

## Prepare your Environment
In order to build container images using scripts available in the NGINX Agent repository, you will need to install several packages. Steps outlined in this document provide installation instructions for distributions that use the `apt` package manager (eg. Debain, Ubuntu, etc...). For installations on other operating systems, please refer to documentation within each prerequisite package. In some cases, it may help to update package source lists in your operating system before proceeding.

```bash
$ sudo apt update
```

### Install `make` Package
Start by installing the [`make`](https://www.gnu.org/software/make/) package, which will enable you to execute build targets within the `Makefile` included in the NGINX Agent source code repository.

```bash
$ sudo apt install make
```

### Install a Container Engine
A container engine will enable you to build images and run containers. NGINX Agent supports the [`Docker`](https://www.docker.com/) and [`Podman`](https://podman.io/) container engines. You will need to install the container engine that you plan to use. Most examples in this document are provided using the `Docker` container engine, with the exception of example under the [Rootless Containers](#rootless-containers) section.

To install the Docker engine:
```bash
$ sudo apt get install docker.io
```

To install the Podman engine:
```bash
$ sudo apt get install podman
```

## Build Container Images
[Dockerfiles](https://github.com/nginx/agent/tree/main/scripts/docker) defining container images are located in [NGINX Agent Github](https://github.com/nginx/agent) repository. Note that `docker build` commands must be run from the repository's root directory. The NGINX Agent repository provides Makefile targets simplifying the image building process. On some Operating Systems, `make` commands must be executed with root privileges (ie. via `sudo`).

### Build Images with NGINX Agent and NGINX Open Source
Prior to building an NGINX Agent bundled with NGINX Open Source image, an NGINX Agent binary must be built or downloaded.

You can download an appropriate binary from the [NGINX Agent Releases](https://github.com/nginx/agent/releases) section on GitHub. Note the location and name of the downloaded package, which will be referred to as [PATH-TO-PACKAGE] below.

The following command will produce an Ubuntu base image:
```bash
$ PACKAGE_NAME=[PATH-TO-PACKAGE] make oss-image 
```

To build the image using a different base image, substitute values for `OS_RELEASE` and `OS_VERSION` from the following table: 

| OS_RELEASE       | OS_VERSION                 | 
| ---------------- | -------------------------- | 
| almalinux        | 8, 9                       | 
| alpine           | 3.14, 3.15, 3.16, 3.17     | 
| amazonlinux      | 2                          | 
| oraclelinux      | 7, 8, 9                    | 
| rockylinux       | 8, 9                       | 
| ubuntu           | 18.04, 20.04, 22.04        | 

For example, to build an image for RockyLinux 9, use the following command. Replace `OS_VERSION=9` with the desired version tag. See [Supported Tags](https://hub.docker.com/_/rockylinux) for version options.
```bash
$ PACKAGE_NAME=[PATH-TO-PACKAGE] OS_RELEASE=rockylinux OS_VERSION=9 make oss-image 
```

Optional: Rather than specifying `PACKAGE_NAME` or `OS_RELEASE` on the command line, you may set these environment variables directly by editing the Makefile.

### Build Images with NGINX Agent and NGINX Plus
Building an NGINX Agent bundled with NGINX Plus image requires an NGINX Plus license. NGINX Plus licenses are provided in the form of `.crt` and `.key` files and must be renamed to `nginx-repo.crt` and `nginx-repo.key` respectively. Begin by creating the `build` directory under the NGINX Agent source root directory (`[PATH_TO_NGINX_AGENT_SRC_ROOT]/build`).

In the NGINX Agent source root, execute:
```
$ mkdir build
```
Copy the license and key files into the `[PATH_TO_NGINX_AGENT_SRC_ROOT]/build` directory.

```bash
$ cp [PATH_TO_LICENSE_CRT] build/nginx-repo.crt
$ cp [PATH_TO_LICENSE_KEY] build/nginx-repo.key
```

From the NGINX Agent source root directory, run the following command to build the image with an Ubuntu 22.04 LTS base
```bash
$ make image
```

To build the image using a different base image, substitute values for `OS_RELEASE` and `OS_VERSION` from the following table: 

| OS_RELEASE       | OS_VERSION                 | 
| ---------------- | -------------------------- | 
| amazonlinux      | 2                          | 
| ubuntu           | 18.04, 20.04, 22.04        | 
| debian           | bullseye-slim, buster-slim | 
| centos           | 7                          | 
| redhatenterprise | 7, 8, 9                    | 
| alpine           | 3.13, 3.14, 3.15, 3.16     | 
| oraclelinux      | 7, 8                       | 
| suse             | sles12sp5, sle15           | 


```bash
$ OS_RELEASE=[NAME_OF_OS] OS_VERSION=[VERSION_OF_OS] make image
```

## Rootless Containers
NGINX Agent images can be built and run as rootless containers, which run without root privileges to the host Operating System.

To build a Podman image with an Ubuntu 22.04 base, execute the following command from the NGINX Agent source root directory. Altering the `OS_RELEASE` and `OS_VERSION` variables with values from the table above will build images using other supported Operating Systems.

```bash
$ CONTAINER_CLITOOL=podman make image
```

## Unprivileged Containers
Certain system architectures, like [F5 Distributed Cloud](https://www.f5.com/cloud) and [OpenShift](https://www.redhat.com/en/technologies/cloud-computing/openshift), require that processes run in containers that don't allow root privileges. [Dockerfiles](https://github.com/nginx/agent/tree/main/scripts/docker) in the NGINX Agent repository can be modified to support such environments.

### Modify Dockerfile to Support Unprivileged Use
To modify a Dockerfile to run NGINX and NGINX Agent in an unprivileged manner, paste the following `RUN` directly below the Dockerfile's primary `RUN` statement.

```
RUN sed -i 's,listen       80,listen       8080,' /etc/nginx/conf.d/default.conf \
    && sed -i '/user  nginx;/d' /etc/nginx/nginx.conf \
    && sed -i 's,/var/run/nginx.pid,/tmp/nginx.pid,' /etc/nginx/nginx.conf \
    && sed -i "/^http {/a \    proxy_temp_path /tmp/proxy_temp;\n    client_body_temp_path /tmp/client_temp;\n    fastcgi_temp_path /tmp/fastcgi_temp;\n    uwsgi_temp_path /tmp/uwsgi_temp;\n    scgi_temp_path /tmp/scgi_temp;\n" /etc/nginx/nginx.conf \
    && chown -R nginx:nginx /var/cache/nginx \
    && chmod -R go+rw /var/cache/nginx \
    && chown -R nginx:nginx /etc/nginx \
    && chmod -R go+rw /etc/nginx \
    && chown -R nginx:nginx /var/log/nginx \
    && chmod -R go+rw /var/log/nginx \
    && chown -R nginx:nginx /var/run/nginx-agent \
    && chmod -R go+w /var/run/nginx-agent \
    && ln -sf /dev/stdout /var/log/nginx-agent/agent.log
```

This command alters the Dockerfile in the following ways:
1) Changes the listen port from `80` to `8080`.
2) Removes the `user nginx;` directive from nginx.conf.
3) Moves the `nginx.pid` file from `/var/run` to `/tmp`.
4) Moves all nginx temporary directories from `/var/run` to `/tmp`.
5) Changes ownership and read/write permissions for several directories that NGINX and NGINX Agent need to write to.
6) Links the `agent.log` file to stdout, while allowing `access.log` and `error.log` to stay in `/var/log/nginx` to be read by NGINX Agent.

### Standalone NGINX Unprivileged Dockerfiles
Standalone NGINX (without NGINX Agent) unprivileged container images can be built by using Dockerfiles available in [this github repository](https://github.com/nginxinc/docker-nginx-unprivileged).

## Supported Environments
Images built with NGINX Agent Dockerfiles can run in the following container environments:
- containerd
- CRI-O

## Container Metrics
To collect container-related metrics, NGINX Agent uses available cgroup files to calculate statistics like CPU and memory usage.

### Supported cgroups
NGINX Agent supports both versions of cgroups.

- https://www.kernel.org/doc/Documentation/cgroup-v1/ 
- https://www.kernel.org/doc/Documentation/cgroup-v2.txt 


### Unsupported Metrics
The following system metrics are not supported in container environments. NGINX Agent returns no values for these metrics when run within a container.

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
If no memory limit is set when starting a container, the memory limit shown in metrics for the container will equal the total memory of the host system.

### Swap Memory Metrics
If a warning message similar to the following is seen in the NGINX Agent logs, the swap memory limit for the container is greater than the swap memory for the host system:

```
Swap memory limit specified for the container, ... is greater than the host system swap memory ...
```

The `system.swap.total` metric for the container matches the total swap memory in the host system instead of the swap memory limit specified when starting the container.

If a warning message similar to the following example is seen in the NGINX Agent logs, the host system does not have cgroup swap limit capabilities enabled.

```
Unable to collect Swap metrics because the file ... was not found
```

When using Docker, follow these steps to enable swap memory metrics:

Check if cgroup swap limit capabilities are enabled:
```
$ docker info | grep swap
WARNING: No swap limit support
```

Enable cgroup swap limit capabilities by referring to [this guide](https://docs.docker.com/engine/install/linux-postinstall/#your-kernel-does-not-support-cgroup-swap-limit-capabilities).