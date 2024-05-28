---
description: ''
docs:
doctypes:
- task
tags:
- docs
title: Use NGINX as a proxy for connections to NGINX One
toc: true
weight: 400
---

## Overview

This guide explains how to set up NGINX as a proxy for other NGINX instances to connect to NGINX One. You can route many NGINX instances' connections to NGINX One through a single NGINX instance. This setup minimizes the number of connections outside your network to NGINX One.

## Before you start

- [Install NGINX Open Source or NGINX Plus]({{< relref "/nginx/admin-guide/installing-nginx.md" >}}).
- [Get a Data Plane Key from NGINX One]({{< relref "/nginx-one/how-to/data-plane-keys.md" >}}).

## Configure NGINX to act as a proxy for connections

In this step, we'll configure an NGINX instance to act as a proxy to NGINX One.

1. Open the NGINX configuration (**/etc/nginx/nginx.conf**) with a text editor.
2. Add the following to define the upstream server, set up logging, and configure the proxy server:

    ```nginx
    stream {
        upstream stream_backend {
            zone tcp_servers 64k;
            server agent.connect.nginx.com:443;
        }

        log_format basic '$remote_addr [$time_local] '
                        '$protocol $status $bytes_sent $bytes_received '
                        '$session_time "$upstream_addr" '
                        '"$upstream_bytes_sent" "$upstream_bytes_received" "$upstream_connect_time"';

        access_log /var/log/nginx/nginx1_access.log basic;
        error_log /var/log/nginx/nginx1_error.log;

        server {
            listen 5000;
            status_zone tcp_server;
            proxy_pass stream_backend;
            proxy_next_upstream on;
        }
    }
    ```

3. Reload NGINX to apply the changes:

    ```sh
    sudo nginx -s reload
    ```

## Configure NGINX Agent to use proxy instance

To set up your other NGINX instances to use the proxy instance to connect to NGINX One, update the NGINX Agent configuration on those instances to use the proxy NGINX instance's IP address. See the example NGINX Agent configuration below.

1. Open the NGINX Agent configuration (**/etc/nginx-agent/nginx-agent.conf**) with a text editor.
2. Add the following configuration. Replace `YOUR_DATA_PLANE_KEY_HERE` with your actual data plane key and `YOUR_PROXY_IP_ADDRESS_HERE` with the IP address of the NGINX proxy instance.


    ```yaml
    server:
      # Replace YOUR_DATA_PLANE_KEY_HERE with your NGINX One Data Plane Key.
      token: "YOUR_DATA_PLANE_KEY_HERE"
      # Replace YOUR_PROXY_IP_ADDRESS_HERE with the IP address of the NGINX proxy instance.
      host: YOUR_PROXY_IP_ADDRESS_HERE
      grpcPort: 5000
      command: agent.connect.nginx.com
      metrics: agent.connect.nginx.com
    tls:
      enable: true
      skip_verify: false
    ```

## References

For more information, refer to the following resources:

- [Installing NGINX and NGINX Plus]({{< relref "/nginx/admin-guide/installing-nginx.md" >}})
- [Create and manage data plane keys]({{< relref "/nginx-one/how-to/data-plane-keys.md" >}})
- [NGINX Agent Installation and upgrade](https://docs.nginx.com/nginx-agent/installation-upgrade/)
- [NGINX Agent Configuration](https://docs.nginx.com/nginx-agent/configuration/)