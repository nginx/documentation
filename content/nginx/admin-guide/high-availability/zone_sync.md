---
description: This article describes how to use F5 NGINX Plus to synchronize shared
  memory zones across NGINX cluster nodes including sticky learn session persistence,
  requests limiting, and key-value store data.
docs: DOCS-407
title: Runtime State Sharing in a Cluster
toc: true
weight: 400
type:
- how-to
---

<span id="intro"></span>
## Introduction

If several F5 NGINX Plus instances are organized in a cluster, they can share some state data between them, including:

- [sticky learn](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/#sticky) session persistence
- [requests limiting](https://docs.nginx.com/nginx/admin-guide/security-controls/controlling-access-proxied-http/#limit_req)
- [key-value storage](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone)

All NGINX Plus instances can exchange state data with all other members in a cluster, provided that the shared memory zone has the same name on all cluster members.


<span id="prerequisites"></span>
## Prerequisites

- <a href="../../../releases/#r16">NGINX Plus R16</a> for sharing limits of requests processing and key-value data across the cluster
- <a href="../../../releases/#r15">NGINX Plus R15</a> for sharing limits of sticky learn data across the cluster

State sharing across a cluster is eventually consistent by nature. It is strongly recommended using data-center grade networks for clustering traffic, as latency, low bandwidth, and packet loss will have a significant negative impact on state consistency. We do not recommend stretching clusters over the Internet, regions, or availability zones.

<span id="config"></span>
## Configuring zone synchronization

For each NGINX instance in a cluster, open the NGINX configuration file and perform the following steps:

1. Enable synchronization between cluster nodes: in the top-level [`stream`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) block, create a [`server`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#server) with the [`zone_sync`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync) directive:

   ```nginx
    stream {
       #...

        server {
            zone_sync;
            #...
        }
    }
   ```

2. Specify all other NGINX instances in a cluster with the [`zone_sync_server`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_server) directive. Cluster nodes can be  added dynamically using the DNS service if the [`resolver`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#resolver) is used:

   ```nginx
    stream {

        resolver 10.0.0.53 valid=20s;

        server {
            zone_sync;
            zone_sync_server nginx-cluster.example.com:9000 resolve;
        }
    }
   ```

   Otherwise, each cluster node can be added statically as a separate line of the [`zone_sync_server`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_server) directive:

   ```nginx
    stream {

        server {
            zone_sync;
            zone_sync_server nginx-node1.example.com:9000;
            zone_sync_server nginx-node2.example.com:9000;
            zone_sync_server nginx-node3.example.com:9000;
        }
    }
   ```

3. Enable SSL by specifying the `ssl` parameter of the [`listen`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#listen) directive for the TCP server:

   ```nginx
   stream {

       resolver 10.0.0.53 valid=20s;

       server {
           listen 10.0.0.1:9000 ssl;
           #...

           zone_sync;
           zone_sync_server nginx-cluster.example.com:9000 resolve;
           #...
       }
   }
   ```

4. Specify the path to the certificates with the [`ssl_certificate`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_certificate) directive, and to the private key with the [`ssl_certificate_key`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_certificate_key) directive. Both the certificate and key must be in the PEM format:

    ```nginx
    stream {

        resolver 10.0.0.53 valid=20s;

        server {
            listen 10.0.0.1:9000 ssl;

            ssl_certificate     /etc/ssl/nginx-1.example.com.server_cert.pem;
            ssl_certificate_key /etc/ssl/nginx-1.example.com.key.pem;

            zone_sync;
            zone_sync_server    nginx-cluster.example.com:9000 resolve;
            #...

        }
    }
    ```

5. Enable SSL connections between cluster servers with the [`zone_sync_ssl`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl) directive, and enable verification of another cluster server certificate with [`zone_sync_ssl_verify`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_verify) and [`zone_sync_ssl_trusted_certificate`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_trusted_certificate) directives:

   ```nginx
    stream {

        resolver 10.0.0.53 valid=20s;

        server {
            listen 10.0.0.1:9000 ssl;

            ssl_certificate        /etc/ssl/nginx-1.example.com.server_cert.pem;
            ssl_certificate_key    /etc/ssl/nginx-1.example.com.key.pem;

            zone_sync;
            zone_sync_server    nginx-cluster.example.com:9000 resolve;

            zone_sync_ssl                     on;
            zone_sync_ssl_verify              on;
            zone_sync_ssl_trusted_certificate /etc/ssl/server_ca.pem;
            #...
        }
    }
   ```

6. Set up certificate-based authentication across cluster nodes.

   Add the [`zone_sync_ssl_certificate`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_certificate) and [`zone_sync_ssl_certificate_key`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_certificate_key`) directives to send the client certificate for outgoing connections.

   Then configure NGINX to require client certificates by setting the [`ssl_verify_client`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_verify_client) directive to `on` and specifying the location of your client certificates CA with the [`ssl_trusted_certificate`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_trusted_certificate) directive:

   ```nginx
    stream {

        resolver 10.0.0.53 valid=20s;

        server {
            listen 10.0.0.1:9000 ssl;

            ssl_certificate        /etc/ssl/nginx-1.example.com.server_cert.pem;
            ssl_certificate_key    /etc/ssl/nginx-1.example.com.key.pem;

            zone_sync;
            zone_sync_server    nginx-cluster.example.com:9000 resolve;

            zone_sync_ssl                     on;
            zone_sync_ssl_verify              on;
            zone_sync_ssl_trusted_certificate /etc/ssl/server_ca.pem;

            zone_sync_ssl_certificate     localhost.crt;
            zone_sync_ssl_certificate_key localhost.key;

            ssl_verify_client       on;
            ssl_trusted_certificate /etc/ssl/client_ca.pem;
            #...
       }
   }
   ```

<span id="config_finetune"></span>
### Fine-tuning Synchronization

Generally you do not have to tune sync options, but in some cases it can be useful to adjust some of these values:

```nginx
#...
zone_sync;
zone_sync_server nginx-cluster.example.com:9000 resolve;

zone_sync_buffers                256 4k;
zone_sync_connect_retry_interval 1s;
zone_sync_connect_timeout        5s;
zone_sync_interval               1s;
zone_sync_timeout                5s;
#...
```

[`zone_sync_buffers`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_buffers) - controls the number of buffers and their size. Increasing the number of buffers will increase the number of information stored in them.

[`zone_sync_connect_retry_interval`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_connect_retry_interval) - sets the timeout between connection attempts to a cluster node.

[`zone_sync_connect_timeout`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_connect_timeout) - sets the time required to connect to a cluster node.

[`zone_sync_interval`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_interval) - sets an interval for polling updates in a shared memory zone. Increasing this value may result in data inconsistency between cluster nodes, decreasing the value may lead to high consumption of cpu and memory resources.

[`zone_sync_timeout`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_timeout) - sets the lifetime of a TCP stream between cluster nodes. If a TCP stream is idle for longer than the value, the connection will be closed.


<span id="manage"></span>
## Managing Cluster Nodes

<span id="manage_start"></span>
### Starting a Node

To start a new node:

- in case of DNS, update a DNS record of a cluster hostname with the IP address of the new node and start an instance
- in case of statically added nodes, add the node's address to nginx configuration file and reload all other nodes

When the node is started, it discovers other nodes from DNS or static configuration and starts sending updates. Other nodes eventually discover the new node using DNS and start pushing updates to it.


<span id="manage_stop"></span>
### Stopping a Node

To stop a node, send the 'QUIT' signal:

```shell
nginx -s quit
```

As soon as the node receives the signal, it finishes zone synchronization and gracefully closes open connections.


<span id="manage_remove"></span>
### Removing a Node

To remove a node:

- in case of DNS, update a DNS record of a cluster hostname and remove the node's IP address
- in case of statically added nodes, remove the node's address from nginx configuration file on each node and reload each node.

When the node is removed, other nodes close connections to the removed node and will no longer try to connect to it. After the node is removed, it can be stopped.


<span id="sync"></span>
## Using synchronization in a cluster

<span id="sync_sticky_learn"></span>
### Sticky learn zone synchronization

If your existing configuration already uses the [sticky learn](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/#sticky) feature, existing state can be simply shared across a cluster by adding the [`sync`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_learn_sync) parameter to the existing `sticky` directive in the configuration file of each NGINX instance in a cluster.
Note that the zone name must be the same in all other NGINX nodes in the cluster:

```nginx
upstream my_backend {
    zone my_backend 64k;

		server backends.example.com resolve;
			sticky learn zone=sessions:1m
			create=$upstream_cookie_session
			lookup=$cookie_session
			sync;
}

server {
    listen 80;
		location / {
		    proxy_pass http://my_backend;
		}
}
```

See [Enabling Session Persistence](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/#sticky) for information how to configure the "sticky learn" session persistence method.


<span id="sync_limit_req"></span>
### Request limits zone synchronization

If your existing configuration already uses rate limiting, these limits can be applied across a cluster by simply adding the [`sync`](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone) parameter to the [`limit_req_zone`](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone) directive in the configuration file of each NGINX instance in a cluster:

```nginx
limit_req_zone $remote_addr zone=req:1M rate=100r/s sync;

server {
    listen 80;
    location / {
        limit_req zone=req;

        proxy_pass http://my_backend;
    }
}
```

The zone name also must be the same in all other NGINX nodes in the cluster.

See [Limiting the Request Rate](https://docs.nginx.com/nginx/admin-guide/security-controls/controlling-access-proxied-http/#limit_req) for more information.


<span id="sync_keyval"></span>
### Key-value storage zone synchronization

Similar to rate limiting and sticky learn, the contents of the key-value shared memory zone can be shared across NGINX machines in a cluster with the `sync` parameter of the [`keyval_zone`](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone) directive:

```nginx
keyval_zone zone=one:32k state=/var/lib/nginx/state/one.keyval sync;
keyval $arg_text $text zone=one;
#...
server {
    #...
    location / {
        return 200 $text;
    }

    location /api {
        api write=on;
    }
}
```

See [Dynamic Denylisting of IP Addresses]({{< relref "/nginx/admin-guide/security-controls/denylisting-ip-addresses.md" >}}) for information how to configure and manage the key-value storage.


<span id="monitor"></span>
## Monitoring Cluster State

Cluster state data can be monitored with [NGINX Plus API metrics](https://nginx.org/en/docs/http/ngx_http_api_module.html#stream_zone_sync_):

- names of shared memory zones
- total number of records on node
- number of records that needs to be sent
- sync status per each node in the cluster


<span id="monitor_api_config"></span>
## Configuring the API

In order to get access to API metrics, you will need to configure the API:

1. Enable the NGINX Plus API in read‑write mode with the [`api`](https://nginx.org/en/docs/http/ngx_http_api_module.html#api) directive:

   ```nginx
   # ...
    server {
        listen 80;
        server_name www.example.com;

        location /api {
            api write=on;
        }
    }
    ```

2. It is highly recommended to [restrict access]({{< relref "/nginx/admin-guide/security-controls/controlling-access-proxied-http.md" >}}) to this location, for example by allowing access only from localhost (`127.0.0.1`), and by restricting access to `PATCH`, `POST`, and `DELETE` methods to some users with HTTP basic authentication:

   ```nginx
   # ...
    server {
        listen 80;
        server_name www.example.com;

        location /api {
            limit_except GET {
                auth_basic "NGINX Plus API";
                auth_basic_user_file /path/to/passwd/file;
            }

            api   write=on;

            allow 127.0.0.1;
            deny  all;
        }
    }
    ```

See [Using the API for Dynamic Configuration](https://docs.nginx.com/nginx/admin-guide/load-balancer/dynamic-configuration-api/#api_use) for instructions how to configure and use NGINX Plus API.


<span id="monitor_api_use"></span>
## Polling Sync Status with the API
To get the synchronization status of the shared memory zone, send the API command, for example, with `curl`:

```shell
curl -s '127.0.0.1/api/9/stream/zone_sync' | jq
```

The output will be:

```json
{
  "zones" : {
    "zone1" : {
      "records_pending" : 2061,
      "records_total" : 260575
    },
    "zone2" : {
      "records_pending" : 0,
      "records_total" : 14749
    }
  },
  "status" : {
    "bytes_in" : 1364923761,
    "msgs_in" : 337236,
    "msgs_out" : 346717,
    "bytes_out" : 1402765472,
    "nodes_online" : 15
  }
}
```

If all nodes have approximately the same number of records ([`records_total`](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_zone_sync_zone)) and almost empty outgoing queue ([`records_pending`](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_zone_sync_zone)), the cluster may be considered healthy.
