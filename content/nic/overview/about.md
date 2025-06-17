---
title: About
weight: 100
nd-content-type: reference
nd-product: NIC
nd-docs: DOCS-612
---

This document describes the F5 NGINX Ingress Controller, an Ingress Controller implementation for NGINX and NGINX Plus.

NGINX Ingress Controller is an [Ingress Controller]({{< ref "/nic/glossary.md#ingress-controller">}}) implementation for [NGINX](https://nginx.org) and [NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) that can load balance Websocket, gRPC, TCP and UDP applications. NGINX Ingress Controller gives you a way to manage NGINX through the [Kubernetes](https://kubernetes.io/) API, and is built to handle the continuous change that happens in Kubernetes environments. 

It supports standard [Ingress]({{< ref "/nic/glossary.md#ingress">}}) features such as content-based routing and TLS/SSL termination.Several NGINX and NGINX Plus features are available as extensions to Ingress resources through [Annotations]({{< ref "/nic/configuration/ingress-resources/advanced-configuration-with-annotations">}}) and the [ConfigMap]({{< ref "/nic/configuration/global-configuration/configmap-resource">}}) resource.

NGINX Ingress Controller supports the [VirtualServer and VirtualServerRoute resources]({{< ref "/nic/configuration/virtualserver-and-virtualserverroute-resources">}}) as alternatives to Ingress, enabling traffic splitting and advanced content-based routing. It also supports TCP, UDP and TLS Passthrough load balancing using [TransportServer resources]({{< ref "/nic/configuration/transportserver-resource">}}).

To learn more about NGINX Ingress Controller, please read the [The design of NGINX Ingress Controller]({{< ref "/nic/overview/design.md">}}) and [Extensibility with NGINX Plus]({{< ref "/nic/overview/nginx-plus.md">}}) topics.
