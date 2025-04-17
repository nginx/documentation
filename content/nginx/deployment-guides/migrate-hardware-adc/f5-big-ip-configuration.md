---
description: Migrate load-balancing configuration from F5 BIG-IP LTM to NGINX Plus,
  using our syntax conversion examples.
docs: DOCS-460
title: Migrating Load Balancer Configuration from F5 BIG-IP LTM to F5 NGINX Plus
toc: true
weight: 100
type:
- how-to
---

F5 NGINX Plus provides a flexible replacement for traditional hardware‑based [application delivery controllers](https://www.nginx.com/resources/glossary/application-delivery-controller/) (ADCs). NGINX Plus is a small software package that can be installed just about anywhere – on bare metal, a virtual machine, or a container, and on‑premises or in public, private, and hybrid clouds – while providing the same level of application delivery, high availability, and security offered by legacy ADCs. This guide explains how to migrate an <span style="white-space: nowrap;">F5 BIG-IP</span> Local Traffic Manager (LTM) configuration to the NGINX Plus software application delivery platform, and covers the most commonly used features and configurations to get you started quickly on your migration.

NGINX Plus and <span style="white-space: nowrap;">BIG-IP LTM</span> both act as a full reverse proxy and load balancer, so that the client sees the load balancer as the application and the backend servers see the load balancer as the client. This allows for great control and fine‑grained manipulation of the traffic. This guide focuses on basic load balancing. For information on extending the configuration with Layer 7 logic and scripting, see the post about [migrating Layer 7 logic](https://www.nginx.com/blog/migrating-layer7-logic-f5-irules-citrix-policies-nginx-plus/) on the NGINX blog. It covers features such as content switching and request routing, rewriting, and redirection.

<span id="about-nginx"></span>
## About NGINX Open Source and NGINX Plus

[NGINX Open Source](https://nginx.org/en) is an open source web server, reverse proxy, and load balancer that has grown in popularity in recent years due to its scalability. <span style="white-space: nowrap;">NGINX Open Source</span> was first created to solve the C10K problem (serving 10,000 simultaneous connections on a single web server). Its features and performance have made it the go‑to solution at high‑performance sites – it's [the #1 web server at the 100,000 busiest websites in the world](https://w3techs.com/technologies/cross/web_server/ranking).

[NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) is the commercially supported version of <span style="white-space: nowrap;">NGINX Open Source</span>. NGINX Plus is a complete software load balancer and application delivery platform, extending the power of <span style="white-space: nowrap;">NGINX Open Source</span> with a host of enterprise‑ready capabilities that are instrumental to building web applications at scale:

- [Full‑featured HTTP, TCP, and UDP load balancing](https://www.nginx.com/products/nginx/load-balancing/)
- [Intelligent session persistence](https://www.nginx.com/products/nginx/load-balancing/#session-persistence)
- [High‑performance reverse proxy]({{< ref "nginx/admin-guide/web-server/reverse-proxy.md" >}})
- [Caching and offload of dynamic and static content]({{< ref "nginx/admin-guide/content-cache/content-caching.md" >}})
- [Adaptive streaming to deliver audio and video to any device](https://www.nginx.com/products/nginx/streaming-media/)
- [Application-aware health checks](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/) and [high availability](https://docs.nginx.com/nginx/admin-guide/high-availability/)
- [Advanced activity monitoring available via a dashboard or API](https://www.nginx.com/products/nginx/live-activity-monitoring/)
- [Management and real‑time configuration changes with DevOps‑friendly tools](https://www.nginx.com/products/nginx/load-balancing/#load-balancing-api)


<span id="scenarios"></span><span id="deployment-scenarios"></span>
## NGINX Plus Deployment Scenarios

Architecturally speaking, NGINX Plus differs from traditional ADCs in deployment location and function. Typical hardware‑based ADCs are usually deployed at the edge of the network and act as a front‑door entry point for all application traffic. It's not uncommon to see a large hardware ADC straddle the public and private DMZs, assuming the large burden of processing 100% of the traffic as it comes into the network. You often see ADCs in this environment performing all functions related to traffic flow for all applications – security, availability, optimization, authentication, etc. – requiring extremely large and powerful hardware appliances. The downside to this model is that the ADC is always stationary at the "front door" of the network.

As they update their infrastructure and approach to application delivery, many companies are paring down the hardware ADC functionality at the edge and moving to a more distributed application model. Because the legacy hardware ADC is already sitting at the edge of the network it can continue to handle all ingress traffic management, directing application traffic to the appropriate NGINX Plus instances for each application type. NGINX Plus then handles traffic for each application type to provide application‑centric load balancing and high availability throughout the network, both on‑ and off‑premises. NGINX Plus is deployed closer to the application and is able to manage all traffic specific to each application type.

<img src="/nginx/images/nginx-plus-behind-hardware-adc.png" alt="In one architecture for modernizing application delivery infrastructure, hardware ADCs on the edge of the network pass application traffic to NGINX Plus for load balancing" style="border:2px solid #666666; padding:2px; margin:2px;" />
_NGINX Plus can run behind hardware ADCs to handle application traffic_

Other companies are completely replacing their stationary hardware ADC appliances at the network edge with NGINX Plus, providing the same level of application delivery at the edge of the network.

<img src="/nginx/images/nginx-plus-without-hardware-adc.png" alt="In the most flexible architecture for modern application delivery, NGINX Plus completely replaces hardware application delivery controllers" style="border:2px solid #666666; padding:2px; margin:2px;" />
_NGINX Plus can completely replace hardware ADCs to handle all traffic entering the network_

<span id="prereqs"></span>
## Prerequisites

This guide assumes you are familiar with F5 <span style="white-space: nowrap;">BIG-IP LTM</span> concepts and CLI configuration commands. Familiarity with basic NGINX software concepts and directives is also helpful; links to documentation are provided, but the guide does not explain NGINX Plus functioning in depth.

<span id="mapping"></span><span id="networking"></span>
## Mapping F5 BIG-IP LTM Networking Concepts to NGINX Plus

- [Network Architecture](#mapping-network)
- [Definitions of Networking Concepts](#mapping-concepts)


<span id="mapping-network"></span>
### Network Architecture

When migrating F5 <span style="white-space: nowrap;">BIG-IP LTM</span> networking and load‑balancer configuration to NGINX Plus, it can be tempting to try translating F5 concepts and commands directly into NGINX Plus syntax. But the result is often frustration, because in several areas the two products don't align very closely in how they conceive of and handle network and application traffic. It's important to understand the differences and keep them in mind as you do your migration.

F5 divides the network into two parts: the management network (often referred to as the _management plane_ or _control plane_) and the _application traffic network_ (the _data plane_). In a traditional architecture, the management network is isolated from the traffic network and accessible via a separate internal network, while the application network is attached to a public network (or another application network). This requires separate network configurations for each of the two kinds of traffic.

<span style="white-space: nowrap;">BIG-IP LTM</span> appliances are a dual‑proxy environment, which means that data plane traffic is also split between two different networks: the client‑side network over which client requests come into the <span style="white-space: nowrap;">BIG-IP LTM</span>, and the server‑side network over which requests are sent to the application servers. <span style="white-space: nowrap;">BIG-IP LTM</span> typically requires two network interface cards (NICs) to handle each part of the network.

It is possible with a <span style="white-space: nowrap;">BIG-IP LTM</span> appliance, however, to combine the client and server networks on a single NIC, combining the data plane into a single‑stack proxy architecture. This is a very typical architecture in a cloud environment where traffic comes into the <span style="white-space: nowrap;">BIG-IP LTM</span> data plane and exits through the same virtual NIC. Regardless of networking architecture, the same basic principles for load balancing apply, and the configurations discussed below work in either architectural layout.

NGINX Plus can function in a similar architecture either by binding multiple IP subnets (and/or VLANs) to a single NIC that is available to the host device, or by installing multiple NICs and using each for unique client and server networks, or multiple client networks and multiple server‑side networks. This is, in essence, how the <span style="white-space: nowrap;">BIG-IP LTM</span> appliance functions as well, typically shipping with multiple NICs which can be trunked or bound into virtual NICs.

<span id="mapping-concepts"></span>
### Definitions of Networking Concepts

Basic F5 <span style="white-space: nowrap;">BIG-IP LTM</span> networking configuration requires only that you specify the IP addresses of the management and data planes, but managing more complex network environments that include <span style="white-space: nowrap;">BIG-IP LTM</span> appliances involves some additional concepts. All of these concepts can be very easily simplified and mapped to NGINX Plus instances. Key <span style="white-space: nowrap;">BIG-IP LTM</span> networking concepts with NGINX Plus correlates include:

- **Self‑IP address** – The primary interface that listens to incoming client‑side data plane traffic on a specific VLAN. It is a specific IP address or subnet on a specific NIC associated with that VLAN or a VLAN group.

    In NGINX Plus, self‑IP addresses most directly map to the primary host interface used by NGINX Plus to manage traffic‑plane application data. Generally speaking, self IP addresses are not a necessary concept in an NGINX Plus deployment, as NGINX Plus utilizes the underlying OS networking for management and data‑traffic control.

- **Management IP address:port pairs** – The IP address:port combinations on a <span style="white-space: nowrap;">BIG-IP LTM</span> appliance that are used to administer it, via the GUI and/or remote SSH access. The NGINX Plus equivalent is the Linux host IP address, typically the primary host interface. It is possible, but not necessary, to use separate IP addresses and/or NICs for management access to the Linux host where NGINX Plus is running, if you need to separate remote access from the application traffic.

- **Virtual server** – The IP address:port combination used by <span style="white-space: nowrap;">BIG-IP LTM</span> as the public destination IP address for the load‑balanced applications. This is the IP‑address portion of the virtual server that is associated with the domain name of a frontend application (for instance), and the port that's associated with the service (such as port 80 for HTTP applications). This address handles client requests and shifts from the primary device to the secondary device in the case of a failover.

    Virtual servers in NGINX Plus are configured using a [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block. The [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive in the `server` block specifies the IP address and port for client traffic.

- **Pool** and **node list** – A _pool_ is a collection of backend nodes, each hosting the same application or service, across which incoming connections are load balanced. Pools are assigned to virtual servers so <span style="white-space: nowrap;">BIG-IP LTM</span> knows which backend applications to use when a new request comes into a virtual server. In addition, <span style="white-space: nowrap;">BIG-IP LTM</span> uses the term _node list_ to refer to an array of distinct services that all use the same traffic protocol and are hosted on the same IP address, but listen on different port numbers (for example, three HTTP services at 192.168.10.10:8100, 192.169.10.10:8200, and 192.168.10.10:8300).

    NGINX Plus flattens the <span style="white-space: nowrap;">BIG-IP LTM</span> pool and node list concepts by representing that information in [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream) configuration blocks, which also define the load‑balancing and session‑persistence method for the virtual server that forwards traffic to the group of backend servers. NGINX Plus does not need the concept of node lists, because standard `upstream` block configuration very easily accommodates multiple services on the same IP address.

In addition to these networking concepts, there are two other important technology categories to consider when migrating from <span style="white-space: nowrap;">BIG-IP LTM</span> to NGINX Plus:

- **iRules** – iRules is a proprietary, event‑driven, content‑switching and traffic‑manipulation engine (based on TCL) used by <span style="white-space: nowrap;">BIG-IP LTM</span> to control all aspects of data‑plane traffic. iRules are attached to virtual servers and are required for any type of content switching, such as choosing a pool based on URI, inserting headers, establishing affinity with JSESSIONIDs, and so on. iRules are event‑driven and are configured to fire for each new connection when certain criteria are met, such as when a new HTTP request is made to a virtual server or when a server sends a response to a client.

    NGINX Plus natively handles content switching and HTTP session manipulation, eliminating the need to explicitly migrate most context‑based iRules and those which deal with HTTP transactions such as header manipulation. Most context‑based iRules can be translated to `server` and `location` blocks, and more complex iRules that cannot be duplicated with NGINX Plus directives and configuration block can be implemented with the [Lua]({{< ref "nginx/admin-guide/dynamic-modules/lua.md" >}}) or [JavaScript]({{< ref "nginx/admin-guide/dynamic-modules/nginscript.md" >}}) modules. For more information on translating iRules to NGINX Plus content rules, see [Migrating Layer 7 Logic from F5 iRules and Citrix Policies to NGINX and NGINX Plus](https://www.nginx.com/blog/migrating-layer7-logic-f5-irules-citrix-policies-nginx-plus/) on the NGINX blog.

- **High availability** – Conceptually, <span style="white-space: nowrap;">BIG-IP LTM</span> and NGINX Plus handle high availability (HA) in the same way: each active‑passive pair of load balancers shares a floating "virtual" IP address (VIP) which maps to the currently active instance. If the active instance fails, the passive instance takes over and assumes the VIP.

  <span style="white-space: nowrap;">BIG-IP LTM</span> uses a built‑in HA mechanism to handle the failover.

  For [on‑premises deployments]({{< ref "nginx/admin-guide/high-availability/ha-keepalived.md" >}}), NGINX Plus uses a separate software package called <span style="white-space: nowrap; font-weight:bold;">**nginx-ha-keepalived**</span> to handle the VIP and the failover process for an active‑passive pair of NGINX Plus servers. The package implements the VRRP protocol to handle the VIP. Limited [active‑active]({{< ref "nginx/admin-guide/high-availability/ha-keepalived-nodes.md" >}}) scenarios are also possible with the <span style="white-space: nowrap; font-weight:bold;">nginx-ha-keepalived</span> package.

  Solutions for high availability of NGINX Plus in cloud environments are also available, including these:

  - [Active‑Active HA for NGINX Plus on AWS Using AWS Network Load Balancer]({{< ref "nginx/deployment-guides/amazon-web-services/high-availability-network-load-balancer.md" >}})
  - [Active‑Passive HA for NGINX Plus on AWS Using Elastic IP Addresses]({{< ref "nginx/deployment-guides/amazon-web-services/high-availability-keepalived.md" >}})
  - [All‑Active HA for NGINX Plus on the Google Cloud Platform]({{< ref "nginx/deployment-guides/google-cloud-platform/high-availability-all-active.md" >}})

<span id="converting"></span><span id="convert-configuration"></span>
## Converting F5 BIG-IP LTM Load-Balancer Configuration to NGINX Plus

- [Virtual Servers](#virtual-servers)
- [SSL/TLS Offload (Termination and Proxy)](#ssl-offload)
- [Session Persistence](#session-persistence)
- [Keepalive Connections](#keepalive-connections)
- [Monitors (Health Checks)](#health-checks)

F5 <span style="white-space: nowrap;">BIG-IP LTM</span> offers three methods for configuration:

- GUI
- CLI (the custom on‑box Traffic Management Shell [TMSH] tool)
- iControl API

Ultimately all changes made via the GUI or API are translated to a TMSH CLI command, so that's the representation we're using in this guide. We assume that you are configuring the device from the `(tmos.ltm`) location, and so omit the common command variable `ltm` from all of the TMSH commands.

With NGINX Plus, configuration is stored in a straightforward text file which can be accessed directly or managed using traditional on‑box tools or configuration management and orchestration tools such as [Ansible](https://www.nginx.com/blog/announcing-unified-ansible-role-nginx-nginx-plus/), [Chef](https://www.nginx.com/blog/installing-nginx-nginx-plus-chef/), and [Puppet](https://www.nginx.com/blog/installing-nginx-nginx-plus-puppet/).

Although the examples in this guide use only IP addresses to identify virtual servers, with NGINX Plus both the listening IP address:port combination and the `Host` header can be used to select the appropriate `server` block to process a request. Include the [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) directive in that block to specify the values to match in the `Host` header.

The list of parameters to the `server_name` directive can include multiple hostnames, wildcards, and regular expressions. You can include multiple `server_name` directives and multiple listening IP address‑port combinations within one NGINX Plus `server` block. For more information on using `Host` and the `server_name` directive instead of IP addresses, see [Server names](https://nginx.org/en/docs/http/server_names.html) at **nginx.org**.

**Note:** All IP addresses and names of objects (`upstream` blocks, virtual servers, pools, and so on) in this guide are examples only. Substitute the values from your <span style="white-space: nowrap;">BIG-IP LTM</span> configuration.

<span id="virtual-servers"></span>
### Virtual Servers

As mentioned above, virtual servers are the primary listeners for both <span style="white-space: nowrap;">BIG-IP LTM</span> and NGINX Plus, but the configuration syntax for defining them is quite different. Here, a virtual server at 192.168.10.10 listens on port 80 for HTTP traffic, and distributes incoming traffic between the two backend application servers listed in the **test_pool** upstream group.

#### BIG-IP LTM

```none
# create pool test_pool members add { 10.10.10.10:80 10.10.10.20:80 }
# create virtual test_virtual { destination 192.168.10.10:80 pool test_pool source-address-translation { type automap } ip-protocol tcp profiles add { http } }
# save sys config
```

#### NGINX Plus

```nginx
http {
    upstream test_pool {
        server 10.10.10.10:80;
        server 10.10.10.20:80;
    }

    server {
        listen 192.168.10.10:80;
        location / {
            proxy_pass http://test_pool;
        }
        #...
     }
 }
```

Directive documentation: [`listen`](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen), [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [`proxy_pass`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass), [`virtual server`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [`upstream server`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [`upstream`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

<span id="ssl-offload"></span><span id="ssl"></span>
### SSL/TLS Offload (Termination and Proxy)

Handling SSL/TLS termination is a common use case for ADC load balancers. F5 <span style="white-space: nowrap;">BIG-IP LTM</span> uses a proprietary SSL/TLS implementation. NGINX Plus relies on system libraries, so the version of OpenSSL is dictated by the OS. On <span style="white-space: nowrap;">BIG-IP LTM</span>, a profile for each SSL/TLS  key and certificate pair is attached to a virtual server (either as a client profile for encrypting traffic to and from the client, a server profile for encrypting backend traffic, or both). On NGINX Plus, the `ssl_certificate` and `ssl_certificate_key` directives are included in the `server` block for the virtual server.

There are two methods for handling SSL/TLS traffic on a load balancer instance,  termination and proxying:

- With SSL/TLS termination, the load balancer and client communicate in an encrypted HTTPS session, in the same way a secure application like a banking website handles client encryption with SSL/TLS certificates. After decrypting the client message (effectively terminating the secure connection), the load balancer forwards the message to the upstream server over a cleartext (unencrypted) HTTP connection. In the other direction, the load balancer encrypts the server response before sending it to the client. SSL/TLS termination is a good option if the load balancer and upstream servers are on a secured network where there's no danger of outside agents intercepting and reading the cleartext backend traffic, and where upstream application performance is paramount.

- In the SSL/TLS proxy architecture, the load balancer still decrypts client‑side traffic as it does in the termination model, but then it re‑encrypts it before forwarding it to upstream servers. This is a good option where the server‑side network is not secure or where the upstream servers can handle the computational workload required for SSL/TLS encryption and decryption.

#### BIG-IP LTM

- SSL/TLS Termination and Proxy: Creating SSL/TLS Virtual Server and Pool Members

   ```none
   # create pool ssl_test_pool members add { 10.10.10.10:443 10.10.10.20:443 }
   # create virtual test_ssl_virtual { destination 192.168.10.10:443 pool ssl_test_pool source-address-translation { type automap } ip-protocol tcp profiles add { http } }
   # save /sys config
   ```

- SSL/TLS Termination: Creating a Client SSL/TLS Profile

   ```none
   # create profile client-ssl test_ssl_client_profile cert test.crt key test.key
   # modify virtual test_ssl_virtual profiles add { test_ssl_client_profile }
   # save /sys config
   ```

- SSL/TLS Proxy: Creating a Server SSL/TLS Profile

   ```none
   # create profile server-ssl test_ssl_server_profile cert test.crt key test.key
   # modify virtual test_ssl_virtual profiles add { test_ssl_server_profile }
   # save /sys config
   ```

#### NGINX Plus

- SSL/TLS Termination

   ```nginx
   upstream ssl_test_pool {
        server 10.10.10.10:443;
        server 10.10.10.20:443;
   }

   server {
        listen 192.168.10.10:443 ssl;
        ssl_certificate     /etc/nginx/ssl/test.crt;
        ssl_certificate_key /etc/nginx/ssl/test.key;

        location / {
            proxy_pass http://ssl_test_pool;
        }
   }
   ```

- SSL/TLS Proxy

   ```nginx
   upstream ssl_test_pool {
        server 10.10.10.10:443;
   }

   server {
        listen 192.168.10.10:443 ssl;
        ssl_certificate     /etc/nginx/ssl/test.crt;
        ssl_certificate_key /etc/nginx/ssl/test.key;

        location / {
            proxy_pass https://ssl_test_pool;
            proxy_ssl_certificate /etc/nginx/ssl/client.pem;
            proxy_ssl_certificate_key /etc/nginx/ssl/client.key;
            proxy_ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
            proxy_ssl_ciphers HIGH:!aNULL:!MD5;
            proxy_ssl_trusted_certificate /etc/nginx/ssl/trusted_ca_cert.crt;
            proxy_ssl_verify on;
            proxy_ssl_verify_depth 2;
        }
   }
   ```

   Directive documentation: [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen), [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass), [proxy_ssl*](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_certificate), [server virtual](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [server upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [ssl_certificate and ssl_certificate_key](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

<span id="session-persistence"></span>
### Session Persistence

F5 <span style="white-space: nowrap;">BIG-IP LTM</span> and NGINX Plus handle session persistence (also referred to as _affinity_) in a similar way and configure it at the same level: on the upstream server (<span style="white-space: nowrap;">BIG-IP LTM</span> pool or NGINX Plus `upstream` block). Both support multiple forms of persistence. Session persistence is critical for applications that are not stateless and is helpful for continuous delivery use cases.

#### Cookie-Based Session Persistence

One method that is simple to configure and handles failover well for NGINX Plus, if compatible with the application, is [_sticky cookie_](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky). It works just like the _cookie insert_ method in <span style="white-space: nowrap;">BIG-IP LTM</span>: the load balancer creates a cookie that represents the server and the client then includes the cookie in each request, effectively offloading the session tracking from the load balancer itself.

- BIG-IP LTM: HTTP Cookie Persistence

   ```none
   # create persistence cookie test_bigip_cookie cookie-name BIGIP_COOKIE_PERSIST expiration 1:0:0
  # modify virtual test_virtual { persist replace-all-with { test_bigip_cookie } }
  # save /sys config
  ```

- BIG-IP LTM: HTTPS Cookie Persistence

   ```none
   # create persistence cookie test_bigip_cookie cookie-name BIGIP_COOKIE_PERSIST expiration 1:0:0
   # modify virtual test_ssl_virtual { persist replace-all-with { test_bigip_cookie } }
   # save /sys config
   ```

- NGINX Plus: HTTP Cookie Persistence

   ```nginx
   upstream test_pool {
        server 10.10.10.10:80;
        server 10.10.10.20:80;
        sticky cookie mysession expires=1h;
   }
   ```

- NGINX Plus: HTTPS Cookie Persistence

   ```nginx
   upstream ssl_test_pool {
        server 10.10.10.10:443;
        server 10.10.10.20:443;
        sticky cookie mysession expires=1h;
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [`sticky cookie`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

#### Source IP Address-Based Session Persistence

Another form of session persistence is based on the source IP address recorded in the request packet (the IP address of the client making the request). For each request the load balancer calculates a hash on the IP address, and sends the request to the backend server that is associated with that hash. Because the hash for a given IP address is always the same, all requests with the hash go to the same server. (For more details on the NGINX Plus implementation, see [Choosing an NGINX Plus Load Balancing Technique](https://www.nginx.com/blog/choosing-nginx-plus-load-balancing-techniques/#ip-hash) on our blog).

- BIG-IP LTM

   ```none
   # modify virtual test_virtual { persist replace-all-with {source_addr} }
   # save /sys config
   ```

- NGINX Plus

   ```nginx
   upstream test_pool {
        ip_hash;
        server 10.10.10.10:80;
        server 10.10.10.20:80;
   }
   ```

   Directive documentation: [ip_hash](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#ip_hash), [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

#### Token-Based Session Persistence

Another method for session persistence takes advantage of a cookie or other token created within the session by the backend server, such as a `jsessionid`. To manage `jsessionid` creation and tracking, NGINX Plus creates a table in memory matching the cookie value with a specific backend server.

- BIG-IP LTM

   <span style="white-space: nowrap;">BIG-IP LTM</span> does not natively support a learned (or universal) persistence profile without creating a more advanced iRule, which is out of scope for this document.

- NGINX Plus

   ```nginx
   upstream test_pool {
        server 10.10.10.10:80;
        server 10.10.10.20:80;
        sticky learn create=$upstream_cookie_jsessionid
                     lookup=$cookie_jsessionid
                     zone=client_sessions:1m;
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [`sticky learn`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

<span id="keepalive-connections"></span>
### Keepalive Connections

Typically, a separate HTTP session is created and destroyed for every connection. This can be fine for short‑lived connections, like requesting a small amount of content from a web server, but it can be highly inefficient for long‑lived connections. Constantly creating and destroying sessions and connections can create high load for both the application server and client, slowing down page load and hurting the overall perception of the website or application's performance. HTTP keepalive connections, which instruct the load balancer to keep connections open for a session, are a necessary performance feature for web pages to load more quickly.

#### BIG-IP LTM

```none
# modify virtual test_virtual profiles add { oneconnect }
# modify virtual test_ssl_virtual profiles add { oneconnect }
# save /sys config
```

#### NGINX Plus

```nginx
upstream test_pool {
    server 10.10.10.10:80;
    server 10.10.10.20:80;
    keepalive 32;
}
```

Directive documentation: [keepalive](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive), [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

<span id="health-checks"></span>
### Monitors (Health Checks)

F5 <span style="white-space: nowrap;">BIG-IP LTM</span> uses the term _monitor_ to refer to the process of verifying that a server is functioning correctly, while NGINX Plus uses [_health check_](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/). In an <span style="white-space: nowrap;">BIG-IP LTM</span> configuration, the monitor is associated directly with a pool and applied to each node in the pool, whereas NGINX Plus places the health check in a `location` block.

The `interval` argument to the following <span style="white-space: nowrap;">BIG-IP LTM</span> `create` command configures <span style="white-space: nowrap;">BIG-IP LTM</span> to check the server every 5 seconds, which corresponds to the default frequency for NGINX Plus. NGINX Plus does not need the <span style="white-space: nowrap;">BIG-IP LTM</span> `timeout` parameter as it implements the timeout function with the `interval` and `fails` parameters.


**Note:** This <span style="white-space: nowrap;">BIG-IP LTM</span> configuration is for HTTP. For HTTPS, substitute `test_ssl_monitor` for `test_monitor` in both the `create` and `modify` commands. The same NGINX Plus configuration works for both HTTP and HTTPS.


#### BIG-IP LTM

```none
# create monitor http test_monitor defaults-from http send "GET /index.html HTTP/1.0\r\n\r\n" interval 5 timeout 20
# modify pool test_pool monitor test_monitor
# save /sys config
```

#### NGINX Plus

```nginx
upstream test_pool {
    # ...
    zone test_pool_zone 64k;
}

server {
   # ...
   location / {
       proxy_pass http://test_pool;
       health_check interval=5 fails=2;
    }
}
```

Directive documentation: [health_check](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check), [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass), [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream), [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

<span id="summary"></span><span id="configuration-summary"></span>
## Summary of Converted Load Balancer Configuration


Here we put together the configuration entities, combining everything required to build a basic F5 <span style="white-space: nowrap;">BIG-IP LTM</span> basic environment and detail how to migrate the same configuration to NGINX Plus.

### BIG-IP LTM

```none
 # create pool test_pool members add { 10.10.10.10:80 10.10.10.20:80 }
 # create virtual test_virtual { destination 192.168.10.10:80 pool test_pool source-address-translation { type automap } ip-protocol tcp profiles add { http } }
 # create pool ssl_test_pool members add { 10.10.10.10:443 10.10.10.20:443 }
 # create virtual test_ssl_virtual { destination 192.168.10.10:443 pool ssl_test_pool source-address-translation { type automap } ip-protocol tcp profiles add { http } }
 # create profile client-ssl test_ssl_client_profile cert test.crt key test.key
 # modify virtual test_ssl_virtual profiles add { test_ssl_client_profile }
 # create profile server-ssl test_ssl_server_profile cert test.crt key test.key
 # modify virtual test_ssl_virtual profiles add { test_ssl_server_profile }
 # create persistence cookie test_bigip_cookie cookie-name BIGIP_COOKIE_PERSIST expiration 1:0:0
 # modify virtual test_virtual { persist replace-all-with { test_bigip_cookie } }
 # modify virtual test_ssl_virtual { persist replace-all-with { test_bigip_cookie } }
 # modify virtual test_virtual profiles add { oneconnect }
 # modify virtual test_ssl_virtual profiles add { oneconnect }
 # create monitor http test_monitor defaults-from http send "GET /index.html HTTP/1.0\r\n\r\n" interval 5 timeout 20
 # modify pool test_pool monitor test_monitor
 # create monitor https test_ssl_monitor defaults-from https send "GET /index.html HTTP/1.0\r\n\r\n" interval 5 timeout 20
 # modify pool ssl_test_pool monitor test_ssl_monitor
 # save /sys config

```

### NGINX Plus

The following configuration includes three additional directives which weren't discussed previously. Adding them is a best practice when proxying traffic:

- The [proxy_set_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) `Host $host` directive ensures the `Host` header received from the client is sent with the request to the backend server.
- The [proxy_http_version](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_http_version) directive sets the HTTP version to 1.1 for the connection to the backend server.
- The `proxy_set_header Connection ""` directive clears the `Connection` header sent by the client, enabling NGINX Plus to keep encrypted keepalive connections open to the upstream servers.

We are also enabling [live activity monitoring](https://www.nginx.com/products/nginx/live-activity-monitoring) in the final `server` block. Live activity monitoring is implemented in the <span style="white-space: nowrap;">[NGINX Plus API](https://nginx.org/en/docs/http/ngx_http_api_module.html)</span> module and is exclusive to NGINX Plus. The wide range of statistics reported by the API is displayed on the built‑in dashboard and can also be exported to any application performance management (APM) or monitoring tool that can consume JSON‑formatted messages. For more detail on logging and monitoring see the [NGINX Plus Admin Guide]({{< ref "/nginx/admin-guide/monitoring/_index.md" >}}).

```nginx
upstream test_pool {
    zone test_pool_zone 64k;
    server 10.10.10.10:80;
    server 10.10.10.20:80;
    sticky cookie mysession expires=1h;
    keepalive 32;
}

upstream ssl_test_pool {
    zone ssl_test_pool_zone 64k;
    server 10.10.10.10:443;
    server 10.10.10.20:443;
    sticky cookie mysession expires=1h;
    keepalive 32;
}

server {
    listen 192.168.10.10:80 default_server;
    proxy_set_header Host $host;

    location / {
         proxy_pass http://test_pool;
         health_check;
         proxy_http_version 1.1;
    }

    location ~ /favicon.ico {
        root /usr/share/nginx/images;
    }
}

server {
    listen 192.168.10.10:443 ssl default_server;
    ssl_certificate     test.crt;
    ssl_certificate_key test.key;
    proxy_set_header    Host $host;

    location / {
        proxy_pass https://ssl_test_pool;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        health_check;
    }

    location ~ /favicon.ico {
        root /usr/share/nginx/images;
    }
}

server {
    listen 8080;
    status_zone status-page;
    root /usr/share/nginx/html;

    location /api {
        api write=on;
        # directives controlling access, such as 'allow' and 'deny'
    }

    location = /dashboard.html {
        root /usr/share/nginx/html;
    }

    # Redirect requests made to the old (pre-R14) dashboard
    location = /status.html {
        return 301 /dashboard.html;
    }

    location ~ /favicon.ico {
        root /usr/share/nginx/images;
    }
}
```

### Revision History

- Version 2 (April 2018) – Updated information about high availability and the NGINX Plus API (NGINX Plus R13, NGINX Open Source 1.13.4)
- Version 1 (February 2017) – Initial version (NGINX Plus R11, NGINX Open Source 1.11.5)
