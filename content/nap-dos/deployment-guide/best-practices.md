---
description:  F5 DoS for NGINX Best Practices Deployment.
nd-docs: DOCS-666
title: Best Practices Deployment
toc: true
weight: 100
type:
- how-to
---

This guide shows how to modify your NGINX configuration to enable F5 DoS for NGINX (NGINX App Protect DoS). We will configure F5 DoS For NGINX to protect a proxy server.

## F5 DoS Configuration

### Load Module

```nginx
load_module modules/ngx_http_app_protect_dos_module.so;
```

### Enable
Add the directive in the appropriate context, You can set it in location, server, or http blocks:

```nginx
app_protect_dos_enable on;
```

#### Set a Protected Object Name
Choose a unique name. You can set it in location, server, or http blocks.

```nginx
app_protect_dos_name po-example;
```

**Note**: Although optional, we strongly recommend specifying a name for each Protected Object (PO) to improve organization and maintainability. If no name is provided, the virtual server is assigned an auto-generated name using the following syntax:

```nginx
line_number-server_name:seq-location_name
Example: 30-backend:1-/abc
```

Where:

- `line number:` the line number of the server block (`server {`) in the `nginx.conf` file (i.e. `30`)<br>
- `server name:` taken from directive `server_name` (i.e. `backend`) <br>
seq: 0 for server block, increments for each location block. i.e. VS created from server block will have 0 and VS's from location blocks will be 1,2,3,... (i.e. `1`)
- `location name:` the name of the location (i.e. `/abc`)

Capacity limits

- Up to 300 Protected Objects in versions up to 4.3 <br>
- Up to 1,000 Protected Objects in versions 4.4 and later <br>


### Set a Monitor directive
The `app_protect_dos_monitor` directive monitors the stress level of a Protected Object by generating requests from localhost (127.0.0.1) that traverse your NGINX configuration like normal client traffic (through the same `server` / `location` / `proxy_pass` chain).  
**This directive is mandatory for optimal accuracy (it may be omitted only when using HTTP/1.1, though it is still strongly recommended).**
```nginx
app_protect_dos_monitor uri=<server_name[:port]/path> [protocol=http1|http2|grpc|websocket] [timeout=<number>] [proxy_protocol=on|off];
```
 
- `uri` is the value of `server_name`, optionally followed by `:port`, and then the location path.  
  Examples: `my_server/`, `example_server:81/abc`  
 
A complete guide on configuring the Monitor Directive can be found here: [Monitor Directive](https://docs.nginx.com/nginx-app-protect-dos/directives-and-policy/learn-about-directives-and-policy/#monitor-directive-app_protect_dos_monitor).

**Monitor directive best practice**
- Monitor the same virtual host and path that your users hit. Set `uri=` to the `server_name[:port]/path` that matches the `server_name` and `listen` directives, **not** to the upstream IP:port.<br>
 
Examples:<br>
 
For `server_name "my_server"` on port `80` and path `/` (port 80 is default, so it can be omitted):  
```nginx
    app_protect_dos_monitor uri=my_server/;
```
 
For `server_name "serv"` on port `81` with location path `/abc`:  
```nginx
    app_protect_dos_monitor uri=serv:81/abc protocol=http1 timeout=7;
```
 
A full example with upstream:<br>
 
```nginx
    upstream backend {
        server 10.197.24.136:3000;
    }
 
    server {
        listen       80 reuseport;
        server_name  example_srv;
 
        location / {
            app_protect_dos_enable  on;
            app_protect_dos_name    "main_app";
 
            # ✅ Good: monitor hits NGINX using server_name and is proxied to the upstream
            app_protect_dos_monitor uri=example_srv:80/ protocol=http1 timeout=7;
 
            # ❌ Bad: do NOT point the monitor directly at the upstream IP
            # app_protect_dos_monitor uri=10.197.24.136:3000/ protocol=http1 timeout=7;
 
            proxy_pass  http://backend;
        }
    }
```
 
- Avoid monitors that short-circuit upstreams (for example, `return 200` locally); this will under-estimate stress.<br>
- Choose `timeout` slightly above your upstream’s p95/p99 latency under normal load, but low enough to react quickly under stress.<br>
- Monitor traffic originates from `127.0.0.1`. Exclude it from rate and connection limits as needed.<br>
- Define the monitor inside each protected `location` block.<br>

## Arbitrator
It is required when more than one F5 DoS for NGINX instance is deployed. Its primary function is to ensure that all instances are aware of—and share—the same state for each Protected Object.<br>
A complete guide on configuring  F5 DoS for NGINX Arbitrator  be found here: [F5 DoS for NGINX Arbitrator](https://docs.nginx.com/nginx-app-protect-dos/deployment-guide/learn-about-deployment/#f5-dos-for-nginx-arbitrator) <br>
Enable the F5 DoS for NGINX Arbitrator in the `http` context of the `nginx.conf` file:

```nginx
app_protect_dos_arb_fqdn 10.1.10.22;
```

## EBPF manager
The eBPF Manager is a high-performance component that simplifies and secures the deployment of eBPF (Extended Berkeley Packet Filter) programs for advanced networking use cases.
Enable the L4-accelerated mitigation feature in the http context of the nginx.conf file:

```nginx
app_protect_dos_accelerated_mitigation on;
```

## ELK Dashboards
ELK stands for Elasticsearch, Logstash, and Kibana. Logstash receives logs from F5 DoS, normalizes them, and stores them in the Elasticsearch index. Kibana allows you to visualize and navigate the logs using purpose-built dashboards.<br>
A complete guide on configuring ELK can be found here: [F5 DoS for NGINX ELK Dashboards](https://github.com/f5devcentral/nap-dos-elk-dashboards) <br>
F5 DoS directives should appear in your `nginx.conf` as shown. Replace `ip_kibana` with the hostname of the server running your ELK Docker container:<br>

```nginx
http {
    log_format log_dos ', vs_name_al=$app_protect_dos_vs_name, ip=$remote_addr, tls_fp=$app_protect_dos_tls_fp, outcome=$app_protect_dos_outcome, reason=$app_protect_dos_outcome_reason, ip_tls=$remote_addr:$app_protect_dos_tls_fp, ';
    ...
    server {
       ...

       app_protect_dos_security_log_enable on;
       app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" syslog:server=ip_kibana:5261;


       location / {
           app_protect_dos_enable       on;
           set $loggable '0';
           access_log syslog:server=ip_kibana:5561 log_dos if=$loggable;

        ...   
       }
       
    }
    ...
}
```

## Live Activity Monitoring

F5 DoS for NGINX provides a range of application monitoring tools:

- F5 DoS for NGINX Dashboard: A dynamic interface for real-time monitoring and detailed views of Protected Objects.<br>
- F5 DoS for NGINX REST API: An interface that exposes comprehensive metrics for Protected Objects.<br>

A complete guide on configuring  F5 DoS for NGINX Live Activity Monitoring  be found here: [F5 DoS for NGINX Live Activity Monitoring](https://docs.nginx.com/nginx-app-protect-dos/monitoring/live-activity-monitoring/) <br>
Below is an example configuration that limits API location access to the local network using the allow and deny directives, and uses HTTP Basic Authentication to restrict the PATCH, POST, and DELETE methods to specific users.<br>
To view the dashboard, enter its address in your browser’s address bar.For example, http://192.168.1.23/dashboard-dos.html displays the dashboard page located in `/usr/share/nginx/html`, as specified by the root directive.<br>

```nginx
http {
    # ...
    server {
        listen 192.168.1.23;
        # ...
        location /api {
            limit_except GET {
                auth_basic "NGINX Plus API";
                auth_basic_user_file /path/to/passwd/file;
            }
            app_protect_dos_api;
            allow 192.168.1.0/24;
            deny  all;
        }
        location = /dashboard-dos.html {
            root   /usr/share/nginx/html;
        }
    }
}
```

## Example nginx.conf
```nginx
user  nginx;
worker_processes  auto;
error_log  /var/log/nginx/error.log error;

load_module modules/ngx_http_app_protect_dos_module.so;

events {
    worker_connections  1024;
}

http {
    app_protect_dos_arb_fqdn          10.1.10.22;
    app_protect_dos_accelerated_mitigation on;

    sendfile        on;
    tcp_nopush      on;
    keepalive_timeout 65;

    log_format log_dos
        ', vs_name_al=$app_protect_dos_vs_name, ip=$remote_addr, tls_fp=$app_protect_dos_tls_fp, '
        'outcome=$app_protect_dos_outcome, reason=$app_protect_dos_outcome_reason, '
        'ip_tls=$remote_addr:$app_protect_dos_tls_fp, ';

    server {
        listen       80 reuseport;
        server_name  example_srv;

        access_log /var/log/nginx/access.log log_dos if=$loggable;
        app_protect_dos_security_log_enable on;
        app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" syslog:server=10.197.30.219:5261;
        app_protect_dos_policy_file "/etc/app_protect_dos/BADOSDefaultPolicy.json";

        location / {
            app_protect_dos_enable on;
            app_protect_dos_name "main_app";
            set $loggable '0';
            access_log syslog:server=10.97.30.219:5561 log_dos if=$loggable;
            app_protect_dos_monitor uri=example_srv:80/ protocol=http1 timeout=7;
            proxy_pass http://10.197.24.136:3000;
        }
    }

    server {
        listen 800;

         location /api {
            limit_except GET {
                auth_basic "NGINX Plus API";
                auth_basic_user_file /path/to/passwd/file;
            }
            app_protect_dos_api;
            allow 192.168.1.0/24;
            deny  all;
        }
        location = /dashboard-dos.html {
            root   /usr/share/nginx/html;
        } 
    }
}
```
