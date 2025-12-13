---
---

Deploy the NGINX Gateway Fabric CRDs using `kubectl apply`:

```shell
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/crds.yaml
```

{{< details summary="Example output" >}}

```text
customresourcedefinition.apiextensions.k8s.io/clientsettingspolicies.gateway.nginx.org serverside-applied
customresourcedefinition.apiextensions.k8s.io/nginxgateways.gateway.nginx.org serverside-applied
customresourcedefinition.apiextensions.k8s.io/nginxproxies.gateway.nginx.org serverside-applied
customresourcedefinition.apiextensions.k8s.io/observabilitypolicies.gateway.nginx.org serverside-applied
customresourcedefinition.apiextensions.k8s.io/snippetsfilters.gateway.nginx.org serverside-applied
customresourcedefinition.apiextensions.k8s.io/upstreamsettingspolicies.gateway.nginx.org serverside-applied
```

{{< /details >}}