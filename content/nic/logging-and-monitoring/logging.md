---
title: Logs available from NGINX Ingress Controller
toc: true
weight: 100
nd-content-type: reference
nd-product: NIC
nd-docs: DOCS-613
---

This document gives an overview of logging provided by F5 NGINX Ingress Controller.

NGINX Ingress Controller exposes the logs of the Ingress Controller process (The process that generates NGINX configuration and reloads NGINX to apply it) and NGINX access and error logs. 

All logs are sent to the standard output and error of the NGINX Ingress Controller process. To view the logs, you can execute the `kubectl logs` command for an Ingress Controller pod. 

For example:

```shell
kubectl logs <nginx-ingress-pod> -n nginx-ingress
```

## NGINX Ingress Controller Process Logs

The NGINX Ingress Controller process logs are configured through the `-log-level` command-line argument of the NGINX Ingress Controller, which sets the log level. 

The default value is `info`. Other options include: `trace`, `debug`, `info`, `warning`, `error` and `fatal`. 

The value `debug` is useful for troubleshooting: you will be able to see how NGINX Ingress Controller gets updates from the Kubernetes API, generates NGINX configuration and reloads NGINX.

Read more about NGINX Ingress Controller [command-line arguments]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md" >}}).

## NGINX Logs

NGINX includes two logs:

- *Access log*, where NGINX writes information about client requests in the access log right after the request is processed. The access log is configured via the [logging-related]({{< ref "/nic/configuration/global-configuration/configmap-resource.md#logging" >}}) ConfigMap keys:
  - `log-format` for HTTP and HTTPS traffic.
  - `stream-log-format` for TCP, UDP, and TLS Passthrough traffic.

    Additionally, you can disable access logging with the `access-log-off` ConfigMap key.
- *Error log*, where NGINX writes information about encountered issues of different severity levels. It is configured via the `error-log-level` [ConfigMap key]({{< ref "/nic/configuration/global-configuration.md#configmap-resource#logging" >}}). To enable debug logging, set the level to `debug` and also set the `-nginx-debug` [command-line argument]({{< ref "/nic/configuration/global-configuration.md#command-line-arguments" >}}), so that NGINX is started with the debug binary `nginx-debug`.

Read more about [NGINX logs]({{< ref "/nginx/admin-guide/monitoring/logging.md" >}}) from NGINX Admin guide.
