---
description: Dynamically reconfigure the servers in an F5 NGINX Plus upstream group
  using the NGINX Plus API, without reloading configuration or restarting processes.
docs: DOCS-415
title: Dynamic Configuration of Upstreams with the NGINX Plus API
toc: true
weight: 700
type:
- how-to
---

<span id="overview"></span>
## Overview

With F5 NGINX Plus, configuration of upstream servers in a server group can be modified on-the-fly without reloading the servers and NGINX configuration. This is useful for:

- autoscaling, when you need to add more servers
- maintenance, when you need to remove a server, specify a backup server, or take a server down temporarily
- quick setup, when you need to change upstream server settings such as server weight, active connections, slow start, failure timeouts.
- monitoring, when you get the state of the server or server group with one command

These changes are made with the NGINX Plus REST API interface with API commands.

> **Note:** In NGINX Plus Release 12 (<a href="../../../releases/#r12">R12</a>) and earlier, dynamic configuration was performed with the `upstream_conf` handler. That API (and the extended `status` API) are now deprecated in favor of the NGINX Plus API.


<span id="prereq"></span>
## Prerequisites

Prior to using the dynamic configuration feature, make sure that you have the following environment:

1. NGINX Plus <a href="../../../releases/#r13">R13</a> or later
2. You have created upstream groups of application or web servers, as described in [HTTP Load Balancing]({{< relref "http-load-balancer.md" >}}) and [TCP/UDP Load Balancing]({{< relref "tcp-udp-load-balancer.md" >}})
3. Upstream server groups reside in the shared memory zone, as described in [Sharing Data with Multiple Worker Processes]({{< relref "http-load-balancer.md" >}})


<span id="api_setup"></span>
## Enabling Dynamic Configuration

1. Create an upstream server group as described in <a href="../http-load-balancer/#proxying-http-traffic-to-a-group-of-servers">Proxying Traffic to a Group of Servers</a>.

    ```nginx
    http {
        # ...
        upstream appservers {
            server appserv1.example.com      weight=5;
            server appserv2.example.com:8080 fail_timeout=5s;
            server reserve1.example.com:8080 backup;
            server reserve2.example.com:8080 backup;
        }

        server {
        # Location that proxies requests to the upstream group
            location / {
                proxy_pass http://appservers;
                health_check;
             }
        }
    }
    ```

1. Include the [`zone`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone) directive in the `upstream` block. The `zone` directive configures a zone in the shared memory and sets the zone name and size. The configuration of the server group is kept in this zone, so all worker processes use the same configuration:

    ```nginx
    http {
        # ...
        upstream appservers {
            zone appservers 64k;

            server appserv1.example.com      weight=5;
            server appserv2.example.com:8080 fail_timeout=5s;
            server reserve1.example.com:8080 backup;
            server reserve2.example.com:8080 backup;
        }
    }
    ```

2. Enable the NGINX API in read‑write mode by including the [`api`](https://nginx.org/en/docs/http/ngx_http_api_module.html#api) directive in a dedicated [`location`](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) block in a [`server`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block.

   We strongly recommend restricting access to the location and to `PATCH`/`POST`/`DELETE` methods. This example uses the [`allow`](https://nginx.org/en/docs/http/ngx_http_access_module.html#allow) and [`deny`](https://nginx.org/en/docs/http/ngx_http_access_module.html#deny) directives to grant access from the `localhost` address (`127.0.0.1`) and deny access from all other addresses. It also restricts access to `PATCH`/`POST`/`DELETE` methods with [HTTP basic authentication](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html):

    ```nginx
    server {
        location /api {
            limit_except GET {
                auth_basic "NGINX Plus API";
                auth_basic_user_file /path/to/passwd/file;
            }
            api write=on;
            allow 127.0.0.1;
            deny  all;
        }
    }
    ```

Complete example:

```nginx
http {
    # ...
    # Configuration of the server group
    upstream appservers {
        zone appservers 64k;

        server appserv1.example.com      weight=5;
        server appserv2.example.com:8080 fail_timeout=5s;
        server reserve1.example.com:8080 backup;
        server reserve2.example.com:8080 backup;
    }
    server {
        # Location that proxies requests to the upstream group
        location / {
            proxy_pass http://appservers;
            health_check;
        }

        # Location for dynamic configuration requests
        location /api {
            limit_except GET {
                auth_basic "NGINX Plus API";
                auth_basic_user_file /path/to/passwd/file;
            }
            api write=on;
            allow 127.0.0.1;
            deny  all;
        }
    }
}
```

<span id="api_use"></span>
## Using the API for Dynamic Configuration

The NGINX Plus REST API supports the following HTTP methods:

- `GET` – Display information about an upstream group or individual server in it
- `POST` – Add a server to the upstream group
- `PATCH` – Modify the parameters of a particular server
- `DELETE` – Delete a server from the upstream group

The endpoints and methods for the NGINX Plus API are described in the [NGINX Modules Reference](https://nginx.org/en/docs/http/ngx_http_api_module.html). In addition, the API has a built‑in a Swagger specification that can be used to explore the API and understand the capabilities of each resource. The Swagger documentation can be accessed at `http://_NGINX-host_/swagger-ui/`.

To change the configuration of an upstream group dynamically, send an HTTP request with the appropriate API method. The following examples use the `curl` command, but any mechanism for making HTTP requests is supported. All request bodies and responses are in JSON format.

The URI specifies the following information in this order:

- The hostname or IP address of the node that handles the request (in the following examples, `127.0.0.1`)
- The location where the `api` directive appears (`api`)
- The API version (`9`)
- The name of the upstream group, complete its place in the NGINX Plus configuration hierarchy represented as a slash‑separated path (`http/upstreams/appservers`)

For example, to add a new server to the `appservers` upstream group, send the following `curl` command:

```shell
curl -X POST -d '{ \
   "server": "10.0.0.1:8089", \
   "weight": 4, \
   "max_conns": 0, \
   "max_fails": 0, \
   "fail_timeout": "10s", \
   "slow_start": "10s", \
   "backup": true, \
   "down": true \
 }' -s 'http://127.0.0.1/api/9/http/upstreams/appservers/servers'
```

To remove a server from the upstream group:

```shell
curl -X DELETE -s 'http://127.0.0.1/api/9/http/upstreams/appservers/servers/0'
```

To set the `down` parameter for the first server in the group (with ID `0`):

```shell
curl -X PATCH -d '{ "down": true }' -s 'http://127.0.0.1/api/9/http/upstreams/appservers/servers/0'
```


<span id="example"></span>
### Interactive Example

You can explore the Swagger interface to the NGINX Plus API in read‑only mode at [https://demo.nginx.com/swagger-ui/](https://demo.nginx.com/swagger-ui/).


<span id="state"></span>
## Configuring Persistence of Dynamic Configuration

With the basic configuration in
[Enabling the API](#api_setup), changes made with the API are stored only in the shared memory zone. The changes are discarded when the NGINX Plus configuration file is reloaded.

To make the changes persist across configuration reloads, move the list of upstream servers from the `upstream` block to a special file for storing server state, defined with the [`state`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#state) directive. The recommended path for Linux distributions is `/var/lib/nginx/state/`, and for FreeBSD distributions is `/var/db/nginx/state/`.

```nginx
http {
    # ...
    upstream appservers {
        zone appservers 64k;
        state /var/lib/nginx/state/appservers.conf;

        # All servers are defined in the state file
        # server appserv1.example.com      weight=5;
        # server appserv2.example.com:8080 fail_timeout=5s;
        # server reserve1.example.com:8080 backup;
        # server reserve2.example.com:8080 backup;
    }
}
```

Keep in mind that the state file can be modified only with configuration commands from the [API](https://nginx.org/en/docs/http/ngx_http_api_module.html) interface; do not modify the file directly (for example, using a text editor).
