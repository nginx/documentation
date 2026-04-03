---
title: Set up security monitoring
description: Configure NGINX Plus with F5 WAF for NGINX to forward security events to NGINX One Console
weight: 100
nd-content-type: how-to
nd-product: NONECO
---

This guide walks you through configuring your NGINX Plus data plane to send security telemetry to NGINX One Console. You'll install F5 WAF for NGINX, configure the security dashboard log profile, and set up NGINX Agent to forward security events.

## Prerequisites

- NGINX Plus installed and running on your data plane
- Root or sudo access on the data plane system
- NGINX One Console access with permissions to add instances

## Verify NGINX Plus is running

Before you begin, confirm that NGINX Plus is installed and running on your system.

1. Run the following command to check the NGINX Plus service status:

```bash
sudo systemctl status nginx
```

Your output should show that the service is active and running:

```
● nginx.service - NGINX Plus - high performance web server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: active (running) since Wed 2026-03-11 17:26:52 UTC; 1 week 1 day ago
       Docs: https://www.nginx.com/resources/
   Main PID: 3682 (nginx)
      Tasks: 3 (limit: 4586)
     Memory: 4.3M (peak: 4.9M)
        CPU: 807ms
```
If NGINX Plus is not installed, see the [NGINX Plus installation guide]({{< ref "/content/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).


## Install F5 WAF for NGINX

Install F5 WAF for NGINX on your data plane following the [installation instructions for your operating system]({{< ref "/content/waf/install/virtual-environment.md" >}}).

After installation, continue with the next section to configure the security dashboard log profile.

## Configure the security dashboard log profile

The security dashboard uses the default log profile to capture security violations. This is a pre-configured, immutable log profile that is automatically compiled for all available WAF compiler versions. For more information about the default log profile, see [Default log profile]({{< ref "/nginx-one-console/waf-security-dashboard/default-log-profile.md" >}}).

To configure the security dashboard, create the `/etc/app_protect/conf/secops_dashboard.json` file with the following content:

1. Create the file:

```bash
sudo touch /etc/app_protect/conf/secops_dashboard.json
```

2. Add the log profile configuration:

```bash
sudo tee /etc/app_protect/conf/secops_dashboard.json > /dev/null << 'EOF'
{
  "filter": {
    "request_type": "illegal"
  },
  "content": {
    "format": "user-defined",
    "format_string": "%support_id%|%ip_client%|%src_port%|%dest_ip%|%dest_port%|%vs_name%|%policy_name%|%method%|%uri%|%protocol%|%request_status%|%response_code%|%outcome%|%outcome_reason%|%violation_rating%|%blocking_exception_reason%|%is_truncated_bool%|%sig_ids%|%sig_names%|%sig_cves%|%sig_set_names%|%threat_campaign_names%|%sub_violations%|%x_forwarded_for_header_value%|%violations%|%violation_details%|%request%|%geo_location%",
    "max_request_size": "2048",
    "max_message_size": "64k",
    "escaping_characters": [
     {
      "from": "|",
      "to": "%7C"
     }
    ]
  }
}
EOF
```

## Enable F5 WAF for NGINX in your configuration

Update your NGINX configuration to enable F5 WAF for NGINX and specify the security dashboard log profile.

### Update the main NGINX configuration

Edit `/etc/nginx/nginx.conf` and add the `load_module` directive at the top:

```nginx
user  nginx;
worker_processes  auto;
load_module modules/ngx_http_app_protect_module.so;
error_log  /var/log/nginx/error.log notice;
pid        /run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    keepalive_timeout  65;

    include /etc/nginx/conf.d/*.conf;
}
```

### Configure a server block with F5 WAF for NGINX

Edit `/etc/nginx/conf.d/default.conf` to add the F5 WAF for NGINX directives:

```nginx
server {
    listen       80 default_server;
    server_name  localhost;
    app_protect_enable on;
    app_protect_policy_file "/etc/app_protect/conf/NginxStrictPolicy.json";
    app_protect_security_log "/etc/app_protect/conf/secops_dashboard.json" syslog:server=127.0.0.1:1514;
    app_protect_security_log_enable on;
    
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```

Make sure you specify port `1514` for the syslog server. NGINX Agent listens on this port to receive security events.

## Verify your NGINX configuration

Test your NGINX configuration for syntax errors:

```bash
sudo nginx -t
```

You should see output like this:

```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Restart NGINX Plus to apply the changes:

```bash
sudo systemctl restart nginx
```

Verify NGINX Plus is running after the restart:

```bash
sudo systemctl status nginx
```

## Install NGINX Agent

NGINX Agent forwards security telemetry from F5 WAF for NGINX to NGINX One Console.

1. In NGINX One Console, go to **Instances** and select **Add Instance**.

2. Select **Generate new key**. This generates your data plane key and displays a `curl` command for agent installation.

3. Copy the `curl` command and run it in your terminal:

```bash
curl <command-shown-in-console>
```

Wait a few minutes for the system to appear in NGINX One Console.

4. Verify the agent is running:

```bash
sudo systemctl status nginx-agent
```

You should see output like this:

```
● nginx-agent.service - NGINX Agent
     Loaded: loaded (/etc/systemd/system/nginx-agent.service; enabled; preset: enabled)
     Active: active (running) since Thu 2026-03-19 23:53:00 UTC; 23s ago
       Docs: https://github.com/nginx/agent#readme
   Main PID: 24716 (nginx-agent)
      Tasks: 8 (limit: 4586)
     Memory: 26.0M (peak: 27.2M)
        CPU: 414ms
```

## Configure NGINX Agent to forward security events

Enable NGINX Agent to collect and forward security telemetry from F5 WAF for NGINX.

1. Edit `/etc/nginx-agent/nginx-agent.conf` and add the following telemetry pipeline configuration at the end of the file:

```yaml
collector:
  exporters:
    debug: {}
  processors:
    batch:
      "logs":
        send_batch_size: 1000
        timeout: 30s
        send_batch_max_size: 1000
  pipelines:
   logs:
     "default-security-events":
       receivers: ["tcplog/nginx_app_protect"]
       processors: ["batch/logs"]
       exporters: ["debug","otlp/default"]
```

This configuration batches security events with a 30-second timeout and a maximum batch size of 1000 events. Events are forwarded to NGINX One Console through the `otlp/default` exporter.

2. Restart NGINX Agent to apply the changes:

```bash
sudo systemctl restart nginx-agent
```

3. Verify NGINX Agent is running:

```bash
sudo systemctl status nginx-agent
```

## Verify the security event pipeline

Check that NGINX Agent successfully started the syslog receiver:

```bash
sudo tail /var/log/nginx-agent/agent.log | grep "syslogserver"
```

You should see a log entry like this:

```
time=2026-03-20T00:05:10.212Z level=INFO msg="Found available local NGINX App Protect syslogserver configured on port 1514"
```

To debug security events being sent to NGINX One Console, tail the agent logs:

```bash
sudo tail /var/log/nginx-agent/opentelemetry-collector-agent.log -f
```

## Test security event detection

Generate test security violations to verify the pipeline is working.

1. Trigger some violations with these example requests:

```bash
curl -X SEARCH -k -v 'http://127.0.0.1/helloworld'

curl -k -v 'http://127.0.0.1/a=<script>getAllMoneyV2()</script>'
```

You should receive a response indicating the request was rejected:

```html
<html><head><title>Request Rejected</title></head><body>The requested URL was rejected. Please consult with your administrator...
```

2. Verify that security events are being sent to NGINX One Console:

```bash
sudo tail /var/log/nginx-agent/opentelemetry-collector-agent.log -n 200
```

Look for log entries showing the violations being forwarded.

Your security monitoring setup is now complete. Security events from F5 WAF for NGINX are now being forwarded to NGINX One Console, where you can monitor and analyze them in the security dashboard.
