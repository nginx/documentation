---
docs: DOCS-000
---

To upgrade your Gateway API resources, take the following steps:

- Use [Technical specifications]({{< ref "/ngf/reference/technical-specifications.md" >}}) to verify your Gateway API resources are compatible with your NGINX Gateway Fabric version. 
- Review the [release notes](https://github.com/kubernetes-sigs/gateway-api/releases) for any important upgrade-specific information.

To upgrade the Gateway API resources, run the following command:

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v{{< version-ngf >}}" | kubectl apply -f -
```

If you installed NGINX Gateway the from the experimental channel, use this instead:

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/experimental?ref=v{{< version-ngf >}}" | kubectl apply -f -
```