---
description: Load balance Wildfly (JBoss) application servers with NGINX Open Source
  or the advanced features in F5 NGINX Plus, following our step-by-step setup instructions.
docs: DOCS-456
title: Load Balancing Wildfly and JBoss Application Servers with NGINX Open Source
  and NGINX Plus
toc: true
weight: 100
type:
- how-to
---

This deployment guide explains how to use NGINX Open Source and F5 NGINX Plus to load balance HTTP and HTTPS traffic across a pool of Wildfly (JBoss) application servers. It provides complete instructions for configuring NGINX Open Source or NGINX Plus as required.


<span id="about-nginx"></span>
## About NGINX Open Source and NGINX Plus

[NGINX Open Source](https://nginx.org/en) is an open source web server and reverse proxy that has grown in popularity in recent years because of its scalability, outstanding performance, and small footprint. NGINX Open Source was first created to solve the C10K problem (serving 10,000 simultaneous connections on a single web server). <span style="white-space: nowrap;">NGINX Open Source's</span> features and performance have made it a staple of high‑performance sites – it's [the #1 web server at the 100,000 busiest websites in the world](https://w3techs.com/technologies/cross/web_server/ranking).

[NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) is the commercially supported version of NGINX Open Source. NGINX Plus is a complete application delivery platform, extending the power of NGINX Open Source with a host of enterprise-ready capabilities that enhance a JBoss application server deployment and are instrumental to building web applications at scale:

- [Full‑featured HTTP, TCP, and UDP load balancing](https://www.nginx.com/products/nginx/load-balancing/)
- [Intelligent session persistence](https://www.nginx.com/products/nginx/load-balancing/#session-persistence)
- [High‑performance reverse proxy]({{< ref "nginx/admin-guide/web-server/reverse-proxy.md" >}})
- [Caching and offload of dynamic and static content]({{< ref "nginx/admin-guide/content-cache/content-caching.md" >}})
- [Adaptive streaming to deliver audio and video to any device](https://www.nginx.com/products/nginx/streaming-media/)
- [Application-aware health checks](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/) and [high availability](https://docs.nginx.com/nginx/admin-guide/high-availability/)
- [Advanced activity monitoring available via a dashboard or API](https://www.nginx.com/products/nginx/live-activity-monitoring/)
- [Management and real‑time configuration changes with DevOps‑friendly tools](https://www.nginx.com/products/nginx/load-balancing/#load-balancing-api)

<span id="about-jboss"></span>
## About Wildfly and JBoss

[Wildfly](https://www.wildfly.org/) is an application server that before 2013 was called the _JBoss Application Server_ or simply _JBoss_. It implements the Java Enterprise Edition 7 Platform (Java EE, formerly known as J2EE) for developing and deploying enterprise Java applications, portals, and web applications and services. Java EE allows the use of standardized modular components and enables the Java platform to handle many aspects of programming automatically. As free and open source software, WildFly is distributed under the GNU Lesser General Public License (LGPL), version 2.1. This guide was developed and tested with Wildfly 9.

The commercially supported version of the Wildfly software is the [Red Hat JBoss Enterprise Application Platform](https://developers.redhat.com/products/eap/overview), and this guide applies to it and other commercial JBoss application servers as well.

<span id="prereqs"></span>
## Prerequisites and System Requirements

- A Wildfly or JBoss application server installed and configured on a physical or virtual system.
- A Linux system to host NGINX Open Source or NGINX Plus. To avoid potential conflicts with other applications, we recommend you install NGINX Plus on a fresh physical or virtual system. For the list of Linux distributions supported by NGINX Plus, see [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}}).
- <span style="white-space: nowrap;">NGINX Open Source 1.9.5</span> or later, or <span style="white-space: nowrap;">NGINX Plus R7</span> or later.

The instructions assume you have basic Linux system administration skills, including the following. Full instructions are not provided for these tasks.

- Configuring and deploying a Wildfly application
- Installing Linux software from vendor‑supplied packages
- Editing configuration files
- Copying files between a central administrative system and Linux servers
- Running basic commands to start and stop services
- Reading log files

### About Sample Values and Copying of Text

- `example.com` is used as a sample organization name (in key names and configuration blocks). Replace it with your organization's name.
- Many NGINX Open Source and NGINX Plus configuration blocks in this guide list two sample Wildfly application servers with IP addresses 192.168.33.11 and 192.168.33.12. Replace these addresses with the IP addresses of your Wildfly servers. Include a line in the configuration block for each server if you have more or fewer than two.
- For readability reasons, some commands appear on multiple lines. If you want to copy and paste them into a terminal window, we recommend that you first copy them into a text editor, where you can substitute the object names that are appropriate for your deployment and remove any extraneous formatting characters that your browser might insert.
- We recommend that you do not copy text from the configuration snippets in this guide into your configuration files. For the recommended way to create configuration files, see [Creating and Modifying Configuration Files](#config-files).

<span id="tls-certificate"></span>
## Configuring an SSL/TLS Certificate for Client Traffic

If you plan to enable SSL/TLS encryption of traffic between NGINX Open Source or NGINX Plus and clients of your Wildfly application, you need to configure a server certificate for NGINX Open Source or NGINX Plus.

- SSL/TLS support is enabled by default in all <span style="white-space: nowrap;">[NGINX Plus packages](https://cs.nginx.com/)</span> and [NGINX Open Source binaries](https://nginx.org/en/linux_packages.html) provided by NGINX.
- If you are compiling NGINX Open Source from source, include the <span style="white-space: nowrap;">`--with-http_ssl_module`</span> parameter to enable SSL/TLS support for HTTP traffic (the corresponding parameter for TCP is <span style="white-space: nowrap;">`--with-stream_ssl_module`</span>, and for email is <span style="white-space: nowrap;">`--with-mail_ssl_module`</span>, but this guide does not cover either of those protocol types).
- If using binaries from another provider, consult the provider documentation to determine if it supports SSL/TLS.

There are several ways to obtain a server certificate, including the following. For your convenience, <span style="white-space: nowrap;">step-by-step</span> instructions are provided for the second and third options.

- If you already have an SSL/TLS certificate for NGINX Open Source or NGINX Plus installed on another UNIX or Linux system (including systems running Apache HTTP Server), copy it to the **/etc/nginx/ssl** directory on the NGINX Open Source or NGINX Plus server.
- Generate a self‑signed certificate as described in [Generating a Self‑Signed Certificate](#certificate-self-signed) below. This is sufficient for testing scenarios, but clients of production deployments generally require a certificate signed by a certificate authority (CA).
- Request a new certificate from a CA or your organization's security group, as described in [Generating a Certificate Request](#certificate-request) below.

For more details on SSL/TLS termination, see the <span style="white-space: nowrap;">[NGINX Plus Admin Guide]({{< relref "../../admin-guide/security-controls/terminating-ssl-http.md" >}})</span>.

<span id="certificate-self-signed"></span>
### Generating a Self-Signed Certificate

Generate a public‑private key pair and a self‑signed server certificate in PEM format that is based on them.

1. Log in as the root user on a machine that has the `openssl` software installed.

2. Generate the key pair in PEM format (the default). To encrypt the private key, include the <span style="white-space: nowrap;">`-des3`</span> parameter. (Other encryption algorithms are available, listed on the man page for the [genrsa](https://www.openssl.org/docs/manmaster/man1/openssl-genrsa.html) command.) You are prompted for the passphrase used as the basis for encryption.

   ```shell
   root# openssl genrsa -des3 -out ~/private-key.pem 2048
   Generating RSA private key
   Enter pass phrase for private-key.pem:
   ```

3. Create a backup of the key file in a secure location. If you lose the key, the certificate becomes unusable.

   ```shell
   root# cp ~/private-key.pem <SECURE-DIR>/private-key.pem.backup
   ```

4. Generate the certificate. Include the <span style="white-space: nowrap;">`-new`</span> and <span style="white-space: nowrap;">`-x509`</span> parameters to make a new self‑signed certificate. Optionally include the <span style="white-space: nowrap;">`-days`</span> parameter to change the key's validity lifetime from the default of 30 days (10950 days is about 30 years). Respond to the prompts with values appropriate for your testing deployment.

   ```shell
   root# openssl req -new -x509 -key ~/private-key.pem -out ~/self-cert.pem -days 10950
   ```

5. Copy or move the certificate file and associated key files to the **/etc/nginx/ssl** directory on the NGINX Open Source or NGINX Plus server.

<span id="certificate-request"></span>
### Generating a Certificate Request

1. Log in as the root user on a machine that has the `openssl` software installed.

2. Create a private key to be packaged in the certificate.

   ```shell
   root# openssl genrsa -out ~/example.com.key 2048
   ```

3. Create a backup of the key file in a secure location. If you lose the key, the certificate becomes unusable.

   ```shell
   root# cp ~/example.com.key secure-dir/example.com.key.backup
   ```

4. Create a Certificate Signing Request (CSR) file.

   ```shell
   root# openssl req -new -sha256 -key ~/example.com.key -out ~/example.com.csr
   ```

5. Request a certificate from a CA or your internal security group, providing the CSR file (**example.com.csr**). As a reminder, never share private keys (**.key** files) directly with third parties.

   The certificate needs to be PEM format rather than in the Windows-compatible PFX format. If you request the certificate from a CA website yourself, choose NGINX or Apache (if available) when asked to select the server platform for which to generate the certificate.

6. Copy or move the certificate file and associated key files to the **/etc/nginx/ssl** directory on the NGINX Plus server.

<span id="config-files"></span>
## Creating and Modifying Configuration Files

To reduce errors, this guide has you copy directives from files provided by NGINX into your configuration files, instead of using a text editor to type in the directives yourself. Then you go through the sections in this guide (starting with [Configuring Virtual Servers for HTTP and HTTPS Traffic](#virtual-servers)) to learn how to modify the directives as required for your deployment.

As provided, there is one file for basic load balancing (with NGINX Open Source or NGINX Plus) and one file for enhanced load balancing (with NGINX Plus). If you are installing and configuring NGINX Open Source or NGINX Plus on a fresh Linux system and using it only to load balance Wildfly traffic, you can use the provided file as your main configuration file, which by convention is called **/etc/nginx/nginx.conf**.

We recommend, however, that instead of a single configuration file you use the scheme that is set up automatically when you install an NGINX Plus package, especially if you already have an existing NGINX Open Source or NGINX Plus deployment or plan to expand your use of NGINX Open Source or NGINX Plus to other purposes in future. In the conventional scheme, the main configuration file is still called **/etc/nginx/nginx.conf**, but instead of including all directives in it, you create separate configuration files for different HTTP‑related functions and store the files in the **/etc/nginx/conf.d** directory. You then use the `include` directive in the `http` context of the main file to read in the contents of the function-specific files.

To download the complete configuration file for basic load balancing:

```none
root# cd /etc/nginx/conf.d
root# curl https://www.nginx.com/resource/conf/jboss-basic.conf > jboss-basic.conf
```

To download the complete configuration file for enhanced load balancing:

```none
root# cd /etc/nginx/conf.d
root# curl https://www.nginx.com/resource/conf/jboss-enhanced.conf > jboss-enhanced.conf
```

(You can also access the URL in a browser and download the file that way.)

To set up the conventional configuration scheme, add an `http` configuration block in the main **nginx.conf** file, if it does not already exist. (The standard placement is below any global directives.) Add this `include` directive with the appropriate filename:

```nginx
http {
    include conf.d/jboss-(basic|enhanced).conf;
}
```

Directive documentation: [include](https://nginx.org/en/docs/ngx_core_module.html#include)

You can also use wildcard notation to reference all files that pertain to a certain function or traffic type in the appropriate context block. For example, if you name all HTTP configuration files <span style="white-space: nowrap; font-weight:bold;">_function_-http.conf</span>, this is an appropriate include directive:

```nginx
http {
    include conf.d/*-http.conf;
}
```

For reference purposes, the text of the full configuration files is included in this document:

- [Full Configuration for Basic Load Balancing](#full-configuration-basic)
- [Full Configuration for Enhanced Load Balancing](#full-configuration-enhanced)

We recommend, however, that you do not copy text directly from this document. It does not necessarily use the same mechanisms for positioning text (such as line breaks and white space) as text editors do. In text copied into an editor, lines might run together and indenting of child statements in configuration blocks might be missing or inconsistent. The absence of formatting does not present a problem for NGINX Open Source or NGINX Plus, because (like many compilers) they ignore white space during parsing, relying solely on semicolons and curly braces as delimiters. The absence of white space does, however, make it more difficult for humans to interpret the configuration and modify it without making mistakes.

### About Reloading Updated Configuration

We recommend that each time you complete a set of updates to the configuration, you run the <span style="white-space: nowrap;">`nginx -t`</span> command to test the configuration file for syntactic validity.

```none
root# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

To tell NGINX Open Source or NGINX Plus to start using the new configuration, run one of the following commands:

```none
root# nginx -s reload
```

or

```none
root# service nginx reload
```

<span id="basic"></span>
## Configuring Basic Load Balancing with NGINX Open Source or NGINX Plus

This section explains how to set up NGINX Open Source or NGINX Plus as a load balancer in front of two Wildfly servers. The instructions in the first two sections are mandatory:

- [Configuring Virtual Servers for HTTP and HTTPS Traffic](#virtual-servers)
- [Configuring Basic Load Balancing](#load-balancing-basic)

The instructions in the remaining sections are optional, depending on the requirements of your application:

- [Configuring Basic Session Persistence](#session-persistence-basic)
- [Configuring Proxy of WebSocket Traffic](#websocket)
- [Configuring Content Caching](#caching)
- [Configuring HTTP/2 Support](#http2)

The complete configuration file appears in [Full Configuration for Basic Load Balancing](#full-configuration-basic).

If you are using NGINX Plus, you can configure additional enhanced features after you complete the configuration of basic load balancing. See [Configuring Enhanced Load Balancing with NGINX Plus](#enhanced).

<span id="virtual-servers"></span>
### Configuring Virtual Servers for HTTP and HTTPS Traffic

These directives define virtual servers for HTTP and HTTPS traffic in separate `server` blocks in the top-level `http` configuration block. All HTTP requests are redirected to the HTTPS server.

1. Configure a `server` block that listens for requests for **"https://example.com"** received on port 443.

   The `ssl_certificate` and `ssl_certificate_key` directives are required; substitute the names of the certificate and private key you chose in [Configuring an SSL/TLS Certificate for Client Traffic](#tls-certificate).

   The other directives are optional but recommended.

   ```nginx
   # In the 'http' block
   server {
       listen 443 ssl;
       server_name example.com;

       ssl_certificate     /etc/nginx/ssl/example.com.crt;
       ssl_certificate_key /etc/nginx/ssl/example.com.key;
       ssl_session_cache   shared:SSL:1m;
       ssl_prefer_server_ciphers on;
   }
   ```

   Directive documentation: [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen), [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name), [ssl_certificate](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate), [ssl_certificate_key](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate_key), [ssl_prefer_server_ciphers](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_prefer_server_ciphers), [ssl_session_cache](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_cache)

2. Configure a `server` block that permanently redirects requests for **"http://example.com"** that are received on port 80 to the HTTPS server, which is defined in the previous step.

   If you're not using SSL/TLS for client connections, omit the `return` directive. When instructed in the remainder of this guide to add directives to the `server` block for HTTPS traffic, add them to this block instead.

   ```nginx
   # In the 'http' block
   server {
       listen 80;
       server_name example.com;

       # Redirect all HTTP requests to HTTPS
       location / {
           return 301 https://$server_name$request_uri;
       }
   }
   ```

   Directive documentation: [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [return](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return)

For more information on configuring SSL/TLS, see the <span style="white-space: nowrap;">[NGINX Plus Admin Guide]({{< relref "../../admin-guide/security-controls/terminating-ssl-http.md" >}})</span> and the reference documentation for the HTTP [SSL/TLS](https://nginx.org/en/docs/http/ngx_http_ssl_module.html) module.

<span id="load-balancing-basic"></span>
### Configuring Basic Load Balancing

To configure load balancing, you first create a named _upstream group_, which lists the backend servers among which client requests are distributed. You then set up NGINX Open Source or NGINX Plus as a reverse proxy and load balancer by referring to the upstream group in one or more `proxy_pass` directives.

1. Configure an upstream group called **jboss** with two Wildfly application servers listening on port 8080, one on IP address 192.168.33.11 and the other on 192.168.33.12.

   ```nginx
   # In the 'http' block
   upstream jboss {
       server 192.168.33.11:8080;
       server 192.168.33.12:8080;
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

2. In the `server` block for HTTPS traffic that we created in [Configuring Virtual Servers for HTTP and HTTPS Traffic](#virtual-servers), include these two [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) blocks:

   - The first one matches HTTPS requests in which the path starts with **/webapp/**, and proxies them to the **jboss** upstream group we created in the previous step.
   - The second one funnels all traffic to the first `location` block, by doing a temporary redirect of all requests for **"http://example.com/"**.

   ```nginx
   # In the 'server' block for HTTPS traffic
   location /webapp/ {
       proxy_pass http://jboss;
   }

   location = / {
       return 302 /webapp/;
   }
   ```

   Directive documentation: [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass), [return](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return)

   Note that these blocks handle only standard HTTPS traffic. If you want to load balance WebSocket traffic, you need to add another `location` block as described in [Configuring Proxy of WebSocket Traffic](#websocket).

By default, NGINX Open Source and NGINX Plus use the Round Robin algorithm for load balancing among servers. The load balancer runs through the list of servers in the upstream group in order, forwarding each new request to the next server. In our example, the first request goes to 192.168.33.11, the second to 192.168.33.12, the third to 192.168.33.11, and so on. For information about the other available load‑balancing algorithms, see the <a href="../../../admin-guide/load-balancer/http-load-balancer/#method">NGINX Plus Admin Guide</a>.

In NGINX Plus, you can also set up dynamic reconfiguration of an upstream group when the set of backend servers changes, using DNS or an API; see [Enabling Dynamic Reconfiguration of Upstream Groups](#reconfiguration).

For more information on proxying and load balancing, see <span style="white-space: nowrap;">[NGINX Reverse Proxy]({{< ref "nginx/admin-guide/web-server/reverse-proxy.md" >}})</span> and <span style="white-space: nowrap;">[HTTP Load Balancing]({{< relref "../../admin-guide/load-balancer/http-load-balancer.md" >}})</span> in the NGINX Plus Admin Guide, and the reference documentation for the HTTP [Proxy](https://nginx.org/en/docs/http/ngx_http_proxy_module.html) and [Upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html) modules.

<span id="session-persistence-basic"></span>
### Configuring Basic Session Persistence

If your application requires basic session persistence (also known as _sticky sessions_), you can implement it in NGINX Open Source with the IP Hash load‑balancing algorithm. (NGINX Plus offers a more sophisticated form of session persistence, as described in [Configuring Advanced Session Persistence](#session-persistence-advanced).)

With the IP Hash algorithm, for each request a hash based on the client's IP address is calculated and associated with one of the upstream servers. All requests with that hash are sent to that server, thus establishing session persistence.

If the client has an IPv6 address, the hash is based on the entire address. If it has an IPv4 address, the hash is based on just the first three octets of the address. This is designed to optimize for ISP clients that are assigned IP addresses dynamically from a subnetwork (/24) range. However, it is not effective in these cases:

- The majority of the traffic to your site is coming from one forward proxy or from clients on the same /24 network, because in that case IP Hash maps all clients to the same server.
- A client's IP address can change during the session, for example when a mobile client switches from a WiFi network to a cellular one.

To configure session persistence in NGINX, add the `ip_hash` directive to the `upstream` block created in [Configuring Basic Load Balancing](#load-balancing-basic):

```nginx
# In the 'http' block
upstream jboss {
    ip_hash;
    server 192.168.33.11:8080;
    server 192.168.33.12:8080;
}
```

Directive documentation: [ip_hash](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#ip_hash)

You can also use the Hash load‑balancing method for session persistence, with the hash based on any combination of text and [NGINX variables](https://nginx.org/en/docs/varindex.html) you specify. For example, you can hash on full (four‑octet) client IP addresses with the following configuration.

```nginx
# In the 'http' block
upstream jboss {
    hash $remote_addr;
    server 192.168.33.11:8080;
    server 192.168.33.12:8080;
}
```

Directive documentation: [hash](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#hash)

<span id="websocket"></span>
### Configuring Proxy of WebSocket Traffic

The WebSocket protocol (defined in [RFC 6455](https://tools.ietf.org/html/rfc6455)) enables simultaneous two‑way communication over a single TCP connection between clients and servers, where each side can send data independently from the other. To initiate the WebSocket connection, the client sends a handshake request to the server, upgrading the request from standard HTTP to WebSocket. The connection is established if the handshake request passes validation, and the server accepts the request. When a WebSocket connection is created, a browser client can send data to a server while simultaneously receiving data from that server.

The WebSocket protocol works out of the box on Wildfly app servers, so no additional Wildfly configuration is required. If you want NGINX Open Source or NGINX Plus to proxy WebSocket traffic to your Wildfly application servers, add the directives discussed in this section.

NGINX Open Source and NGINX Plus by default use HTTP/1.0 for upstream connections. To be proxied correctly, WebSocket connections require HTTP/1.1 along with some other configuration directives that set HTTP headers:

```nginx
# In the 'http' block
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

# In the 'server' block for HTTPS traffic
location /wstunnel/ {
    proxy_pass http://jboss;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
}
```

Directive documentation: [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [map](https://nginx.org/en/docs/http/ngx_http_map_module.html#map), [proxy_http_version](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_http_version), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass), [proxy_set_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header)

The first `proxy_set_header` directive is needed because the `Upgrade` request header is <span style="white-space: nowrap;">hop-by-hop</span>; that is, the HTTP specification explicitly forbids proxies from forwarding it. This directive overrides the prohibition.

The second `proxy_set_header` directive sets the `Connection` header to a value that depends on the test in the `map` block: if the request has an `Upgrade` header, the `Connection` header is set to `upgrade`; otherwise, it is set to `close`.

For more information about proxying WebSocket traffic, see [WebSocket proxying](https://nginx.org/en/docs/http/websocket.html) and <span style="white-space: nowrap;">[NGINX as a WebSocket Proxy](https://www.nginx.com/blog/websocket-nginx/)</span>.

<span id="caching"></span>
### Configuring Content Caching

Caching responses from your Wildfly app servers can both improve response time to clients and reduce load on the servers, because eligible responses are served immediately from the cache instead of being generated again on the server. There are a variety of useful directives that can be used to fine‑tune caching behavior; for a detailed discussion, see [A Guide to Caching with NGINX](https://www.nginx.com/blog/nginx-caching-guide/).

One choice for caching is [Infinispan](https://infinispan.org/), an open source, distributed cache and key‑value NoSQL data store developed by Red Hat. Java application servers (including Wildfly and JBoss) can embed it as a library or use it as a service, and any non‑Java applications can use it as remote service through TCP/IP.

Another alternative is to cache server responses on the NGINX Open Source host by creating this configuration:

1. Include the `proxy_cache_path` directive to create the local disk directory **/tmp/NGINX_cache/** for use as a cache. The `keys_zone` parameter allocates 10 megabytes (MB) of shared memory for a zone called **backcache**, which is used to store cache keys and metadata such as usage timers. A 1‑MB zone can store data for about 8,000 keys.

   ```nginx
   # In the 'http' block
   proxy_cache_path /tmp/NGINX_cache/ keys_zone=backcache:10m;
   ```

   Directive documentation: [proxy_cache_path](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path)

2. In the `location` block that matches HTTPS requests in which the path starts with **/webapp/**, include the `proxy_cache` directive to reference the cache created in the previous step.

   ```nginx
   # In the 'server' block for HTTPS traffic
   location /webapp/ {
       proxy_pass http://jboss;
       proxy_cache backcache;
   }
   ```

   Directive documentation: [proxy_cache](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)

For more complete information on caching, see the [NGINX Plus Admin Guide]({{< ref "nginx/admin-guide/content-cache/content-caching.md" >}}) and the reference documentation for the HTTP [Proxy](https://nginx.org/en/docs/http/ngx_http_proxy_module.html) module.

<span id="http2"></span>
### Configuring HTTP/2 Support

HTTP/2 is fully supported in both <span style="white-space: nowrap;">NGINX Open Source 1.9.5</span> or later and later, and <span style="white-space: nowrap;">NGINX Plus R7</span> and later. As always, we recommend you run the latest version of software to take advantage of improvements and bug fixes.

- If using NGINX Open Source, note that in version 1.9.5 and later the SPDY module is completely removed from the codebase and replaced with the [HTTP/2](https://nginx.org/en/docs/http/ngx_http_v2_module.html) module. After upgrading to version 1.9.5 or later, you can no longer configure NGINX Open Source to use SPDY. If you want to keep using SPDY, you need to compile NGINX Open Source from the sources in the [NGINX 1.8.x branch](https://nginx.org/en/download.html).

- In <span style="white-space: nowrap;">NGINX Plus R8</span> and later, NGINX Plus supports HTTP/2 by default. (Support for SPDY is deprecated as of that release). Specifically:

  In [NGINX Plus R11]({{< ref "/nginx/releases.md#r11" >}}) and later, the **nginx-plus** package continues to support HTTP/2 by default, but the **nginx-plus-extras** package available in previous releases is deprecated and replaced by [dynamic modules]({{< ref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}).

  For <span style="white-space: nowrap;">NGINX Plus R8</span> through R10, the <span style="white-space: nowrap; font-weight:bold;">nginx-plus</span> and <span style="white-space: nowrap; font-weight:bold;">nginx-plus-extras</span> packages support HTTP/2 by default.

  If using <span style="white-space: nowrap;">NGINX Plus R7</span>, you must install the <span style="white-space: nowrap; font-weight:bold;">nginx-plus-http2</span> package instead of the <span style="white-space: nowrap; font-weight:bold;">nginx-plus</span> or <span style="white-space: nowrap; font-weight:bold;">nginx-plus-extras</span> package.

To enable HTTP/2 support, add the `http2` directive in the `server` block for HTTPS traffic that we created in [Configuring Virtual Servers for HTTP and HTTPS Traffic](#virtual-servers), so that it looks like this:

```nginx
# In the 'server' block for HTTPS traffic
listen 443 ssl;
http2  on;
```

Directive documentation: [http2](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2)

To verify that HTTP/2 translation is working, you can use the "HTTP/2 and SPDY indicator" plug‑in available for [Google Chrome](https://chrome.google.com/webstore/detail/http2-and-spdy-indicator/mpbpobfflnpcgagjijhmgnchggcjblin?hl=en) and [Firefox](https://addons.mozilla.org/en-US/firefox/addon/http2-indicator/).

<span id="full-configuration-basic"></span>
### Full Configuration for Basic Load Balancing

The full configuration for basic load balancing appears here for your convenience. It goes in the `http` context. The complete file is available for [download](https://www.nginx.com/resource/conf/jboss-basic.conf) from the NGINX website.

We recommend that you do not copy text directly from this document, but instead use the method described in [Creating and Modifying Configuration Files](#config-files) to include these directives in your configuration – add an `include` directive to the `http` context of the main **nginx.conf** file to read in the contents of <span style="white-space: nowrap; font-weight: bold;">/etc/nginx/conf.d/jboss-basic.conf</span>.

```nginx
proxy_cache_path /tmp/NGINX_cache/ keys_zone=backcache:10m;

map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

upstream jboss {
    # Use IP Hash for session persistence
    ip_hash;

    # List of Wildfly application servers
    server 192.168.33.11:8080;
    server 192.168.33.12:8080;
}

server {
    listen 80;
    server_name example.com;

    # Redirect all HTTP requests to HTTPS
    location / {
        return 301 https://$server_name$request_uri;
    }
}

server {
    listen 443 ssl;
    http2  on;

    server_name example.com;

    ssl_certificate     /etc/nginx/ssl/<certificate-name>;
    ssl_certificate_key /etc/nginx/ssl/<private-key>;
    ssl_session_cache   shared:SSL:1m;
    ssl_prefer_server_ciphers on;

    # Load balance requests for '/webapp/' across Wildfly application servers
    location /webapp/ {
        proxy_pass http://jboss;
        proxy_cache backcache;
    }

    # Return a temporary redirect to '/webapp/' when user requests '/'
    location = / {
        return 302 /webapp/;
    }

    # WebSocket configuration
    location /wstunnel/ {
        proxy_pass https://jboss;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }
}

```

<span id="enhanced"></span>
## Configuring Enhanced Load Balancing with NGINX Plus

This section explains how to configure enhanced load balancing with some of the extended features in NGINX Plus.

**Note:** Before setting up the enhanced features described in this section, you must complete the instructions for basic load balancing in these two sections:

- [Configuring Virtual Servers for HTTP and HTTPS Traffic](#virtual-servers)
- [Configuring Basic Load Balancing](#load-balancing-basic)

Except as noted, all optional basic features (described in the other subsections of [Configuring Basic Load Balancing in NGINX Open Source and NGINX Plus](#basic)) can be combined with the enhanced features described here.

The features described in the following sections are all optional.

- [Configuring Advanced Session Persistence](#session-persistence-advanced)
- [Configuring Application Health Checks](#health-checks)
- [Enabling Live Activity Monitoring](#live-activity-monitoring)
- [Enabling Dynamic Reconfiguration of Upstream Groups](#reconfiguration)

The complete configuration file appears in [Full Configuration for Enhanced Load Balancing](#full-configuration-enhanced).

<span id="session-persistence-advanced"></span>
### Configuring Advanced Session Persistence

NGINX Plus has more sophisticated session persistence methods available than NGINX Open Source, implemented in three variants of the `sticky` directive. In the following example, we add the `sticky learn` directive to the upstream group we created in [Configuring Basic Load Balancing](#load-balancing-basic).

1. Remove or comment out the `ip_hash` directive, leaving only the `server` directives:

   ```nginx
   # In the 'http' block
   upstream jboss {
       #ip_hash;
       server 192.168.33.11:8080;
       server 192.168.33.12:8080;
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

2. Configure session persistence that uses the `sticky learn` directive to refer to the `JSESSIONID` cookie created by your Wildfly application as the session identifier.

   - The `create` and `lookup` parameters to `sticky learn` specify how new sessions are created and existing sessions are searched for, respectively. For new sessions, NGINX Plus sets the session identifier to the value of the `$upstream_cookie_JSESSIONID` variable, which captures the `JSESSIONID` cookie sent by the Wildfly application server. When checking for existing sessions, it uses the `JSESSIONID` cookie sent by the client (the `$cookie_JSESSIONID` variable) as the session identifier.

     Both parameters can be specified more than once (each time with a different variable), in which case NGINX Plus uses the first non-empty variable for each one.

   - The `zone` argument creates a shared memory zone for storing information about sessions. The amount of memory allocated – here, 1 MB – determines how many sessions can be stored at a time (the number varies by platform). The name assigned to the zone – here, `client_sessions` – must be unique for each `sticky` directive.

   ```nginx
   # In the 'http' block
   upstream jboss {
       server 192.168.33.11:8080;
       server 192.168.33.12:8080;
       sticky learn create=$upstream_cookie_JSESSIONID lookup=$cookie_JSESSIONID
                    zone=client_sessions:1m;
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [`sticky learn`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

For more information on session persistence, see the <a href="../../../admin-guide/load-balancer/http-load-balancer/#sticky">NGINX Plus Admin Guide</a>.

<span id="health-checks"></span>
### Configuring Application Health Checks

Health checks are out‑of‑band HTTP requests sent to a server at fixed intervals. They are used to determine whether a server is responsive and functioning correctly, without requiring an actual request from a client.

Because the `health_check` directive is placed in the `location` block, we can enable different health checks for each application.

1. In the `location` block that matches HTTPS requests in which the path starts with **/webapp/** (created in [Configuring Basic Load Balancing](#load-balancing-basic)), add the `health_check` directive.

   Here we configure NGINX Plus to send an out‑of‑band request for the top‑level URI **/** (slash) to each of the servers in the **jboss** upstream group every 5 seconds (the default URI and frequency). If a server does not respond correctly, it is marked down and NGINX Plus stops sending requests to it until it passes a subsequent health check. We include the `match` parameter so we can define a nondefault set of health‑check tests (we define them in the next step).

   ```nginx
   # In the 'server' block for HTTPS traffic
   location /webapp/ {
       proxy_pass http://jboss;
       proxy_cache backcache;
       health_check match=jboss_check;
   }
   ```

   Directive documentation: [health_check](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check), [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [proxy_cache](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)

2. In the `http` context, include a `match` directive to define the tests that a server must pass to be considered functional. In this example, it must return status code `200`, the <span style="white-space: nowrap;">`Content-Type`</span> response header must be `text/html`, and the response body must match the indicated regular expression.

   ```nginx
   # In the 'http' block
   match jboss_check {
       status 200;
       header Content-Type = text/html;
       body ~ "Your WildFly 9 is running";
   }
   ```

   Directive documentation: [match](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#match)

3. In the **jboss** upstream group, include the `zone` directive to define a shared memory zone that stores the group's configuration and run-time state, which are shared among worker processes.

   ```nginx
   # In the 'http' block
   upstream jboss {
       zone jboss 64k;
       server 192.168.33.11:8080;
       server 192.168.33.12:8080;
       # ...
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream), [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

NGINX Plus also has a slow‑start feature that is a useful auxiliary to health checks. When a failed server recovers, or a new server is added to the upstream group, NGINX Plus slowly ramps up the traffic to it over a defined period of time. This gives the server time to "warm up" without being overwhelmed by more connections than it can handle as it starts up. For more information, see the <a href="../../../admin-guide/load-balancer/http-load-balancer/#slow_start">NGINX Plus Admin Guide</a>.

For example, to set a slow‑start period of 30 seconds for your Wildfly application servers, include the `slow_start` parameter to their `server` directives:

```nginx
# In the 'upstream' block
server 192.168.33.11:8080 slow_start=30s;
server 192.168.33.12:8080 slow_start=30s;
```

Parameter documentation: [slow_start](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#slow_start)

For information about customizing health checks, see the [NGINX Plus Admin Guide]({{< ref "nginx/admin-guide/load-balancer/http-health-check.md" >}}).

<span id="live-activity-monitoring"></span>
### Enabling Live Activity Monitoring

NGINX Plus includes a live activity monitoring interface that provides key load and performance metrics in real time, including TCP metrics in <span style="white-space: nowrap;">NGINX Plus R6</span> and later. Statistics are reported through a RESTful JSON interface, making it very easy to feed the data to a custom or third‑party monitoring tool. There is also a built‑in dashboard. Follow these instructions to deploy it.

<img src="/nginx/images/nginx-plus-dashboard-r19-overview.png" alt="Dashboard tab in NGINX Plus live activity monitoring dashboard" style="border:2px solid #666666; padding:2px; margin:2px;" />

For more information about live activity monitoring, see the <span style="white-space: nowrap;">[NGINX Plus Admin Guide]({{< ref "nginx/admin-guide/monitoring/live-activity-monitoring.md" >}}).</span>

The quickest way to configure the module and the built‑in NGINX Plus dashboard is to download the sample configuration file from the NGINX website and modify it as necessary. For more complete instructions, see [Live Activity Monitoring of NGINX Plus in 3 Simple Steps](https://www.nginx.com/blog/live-activity-monitoring-nginx-plus-3-simple-steps/).

1. Download the **status.conf** file to the NGINX Plus server:

   ```none
   # cd /etc/nginx/conf.d
   # curl https://www.nginx.com/resource/conf/status.conf > status.conf
   ```

2. Include the file in the `http` context in the main configuration file (**/etc/nginx/nginx.conf**):

   ```nginx
   # In the 'http' block in nginx.conf
   include conf.d/status.conf;
   ```

   Directive documentation: [include](https://nginx.org/en/docs/ngx_core_module.html#include)

3. Customize the file for your deployment as specified by comments in the file. In particular, the default settings in the file allow anyone on any network to access the dashboard. We strongly recommend that you restrict access to the NGINX Plus API with one or more of the following methods:

   - **IP address‑based access control lists (ACLs)**. In the sample configuration file, uncomment the `allow` and `deny` directives, and substitute the address of your administrative network for 10.0.0.0/8. Only users on the specified network can access the status page.

     ```nginx
     allow 10.0.0.0/8;
     deny all;
     ```

     Directive documentation: [allow and deny](https://nginx.org/en/docs/http/ngx_http_access_module.html)

   - **HTTP Basic authentication**. In the sample configuration file, uncomment the `auth_basic` and `auth_basic_user_file` directives and add user entries to the **/etc/nginx/users** file (for example, by using an [htpasswd generator](https://httpd.apache.org/docs/2.4/programs/htpasswd.html). If you have an Apache installation, another option is to reuse an existing **htpasswd** file.

     ```nginx
     auth_basic on;
     auth_basic_user_file /etc/nginx/users;
     ```

     Directive documentation: [auth_basic](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html#auth_basic), [auth_basic_user_file](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html#auth_basic_user_file)

   - **Client certificates**, which are part of a complete configuration of SSL/TLS. For more information, see the <span style="white-space: nowrap;">[NGINX Plus Admin Guide]({{< relref "../../admin-guide/security-controls/terminating-ssl-http.md" >}})</span> and the reference documentation for the HTTP [SSL/TLS](https://nginx.org/en/docs/http/ngx_http_ssl_module.html) module.

   - **Firewall**. Configure your firewall to disallow outside access to the port for the dashboard (8080 in the sample configuration file).

3. In each upstream group that you want to monitor, include the `zone` directive to define a shared memory zone that stores the group's configuration and run-time state, which are shared among worker processes.

   For example, to monitor your Wildfly application servers, add the `zone` directive to the **jboss** upstream group (if configured [application health checks](#health-checks), you already made this change).

   ```nginx
   # In the 'http' block
   upstream jboss {
       zone jboss 64k;
       server 192.168.33.11:8080;
       server 192.168.33.12:8080;
       # ...
   }
   ```

   Directive documentation: [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

4. In the `server` block for HTTPS traffic (created in [Configuring Virtual Servers for HTTP and HTTPS Traffic](#virtual-servers)), add the `status_zone` directive:

   ```nginx
   # In the 'server' block for HTTPS traffic
   status_zone jboss;
   ```

   Directive documentation: [status_zone](https://nginx.org/en/docs/http/ngx_http_status_module.html#status_zone)

When you reload the NGINX Plus configuration file, for example by running the <span style="white-space: nowrap;">`nginx -s reload`</span> command, the NGINX Plus dashboard is available immediately at <span style="white-space: nowrap; font-weight: bold;">http://_nginx-plus-server-address_:8080</span>.

<span id="reconfiguration"></span>
### Enabling Dynamic Reconfiguration of Upstream Groups

With NGINX Plus, you can reconfigure load‑balanced server groups (both HTTP and TCP/UDP) dynamically using either the Domain Name System (DNS) or the NGINX Plus API introduced in <span style="white-space: nowrap;">NGINX Plus R13</span>. See the NGINX Plus Admin Guide for a more detailed discussion of the <a href="../../../admin-guide/load-balancer/http-load-balancer/#dns">DNS</a> and [API]({{< ref "nginx/admin-guide/load-balancer/dynamic-configuration-api.md" >}}) methods.

#### Configuring the API Method

To enable dynamic reconfiguration of your upstream group of Wildfly app servers using the NGINX Plus API, you need to grant secured access to it. You can use the API to add or remove servers, dynamically alter their weights, and set their status as `primary`, `backup`, or `down`.

1. Include the `zone` directive in the **jboss** upstream group to create a shared memory zone for storing the group's configuration and run‑time state, which makes the information available to all worker processes. (If you configured [application health checks](#health-checks) or [live activity monitoring](#live-activity-monitoring), you already made this change.)

   ```nginx
   # In the 'http' block
   upstream jboss {
       zone jboss 64k;
       server 192.168.33.11:8080;
       server 192.168.33.12:8080;
       # ...
   }
   ```

   Directive documentation: [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

2. In the `server` block for HTTPS traffic (created in [Configuring Virtual Servers for HTTP and HTTPS Traffic](#virtual-servers)), add a new `location` block for the NGINX Plus API, which enables dynamic reconfiguration among other features. It contains the `api` directive (**api** is also the conventional name for the location, as used here).

   (If you configured [live activity monitoring](#live-activity-monitoring) by downloading the **status.conf** file, it already includes this block.)

   We strongly recommend that you restrict access to the location so that only authorized administrators can access the NGINX Plus API. The [allow and deny](https://nginx.org/en/docs/http/ngx_http_access_module.html) directives in the following example permit access only from the localhost address (127.0.0.1).

   ```nginx
   # In the 'server' block for HTTPS traffic
   location /api {
       api write=on;
       allow 127.0.0.1;
       deny all;
   }
   ```

   Directive documentation: [allow and deny](https://nginx.org/en/docs/http/ngx_http_access_module.html), [api](https://nginx.org/en/docs/http/ngx_http_api_module.html#api)

#### Configuring the DNS Method

In the `http` block, add the `resolver` directive pointing to your DNS server. In the **jboss** `upstream` block add the `resolve` parameter to the `server` directive, which instructs NGINX Plus to periodically re‑resolve the domain name (here, **example.com** here) with DNS.

Also include the `zone` directive in the `upstream` block to create a shared memory zone for storing the upstream group's configuration and run‑time state, which makes the information available to all worker processes. (If you configured [application health checks](#health-checks) or [live activity monitoring](#live-activity-monitoring), you already made this change.)

```nginx
# In the 'http' block
resolver <IP-address-of-DNS-server>;

upstream jboss {
    zone jboss 64k;
    server example.com resolve;
}
```

Directive and parameter documentation: [resolve](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#resolve), [resolver](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver), [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

[NGINX Plus Release 9](https://www.nginx.com/blog/nginx-plus-r9-released/#dns-srv) and later can also use the additional information in DNS `SRV` records, such as the port number. Include the `service` parameter to the `server` directive, along with the `resolve` parameter:

```nginx
# In the 'http' block
resolver <IP-address-of-DNS-server>;

upstream jboss {
    zone jboss 64k;
    server example.com service=http resolve;
}
```

Parameter documentation: [service](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#service)

<span id="full-configuration-enhanced"></span>
### Full Configuration for Enhanced Load Balancing

The full configuration for enhanced load balancing appears here for your convenience. It goes in the `http` context. The complete file is available for [download](https://www.nginx.com/resource/conf/jboss-enhanced.conf) from the NGINX website.

We recommend that you do not copy text directly from this document, but instead use the method described in [Creating and Modifying Configuration Files](#config-files) to include these directives in your configuration – add an `include` directive to the `http` context of the main **nginx.conf** file to read in the contents of <span style="white-space: nowrap;">/etc/nginx/conf.d/jboss-enhanced.conf</span>.

**Note:** The `api` block in this configuration summary and the [downloadable](https://www.nginx.com/resource/conf/jboss-enhanced.conf) <span style="white-space: nowrap; font-weight:bold;">jboss-enhanced.conf</span> file is for the [API method](#reconfiguration-api) of dynamic reconfiguration. If you want to use the [DNS method](#reconfiguration-dns) instead, make the appropriate changes to the block. (You can also remove or comment out the directives for the NGINX Plus API in that case, but they do not conflict with using the DNS method and enable features other than dynamic reconfiguration.)

```nginx
proxy_cache_path /tmp/NGINX_cache/ keys_zone=backcache:10m;

# WebSocket configuration
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

# Application health checks
match jboss_check {
    status 200;
    header Content-Type = text/html;
    body ~ "Your WildFly 9 is running";

}

upstream jboss {
    # Shared memory zone for application health checks, live activity
    # monitoring, and dynamic reconfiguration
    zone jboss 64k;

    # List of Wildfly application servers
    server 192.168.33.11:8080 slow_start=30s;
    server 192.168.33.12:8080 slow_start=30s;

    # Session persistence based on JSESSIONID
    sticky learn create=$upstream_cookie_JSESSIONID
                 lookup=$cookie_JSESSIONID
                 zone=client_sessions:1m;
}

server {
    listen 80;
    server_name example.com;

    # Redirect all HTTP requests to HTTPS
    location / {
        return 301 https://$server_name$request_uri;
    }
}

server {
    listen 443 ssl;
    http2  on;

    server_name example.com;

    # Required for live activity monitoring of HTTPS traffic
    status_zone jboss;
    ssl_certificate            /etc/nginx/ssl/<certificate-name>;
    ssl_certificate_key        /etc/nginx/ssl/<private-key>;
    ssl_session_cache          shared:SSL:1m;
    ssl_prefer_server_ciphers  on;

    # Load balance requests for '/webapp/' across Wildfly application servers
    location /webapp/ {
        proxy_pass http://jboss;
        proxy_cache backcache;

        # Active health checks
        health_check match=jboss_check;
    }

    # Return a 302 redirect to '/webapp/' when user requests '/'
    location = / {
        return 302 /webapp/;
    }

    # WebSocket configuration
    location /wstunnel/ {
        proxy_pass http://jboss;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }

    # Secured access to the NGINX Plus API
    location /api {
        api write=on;
        allow 127.0.0.1; # Permit access from localhost
        deny all;        # Deny access from everywhere else
    }
}

```

<span id="resources"></span>
## Resources

- [NGINX Plus Overview](https://www.nginx.com/products/nginx)
- [NGINX Plus Admin Guide]({{< ref "/nginx/admin-guide/_index.md" >}})
- [NGINX Wiki](https://www.nginx.com/resources/wiki/)

### Revision History

- Version 6 (May 2024) – Update about HTTP/2 support (the [http2](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2) directive)
- Version 5 (April 2018) – Update naming to Wildfly, and information about metrics gathering with the NGINX Plus API
- Version 4 (December 2017) – Add instructions for DNS method of dynamic reconfiguration (NGINX Plus R14)
- Version 3 (April 2017) – Update about HTTP/2 support (NGINX Plus R11)
- Version 2 (January 2016) – Update about HTTP/2 support (NGINX Plus R8, NGINX Open Source 1.9.9)
- Version 1 (December 2015) – Initial version (NGINX Plus R7, NGINX Open Source 1.9.5)
