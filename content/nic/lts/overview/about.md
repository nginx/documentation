---
title: About
weight: 100
f5-content-type: reference
f5-product: NGINX Ingress Controller
---

This document describes the F5 NGINX Ingress Controller LTS, an Ingress Controller implementation for NGINX Plus.

The LTS version of NGINX Ingress Controller is based on the latest stable release of NGINX. It is *feature-frozen* at the time of release — no new features are added after release. Only critical bug fixes and security patches are delivered as patch revisions. It is ideal for users who prioritize stability and long-term support over access to the latest features.

This version is supported for 36 months from the date of release, with security patches provided throughout the support period. For users who require access to the latest features and improvements, we recommend using the latest mainline release of NGINX Ingress Controller.

NGINX Ingress Controller LTS is an [Ingress Controller]({{< ref "/glossary/#k8s-ingress-controller">}}) implementation for [NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) that can load balance Websocket, gRPC, TCP and UDP applications. NGINX Ingress Controller LTS gives you a way to manage NGINX through the [Kubernetes](https://kubernetes.io/) API, and is built to handle the continuous change that happens in Kubernetes environments.

It supports standard [Ingress]({{< ref "/glossary/#k8s-ingress-controller">}}) features such as content-based routing and TLS/SSL termination. NGINX Plus features are available as extensions to Ingress resources through [Annotations]({{< ref "/nic/lts/configuration/ingress-resources/advanced-configuration-with-annotations">}}) and the [ConfigMap]({{< ref "/nic/lts/configuration/global-configuration/configmap-resource">}}) resource.

NGINX Ingress Controller LTS supports the [VirtualServer and VirtualServerRoute resources]({{< ref "/nic/lts/configuration/virtualserver-and-virtualserverroute-resources">}}) as alternatives to Ingress, enabling traffic splitting and advanced content-based routing. It also supports TCP, UDP and TLS Passthrough load balancing using [TransportServer resources]({{< ref "/nic/lts/configuration/transportserver-resource">}}).

To learn more about NGINX Ingress Controller LTS, please read the [The design of NGINX Ingress Controller LTS]({{< ref "/nic/lts/overview/design.md">}}) and [Extensibility with NGINX Plus]({{< ref "/nic/lts/overview/nginx-plus.md">}}) topics.
