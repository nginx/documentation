---
f5-product: F5 WAF for NGINX
f5-files:
- content/ngf/waf-integration/get-started-plm.md
---

<!-- Maintainer note: This include is product-agnostic. It covers creating the security namespace and defining an APLogConf resource. The securityLogs field that references this log profile lives on the product-specific policy attachment resource (WAFPolicy for NGF, Policy for NIC) — keep that configuration in the parent tutorial, not here. -->

This section is typically owned by the security team. If you're not on the security team, share this section with them before continuing.

PLM security logging profiles are defined as `APLogConf` custom resources. Create a namespace to hold your security resources, then define a log profile that logs illegal requests:

```shell
kubectl create namespace security
```

```yaml
kubectl apply -f - <<EOF
apiVersion: appprotect.f5.com/v1
kind: APLogConf
metadata:
  name: log-illegal
  namespace: security
spec:
  filter:
    request_type: illegal
  content:
    format: default
    max_request_size: any
    max_message_size: 15k
EOF
```

PLM compiles the log profile automatically. Wait for `status.bundle.state` to report `ready` before referencing it:

```shell
kubectl wait --for=jsonpath='{.status.bundle.state}'=ready aplogconf/log-illegal -n security --timeout=60s
```
