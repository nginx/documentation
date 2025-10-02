---
nd-docs: null
title: Add service-specific locations
toc: true
weight: 400
type:
- how-to
nd-product: NGINX One Console
---

# Overview

This guide shows how to extend a working submission from the [Submit Templates Guide]({{< ref "submit-templates.md" >}}) by adding server augments for new services with dedicated location augments.

{{< call-out "note" "Note" >}}Because you can’t retrieve previous submissions, you must include the full request with any updates.{{< /call-out >}}

## Import template

If there aren't existing augment templates that fit your needs, you will need to create and import them.

### New server augment template

Because there isn’t a server augment yet, you need to create one. This template creates dedicated server blocks for each service.

`http-server.tmpl`

```text
server {
    listen {{ .listen_port }};
    server_name{{ range .server_names }} {{ . }}{{ end }};
    
    {{ augment_includes "http/server/location" . }}
}
```

`schema.yaml`

```text
$schema: "http://json-schema.org/draft-07/schema#"
type: object
properties:
  listen_port:
    type: integer
    description: "Port for the server to listen on"
    minimum: 1
    maximum: 65535
    default: 80
  server_names:
    type: array
    description: "Array of domain names for this server"
    items:
      type: string
    minItems: 1
required:
  - listen_port
  - server_names
additionalProperties: false
```

#### Import parameters

When [Importing]({{< ref "import-templates.md#ready-to-import" >}}) this template allows you to set up:

- name: `http-server`
- type: `augment` 
- allowed_in_contexts: `["http"]`

### New location augment template

Create a location augment template to add location blocks within each server.

{{< call-out "note" "Note" >}}
If you already have a "health-check" location augment from earlier steps, you can add it to the new servers.
{{< /call-out >}}

`location-proxy.tmpl`

```text
location {{ .path }} {
    proxy_pass {{ .upstream_url }};
    proxy_connect_timeout {{ .proxy_timeout }};
    proxy_read_timeout {{ .proxy_read_timeout }};
}
```

`schema.yaml`

```text
$schema: "http://json-schema.org/draft-07/schema#"
type: object
properties:
  path:
    type: string
    description: "Location path (for example, /api, /admin)"
    pattern: "^/.*$"
  upstream_url:
    type: string
    description: "Backend service URL"
    pattern: "^https?://[^\\s]+$"
  proxy_timeout:
    type: string
    description: "Proxy connection timeout"
    pattern: "^\\d+[smhd]?$"
    default: "30s"
  proxy_read_timeout:
    type: string
    description: "Proxy read timeout"
    pattern: "^\\d+[smhd]?$"
    default: "60s"
required:
  - path
  - upstream_url
additionalProperties: false
```

#### Import parameters
When [Importing]({{< ref "import-templates.md#ready-to-import" >}}) this template allows you to:

- name: `location-proxy`
- type: `augment`
- allowed_in_contexts: `["http/server/location"]`

## Submit to add multiple services

### Request structure

Example API request:

```json
{
  "conf_path": "/etc/nginx/nginx.conf",
  "base_template": {
    "object_id": "<ID of your template object>",
    "values": {
      "backend_url": "http://example.com:8080"
    }
  },
  "augments": [
    {
      "object_id": "<ID of your template object>",
      "target_context": "http/server/location",
      "values": {
        "cors_allowed_origins": "https://app.example.com",
        "cors_allowed_methods": "GET, POST, PUT, DELETE, OPTIONS"
      }
    },
    {
      "object_id": "<ID of your template object>",
      "target_context": "http/server"
    },
    {
      "object_id": "<ID of your template object>",
      "target_context": "http",
      "values": {
        "listen_port": 80,
        "server_names": ["admin.example.com"]
      },
      "child_augments": [
        {
          "object_id": "<ID of your template object>",
          "target_context": "http/server/location",
          "values": {
            "path": "/admin",
            "upstream_url": "http://admin-backend:8080"
          }
        },
        {
          "object_id": "<ID of your template object>",
          "target_context": "http/server/location",
          "values": {
            "health_check_path": "/admin/health"
          }
        }
      ]
    }
  ]
}
```

### New config template contents

- **Existing augments remain:** CORS headers and the health-check location still apply to the main server.  
- **New server augments** Adds an extra server block.  
- **Service-specific routing:** The new `admin.example.com` server name has its own location blocks and routing rules.  

### Response format

If the request succeeds, the response includes the following output and the rendered NGINX configuration:

#### Successful response (200 OK)

```json
{
    "config": {
        "aux": [],
        "conf_path": "/etc/nginx/nginx.conf",
        "config_version": "nuZ4+d1T159/0vVV9vKaajrEw7QXc6T3fAnxKcVkC6I=",
        "configs": [
            {
                "files": [
                    {
                        "contents": "<base64_encoded_nginx_conf>",
                        "mtime": "0001-01-01T00:00:00Z",
                        "name": "nginx.conf",
                        "size": 483
                    }
                ],
                "name": "/etc/nginx"
            },
            {
                "files": [
                    {
                        "contents": "<base64_encoded_nginx_conf>",
                        "mtime": "0001-01-01T00:00:00Z",
                        "name": "cors-headers.tmpl.4aaf36d4a643.conf",
                        "size": 159
                    },
                    {
                        "contents": "<base64_encoded_nginx_conf>",
                        "mtime": "0001-01-01T00:00:00Z",
                        "name": "health-check.tmpl.78346de4dae4.conf",
                        "size": 109
                    },
                    {
                        "contents": "<base64_encoded_nginx_conf>",
                        "mtime": "0001-01-01T00:00:00Z",
                        "name": "http-server.tmpl.81761e94d463.conf",
                        "size": 145
                    },
                    {
                        "contents": "<base64_encoded_nginx_conf>",
                        "mtime": "0001-01-01T00:00:00Z",
                        "name": "location-proxy.tmpl.66ebf3e1dfd9.conf",
                        "size": 121
                    }
                ],
                "name": "/etc/nginx/conf.d/augments"
            }
        ]
    },
    "errors": null
}
```

#### Rendered NGINX configuration

```nginx
# configuration file /etc/nginx/nginx.conf:
user nginx;
worker_processes auto;

events {
    worker_connections 1048;
}

http {
    server {
        listen 80;
        server_name admin.example.com;
        
        location /admin {
            proxy_pass http://admin-backend:8080;
            proxy_connect_timeout 30s;
            proxy_read_timeout 60s;
        }

    }

    
    server {
        listen 80;
        server_name _;

        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }

        
        location / {
            proxy_pass http://example.com:8080;
            add_header 'Access-Control-Allow-Origin' 'https://app.example.com' always;
            add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;

        }
    }
}
```

## Child augments

Child augments let you nest one augment inside another, creating hierarchical configurations. This is often used when a parent augment creates a container (such as a server block) that requires specific sub-configurations (such as location blocks).

**How child augments work**

When an augment template includes an `{{ augment_includes "context_path" . }}` extension point, you can provide child augments that target that context path. The child augments render only within their parent augment’s output.

**Key behaviors**
- Child location augments apply only to their parent server.  
- Different servers can have different location configurations.  
- Each server runs independently with its own routing rules.  

For details on designing templates with extension points, see the [Template Authoring Guide]({{< ref "author-templates.md" >}}).