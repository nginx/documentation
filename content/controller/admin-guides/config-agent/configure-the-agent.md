---
description: Customize the F5 NGINX Controller Agent configuration.
docs: DOCS-510
title: Configure the NGINX Controller Agent
toc: true
weight: 110
type:
- tutorial
---

## Overview

Follow the steps in this guide to customize the F5 NGINX Controller Agent configuration.

## Default Agent Settings

To access the **Default Agent Settings** page:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Agent**.

On the **Default Agent Settings** page, you can set the following default settings for the NGINX Controller Agent:

- **NGINX configuration file analysis**. This setting is enabled by default.
- **Periodic NGINX configuration syntax checking with "nginx -t"**. This setting is disabled by default.
- **Analyzing SSL certs**. This setting is enabled by default.

## Enable /api Location

NGINX Controller uses the `/api` location on the NGINX Plus instance to collect metrics.

When you push a configuration to an NGINX Plus instance, NGINX Controller automatically enables the `/api` location for that instance.

{{< note >}}
The `/api` location settings that NGINX Controller creates will override any settings that you have previously defined.
{{< /note >}}

If you use NGINX Controller solely to monitor your NGINX Plus instances, you may need to enable the `/api` location on your instances manually.
Refer to the [Configuring the API](https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/#configuring-the-api) section of the NGINX Plus Admin Guide for instructions.

## Controller Agent Configuration File

The configuration file for the NGINX Controller Agent is located at `/etc/controller-agent/agent.conf`. This configuration file is a text-based file.

## Change the API Key

When you first [install the NGINX Controller Agent]({{< relref "/controller/admin-guides/install/install-nginx-controller-agent.md" >}}), your API key is written to the `agent.conf` file automatically. If you ever need to change the API key, you can edit the following section in `agent.conf` accordingly:

``` nginx
[credentials]
api_key = YOUR_API_KEY
```

## Change the Hostname and UUID

To create unique objects for monitoring, the NGINX Controller Agent must be able to extract a valid hostname from the system. The hostname is also used as one of the components for generating a unique identifier. Essentially, the hostname and the UUID (universally unique identifier) unambiguously identify a particular instance of the NGINX Controller Agent to NGINX Controller. If the hostname or the UUID are changed, the NGINX Controller Agent and the server will register a new object for monitoring.

The NGINX Controller Agent tries its best to determine the correct hostname. If the Agent cannot determine the hostname, you can set the hostname in the `agent.conf` file. Check for the following section, and provide the desired hostname here:

``` nginx
[credentials]
..
hostname = myhostname1
```

The hostname should be real. The NGINX Controller Agent won't start unless a valid hostname is defined. The following *are not* valid hostnames:

- localhost
- localhost.localdomain
- localhost6.localdomain6
- ip6-localhost

{{< note >}}

You can use the above method to replace the system's hostname with an arbitrary alias. Keep in mind that if you redefine the hostname for a live object, the existing object will be marked as failed in the NGINX Controller user interface. Redefining the hostname in the NGINX Controller Agent's configuration creates a new UUID and a new system for monitoring.

Alternatively, you can define an alias for the host in the NGINX Controller user interface. Go to the **Graphs** page, select the system that you want to update, and click the gear icon.

{{< /note >}}

## Preserving the UUID across OS upgrades

The UUID is generated based on a combination of the hostname and underlying OS functions. An upgrade to the OS may lead to a new UUID and cause previously registered agents to be offline.

If your use case requires that the UUID persist across upgrades, you can set the `store_uuid` option in `agent.conf`:

``` nginx
[credentials]
...
store_uuid = True
```

After restarting the Controller Agent -- `service controller-agent restart` -- the UUID will be persisted to `agent.conf` and used for future instance detection.

## Set the Path to the NGINX Configuration File

The NGINX Controller Agent detects the NGINX configuration file automatically. You shouldn't need to point the NGINX Controller Agent to the `nginx.conf` file explicitly.

{{< caution >}}You should not make manual changes to the `nginx.conf` file on NGINX Plus instances that are managed by NGINX Controller. Manually updating the `nginx.conf` file on managed instances may adversely affect system performance. In most cases, NGINX Controller will revert or overwrite manual updates made to `nginx.conf`.{{< /caution >}}

If, for some reason, the NGINX Controller Agent cannot find the NGINX configuration, you can use the following option in `/etc/controller-agent/agent.conf` to point to the configuration file:

``` nginx
[nginx]
configfile = /etc/nginx/nginx.conf
```

{{< note >}} We recommend using this option only as a workaround if needed. If you do need to add the path to the NGINX config file, we ask that you [contact NGINX Support]({{< relref "/controller/support/contact-support.md" >}}) so they can help troubleshoot the issue.{{< /note >}}

## Set Host Tags

You can define arbitrary tags on a "per-host" basis. Tags can be configured in the Controller user interface on the **Graphs** page, or set in the `/etc/controller-agent/agent.conf` file:

``` nginx
[credentials]
tags = foo bar foo:bar
```

{{< note >}} Any changes to instance Tags made in the Controller user interface will overwrite the values stored in `agent.conf`.{{< /note >}}

You can use tags to build custom graphs, configure alerts, and filter the systems on the **Graphs** page in the Controller user interface.

## Logging to Syslog

{{< see-also >}}
[NGINX Admin Guide - Logging to Syslog](https://docs.nginx.com/nginx/admin-guide/monitoring/logging/#logging-to-syslog)
{{< /see-also >}}

The NGINX Controller Agent can collect NGINX log files using `syslog`. This could be useful when you don't keep the NGINX logs on disk, or when monitoring a container environment such as Docker with NGINX Controller.

To configure the NGINX Controller Agent to send logs to `syslog`:

1. Add the following to the `/etc/controller-agent/agent.conf` file:

    ``` nginx
    [listeners]
    keys = syslog-default

    [listener_syslog-default]
    address = 127.0.0.1:12000
    ```

2. Restart the NGINX Controller Agent. This will reload the configuration, and the Agent will start listening on the specified IP address and port:

    ``` nginx
    # service controller-agent restart
    ```

    {{< important >}}
Make sure you [add the `syslog` settings to your NGINX configuration file]({{< relref "/controller/admin-guides/config-agent/configure-metrics-collection.md#collect-metrics-from-syslog" >}}) as well.
    {{< /important >}}

## Exclude Certain NGINX Log Files

By default, the NGINX Controller Agent tries to find and watch all `access.log` files described in the NGINX configuration. If there are multiple log files where the same request is logged, the metrics may be counted more than once.

To exclude specific NGINX log files from the metrics collection, add lines similar to the following to `/etc/controller-agent/agent.conf`:

``` nginx
[nginx]
exclude_logs=/var/log/nginx/app1/*,access-app1-*.log,sender1-*.log
```

## Set Up a Proxy

If your system is in a DMZ environment without direct access to NGINX Controller, the only way for the NGINX Controller Agent to report collected metrics to NGINX Controller is through a proxy.

The NGINX Controller Agent will use the usual environment variables common on Linux systems (for example, `https_proxy` or `HTTP_PROXY`). However, you can also define HTTPS proxy manually in `agent.conf`. This can be done as follows:

``` nginx
[proxies]
https = https://10.20.30.40:3030
..
```

## Controller Agent Logfile

The NGINX Controller Agent maintains its log file in `/var/log/nginx-controller/agent.log`.

Upon installation, the NGINX Controller Agent's log rotation schedule is added to `/etc/logrotate.d/controller-agent`.

The normal level of logging for the NGINX Controller Agent is `INFO`. If you ever need to debug the NGINX Controller Agent, change the level to `DEBUG` as described below.

{{< caution >}}
The size of the NGINX Controller Agent's log file can proliferate in `DEBUG` mode. You should use `DEBUG` mode only for troubleshooting purposes.
{{< /caution >}}

### Change the Agent Log Level

To change the log level for the NGINX Controller Agent:

1. Edit the `[loggers]` section of the NGINX Controller Agent configuration file -- `/etc/controller-agent/agent.conf`.
1. Set the `level` to one of the following:

   - error
   - info
   - debug
   - trace

    ```plaintext
    [loggers]
    level = DEBUG
    ...
    ```

1. [Restart the NGINX Controller Agent]({{< relref "/controller/admin-guides/install/agent-restart.md#Starting-and-Stopping-the-Agent" >}}) to make the changes take effect.

## What's Next

- [Set up Metrics Collection]({{< relref "/controller/admin-guides/config-agent/configure-metrics-collection.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
