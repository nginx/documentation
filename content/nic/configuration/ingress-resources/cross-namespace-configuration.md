---
title: Cross-namespace configuration
content-type: how-to
product: INGRESS
id: DOCS-594
canonical-url: https://docs.nginx.com/nic/configuration/ingress-resources/cross-namespace-configuration/
---

This topic explains how to spread Ingress configuration across different namespaces in F5 NGINX Ingress Controller.

You can spread the Ingress configuration for a common host across multiple Ingress resources using Mergeable Ingress resources. Such resources can belong to the *same* or *different* namespaces. This enables easier management when using a large number of paths. See the [Mergeable Ingress Resources](https://github.com/nginx/kubernetes-ingress/tree/v
5.4.1
/examples/ingress-resources/mergeable-ingress-types) example in our GitHub repo.

As an alternative to Mergeable Ingress resources, you can use [VirtualServer and VirtualServerRoute resources](https://docs.nginx.com/nic//configuration/virtualserver-and-virtualserverroute-resources) for cross-namespace configuration.

VirtualServer and VirtualServerRoute support referencing upstream services in other namespaces using the `namespace/service-name` syntax. NGINX Ingress Controller automatically detects endpoint changes for those upstream services and updates NGINX. This keeps your routing current when pods scale, restart, or roll during updates.

See the [Cross-Namespace Configuration](https://github.com/nginx/kubernetes-ingress/tree/v
5.4.1
/examples/custom-resources/cross-namespace-configuration) example in our GitHub repo.