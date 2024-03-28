---
description: Follow the steps in this guide to fine-tune the NGINX proxy gateway for
  NGINX Management Suite to support large data planes running numerous NGINX Agents.
docs: DOCS-1131
doctypes:
- tutorial
tags:
- docs
title: Optimize NGINX Proxy Gateway for Large Data Planes
toc: true
weight: 400
---

## Overview

If the NGINX proxy gateway for NGINX Management Suite alerts you that there are not enough worker connections, you may need to modify the NGINX configuration (`/etc/nginx/nginx.conf` on the NGINX Management Suite host) to allow more worker connections and increase the number of file descriptors for worker processes.

## Configure Worker Connections

By default, the NGINX Management Suite's NGINX configuration (`/etc/nginx/nginx.conf`) allows 1024 worker connections (`worker_connections`). However, this default may be insufficient if you have a large data plane with numerous NGINX Agents. To ensure optimal performance, we suggest allowing **twice as many worker connections as the number of NGINX Agents** you want to support. This is because each NGINX Agent requires two persistent gRPC connections to the NGINX Management Suite. If you have 1,000 NGINX Agents, for example, you should allow around 2,000 worker connections.

You may also want to adjust the maximum number of file descriptors (`worker_rlimit_nofile`) that a process can open to align with the number of worker connections. Note that `rlimit_nofile` is a system setting, so make sure to check the user limits for your Linux distribution, as these may be more restrictive.

To update the number of worker connections and file descriptors, edit the NGINX configuration file (`/etc/nginx/nginx.conf`) on the NGINX Management Suite host. For more information on the NGINX worker connection and file descriptor settings, refer to the following NGINX Core topics:

- [NGINX worker_connections](http://nginx.org/en/docs/ngx_core_module.html#worker_connections)
- [NGINX worker_rlimit_nofile](http://nginx.org/en/docs/ngx_core_module.html#worker_rlimit_nofile)

## Configure GRPC for Agents

By default, the NGINX Management Suite's NGINX configuration (`/etc/nginx/conf.d/nms-http.conf`) times out the gRPC connection from Agents at 10 minutes using the client body timeout (`client_body_timeout`). You can adjust this value to suit your needs; a lower value will time out gRPC connection from aborted Agent connections faster. An aborted Agent connection can happen when the Agent disconnects unexpectedly from the network without going through the gRPC protocol teardown process.

To update the timeout value, edit the NGINX Management Suite's NGINX configuration file (`/etc/nginx/conf.d/nms-http.conf`) on the NGINX Management Suite host. For example:

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
