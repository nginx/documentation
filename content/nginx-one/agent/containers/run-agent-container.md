---
title: Run the NGINX Agent in a container
weight: 100
toc: true
nd-content-type: how-to
product: Agent
nd-docs: DOCS-1872
---

## Overview

This guide serves as a step-by-step guide to run NGINX Agent in a container. It covers the basic setup needed to get the NGINX Agent up and running efficiently and securely.

## Before you begin

Before you begin this guide ensure:

{{< note >}}
This guide uses Docker but NGINX Agent also works with other container applications.
{{< /note >}}

- **Docker:** Ensure Docker is installed and configured on your system. [Download Docker from the official site](https://www.docker.com/products/docker-desktop/).
- **Credentials:** Acquire any necessary authentication tokens or credentials required for the NGINX Agent.

## Prepare the environment

To run NGINX Agent in a container you will need to download the NGINX Agent
container image and create a configuration file.

### Pull the NGINX Agent container image

The NGINX Agent container image must be downloaded from a trusted source such as Docker Hub or a private container registry.

Run the following command to pull the official image:

```bash
<!-- Registry HERE -->
docker pull <Registry HERE>:latest
```

Ensure you are using the correct image version. Replace `latest` with the desired version tag if necessary.


### Create a configuration file

Create a configuration file named `nginx-agent.conf` in your current directory
and populate the file with the following structure:


{{< include "/nginx-one/conf/nginx-agent-conf.md" >}}


## Run the container

Run the NGINX Agent container with the configuration file mounted.

Use the following command:

```bash
docker run -d \
  --name nginx-agent \
  -v $(pwd)/nginx-agent.conf:/etc/nginx-agent/nginx-agent.conf \
  nginx/agent:latest
```

Key options explained:

- `-d`: Runs the container in detached mode.
- `--name nginx-agent`: Assigns a name to the container for easy identification.
- `-v $(pwd)/nginx-agent.conf:/etc/nginx-agent/nginx-agent.conf`: Mounts the configuration file into the container.


### Verify the container is running

Check the running status of the container:

```bash
docker ps
```

You should see an entry for `nginx-agent`. The `STATUS` field indicates that the container is running.

### Monitor logs

To ensure the container is functioning properly and communicating with NGINX One Console, monitor the container logs.

Run the following command:

```bash
docker logs -f nginx-agent
```

Look for log entries indicating successful connection to the NGINX One Console and periodic metric transmission.
