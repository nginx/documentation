---
title: Path matching
toc: true
weight: 750
f5-content-type: reference
f5-product: NGINX Ingress Controller
f5-keywords: nginx, nginx ingress controller, nic, ingress controller, path matching, regex, prefix, longest prefix, case sensitive, case insensitive, virtualserver, virtual server, virtualserverroute, virtual server route, kubernetes, crd, path, location, location block
f5-summary: This page describes the path matching algorithm used by NGINX. This is useful when configuring VirtualServers and VirtualServerRoutes in NGINX Ingress Controller. Since version 5.5.0, NIC supports all five types of paths. Those are prefix, longest prefix, case sensitive regex, case insensitive regex, and exact match. Before 5.5.0 the longest prefix match was not available via NIC.
f5-audience: developer, operator, admin
---

This document describes how F5 NGINX Ingress Controller translates VirtualServer and VirtualServerRoute route paths into NGINX [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) directives, with a focus on the longest prefix match (`^~`) modifier.

## Overview

Each route in a VirtualServer or subroute in a VirtualServerRoute has a `path` field that maps directly to an NGINX `location` directive. NGINX Ingress Controller supports five path matching types, each with different syntax and priority behavior. Understanding these types, especially the longest prefix match, allows you to control exactly which location block handles a given request.

## Matching types and priority

The following table lists all five supported path types in order of priority from highest to lowest:

{{< table >}}

| Priority | Path type | Syntax | NGINX directive | Description |
| --- | --- | --- | --- | --- |
| 1 (highest) | Exact match | `=/path` | `location = /path` | Matches only the exact URI. Stops all further searching immediately. |
| 2 | Longest prefix match | `^~/path` | `location ^~ /path` | Matches by prefix and stops NGINX from evaluating any regex locations. |
| 3 | Regex (case-sensitive) | `~ pattern` | `location ~ "pattern"` | Matches the URI against a case-sensitive regular expression. |
| 3 | Regex (case-insensitive) | `~* pattern` | `location ~* "pattern"` | Matches the URI against a case-insensitive regular expression. |
| 4 (lowest) | Prefix match | `/path` | `location /path` | Matches by prefix, but can be overridden by a regex match. |

{{< /table >}}

When NGINX receives a request, it evaluates locations in the following order:

1. **Exact match (`=`)**: If the URI matches an exact location, NGINX uses it immediately and stops searching.
2. **Prefix scan**: NGINX scans all prefix locations (both `^~` and plain `/`) and remembers the longest match.
3. **Longest prefix match (`^~`)**: If the longest matching prefix location has the `^~` modifier, NGINX uses it immediately and skips all regex evaluation.
4. **Regex evaluation (`~` and `~*`)**: NGINX checks regex locations in the order they appear in the configuration. The first matching regex wins.
5. **Prefix fallback**: If no regex matches, NGINX uses the longest matching prefix location from step 2.

## Longest prefix match (`^~`)

The `^~` modifier gives a prefix location higher priority than regex locations. When a request URI matches a `^~` location, NGINX uses that location immediately and does not evaluate any regular expression locations, even if a regex would also match.

This is useful when you want to serve a specific path prefix with certainty, regardless of any regex patterns that might also match.

### When to use longest prefix match

Use `^~` when:

- You need to guarantee that a specific path prefix is always handled by a particular upstream or action, even if regex locations exist that could match the same URI.
- You are serving static assets from a known path (such as `/images/static/` or `/assets/`) and want to prevent regex patterns (such as `~ \.jpg$`) from intercepting those requests.

### Path syntax rules

A longest prefix match path must follow these rules:

- The path must start with `^~` followed by a valid URI path starting with `/`.
- Optional whitespace between `^~` and the path is allowed (for example, `^~ /images/` and `^~/images/` are equivalent).
- The URI portion must not contain whitespace, `{`, `}`, `;`, or `\` characters.
- The URI portion must not contain `..` path segments.

### How it differs from a regular prefix match

| Behavior | Prefix (`/path`) | Longest prefix (`^~/path`) |
| --- | --- | --- |
| Matches by URI prefix | Yes | Yes |
| Can be overridden by regex | Yes | No |
| Supports `proxy.rewritePath` | Yes | Yes |
| Supports subroute delegation | Yes | Yes |

The only difference is that `^~` prevents regex locations from overriding the match.

## VirtualServer example

The following VirtualServer defines routes using several path types, including the longest prefix match:

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: path-matching
spec:
  host: path-matching.example.com
  upstreams:
  - name: static-backend
    service: static-svc
    port: 80
  - name: images-backend
    service: images-svc
    port: 80
  - name: app-backend
    service: app-svc
    port: 80
  routes:
  - path: "=/images/logo.jpg"
    action:
      pass: static-backend
  - path: "^~/images/static/"
    action:
      pass: static-backend
  - path: "~ \\.jpg$"
    action:
      pass: images-backend
  - path: /images/
    action:
      pass: app-backend
```

This configuration produces the following NGINX location blocks:

```nginx
location = /images/logo.jpg {
    # Exact match - highest priority
    ...
}

location ^~ /images/static/ {
    # Longest prefix match - blocks regex evaluation
    ...
}

location ~ "\.jpg$" {
    # Case-sensitive regex
    ...
}

location /images/ {
    # Regular prefix - lowest priority
    ...
}
```

With this configuration:

{{< table >}}

| Request URI | Matching location | Reason |
| --- | --- | --- |
| `/images/logo.jpg` | `= /images/logo.jpg` | Exact match has highest priority. |
| `/images/static/photo.jpg` | `^~ /images/static/` | Longest prefix match blocks regex (`~ \.jpg$`) from being evaluated. |
| `/images/photo.jpg` | `~ "\.jpg$"` | Regular prefix `/images/` matches, but regex takes priority over plain prefix. |
| `/images/photo.gif` | `/images/` | No regex matches `.gif`, so the prefix fallback is used. |

{{< /table >}}

## VirtualServerRoute subroutes with longest prefix match

When a VirtualServer route delegates to a VirtualServerRoute using the `route` or `routeSelector` field, the parent route's path acts as a constraint on subroute paths. For a `^~` parent path, each subroute must also use the `^~` modifier.

### VirtualServer with delegation

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: path-matching-vsr
spec:
  host: path-matching-vsr.example.com
  routes:
  - path: "^~/static/"
    route: static-routes
```

### VirtualServerRoute with `^~` subroutes

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServerRoute
metadata:
  name: static-routes
spec:
  host: path-matching-vsr.example.com
  subroutes:
  - path: "^~/static/css/"
    action:
      pass: css-backend
  - path: "^~/static/js/"
    action:
      pass: js-backend
```

This produces two NGINX location blocks:

```nginx
location ^~ /static/css/ {
    ...
}

location ^~ /static/js/ {
    ...
}
```

{{< call-out "important" >}}
The parent route's path (`^~/static/`) does not create an NGINX location block. Only the subroute paths become NGINX locations. If a request matches the parent prefix but not any subroute (for example, `/static/fonts/bold.woff`), no location handles it and NGINX returns a 404 response.
{{< /call-out >}}

## Subroute path constraints

When a VirtualServer route delegates to a VirtualServerRoute, the subroute paths must follow constraints based on the parent route's path type:

{{< table >}}

| Parent path type | Subroute requirement | Multiple subroutes | Example |
| --- | --- | --- | --- |
| Prefix (`/path`) | Each subroute must start with the parent path and use the prefix type. | Yes | Parent: `/images/`, subroutes: `/images/thumbnails/`, `/images/originals/` |
| Longest prefix (`^~/path`) | Each subroute must start with the parent path string including the `^~` modifier. | Yes | Parent: `^~/static/`, subroutes: `^~/static/css/`, `^~/static/js/` |
| Regex (`~/pattern` or `~*/pattern`) | The subroute must have the exact same path as the parent. | No (one only) | Parent: `~ \.jpg$`, subroute: `~ \.jpg$` |
| Exact (`=/path`) | The subroute must have the exact same path as the parent. | No (one only) | Parent: `=/exact`, subroute: `=/exact` |

{{< /table >}}

For longest prefix parent paths, a plain prefix subroute like `/static/css/` is rejected because the validation requires that the subroute path string starts with `^~/static/`. The `^~` modifier must be present on every subroute.

## See also

- [VirtualServer and VirtualServerRoute resources]({{< ref "/nic/configuration/virtualserver-and-virtualserverroute-resources.md" >}}) for the full CRD field reference.
- NGINX [location directive documentation](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) for the upstream NGINX matching algorithm.
- NGINX [location priority]({{< ref "/nginx/admin-guide/web-server/web-server.md#nginx-location-priority" >}}) for a detailed explanation of NGINX's location evaluation order.
- [Ingress path matching using path-regex annotation]({{< ref "/nic/tutorials/ingress-path-regex-annotation.md" >}}) for configuring regex path matching with Ingress resources.
- [Path matching examples](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/custom-resources/path-matching) on GitHub for runnable examples of all five path types.
