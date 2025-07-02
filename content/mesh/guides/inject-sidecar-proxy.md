---
title: Sidecar Proxy Injection
toc: true
description: Learn about the configuration options for F5 NGINX Service Mesh sidecar
  proxy injection.
weight: 10
nd-docs: DOCS-692
type:
- how-to
---

## Overview

F5 NGINX Service Mesh works by injecting a sidecar proxy into Kubernetes resources.

A couple important things to note about injected Pods:

- The sidecar proxy will not be injected into Pods that define multiple container ports with the same port number or for container ports with the SCTP protocol.
  UDP and TCP are an exception to this, and may be specified on the same port.
- When you inject the sidecar proxy into a Kubernetes resource, the injected config uses the global mTLS setting.
  You can define the global setting when you deploy NGINX Service Mesh, or use the default setting.
  Refer to [Secure Mesh Traffic using mTLS]({{< ref "/mesh/guides/secure-traffic-mtls.md" >}}) for more information.


The mesh supports the following Kubernetes resources and API versions for injection:

{{% table %}}
|  Resource Type        | API Version |
|-----------------------|-------------|
| Deployment            | apps/v1     |
| DaemonSet             | apps/v1     |
| StatefulSet           | apps/v1     |
| ReplicaSet            | apps/v1     |
| ReplicationController | v1          |
| Pod                   | v1          |
| Job                   | batch/v1    |
{{% /table %}}

You can choose to inject the sidecar proxy into the YAML or JSON definitions for your Kubernetes resources in the following ways:

- [Automatic Injection](#automatic-proxy-injection)
- [Manual Injection](#manual-proxy-injection)

## Automatic Proxy Injection

To enable automatic sidecar injection for all Pods in a namespace, add the `injector.nsm.nginx.com/auto-inject=enabled` label to the namespace.

```bash
kubectl label namespaces <namespace name> injector.nsm.nginx.com/auto-inject=enabled
```

For more granular control, you can enable or disable automatic sidecar injection on a per-resource basis.
To do so, add the following label to the resource's **PodTemplateSpec**: `injector.nsm.nginx.com/auto-inject: "enabled|disabled"`.
Pod labels take precedence over namespace labels.

If you add the auto-inject label to existing resources, you will need to restart the affected Pods in order for the sidecar to be injected.
By the same token if you remove the label or set the Pod label to `disabled`, you will need to restart them to remove the sidecar.

Use `kubectl rollout restart` to restart your Pods:

```bash
kubectl rollout restart <resource type>/<resource name>
```

For example:

```bash
kubectl rollout restart deployment/frontend
```

{{< see-also >}}
See [NGINX Service Mesh Labels and Annotations]( {{< ref "/mesh/get-started/install/configuration.md#supported-labels-and-annotations" >}}) for more information on available labels and annotations.

Refer to the Kubernetes [`kubectl` Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#updating-resources) documentation for more information about rolling resources.
{{< /see-also >}}

## Manual Proxy Injection

To inject the sidecar proxy into a resource manually, use the `nginx-meshctl inject` command. Provide the path to the resource definition file and your desired output filename.

```bash
nginx-meshctl inject < <resource-file> > <new-resource-file>
```

For example, the following command will write the updated config for "resource.yaml" to a new file, "resource-injected.yaml":

```bash
nginx-meshctl inject < resource.yaml > resource-injected.yaml
```

## Ignore Specific Ports

You can set the proxy to ignore ports for either incoming or outgoing traffic. The NGINX Service Mesh applies the configurations at injection time.

- For automatic injection, add the following annotations to the **PodTemplateSpec** in your resource definition:

  ```yaml
  config.nsm.nginx.com/ignore-incoming-ports: "port1, port2, ..., portN"
  config.nsm.nginx.com/ignore-outgoing-ports: "port1, port2, ..., portN"
  ```

- For manual injection, you can use the annotations above or specify the ports when running the `nginx-meshctl inject` command.

    ```bash
    nginx-meshctl inject --ignore-incoming-ports "port1,port2,...,portN", --ignore-outgoing-ports "port1,port2,...,portN" < resource.yaml > resource-injected.yaml
    ```

{{< note >}}
Refer to [NGINX Service Mesh Annotations]( {{< ref "/mesh/get-started/install/configuration.md#pod-annotations" >}}) for more information around annotations.
{{< /note >}}

## Default Ignored Ports

By default, the following ports are ignored by the proxy:

- 53 (DNS)

## HTTPGet Health Probe Rewrite

If mTLS mode is set to `strict`, then readiness, liveness, and startup probes using HTTP GET do not work. This is
due to `kubelet` not having the correct client certificates. To remedy this, application HTTP/S health probes are
rewritten at injection time. The new probes point to an endpoint on the sidecar proxy, which
redirects the health check to the original destination on the application. This allows the health check to bypass
the SSL verification, while still sending the health check to the intended destination.

## UDP MTU Sizing

NGINX Service Mesh automatically detects and adjusts the `eth0` interface to support the 32 bytes of space required for PROXY Protocol V2. See the [UDP and eBPF architecture]( {{< ref "/mesh/about/architecture.md#udp-and-ebpf" >}} ) section for more information.
