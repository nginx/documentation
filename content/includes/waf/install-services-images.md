---
f5-product: F5 WAF for NGINX
f5-files:
- content/waf/install/docker.md
---

Download the `waf-enforcer` and `waf-config-mgr` images.

```shell
docker pull private-registry.nginx.com/nap/waf-enforcer:{{< version-waf-enforcer >}}
docker pull private-registry.nginx.com/nap/waf-config-mgr:{{< version-waf-config-mgr >}}
```