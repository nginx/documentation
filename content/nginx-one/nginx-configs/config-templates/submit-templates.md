---
title: Submit templates
toc: true
weight: 200
nd-content-type: how-to
nd-product: ONE
---

# Template submission and preview guide

This guide explains how to submit templates for rendering NGINX configurations and preview the results using the Templates API.

Before submitting templates for preview, you need to import templates into NGINX One Console. 

- See the [Import Templates Guide]({{< ref "import-templates.md" >}}) for instructions on creating templates. 
- For guidance on writing templates, see the [Template Authoring Guide]({{< ref "author-templates.md" >}}).

## Overview

Template submission allows you to compose templates that generate complete NGINX configuration. The process involves:

1. **Discovering templates** - Find base and augment templates that match your infrastructure needs
1. **Understanding capabilities** - Review what contexts and features the base template supports
1. **Selecting augments** - Choose augments for additional features (CORS, rate limiting, SSL, etc.)
1. **Providing values** - Supply values for all template variables
1. **Preview and validate** - Generate and review the complete NGINX configuration
1. **Save as staged config** - Use NGINX One Console to save the preview as a staged configuration for deployment

## Current limitations

- **Preview only:** Template submission currently only supports preview mode (`preview_only=true`)
- **No submission persistence:** Submissions are not saved as objects (planned for future release)
- **Manual staged config creation:** After preview, use the NGINX One Console to manually save the rendered configuration as a staged config for deployment to instances or Config Sync Groups
- **Static includes:** Templates cannot include external static files (planned for future release)

## Template discovery

Before creating a submission, find base and augment templates that match your infrastructure needs.

### List available templates

Use the [List Templates]({{< ref "/nginx-one/api/api-reference-guide/#operation/listTemplates" >}}) API operation to find templates organized by use case.

**Example response:**

```json
{
  "count": 3,
  "items": [
    {
      "allowed_in_contexts": [
        "http/server/location"
      ],
      "augment_includes": [],
      "created_at": "2025-09-25T18:22:18.149122Z",
      "description": "",
      "name": "cors-headers",
      "object_id": "tmpl_AFVNBQcoRDeV9jk9panxbw",
      "type": "augment"
    },
    {
      "allowed_in_contexts": [
        "http/server"
      ],
      "augment_includes": [],
      "created_at": "2025-09-25T19:13:07.977943Z",
      "description": "",
      "name": "health-check",
      "object_id": "tmpl_rT6Ul8RvQtSZPkNfsIExPQ",
      "type": "augment"
    },
    {
      "allowed_in_contexts": [],
      "augment_includes": [
        "http",
        "http/server",
        "http/server/location"
      ],
      "created_at": "2025-09-25T19:20:47.473935Z",
      "description": "",
      "name": "reverse-proxy-base",
      "object_id": "tmpl_0rQSkSNSTamthLQVtSZb1g",
      "type": "base"
    }
  ],
  "items_per_page": 100,
  "start_index": 1,
  "total": 3
}
```

**Use Case Identification:**

- **Base templates** represent primary NGINX use cases (reverse proxy, load balancer, static site, API gateway)
- **Template descriptions** help identify which base template matches your infrastructure need
- **augment_includes** shows what additional features each base template supports

**Information Available In API Response:**

- **object_id** - A unique identifier of a template to use in submission requests
- **type** - Identifies base templates (use exactly one) vs augment templates (use zero or more)
- **allowed_in_contexts** - Shows where augment templates can be applied within a base template
- **augment_includes** - Shows which contexts the base template supports for augments

The API response contains all information needed for creating a submission to render NGINX configurations. You need template details **only** if you want to examine the actual template content or variable requirements.

### Get template details (optional)

Use the [Retrieve a Template]({{< ref "/nginx-one/api/api-reference-guide/#operation/getTemplate" >}}) API operation only when you need to examine template content or detailed variable requirements.

**When to use template details:**

- Review the actual template code and structure
- Examine detailed schema definitions for variable validation
- Understand specific variable names and constraints
- Debug template behavior or compatibility issues

**Example response:**

```json
{
  "allowed_in_contexts": [],
  "augment_includes": [
    "http",
    "http/server",
    "http/server/location"
  ],
  "created_at": "2025-09-25T19:20:47.473935Z",
  "description": "",
  "items": [
    {
      "contents": "user nginx;\nworker_processes auto;\n\nhttp {\n    {{ augment_includes \"http\" . }}\n    \n    server {\n        listen 80;\n        server_name _;\n\n        {{ augment_includes \"http/server\" . }}\n        \n        location / {\n            proxy_pass {{ .backend_url }};\n            {{ augment_includes \"http/server/location\" . }}\n        }\n    }\n}\n",
      "ctime": "2025-09-25T19:20:47.473935Z",
      "file_format": "FILE_FORMAT_PLAIN",
      "file_type": "FILE_TYPE_TEMPLATE",
      "mime_type": "FILE_MIME_TYPE_TEXT",
      "name": "reverse-proxy.tmpl",
      "size": 338
    },
    {
      "contents": "$schema: \"http://json-schema.org/draft-07/schema#\"\ntype: object\nproperties:\n  backend_url:\n    type: string\n    description: \"Backend server URL\"\nrequired:\n  - backend_url\nadditionalProperties: false\n",
      "ctime": "2025-09-25T19:20:47.473935Z",
      "file_format": "FILE_FORMAT_PLAIN",
      "file_type": "FILE_TYPE_SCHEMA",
      "mime_type": "FILE_MIME_TYPE_YAML",
      "name": "schema.yaml",
      "size": 200
    }
  ],
  "name": "reverse-proxy-base",
  "object_id": "tmpl_0rQSkSNSTamthLQVtSZb1g",
  "type": "base"
}
```

**Details:**

- **Template content** - Shows `augment_includes` placeholders and variable usage (e.g., `{{ .backend_url }}`)
- **Schema definition** - Shows required variables (`backend_url`) and their validation rules
- **Variable constraints** - Data types, descriptions, and any pattern requirements

## API endpoint

Use the [Submit templates for previewing NGINX configuration]({{< ref "/nginx-one/api/api-reference-guide/#operation/submitTemplates" >}}) API operation to render and preview NGINX configurations from templates.

## Request structure

The following sections describe what you need for the request:

### Required parameters

**Query Parameter:**

- `preview_only=true` - Currently the only supported mode. Renders configuration for preview without creating a submission object.

### Configuration path (`conf_path`)

{{< call-out "important" >}}

This path determines where augment configurations are rendered:

- Base template → renders to the exact `conf_path`
- Augment templates → render to `{base_dir}/conf.d/augments/{filename}.{hash}.conf`

Where `base_dir` is derived from `conf_path`:

- `conf_path: /etc/nginx/nginx.conf` → augments in `/etc/nginx/conf.d/augments/`
- `conf_path: /opt/nginx/nginx.conf` → augments in `/opt/nginx/conf.d/augments/`

{{< /call-out >}}

**Required.** The absolute path where the main NGINX configuration file should be placed.

**Examples:**

- `/etc/nginx/nginx.conf` (standard installation)
- `/opt/nginx/nginx.conf` (custom installation)

### Template properties

**Base Template:**

- `object_id` - Template unique identifier (use a template where `type` is `base`)
- `values` - Key-value pairs for template variables

**Augment Templates:**

- `object_id` - Template unique identifier (use a template where `type` is `augment`)
- `target_context` - NGINX context where the augment should be applied
- `values` - Key-value pairs for template variables (optional if template has no variables)
- `child_augments` - Optional nested augments that render within this augment's output

### Context paths

Augment templates must specify a `target_context` that determines where the augment will be placed in the base template.

**Validation:**

- The augment's `target_context` must be listed in the augment template's `allowed_in_contexts` (specified during import)

**Available Contexts:**

See the [Template Authoring Guide]({{< ref "author-templates.md#config-templates-contexts" >}}) for detailed information about context paths and how they map to NGINX configuration structure.

**Rendering Behavior:**

- If the base template has an `augment_includes` placeholder for the target context, the augment content is injected there
- If the base template doesn't have a matching placeholder, the augment is ignored (no error)
- If the base template has placeholders but no matching augments are provided, those placeholders render as empty strings
- Augments are applied in the order specified in the request.

For more information, see [Understanding Rendering Order](#understanding-rendering-order).

## Make the request

Use the [Submit Templates]({{< ref "/nginx-one/api/api-reference-guide/#operation/submitTemplates" >}}) API operation with your composed request and the required `preview_only=true` parameter.

### Request body

Here's an example of what you need to include with the API request:

```json
{
  "conf_path": "/etc/nginx/nginx.conf",
  "base_template": {
    "object_id": "<id of your template object>",
    "values": {
      "backend_url": "http://example.com:8080"
    }
  },
  "augments": [
    {
      "object_id": "<id of your template object>",
      "target_context": "http/server/location",
      "values": {
        "cors_allowed_origins": "https://app.example.com",
        "cors_allowed_methods": "GET, POST, PUT, DELETE, OPTIONS"
      }
    },
    {
      "object_id": "<id of your template object>",
      "target_context": "http/server"
    }
  ]
}
```

### Response format

#### Successful response (200 OK)

```json
{
  "config": {
    "aux": [],
    "conf_path": "/etc/nginx/nginx.conf",
    "config_version": "17qlLiPmAqIWhhYxmVieE9mC5t92e+/7gIvz0GFRj/E=",
    "configs": [
      {
        "files": [
          {
            "contents": "<base64_encoded_nginx_conf>",
            "mtime": "0001-01-01T00:00:00Z",
            "name": "nginx.conf",
            "size": 371
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
          }
        ],
        "name": "/etc/nginx/conf.d/augments"
      }
    ]
  },
  "errors": null
}
```

#### Response with parse errors (200 OK)

If the rendered configuration has NGINX syntax errors. You can use this information to debug and correct your submission request.

{{< call-out "caution" >}}
Parse errors indicate the rendered configuration has NGINX syntax issues, often due to missing include files or incomplete template logic. See [Template Limitations]({{< ref "author-templates.md#template-limitations" >}}).
{{< /call-out >}}

```json
{
  "config": {
    "aux": [],
    "conf_path": "/etc/nginx/nginx.conf",
    "config_version": "17qlLiPmAqIWhhYxmVieE9mC5t92e+/7gIvz0GFRj/E=",
    "configs": [
      {
        "files": [
          {
            "contents": "dXNlciBuZ2lueDsKd29ya2VyX3Byb2Nlc3NlcyBhdXRvOwoKaHR0cCB7CiAgICAKICAgIAogICAgc2VydmVyIHsKICAgICAgICBsaXN0ZW4gODA7CiAgICAgICAgc2VydmVyX25hbWUgXzsKCiAgICAgICAgaW5jbHVkZSAvZXRjL25naW54L2NvbmYuZC9hdWdtZW50cy9oZWFsdGgtY2hlY2sudG1wbC43ODM0NmRlNGRhZTQuY29uZjsKCiAgICAgICAgCiAgICAgICAgbG9jYXRpb24gLyB7CiAgICAgICAgICAgIHByb3h5X3Bhc3MgaHR0cDovL2FwaS1zZXJ2aWNlOjgwODA7CiAgICAgICAgICAgIGluY2x1ZGUgL2V0Yy9uZ2lueC9jb25mLmQvYXVnbWVudHMvY29ycy1oZWFkZXJzLnRtcGwuNGFhZjM2ZDRhNjQzLmNvbmY7CgogICAgICAgIH0KICAgIH0KfQo=",
            "mtime": "0001-01-01T00:00:00Z",
            "name": "nginx.conf",
            "size": 371
          }
        ],
        "name": "/etc/nginx"
      },
      {
        "files": [
          {
            "contents": "YWRkX2hlYWRlciAnQWNjZXNzLUNvbnRyb2wtQWxsb3ctT3JpZ2luJyAnaHR0cHM6Ly9hcHAuZXhhbXBsZS5jb20nIGFsd2F5czsKYWRkX2hlYWRlciAnQWNjZXNzLUNvbnRyb2wtQWxsb3ctTWV0aG9kcycgJ0dFVCwgUE9TVCwgUFVULCBERUxFVEUsIE9QVElPTlMnIGFsd2F5czsK",
            "mtime": "0001-01-01T00:00:00Z",
            "name": "cors-headers.tmpl.4aaf36d4a643.conf",
            "size": 159
          },
          {
            "contents": "bG9jYXRpb24gL2hlYWx0aCB7CiAgICBhY2Nlc3NfbG9nIG9mZjsKICAgIHJldHVybiAyMDAgImhlYWx0aHlcbiI7CiAgICBhZGRfaGVhZGVyIENvbnRlbnQtVHlwZSB0ZXh0L3BsYWluOwp9Cg==",
            "mtime": "0001-01-01T00:00:00Z",
            "name": "health-check.tmpl.78346de4dae4.conf",
            "size": 109
          }
        ],
        "name": "/etc/nginx/conf.d/augments"
      }
    ]
  },
  "errors": [
    {
      "file": "nginx.conf",
      "line": 3,
      "error": "upstream \"backend\" has no servers in /etc/nginx/nginx.conf:3"
    }
  ]
}
```

## Rendered file structure

When templates are successfully rendered, the system creates multiple files:

### Base template output

- **File:** Exact path specified in `conf_path`
- **Content:** Rendered base template with augment content injected at `augment_includes` points

### Augment template outputs

- **Location:** `{base_dir}/conf.d/augments/`
- **Filename:** `{template-name}.{content-hash}.conf`
- **Content:** Individual augment template rendered output

**Example structure:**

```
/etc/nginx/
├── nginx.conf                           # Base template output
└── conf.d/
    └── augments/
        ├── rate-limiting-http.abc123.conf      # HTTP context augment
        ├── rate-limiting-location.def456.conf  # Location context augment
        └── cors-headers.ghi789.conf            # Location context augment
```

**NGINX configuration:**

This is the output of `nginx -T` when such configuration is published to a data plane:

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
        server_name _;

        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }

        
        location / {
            proxy_pass http://example:8080;
            add_header 'Access-Control-Allow-Origin' 'https://app.example.com' always;
            add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;

        }
    }
}
```

## Understanding rendering order

Template rendering follows predictable ordering rules at two levels:

### Directive order within templates

Directives render in the exact order they appear in the template file. This includes the placement of `{{ augment_includes "context_path" . }}` extension points.

**Example:**

```nginx
http {
    # This renders first
    upstream backend { }
    
    # Augments targeting "http" context render here
    {{ augment_includes "http" . }}
    
    # This renders after augments
    server { }
}
```

### Augment render in submissions

When multiple augments target the same context, they render in the order specified in the submission request's augments array.

**Example submission:**

```json
{
  "conf_path": "/etc/nginx/nginx.conf",
  "base_template": {
    "object_id": "<id of your template object>",
    "values": {
      "backend_url": "http://example.com:8080"
    }
  },
  "augments": [
    {
      "object_id": "tmpl_rate_limit_zone",
      "target_context": "http"
    },
    {
      "object_id": "tmpl_upstream_definition", 
      "target_context": "http"
    }
  ]
}
```

**Rendered output:**

```text
http {
    # First augment renders first
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    
    # Second augment renders second
    upstream custom_backend {
        server 10.0.1.10:8080;
    }
}
```

### Why order matters

Some NGINX directives must appear before others.

For example:

- Rate limit zones must be defined before they're used
- Upstream blocks should be defined before server blocks reference them
- Map directives typically appear early in the http block

When composing templates submissions, arrange your augments array to match the required directive order for valid NGINX configuration.

## See also

- [Template Authoring Guide]({{< ref "author-templates.md" >}})
- [Add More Services]({{< ref "add-multiple-services.md" >}})
