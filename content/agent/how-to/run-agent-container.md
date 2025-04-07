---
title: "Run the NGINX Agent in a container"
weight: 300
toc: true
type: how-to
product: Agent
---

## Overview

This guide serves as a step-by-step guide to run NGINX Agent in a container. It covers the basic setup needed to get the NGINX Agent up and running efficiently and securely.

## Before you begin

Before you begin this guide ensure:

{{< note >}}
This guide uses Docker but NGINX Agent will also work with other container applications.
{{< /note >}}

- **Docker:** Ensure Docker is installed and configured on your system. [Download Docker from the official site](https://www.docker.com/products/docker-desktop/).
- **NGINX Agent Image:** You need access to the Docker image for NGINX Agent. Find the appropriate image in your organization's registry or on Docker Hub if publicly available.
- **NGINX Configuration File:** Prepare and validate your NGINX configuration files that the Agent will monitor.
- **Credentials:** Acquire any necessary authentication tokens or credentials required for the NGINX Agent.

1. Pull the NGINX Agent container image

The NGINX Agent container image must be downloaded from a trusted source such as Docker Hub or a private container registry.

Run the following command to pull the official image:

```bash
<!-- Registry HERE -->
docker pull <Registry HERE>:latest
```

Ensure you are using the correct image version. Replace `latest` with the desired version tag if necessary.


2. Create a configuration file

1. Create a configuration file named `nginx-agent.conf` in your current directory.
2. Populate the file with the following structure:

```vim
command:
  server:
    host: "<NGINX-One-Console-URL>" # Command server host
    port: 443                       # Command server port
  auth:
    token: "<your-data-plane-key-here>" # Authentication token for the command server
  tls:
    skip_verify: false
```

Replace the placeholder values:

- `<NGINX-One-Console-URL>`: The URL of your NGINX One Console instance.
- `<your-data-plane-key-here>`: Your Data Plane access token.


3. Run the container

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


4. Verify the container is running

Check the running status of the container:

```bash
docker ps
```

You should see an entry for `nginx-agent`. The `STATUS` field should indicate that the container is running.

5. Monitor logs

To ensure the container is functioning properly and communicating with NGINX One Console, monitor the container logs.

Run the following command:

```bash
docker logs -f nginx-agent
```

Look for log entries indicating successful connection to the NGINX One Console and periodic metric transmission.
