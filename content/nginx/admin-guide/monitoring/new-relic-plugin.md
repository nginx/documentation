---
description: Find what's new in version 2 of the NGINX and F5 NGINX Plus plug‑in for
  New Relic – more convenience, more metrics, richer visualization.
docs: DOCS-427
title: Monitoring NGINX and NGINX Plus with the New Relic Plug-In
toc: true
weight: 500
type:
- how-to
---

In March, 2013 we released the first version of the [“nginx web server” plug‑in](https://newrelic.com/instant-observability/nginx) for New Relic monitoring of the NGINX Open Source  software and F5 NGINX Plus. Since then, we’ve received lots of interest from users – we greatly appreciate it! The plug‑in continues to be one of the most popular New Relic plug‑ins, in spite of the few things that (we believe!) could be improved. If you don’t already have a New Relic account, [sign up](http://newrelic.com/).

We selected Ruby as the base language for the original plug‑in, because the New Relic platform itself is written in Ruby, the API was not yet published, and many things were changing quickly.

Later, after the launch of the New Relic platform, we continued to work on adding a number of improvements based on users’ feedback and our own vision of how to improve the overall usability of the NGINX monitoring plug‑in, and realized the need for further changes.

## What’s New?

Today, we are pleased to announce a major update of the NGINX plug‑in for New Relic, **version 2.0**, which includes the following changes:

- The plug‑in is rewritten in Python. You no longer need to install Ruby.
- The plug‑in is finally packaged. There are prebuilt packages for RHEL/CentOS‑based and Debian/Ubuntu‑based systems. An included init script enables you to easily set up autostart of the plug‑in.
- There are two new sections in the live activity monitoring dashboard, for NGINX Plus customers:

  - **Servers** – Additional summary counters for virtual servers whose `server` configuration block includes the [status_zone](https://nginx.org/en/docs/http/ngx_http_api_module.html#status_zone) directive
  - **Cache** – Cumulative stats for all configured caches
- Verbose logging is enabled by default.

## Installation

Download the [plug‑in and installation instructions](https://docs.newrelic.com/install/nginx/).

## Configuring the Plug‑In

The configuration file for the NGINX plug‑in is <span style="white-space: nowrap; font-weight:bold;">/etc/nginx-nr-agent/nginx-nr-agent.ini</span>. The minimal configuration includes:

- Your New Relic license key in the `newrelic_license_key` statement in the `global` section.

- At least one `source` section. The name of the section is used in log entries only, and can contain almost any character string you want. Two parameters are required:

  - `name` – NGINX instance name in the New Relic UI.
  - `url` – Full URL to the corresponding instance. The plug‑in accepts source data in the format generated when the [stub_status](https://nginx.org/en/docs/http/ngx_http_stub_status_module.html#stub_status) directive is included in the configuration of NGINX or NGINX Plus. It also supports the JSON‑formatted output generated when the [api](https://nginx.org/en/docs/http/ngx_http_api_module.html#api) directive is included in an NGINX Plus configuration.

You can include the optional `http_user` and `http_pass` statements to set HTTP basic authentication credentials in cases where the corresponding location is protected by the NGINX [auth_basic](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html#auth_basic) directive.

The default log file is <span style="white-space: nowrap; font-weight:bold;">/var/log/nginx-nr-agent.log</span>.

## Running the Plug‑In

You can manage the plug‑in with an init script. Run the <span style="white-space: nowrap;">`service` `nginx-nr-agent`</span> command with the `start`, `stop`, or `status` argument to start, stop, or display the status of the plug‑in, respectively.

When started from an init script, the plug‑in daemon runs as the `nobody` user.

You can start the plug‑in directly by running <span style="white-space: nowrap;">`/usr/bin/nginx-nr-agent.py`</span>, with the following optional parameters:

- <span style="white-space: nowrap;">`-c`</span>, <span style="white-space: nowrap;">`--config`</span> – Path to configuration file
- <span style="white-space: nowrap;">`-p`</span>, <span style="white-space: nowrap;">`--pidfile`</span>> – Path to PID file
- <span style="white-space: nowrap;">`-f`</span>, <span style="white-space: nowrap;">`--foreground`</span> – Do not detach from terminal (useful for debugging)

If everything is working as expected, the plug‑in appears as a tab in the New Relic UI:

[![image of NGINX instance in New Relic instances list](/nginx/images/0s-instances.png)](/nginx/images/0s-instances.png)

## Dashboard Examples

### Overview

The **Overview** tab displays the most basic metrics for the whole instance: number of active and idle connections, and request rate.

[![image of Overview tab in New Relic UI](/nginx/images/1s-overview.png)](/nginx/images/1s-overview.png)

### Connections

The **Connections** tab displays various metrics about client connections.

[![image of Connections tab in New Relic UI](/nginx/images/2s-connections.png)](/nginx/images/2s-connections.png)

### Requests

The **Requests** tab displays the number of requests currently being processed and the overall request rate.

[![image of Requests tab in New Relic UI](/nginx/images/3s-requests.png)](/nginx/images/3s-requests.png)

### Upstreams (NGINX Plus only)

The **Upstreams** tab displays detailed statistics about all configured upstream groups.

[![image of Upstreams tab in New Relic UI](/nginx/images/4s-upstreams.png)](/nginx/images/4s-upstreams.png)

### Servers (NGINX Plus only)

The **Servers** tab displays detailed statistics about all configured virtual server zones.

[![image of Servers tab in New Relic UI](/nginx/images/5s-servers.png)](/nginx/images/5s-servers.png)

### Cache (NGINX Plus only)

The **Cache** tab displays summary statistics for all configured caches.

[![image of Caches tab in New Relic UI](/nginx/images/6s-cache.png)](/nginx/images/6s-cache.png)

## What’s Next?

We plan to extend the plug‑in’s functionality with additional metrics for both NGINX and NGINX Plus, and your feedback is very important to us. Ideas, thoughts, questions? Let us know by commenting on this post.

Thanks for using NGINX and NGINX Plus!

To try NGINX Plus, start your <span style="white-space: nowrap;">[free 30-day trial](https://www.nginx.com/free-trial-request/)</span> today or [contact us](https://www.nginx.com/contact-sales/) for a demo.
