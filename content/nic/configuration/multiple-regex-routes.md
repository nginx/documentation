---
title: Multiple regex routes in a VirtualServerRoute
toc: true
weight: 760
f5-content-type: reference
f5-product: INGRESS
f5-docs: DOCS-XXXX
---

F5 NGINX Ingress Controller lets you reference the same VirtualServerRoute from multiple regex routes in a VirtualServer. This means you can group related regex paths by concern — for example, all `/api` paths go to one team's VirtualServerRoute and all `/images` paths go to another.

## How it works

When NGINX Ingress Controller processes a VirtualServer, it collects every regex route (`~` or `~*`) that references the same VirtualServerRoute. It then validates the collected VirtualServer paths against the VirtualServerRoute's subroutes as a single set. Each subroute produces a separate NGINX `location` block in the generated configuration.

## Set match requirement

The VirtualServer paths and VirtualServerRoute subroutes must form a **bidirectional set match**:

- Every VirtualServer regex path that references the VirtualServerRoute must have a corresponding subroute.
- Every subroute in the VirtualServerRoute must be referenced by a VirtualServer regex path.

If either side has a path the other doesn't, NGINX Ingress Controller rejects the VirtualServerRoute and the VirtualServer enters a warning state.

{{< table >}}

| Direction | Rule | Error if violated |
| --- | --- | --- |
| VirtualServer &rarr; VirtualServerRoute | Every VirtualServer regex path must appear as a subroute | "subroute with path '...' is missing" |
| VirtualServerRoute &rarr; VirtualServer | Every subroute must be referenced by a VirtualServer regex path | "subroute path '...' is not referenced by any VS route" |

{{< /table >}}

## Configure multiple regex routes

The following example shows a VirtualServer with five routes. Two case-sensitive regex routes delegate to `vsr-api`, and two case-insensitive regex routes delegate to `vsr-media`. The `/health` route is handled directly by the VirtualServer.

### VirtualServer

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: api-gateway
spec:
  host: api-gateway.example.com
  routes:
  - path: /health
    action:
      return:
        code: 200
        type: text/plain
        body: "OK"
  - path: "~/api/v1"
    route: vsr-api
  - path: "~/api/v2"
    route: vsr-api
  - path: "~*/images/jpg"
    route: vsr-media
  - path: "~*/images/png"
    route: vsr-media
```

### VirtualServerRoute for API routes

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServerRoute
metadata:
  name: vsr-api
spec:
  host: api-gateway.example.com
  subroutes:
  - path: "~/api/v1"
    action:
      pass: api-v1
  - path: "~ /api/v2"
    action:
      pass: api-v2
```

Notice that the second subroute uses `"~ /api/v2"` (with a space) while the VirtualServer declares `"~/api/v2"` (without a space). NGINX Ingress Controller normalizes both to the same value, so the configuration is valid. See [Path normalization](#path-normalization) for details.

### VirtualServerRoute for media routes

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServerRoute
metadata:
  name: vsr-media
spec:
  host: api-gateway.example.com
  subroutes:
  - path: "~*/images/jpg"
    action:
      pass: images-jpg
  - path: "~*/images/png"
    action:
      pass: images-png
```

### Generated NGINX configuration

Each subroute produces a separate `location` block. The generated NGINX configuration for the four regex subroutes looks like this:

```nginx
location ~ "/api/v1" {
    ...
}

location ~ "/api/v2" {
    ...
}

location ~* "/images/jpg" {
    ...
}

location ~* "/images/png" {
    ...
}
```

### Request routing

{{< table >}}

| Request URI | Matching location | VirtualServerRoute |
| --- | --- | --- |
| `/health` | `/health` (prefix, direct VirtualServer action) | None |
| `/api/v1` | `~ "/api/v1"` | `vsr-api` |
| `/api/v2` | `~ "/api/v2"` | `vsr-api` |
| `/images/jpg` | `~* "/images/jpg"` | `vsr-media` |
| `/images/png` | `~* "/images/png"` | `vsr-media` |

{{< /table >}}

## Path normalization

NGINX Ingress Controller strips whitespace between the regex modifier (`~` or `~*`) and the path before comparing values. This means `"~/api/v1"` and `"~ /api/v1"` normalize to the same value.

Normalization applies to all path comparisons:

- **Set match validation**: A VirtualServer path `"~/api/v2"` matches a VirtualServerRoute subroute `"~ /api/v2"` because both normalize to `"~/api/v2"`.
- **Duplicate detection**: If a single VirtualServerRoute contains both `"~*/images/jpg"` and `"~* /images/jpg"` as subroutes, they normalize to the same value and NGINX Ingress Controller rejects the VirtualServerRoute with a duplicate path error.

{{< call-out "important" >}}
Using `"~ /api/v1"` in a VirtualServerRoute to match `"~/api/v1"` in a VirtualServer is valid — the paths are in different resources and represent the same logical route. Having both `"~/api/v1"` and `"~ /api/v1"` as separate subroutes in the **same** VirtualServerRoute is invalid — they resolve to the same normalized path and are treated as duplicates.
{{< /call-out >}}

## Validation rules

NGINX Ingress Controller enforces the following rules for regex route delegation:

- Every VirtualServer regex path referencing a VirtualServerRoute must have a matching subroute in that VirtualServerRoute.
- Every subroute in the VirtualServerRoute must be referenced by a VirtualServer regex path.
- Subroute paths must be unique after normalization. Paths that differ only in whitespace between the modifier and the URI are treated as duplicates.
- All VirtualServer routes referencing the same VirtualServerRoute must use the same modifier category. You can't have a regex route (`~`) and a prefix route (`/`) both referencing the same VirtualServerRoute.
- Case-sensitive (`~`) and case-insensitive (`~*`) modifiers can reference the same VirtualServerRoute because both are in the regex category.
- Exact match routes (`=`) still require exactly one subroute. Only regex routes support multiple subroutes per VirtualServerRoute.

## Validation errors

When NGINX Ingress Controller detects a validation failure, it rejects the VirtualServerRoute and the VirtualServer enters a warning state. Other VirtualServerRoutes and direct VirtualServer routes continue to serve traffic normally.

### Missing subroute

This error occurs when the VirtualServer references a regex path through a VirtualServerRoute, but the VirtualServerRoute doesn't have a subroute for that path.

For example, the VirtualServer references both `~/api/v1` and `~/api/v2` through `vsr-api`, but the VirtualServerRoute only defines `~/api/v1`:

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServerRoute
metadata:
  name: vsr-api
spec:
  host: api-gateway.example.com
  subroutes:
  - path: "~/api/v1"
    action:
      pass: api-v1
```

NGINX Ingress Controller rejects the VirtualServerRoute with the following error:

```text
VirtualServerRoute default/vsr-api is invalid: spec.subroutes: Invalid value:
"subroutes": subroute with path '~/api/v2' is missing; all VS route paths must
be covered by VSR subroutes
```

To fix this, add the missing subroute (`~/api/v2`) to the VirtualServerRoute, or remove the VirtualServer route that references it.

### Extra subroute

This error occurs when the VirtualServerRoute has a subroute that no VirtualServer route references.

For example, the VirtualServerRoute defines `~/api/v1`, `~/api/v2`, and `~/api/v3`, but the VirtualServer only references `~/api/v1` and `~/api/v2`:

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServerRoute
metadata:
  name: vsr-api
spec:
  host: api-gateway.example.com
  subroutes:
  - path: "~/api/v1"
    action:
      pass: api-v1
  - path: "~/api/v2"
    action:
      pass: api-v2
  - path: "~/api/v3"
    action:
      pass: api-v3
```

NGINX Ingress Controller rejects the VirtualServerRoute with the following error:

```text
VirtualServerRoute default/vsr-api is invalid: spec.subroutes[2].path: Invalid
value: "~/api/v3": subroute path '~/api/v3' is not referenced by any VS route;
all VSR subroutes must be referenced
```

To fix this, remove the extra subroute from the VirtualServerRoute, or add a corresponding regex route in the VirtualServer.

### Duplicate paths after normalization

This error occurs when two subroutes in the same VirtualServerRoute resolve to the same path after normalization. Because NGINX Ingress Controller strips whitespace between the modifier and the URI, paths that appear different in YAML can be identical after normalization.

For example, the following VirtualServerRoute has `"~/api/v1"` and `"~ /api/v1"` as separate subroutes:

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServerRoute
metadata:
  name: vsr-api
spec:
  host: api-gateway.example.com
  subroutes:
  - path: "~/api/v1"
    action:
      pass: api-v1
  - path: "~ /api/v1"
    action:
      pass: api-v1-alt
```

Both paths normalize to `"~/api/v1"`. NGINX Ingress Controller rejects the VirtualServerRoute:

```text
VirtualServerRoute default/vsr-api is invalid: spec.subroutes[0].path:
Duplicate value: "~/api/v1", spec.subroutes[1].path: Duplicate value:
"~ /api/v1"
```

To fix this, remove the duplicate subroute. If you need to match the same pattern, use a single subroute.

## See also

- [VirtualServer and VirtualServerRoute resources]({{< ref "/nic/configuration/virtualserver-and-virtualserverroute-resources.md" >}}) for the full field reference.
- NGINX [location directive documentation](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) for how NGINX evaluates regex locations.
- [Multiple regex routes examples](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/custom-resources/vsr-multiple-regex-routes) on GitHub for runnable manifests and additional error case examples.
