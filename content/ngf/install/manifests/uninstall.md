---
title: Use Manifests to uninstall NGINX Gateway Fabric
linkTitle: Uninstall
weight: 300
toc: true
nd-content-type: how-to
nd-product: FABRIC
---

This page describes how to uninstall NGINX Gateway Fabric, its custom resource definitions (CRDs) and the Gateway API resources from a Kubernetes cluster.

These instructions are for a Manifest deployment: for a Helm deployment, view the [Use Helm to uninstall NGINX Gateway Fabric]({{< ref "/ngf/install/helm.md#uninstall-nginx-gateway-fabric" >}}) topic.

## Remove NGINX Gateway Fabric

To remove NGINX Gateway Fabric run:

```shell
kubectl delete namespace nginx-gateway
kubectl delete clusterrole nginx-gateway
kubectl delete clusterrolebinding nginx-gateway
```

## Remove the CRDs

To remove the NGINX Gateway Fabric CRDs, run:

```shell
kubectl delete -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/crds.yaml
```

{{< details summary="Example output" >}}

```text
customresourcedefinition.apiextensions.k8s.io "clientsettingspolicies.gateway.nginx.org" deleted
customresourcedefinition.apiextensions.k8s.io "nginxgateways.gateway.nginx.org" deleted
customresourcedefinition.apiextensions.k8s.io "nginxproxies.gateway.nginx.org" deleted
customresourcedefinition.apiextensions.k8s.io "observabilitypolicies.gateway.nginx.org" deleted
customresourcedefinition.apiextensions.k8s.io "snippetsfilters.gateway.nginx.org" deleted
customresourcedefinition.apiextensions.k8s.io "upstreamsettingspolicies.gateway.nginx.org" deleted
```

{{< /details >}}

## Remove the Gateway API resources

{{< include "/ngf/installation/uninstall-gateway-api-resources.md" >}}

## Remove secrets

{{< include "/k8s/delete-license-registry-secrets.md" >}}