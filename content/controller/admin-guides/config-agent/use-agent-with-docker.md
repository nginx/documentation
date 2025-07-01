---
description: Learn how to use the F5 NGINX Controller Agent in a Docker environment.
nd-docs: DOCS-511
title: Use the NGINX Controller Agent with Docker
toc: true
weight: 200
type:
- reference
---

## Before You Begin

We support running the F5 NGINX Controller Agent in a Docker environment on the following distributions: CentOS, Debian, and Ubuntu.

We **don't support** containerized instances on RHEL 7 and RHEL 8.

For optimal performance when using the Controller Agent in a Docker environment, the number of containers shouldn't exceed the number of processors on the container host.

## Running NGINX Controller Agent in Docker

When running a containerized instance on an Ubuntu or Debian docker host, you need to enable cgroup swap limit capabilities in order for the NGINX Controller Agent to be able to report swap metrics for instances. See [Docker - Linux post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/#your-kernel-does-not-support-cgroup-swap-limit-capabilities) for details.

Refer to the [nginxinc/docker-nginx-controller](https://github.com/nginxinc/docker-nginx-controller) repository in GitHub for a set of guidelines that you can use today as we continue to enhance the experience.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
