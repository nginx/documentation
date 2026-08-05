---
f5-product: FABRIC
---

Create a partition named `k8s` for F5 Container Ingress Services to own:

```shell
curl -sku '<BIGIP_USERNAME>:<BIGIP_PASSWORD>' -X POST "https://<BIGIP_ADDRESS>/mgmt/tm/auth/partition" \
  -H "Content-Type: application/json" -d '{"name":"k8s"}'
```

The response describes the new partition:

```json
{
    "name": "k8s",
    "fullPath": "k8s",
    "defaultRouteDomain": 0
}
```

F5 Container Ingress Services manages the full contents of its partition. The partition cannot be `Common`, because Container Ingress Services must not modify shared configuration.
