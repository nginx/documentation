---
description: Migrate load-balancing configuration from Citrix ADC to F5 NGINX Plus
  for equal performance at lower cost, using our syntax conversion examples.
nd-docs: DOCS-459
title: Migrating Load Balancer Configuration from Citrix ADC to NGINX Plus
toc: true
weight: 100
type:
- how-to
---

F5 NGINX Plus provides a flexible replacement for traditional hardware‑based [application delivery controllers](https://www.nginx.com/resources/glossary/application-delivery-controller/) (ADCs). As a software load balancer with a small footprint, NGINX Plus can be deployed just about anywhere – on bare metal, on a virtual machine, or in a container, and on‑premises or in public, private, and hybrid clouds. This guide explains how to migrate the Citrix ADC configuration for several common load‑balancer features to the NGINX Plus application delivery platform. It covers the most commonly used features to get you started quickly.

**Note:** Citrix ADC was formerly called Citrix NetScaler.

NGINX Plus and Citrix ADC both act as a full reverse proxy and load balancer, so that the client sees the load balancer as the application and the backend servers see the load balancer as the client. This allows for great control and fine‑grained manipulation of the traffic. This guide focuses on basic load balancing. For information on extending the configuration with Layer 7 logic and scripting, see the article on [migrating Layer 7 logic](https://www.nginx.com/blog/migrating-layer7-logic-f5-irules-citrix-policies-nginx-plus/) on the NGINX blog. It covers features such as content switching and request routing, rewriting, and redirection.

<span id="about-nginx"></span>
## About NGINX Open Source and NGINX Plus

[NGINX Open Source](https://nginx.org/en) is an open source web server, reverse proxy, and load balancer that has grown in popularity in recent years due to its scalability. <span style="white-space: nowrap;">NGINX Open Source</span> was first created to solve the C10K problem (serving 10,000 simultaneous connections on a single web server). Its features and performance have made it the go‑to solution at high‑performance sites – it's [the #1 web server at the 100,000 busiest websites in the world](https://w3techs.com/technologies/cross/web_server/ranking).

[NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) is the commercially supported version of <span style="white-space: nowrap;">NGINX Open Source</span>. NGINX Plus is a complete software load balancer and application delivery platform, extending the power of <span style="white-space: nowrap;">NGINX Open Source</span> with a host of enterprise‑ready capabilities that are instrumental to building web applications at scale:

- Full‑featured [HTTP]({{< ref "nginx/admin-guide/load-balancer/http-load-balancer.md" >}}), [TCP, and UDP]({{< ref "nginx/admin-guide/load-balancer/tcp-udp-load-balancer.md" >}}) load balancing
- [Intelligent session persistence]({{< ref "nginx/admin-guide/load-balancer/http-load-balancer.md#session-persistence" >}})
- [High‑performance reverse proxy]({{< ref "nginx/admin-guide/web-server/reverse-proxy.md" >}})
- [Caching and offload of dynamic and static content]({{< ref "nginx/admin-guide/content-cache/content-caching.md" >}})
- Adaptive streaming to deliver audio and video to any device
- [Application-aware health checks]({{< ref "nginx/admin-guide/load-balancer/http-health-check.md" >}}) and [high availability]({{< ref "nginx/admin-guide/high-availability/ha-keepalived.md" >}})
- Advanced activity monitoring available via a [Dashboard]({{< ref "nginx/admin-guide/monitoring/live-activity-monitoring.md#using-the-dashboard" >}}) or [REST API]({{< ref "nginx/admin-guide/monitoring/live-activity-monitoring.md#using-the-rest-api" >}})
- [Management and real‑time configuration changes with DevOps‑friendly tools](https://www.nginx.com/products/nginx/load-balancing/#load-balancing-api)

<span id="prereqs"></span>
## Prerequisites

This guide assumes you are familiar with Citrix ADC concepts and CLI configuration commands.

Familiarity with basic NGINX software concepts and directives is also helpful; links to documentation are provided, but the guide does not explain NGINX Plus functioning in depth.

<span id="networking"></span>
## Mapping Citrix ADC Networking Concepts to NGINX Plus

The networking configuration for Citrix ADC defines three types of IP addresses, which can be easily mapped to NGINX Plus:

- **Citrix ADC IP address (NSIP)** – Management IP address of a specific Citrix ADC appliance. The NGINX Plus equivalent is the host IP address of the NGINX Plus instance.
- **Subnet IP address (SNIP)** – The source (client) IP address seen by backend servers in the load‑balancing configuration. By default, the NGINX Plus equivalent is the same as for the NSIP: the host IP address of the NGINX Plus instance.

  Both NGINX Plus and Citrix ADC use a routing table to choose the best IP address to use. With Citrix ADC, you manage the routing table in the Citrix ADC CLI or GUI, but with NGINX Plus you need to edit the system‑level routing for your Linux or FreeBSD OS. You can also use the [proxy_bind](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_bind) directive in the NGINX Plus configuration to specify the source address used for a specific application.

- **Virtual IP address (VIP)** – Address advertised to clients for the service provided by the backend servers. The VIP functions in the same way for both Citrix ADC and NGINX Plus: if the primary device or instance fails, the VIP address is reassigned to the secondary.

<span id="convert-configuration"></span>
## Converting Citrix ADC Load Balancer Configuration to NGINX Plus

Citrix ADC uses a CLI for configuration. Even changes made in the GUI are translated internally to CLI commands, so we'll represent Citrix ADC configuration in the CLI format.

NGINX Plus instead defines configuration with directives in a text file. The following sections explain how to convert Citrix ADC configuration to NGINX Plus for these entities and features:

- [Virtual Servers](#virtual-servers)
- [SSL/TLS Termination](#ssl)
- [Service Group Entities](#service-group)
- [Session Persistence](#session-persistence)
- [Monitors (Health Checks)](#health-checks)
- [Summary of Converted Load Balancer Configuration](#configuration-summary)

<span id="virtual-servers"></span>

### Virtual Servers

Citrix ADC uses only the combination of IP address and port to select the virtual server for a request. If you want to consider information in the `Host` header as well, you use AppExpert policies or a Content Switch Virtual Server to inspect it.

In contrast, the NGINX Plus definition of a virtual server in a [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block can include both IP address‑port combinations and values in the `Host` header. Include the [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) directive in that block to specify the values to match in the `Host` header.

The list of parameters to the `server_name` directive can include multiple hostnames, wildcards, and regular expressions. You can include multiple `server_name` directives and multiple listening IP address‑port combinations within one NGINX Plus `server` block. For more information on using `Host` and the `server_name` directive instead of IP addresses, see [Server names](https://nginx.org/en/docs/http/server_names.html) at **nginx.org**.

The following sample virtual server configuration is for a hostname that ends in **.example.com**.

#### Citrix ADC

```none
add lb vserver myvserver HTTP 10.0.0.99 80
```

#### NGINX Plus

```nginx
server {
    listen 10.0.0.99:80;
    server_name .example.com;
    #...
}
```

Directive documentation: [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen), [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name)

<span id="ssl"></span>

### SSL/TLS Termination

Handling SSL/TLS termination is a common use case for ADC load balancers. Both Citrix ADC and NGINX Plus use OpenSSL libraries to perform the encryption/decryption. NGINX Plus uses the system‑level libraries, so the OpenSSL version is determined by the OS. Citrix ADC uses a modified version of OpenSSL included within its firmware.

To define the SSL/TLS key and certificate, NGINX Plus uses the `ssl_certificate` and `ssl_certificate_key` directives. The following load‑balancer configuration examples offload SSL/TLS termination from the backend servers.

#### Citrix ADC

```none
add ssl certKey test.crt -cert test.crt -key test.key
add lb vserver mysslvserver SSL 10.0.0.98 443
bind ssl vserver mysslvserver -certkeyName test.crt
```

#### NGINX Plus

```nginx
server {
    listen 10.0.0.98:443 ssl;
    ssl_certificate     test.crt;
    ssl_certificate_key test.key;
    #...
}
```

Directive documentation: [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen), [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [ssl_certificate and ssl_certificate_key](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate)

<span id="service-group"></span>

### Service Group Entities

It is straightforward to migrate the Citrix ADC entities that make up Services and Service Groups to NGINX Plus. Citrix ADC uses three major entity types:

- **Server** – IP address or hostname of a specific backend server
- **Service** – Association of a server entity with a listening port and monitor
- **Service Group** – Association of a pool of server entities and listening ports with a monitor

NGINX Plus uses the `upstream` block to represent a pool of backend application servers. In the most basic configuration, there is a `server` directive in the `upstream` block for each server in the pool, specifying its IP address or hostname.

The following load‑balancer configuration examples define a server pool called **myapp** with three servers in it.

#### Citrix ADC

```none
add serviceGroup myapp HTTP
bind serviceGroup myapp 10.0.0.100 80
bind serviceGroup myapp 10.0.0.101 80
bind serviceGroup myapp 10.0.0.102 80
```

#### NGINX Plus

```nginx
upstream myapp {
    server 10.0.0.100:80;
    server 10.0.0.101:80;
    server 10.0.0.102:80;
}
```

Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

<span id="session-persistence"></span>

### Session Persistence

Session persistence is critical for stateless applications and is helpful for continuous delivery use cases. Citrix ADC and NGINX Plus handle session persistence in a similar way.

If NGINX Plus' [Sticky Cookie](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky) method is compatible with the application, it's a good choice, as it is simple to configure and handles failover well. It works just like the _cookie insert_ method in Citrix ADC: the load balancer adds a session cookie to the first response from a backend server to a given client. The client then includes the cookie in subsequent requests and the load balancer uses it to route the request to the same server. This method doesn't require the load balancer to maintain information about session state, because the session data is stored in the client‑side cookie.

A logical difference between the products is that Citrix ADC defines session persistence in the configuration for a virtual server, whereas NGINX Plus defines it in the context of the backend server group (`upstream` block).

The following load‑balancer configuration examples set up cookie‑based session persistence.

#### Citrix ADC - Cookie-based

```none
add lb vserver mysslvserver SSL 10.0.0.91 443 -persistenceType COOKIEINSERT -timeout 60 -cookieName mysession
```

#### NGINX Plus - Cookie-based

```nginx
upstream myapp {
    server 10.0.0.100:80;
    server 10.0.0.101:80;
    server 10.0.0.102:80;
    sticky cookie mysession expires=1h;
}
```

Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [`sticky cookie`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

Another session persistence method available in both products takes advantage of a cookie or other token created by the session participants, such as a `JSESSIONID`. NGINX Plus calls this the [Sticky Learn](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky) method. The load balancer maintains a table in memory to map each cookie to a specific backend server.

The following load‑balancer configuration examples set up session persistence based on the `JSESSIONID` found in an existing cookie.

#### Citrix ADC - JSESSIONID-based

```none
set lb vserver mysslvserver -persistencetype RULE -rule 'HTTP.REQ.COOKIE.VALUE("jsessionid")' -resRule 'HTTP.RES.SET_COOKIE.COOKIE("jsessionid")'
```

#### NGINX Plus - JSESSIONID-based

```nginx
upstream myapp {
    server 10.0.0.100:80;
    server 10.0.0.101:80;
    server 10.0.0.102:80;
    sticky learn create=$upstream_cookie_jsessionid
                 lookup=$cookie_jsessionid
                 zone=client_sessions:1m;
}
```

Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [`sticky learn`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

The third NGINX Plus session persistence method, [Sticky Route](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky), is comparable to Citrix ADC's [custom server ID persistence](https://docs.citrix.com/en-us/citrix-adc/12-1/load-balancing/load-balancing-persistence/custom-server-id-persistence.html). In this method a particular backend server is specified in each request.

<span id="health-checks"></span>

### Monitors (Health Checks)

Citrix ADC uses the term _monitor_ for what NGINX Plus calls a _health check_. You associate a monitor directly with a Citrix ADC service or service group, whereas an NGINX Plus health check is defined in a `location` block.

With the following load‑balancer configuration examples, the load balancer sends a request for **/** to backend servers; by default, Citrix ADC sends `HEAD` requests and NGINX Plus sends `GET` requests. Citrix ADC marks the server as healthy if it returns response code `200`, while with this default configuration NGINX Plus accepts any `2xx` or `3xx` code.

#### Citrix ADC - Default health check

```none
add lb monitor httphealth HTTP -respCode 200 -httpRequest "HEAD /"
bind serviceGroup myapp -monitorName httphealth
```

#### NGINX Plus - Default health check

```nginx
location / {
    proxy_pass http://myapp;
    health_check;
}
```

Directive documentation: [health_check](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check), [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)

It's also possible with both products to define additional characteristics of the request or response. The following examples mark a backend server as healthy if it returns response code `200` and the message body includes the text `Welcome to nginx!`.

#### Citrix ADC - Custom health check

```none
add lb monitor httphealth-ecv HTTP-ECV -send "GET /" -recv "Welcome to nginx!"
bind serviceGroup myapp -monitorName httphealth-ecv
```

#### NGINX Plus - Custom health check

```nginx
match server_ok {
    status 200;
    body ~ "Welcome to nginx!";
}
server {
    #...
    location / {
        proxy_pass http://myapp;
        health_check match=server_ok;
    }
}
```

Directive documentation: [health_check](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check), [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [match](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#match), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass), [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server)

For more information about NGINX Plus health checks, see the [NGINX Plus Admin Guide]({{< ref "nginx/admin-guide/load-balancer/http-health-check.md" >}}).

<span id="configuration-summary"></span>

### Summary of Converted Load Balancer Configuration

The following examples bring together the commands and directives from the preceding sections. The NGINX Plus configuration includes some additional directives not discussed above:

- [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone) – Defines a shared memory zone used for health checks
- [proxy_set_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) – Ensures that requests forwarded to the backend servers include the `Host` header, set to the value extracted from that header in the client request
- [proxy_http_version](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_http_version) – Specifies HTTP version 1.1 for connections to the backend servers

#### Citrix ADC

```none
add ssl certKey test.crt -cert test.crt -key test.key
add lb vserver myssl SSL 10.0.0.98 443 -persistenceType COOKIEINSERT -timeout 60 -cookieName mysession
bind ssl vserver myssl -certkeyName test.crt
add serviceGroup myapp HTTP
bind serviceGroup myapp 10.0.0.100 80
bind serviceGroup myapp 10.0.0.101 80
bind serviceGroup myapp 10.0.0.102 80
add lb monitor httphealth HTTP -respCode 200 -httpRequest "HEAD /"
bind serviceGroup myapp -monitorName httphealth
bind lb vserver mysslvserver myapp
```

#### NGINX Plus

```nginx
upstream myapp {
    zone myapp 64k;
    server 10.0.0.100:80;
    server 10.0.0.101:80;
    server 10.0.0.102:80;
    sticky cookie mysession expires=1h;
}

server {
    listen 10.0.0.98:443 ssl default_server;
    ssl_certificate     test.crt;
    ssl_certificate_key test.key;
    proxy_set_header Host $host;
    location / {
        proxy_pass http://myapp;
        health_check;
        proxy_http_version 1.1;
    }
}
```

<span id="ha"></span>
## Configuring High Availability

NGINX Plus and Citrix ADC handle high availability (HA) in similar but slightly different ways.

Citrix ADC handles the monitoring and failover of the VIP in a proprietary way.

 For [on‑premises deployments]({{< ref "nginx/admin-guide/high-availability/ha-keepalived.md" >}}), NGINX Plus uses a separate software package called {{<nb>}}****nginx-ha-keepalived****{{</nb>}} to handle the VIP and the failover process for an active‑passive pair of NGINX Plus servers. The package implements the VRRP protocol to handle the VIP. Limited [active‑active]({{< ref "nginx/admin-guide/high-availability/ha-keepalived-nodes.md" >}}) scenarios are also possible with the {{<nb>}}**nginx-ha-keepalived**{{</nb>}} package.

Solutions for high availability of NGINX Plus in cloud environments are also available, including these:

- [Active‑Active HA for NGINX Plus on AWS Using AWS Network Load Balancer]({{< ref "nginx/deployment-guides/amazon-web-services/high-availability-network-load-balancer.md" >}})
- [Active‑Passive HA for NGINX Plus on AWS Using Elastic IP Addresses]({{< ref "nginx/deployment-guides/amazon-web-services/high-availability-keepalived.md" >}})
- [All‑Active HA for NGINX Plus on the Google Cloud Platform]({{< ref "nginx/deployment-guides/google-cloud-platform/high-availability-all-active.md" >}})

<span id="logging"></span>
## Logging in Citrix ADC and NGINX Plus

Logging and monitoring are important supporting functionality for load balancing. Both NGINX Plus and Citrix ADC support logging.

Citrix ADC logs errors in its _event log_ and NGINX Plus in its [_error log_](https://nginx.org/en/docs/ngx_core_module.html#error_log). By default, Citrix ADC does not log individual requests, but can be configured to do so, using a separate weblog client. NGINX Plus has an [_access log_](https://nginx.org/en/docs/http/ngx_http_log_module.html) for which you can define customized formats to log many metrics (as captured in [variables](https://nginx.org/en/docs/varindex.html)) from both requests and responses.

The [NGINX Plus API](https://nginx.org/en/docs/http/ngx_http_api_module.html) module collects numerous statistics, which you can access via the API, display on the built‑in live activity monitoring dashboard, or pass to third‑party monitoring tools. For more detail on logging and monitoring see the [NGINX Plus Admin Guide]({{< ref "nginx/admin-guide/monitoring/live-activity-monitoring.md" >}}).

### Revision History

- Version 3 (April 2019) – Product name changed to Citrix ADC
- Version 2 (April 2018) – Updated information about high availability and the NGINX Plus API (NGINX Plus R13, NGINX Open Source 1.13.4)
- Version 1 (November 2016) – Initial version (<span style="white-space: nowrap;">NGINX Plus R11</span>, NGINX 1.11.5)
