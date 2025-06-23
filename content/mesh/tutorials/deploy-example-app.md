---
title: Deploy an Example App with NGINX Service Mesh
draft: false
toc: true
description: This topic provides a walkthrough of deploying an App with F5 NGINX Service
  Mesh.
weight: 100
nd-docs: DOCS-720
type:
- tutorial
---

## Overview

In this tutorial, we will use the `bookinfo` example app Deployment.

- {{< icon "download" >}} {{< link "examples/bookinfo.yaml" "examples/bookinfo.yaml" >}}

{{< call-out "note" >}}
Notice in the above yaml:

- All of the service spec port names are populated with the name of the protocol
- All deployment `containerPort` fields are specified.

This is used in the mesh to identify the kind of traffic being sent and where it is allowed to be received. For more information on deployment and service identification rules, see [identification-rules]( {{< ref "/mesh/get-started/install/configuration.md#identification-rules" >}} ) in the Getting Started section.
{{< /call-out >}}

{{< call-out "note" >}}
Review the [ports reserved by F5 NGINX Service Mesh sidecar]( {{< ref "/mesh/about/mesh-tech-specs.md#ports" >}} ) and make sure there are no overlaps with ports used by your applications.
{{< /call-out >}}

## Prerequisite
Ensure that you have deployed Prometheus, Grafana, and a tracing backend and configured NGINX Service Mesh to export data to them. Refer to the [Monitoring and Tracing]( {{< ref "/mesh/guides/monitoring-and-tracing.md" >}} ) guide for instructions.

## Inject the Sidecar Proxy

You can use either [automatic]( {{< ref "/mesh/guides/inject-sidecar-proxy.md#automatic-proxy-injection" >}} ) or [manual injection]( {{< ref "/mesh/guides/inject-sidecar-proxy.md#manual-proxy-injection" >}} ) to add the NGINX Service Mesh sidecar containers to your application pods.

### Inject the Sidecar Proxy Automatically

To enable automatic sidecar injection for all Pods in a namespace, add the `injector.nsm.nginx.com/auto-inject=enabled` label to the namespace.

```bash
kubectl label namespaces default injector.nsm.nginx.com/auto-inject=enabled
```

With auto-injection enabled, you can use `kubectl` to apply your Deployment as normal.
The sidecar proxy will be added and runs automatically.

```bash
kubectl apply -f examples/bookinfo.yaml
```

### Inject the Sidecar Proxy Manually

You can inject the sidecar proxy into your Deployment manually by using the [`nginx-meshctl inject`]( {{< ref "nginx-meshctl.md#inject" >}} ) CLI command.
You can then `kubectl apply` the Deployment as usual, or pipe the command directly to `kubectl`:

```bash
nginx-meshctl inject < examples/bookinfo.yaml | kubectl apply -f -
```

## Verify that the Sample App Works Correctly

1. Port-forward to the `productpage` Service:

    ```bash
    kubectl port-forward svc/productpage 9080
    ```

2. Open the Service URL in a browser: `http://localhost:9080`.
3. Click one of the links to view the app as a general user, then as a test user, and verify that all portions of the page load.

## Verify Observability

### Check the Grafana dashboard

[Grafana](https://grafana.com/grafana/) is the observability dashboard used to visualize Prometheus metrics for applications in NGINX Service Mesh.

1. Port-forward your Grafana Service:

    ```bash
    kubectl -n <grafana-namespace> port-forward svc/grafana 3000
    ```

2. Open the Grafana URL in a browser: `http://localhost:3000`.

### Check Prometheus metrics

[Prometheus](https://prometheus.io/docs/concepts/data_model/) is the systems monitoring tool used to collect metrics, such as request time and success rate, from applications in NGINX Service Mesh.


1. Port-forward your Prometheus Service:

   ```bash
   kubectl -n <prometheus-namespace> port-forward svc/prometheus 9090
   ```

2. Open the Prometheus server URL in a browser window: `http://localhost:9090/graph`

### Check Tracing

[Tracing](https://opentelemetry.io/docs/concepts/data-sources/#traces) is used to track and profile requests as they pass through applications, and is collected using services such as [Jaeger](https://www.jaegertracing.io/), [DataDog](https://docs.datadoghq.com/tracing/), or [LightStep](https://lightstep.com/).

1. Port-forward your tracing Service:

    ```bash
    kubectl -n <tracing-namespace> port-forward svc/<tracing-service> <tracing-service-port>
    ```

2. Open the tracing server URL in a browser. For example, you might access the Jaeger server at `http://localhost:16686`.
