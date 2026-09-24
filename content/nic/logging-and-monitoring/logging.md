---
title: Logs available from NGINX Ingress Controller
toc: true
weight: 100
f5-content-type: reference
f5-product: NGINX Ingress Controller
f5-docs: DOCS-613
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

### Resource attributes on process log lines

In a multi-tenant cluster, these attributes let you filter, route, and triage the NGINX Ingress Controller process log lines by namespace or resource, and trace a log line back to the object that produced it, without manual investigation. To make this possible, NGINX Ingress Controller stamps its process log lines with the identity of the Kubernetes resource it is processing.

Three attributes carry this identity:

- `resource_namespace`: the resource's namespace.
- `resource_kind`: the resource's kind, such as `Ingress`, `VirtualServer`, `VirtualServerRoute`, `TransportServer`, or `Policy`.
- `resource_name`: the resource's name.

These attributes appear only on NGINX Ingress Controller process log lines emitted at any log level while it processes a resource. They do not appear in the NGINX access or error logs.

One, two, or all three attributes can appear, depending on the code path. A line about a namespace-scoped operation may carry only `resource_namespace` and `resource_kind`, while a line about a specific object carries all three.

How the attributes render depends on the [`-log-format`]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md#cmdoption-log-format" >}}) command-line argument. The `glog` format renders them as space-separated `key=value` pairs, placed after the `file:line]` bracket and before the message. The `json` format emits them as native JSON fields, and the `text` format emits them as `key=value` fields.

The following example shows an NGINX Ingress Controller log line in the default `glog` format. It is illustrative, not runnable:

```text
W20260806 14:07:23.267011   1 controller.go:3057] resource_namespace=log-test-1 resource_kind=VirtualServer resource_name=webapp1 Error trying to get the secret log-test-1/tls-secret for VirtualServer webapp1: secret doesn't exist or of an unsupported type
```

## NGINX Logs

NGINX includes two logs:

- *Access log*, where NGINX writes information about client requests in the access log right after the request is processed. The access log is configured via the [logging-related]({{< ref "/nic/configuration/global-configuration/configmap-resource.md#logging" >}}) ConfigMap keys:
  - `log-format` for HTTP and HTTPS traffic.
  - `stream-log-format` for TCP, UDP, and TLS Passthrough traffic.

    Additionally, you can disable access logging with the `access-log-off` ConfigMap key.
- *Error log*, where NGINX writes information about encountered issues of different severity levels. It is configured via the `error-log-level` [ConfigMap key]({{< ref "/nic/configuration/global-configuration.md#configmap-resource#logging" >}}). To enable debug logging, set the level to `debug` and also set the `-nginx-debug` [command-line argument]({{< ref "/nic/configuration/global-configuration.md#command-line-arguments" >}}), so that NGINX is started with the debug binary `nginx-debug`.

Read more about [NGINX logs]({{< ref "/nginx/admin-guide/monitoring/logging.md" >}}) from NGINX Admin guide.
