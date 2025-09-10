---
title: Install NGINX Service Mesh with Basic Observability
draft: false
toc: true
description: This topic provides a walkthrough of deploying F5 NGINX Service Mesh
  with basic observability components.
weight: 90
nd-docs: DOCS-886
type:
- tutorial
---

## Overview

In this tutorial, we will install F5 NGINX Service Mesh with some basic observability components. These components include Prometheus for collecting metrics, Grafana for visualizing metrics, and the OpenTelemetry Collector and Jaeger for collecting traces. These deployments are meant for demo purposes only, and are not recommended for production environments.

## Deploy the Observability Components

Download the following files containing the configurations for the observability components:

- {{< icon "download" >}} {{< link "/examples/prometheus.yaml" "prometheus.yaml" >}}
- {{< icon "download" >}} {{< link "/examples/grafana.yaml" "grafana.yaml" >}}
- {{< icon "download" >}} {{< link "/examples/otel-collector.yaml" "otel-collector.yaml" >}}
- {{< icon "download" >}} {{< link "/examples/jaeger.yaml" "jaeger.yaml" >}}

Deploy the components:

```bash
kubectl apply -f prometheus.yaml -f grafana.yaml -f otel-collector.yaml -f jaeger.yaml
```

This command creates the `nsm-monitoring` namespace and deploys all of the components in that namespace. This namespace does not have the auto-inject label because we do not want to inject the sidecar into the observability deployments.

## Install NGINX Service Mesh

Install NGINX Service Mesh and configure it to integrate with the observability deployments:

Using the CLI:

```bash
nginx-meshctl deploy --prometheus-address "prometheus.nsm-monitoring.svc:9090" --telemetry-exporters "type=otlp,host=otel-collector.nsm-monitoring.svc,port=4317" --telemetry-sampler-ratio 1
```

Using Helm:

```bash
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update

helm install nsm nginx-stable/nginx-service-mesh --namespace nginx-mesh --create-namespace --wait --set prometheusAddress=prometheus.nsm-monitoring.svc:9090 --set telemetry.exporters.otlp.host=otel-collector.nsm-monitoring.svc --set telemetry.exporters.otlp.port=4317 --set telemetry.samplerRatio=1
```

{{< call-out "note" >}}
A sampler ratio of 1 results in 100% of traces being sampled. Adjust this value (float from 0 to 1) to your needs.
{{< /call-out >}}

## View the Dashboards

To view the Prometheus dashboard:

```bash
kubectl -n nsm-monitoring port-forward svc/prometheus 9090
```

Visit [http://localhost:9090](http://localhost:9090)

To view the Grafana dashboard:

```bash
kubectl -n nsm-monitoring port-forward svc/grafana 3000
```

Visit [http://localhost:3000](http://localhost:3000). Both the default username and password are "admin".

To view the Jaeger dashboard:

```bash
kubectl -n nsm-monitoring port-forward svc/jaeger 16686
```

Visit [http://localhost:16686](http://localhost:16686)

## What's Next

[Deploy an Example App]( {{< ref "/mesh/tutorials/deploy-example-app.md" >}})
