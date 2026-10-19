---
f5-docs: DOCS-75
f5-product: Miscellaneous
f5-files:
- content/nic/install/helm/uninstall.md
- content/nic/lts/install/helm/uninstall.md
---

If your deployment used NGINX Plus, you should also remove the secrets created for your license and the F5 registry.

```shell
kubectl delete secret nplus-license
```

{{< details summary="Example output" >}}

```text
secret "nplus-license" deleted
```

{{< /details >}}

```shell
kubectl delete secret regcred
```

{{< details summary="Example output" >}}

```text
secret "regcred" deleted
```

{{< /details >}}