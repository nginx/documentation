---
f5-product: F5 WAF for NGINX
f5-files:
- content/ngf/waf-integration/get-started-plm.md
---

<!-- Maintainer note: This include creates the security namespace used by APPolicy and APLogConf resources. It is product-agnostic and must be included before any include or section that applies resources to the security namespace. In the NGF and NIC tutorials, include this before the optional security logging section. Note: NGF tutorials also create a ReferenceGrant in this namespace, but that is product-specific and not referenced here. -->

This section is typically owned by the security team. If you're not on the security team, share this section with them before continuing.

Create the `security` namespace. The security team's `APPolicy` and `APLogConf` resources live here. In NGINX Gateway Fabric, the `ReferenceGrant` that permits cross-namespace WAFPolicy references also lives in this namespace.

```shell
kubectl create namespace security
```
