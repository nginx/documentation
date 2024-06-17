---
description: Follow the instructions in this guide to install and configure the NGINX
  Agent on your data plane systems.
docs: DOCS-800
doctypes:
- tutorial
tags:
- docs
title: Install and Configure NGINX Agent
toc: true
weight: 100
---

## Prerequisites

This section lists the prerequisites for installing and configuring NGINX Agent. Follow the steps below to complete the requirements:

1. [NGINX Management Suite is installed on a server]({{< relref "/nms/installation/vm-bare-metal/_index.md" >}}).

    {{<note>}} When installing and configuring NGINX Management Suite, take note of the fully qualified domain name (FQDN) and gRPC port number. You'll need this information to properly configure the NGINX Agent to communicate with NGINX Management Suite.
    {{</note>}}

2. Make sure NGINX is running on your instance:

    ```bash
    ps aux | grep nginx
    ```

3. If a previous version of NGINX Agent was installed, you must stop the current NGINX Agent process before running the NGINX Agent install script. To check if any NGINX Agent processes are running, run the following command:

    ```bash
    ps aux | grep nginx-agent
    ```

4. If a previous version of NGINX Agent was installed, make sure to uninstall `nginx-agent-selinux` before running the NGINX Agent install script.
To see if `nginx_agent_selinux` is installed, run the following command:

    {{<tabs name="install_repo">}}
    {{%tab name="CentOS, RHEL, and RPM-Based"%}}

  ```bash
  rpm -qa | grep nginx_agent_selinux
  ```

   {{%/tab%}}
   {{%tab name="Debian, Ubuntu, and Deb-Based"%}}

  ```bash
  dpkg -s nginx_agent_selinux
  ```

    {{%/tab%}}
    {{</tabs>}}

5. Review the [Technical Specifications]({{< relref "/nms/tech-specs.md" >}}) guide for system requirements.

---

## Install NGINX Agent

You can choose one of the following two methods to install the NGINX Agent on your data plane host:

- Install via the NGINX Management Suite API Gateway
- Install from packages downloaded from [MyF5 Customer Portal](https://account.f5.com/myf5) or from your NGINX/F5 sales team.

{{< note >}} You can also install NGINX Agent in the following ways:

- From the [GitHub releases](https://docs.nginx.com/nginx-agent/installation-upgrade/installation-github/)
- From the [NGINX Repository](https://docs.nginx.com/nginx-agent/installation-upgrade/installation-oss/)
- From the [NGINX Plus Repository](https://docs.nginx.com/nginx-agent/installation-upgrade/installation-plus/).

{{< /note >}}

### Install using the API

{{< include "agent/installation/install-agent-api.md" >}}

---

## Enable and Start NGINX Agent

Run the following command to enable and start the NGINX Agent service:

```bash
sudo systemctl enable nginx-agent --now
```

---

## Verifying NGINX Agent is Running and Registered

Run the following command on your data plane to verify that the NGINX Agent process is running:

```bash
ps aux | grep nginx-agent
```

You should see output that looks similar to the following example:

```text
root      293850  109  1.1 1240056 23536 ?       Ssl  22:00   0:07 /usr/local/bin/nginx-agent
vagrant   293866  0.0  0.0   8160   736 pts/0    S+   22:00   0:00 grep --color=auto nginx-agent
```

Once you've verified the NGINX Agent is running on your data plane, you should confirm it's registered with NGINX Management Suite. You can do this two ways:

{{<tabs name="verify-nginx">}}

{{%tab name="API"%}}

Send an API request similar to the following example to get the inventory list. Your instance should be listed.

  ```bash
  curl -u <user>:<password> https://<NMS_FQDN>/api/platform/v1/systems | jq
  ```

{{%/tab%}}

{{%tab name="WEBUI"%}}

In a web browser, go to the FQDN for your NGINX Management Suite host and log in. The registered instance is shown in the **Instances** list.

  ![Registered instances](/install/registered-instance.png)

{{%/tab%}}

{{</tabs>}}

<br>

Once you've verified the NGINX Agent instance is registered with NGINX Management Suite, no additional action is required for monitoring the instance.

{{<note>}}
If you need to remove the instance, ensure that the NGINX Agent service is stopped first. Then you can remove the instance from the inventory.
{{</note>}}

---

## Configuring the NGINX Agent

The following sections explain how to configure the NGINX Agent using configuration files, CLI flags, and environment variables.

{{<note>}}

- The NGINX Agent interprets configuration values set by configuration files, CLI flags, and environment variables in the following priorities:

  1. CLI flags overwrite configuration files and environment variable values.
  2. Environment variables overwrite configuration file values.
  3. Config files are the lowest priority and config settings are superseded if either of the other options is used.

- The NGINX Agent is configured by default to connect to the NGINX Management Suite on port 443 based on the address used to download the install script. If this setting doesn't work, you can change the `server` fields in the `nginx-agent.conf` file. Instructions are provided in the following sections.

- Open any required firewall ports or SELinux/AppArmor rules for the ports and IPs you want to use.

{{</note>}}

### Configure with Config Files

The configuration files for the NGINX Agent are `/etc/nginx-agent/nginx-agent.conf` and `/var/lib/nginx-agent/agent-dynamic.conf`. These files have comments at the top indicating their purpose.

{{<note>}}If you're running Instance Manager 2.10.1 or earlier or NGINX Agent 2.25.1 or earlier, the `agent-dynamic.conf` file is located in `/etc/nginx-agent/`.{{</note>}}

Examples of the configuration files are provided below:

<details open>
    <summary>example nginx-agent.conf</summary>

{{<note>}}
In the following example `nginx-agent.conf` file, you can change the `server.host` and `server.grpcPort` to connect to the NGINX Management Suite.

If NGINX Agent was previously installed for data reporting purposes only, you may need to find and remove the following line from the NGINX Agent configuration file:

```none
features: registration,dataplane-status
```

{{</note>}}

```nginx {hl_lines=[13]}
#
# /etc/nginx-agent/nginx-agent.conf
#
# Configuration file for NGINX Agent.
#
# This file tracks agent configuration values that are meant to be statically set. There
# are additional agent configuration values that are set via the API and agent install script
# which can be found in /var/lib/nginx-agent/agent-dynamic.conf.

# specify the server grpc port to connect to
server:
  # host of the control plane
  host: <NMS_FQDN>
  grpcPort: 443
# tls options
tls:
  # enable tls in the nginx-agent setup for grpcs
  # default to enable to connect with secure connection but without client cert for mtls
  enable: true
  # controls whether the server certificate chain and host name are verified.
  # for production use, see instructions for configuring TLS
  skip_verify: false
log:
  # set log level (panic, fatal, error, info, debug, trace; default "info")
  level: info
  # set log path. if empty, don't log to file.
  path: /var/log/nginx-agent/
nginx:
  # path of NGINX logs to exclude
  exclude_logs: ""
# data plane status message / 'heartbeat'
dataplane:
  status:
    # poll interval for dataplane status - the frequency the agent will query the dataplane for changes
    poll_interval: 30s
    # report interval for dataplane status - the maximum duration to wait before syncing dataplane information if no updates have been observed
    report_interval: 24h
metrics:
  # specify the size of a buffer to build before sending metrics
  bulk_size: 20
  # specify metrics poll interval
  report_interval: 1m
  collection_interval: 15s
  mode: aggregated

# OSS NGINX default config path
# path to aux file dirs can also be added
config_dirs: "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms:/etc/app_protect"

extensions:
  - nginx-app-protect

# Enable reporting NGINX App Protect details to the control plane.
nginx_app_protect:
  # Report interval for NGINX App Protect details - the frequency the NGINX Agent checks NGINX App Protect for changes.
  report_interval: 15s
  # Enable precompiled publication from the NGINX Management Suite (true) or perform compilation on the data plane host (false).
  precompiled_publication: true
```

</details>


<details open>
    <summary>example agent-dynamic.conf</summary>

```yaml
#
# /var/lib/nginx-agent/agent-dynamic.conf
#
# Dynamic configuration file for NGINX Agent.
#
# The purpose of this file is to track agent configuration
# values that can be dynamically changed via the API and the agent install script.
# You may edit this file, but API calls that modify the tags on this system will
# overwrite the tag values in this file.
#
# The agent configuration values that API calls can modify are as follows:
#    - tags
#
# The agent configuration value that the agent install script can modify are as follows:
#    - instance_group

instance_group: devenv-group
tags:
  - devenv
  - test
```

</details>


### NGINX Agent CLI Flags & Usage {#nginx-agent-cli-flags-usage}

This section displays the configurable options for the NGINX Agent that can be set with CLI flags. See the CLI flags and their uses in the figure below:

<details open>
  <summary>NGINX Agent CLI flags & usage</summary>

```text
Usage:
  nginx-agent [flags]
  nginx-agent [command]

Available Commands:
  completion  Generate completion script.
  help        Help about any command

Flags:
      --api-cert string                                  The cert used by the Agent API.
      --api-host string                                  The host used by the Agent API. (default "127.0.0.1")
      --api-key string                                   The key used by the Agent API.
      --api-port int                                     The desired port to use for nginx-agent to expose for HTTP traffic.
      --config-dirs string                               Defines the paths that you want to grant nginx-agent read/write access to. This key is formatted as a string and follows Unix PATH format. (default "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms")
      --dataplane-report-interval duration               The amount of time the agent will report on the dataplane. After this period of time it will send a snapshot of the dataplane information. (default 24h0m0s)
      --dataplane-status-poll-interval duration          The frequency the agent will check the dataplane for changes. Used as a "heartbeat" to keep the gRPC connections alive. (default 30s)
      --display-name string                              The instance's 'name' value.
      --features strings                                 A comma-separated list of features enabled for the agent. (default [registration,nginx-config-async,nginx-ssl-config,nginx-counting,metrics,metrics-throttle,dataplane-status,process-watcher,file-watcher,activity-events,agent-api])
  -h, --help                                             help for nginx-agent
      --instance-group string                            The instance's 'group' value.
      --log-level string                                 The desired verbosity level for logging messages from nginx-agent. Available options, in order of severity from highest to lowest, are: panic, fatal, error, info, debug, and trace. (default "info")
      --log-path string                                  The path to output log messages to. If the default path doesn't exist, log messages are output to stdout/stderr. (default "/var/log/nginx-agent")
      --metrics-bulk-size int                            The amount of metrics reports collected before sending the data back to the server. (default 20)
      --metrics-collection-interval duration             Sets the interval, in seconds, at which metrics are collected. (default 15s)
      --metrics-mode string                              Sets the desired metrics collection mode: streaming or aggregation. (default "aggregated")
      --metrics-report-interval duration                 The polling period specified for a single set of metrics being collected. (default 1m0s)
      --nginx-config-reload-monitoring-period duration   The duration the NGINX Agent will monitor error logs after a NGINX reload (default 10s)
      --nginx-exclude-logs string                        One or more NGINX access log paths that you want to exclude from metrics collection. This key is formatted as a string and multiple values should be provided as a comma-separated list.
      --nginx-socket string                              The NGINX Plus counting unix socket location. (default "unix:/var/run/nginx-agent/nginx.sock")
      --nginx-treat-warnings-as-errors                   On nginx -t, treat warnings as failures on configuration application.
      --server-command string                            The name of the command server sent in the tls configuration.
      --server-grpcport int                              The desired GRPC port to use for nginx-agent traffic.
      --server-host string                               The IP address of the server host. IPv4 addresses and hostnames are supported.
      --server-metrics string                            The name of the metrics server sent in the tls configuration.
      --server-token string                              An authentication token that grants nginx-agent access to the commander and metrics services. Auto-generated by default. (default "750d0148-c4b2-499a-9011-ca5a8c752d52")
      --tags strings                                     A comma-separated list of tags to add to the current instance or machine, to be used for inventory purposes.
      --tls-ca string                                    The path to the CA certificate file to use for TLS.
      --tls-cert string                                  The path to the certificate file to use for TLS.
      --tls-enable                                       Enables TLS for secure communications.
      --tls-key string                                   The path to the certificate key file to use for TLS.
      --tls-skip-verify                                  Only intended for demonstration, sets InsecureSkipVerify for gRPC TLS credentials
  -v, --version                                          version for nginx-agent

Use "nginx-agent [command] --help" for more information about a command.
```

{{< note >}}
The following commands were deprecated In Instance Manager v2.1:

- `--instance-name`
- `--location`

{{< /note >}}

</details>

#### NGINX Agent Config Dirs Option

Use the `--config-dirs` command-line option, or the `config_dirs` key in the `nginx-agent.conf` file, to identify the directories the NGINX Agent can read from or write to. This setting also defines the location to which you can upload config files when using NGINX Management Suite Instance Manager. The NGINX Agent cannot write to directories outside the specified location when updating a config and cannot upload files to directories outside of the configured location.
The NGINX Agent follows NGINX configuration directives to file paths outside the designated directories and reads certificates' metadata. The NGINX Agent uses the following directives:

- [`ssl_certificate`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate)

### NGINX Agent Environment Variables

This section displays the configurable options for the NGINX Agent that can be set with environment variables. A list of the configurable environment variables can be seen below:

<details open>
  <summary>NGINX Agent Environment Variables</summary>

```text
- NGINX_AGENT_INSTANCE_GROUP
- NGINX_AGENT_DISPLAY_NAME
- NGINX_AGENT_FEATURES
- NGINX_AGENT_LOG_LEVEL
- NGINX_AGENT_LOG_PATH
- NGINX_AGENT_PATH
- NGINX_AGENT_METRICS_COLLECTION_INTERVAL
- NGINX_AGENT_METRICS_MODE
- NGINX_AGENT_METRICS_BULK_SIZE
- NGINX_AGENT_METRICS_REPORT_INTERVAL
- NGINX_AGENT_NGINX_EXCLUDE_LOGS
- NGINX_AGENT_NGINX_SOCKET
- NGINX_AGENT_SERVER_GRPCPORT
- NGINX_AGENT_SERVER_HOST
- NGINX_AGENT_SERVER_TOKEN
- NGINX_AGENT_SERVER_COMMAND
- NGINX_AGENT_SERVER_METRICS
- NGINX_AGENT_TAGS
- NGINX_AGENT_TLS_CA
- NGINX_AGENT_TLS_CERT
- NGINX_AGENT_TLS_ENABLE
- NGINX_AGENT_TLS_KEY
- NGINX_AGENT_TLS_SKIP_VERIFY
- NGINX_AGENT_CONFIG_DIRS
- NGINX_AGENT_DATAPLANE_REPORT_INTERVAL
- NGINX_AGENT_DATAPLANE_STATUS_POLL_INTERVAL
- NGINX_AGENT_NGINX_APP_PROTECT_REPORT_INTERVAL
- NGINX_AGENT_ADVANCED_METRICS_AGGREGATION_PERIOD
- NGINX_AGENT_ADVANCED_METRICS_PUBLISHING-PERIOD
- NGINX_AGENT_ADVANCED_METRICS_SOCKET_PATH
- NGINX_AGENT_ADVANCED_METRICS_TABLE_SIZES_LIMITS_PRIORITY_TABLE_MAX_SIZE
- NGINX_AGENT_ADVANCED_METRICS_TABLE_SIZES_LIMITS_PRIORITY_TABLE_THRESHOLD
- NGINX_AGENT_ADVANCED_METRICS_TABLE_SIZES_LIMITS_STAGING_TABLE_MAX_SIZE
- NGINX_AGENT_ADVANCED_METRICS_TABLE_SIZES_LIMITS_STAGING_TABLE_THRESHOLD
```

</details>

### Enable NGINX App Protect WAF Status Reporting

You can configure NGINX Agent to report the following NGINX App Protect WAF installation information to NGINX Management Suite:

- the current version of NGINX App Protect WAF
- the current status of NGINX App Protect WAF (active or inactive)
- the Attack Signatures package version
- the Threat Campaigns package version

You can also configure NGINX Agent to enable the publication of precompiled NGINX App Protect policies and log profiles from the NGINX Management Suite.

To enable NGINX App Protect WAF reporting or precompiled publication, edit the `/etc/nginx-agent/nginx-agent.conf` to add the following directives:

```yaml
# path to aux file dirs can also be added
config_dirs: "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms:/etc/app_protect"

# Enable necessary NAP extension
extensions:
    - nginx-app-protect

nginx_app_protect:
  # Report interval for NGINX App Protect details - the frequency the NGINX Agent checks NGINX App Protect for changes.
  report_interval: 15s
  # Enable precompiled publication from the NGINX Management Suite (true) or perform compilation on the data plane host (false).
  precompiled_publication: true
```

Additionally, you can use the agent installation script to add these fields:

  ```bash
  # Download install script via API
  curl https://<NMS_FQDN>/install/nginx-agent > install.sh

  # Specify the -m | --nginx-app-protect-mode flag to set up management of NGINX App Protect on
  # the instance. In the example below we specify 'precompiled-publication' for the flag value
  # which will make the config field 'precompiled_publication' set to 'true', if you would like to
  # set the config field 'precompiled_publication' to 'false' you can specify 'none' as the flag value.
  sudo sh ./install.sh --nginx-app-protect-mode precompiled-publication
  ```

---

### Enable NGINX Plus Advanced Metrics

- To enable NGINX Plus advanced metrics, follow the steps in the [Install NGINX Plus Metrics Module]({{< relref "/nms/nginx-agent/install-nginx-plus-advanced-metrics.md" >}}) guide.

---

## SELinux for NGINX Agent

This section explains how to install and configure the SELinux policy for the NGINX Agent.

### Installing NGINX Agent SELinux Policy Module

The NGINX Agent package includes the following SELinux files:

- `/usr/share/man/man8/nginx_agent_selinux.8.gz`
- `/usr/share/selinux/devel/include/contrib/nginx_agent.if`
- `/usr/share/selinux/packages/nginx_agent.pp`

To load the NGINX Agent policy, run the following commands:

{{< include "installation/agent-selinux.md" >}}

### Adding Ports for NGINX Agent SELinux Context

You can configure the NGINX Agent to work with SELinux. Make sure you add external ports to the firewall exception list.

The following example shows how to allow external ports outside the HTTPD context. You may need to enable NGINX to connect to these ports.

```bash
sudo setsebool -P httpd_can_network_connect 1
```

For additional information on using NGINX with SELinux, refer to the guide [Using NGINX and NGINX Plus with SELinux](https://www.nginx.com/blog/using-nginx-plus-with-selinux/).

---

## Secure the NGINX Agent with mTLS

{{< important >}}By default, communication between the NGINX Agent and NGINX Management Suite is unsecured.{{< /important >}}

For instructions on how configure mTLS to secure communication between the NGINX Agent and NGINX Management Suite, see [NGINX Agent TLS Settings](https://docs.nginx.com/nginx-agent/configuration/encrypt-communication/).

---

## NGINX Metrics

After you register an NGINX instance with NGINX Management Suite, the NGINX Agent will collect and report metrics. For more information about the metrics that are reported, see [Overview: Instance Metrics]({{< relref "/nms/nim/about/overview-metrics.md" >}}).

## Container Support
NGINX Agent is a companion daemon for NGINX Open Source or NGINX Plus instances and must run in the same container to work. The NGINX Agent repository includes [Dockerfiles](https://github.com/nginx/agent/tree/main/scripts/docker/official/) that can be used to build custom container images. Images are created with an NGINX Open Source or NGINX Plus instance and are available for various operating systems.

See the requirements and supported operating systems in the [NGINX Agent Technical Specifications](https://docs.nginx.com/nginx-agent/technical-specifications/) topic.

See the [Build Container Images](https://docs.nginx.com/nginx-agent/installation-upgrade/container-environments/docker-images/) topic for instructions on building container images.
