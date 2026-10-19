---
f5-docs: DOCS-107
f5-product: F5 NGINX Gateway Fabric
f5-files:
- content/ngf/install/manifests/open-source-experimental.md
- content/ngf/install/manifests/open-source.md
- content/ngf/install/manifests/plus-experimental.md
- content/ngf/install/manifests/plus.md
---

To confirm that NGINX Gateway Fabric is running, check the pods in the `nginx-gateway` namespace:

```shell
kubectl get pods -n nginx-gateway
```

The output should look similar to this (The pod name will include a unique string):

```text
NAME                             READY   STATUS    RESTARTS   AGE
nginx-gateway-694897c587-bbz62       1/1     Running     0          29s
```