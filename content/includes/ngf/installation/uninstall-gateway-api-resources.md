---
nd-docs: DOCS-1436
nd-product: FABRIC
nd-files:
- content/ngf/how-to/gateway-api-inference-extension.md
- content/ngf/install/helm.md
---

{{< call-out "warning" >}} This step will remove all corresponding custom resources in your entire cluster, across every namespace. 

Ensure you don't have any custom resources you need to keep, and confirm that there are no other Gateway API implementations active in your cluster. {{< /call-out >}}

To uninstall the Gateway API resources, run the following:

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v{{< version-ngf >}}" | kubectl delete -f -
```

{{< details summary="Example output" >}}

```text
customresourcedefinition.apiextensions.k8s.io "gatewayclasses.gateway.networking.k8s.io" deleted
customresourcedefinition.apiextensions.k8s.io "gateways.gateway.networking.k8s.io" deleted
customresourcedefinition.apiextensions.k8s.io "grpcroutes.gateway.networking.k8s.io" deleted
customresourcedefinition.apiextensions.k8s.io "httproutes.gateway.networking.k8s.io" deleted
customresourcedefinition.apiextensions.k8s.io "referencegrants.gateway.networking.k8s.io" deleted
```

{{< /details >}}

If you installed the Gateway APIs from the experimental channel, run the following instead:

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/experimental?ref=v{{< version-ngf >}}" | kubectl delete -f -
```
