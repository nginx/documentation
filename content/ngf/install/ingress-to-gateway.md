---
title: Migrate from NGINX Ingress Controller to NGINX Gateway Fabric
weight: 800
toc: true
nd-content-type: how-to
nd-product: NGF
nd-docs:
---

This document describes how to migrate from F5 NGINX Ingress Controller to NGINX Gateway Fabric.

If you're already using NGINX Ingress Controller and want to migrate to NGINX Gateway Fabric, you can use the [ingress2gateway](https://github.com/kubernetes-sigs/ingress2gateway) tool to automatically convert your existing Ingress resources to Gateway API resources.

## Why migrate?

The [Gateway API](https://gateway-api.sigs.k8s.io/) is the next-generation Kubernetes networking API that builds on the limitations of Ingress. Compared to Ingress, Gateway API provides:

- **Role-oriented resources**: Distinct resources for infrastructure providers, cluster operators, and application developers, enabling [separation of concerns](https://gateway-api.sigs.k8s.io/concepts/security-model/#role-oriented-resources).
- **More expressive routing**: Support for [advanced traffic management](https://gateway-api.sigs.k8s.io/concepts/api-overview/#routes) such as path-based and header-based routing, traffic splitting, and TLS configuration.
- **Standardization and portability**: A Kubernetes [community standard](https://gateway-api.sigs.k8s.io/) supported by multiple vendors, ensuring consistent behavior across implementations.
- **Extensibility**: Built on Kubernetes [CRD extensibility](https://gateway-api.sigs.k8s.io/guides/migrating-from-ingress/?h=extensibility#approach-to-extensibility) to support new capabilities without breaking the core API.

Migrating to Gateway API with NGINX Gateway Fabric helps future-proof your Kubernetes networking stack, provide a standardized API across implementations, and unlock advanced traffic management features.

## About the ingress2gateway tool

The ingress2gateway tool is a [Kubernetes SIG project](https://github.com/kubernetes-sigs) for converting Ingress resources to Gateway API resources. It supports multiple Ingress providers, including NGINX Ingress Controller.

{{< call-out "important" >}}
The ingress2gateway tool is a conversion utility that translates Ingress resources to Gateway API equivalents. It is not a complete end-to-end migration solution. 

You will need to manually review the converted resources, test functionality, and make additional configuration changes as needed for your specific environment.
{{< /call-out >}}

To convert your existing NGINX Ingress resources to Gateway API resources, first [install the ingress2gateway tool](https://github.com/kubernetes-sigs/ingress2gateway?tab=readme-ov-file#installation).

Then run the conversion command for the NGINX provider:
   
```shell
ingress2gateway print --providers=nginx --input-file=<your-ingress-file> > gateway-api-resources.yaml
```

This tool will analyze your Ingress resources from the input file and output the equivalent Gateway API resources to a file named `gateway-api-resources.yaml`.

Review the generated Gateway API resources in the output file and apply them to your cluster:

```shell
kubectl apply -f gateway-api-resources.yaml
```

For detailed information about NGINX-specific features and conversion options, see the [NGINX provider documentation](https://github.com/kubernetes-sigs/ingress2gateway/blob/main/pkg/i2gw/providers/nginx/README.md).
