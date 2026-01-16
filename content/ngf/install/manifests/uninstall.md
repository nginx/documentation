---
title: Use Manifests to uninstall NGINX Gateway Fabric
linkTitle: Uninstall
weight: 500
toc: true
nd-content-type: how-to
nd-product: FABRIC
---

This page describes how to use Manifests to uninstall NGINX Gateway Fabric, its custom resource definitions, and its Gateway API resources.

By following these instrucions, you will remove NGINX Gateway Fabric and all Gateway resources from a Kubernetes cluster.

## Remove NGINX Gateway Fabric

To remove NGINX Gateway Fabric run:

```shell
kubectl delete namespace nginx-gateway
kubectl delete clusterrole nginx-gateway
kubectl delete clusterrolebinding nginx-gateway
```

## Delete the custom resource definitions

To remove the NGINX Gateway Fabric custom resource definitions, run:

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

To uninstall the Gateway API resources, run the command based on your deployment type:

{{< tabs name="deployment-type" >}}

{{% tab name="Default" %}}

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v{{< version-ngf >}}" | kubectl delete -f -
```

{{% /tab %}}

{{% tab name="Experimental" %}}

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/experimental?ref=v{{< version-ngf >}}" | kubectl delete -f -
```

{{% /tab %}}

{{< /tabs >}}

{{< details summary="Example output" >}}

```text
customresourcedefinition.apiextensions.k8s.io "gatewayclasses.gateway.networking.k8s.io" deleted
customresourcedefinition.apiextensions.k8s.io "gateways.gateway.networking.k8s.io" deleted
customresourcedefinition.apiextensions.k8s.io "grpcroutes.gateway.networking.k8s.io" deleted
customresourcedefinition.apiextensions.k8s.io "httproutes.gateway.networking.k8s.io" deleted
customresourcedefinition.apiextensions.k8s.io "referencegrants.gateway.networking.k8s.io" deleted
```

{{< /details >}}