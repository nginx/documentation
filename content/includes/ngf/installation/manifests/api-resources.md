---
---

{{< call-out "note" >}} If you have already installed Gateway API resources in your cluster, ensure they are a version [supported by NGINX Gateway Fabric]({{< ref "/ngf/overview/technical-specifications.md" >}}) {{< /call-out >}}

To install the Gateway API resources, use `kubectl kustomize`:

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v{{< version-ngf >}}" | kubectl apply -f -
```

{{< details summary="Example output" >}}

```text
customresourcedefinition.apiextensions.k8s.io/gatewayclasses.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/gateways.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/grpcroutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/httproutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/referencegrants.gateway.networking.k8s.io created
```

{{< /details >}}

You should also create the _nginx-gateway_ namespace, which is used by the Manifest files by default:

```shell
kubectl create namespace nginx-gateway
```