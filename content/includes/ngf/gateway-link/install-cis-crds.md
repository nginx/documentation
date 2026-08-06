---
f5-product: NGINX Gateway Fabric
f5-files:
- content/ngf/external-loadbalancers/gateway-link/quickstart.md
- content/ngf/external-loadbalancers/gateway-link/multicluster.md
---

```shell
kubectl apply -f https://raw.githubusercontent.com/F5Networks/k8s-bigip-ctlr/v{{< ngf-version-cis >}}/docs/config_examples/customResourceDefinitions/customresourcedefinitions.yml
```

Confirm the `IngressLink` custom resource definition is installed:

```shell
kubectl get crd ingresslinks.cis.f5.com
```

```text
NAME                        CREATED AT
ingresslinks.cis.f5.com     2026-08-05T01:40:54Z
```
