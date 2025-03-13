---
description: Contains instructions for setting up the F5 NGINX Controller Agent to
  collect metrics for NGINX Plus instances.
docs: DOCS-509
title: Set up Metrics Collection
toc: true
weight: 120
type:
- how-to
---

## Before You Begin

- Before you can set up metrics collection, you first need to [install and start the F5 NGINX Controller Agent]({{< relref "/controller/admin-guides/install/install-nginx-controller-agent.md" >}}), so that the Agent can start pushing aggregated data to NGINX Controller.

## Objectives

Follow the steps in this guide to configure how metrics are collected and monitored.

## Configuring NGINX for Metrics Collection

In order to monitor an NGINX Plus instance, the NGINX Controller Agent needs to find the relevant NGINX control process and determine its key characteristics.

The Agent is able to automatically find all relevant NGINX configuration files, parse them, extract their logical structure, and send the associated JSON data to the Controller Server for further analysis and reporting.

### SSL Certificate Parsing and Analysis

To parse SSL certificate metadata, the NGINX Controller Agent uses standard `openssl(1)` functions. SSL certificates are parsed and analyzed only when the corresponding [settings]({{< relref "/controller/admin-guides/config-agent/configure-the-agent.md#default-agent-settings" >}}) are turned on. SSL certificate analysis is *on* by default.

To enable or disable analyzing SSL certs:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Agent**.
4. On the **Default agent settings** page, select or clear the **Analyze SSL certificates** box.

### Metrics from `/api`

NGINX Controller uses the `/api` location on the NGINX Plus instance to collect metrics.

When you push a configuration to an NGINX Plus instance, NGINX Controller automatically enables the `/api` location for that instance.

{{< note >}}
The `/api` location settings that NGINX Controller creates will override any settings that you have previously defined.
{{< /note >}}

If you use NGINX Controller solely to monitor your NGINX Plus instances, you may need to enable the `/api` location on your instances manually.
Refer to the [Configuring the API](https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/#configuring-the-api) section of the NGINX Plus Admin Guide for instructions.

For more information about the metrics list, refer to [Overview: Metrics and Metadata]({{< relref "/controller/analytics/metrics/overview-metrics-metadata.md" >}}).

### Metrics from `access.log` and `error.log`

The NGINX Controller Agent collects NGINX metrics from the [access.log](http://nginx.org/en/docs/http/ngx_http_log_module.html) and the [error.log](http://nginx.org/en/docs/ngx_core_module.html#error_log) by default.

You don't have to specifically point the Agent to either the NGINX configuration or the NGINX log files. The Agent should detect their location automatically. However, **you do need to make sure that the Agent can read the log files**.

To do so, verify that either the `nginx` user or the [user defined in the NGINX config](https://nginx.org/en/docs/ngx_core_module.html#user) -- such as `www-data` -- can read the log files. In addition, make sure that the log files are being written normally.

The Agent will try to detect the [log format](https://nginx.org/en/docs/http/ngx_http_log_module.html#log_format) for a particular log, so that it can parse the log correctly and extract relevant metrics data.

#### Enable Custom `access.log` Metrics

Some metrics included in the [NGINX Metrics reference]({{< relref "/controller/analytics/catalogs/metrics.md" >}}) are not available unless the corresponding variables are included in a custom [access.log](https://nginx.org/en/docs/http/ngx_http_log_module.html) format in the NGINX config.

{{< see-also >}}

- Read [Configuring Logging](https://docs.nginx.com/nginx/admin-guide/monitoring/logging/#setting-up-the-access-log) in the NGINX Admin Guide.
- View the complete list of [NGINX log variables](https://nginx.org/en/docs/varindex.html).

{{< /see-also >}}.

Take the steps in this section to enable the NGINX Controller Agent to collect metrics from custom `access.log` variables.

1. Add a new [access.log](https://nginx.org/en/docs/http/ngx_http_log_module.html) format to the NGINX configuration (or modify an existing one).

2. Add the desired [NGINX variables](https://nginx.org/en/docs/varindex.html) to the log format. For example:

   ```nginx
   log_format main_ext '$remote_addr - $remote_user [$time_local] "$request" '
   '$status $body_bytes_sent "$http_referer" '
   '"$http_user_agent" "$http_x_forwarded_for" '
   '"$host" sn="$server_name" '
   'rt=$request_time '
   'ua="$upstream_addr" us="$upstream_status" '
   'ut="$upstream_response_time" ul="$upstream_response_length" '
   'cs=$upstream_cache_status' ;
   ```

3. Use the extended log format in your access log configuration:

   ```nginx
   access_log /var/log/nginx/access.log main_ext;
   ```

   {{< note >}}
By default, the Controller Agent processes all access logs that it finds in your log directory. If you define a new log file with the extended log format that contains entries that are already being logged to another access log, your metrics might be counted twice. Refer to the [Agent configuration]({{< relref "/controller/admin-guides/config-agent/configure-the-agent.md" >}}) guide to learn how to exclude specific log files from processing.
   {{< /note >}}

4. Set the [error.log](https://nginx.org/en/docs/ngx_core_module.html#error_log) log level to `warn`.

   ```nginx
   error_log /var/log/nginx/error.log warn;
   ```

5. [Reload](https://nginx.org/en/docs/control.html) your NGINX configuration:

   ```bash
   service nginx reload
   ```

When the Controller Agent discovers these metrics, the NGINX Controller **Analytics Dashboards Overview** will automatically update with a predefined set of graphs.
You can also use these metrics to build more specific set of [custom Dashboards]({{< relref "/controller/analytics/dashboards/custom-dashboards.md" >}}).

### Collect Metrics from Syslog

If you set up the Controller Agent to [use Syslog]({{< relref "/controller/admin-guides/config-agent/configure-the-agent.md#logging-to-syslog" >}}), you need to set up the Controller Agent to collect metrics from Syslog.

Take the steps below to enable metrics collection from Syslog:

1. Edit the NGINX configuration file.

   1. Specify the `syslog` listener address as the first parameter to the [access.log](https://nginx.org/en/docs/http/ngx_http_log_module.html) directive.
   2. Include the `controller` tag and your preferred log format:

      ```nginx
      access_log syslog:server=127.0.0.1:12000,tag=controller,severity=info main_ext;
      ```

2. Reload NGINX:

   ```bash
   service nginx reload
   ```

   For more information, see [Controlling NGINX](https://nginx.org/en/docs/control.html).

{{< note >}}
To send the NGINX logs to both the existing logging facility and the NGINX Controller Agent, include a separate [access.log](https://nginx.org/en/docs/http/ngx_http_log_module.html) directive for each destination.
{{< /note >}}


## What's Next

- [Overview: NGINX Metrics and Metadata]({{< relref "/controller/analytics/metrics/overview-metrics-metadata.md" >}})
- [What to check if the Controller Agent isn't reporting metrics]({{< relref "/controller/support/troubleshooting-controller.md#troubleshooting-metrics" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
