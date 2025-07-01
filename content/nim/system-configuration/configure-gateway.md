---
nd-docs: DOCS-1131
title: Optimize NGINX proxy gateway for large data planes
toc: true
weight: 400
type:
- tutorial
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Overview

If the NGINX proxy gateway for F5 NGINX Instance Manager alerts you that there are not enough worker connections, you may need to update the NGINX configuration (`/etc/nginx/nginx.conf`) on the NGINX Instance Manager host. These updates include increasing the number of worker connections and file descriptors for worker processes to support larger data planes effectively.

---

## Configure worker connections

By default, the NGINX Instance Manager's NGINX configuration allows 1,024 worker connections (`worker_connections`). However, this default may not be sufficient for large data planes with numerous NGINX Agents.

We recommend allowing **twice as many worker connections as the number of NGINX Agents** you need to support. Each NGINX Agent requires two persistent gRPC connections to the NGINX Instance Manager host. For example, if you have 1,000 NGINX Agents, configure approximately 2,000 worker connections.

To align with the worker connection count, you should also adjust the maximum number of file descriptors (`worker_rlimit_nofile`) that worker processes can open. Since `rlimit_nofile` is a system setting, ensure your Linux user limits allow the required number of file descriptors.

### Update worker connections and file descriptors

1. Open the NGINX configuration file on the NGINX Instance Manager host:

    ```bash
    sudo nano /etc/nginx/nginx.conf
    ```

2. Modify the `worker_connections` and `worker_rlimit_nofile` settings as needed:

    ```nginx
    events {
        worker_connections 2000;
    }

    worker_rlimit_nofile 2000;
    ```

3. Save the changes and restart NGINX:

    ```bash
    sudo systemctl restart nginx
    ```

For more information, refer to the official NGINX documentation:
- [worker_connections](http://nginx.org/en/docs/ngx_core_module.html#worker_connections)
- [worker_rlimit_nofile](http://nginx.org/en/docs/ngx_core_module.html#worker_rlimit_nofile)

---

## Configure gRPC for agents

By default, the NGINX Instance Manager's NGINX configuration (`/etc/nginx/conf.d/nms-http.conf`) times out gRPC connections from NGINX Agents after 10 minutes using the `client_body_timeout` directive. You can adjust this timeout to better suit your needs. For example, a shorter timeout quickly clears connections from agents that disconnect unexpectedly without completing the gRPC protocol teardown.

### Update gRPC timeout settings

1. Open the gRPC configuration file on the NGINX Instance Manager host:

    ```bash
    sudo nano /etc/nginx/conf.d/nms-http.conf
    ```

2. Locate the gRPC service locations and modify the `client_body_timeout` value as needed. For example:

    ```nginx
    # gRPC service for metric ingestion
    location /f5.nginx.agent.sdk.MetricsService {
        # uncomment to enable mTLS with agent
        # auth_request /check-agent-client-cert;
        include /etc/nms/nginx/errors-grpc.loc_conf;
        grpc_socket_keepalive on;
        grpc_read_timeout 5m;
        grpc_send_timeout 5m;
        client_body_timeout 10m;
        grpc_pass grpc://ingestion-grpc-service;
    }

    # gRPC service for DPM
    location /f5.nginx.agent.sdk.Commander {
        # uncomment to enable mTLS with agent
        # auth_request /check-agent-client-cert;
        include /etc/nms/nginx/errors-grpc.loc_conf;
        grpc_socket_keepalive on;
        grpc_read_timeout 5m;
        grpc_send_timeout 5m;
        client_body_timeout 10m;
        grpc_pass grpc://dpm-grpc-service;
    }
    ```

3. Save the changes and restart NGINX:

    ```bash
    sudo systemctl restart nginx
    ```
