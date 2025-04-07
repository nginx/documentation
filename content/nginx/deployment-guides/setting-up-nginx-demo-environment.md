---
description: Configure NGINX Open Source as a web server and F5 NGINX Plus as a load
  balancer, as required for the sample deployments in NGINX deployment guides.
docs: DOCS-462
title: Setting up an NGINX demo environment
toc: true
weight: 100
type:
- how-to
---

The instructions in this guide explain how to set up a simple demo environment that uses F5 NGINX Plus to load balance web servers that run NGINX Open Source and serve two distinct web applications. It is referenced by some of our deployment guides for implementing highly availability of NGINX Plus and NGINX Open Source in cloud environments.

<span id="prereqs"></span>
## Prerequisites

This guide assumes you have already provisioned a number of host systems (physical servers, virtual machines, containers, or cloud instances) required for a deployment guide (if applicable) and installed NGINX Open Source or NGINX Plus on each instance as appropriate. For installation instructions, see the [NGINX Plus Admin Guide]({{< ref "nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).

Some commands require `root` privilege. If appropriate for your environment, prefix commands with the `sudo` command.

<span id="nginx-oss"></span>
## Configuring NGINX Open Source for web serving

The steps in this section configure an NGINX Open Source instance as a web server to return a page like the following, which specifies the server name, address, and other information. The page is defined in the <span style="white-space: nowrap; font-weight:bold;">demo-index.html</span> configuration file you create in Step 4 below.

   <a href="/nginx/images/aws-nlb-app1.png"><img src="/nginx/images/aws-nlb-app1.png" alt="" width="1024" height="491" class="aligncenter size-full wp-image-54839" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

If you are using these instructions to satisfy the prerequisites for one of our deployment guides, the Appendix in the guide specifies the name of each NGINX Open Source instance and whether to configure **App 1** or **App 2**.

**Note:** Some commands require `root` privilege. If appropriate for your environment, prefix commands with the `sudo` command.

1. Open a connection to the NGINX Open Source instance and change the directory to **/**etc/nginx/conf.d**:

   ```shell
   cd /etc/nginx/conf.d
   ```

2. Rename **default.conf** to **default.conf.bak** so that NGINX Plus does not use it.

   ```shell
   mv default.conf default.conf.bak
   ```

3. Create a new file called **app.conf** with the following contents.

   ```nginx
   server {
       listen 80 default_server;
       server_name app_server;

       root /usr/share/nginx/html;
       error_log /var/log/nginx/app-server-error.log notice;
       index demo-index.html index.html;
       expires -1;

       sub_filter_once off;
       sub_filter 'server_hostname' '$hostname';
       sub_filter 'server_address'  '$server_addr:$server_port';
       sub_filter 'server_url'      '$request_uri';
       sub_filter 'remote_addr'     '$remote_addr:$remote_port';
       sub_filter 'server_date'     '$time_local';
       sub_filter 'client_browser'  '$http_user_agent';
       sub_filter 'request_id'      '$request_id';
       sub_filter 'nginx_version'   '$nginx_version';
       sub_filter 'document_root'   '$document_root';
       sub_filter 'proxied_for_ip'  '$http_x_forwarded_for';
   }
   	```

   Directive documentation: [error_log](http://nginx.org/en/docs/ngx_core_module.html#error_log), [expires](http://nginx.org/en/docs/http/ngx_http_headers_module.html#expires), [index](http://nginx.org/en/docs/http/ngx_http_index_module.html#index), [listen](http://nginx.org/en/docs/http/ngx_http_core_module.html#listen), [root](http://nginx.org/en/docs/http/ngx_http_core_module.html#root), [server](http://nginx.org/en/docs/http/ngx_http_core_module.html#server), [server_name](http://nginx.org/en/docs/http/ngx_http_core_module.html#server_name), [sub_filter](http://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter)

4. Include the following directive in the top‑level ("main") context in **/etc/nginx/nginx.conf**, if it does not already appear there.

   ```nginx
   include conf.d/*.conf;
   ```

   Directive documentation: [include](http://nginx.org/en/docs/ngx_core_module.html#include)

5. In the **/usr/share/nginx/html** directory, create a new file called **demo-index.html** with the following contents, which define the default web page that appears when users access the instance.

   In the `<title>` tag, replace the comment with `1` or `2` depending on whether the instance is serving **App 1** or **App 2**.

   ```html
   <!DOCTYPE html>
   <html>
       <head>
           <title>Hello World - App X <!-- Replace 'X' with '1' or '2' as appropriate --></title>
           <link href="data:image/png;base64,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" rel="icon" type="image/png" />
           <style>
               body {
                   margin: 0px;
                   font: 20px 'RobotoRegular', Arial, sans-serif;
                   font-weight: 100;
                   height: 100%;
                   color: #0f1419;
               }
               div.info {
                   display: table;
                   background: #e8eaec;
                   padding: 20px 20px 20px 20px;
                   border: 1px dashed black;
                   border-radius: 10px;
                   margin: 0px auto auto auto;
               }
               div.info p {
                   display: table-row;
                   margin: 5px auto auto auto;
               }
               div.info p span {
                   display: table-cell;
                   padding: 10px;
               }
               img {
                   width: 176px;
                   margin: 36px auto 36px auto;
                   display:block;
               }
               div.smaller p span {
                   color: #3D5266;
               }
               h1, h2 {
                   font-weight: 100;
               }
               div.check {
                   padding: 0px 0px 0px 0px;
                   display: table;
                   margin: 36px auto auto auto;
                   font: 12px 'RobotoRegular', Arial, sans-serif;
               }
               #footer {
                   position: fixed;
                   bottom: 36px;
                   width: 100%;
               }
               #center {
                   width: 400px;
                   margin: 0 auto;
                   font: 12px Courier;
               }
           </style>

           <script>
               var ref;
               function checkRefresh() {
                   if (document.cookie == "refresh=1") {
                       document.getElementById("check").checked = true;
                       ref = setTimeout(function(){location.reload();}, 1000);
                   } else {
                   }
               }
               function changeCookie() {
                   if (document.getElementById("check").checked) {
                       document.cookie = "refresh=1";
                       ref = setTimeout(function(){location.reload();}, 1000);
                   } else {
                       document.cookie = "refresh=0";
                       clearTimeout(ref);
                   }
               }
           </script>
       </head>

       <body onload="checkRefresh();">
           <img alt="NGINX Logo" src="data:image/png;base64,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"/>
           <div class="info">
               <p><span>Server name:</span> <span>server_hostname</span></p>
               <p><span>Server address:</span> <span>server_address</span></p>
               <p class="smaller"><span>User Agent:</span> <span>client_browser</span></p>
               <p class="smaller"><span>URI:</span> <span>server_url</span></p>
               <p class="smaller"><span>Doc Root:</span> <span>document_root</span></p>
               <p class="smaller"><span>Date:</span> <span>server_date</span></p>
               <p class="smaller"><span>NGINX Frontend Load Balancer IP:</span> <span>remote_addr</span></p>
               <p class="smaller"><span>Client IP:</span> <span>proxied_for_ip</span></p>
               <p class="smaller"><span>NGINX Version:</span> <span>nginx_version</span></p>
           </div>
           <div class="check">
               <input type="checkbox" id="check" onchange="changeCookie()"> Auto Refresh</input>
           </div>
           <div id="footer">
               <div id="center" align="center">
                   Request ID: request_id<br/>
                   © NGINX, Inc. 2018
               </div>
           </div>
       </body>
   </html>
   ```

<span id="nginx-plus"></span>
## Configuring NGINX Plus for load balancing

The steps in this section configure an NGINX Plus instance to load balance requests across the group of NGINX Open Source web servers you configured in the [previous section](#nginx-oss).

If you are using these instructions to satisfy the prerequisites for one of our deployment guides, the Appendix in the guide specifies the names of the NGINX Plus instances used in it.

Repeat these instructions on each instance. Alternatively, you can configure one instance and share the configuration with its peers in a cluster. See the [NGINX Plus Admin Guide]({{< ref "nginx/admin-guide/high-availability/configuration-sharing.md" >}}).

1. Open a connection to the NGINX Plus instance and change the directory to **/**etc/nginx/conf.d**:

   ```shell
   cd /etc/nginx/conf.d
   ```

2. Rename **default.conf** to **default.conf.bak** so that NGINX Plus does not use it.

   ```shell
   mv default.conf default.conf.bak
   ```

3. Create a new file called **lb.conf** with the following contents.

   **Note:** In the `upstream` blocks, include a [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server) directive for each NGINX Open Source instance that serves the relevant application.

   ```nginx
   # in the 'http' context
   upstream app1 {
       server <internal IP address of NGINX Open Source instance serving App 1>;
       # 'server' directives for additional App 1 servers, if using
       zone app1 64k;
   }

   upstream app2 {
       server <internal IP address of NGINX Open Source instance serving App 2>;
       # 'server' directives for additional App 2 servers, if using
       zone app2 64k;
   }

   server {
       listen 80;
       status_zone backend;
       root /usr/share/nginx/html;

       location / {
           # directives for serving the site's HTML landing page
       }

       location /application1 {
           proxy_set_header Host $host;
           proxy_set_header X-Forwarded-For $remote_addr;
           proxy_pass http://app1/;
       }

       location /application2 {
           proxy_set_header Host $host;
           proxy_set_header X-Forwarded-For $remote_addr;
           proxy_pass http://app2/;
       }

       location /api {
           api write=on;
           # directives to control access, such as 'allow' and 'deny'
       }

       location = /dashboard.html {
           root /usr/share/nginx/html;
       }

       location = /status.html {  # redirect requests that are made to pre-R14 dashboard
           return 301 /dashboard.html;
       }
   }
   ```

    Directive documentation: [api](https://nginx.org/en/docs/http/ngx_http_api_module.html#api), [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen), [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass), [proxy_set_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header), [return](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return), [root](https://nginx.org/en/docs/http/ngx_http_core_module.html#root), [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server) (upstream),[server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) (virtual), [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name), [status_zone](https://nginx.org/en/docs/http/ngx_http_status_module.html#status_zone), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream), [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

4. Include the following directive in the top‑level ("main") context in **/etc/nginx/nginx.conf**, if it does not already appear there.

   ```nginx
   include conf.d/*.conf;
   ```

   Directive documentation: [include](http://nginx.org/en/docs/ngx_core_module.html#include)

### Revision history

- Version 2 (April 2019) – Generalized instructions for use with deployment guides
- Version 1 (April 2018) – Initial version
