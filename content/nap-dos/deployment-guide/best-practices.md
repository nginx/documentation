---
title: Best Practices
description: "Configure F5 DoS for NGINX using recommended settings for protected objects, monitor directives, and security logging."
keywords: "F5 DoS for NGINX, best practices, configuration, protected object, monitor directive, security log, NGINX configuration"
nd-docs: DOCS-666
toc: true
weight: 130
nd-content-type: how-to
nd-product: F5DOSN
nd-summary: >
  Configure protected objects with unique names, add the monitor directive, and enable security logging to improve detection accuracy and observability.
  F5 DoS for NGINX uses protected objects and monitor directives to build a behavioral baseline and identify denial-of-service threats.
  These settings apply to any deployment where F5 DoS for NGINX is already installed.
---

This guide shows how to configure F5 DoS for NGINX to protect a proxy server.

## F5 DoS Configuration

### Load Module

```nginx
load_module modules/ngx_http_app_protect_dos_module.so;
```

### Enable

Add the directive in the appropriate context. You can set it in `location`, `server`, or `http` blocks:

```nginx
app_protect_dos_enable on;
```

#### Set a Protected Object Name
Choose a unique name. You can set it in location, server, or http blocks.

```nginx
app_protect_dos_name po-example;
```

{{< call-out "note" "Protected Object name" >}}
Although optional, specifying a name for each Protected Object (PO) is strongly recommended. It improves organization and makes troubleshooting easier. If no name is provided, the virtual server gets an auto-generated name using the following syntax:
{{< /call-out >}}

```nginx
line_number-server_name:seq-location_name
Example: 30-backend:1-/abc
```

Where:

- `line number` — the line number of the `server {` block in `nginx.conf` (for example, `30`)
- `server name` — taken from the `server_name` directive (for example, `backend`)
- `seq` — `0` for the server block; increments for each location block (`1`, `2`, `3`, …)
- `location name` — the name of the location (for example, `/abc`)

**Capacity limits**

- Up to 300 Protected Objects in versions up to 4.3
- Up to 1,000 Protected Objects in versions 4.4 and later


### Set a Monitor directive
The `app_protect_dos_monitor` directive monitors the stress level of a Protected Object by generating requests from localhost (127.0.0.1) that traverse your NGINX configuration like normal client traffic (through the same `server` / `location` / `proxy_pass` chain).  
**This directive is mandatory for optimal accuracy (it may be omitted only when using HTTP/1.1, though it is still strongly recommended).**
```nginx
app_protect_dos_monitor uri=<server_name[:port]/path> [protocol=http1|http2|grpc|websocket] [timeout=<number>] [proxy_protocol=on|off];
```
 
- `uri` is the value of `server_name`, optionally followed by `:port`, and then the location path.  
  Examples: `my_server/`, `example_server:81/abc`  
 
For full configuration details, see [Directives and Policy]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#monitor-directive-app_protect_dos_monitor" >}}).

**Monitor directive best practice**

- Monitor the same virtual host and path that your users hit. Set `uri=` to the `server_name[:port]/path` that matches the `server_name` and `listen` directives, **not** to the upstream IP:port.

Examples:

For `server_name "my_server"` on port `80` and path `/` (port 80 is the default, so it can be omitted):
```nginx
    app_protect_dos_monitor uri=my_server/;
```
 
For `server_name "serv"` on port `81` with location path `/abc`:
```nginx
    app_protect_dos_monitor uri=serv:81/abc protocol=http1 timeout=7;
```

A full example with upstream:

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
 
- Avoid monitors that short-circuit upstreams (for example, `return 200` locally); this under-estimates stress.
- Set `timeout` slightly above your upstream p95/p99 latency under normal load, but low enough to react quickly under stress.
- Monitor traffic originates from `127.0.0.1`. Exclude it from rate and connection limits as needed.
- Define the monitor inside each protected `location` block.

## Arbitrator

The Arbitrator is required when more than one F5 DoS for NGINX instance is deployed. Its primary function is to ensure all instances share the same state for each Protected Object.

For configuration details, see [F5 DoS for NGINX Arbitrator]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md#f5-dos-for-nginx-arbitrator" >}}).

Enable the F5 DoS for NGINX Arbitrator in the `http` context of the `nginx.conf` file:

```nginx
app_protect_dos_arb_fqdn 10.1.10.22;
```

## EBPF manager

The eBPF Manager is a high-performance component that simplifies and secures the deployment of eBPF (Extended Berkeley Packet Filter) programs for advanced networking use cases.

Enable the L4-accelerated mitigation feature in the `http` context of the `nginx.conf` file:

```nginx
app_protect_dos_accelerated_mitigation on;
```

## ELK Dashboards

ELK stands for Elasticsearch, Logstash, and Kibana. Logstash receives logs from F5 DoS for NGINX, normalizes them, and stores them in the Elasticsearch index. Kibana lets you visualize and navigate the logs using purpose-built dashboards.

For configuration details, see [F5 DoS for NGINX ELK Dashboards](https://github.com/f5devcentral/nap-dos-elk-dashboards).

F5 DoS directives should appear in your `nginx.conf` as shown. Replace `ip_kibana` with the hostname of the server running your ELK Docker container:

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

- F5 DoS for NGINX Dashboard: A dynamic interface for real-time monitoring and detailed views of Protected Objects.
- F5 DoS for NGINX REST API: An interface that exposes comprehensive metrics for Protected Objects.

For configuration details, see [F5 DoS for NGINX Live Activity Monitoring]({{< ref "/nap-dos/monitoring/live-activity-monitoring.md" >}}).

The following example limits API location access to the local network using the `allow` and `deny` directives, and uses HTTP Basic Authentication to restrict `PATCH`, `POST`, and `DELETE` methods to specific users.
To view the dashboard, enter its address in your browser's address bar. For example, `http://192.168.1.23/dashboard-dos.html` displays the dashboard page located in `/usr/share/nginx/html`, as specified by the `root` directive.

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
        app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" syslog:server=<SYSLOG_SERVER_IP>:5261;
        app_protect_dos_policy_file "/etc/app_protect_dos/BADOSDefaultPolicy.json";

        location / {
            app_protect_dos_enable on;
            app_protect_dos_name "main_app";
            set $loggable '0';
            access_log syslog:server=<SYSLOG_SERVER_IP>:5561 log_dos if=$loggable;
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
