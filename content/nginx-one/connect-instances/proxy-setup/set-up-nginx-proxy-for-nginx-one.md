---
description: ''
docs: null
title: Set up NGINX as a proxy for NGINX One
toc: true
weight: 300
type:
- how-to
---

## Overview

This guide explains how to set up NGINX as a proxy for other NGINX instances to connect to the F5 NGINX One Console. By routing these connections through one proxy, you can minimize the number of external connections to NGINX One from your network.

---

## Before you start

- [Install NGINX Open Source or NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/" >}}).
- [Get a Data Plane Key from NGINX One]({{< ref "/nginx-one/connect-instances/data-plane-keys/create-manage-data-plane-keys.md" >}}).

---

## Configure an NGINX instance to act as a proxy

In this step, we'll configure an NGINX instance to act as a proxy server for NGINX One.

1. Open a secure connection to your instance using SSH and log in.
2. Open the NGINX configuration file (**/etc/nginx/nginx.conf**) with a text editor.
3. Add the following configuration to define the upstream server, set up logging, and configure the proxy server:

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

4. Reload NGINX to apply the changes:

    ```sh
    sudo nginx -s reload
    ```

---

## Configure NGINX Agent to use the proxy

To set up your other NGINX instances to use the proxy instance to connect to NGINX One, update the NGINX Agent configuration on those instances to use the proxy NGINX instance's IP address. See the example NGINX Agent configuration below.

1. Open a secure connection to your instance using SSH and log in.
2. Open the NGINX Agent configuration file (**/etc/nginx-agent/nginx-agent.conf**) with a text editor.
3. Add the following configuration. Replace `YOUR_DATA_PLANE_KEY_HERE` with your actual data plane key and `YOUR_PROXY_IP_ADDRESS_HERE` with the IP address of the NGINX proxy instance.

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

4. Restart NGINX Agent:

    ``` sh
    sudo systemctl restart nginx-agent
    ```

---

## References

For more information, refer to the following resources:

- [Install NGINX and NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/" >}})
- [Create and manage data plane keys]({{< ref "/nginx-one/connect-instances/data-plane-keys/create-manage-data-plane-keys.md" >}})
- [NGINX Agent Installation and upgrade](https://docs.nginx.com/nginx-agent/installation-upgrade/)
- [NGINX Agent Configuration](https://docs.nginx.com/nginx-agent/configuration/)
