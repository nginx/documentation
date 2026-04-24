---
title: REVIEW — Migrate from Ingress-NGINX Controller to NGINX Ingress Controller
nd-content-type: internal-review
---

Summary

- Purpose: Editorial and technical review of content/nic/install/migrate-ingress-nginx.md.
- Verdict: Good intent and structure, but several technical inaccuracies, YAML errors, and style/clarity issues need attention before publication.

Highlights (What’s working)

- Clear framing of the two migration paths (NGINX custom resources vs. Kubernetes Ingress + annotations/ConfigMaps).
- Helpful cross-reference tables for annotations and ConfigMap keys.
- Useful mention of TLS, gRPC, and mTLS differences and the policy resource.

Critical issues to address

1) YAML correctness and API versions

- Kubernetes Ingress v1 example uses deprecated fields and has indentation errors:
  - Use pathType for each path.
  - backend must use service.name and service.port fields (serviceName/servicePort are deprecated since networking.k8s.io/v1).
  - /billing path block is missing backend: entirely.
- NGINX VirtualServer example uses the wrong apiVersion. VirtualServer is a CRD: apiVersion: k8s.nginx.org/v1 (not networking.k8s.io/v1).
- Several example blocks in the canary section are not valid YAML (incorrect indentation, list scoping, and key/value alignment).

2) Inaccurate/unclear statements

- “This path uses Kubernetes Ingress Resources to set root permissions…” Root permissions is unclear and likely incorrect in this context. Recommend: “Use NGINX custom resources (CRDs) for application configuration and traffic management.”
- “Install NIC on the same host” — typically both controllers run in the same cluster (often different namespaces), not necessarily “same host.”
- Canary section: order-of-evaluation guidance is useful, but the VirtualServer/VirtualServerRoute matches examples are malformed and will confuse readers.
- Rate-limiting/connection-limiting: some mappings propose snippets; wherever possible, prefer first-class Policy/VirtualServer fields to snippets (see suggestions below).
- Typos: evalute -> evaluate; north-sourth -> north-south.

3) Completeness and migration guidance

- Add a practical migration strategy: run both controllers concurrently, migrate by namespace or application, validate, then switch traffic.
- Provide notes on class-based scoping (ingressClassName vs. controller class) to avoid route conflicts.

Edits and concrete fixes (ready to replace in the doc)

Overview (rewrite)

Replace the current Overview paragraph with:

This page shows two ways to migrate from the community-maintained Ingress-NGINX Controller to F5 NGINX Ingress Controller (NIC):
- Using NGINX custom resources (VirtualServer/VirtualServerRoute, TransportServer, GlobalConfiguration, and Policy)
- Using standard Kubernetes Ingress resources with NIC annotations and a ConfigMap

Choose the NGINX custom resources path if you want richer traffic management, advanced policies, or NGINX Plus features. Choose the Kubernetes Ingress path if you prefer to keep configuration on the standard Ingress object.

Before you begin (fix)

- Change “on the same host as an existing Ingress-NGINX Controller” to “in the same cluster as an existing Ingress-NGINX Controller (typically in a separate namespace).”

Migration with NGINX Ingress resources — SSL termination and path routing

Kubernetes Ingress (networking.k8s.io/v1) — corrected example:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-test
spec:
  tls:
  - hosts:
    - foo.bar.com
    secretName: tls-secret
  rules:
  - host: foo.bar.com
    http:
      paths:
      - path: /login
        pathType: Prefix
        backend:
          service:
            name: login-svc
            port:
              number: 80
      - path: /billing
        pathType: Prefix
        backend:
          service:
            name: billing-svc
            port:
              number: 80
```

NGINX VirtualServer — corrected example:

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: nginx-test
spec:
  host: foo.bar.com
  tls:
    secret: tls-secret
  upstreams:
  - name: login
    service: login-svc
    port: 80
  - name: billing
    service: billing-svc
    port: 80
  routes:
  - path: /login
    action:
      pass: login
  - path: /billing
    action:
      pass: billing
```

Canary deployments — corrected matches examples

Header-based canary (presence/value semantics):

Ingress-NGINX annotations:

```yaml
nginx.ingress.kubernetes.io/canary: "true"
nginx.ingress.kubernetes.io/canary-by-header: "httpHeader"
```

VirtualServer/VirtualServerRoute (simplified example):

```yaml
routes:
- path: /
  matches:
  - conditions:
    - header: httpHeader
      value: never
    action:
      pass: echo
  - conditions:
    - header: httpHeader
      value: always
    action:
      pass: echo-canary
  action:
    pass: echo
```

Header with explicit value:

Ingress-NGINX annotations:

```yaml
nginx.ingress.kubernetes.io/canary: "true"
nginx.ingress.kubernetes.io/canary-by-header: "httpHeader"
nginx.ingress.kubernetes.io/canary-by-header-value: "my-value"
```

VirtualServer/VirtualServerRoute:

```yaml
routes:
- path: /
  matches:
  - conditions:
    - header: httpHeader
      value: my-value
    action:
      pass: echo-canary
  action:
    pass: echo
```

Cookie-based canary:

Ingress-NGINX annotations:

```yaml
nginx.ingress.kubernetes.io/canary: "true"
nginx.ingress.kubernetes.io/canary-by-cookie: "cookieName"
```

VirtualServer/VirtualServerRoute:

```yaml
routes:
- path: /
  matches:
  - conditions:
    - cookie: cookieName
      value: never
    action:
      pass: echo
  - conditions:
    - cookie: cookieName
      value: always
    action:
      pass: echo-canary
  action:
    pass: echo
```

Traffic control — improvements

- For rate limiting, prefer the Policy resource or the VirtualServer route rateLimit where possible, instead of raw snippets.
- For allow/deny by CIDR, prefer Policy access control rather than generic snippets.

Examples:

Rate limiting via Policy (attach policy to a route):

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: ratelimit-policy
spec:
  rateLimit:
    rate: 100r/s
    burst: 50
    key: "$binary_remote_addr"
    zoneSize: 10m
```

Attach policy to a VirtualServer route:

```yaml
routes:
- path: /path
  action:
    pass: my-upstream
  policies:
  - name: ratelimit-policy
```

IP allowlist via Policy:

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: ip-allowlist
spec:
  accessControl:
    allow:
    - 10.0.0.0/8
    deny:
    - 0.0.0.0/0
```

Attach to a route or server-wide depending on scope:

```yaml
routes:
- path: /
  action:
    pass: my-upstream
  policies:
  - name: ip-allowlist
```

URI rewriting in VirtualServer:

```yaml
routes:
- path: /app
  action:
    pass: app-upstream
    rewritePath: /
```

mTLS authentication — fixes

- Typos: “north-sourth” -> “north-south”.
- Keep bools unquoted where appropriate in YAML; keep verifyClient as "on" if the field expects an NGINX directive value string.

Ingress (client) mTLS via Policy:

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: ingress-mtls
spec:
  ingressMTLS:
    clientCertSecret: secretName
    verifyClient: "on"
    verifyDepth: 1
```

Egress (backend) mTLS in VirtualServer upstream (or Policy if supported):

```yaml
upstreams:
- name: backend
  service: backend-svc
  port: 443
  tls:
    enable: true
    tlsSecret: secretName
    verifyServer: true
    verifyDepth: 1
    protocols: TLSv1.2
    ciphers: DEFAULT
    serverName: true
    sslName: server-name
```

Session persistence — clarification

- If you use annotations on standard Ingress, map to nginx.org/sticky-cookie-services.
- With VirtualServer or Policy, sessionCookie is available. Please ensure the version note refers to the NIC version that introduced sessionCookie (not core NGINX version). Confirm the specific version before publishing.

Standard Ingress (annotation) example:

```yaml
nginx.org/sticky-cookie-services: "serviceName=example-svc cookie_name expires=3h path=/route secure"
```

VirtualServer Policy example:

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: session-cookie
spec:
  sessionCookie:
    enable: true
    name: cookieName
    expires: 3h
    path: /route
    secure: true
```

Kubernetes Ingress path — warning and note

- The warning against altering spec is good. Add explicit guidance to use ingressClassName and NIC’s controller class to avoid conflicts with Ingress-NGINX.

Annotation and ConfigMap tables — validation

- Many mappings look correct, but a few rows need validation before publish:
  - keep-alive -> keepalive-timeout: semantics differ; verify intended behavior.
  - proxy-headers-hash-max-size -> server-names-hash-max-size: likely incorrect; verify the intended NIC key or remove if no direct equivalent.
  - load-balance differences: some Ingress-NGINX algorithms are Lua-based; call this out (you already do via footnote (1)).

Style and terminology

- Use consistent product names:
  - Ingress-NGINX Controller (community project)
  - NGINX Ingress Controller (F5)
- Prefer “cluster” over “host” for Kubernetes.
- Watch tone and clarity; avoid ambiguous phrases like “root permissions.”

Suggested structure upgrade (optional but recommended)

1) Overview with a decision aid (When to use NGINX CRDs vs. standard Ingress).
2) Prerequisites with cluster/namespace scope and class configuration.
3) Migration approach: run both controllers, migrate per app/namespace, verify, cutover.
4) Path A: NGINX custom resources (examples: VS/VSR, TransportServer, Policy) — include the corrected samples above.
5) Path B: Standard Ingress with NIC annotations/ConfigMap — keep tables, add a worked example.
6) Features parity and gaps (Lua-only features in Ingress-NGINX; NIC-only features such as active health checks, JWT, etc.).
7) Troubleshooting and rollback.

Quick editorial fixes (by line number)

- 14: Rewrite per the Overview rewrite above.
- 30–31: Replace “same host” with “same cluster (separate namespace recommended).”
- 34–36: Period/capitalization consistency; consider bullets under a preceding colon.
- 39: Replace sentence; remove “root permissions.”
- 48: “used for SSL termination and Layer 7 path-based routing” — fine, but ensure examples are valid (replace with corrected versions above).
- 104: “TLS Passthrough” -> “TLS passthrough” (lowercase p) for consistency.
- 114: “evalute” -> “evaluate.”
- 156–167; 176–190: Replace with corrected canary YAML blocks above.
- 197–216 onward: For “custom default backend,” consider a short note on how NIC handles unmatched requests; avoid implying errorPages equals default backend. Add link to VS behavior.
- 294–297: Provide concrete snippet examples or replace with Policy-based IP allowlist as shown.
- 356–375: Table is fine conceptually; verify sticky-cookie-services spelling and link anchor.
- 378: “north-sourth” -> “north-south.”
- 424–447: Confirm version statement (“since 1.29.6”): which product/version is that? Adjust to NIC release number and link to changelog.
- 455–457: Good warning; add ingressClass guidance.
- 486–488: Already noted; keep the Lua caveats.
- 526–574: ConfigMap mapping table — validate the three noted rows and any with potentially different semantics.

Next steps

- If you approve, I can apply these edits directly to content/nic/install/migrate-ingress-nginx.md and adjust any affected anchors/links.
- Optionally, I can add a short “migration checklist” section and a basic example of running both controllers in parallel using distinct Ingress classes.
