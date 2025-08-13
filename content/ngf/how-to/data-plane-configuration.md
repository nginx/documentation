---
title: Data plane configuration
weight: 500
toc: true
type: how-to
product: NGF
nd-docs: DOCS-1838
---

Learn how to dynamically update the NGINX Gateway Fabric global data plane configuration.

## Overview

NGINX Gateway Fabric can dynamically update the global data plane configuration without restarting. The data plane configuration contains configuration for NGINX that is not available using the standard Gateway API resources. This includes options such as configuring an OpenTelemetry collector, disabling HTTP/2, changing the IP family, modifying infrastructure-related fields, and setting the NGINX error log level.

The data plane configuration is stored in the `NginxProxy` custom resource, which is a namespace-scoped resource that can be attached to a GatewayClass or Gateway. When attached to a GatewayClass, the fields in the NginxProxy affect all Gateways that belong to the GatewayClass.
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

## Configuring the GatewayClass NginxProxy on install

By default, an `NginxProxy` resource is created in the same namespace where NGINX Gateway Fabric is installed, attached to the GatewayClass. You can set configuration options in the `nginx` Helm value section, and the resource will be created and attached using the set values. You can also [manually create and attach](#manually-creating-nginxProxies) specific `NginxProxy` resources to target different Gateways.

When installed using the Helm chart, the NginxProxy resource is named `<release-name>-proxy-config` and is created in the release Namespace.

**For a full list of configuration options that can be set, see the `NginxProxy spec` in the [API reference]({{< ref "/ngf/reference/api.md" >}}).**

{{< call-out "note" >}} Some global configuration also requires an [associated policy]({{< ref "/ngf/overview/custom-policies.md" >}}) to fully enable a feature (such as [tracing]({{< ref "/ngf/monitoring/tracing.md" >}}), for example). {{< /call-out >}}

---

## Manually Creating NginxProxies

The following command creates a basic `NginxProxy` configuration in the `default` namespace that sets the IP family to `ipv4` instead of the default value of `dual`:

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

For a full list of configuration options that can be set, see the `NginxProxy spec` in the [API reference]({{< ref "/ngf/reference/api.md" >}}).

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
```

{{< call-out "note" >}} The `NginxProxy` resource must reside in the same namespace as the Gateway it is attached to. {{< /call-out >}}

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

You can use the `NginxProxy` resource to dynamically configure the log level.

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

{{< call-out "note" >}}For `debug` logging to work, NGINX needs to be built with `--with-debug` or "in debug mode". NGINX Gateway Fabric can easily
be [run with NGINX in debug mode](#run-nginx-gateway-fabric-with-nginx-in-debug-mode) upon startup through the addition
of a few arguments. {{< /call-out >}}

---

### Run NGINX Gateway Fabric with NGINX in debug mode

To run NGINX Gateway Fabric with NGINX in debug mode, during [installation]({{< ref "/ngf/install/" >}}), follow these additional steps:

- **Helm**: Set _nginx.debug_ to _true_.
- **Manifests**: Set  _spec.kubernetes.deployment.container.debug_ field in the _NginxProxy_ resource to _true_.

To change NGINX mode **after** deploying NGINX Gateway Fabric, use the _NginxProxy_ _spec.kubernetes.deployment.container.debug_ field.

The following command creates a basic _NginxProxy_ configuration that sets both the NGINX mode and log level to _debug_.

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: ngf-proxy-config
spec:
  logging:
    errorLevel: debug
  kubernetes:
    deployment:
      container:
        debug: true
EOF
```

{{< call-out "note" >}} When modifying any _deployment_ field in the _NginxProxy_ resource, any corresponding NGINX instances will be restarted. {{< /call-out >}}

---

## Configure PROXY protocol and RewriteClientIP settings

When a request is passed through multiple proxies or load balancers, the client IP is set to the IP address of the server that last handled the request. To preserve the original client IP address, you can configure `RewriteClientIP` settings in the `NginxProxy` resource. `RewriteClientIP` has the fields: _mode_, _trustedAddresses_ and _setIPRecursively_.

**Mode** determines how the original client IP is passed through multiple proxies and the way the load balancer is set to receive it. It can have two values:

  1. `ProxyProtocol` is a protocol that carries connection information from the source requesting the connection to the destination for which the connection was requested.
  2. `XForwardedFor` is a multi-value HTTP header that is used by proxies to append IP addresses of the hosts that passed the request.

The choice of mode depends on how the load balancer fronting NGINX Gateway Fabric receives information.

**TrustedAddresses** are used to specify the IP addresses of the trusted proxies that pass the request. These can be in the form of CIDRs, IPs, or hostnames. For example, if a load balancer is forwarding the request to NGINX Gateway Fabric, the IP address of the load balancer should be specified in the `trustedAddresses` list to inform NGINX that the forwarded request is from a known source.

**SetIPRecursively** is a boolean field used to enable recursive search when selecting the client's address from a multi-value header. It is applicable in cases where we have a multi-value header containing client IPs to select from, that is, when using `XForwardedFor` mode.

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
        value: "76.89.90.11/24"
EOF
```

{{< call-out "note" >}} When sending curl requests to a server expecting proxy information, use the flag `--haproxy-protocol` to avoid broken header errors. {{< /call-out >}}

---

## Configure infrastructure-related settings

You can configure deployment and service settings for all data plane instances by editing the `NginxProxy` resource at the Gateway or GatewayClass level. These settings can also be specified under the `nginx` section in the Helm values file. You can edit things such as replicas, pod scheduling options, container resource limits, extra volume mounts, service types and load balancer settings.

The following command creates an `NginxProxy` resource with 2 replicas, sets `container.resources.requests` to 100m CPU and 128Mi memory, configures a 90 second `pod.terminationGracePeriodSeconds`, and sets the service type to `LoadBalancer` with IP `192.87.9.1` and AWS NLB annotation.

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: ngf-proxy-config-test
spec:
  kubernetes:
    deployment:
      container:
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
      pod:
        terminationGracePeriodSeconds: 90
      replicas: 2
    service:
      annotations:
        service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
      type: LoadBalancer
      loadBalancerIP: "192.87.9.1"
EOF
```

To view the full list of configuration options, see the `NginxProxy spec` in the [API reference]({{< ref "/ngf/reference/api.md" >}}).

---

### Patch data plane Service, Deployment, and DaemonSet

NGINX Gateway Fabric supports advanced customization of the data plane Service, Deployment, and DaemonSet objects using patches in the `NginxProxy` resource. This allows you to apply Kubernetes-style patches to these resources, enabling custom labels, annotations, or other modifications that are not directly exposed via the NginxProxy spec.

#### Supported Patch Types

You can specify one or more patches for each of the following resources:

- `spec.kubernetes.service.patches`
- `spec.kubernetes.deployment.patches`
- `spec.kubernetes.daemonSet.patches`

Each patch has two fields:

- `type`: The patch type. Supported values are:
    - `StrategicMerge` (default): Strategic merge patch (Kubernetes default for most resources)
    - `Merge`: JSON merge patch (RFC 7386)
    - `JSONPatch`: JSON patch (RFC 6902)
- `value`: The patch data. For `StrategicMerge` and `Merge`, this should be a JSON object. For `JSONPatch`, this should be a JSON array of patch operations.

Patches are applied in the order they appear in the array. Later patches can override fields set by earlier patches.

#### Example: Configure Service with session affinity

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: ngf-proxy-patch-service
spec:
  kubernetes:
    service:
      patches:
        - type: StrategicMerge
          value:
            spec:
              sessionAffinity: ClientIP
              sessionAffinityConfig:
                clientIP:
                  timeoutSeconds: 300
```

#### Example: Configure Deployment with custom strategy

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: ngf-proxy-patch-deployment
spec:
  kubernetes:
    deployment:
      patches:
        - type: Merge
          value:
            spec:
              strategy:
                type: RollingUpdate
                rollingUpdate:
                  maxUnavailable: 0
                  maxSurge: 2
```

#### Example: Use JSONPatch to configure DaemonSet host networking and priority

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: ngf-proxy-patch-daemonset
spec:
  kubernetes:
    daemonSet:
      patches:
        - type: JSONPatch
          value:
            - op: add
              path: /spec/template/spec/hostNetwork
              value: true
            - op: add
              path: /spec/template/spec/dnsPolicy
              value: "ClusterFirstWithHostNet"
            - op: add
              path: /spec/template/spec/priorityClassName
              value: "system-node-critical"
```

#### Example: Multiple patches, later patch overrides earlier

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: ngf-proxy-multi-patch
spec:
  kubernetes:
    service:
      patches:
        - type: StrategicMerge
          value:
            spec:
              sessionAffinity: ClientIP
              publishNotReadyAddresses: false
        - type: StrategicMerge
          value:
            spec:
              sessionAffinity: None
              publishNotReadyAddresses: true
```

In this example, the final Service will have `sessionAffinity: None` and `publishNotReadyAddresses: true` because the second patch overrides the values from the first patch.

{{< note >}}
**Which patch type should I use?**

- **StrategicMerge** is the default and most user-friendly for Kubernetes-native resources like Deployments and Services. It understands lists and merges fields intelligently (e.g., merging containers by name). Use this for most use cases.
- **Merge** (JSON Merge Patch) is simpler and works well for basic object merges, but does not handle lists or complex merging. Use this if you want to replace entire fields or for non-Kubernetes-native resources.
- **JSONPatch** is the most powerful and flexible, allowing you to add, remove, or replace specific fields using RFC 6902 operations. Use this for advanced or fine-grained changes, but it is more verbose and error-prone.

If unsure, start with StrategicMerge. Use JSONPatch only if you need to surgically modify fields that cannot be addressed by the other patch types.

Patches are applied after all other NginxProxy configuration is rendered. Invalid patches will result in a validation error and will not be applied.
{{< /note >}}

---
