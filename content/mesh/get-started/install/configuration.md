---
title: Configuration Options
weight: 100
description: Learn about F5 NGINX Service Mesh features and deployment options.
toc: true
docs: DOCS-679
type:
- concept
---

## Overview

This document provides an overview of the various options you can configure when deploying F5 NGINX Service Mesh. We strongly recommended that you review all of the available options discussed in this document *before* deploying NGINX Service Mesh.

{{< tip >}}
To manage your configuration after deployment, you can use the NGINX Service Mesh API.

Refer to the [API Usage Guide]( {{< ref "api-usage.md" >}} ) for more information.
{{< /tip >}}

{{< note >}}
For Helm users, the `nginx-meshctl deploy` command-line options map directly to Helm values. Alongside this guide, check out the [Helm Configuration Options]( {{< ref "/mesh/get-started/install/install-with-helm.md#configuration-options" >}} ).
{{< /note >}}

## Mutual TLS

For information on the mTLS configuration options--including how to use a custom Upstream Certificate Authority--see how to [Secure Mesh Traffic using mTLS]( {{< ref "/mesh/guides/secure-traffic-mtls.md#usage" >}} ).

## Access Control

By default, traffic flow is allowed for all services in the mesh.

To change this to a closed global policy and only allow traffic to flow between services that have access control policies defined, use the `--access-control-mode` flag when deploying NGINX Service Mesh:

```bash
nginx-meshctl deploy ... --access-control-mode deny
```

If you need to [modify the global access control mode]( {{< ref "api-usage.md#modifying-the-global-mesh-configuration" >}} ) after you've deployed NGINX Service Mesh, you can do so by using the API.

## Client Max Body Size

By default, NGINX allows a client request body to be up to 1m in size.

To change this value to a different size, use the `--client-max-body-size` flag when deploying NGINX Service Mesh:

```bash
nginx-meshctl deploy ... --client-max-body-size 5m
```

Setting the value to "0" allows for an unlimited request body size.

To configure the client max body size for a specific Pod, add the `config.nsm.nginx.com/client-max-body-size: <size>` annotation to the *PodTemplateSpec* of your Deployment, StatefulSet, and so on.

If you need to [modify the global client max body size]( {{< ref "api-usage.md#modifying-the-global-mesh-configuration" >}} ) after you've deployed NGINX Service Mesh, you can do so by using the API.

{{< see-also >}}
[NGINX core module documentation](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size) for `client_max_body_size`.
{{< /see-also >}}

## Logging

By default, the NGINX sidecar emits logs at the `warn` level.

To set the desired log level, use the `--nginx-error-log-level` flag when deploying NGINX Service Mesh:

```bash
nginx-meshctl deploy ... --nginx-error-log-level debug
```

All of the NGINX error log levels are supported, in the order of most to least verbose:

- `debug`,
- `info`,
- `notice`,
- `warn`,
- `error`,
- `crit`,
- `alert`,
- `emerg`

By default, the NGINX sidecar emits logs using the `default` format. The [supported formats](https://nginx.org/en/docs/http/ngx_http_log_module.html#log_format) are `default` and `json`.

To set the NGINX sidecar logging format, use the `--nginx-log-format` flag when deploying NGINX Service Mesh:

```bash
nginx-meshctl deploy ... --nginx-log-format json
```

If you need to [modify the log level or log format]( {{< ref "api-usage.md#modifying-the-global-mesh-configuration" >}} ) after you've deployed NGINX Service Mesh, you can do so by using the API.

## Load Balancing

By default, the NGINX sidecar uses the `least_time` load balancing method.

To set the desired load balancing method, use the `--nginx-lb-method` flag when deploying the
NGINX Service Mesh:

```bash
nginx-meshctl deploy ... --nginx-lb-method "random two least_conn"
```

To configure the load balancing method for a Service, add the `config.nsm.nginx.com/lb-method: <method>` annotation to the `metadata.annotations` field of your Service.

The supported methods (used for both `http` and `stream` blocks) are:

- `round_robin`
- `least_conn`
- `least_time`
- `least_time last_byte`
- `least_time last_byte inflight`
- `random`
- `random two`
- `random two least_conn`
- `random two least_time`
- `random two least_time=last_byte`

{{< note >}}
`least_time` and `random two least_time` are treated as "time to first byte" methods. `stream` blocks with either
of these methods are given the `first_byte` method parameter, and `http` blocks are given the `header` parameter.
{{< /note >}}

For more information on how these load balancing methods work, see [HTTP Load Balancing](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/) and [TCP and UDP Load Balancing](https://docs.nginx.com/nginx/admin-guide/load-balancer/tcp-udp-load-balancer/).

## Monitoring and Tracing

NGINX Service Mesh can connect to your Prometheus and tracing deployments. Refer to [Monitoring and Tracing]( {{< ref "/mesh/guides/monitoring-and-tracing.md" >}} ) for more information.

## Sidecar Proxy

NGINX Service Mesh works by injecting a sidecar proxy into Kubernetes resources. You can choose to inject the sidecar proxy into the YAML or JSON definitions for your Kubernetes resources in the following ways:

- [Automatic Injection]( {{< ref "/mesh/guides/inject-sidecar-proxy.md#automatic-proxy-injection" >}} )
- [Manual Injection]( {{< ref "/mesh/guides/inject-sidecar-proxy.md#manual-proxy-injection" >}} )

## Supported Labels and Annotations

NGINX Service Mesh supports the use of the labels and annotations listed in the tables below.
If not specified, then the global defaults will be used.

### Namespace Labels

{{% table %}}
| Label                                                                                                         | Values                |
|---------------------------------------------------------------------------------------------------------------|-----------------------|
| [injector.nsm.nginx.com/auto-inject]({{< ref "/mesh/guides/inject-sidecar-proxy.md#automatic-proxy-injection" >}}) | `enabled`, `disabled` |
{{% /table %}}

### Pod Labels

{{% table %}}
| Label                                                                                                         | Values                |
|---------------------------------------------------------------------------------------------------------------|-----------------------|
| [injector.nsm.nginx.com/auto-inject]({{< ref "/mesh/guides/inject-sidecar-proxy.md#automatic-proxy-injection" >}}) | `enabled`, `disabled` |
| [nsm.nginx.com/enable-ingress]({{< ref "/mesh/tutorials/kic/deploy-with-kic.md#secure-communication-between-nginx-plus-ingress-controller-and-nginx-service-mesh" >}}) | `true`, `false` |
| [nsm.nginx.com/enable-egress]({{< ref "/mesh/tutorials/kic/deploy-with-kic.md#enable-egress" >}})                                                                      | `true`, `false` |
{{% /table %}}

### Pod Annotations

{{% table %}}
| Annotation                                                                                                                                                        | Values                                 | Default       |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [config.nsm.nginx.com/mtls-mode]({{< ref "/mesh/guides/secure-traffic-mtls.md#change-the-mtls-setting-for-a-resource" >}})                                             | `off`, `permissive`, `strict`          | `permissive`  |
| [config.nsm.nginx.com/client-max-body-size](#client-max-body-size)                                                                                                | `0`, `64k`, `10m`, ...                 | `1m`          |
| [config.nsm.nginx.com/ignore-incoming-ports]({{< ref "/mesh/guides/inject-sidecar-proxy.md#ignore-specific-ports" >}})                                                 | list of port strings                   | ""            |
| [config.nsm.nginx.com/ignore-outgoing-ports]({{< ref "/mesh/guides/inject-sidecar-proxy.md#ignore-specific-ports" >}})                                                 | list of port strings                   | ""            |
| [config.nsm.nginx.com/default-egress-allowed]({{< ref "/mesh/tutorials/kic/deploy-with-kic.md#enable-egress" >}})                                                    | `true`, `false`                        | `false`       |
{{% /table %}}

The Pod labels and annotations should be added to the **PodTemplateSpec** of a Deployment, StatefulSet, and so on, **before** injecting the sidecar proxy.
For example, the following `nginx` Deployment is configured with an `mtls-mode` of `strict`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
      annotations:
        config.nsm.nginx.com/mtls-mode: strict
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

- When you need to update a label or annotation, be sure to edit the Deployment, StatefulSet, and so on; if you edit a Pod, then those edits will be overwritten if the Pod restarts.
- In the case of a standalone Pod, you should edit the Pod definition, then restart the Pod to load the new config.

### Service Annotations

{{% table %}}
| Annotation                                                                                                                                                        | Values                                 | Default       |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [config.nsm.nginx.com/lb-method](#load-balancing)                                                                                                                 | `least_conn`, `least_time`,            | `least_time`  |
|                                                                                                                                                                   | `least_time last_byte`,                |               |
|                                                                                                                                                                   | `least_time last_byte inflight`,       |               |
|                                                                                                                                                                   | `round_robin`, `random`, `random two`, |               |
|                                                                                                                                                                   | `random two least_conn`,               |               |
|                                                                                                                                                                   | `random two least_time`,               |               |
|                                                                                                                                                                   | `random two least_time=last_byte`      |               |
{{% /table %}}

Service annotations are added to the metadata field of the Service.
For example, the following Service is configured to use the `random` load balancing method:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
  annotations:
    config.nsm.nginx.com/lb-method: random
spec:
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

## Supported Protocols

NGINX Service Mesh supports HTTP and GRPC at the L7 protocol layer. Sidecars can proxy these protocols explicitly. When HTTP and GRPC protocols are configured, a wider range of traffic shaping and traffic control features are available.

NGINX Service Mesh provides TCP transport support for Services that employ other L7 protocols. Workloads are not limited to communicating via HTTP and GRPC alone. These workloads may not be able to use some of the advanced L7 functionality.

NGINX Service Mesh provides UDP transport applications that need one-way communication of datagrams. For bidirectional communication we recommend using TCP.

Protocols will be identified by the Service's port config, `.spec.ports`.

### Identification Rules

NGINX Service Mesh uses identification rules both on the incoming and outgoing side of application deployments to identify the kind of traffic that is being sent, as well as what traffic is intended for a particular application.

#### Outgoing

In a service spec, if the port config is named, the name will be used to identify the protocol. If the name contains a dash it will be split using the dash as a delimiter and the first portion used, for example, 'http-example' will set protocol 'http'.

If the port config sets a well-known port (`.spec.ports[].port`), this value will be used to determine protocol, for example, 80 will set protocol 'http'.

If none of these rules are satisfied the protocol will default to TCP.

For an example of how this is used, see [Deploy an Example App]( {{< ref "/mesh/tutorials/deploy-example-app.md" >}}) in the tutorials section.

#### Incoming

For a particular deployment or pod resource, the `containerPort` (`.spec.containers[].ports.containerPort`) field of the Pod spec is used to determine what traffic should be allowed to access your application. This is particularly important when using [strict mode]( {{< ref "/mesh/guides/secure-traffic-mtls.md" >}}) for denying unwanted traffic.

For an example of how this is used, see [Deploy an Example App]( {{< ref "/mesh/tutorials/deploy-example-app.md" >}}) in the tutorials section.

### Protocols

- HTTP - name 'http', port 80
- GRPC - name 'grpc'
- TCP  - name 'tcp'
- UDP  - name 'udp'

### Unavailable protocols

- SCTP

## Traffic Encryption

NGINX Service Mesh uses SPIRE -- the [SPIFFE](https://spiffe.io/) Runtime Environment -- to manage certificates for secure communication between proxies.

Refer to [Secure Mesh Traffic using mTLS]( {{< ref "/mesh/guides/secure-traffic-mtls.md">}} ) for more information about configuration options.

## Traffic Metrics

NGINX Service Mesh can export metrics to Prometheus, and provides a [custom dashboard](https://github.com/nginxinc/nginx-service-mesh/tree/main/examples/grafana) for visualizing metrics in Grafana.

Refer to the [Traffic Metrics]( {{< ref "/mesh/guides/smi-traffic-metrics.md">}} ) topic for more information.

## Traffic Policies

NGINX Service Mesh supports the SMI spec, which allows for a variety of functionality within the mesh, from traffic shaping to access control.

Refer to the [SMI GitHub repo](https://github.com/servicemeshinterface/smi-spec) to find out more about the SMI spec and how to configure it.

Refer to the [Traffic Policies]( {{< ref "smi-traffic-policies.md" >}} ) topic for examples of how you can use the SMI spec in NGINX Service Mesh.

## Environment

By default, NGINX Service Mesh deploys with the `kubernetes` configuration. If deploying in an Openshift environment, use the `--environment` flag to specify an alternative environment:

```bash
nginx-meshctl deploy ... --environment "openshift"
```

See [Considerations]({{< ref "/mesh/get-started/platform-setup/openshift.md" >}}) for when you're deploying in an OpenShift cluster.

## Headless Services

Avoid configuring traffic policies such as TrafficSplits, RateLimits, and CircuitBreakers for headless services. These policies will not work as expected because NGINX Service Mesh has no way to tie each pod IP address to its headless service.

When using NGINX Service Mesh, it is necessary to declare the port in a headless service in order for it to be matched. Without this declaration, traffic will not be routed correctly.

## UDP Proxying

UDP traffic proxying is turned off by default. You can activate it at deploy time using the `--enable-udp` flag. Linux kernel 4.18 or greater is required.

NGINX Service Mesh automatically detects and adjusts the `eth0` interface to support the 32 bytes of space required for PROXY Protocol V2.
See the [UDP and eBPF architecture]({{< ref "/mesh/about/architecture.md#udp-and-ebpf" >}}) section for more information.

NGINX Service Mesh does not detect changes made to the MTU in the pod at runtime.
If adding a CNI changes the MTU of the `eth0` interface of running pods, you should re-roll the affected pods to ensure those changes take place.
