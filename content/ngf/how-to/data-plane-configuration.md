---
title: Data plane configuration
weight: 500
toc: true
type: how-to
product: NGF
docs: DOCS-000
---

Learn how to dynamically update the NGINX Gateway Fabric global data plane configuration.

## Overview

NGINX Gateway Fabric can dynamically update the global data plane configuration without restarting. The data plane configuration contains configuration for NGINX that is not available using the standard Gateway API resources. This includes such things as setting an OpenTelemetry collector config, disabling http2, changing the IP family, or setting the NGINX error log level.

The data plane configuration is stored in the NginxProxy custom resource, which is a namespace-scoped resource that can be attached to a GatewayClass or Gateway. When attached to a GatewayClass, the fields in the NginxProxy affect all Gateways that belong to the GatewayClass.
When attached to a Gateway, the fields in the NginxProxy only affect the Gateway. If a GatewayClass and its Gateway both specify an NginxProxy, the GatewayClass NginxProxy provides defaults that can be overridden by the Gateway NginxProxy. See the [Merging Semantics](#merging-semantics) section for more detail.

---

## Merging Semantics

NginxProxy resources are merged when a GatewayClass and a Gateway reference different NginxProxy resources.

For fields that are bools, integers, and strings:
- If a field on the Gateway's NginxProxy is unspecified (`nil`), the Gateway __inherits__ the value of the field in the GatewayClass's NginxProxy.
- If a field on the Gateway's NginxProxy is specified, its value __overrides__ the value of the field in the GatewayClass's NginxProxy.

For array fields:
- If the array on the Gateway's NginxProxy is unspecified (`nil`), the Gateway __inherits__ the entire array in the GatewayClass's NginxProxy.
- If the array on the Gateway's NginxProxy is empty, it __overrides__ the entire array in the GatewayClass's NginxProxy, effectively unsetting the field.
- If the array on the Gateway's NginxProxy is specified and not empty, it __overrides__ the entire array in the GatewayClass's NginxProxy.


### Merging Examples

This section contains examples of how NginxProxy resources are merged when they are attached to both a Gateway and its GatewayClass.

#### Disable HTTP/2 for a Gateway

A GatewayClass references the following NginxProxy which explicitly allows HTTP/2 traffic and sets the IPFamily to ipv4:

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: gateway-class-enable-http2
  namespace: default
spec:
  ipFamily: "ipv4"
  disableHTTP: false
```

To disable HTTP/2 traffic for a particular Gateway, reference the following NginxProxy in the Gateway's spec:

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: gateway-disable-http
  namespace: default
spec:
  disableHTTP: true
```

These NginxProxy resources are merged and the following settings are applied to the Gateway:

```yaml
ipFamily: "ipv4"
disableHTTP: true
```

#### Change Telemetry configuration for a Gateway

A GatewayClass references the following NginxProxy which configures telemetry:

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: gateway-class-telemetry
  namespace: default
spec:
  telemetry:
    exporter:
      endpoint: "my.telemetry.collector:9000"
      interval: "60s"
      batchSize: 20
    serviceName: "my-company"
    spanAttributes:
    - key: "company-key"
      value: "company-value"
```

To change the telemetry configuration for a particular Gateway, reference the following NginxProxy in the Gateway's spec:

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: gateway-telemetry-service-name
  namespace: default
spec:
  telemetry:
    exporter:
      batchSize: 50
      batchCount: 5
    serviceName: "my-app"
    spanAttributes:
    - key: "app-key"
      value: "app-value"
```

These NginxProxy resources are merged and the following settings are applied to the Gateway:

```yaml
  telemetry:
    exporter:
      endpoint: "my.telemetry.collector:9000"
      interval: "60s"
      batchSize: 50
      batchCount: 5
    serviceName: "my-app"
    spanAttributes:
    - key: "app-key"
      value: "app-value"
```

#### Disable Tracing for a Gateway

A GatewayClass references the following NginxProxy which configures telemetry:

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: gateway-class-telemetry
  namespace: default
spec:
  telemetry:
    exporter:
      endpoint: "my.telemetry.collector:9000"
      interval: "60s"
    serviceName: "my-company"
```

To disable tracing for a particular Gateway, reference the following NginxProxy in the Gateway's spec:

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: gateway-disable-tracing
  namespace: default
spec:
  telemetry:
    disabledFeatures:
    - DisableTracing
```

These NginxProxy resources are merged and the following settings are applied to the Gateway:

```yaml
telemetry:
    exporter:
      endpoint: "my.telemetry.collector:9000"
      interval: "60s"
    serviceName: "my-app"
    disabledFeatures:
    - DisableTracing
```

---

## Configuring the GatewayClass NginxProxy on Install

By default, the NginxProxy resource is not created when installing NGINX Gateway Fabric. However, you can set configuration options in the `nginx.config` Helm values, and the resource will be created and attached to the GatewayClass when NGINX Gateway Fabric is installed using Helm. You can also [manually create and attach](#manually-creating-nginxproxies) the resource after NGINX Gateway Fabric is already installed.

When installed using the Helm chart, the NginxProxy resource is named `<release-name>-proxy-config` and is created in the release Namespace.

**For a full list of configuration options that can be set, see the `NginxProxy spec` in the [API reference]({{< ref "/ngf/reference/api.md" >}}).**

{{< note >}} Some global configuration also requires an [associated policy]({{< ref "/ngf/overview/custom-policies.md" >}}) to fully enable a feature (such as [tracing]({{< ref "/ngf/how-to/monitoring/tracing.md" >}}), for example). {{< /note >}}

---

## Manually Creating NginxProxies

The following command creates a basic `NginxProxy` configuration that sets the IP family to `ipv4` instead of the default value of `dual`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: ngf-proxy-config
  namespace: default
spec:
  ipFamily: ipv4
EOF
```

**For a full list of configuration options that can be set, see the `NginxProxy spec` in the [API reference]({{< ref "/ngf/reference/api.md" >}}).**

---

### Attaching NginxProxy to GatewayClass

To attach the `ngf-proxy-config` NginxProxy to the GatewayClass:

```shell
kubectl edit gatewayclass nginx
```

This will open your default editor, allowing you to add the following to the `spec`:

```yaml
parametersRef:
    group: gateway.nginx.org
    kind: NginxProxy
    name: ngf-proxy-config
    namespace: default
```

After updating, you can check the status of the GatewayClass to see if the configuration is valid:

```shell
kubectl describe gatewayclass nginx
```

```text
...
Status:
  Conditions:
     ...
    Message:               parametersRef resource is resolved
    Observed Generation:   1
    Reason:                ResolvedRefs
    Status:                True
    Type:                  ResolvedRefs
```

If everything is valid, the `ResolvedRefs` condition should be `True`. Otherwise, you will see an `InvalidParameters` condition in the status.

---

### Attaching NginxProxy to Gateway

To attach the `ngf-proxy-config` NginxProxy to a Gateway:

```shell
kubectl edit gateway <gateway-name>
```

This will open your default editor, allowing you to add the following to the `spec`:

```yaml
infrastructure:
    parametersRef:
        group: gateway.nginx.org
        kind: NginxProxy
        name: ngf-proxy-config
        namespace: default
```

After updating, you can check the status of the Gateway to see if the configuration is valid:

```shell
kubectl describe gateway <gateway-name>
```

```text
...
Status:
  Conditions:
     ...
    Message:               parametersRef resource is resolved
    Observed Generation:   1
    Reason:                ResolvedRefs
    Status:                True
    Type:                  ResolvedRefs
```

If everything is valid, the `ResolvedRefs` condition should be `True`. Otherwise, you will see an `InvalidParameters` condition in the status.

---

## Configure the data plane log level

You can use the `NginxProxy` resource to dynamically configure the Data Plane Log Level.

The following command creates a basic `NginxProxy` configuration that sets the log level to `warn` instead of the default value of `info`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: ngf-proxy-config
spec:
  logging:
    errorLevel: warn
EOF
```

To view the full list of supported log levels, see the `NginxProxy spec` in the [API reference]({{< ref "/ngf/reference/api.md" >}}).

{{< note >}}For `debug` logging to work, NGINX needs to be built with `--with-debug` or "in debug mode". NGINX Gateway Fabric can easily
be [run with NGINX in debug mode](#run-nginx-gateway-fabric-with-nginx-in-debug-mode) upon startup through the addition
of a few arguments. {{</ note >}}

---

### Run NGINX Gateway Fabric with NGINX in debug mode

To run NGINX Gateway Fabric with NGINX in debug mode, follow the [installation document]({{< ref "/ngf/installation/installing-ngf" >}}) with these additional steps:

Using Helm: Set `nginx.debug` to true.

Using Kubernetes Manifests: Under the `nginx` container of the deployment manifest, add `-c` and `rm -rf /var/run/nginx/*.sock && nginx-debug -g 'daemon off;'`
as arguments and add `/bin/sh` as the command. The deployment manifest should look something like this:

```text
...
- args:
  - -c
  - rm -rf /var/run/nginx/*.sock && nginx-debug -g 'daemon off;'
  command:
  - /bin/sh
...
```

---

## Configure PROXY protocol and RewriteClientIP settings

When a request is passed through multiple proxies or load balancers, the client IP is set to the IP address of the server that last handled the request. To preserve the original client IP address, you can configure `RewriteClientIP` settings in the `NginxProxy` resource. `RewriteClientIP` has the fields: _mode_, _trustedAddresses_ and _setIPRecursively_.

**Mode** determines how the original client IP is passed through multiple proxies and the way the load balancer is set to receive it. It can have two values:

  1. `ProxyProtocol` is a protocol that carries connection information from the source requesting the connection to the destination for which the connection was requested.
  2. `XForwardedFor` is a multi-value HTTP header that is used by proxies to append IP addresses of the hosts that passed the request.

The choice of mode depends on how the load balancer fronting NGINX Gateway Fabric receives information.

**TrustedAddresses** are used to specify the IP addresses of the trusted proxies that pass the request. These can be in the form of CIDRs, IPs, or hostnames. For example, if a load balancer is forwarding the request to NGINX Gateway Fabric, the IP address of the load balancer should be specified in the `trustedAddresses` list to inform NGINX that the forwarded request is from a known source.

**SetIPRecursively** is a boolean field used to enable recursive search when selecting the client's address from a multi-value header. It is applicable in cases where we have a multi-value header containing client IPs to select from, i.e., when using `XForwardedFor` mode.

The following command creates an `NginxProxy` resource with `RewriteClientIP` settings that set the mode to ProxyProtocol and sets a CIDR in the list of trusted addresses to find the original client IP address.

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: ngf-proxy-config
spec:
  config:
    rewriteClientIP:
      mode: ProxyProtocol
      trustedAddresses:
      - type: CIDR
        value "76.89.90.11/24"
EOF
```

For the full configuration API, see the `NginxProxy spec` in the [API reference]({{< ref "/ngf/reference/api.md" >}}).

{{< note >}} When sending curl requests to a server expecting proxy information, use the flag `--haproxy-protocol` to avoid broken header errors. {{< /note >}}
