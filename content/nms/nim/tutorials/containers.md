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

## Dockerfile

We will use Debian (buster-slim) as an example, but other supported distributions can be used.

1. Copy the `nginx.conf` and `conf.d` files to the same directory of your Dockerfile. If you are using open-source, add a `stub_status` conf to `127.0.0.1` at a minimum.

2. Create a Dockerfile similar to the following example:

    <details open>
        <summary>Example Dockerfile</summary>

    {{<fa "download">}} {{<link "/tutorials/docker/Dockerfile" "Download Dockerfile" >}}

    ```Dockerfile
    FROM debian:buster-slim

    LABEL maintainer="NGINX Agent Engineering"

    # APT non-interactive during build
    ARG DEBIAN_FRONTEND=noninteractive

    ARG CONTROL_PLANE_IP
    ENV CONTROL_PLANE_IP=$CONTROL_PLANE_IP

    # Install NGINX Agent
    RUN apt-get update && \
        apt-get install --no-install-recommends --no-install-suggests -y \
        curl \
        gnupg \
        ca-certificates \
        apt-transport-https \
        lsb-release \
        procps \
    # NGINX is included in the dockerfile here, can be modified as needed, this adds the OSS image by default.
        nginx \
      && curl --insecure https://$CONTROL_PLANE_IP/install/nginx-agent | sh \
    # Forward request and error logs to docker log collector \
      && ln -sf /dev/stdout /var/log/nginx/access.log \
      && ln -sf /dev/stderr /var/log/nginx/error.log

    # Cleanup \
    RUN apt-get autoremove --purge -y \
          curl \
          gnupg \
          apt-transport-https \
          lsb-release \
      && rm -rf /root/.gnupg \
      && rm -rf /var/lib/apt/lists/*

    COPY entrypoint.sh /

    STOPSIGNAL SIGTERM

    CMD bash /entrypoint.sh
    ```

    </details>

3. Add the `entrypoint.sh` file in the same directory:

    <details open>
      <summary>Example entrypoint.sh</summary>

    {{<fa "download">}} {{<link "/tutorials/containers/entrypoint.sh" "Download entrypoint.sh">}}

    ```bash
    #!/bin/bash

    set -euxo pipefail

    handle_term()
    {
        echo "received TERM signal"
        echo "stopping nginx-agent ..."
        kill -TERM "${agent_pid}" 2>/dev/null
        echo "stopping nginx ..."
        kill -TERM "${nginx_pid}" 2>/dev/null
    }

    trap 'handle_term' TERM

    # Launch nginx
    echo "starting nginx ..."
    /usr/sbin/nginx -g "daemon off;" &

    nginx_pid=$!

    cat /etc/nginx-agent/nginx-agent.conf

    # start nginx-agent, pass args
    echo "starting nginx-agent ..."
    /usr/bin/nginx-agent "$@" &

    agent_pid=$!

    wait_term()
    {
        wait ${agent_pid}
        trap '' EXIT INT TERM
        kill -QUIT "${nginx_pid}" 2>/dev/null
        echo "waiting for nginx to stop..."
        wait ${nginx_pid}
        kill -TERM "${agent_pid}" 2>/dev/null
        echo "terminating nginx-agent..."
    }

    wait_term

    echo "nginx-agent process has stopped, exiting."
    ```

    </details>

4. Build the Dockerfile:

    ```bash
    export CONTROL_PLANE_IP=<NGINX-INSTANCE-MANAGER-FQDN>
    docker build \
      -t nginx-agent --build-arg CONTROL_PLANE_IP .
    ```

5. Run the container. In this example, we mount a local version of `nginx-agent.conf`, which can be used in place of the one in the image, and export port 1080 to the container's port 80. We specify the NMS host IP address, port and instance group name. See [NGINX Agent Environment Variables]({{< relref "nginx-agent/install-nginx-agent#nginx-agent-environment-variables" >}}) for details on these. We also make the container a daemon and name it `nginx-agent-1`. Finally, we specify we want to restart the container on failure.

    ```bash
    docker run \
      --name nginx-agent-1 \
      --hostname nginx-agent-1 \
      -d \
      -e NMS_SERVER_HOST=192.168.1.1 \
      -e NMS_SERVER_GRPCPORT=443 \
      -e NMS_INSTANCE_GROUP='ig01' \
      --restart=unless-stopped \
      -v $PWD/nginx-agent.conf:/etc/nginx-agent/nginx-agent.conf \
      -p 1080:80 \
      nginx-agent
    ```

## Next Steps {#next}

You can combine this example with certificates and advanced configurations.

<br>