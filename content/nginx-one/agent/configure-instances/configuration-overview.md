---
title: Configuration overview
toc: true
weight: 300
nd-docs: DOCS-1879
---

This page describes how to configure F5 NGINX Agent using configuration files, CLI (Command line interface) flags, and environment variables.

{{< call-out "note" >}}

- NGINX Agent interprets configuration values set by configuration files, CLI flags, and environment variables in the following priorities:

  1. CLI flags overwrite configuration files and environment variable values.
  2. Environment variables overwrite configuration file values.
  3. Config files are the lowest priority and config settings are superseded if either of the other options is used.

- You must open any required firewall ports or add SELinux/AppArmor rules for the ports and IPs you want to use.

{{< /call-out >}}

## Configuration via Configuration Files 

The NGINX Agent configuration file is created using a YAML structure and can be found in `/etc/nginx-agent/nginx-agent.conf`

1. Edit the configuration file `sudo vim /etc/nginx-agent/nginx-agent.conf`
2. Add the log property 
```bash
log:
  level: debug 
```
3. Save and exit 
4. `sudo systemctl restart nginx-agent`

## Configuration via CLI Parameters

From a command line terminal: 
```bash
sudo nginx-agent \
      --log-level=debug
```

## Configuration via Environment Variables
Environment variables are another way to set configuration values, especially in containerized deployments or CI/CD pipelines. 

```bash
sudo docker run \
  --env=NGINX_AGENT_LOG_LEVEL=debug \
  -d agent
```

### NGINX Agent configuration options

{{< bootstrap-table "table table-striped table-bordered" >}}
| **Environment Variable**                         | **Command-Line Option**                             | **Description**                                                                                              | **Default Value**                                      |
|--------------------------------------------------|---------------------------------------------------|--------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|
| NGINX_AGENT_LOG_LEVEL                          | --log-level                                      | The desired verbosity level for logging messages from nginx-agent. Available options: panic, fatal, error, info, and debug.       | info                                                |
| NGINX_AGENT_LOG_PATH                           | --log-path                                       | The path to output log messages to. If the default path doesn't exist, logs are output to stdout/stderr.     | /var/log/nginx-agent/nginx-agent.log                |
| NGINX_AGENT_DATA_PLANE_NGINX_RELOAD_MONITORING_PERIOD | --data-plane-config-nginx-reload-monitoring-period                                           | The amount of time used to monitor NGINX after a configuration reload (units in seconds).                     | N/A                                                    |
| NGINX_AGENT_DATA_PLANE_NGINX_TREAT_WARNINGS_AS_ERRORS | --data-plane-config-nginx-treat-warnings-as-errors | Warning messages in the NGINX error logs are treated as errors after a configuration reload.                  | N/A                                                    |
| NGINX_AGENT_DATA_PLANE_NGINX_EXCLUDE_LOGS      | --data-plane-config-nginx-exclude-logs          | Specify one or more log paths to exclude from metrics collection and error monitoring (Unix PATH format).      | N/A                                                    |
| NGINX_AGENT_ALLOWED_DIRECTORIES               | --allowed-directories                           | A comma-separated list of paths granting read/write permissions for the agent.                                | N/A                                                    |
| NGINX_AGENT_FEATURES                          | --features                                      | Comma-separated list of features enabled for the agent.                                                      | N/A                                                    |
| NGINX_AGENT_LABELS                            | --labels                                        | A comma-separated list of key-value pairs defining agent labels (for example: env=prod,team=backend).                            | N/A                                                    |
| NGINX_AGENT_COMMAND_SERVER_HOST               | --command-server-host                           | Specifies target hostname for the command and control server.                                                | N/A                                                    |
| NGINX_AGENT_COMMAND_SERVER_PORT               | --command-server-port                           | Specifies the port of the command and control server.                                                        | N/A                                                    |
| NGINX_AGENT_COMMAND_AUTH_TOKEN                | --command-auth-token                            | Authentication token used to establish communication with the command server.                                | N/A                                                    |
| NGINX_AGENT_COMMAND_AUTH_TOKENPATH            | --command-auth-tokenpath                        | File path for the authentication token used with the server.                                                 | N/A                                                    |
| NGINX_AGENT_COMMAND_TLS_CERT                  | --command-tls-cert                              | Certificate file path required for TLS communication.                                                        | N/A                                                    |
| NGINX_AGENT_COMMAND_TLS_KEY                   | --command-tls-key                               | Certificate key file path required for TLS communication.                                                    | N/A                                                    |
| NGINX_AGENT_COMMAND_TLS_CA                    | --command-tls-ca                                | CA certificate file path for TLS communication.                                                              | N/A                                                    |
| NGINX_AGENT_COMMAND_TLS_SKIP_VERIFY           | --command-tls-skip-verify                       | **For Testing Only:** Disables client-side verification of the server's certificate chain and hostname.       | N/A                                                    |
| NGINX_AGENT_COMMAND_TLS_SERVER_NAME           | --command-tls-server-name                       | Specifies server name sent in the TLS handshake configuration.                                               | N/A                                                    |
| NGINX_AGENT_INSTANCE_WATCHER_MONITORING_FREQUENCY | --instance-watcher-monitoring-frequency         | Frequency (in seconds) for instance monitoring.                                                              | N/A                                                    |
| NGINX_AGENT_HEALTH_WATCHER_MONITORING_FREQUENCY   | --health-watcher-monitoring-frequency           | Frequency (in seconds) for monitoring NGINX health changes.                                                  | N/A                                                    |
| NGINX_AGENT_FILE_WATCHER_MONITORING_FREQUENCY     | --file-watcher-monitoring-frequency             | Frequency (in seconds) for monitoring file changes.                                                          | N/A                                                    |
| NGINX_AGENT_COLLECTOR_CONFIG_PATH             | --collector-config-path                         | Path to OpenTelemetry (OTel) Collector configuration file.                                                   | /etc/nginx-agent/opentelemetry-collector-agent.yaml  |
| NGINX_AGENT_COLLECTOR_EXTENSIONS_HEALTH_PATH  | --collector-extensions-health-path              | Path configured for health check server communication with OTel Collector.                                   | /                                                    |
| NGINX_AGENT_COLLECTOR_EXTENSIONS_SERVER_HOST  | --collector-extensions-health-server-host       | Hostname for publishing health check statuses of OTel Collector.                                             | localhost                                            |
| NGINX_AGENT_COLLECTOR_EXTENSIONS_SERVER_PORT  | --collector-extensions-health-server-port       | Port for publishing health check statuses of OTel Collector.                                                 | 13133                                                |
| NGINX_AGENT_COLLECTOR_EXTENSIONS_TLS_CA       | --collector-extensions-health-tls-ca            | CA certificate file path for TLS communication with OTel health server.                                      | N/A                                                    |
| NGINX_AGENT_COLLECTOR_EXTENSIONS_TLS_CERT     | --collector-extensions-health-tls-cert          | TLS Certificate file path for communication with OTel health server.                                         | N/A                                                    |
| NGINX_AGENT_COLLECTOR_EXTENSIONS_TLS_KEY      | --collector-extensions-health-tls-key           | File path for TLS key used when connecting with OTel health server.                                           | N/A                                                    |
| NGINX_AGENT_COLLECTOR_PROCESSORS_BATCH_SEND_BATCH_TIMEOUT    | --collector-processors-batch-send-batch-timeout                                               | Maximum time duration for sending batch data metrics regardless of size.                                      | 200ms
{{< /bootstrap-table >}}
