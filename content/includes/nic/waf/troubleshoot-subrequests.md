---
f5-product: F5 NGINX Ingress Controller
f5-files:
- content/nic/integrations/waf/current/troubleshoot.md
- content/nic/integrations/waf/legacy/troubleshoot.md
---

A `Cache` policy with `cacheBackgroundUpdate` uses NGINX subrequests. These subrequests may not work as expected when F5 WAF for NGINX applies to the same route.

Other policies that use subrequests, such as `ExternalAuth`, `JWT` with `jwksURI`, and `OIDC`, don't have this issue. NGINX Ingress Controller turns off F5 WAF for NGINX in the internal locations that serve their subrequests.
