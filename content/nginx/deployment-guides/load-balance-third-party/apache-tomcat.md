---
description: Load balance Apache Tomcat application servers with NGINX Open Source
  or the advanced features in F5 NGINX Plus, following our step-by-step setup instructions.
nd-docs: DOCS-451
title: Load Balancing Apache Tomcat Servers with NGINX Open Source and NGINX Plus
toc: true
weight: 100
type:
- how-to
---

This deployment guide explains how to use NGINX Open Source and F5 NGINX Plus to load balance HTTP and HTTPS traffic across a pool of Apache Tomcat<sup>TM</sup> application servers. The detailed instructions in this guide apply to both cloud‑based and on‑premises deployments of Tomcat.


<span id="about-nginx"></span>
## About NGINX Open Source and NGINX Plus

[NGINX Open Source](https://nginx.org/en) is an open source web server and reverse proxy that is known for its scalability, outstanding performance, and small footprint. <span style="white-space: nowrap;">NGINX Open Source</span> was first created to solve the C10K problem (serving 10,000 simultaneous connections on a single web server). <span style="white-space: nowrap;">NGINX Open Source's</span> features and high-speed performance has made it a staple, NGINX is used by 33.8% of all the websites whose server we know – it's [the #1 web server at the 100,000 busiest websites in the world](https://w3techs.com/technologies/cross/web_server/ranking).

[NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) is the commercially supported version of <span style="white-space: nowrap;">NGINX Open Source</span>. NGINX Plus is a complete application delivery platform, that extends the power of <span style="white-space: nowrap;">NGINX Open Source</span> with a host of enterprise‑ready capabilities, improving Tomcat deployments and supporting the development of web applications at scale:

- [Full‑featured HTTP, TCP, and UDP load balancing](https://www.nginx.com/products/nginx/load-balancing/)
- [Intelligent session persistence](https://www.nginx.com/products/nginx/load-balancing/#session-persistence)
- [High‑performance reverse proxy]({{< ref "nginx/admin-guide/web-server/reverse-proxy.md" >}})
- [Caching and offload of dynamic and static content]({{< ref "nginx/admin-guide/content-cache/content-caching.md" >}})
- [Adaptive streaming to deliver audio and video to any device](https://www.nginx.com/products/nginx/streaming-media/)
- [Application-aware health checks](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/) and [high availability](https://docs.nginx.com/nginx/admin-guide/high-availability/)
- [Advanced activity monitoring available via a dashboard or API](https://www.nginx.com/products/nginx/live-activity-monitoring/)
- [Management and real‑time configuration changes with DevOps‑friendly tools](https://www.nginx.com/products/nginx/load-balancing/#load-balancing-api)

<span id="about-tomcat"></span>
## About Apache Tomcat

Apache Tomcat is an open source software implementation of the Java Servlet, JavaServer Pages, Java Expression Language, and Java WebSocket technologies.

Apache Tomcat 8.0 was used to prepare the documentation for this guide.

<span id="prereqs"></span>
## Prerequisites and System Requirements

- A Tomcat application server installed and configured on a physical or virtual system.
- A Linux system to host <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus. To avoid potential conflicts with other applications, we recommend you install the software on a fresh physical or virtual system. For the list of operating systems supported by NGINX Plus, see [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}}).
- <span style="white-space: nowrap;">NGINX Open Source 1.9.5</span> and later, and <span style="white-space: nowrap;">NGINX Plus R7</span> and later.

The instructions assume you have basic Linux system administration skills, including the following. Full instructions are not provided for these tasks.

- Configuring and deploying a Tomcat application
- Installing Linux software from vendor‑supplied packages
- Editing configuration files
- Copying files between a central administrative system and Linux servers
- Running basic commands to start and stop services
- Reading log files


<span id="sample-values"></span>
### About Sample Values and Copying of Text

- `example.com` is used as a sample domain name (in key names and configuration blocks). Replace it with your organization's name.
- Many <span style="white-space: nowrap;">NGINX Open Source</span> and NGINX Plus configuration blocks in this guide list two sample Tomcat application servers with IP addresses 10.100.100.11 and 10.100.100.12. Replace these addresses with the IP addresses of your Tomcat servers. Include a line in the configuration block for each server if you have more or fewer than two.
- For better readability, some commands are split across multiple lines.Recommendation: When copying commands, first place the text in a text-editor that way it makes it easier to subsititute the object names with those that are relevent to your project, make sure to also remove any extra special characters that may be added by your browser.
- Some of the examples in this guide are partial and require additional directives or parameters to be complete. You can download complete configuration files for basic and enhanced load balancing from the NGINX website, as instructed in [Creating and Modifying Configuration Files](#config-files). For details about a specific directive or parameter, see the [NGINX reference documentation](https://nginx.org/en/docs/).
- We recommend that you do not copy text from the configuration snippets in this guide into your configuration files. For the recommended way to create configuration files, see [Creating and Modifying Configuration Files](#config-files).

<span id="tls-certificate"></span>
## Configuring an SSL/TLS Certificate for Client Traffic

If you plan to enable SSL/TLS encryption of traffic between <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus and clients of your Tomcat application, you will need to configure a server certificate for <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus.

- SSL/TLS support is enabled by default in all <span style="white-space: nowrap;">[NGINX Plus packages](https://cs.nginx.com/)</span> and [<span style="white-space: nowrap;">NGINX Open Source</span> binaries](https://nginx.org/en/linux_packages.html) provided by NGINX.
- If you are compiling <span style="white-space: nowrap;">NGINX Open Source</span> from source, include the <span style="white-space: nowrap;">`--with-http_ssl_module`</span> parameter to enable SSL/TLS support for HTTP traffic (the corresponding parameter for TCP is <span style="white-space: nowrap;">`--with-stream_ssl_module`</span>, and for email is <span style="white-space: nowrap;">`--with-mail_ssl_module`</span>, but this guide does not cover either of those protocol types).
- If using binaries from other providers, consult the provider documentation to determine if they support SSL/TLS.

There are several ways to obtain a server certificate, including the following. For your convenience, <span style="white-space: nowrap;">step-by-step</span> instructions are provided for the second and third options.

- If you already have an SSL/TLS certificate for <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus installed on another UNIX or Linux system (including systems running Apache HTTP Server), copy it to the **/etc/nginx/ssl** directory on the <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus server.
- Generate a self‑signed certificate as outlined in [Generating a Self‑Signed Certificate](#certificate-self-signed) below. This is sufficient for testing scenarios, but clients of production deployments generally require a certificate signed by a certificate authority (CA).
- Request a new certificate from a CA or your organization's security group, as described in [Generating a Certificate Request](#certificate-request) below.

For more details on SSL/TLS termination, see the <span style="white-space: nowrap;">[NGINX Plus Admin Guide]({{< ref "/nginx/admin-guide/_index.md" >}})</span>.


<span id="certificate-self-signed"></span>
### Generating a Self-Signed Certificate

Generate a public‑private key pair and a self‑signed server certificate in PEM format that is based on them.

1. Log in as the root user on a machine that has the `openssl` software installed.

2. Generate the key pair in PEM format (the default). To encrypt the private key, include the <span style="white-space: nowrap;">`-des3`</span> parameter (Other encryption algorithms are available and can be found on the man page for the [genrsa](https://www.openssl.org/docs/manmaster/man1/openssl-genrsa.html) command). You will be prompted for a passphrase to use for encryption.

   ```shell
   root# openssl genrsa -des3 -out ~/private-key.pem 2048
   Generating RSA private key ...
   Enter pass phrase for private-key.pem:
   ```

3. Create a backup of the key file in a secure location. If you lose the key, the certificate becomes unusable.

   ```shell
   root# cp ~/private-key.pem <SECURE-DIR>/private-key.pem.backup
   ```

4. Generate the certificate. Include the <span style="white-space: nowrap;">`-new`</span> and <span style="white-space: nowrap;">`-x509`</span> parameters to make a new self‑signed certificate. Optionally include the <span style="white-space: nowrap;">`-days`</span> parameter to change the key's validity lifetime from the default of 30 days (10950 days is about 30 years). Follow the prompts and enter values appropriate for your testing deployment.

    ```none
    root# openssl req -new -x509 -key ~/private-key.pem -out ~/self-cert.pem -days 10950
    ```

5. Copy or move the certificate file and associated key files to the **/etc/nginx/ssl** directory on the <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus server.


<span id="certificate-request"></span>
### Generating a Certificate Request

1. Log in as the root user on a machine that has the `openssl` software installed.

2. Create a private key to be packaged in the certificate.

   ```shell
   root# openssl genrsa -out ~/example.com.key 2048
   ```

3. Create a backup of the key file in a secure location. If you lose the key, the certificate becomes unusable.

   ```shell
   root# cp ~/example.com.key <SECURE-DIR>/example.com.key.backup
   ```

4. Create a Certificate Signing Request (CSR) file.

   ```shell
   root# openssl req -new -sha256 -key ~/example.com.key -out ~/example.com.csr
   ```

5. Request a certificate from a CA or your internal security group, providing the CSR file (**example.com.csr**). As a reminder, never share private keys (**.key** files) directly with third parties.

    The certificate needs to be PEM format rather than in the Windows‑compatible PFX format. If you request the certificate from a CA website yourself, choose NGINX or Apache (if available) when asked to select the server platform for which to generate the certificate.

6. Copy or move the certificate file and associated key files to the **/etc/nginx/ssl** directory on the NGINX Plus server.

<span id="config-files"></span>
## Creating and Modifying Configuration Files

To simplify the process, this guide has you copy directives from files provided by NGINX into your configuration files, rather than typing it manually. After that, follow the sections in this guide (starting with [Configuring Virtual Servers for HTTP and HTTPS Traffic](#virtual-servers)) to learn how to modify the directives as required for your deployment.

As provided, there is one file for basic load balancing (with <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus) and one file for enhanced load balancing (with NGINX Plus). If you are installing and configuring <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus on a fresh Linux system and using it only to load balance Tomcat traffic, you can use the provided file as your main configuration file, which by convention is called **/etc/nginx/nginx.conf**.

We recommend, however, that instead of a single configuration file you use the scheme that is set up automatically when you install an NGINX Plus package, especially if you already have an existing <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus deployment or plan to expand its use in the future. In the conventional scheme, the main configuration file is still called **/etc/nginx/nginx.conf**, but instead of including all directives in it, you create separate configuration files for different HTTP‑related functions and store the files in the **/etc/nginx/conf.d** directory. You then use the `include` directive in the `http` context of the main file to read in the contents of the function‑specific files.

To download the complete configuration file for basic load balancing:

```none
root# cd /etc/nginx/conf.d
root# curl https://www.nginx.com/resource/conf/tomcat-basic.conf > tomcat-basic.conf
```

To download the complete configuration file for enhanced load balancing:

```none
root# cd /etc/nginx/conf.d
root# curl https://www.nginx.com/resource/conf/tomcat-enhanced.conf > tomcat-enhanced.conf
```

(You can also access the URL in a browser and download the file that way.)

To set up the conventional configuration scheme, add an `http` configuration block in the main **nginx.conf** file, if it does not already exist. (The standard placement is below any global directives.) Add this `include` directive with the appropriate filename:

```nginx
http {
    include conf.d/tomcat-(basic|enhanced).conf;
}
```

You can also use wildcard notation to reference all files that pertain to a certain function or traffic type in the appropriate context block. For example, if you name all HTTP configuration files {{<nb>}}**_function_-http.conf**{{</nb>}}, this is an appropriate `include` directive:

```nginx
http {
    include conf.d/*-http.conf;
}
```

For reference, the text of the full configuration files is included in this document:

- [Full Configuration for Basic Load Balancing](#full-configuration-basic)
- [Full Configuration for Enhanced Load Balancing](#full-configuration-enhanced)

We recommend, however, that you do not copy text directly from this document. It does not necessarily use the same mechanisms for positioning text (such as line breaks and white space) as text editors do. When text is copied into an editor, lines may run together and the indentation in configuration blocks might be inconsistent or missing. While the lack of formatting does not cause issues for <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus, (because like many compilers they ignore white space during parsing, relying solely on semicolons and curly braces as delimiters), it can make the configuration harder for humans to read and modify without encountering errors.

<span id="reloading"></span>
### About Reloading Updated Configuration

We recommend that each time you complete a set of updates to the configuration, you run the <span style="white-space: nowrap;">`nginx -t`</span> command to test the configuration file for syntactic validity.

```none
root# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

To tell <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus to start using the new configuration, run one of the following commands:

```none
root# nginx -s reload
```

or

```none
root# service nginx reload
```

<span id="basic"></span>
## Configuring Basic Load Balancing with NGINX Open Source or NGINX Plus

This section explains how to set up <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus as a load balancer in front of two Tomcat servers. The instructions in the first two sections are mandatory:

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

These directives define virtual servers for HTTP and HTTPS traffic in separate `server` blocks in the top‑level `http` configuration block. All HTTP requests are redirected to the HTTPS server.

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

   Directive documentation: [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen), [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name), [ssl_certificate and ssl_certificate_key](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate), [ssl_prefer_server_ciphers](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_prefer_server_ciphers), [ssl_session_cache](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_cache)

2. Configure a `server` block that permanently redirects requests received on port 80 for **"http://example.com"** to the HTTPS server, which is defined in the previous step.

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

For more information about configuring SSL/TLS, see the <span style="white-space: nowrap;">[NGINX Plus Admin Guide]({{< ref "/nginx/admin-guide/security-controls/terminating-ssl-http.md" >}})</span> and the reference documentation for the HTTP [SSL/TLS](https://nginx.org/en/docs/http/ngx_http_ssl_module.html)  module.

<span id="load-balancing-basic"></span>
### Configuring Basic Load Balancing

To configure load balancing, first create a named _upstream group_, which lists the backend servers among which client requests are distributed. Then set up <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus as a reverse proxy and load balancer by referring to the upstream group in one or more `proxy_pass` directives.

1. Configure an upstream group called **tomcat** with two Tomcat application servers listening on port 8080, one on IP address 10.100.100.11 and the other on 10.100.100.12.

   ```nginx
   # In the 'http' block
   upstream tomcat {
       server 10.100.100.11:8080;
       server 10.100.100.12:8080;
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

2. In the `server` block for HTTPS traffic that we created in [Configuring Virtual Servers for HTTP and HTTPS Traffic](#virtual-servers), include two `location` blocks:

   - The first one matches HTTPS requests in which the path starts with {{<nb>}}**/tomcat-app/**{{</nb>}}, and proxies them to the **tomcat** upstream group we created in the previous step.

   - The second one funnels all traffic to the first `location` block, by doing a temporary redirect of all requests for **"http://example.com/"**.

   ```nginx
   # In the 'server' block for HTTPS traffic
   location /tomcat-app/ {
       proxy_pass http://tomcat;
   }

   location = / {
       return 302 /tomcat-app/;
   }
   ```

   Directive documentation: [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass), [return](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return)


Note that these blocks handle only standard HTTPS traffic. If you want to load balance WebSocket traffic, you need to add another `location` block as described in [Configuring Proxy of WebSocket Traffic](#websocket).

By default, <span style="white-space: nowrap;">NGINX Open Source</span> and NGINX Plus use the Round Robin algorithm for load balancing among servers, forwarding each new request to the next server in the upstream group. In our example, the first request goes to 10.100.100.11, the second to 10.100.100.12, the third to 10.100.100.11, and so on. For information about the other available load-balancing algorithms, see the <a href="../../../admin-guide/load-balancer/http-load-balancer/#choosing-a-load-balancing-method">NGINX Plus Admin Guide</a>.

In NGINX Plus, you can also set up dynamic reconfiguration of an upstream group when the set of backend servers changes, using DNS or an API; see [Enabling Dynamic Reconfiguration of Upstream Groups](#reconfiguration).

For more information about proxying and load balancing, see <span style="white-space: nowrap;">[NGINX Reverse Proxy]({{< ref "nginx/admin-guide/web-server/reverse-proxy.md" >}})</span> and <span style="white-space: nowrap;">[HTTP Load Balancing]({{< relref "../../admin-guide/load-balancer/http-load-balancer.md" >}})</span> in the NGINX Plus Admin Guide, and the reference documentation for the HTTP [Proxy](https://nginx.org/en/docs/http/ngx_http_proxy_module.html) and [Upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html) modules.

<span id="session-persistence-basic"></span>
### Configuring Basic Session Persistence

If your application requires basic session persistence (also known as _sticky sessions_), you can implement it in <span style="white-space: nowrap;">NGINX Open Source</span> with the IP Hash load‑balancing algorithm. (NGINX Plus offers a more sophisticated form of session persistence, as described in [Configuring Advanced Session Persistence](#session-persistence-advanced).)

With the IP Hash algorithm, for each request a hash based on the client's IP address is calculated and associated with one of the upstream servers. All requests with that hash are sent to that server, thus establishing session persistence.

If the client has an IPv6 address, the hash is based on the entire address. For IPv4, the hash is based on the first three octets. This approach is optimized for ISP clients with dynamically assigned IP addresses from a subnetwork (/24) range. However, it is not effective in these cases:

- The majority of the traffic to your site is coming from one forward proxy or from clients on the same /24 network, because in that case IP Hash maps all clients to the same server.

- A client's IP address can change during the session, for example when a mobile client switches from a WiFi network to a cellular one.

To configure session persistence in NGINX, add the `ip_hash` directive to the `upstream` block created in [Configuring Basic Load Balancing](#load-balancing-basic):

```nginx
# In the 'http' block
upstream tomcat {
    ip_hash;
    server 10.100.100.11:8080;
    server 10.100.100.12:8080;
}
```

Directive documentation: [ip_hash](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#ip_hash)

You can also use the Hash load‑balancing method for session persistence, with the hash based on any combination of text and [NGINX variables](https://nginx.org/en/docs/varindex.html) you specify. For example, you can hash on full (four‑octet) client IP addresses with the following configuration.

```nginx
# In the 'http' block
upstream tomcat {
    hash $remote_addr;
    server 10.100.100.11:8080;
    server 10.100.100.12:8080;
}
```

Directive documentation: [hash](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#hash)

<span id="websocket"></span>
### Configuring Proxy of WebSocket Traffic

The WebSocket protocol (defined in [RFC 6455](https://tools.ietf.org/html/rfc6455)) enables simultaneous two‑way communication over a single TCP connection between clients and servers, where each side can send data independently from the other. To initiate the WebSocket connection, the client sends a handshake request to the server, upgrading the request from standard HTTP to WebSocket. The connection is established if the handshake request is validated and accepted by the server. When a WebSocket connection is created, a browser client can send and receive data simultaneously from that server.

Tomcat 8 does not enable WebSocket by default, but instructions for enabling it are available in the [Tomcat documentation](https://tomcat.apache.org/tomcat-8.0-doc/web-socket-howto.html). If you want to use <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus to proxy WebSocket traffic to your Tomcat application servers, add the directives discussed in this section.

 <span style="white-space: nowrap;">NGINX Open Source</span> and NGINX Plus by default use HTTP/1.0 for upstream connections. To be proxied correctly, WebSocket connections require HTTP/1.1 along with some other configuration directives that set HTTP headers:

```nginx
# In the 'http' block
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

# In the 'server' block for HTTPS traffic
location /wstunnel/ {
    proxy_pass http://tomcat;
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

Caching responses from your Tomcat app servers can both improve response time to clients and reduce load on the servers, because eligible responses are served immediately from the cache instead of being generated again on the server. There are a variety of useful directives that can be used to fine‑tune caching behavior; for a detailed discussion, see [A Guide to Caching with NGINX and NGINX Plus](https://www.nginx.com/blog/nginx-caching-guide/).

To enable basic caching in <span style="white-space: nowrap;">NGINX Open Source</span> or NGINX Plus, add the following configuration:

1. Include the `proxy_cache_path` directive to create the local disk directory **/tmp/NGINX_cache/** for use as a cache. The `keys_zone` parameter allocates 10 megabytes (MB) of shared memory for a zone called **backcache**, which is used to store cache keys and metadata such as usage timers. A 1‑MB zone can store data for about 8,000 keys.

   ```nginx
   # In the 'http' block
   proxy_cache_path /tmp/NGINX_cache/ keys_zone=backcache:10m;
   ```

   Directive documentation: [proxy_cache_path](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path)

2. In the `location` block that matches HTTPS requests in which the path starts with {{<nb>}}**/tomcat-app/**{{</nb>}}, include the `proxy_cache` directive to reference the cache created in the previous step.

   ```nginx
   # In the 'server' block for HTTPS traffic
   location /tomcat-app/ {
       proxy_pass http://tomcat;
       proxy_cache backcache;
   }
   ```

   Directive documentation: [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [proxy_cache](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)

By default, the cache key is similar to this string of [NGINX variables](https://nginx.org/en/docs/varindex.html): `$scheme$proxy_host$request_uri`. To change the list of variables, specify them with the `proxy_cache_key` directive. One effective use of this directive is to create a cache key for each user based on the `JSESSIONID` cookie. This is useful when the cache is private, for example containing shopping cart data or other user‑specific resources. Include the `JSESSIONID` cookie in the cache key with this directive:

```nginx
proxy_cache_key $proxy_host$request_uri$cookie_jessionid;
```

   Directive documentation: [proxy_cache_key](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_key)

For more information about caching, see the [NGINX Plus Admin Guide]({{< relref "../../admin-guide/content-cache/content-caching.md/" >}}) and the reference documentation for the HTTP [Proxy](https://nginx.org/en/docs/http/ngx_http_proxy_module.html) module.

<span id="http2"></span>
### Configuring HTTP/2 Support

HTTP/2 is fully supported in both <span style="white-space: nowrap;">NGINX Open Source 1.9.5</span> and later, and <span style="white-space: nowrap;">NGINX Plus R7</span> and later. As always, we recommend you run the latest version of software to take advantage of improvements and bug fixes.

- If using <span style="white-space: nowrap;">NGINX Open Source</span>, note that in version 1.9.5 and later the SPDY module is completely removed from the codebase and replaced with the [HTTP/2](https://nginx.org/en/docs/http/ngx_http_v2_module.html) module. After upgrading to version 1.9.5 or later, you can no longer configure <span style="white-space: nowrap;">NGINX Open Source</span> to use SPDY. If you want to keep using SPDY, you need to compile <span style="white-space: nowrap;">NGINX Open Source</span> from the sources in the [NGINX 1.8.x branch](https://nginx.org/en/download.html).

- In <span style="white-space: nowrap;">NGINX Plus R8</span> and later, NGINX Plus supports HTTP/2 by default. (Support for SPDY is deprecated as of that release). Specifically:

  In <span style="white-space: nowrap;">NGINX Plus R11</span> and later, the {{<nb>}}**nginx-plus**{{</nb>}} package continues to support HTTP/2 by default, but the {{<nb>}}**nginx-plus-extras**{{</nb>}} package available in previous releases is deprecated by [dynamic modules](https://www.f5.com/go/product/nginx-modules/).

  For <span style="white-space: nowrap;">NGINX Plus R8</span> through R10, the {{<nb>}}**nginx-plus**{{</nb>}} and {{<nb>}}**nginx-plus-extras**{{</nb>}} packages support HTTP/2 by default.

  If using <span style="white-space: nowrap;">NGINX Plus R7</span>, you must install the {{<nb>}}**nginx-plus-http2**{{</nb>}} package instead of the {{<nb>}}**nginx-plus**{{</nb>}} or {{<nb>}}**nginx-plus-extras**{{</nb>}} package.

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

The full configuration for basic load balancing appears here for your convenience. It goes in the `http` context. The complete file is available for [download](https://www.nginx.com/resource/conf/tomcat-basic.conf) from the NGINX website.

We recommend that you do not copy text directly from this document, but instead use the method described in [Creating and Modifying Configuration Files](#config-files) to include these directives in your configuration – add an `include` directive to the `http` context of the main **nginx.conf** file to read in the contents of <span style="white-space: nowrap;">**/etc/nginx/conf.d/tomcat-basic.conf**</span>.

```nginx
proxy_cache_path /tmp/NGINX_cache/ keys_zone=backcache:10m;

map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

upstream tomcat {
    # Use IP Hash for session persistence
    ip_hash;
    # List of Tomcat application servers
    server 10.100.100.11:8080;
    server 10.100.100.12:8080;
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
    ssl_certificate     /etc/nginx/ssl/example.com.crt;
    ssl_certificate_key /etc/nginx/ssl/example.com.key;
    ssl_session_cache   shared:SSL:1m;
    ssl_prefer_server_ciphers on;

    # Load balance requests for '/tomcat-app/' across Tomcat application
    # servers
    location /tomcat-app/ {
        proxy_pass http://tomcat;
        proxy_cache backcache;
    }

    # Return a temporary redirect to '/tomcat-app/' when user requests '/'
    location = / {
        return 302 /tomcat-app/;
    }

    # WebSocket configuration
    location /wstunnel/ {
        proxy_pass https://tomcat;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }
}

```

<span id="enhanced"></span>
## Configuring Enhanced Load Balancing with NGINX Plus

This section explains how to configure enhanced load balancing with some of the extended features in NGINX Plus.

**Note:** Before setting up the enhanced features described in this section, you must complete the instructions for basic load balancing in these two sections:

- [Configuring Virtual Servers for HTTP and HTTPS Traffic](#virtual-servers)
- [Configuring Basic Load Balancing](#load-balancing-basic).

Except as noted, all optional basic features (described in the other subsections of [Configuring Basic Load Balancing in <span style="white-space: nowrap;">NGINX Open Source</span> and NGINX Plus](#basic) can be combined with the enhanced features described here.

The features described in the following sections are all optional.

- [Configuring Advanced Session Persistence](#session-persistence-advanced)
- [Configuring Application Health Checks](#health-checks)
- [Enabling Live Activity Monitoring](#live-activity-monitoring)
- [Enabling Dynamic Reconfiguration of Upstream Groups](#reconfiguration)

The complete configuration file appears in [Full Configuration for Enhanced Load Balancing](#full-configuration-enhanced).

<span id="session-persistence-advanced"></span>
### Configuring Advanced Session Persistence

NGINX Plus provides more sophisticated session persistence methods than <span style="white-space: nowrap;">NGINX Open Source</span>, implemented in three variants of the `sticky` directive. In the following example, we add the <span style="white-space: nowrap;">`sticky route`</span> directive to the upstream group we created in [Configuring Basic Load Balancing](#load-balancing-basic), to base session persistence on the `jvmRoute` attribute set by the Tomcat application.

#### Configuring Sticky Route-Based Session Persistence

1. In the NGINX Plus configuration, remove or comment out the `ip_hash` directive, leaving only the `server` directives:

   ```nginx
   # In the 'http' block
   upstream tomcat {
        #ip_hash;
        server 10.100.100.11:8080;
        server 10.100.100.12:8080;
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

2. Add the following lines to the configuration files for your backend Tomcat servers to append an identifier based on the `jvmRoute` attribute (here, set to either `a` or `b`) to the end of the `JSESSIONID` cookie value:

   ```none
   # On host 10.100.100.11
   <Engine name="Catalina" defaultHoast="www.example.com" jvmRoute="a">
   # On host 10.100.100.12
   <Engine name="Catalina" defaultHoast="www.example.com" jvmRoute="b">
   ```

3. Configure NGINX Plus to select the upstream server by inspecting the `JSESSIONID` cookie and URL in each request and extracting the `jvmRoute` value.

   ```nginx
    # In the 'http' block
    map $cookie_jsessionid $route_cookie {
       ~.+\.(?Pw+)$ $route;
   }

   map $request_uri $route_uri {
       ~jsessionid=.+\.(?Pw+)$ $route_uri;
   }

   upstream tomcat {
       server 10.100.100.11:8080 route=a;
       server 10.100.100.12:8080 route=b;
       sticky route $route_cookie $route_uri;
   }
   ```

   Directive documentation: [map](https://nginx.org/en/docs/http/ngx_http_map_module.html#map), [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [`sticky route`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

   - The first `map` directive extracts the final element (following the period) of the `JSESSIONID` cookie, recording it in the `$route_cookie` variable.
   - The second `map` directive extracts the final element (following the period) from the trailing `jsessionid=` element of the request URL, recording it in the `$route_uri` variable.
   - The <span style="white-space: nowrap;">`sticky route`</span> directive tells NGINX Plus to use the value of the first nonempty variable it finds in the list of parameters, which here is the two variables set by the `map` directives. In other words, it uses the final element of the `JESSIONID` cookie if it exists, and the final element of the `jessionid=` URL element otherwise.

      The `route` parameters to the `server` directives mean that the request is sent to 10.100.100.11 if the value is `a` and to 10.100.100.12 if the value is `b`.

#### Configuring Sticky Learn-Based Session Persistence

The <span style="white-space: nowrap;">`sticky learn`</span> directive is another option for session persistence; in this case the session identifier is the `JSESSIONID` cookie created by your Tomcat application.

1. Remove or comment out the `ip_hash` directive in the `upstream` block as in Step 1 above.

2. Include the <span style="white-space: nowrap;">`sticky learn`</span> directive in the `upstream` block:

   ```nginx
   # In the 'http' block
   upstream tomcat {
       server 10.100.100.11:8080;
       server 10.100.100.12:8080;
       sticky learn create=$upstream_cookie_JSESSIONID
                    lookup=$cookie_JSESSIONID
                    zone=client_sessions:1m;
   }
   ```

   Directive documentation: [map](https://nginx.org/en/docs/http/ngx_http_map_module.html#map), [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [`sticky learn`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

   - The `create` and `lookup` parameters specify how new sessions are created and existing sessions are searched for, respectively. For new sessions, NGINX Plus sets the session identifier to the value of the `$upstream_cookie_JSESSIONID` variable, which captures the `JSESSIONID` cookie sent by the Tomcat application server. When checking for existing sessions, it uses the `JSESSIONID` cookie sent by the client (the `$cookie_JSESSIONID` variable) as the session identifier.

      Both parameters can be specified more than once (each time with a different variable), in which case NGINX Plus uses the first nonempty variable for each one.

   - The `zone` argument creates a shared memory zone for storing information about sessions. The amount of memory allocated – here, 1 MB – determines how many sessions can be stored at a time (the number varies by platform). The name assigned to the zone – here, `client_sessions` – must be unique for each `sticky` directive.

For more information about session persistence, see the <a href="../../../admin-guide/load-balancer/http-load-balancer/#sticky">NGINX Plus Admin Guide</a>.

<span id="health-checks"></span>
### Configuring Application Health Checks

Health checks are <span style="white-space: nowrap;">out-of-band</span> HTTP requests sent to a server at fixed intervals. They are used to determine whether a server is responsive and functioning correctly, without requiring an actual request from a client.

Because the `health_check` directive is placed in the `location` block, we can enable different health checks for each application.

1. In the `location` block that matches HTTPS requests in which the path starts with {{<nb>}}**/tomcat-app/**{{</nb>}} (created in [Configuring Basic Load Balancing](#load-balancing-basic)), add the `health_check` directive.

   Here we configure NGINX Plus to send an <span style="white-space: nowrap;">out-of-band</span> request for the top‑level URI **/** (slash) to each of the servers in the **tomcat** upstream group every 2 seconds, which is more aggressive than the default 5‑second interval. If a server does not respond correctly, it is marked down and NGINX Plus stops sending requests to it until it passes five subsequent health checks in a row. We include the `match` parameter to define a nondefault set of health‑check tests.

   ```nginx
   # In the 'server' block for HTTPS traffic
   location /tomcat-app/ {
       proxy_pass http://tomcat;
       proxy_cache backcache;
       health_check interval=2s fails=1 passes=5 uri=/ match=tomcat_check;
   }
   ```

   Directive documentation: [health_check](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check), [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [proxy_cache](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)

2. In the `http` context, include a `match` directive to define the tests that a server must pass to be considered functional. In this example, it must return status code `200`, the <span style="white-space: nowrap;">`Content-Type`</span> response header must be `text/html`, and the response body must match the indicated regular expression.

   ```nginx
   # In the 'http' block
   match health_check {
       status 200;
       header Content-Type = text/html;
       body ~ "Apache Tomcat/8";
   }
   ```

   Directive documentation: [match](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#match)

3. In the **tomcat** upstream group, include the `zone` directive to define a shared memory zone that stores the group's configuration and run‑time state, which are shared among worker processes.

   ```nginx
   # In the 'http' block
   upstream tomcat {
      zone tomcat 64k;

      server 10.100.100.11:8080;
      server 10.100.100.12:8080;
      # ...
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream), [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

NGINX Plus also has a slow‑start feature that is a useful auxiliary to health checks. When a failed server recovers, or a new server is added to the upstream group, NGINX Plus slowly ramps up the traffic to it over a defined period of time. This gives the server time to "warm up" without being overwhelmed by more connections than it can handle as it starts up. For more information, see the <a href="../../../admin-guide/load-balancer/http-load-balancer/#slow_start">NGINX Plus Admin Guide</a>.

For example, to set a slow‑start period of 30 seconds for your Tomcat application servers, include the `slow_start` parameter to their `server` directives:

```nginx
# In the 'upstream' block
#...
server 10.100.100.11:8080 slow_start=30s;
server 10.100.100.12:8080 slow_start=30s;
```

For information about customizing health checks, see the [NGINX Plus Admin Guide]({{< ref "nginx/admin-guide/load-balancer/http-health-check.md" >}}).

<span id="live-activity-monitoring"></span>
### Enabling Live Activity Monitoring

NGINX Plus includes a live activity monitoring interface that provides key load and real-time performance metrics, including TCP metrics in <span style="white-space: nowrap;">NGINX Plus R6</span> and later. Statistics are reported through a RESTful JSON interface, making it easy to integrate with custom or third‑party monitoring tools. There is also a built‑in dashboard. Follow these instructions to deploy it.

<img src="/nginx/images/nginx-plus-dashboard-r19-overview.png" alt="Dashboard tab in NGINX Plus live activity monitoring dashboard" style="border:2px solid #666666; padding:2px; margin:2px;" />

For more information about live activity monitoring, see the [NGINX Plus Admin Guide]({{< ref "nginx/admin-guide/monitoring/live-activity-monitoring.md" >}}).

The quickest way to configure the module and the built‑in dashboard is to download the sample configuration file from the NGINX website, and modify it as necessary. For more complete instructions, see [Live Activity Monitoring of NGINX Plus in 3 Simple Steps](https://www.nginx.com/blog/live-activity-monitoring-nginx-plus-3-simple-steps/).

1. Download the **status.conf** file to the NGINX Plus server:

   ```shell
   # cd /etc/nginx/conf.d
   # curl https://www.nginx.com/resource/conf/status.conf > status.conf
   ```

2. Read in **status.conf** at the top‑level `http` configuration block in the main **nginx.conf** file:

   ```nginx
   # In the 'http' block
   include conf.d/status.conf;
   ```

    Directive documentation: [include](https://nginx.org/en/docs/ngx_core_module.html#include)

    If you are using the conventional configuration scheme and your existing `include` directives use the wildcard notation discussed in [Creating and Modifying Configuration Files](#config-files), you can either add a separate `include` directive for **status.conf** as shown above, or change the name of **status.conf** so it is captured by the wildcard in an existing `include` directive in the `http` block. For example, changing it to {{<nb>}}**status-http.conf**{{</nb>}} means it is captured by the `include` directive for <span style="white-space: nowrap;">`*-http.conf`</span>.

3. Comments in **status.conf** explain which directives you must customize for your deployment. In particular, the default settings in the sample configuration file allow anyone on any network to access the dashboard. We strongly recommend that you restrict access to the dashboard with one or more of the following methods:

   - **IP address‑based access control lists (ACLs)**. In the sample configuration file, uncomment the `allow` and `deny` directives, and substitute the address of your administrative network for 10.0.0.0/8. Only users on the specified network can access the status page.

     ```nginx
     allow 10.0.0.0/8;
     deny all;
     ```

     Directive documentation: [allow](https://nginx.org/en/docs/http/ngx_http_access_module.html#allow), [deny](https://nginx.org/en/docs/http/ngx_http_access_module.html#deny)

   - **HTTP Basic authentication** as defined in [RFC 7617](https://tools.ietf.org/html/rfc7617). In the sample configuration file, uncomment the `auth_basic` and `auth_basic_user_file` directives and add user entries to the **/etc/nginx/users** file (for example, by using an **htpasswd** generator). If you have an Apache installation, another option is to reuse an existing **htpasswd** file.

     ```nginx
     auth_basic on;
     auth_basic_user_file /etc/nginx/users;
     ```

     Directive documentation: [auth_basic](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html#auth_basic), [auth_basic_user_file](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html#auth_basic_user_file)

   - **Client certificates**, which are part of a complete configuration of SSL/TLS. For more information, see the <span style="white-space: nowrap;">[NGINX Plus Admin Guide]({{< relref "../../admin-guide/security-controls/terminating-ssl-http.md" >}})</span> and the reference documentation for the HTTP  [SSL/TLS](https://nginx.org/en/docs/http/ngx_http_ssl_module.html) module.

   - **Firewall**. Configure your firewall to disallow outside access to the port for the dashboard (8080 in the sample configuration file).

4. In each upstream group that you want to monitor, include the `zone` directive to define a shared memory zone that stores the group's configuration and run‑time state, which are shared among worker processes.

   For example, to monitor your Tomcat application servers, add the `zone` directive to the **tomcat** upstream group (if you followed the instructions in [Configuring Application Health Checks](#health-checks), you already made this change).

   ```nginx
   # In the 'http' block
   upstream tomcat {
      zone tomcat 64k;

      server 10.100.100.11:8080;
      server 10.100.100.12:8080;
      #...
   }
   ```

    Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream), [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

5. In the `server` block for HTTPS traffic (created in [Configuring Virtual Servers for HTTP and HTTPS Traffic](#virtual-servers)), add the `status_zone` directive:

   ```nginx
   # In the 'server' block for HTTPS traffic
   status_zone tomcat;
   ```

   Directive documentation: [status_zone](https://nginx.org/en/docs/http/ngx_http_status_module.html#status_zone)

When you reload the NGINX Plus configuration file, for example by running the <span style="white-space: nowrap;">`nginx -s reload`</span> command, the NGINX Plus dashboard is available immediately at <span style="white-space: nowrap;">**http://_nginx-plus-server-address_:8080**</span>.

<span id="reconfiguration"></span>
### Enabling Dynamic Reconfiguration of Upstream Groups

With NGINX Plus, you can reconfigure load‑balanced server groups (both HTTP and TCP/UDP) dynamically using either the Domain Name System (DNS) or the NGINX Plus API introduced in <span style="white-space: nowrap;">NGINX Plus R13</span>. See the NGINX Plus Admin Guide for a more detailed discussion of the <a href="../../../admin-guide/load-balancer/http-load-balancer/#resolve">DNS</a> and [API]({{< ref "nginx/admin-guide/load-balancer/dynamic-configuration-api.md" >}}) methods.

#### Configuring the API Method

To enable dynamic reconfiguration of your upstream group of Tomcat app servers using the NGINX Plus API, you need to grant secured access to it. You can use the API to add or remove servers, dynamically alter their weights, and set their status as `primary`, `backup`, or `down`.

1. Include the `zone` directive in the **tomcat** upstream group to create a shared memory zone for storing the group's configuration and run‑time state, which makes the information available to all worker processes. (If you configured [application health checks](#health-checks) or [live activity monitoring](#live-activity-monitoring), you already made this change.)

   ```nginx
   # In the 'http' block
   upstream tomcat {
       zone tomcat 64k;
       server 192.168.33.11:8080;
       server 192.168.33.12:8080;
       # ...
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream), [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

2. In the `server` block for HTTPS traffic (created in [Configuring Virtual Servers for HTTP and HTTPS Traffic](#virtual-servers)), add a new `location` block for the NGINX Plus API, which enables dynamic reconfiguration among other features. It contains the `api` directive (**api** is also the conventional name for the location, as used here).

   (If you configured [live activity monitoring](#live-activity-monitoring) by downloading the **status.conf** file, it already includes this block.)

   We strongly recommend that you restrict access to the location so that only authorized administrators can access the NGINX Plus API. The `allow` and `deny` directives in the following example permit access only from the localhost address (127.0.0.1).

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

In the `http` block, add the `resolver` directive pointing to your DNS server. In the **tomact** `upstream` block add the `resolve` parameter to the `server` directive, which instructs NGINX Plus to periodically re‑resolve the domain name (here, **example.com** here) with DNS.

Also include the `zone` directive in the `upstream` block to create a shared memory zone for storing the upstream group's configuration and run‑time state, which makes the information available to all worker processes. (If you configured [application health checks](#health-checks) or [live activity monitoring](#live-activity-monitoring), you already made this change.)


```nginx
# In the 'http' block
resolver <IP-address-of-DNS-server>;

upstream tomcat {
    zone tomcat 64k;
    server example.com resolve;
}
```

Directive and parameter documentation: [resolve](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#resolve), [resolver](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver), [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

[NGINX Plus Release 9](https://www.nginx.com/blog/nginx-plus-r9-released/#dns-srv) and later can also use the additional information in DNS `SRV` records, such as the port number. Include the `service` parameter to the `server` directive, along with the `resolve` parameter:

```nginx
# In the 'http' block
resolver <IP-address-of-DNS-server>;

upstream tomcat {
    zone tomcat 64k;
    server example.com service=http resolve;
}
```

Parameter documentation: [service](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#service)

<span id="full-configuration-enhanced"></span>
### Full Configuration for Enhanced Load Balancing

The full configuration for enhanced load balancing appears here for your convenience. It goes in the `http` context. The complete file is available for [download](https://www.nginx.com/resource/conf/tomcat-enhanced.conf) from the NGINX website.

We recommend that you do not copy text directly from this document, but instead use the method described in [Creating and Modifying Configuration Files](#config-files) to include these directives in your configuration – namely, add an `include` directive to the `http` context of the main **nginx.conf** file to read in the contents of <span style="white-space: nowrap;">**/etc/nginx/conf.d/tomcat-enhanced.conf**</span>.

```nginx
proxy_cache_path /tmp/NGINX_cache/ keys_zone=backcache:10m;

# WebSocket configuration
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

# Extract the data after the final period (.) in the
# JSESSIONID cookie and store it in the $route_cookie variable.
map $cookie_jsessionid $route_cookie {
    ~.+\.(?P<route>w+)$ $route;
}

# Search the URL for a trailing jsessionid parameter, extract the
# data after the final period (.), and store it in
# the $route_uri variable.
map $request_uri $route_uri {
    jsessionid=.+\.(?P<route>w+)$ $route;
}

# Application health checks
match tomcat_check {
    status 200;
    header Content-Type = text/html;
    body ~ "Apache Tomcat/8";
}

upstream tomcat {
    # Shared memory zone for application health checks, live activity
    # monitoring, and dynamic reconfiguration
    zone tomcat 64k;

    # List of Tomcat application servers
    server 10.100.100.11:8080 slow_start=30s;
    server 10.100.100.12:8080 slow_start=30s;

    # Session persistence based on the jvmRoute value in
    # the JSESSION ID cookie
    sticky route $route_cookie $route_uri;

    # Uncomment the following directive (and comment the preceding
    # 'sticky route' and JSESSIONID 'map' directives) for session
    # persistence based on the JSESSIONID
    #sticky learn create=$upstream_cookie_JSESSIONID
    #             lookup=$cookie_JSESSIONID
    #             zone=client_sessions:1m;
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
    status_zone tomcat;

    ssl_certificate     /etc/nginx/ssl/example.com.crt;
    ssl_certificate_key /etc/nginx/ssl/example.com.key;
    ssl_session_cache         shared:SSL:1m;
    ssl_prefer_server_ciphers on;

    # Load balance requests for '/tomcat-app/' across Tomcat application
    # servers
    location /tomcat-app/ {
        proxy_pass http://tomcat;
        proxy_cache backcache;

        # Active health checks
        health_check interval=2s fails=1 passes=5 uri=/ match=tomcat_check;
    }

    # Return a 302 redirect to '/tomcat-app/' when user requests '/'
    location = / {
        return 302 /tomcat-app/;
    }

    # WebSocket configuration
    location /wstunnel/ {
        proxy_pass http://tomcat;
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

- [NGINX Plus Overview](https://www.f5.com/products/nginx/nginx-plus)
- [NGINX Plus Admin Guide]({{< ref "/nginx/admin-guide/_index.md" >}})
- [NGINX Wiki](https://www.nginx.com/resources/wiki/)

### Revision History

- Version 6 (May 2024) – Update about HTTP/2 support (the [http2](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2) directive)
- Version 5 (October 2019) – Fix syntax of comment in config snippet (add missing `#`)
- Version 4 (February 2018) – Update for NGINX Plus API (<span style="white-space: nowrap;">NGINX Plus R14</span>)
- Version 3 (April 2017) – Update about HTTP/2 support and dynamic modules (<span style="white-space: nowrap;">NGINX Plus R11</span>, <span style="white-space: nowrap;">NGINX Open Source 1.11.5</span>)
- Version 2 (January 2016) – Update about HTTP/2 support (<span style="white-space: nowrap;">NGINX Plus R8</span>, <span style="white-space: nowrap;">NGINX Open Source 1.9.9</span>)
- Version 1 (January 2016) – Initial version (<span style="white-space: nowrap;">NGINX Plus R7</span>, <span style="white-space: nowrap;">NGINX Open Source 1.9.5</span>)

