---
f5-content-type: how-to
f5-product: NGINX One Console
title: Submit templates
toc: true
weight: 200
---

# Template submission guide

This guide explains how to submit templates to render and deploy NGINX configurations, and how to manage existing submissions using the Templates API.

Before submitting templates, you need to import them into NGINX One Console.

- See the [Import Templates Guide]({{< ref "import-templates.md" >}}) for instructions on creating and importing templates.
- For guidance on writing templates, see the [Template Authoring Guide]({{< ref "author-templates.md" >}}).

## Overview

Template submission allows you to compose templates that generate a complete NGINX configuration and deploy it to a target. The process involves:

1. **Discovering templates** - Find base and augment templates that match your infrastructure needs
1. **Understanding capabilities** - Review what contexts and features the base template supports
1. **Selecting augments** - Choose augments for additional features (CORS, rate limiting, SSL, etc.)
1. **Providing values** - Supply values for all template variables
1. **Submit** - Submit the composed request to render the NGINX configuration and create a staged config

To review the rendered configuration before committing, use [preview mode](#preview-mode-preview_onlytrue) with `preview_only=true`. See [Save rendered config as staged config]({{< ref "save-as-staged-config.md" >}}) for the preview-first workflow.

## Template discovery

Before creating a submission, find base and augment templates that match your infrastructure needs.

### List available templates

Use the [List Templates]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/listTemplates" >}}) API operation to find templates organized by use case.

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
      "created_at": "2025-09-25T19:20:47.473955Z",
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
- **is_f5_default** - When `true`, the template is provided by F5 and is immutable. These templates are also identified in the NGINX One Console by the F5 logo icon in the templates list.

The API response contains all information needed for creating a submission to render NGINX configurations. You need template details **only** if you want to examine the actual template content or variable requirements.

### Get template details (optional)

Use the [Retrieve a Template]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/getTemplate" >}}) API operation only when you need to examine template content or detailed variable requirements.

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
  "created_at": "2025-09-25T19:20:47.473955Z",
  "description": "",
  "items": [
    {
      "contents": "user nginx;\nworker_processes auto;\n\nhttp {\n    {{ augment_includes \"http\" . }}\n    \n    server {\n        listen 80;\n        server_name _;\n\n        {{ augment_includes \"http/server\" . }}\n        \n        location / {\n            proxy_pass {{ .backend_url }};\n            {{ augment_includes \"http/server/location\" . }}\n        }\n    }\n}\n",
      "ctime": "2025-09-25T19:20:47.473955Z",
      "file_format": "FILE_FORMAT_PLAIN",
      "file_type": "FILE_TYPE_TEMPLATE",
      "mime_type": "FILE_MIME_TYPE_TEXT",
      "name": "reverse-proxy.tmpl",
      "size": 338
    },
    {
      "contents": "$schema: \"http://json-schema.org/draft-07/schema#\"\ntype: object\nproperties:\n  backend_url:\n    type: string\n    description: \"Backend server URL\"\nrequired:\n  - backend_url\nadditionalProperties: false\n",
      "ctime": "2025-09-25T19:20:47.473955Z",
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

Use the [Submit templates for previewing NGINX configuration]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/submitTemplates" >}}) API operation to render NGINX configurations from templates.

The `preview_only` query parameter controls the mode:

{{<table>}}
| `preview_only` | Behavior | Response |
|---|---|---|
| `false` (default) | Renders the configuration, creates a persistent submission, and publishes to the target(s). | `202 Accepted` with submission `object_id` and target results. |
| `true` | Renders the configuration for inspection **without** creating a submission or publishing. | `200 OK` with the rendered NGINX configuration. |
{{</table >}}

## Request structure

The following sections describe what you need for the request.

### Configuration path (`conf_path`)

{{< call-out class="important" >}}

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

- `object_id` - Template version unique identifier (`tmplv_...`) for the version to use
- `values` - Key-value pairs for template variables

**Augment Templates:**

- `object_id` - Template version unique identifier (`tmplv_...`)
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

## Submission mode (default)

Use the [Submit Templates]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/submitTemplates" >}}) API operation without `preview_only=true` (or explicitly with `preview_only=false`) to render and persist a submission.

{{< call-out "note" >}}
**Current limitation:** Submission targets are currently limited to staged configurations. Targeting Config Sync Groups or instances directly is not yet supported.
{{< /call-out >}}

### Create a new staged config

Omit `target_object_ids` from the request body. The API renders the configuration and automatically creates a new staged config.

**Required fields:**

- `conf_path` - Configuration file path
- `base_template` - Base template version and values
- `augments` - Ordered list of augment templates (can be empty)
- `description` - A description for the submission (required in submission mode)

**Request body:**

```json
{
  "conf_path": "/etc/nginx/nginx.conf",
  "description": "Reverse proxy with rate limiting",
  "base_template": {
    "object_id": "tmplv_-uvR3F2TQGm18jnl7bpaGw",
    "values": {
      "backend_url": "http://example.com:8080"
    }
  },
  "augments": [
    {
      "object_id": "tmplv_-abR3F2TQGm18jnl7bpaXw",
      "target_context": "http",
      "values": {
        "zone_name": "req_limit",
        "memory": "10m",
        "rate": "10r/s"
      }
    }
  ]
}
```

**Successful response (202 Accepted):**

```json
{
  "object_id": "tmplsm_frBobKIAQ_21grAwV83VYz",
  "target_results": [
    {
      "staged_config_status": {
        "status": "succeeded"
      },
      "target_object_id": "sc_cEoiYCVJRuekVpYOvV1raA"
    }
  ]
}
```

The `object_id` in the response is your **submission ID** (`tmplsm_...`). Save this value — it is used to retrieve, update, or delete the submission later. The `target_object_id` is the newly created staged config.

### Update an existing staged config

Include `target_object_ids` in the request body with the ID of an existing staged config. The API renders the configuration and publishes it to the specified target.

**Request body:**

```json
{
  "conf_path": "/etc/nginx/nginx.conf",
  "description": "Reverse proxy with rate limiting - updated",
  "base_template": {
    "object_id": "tmplv_-uvR3F2TQGm18jnl7bpaGw",
    "values": {
      "backend_url": "http://example.com:8080"
    }
  },
  "augments": [
    {
      "object_id": "tmplv_-abR3F2TQGm18jnl7bpaXw",
      "target_context": "http",
      "values": {
        "zone_name": "req_limit",
        "memory": "10m",
        "rate": "10r/s"
      }
    }
  ],
  "target_object_ids": ["sc_cEoiYCVJRuekVpYOvV1raA"]
}
```

## Preview mode (`preview_only=true`)

Add `?preview_only=true` to the request URL to render the configuration for inspection without creating a submission or publishing to any target. This is useful for validating your template values before committing.

### Request body

Here's an example of what you need to include with the API request:

```json
{
  "conf_path": "/etc/nginx/nginx.conf",
  "base_template": {
    "object_id": "tmplv_-uvR3F2TQGm18jnl7bpaGw",
    "values": {
      "backend_url": "http://example.com:8080"
    }
  },
  "augments": [
    {
      "object_id": "tmplv_AFVNBQcoRDeV9jk9panxbw",
      "target_context": "http/server/location",
      "values": {
        "cors_allowed_origins": "https://app.example.com",
        "cors_allowed_methods": "GET, POST, PUT, DELETE, OPTIONS"
      }
    },
    {
      "object_id": "tmplv_rT6Ul8RvQtSZPkNfsIExPQ",
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

If the rendered configuration has NGINX syntax errors, you can use this information to debug and correct your submission request.

{{< call-out class="caution" >}}
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
            "contents": "<base64_encoded_nginx_conf>",
            "mtime": "0001-01-01T00:00:00Z",
            "name": "nginx.conf",
            "size": 371
          }
        ],
        "name": "/etc/nginx"
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

## Manage template submissions

Submissions are persistent objects that store the template composition and input values used to generate a configuration. Each submission tracks its target(s) and can be retrieved, updated, or deleted.

### Get a submission

Use the [Get a Template Submission]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/getTemplateSubmission" >}}) API operation (`GET /templates/submissions/{submissionObjectID}`) to retrieve the full details of a submission, including the templates used, their input values, and target object IDs.

**Example response:**

```json
{
  "object_id": "tmplsm_frBobKIAQ_21grAwV83VYz",
  "description": "Reverse proxy with rate limiting",
  "target_object_ids": ["sc_cEoiYCVJRuekVpYOvV1raA"],
  "created_at": "2025-09-25T19:20:47.473955Z",
  "modified_at": "2025-09-25T19:20:47.473955Z",
  "templates": [
    {
      "template_object_id": "tmpl_-uvR3F2TQGm18jnl7bpaGw",
      "template_version_object_id": "tmplv_-uvR3F2TQGm18jnl7bpaGw",
      "name": "reverse-proxy-base",
      "type": "base",
      "state": "final",
      "version": 1,
      "latest_version": 1,
      "values": {
        "backend_url": "http://example.com:8080"
      }
    }
  ]
}
```

### Update a submission

Use the [Update a Template Submission]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/updateTemplateSubmission" >}}) API operation (`PUT /templates/submissions/{submissionObjectID}`) to fully replace the input values and payloads for all templates in the submission.

The `conf_path` and target object IDs are preserved from the original submission and cannot be changed through this endpoint. After the update, the configuration is re-rendered and re-published to the existing target(s).

**Request body:**

```json
{
  "base_template": {
    "object_id": "tmplv_-uvR3F2TQGm18jnl7bpaGw",
    "values": {
      "backend_url": "http://new-backend.example.com:9090"
    }
  },
  "augments": [
    {
      "object_id": "tmplv_-abR3F2TQGm18jnl7bpaXw",
      "target_context": "http",
      "values": {
        "zone_name": "req_limit",
        "memory": "20m",
        "rate": "20r/s"
      }
    }
  ]
}
```

**Successful response (202 Accepted):**

```json
{
  "object_id": "tmplsm_frBobKIAQ_21grAwV83VYz",
  "target_results": [
    {
      "staged_config_status": {
        "status": "succeeded"
      },
      "target_object_id": "sc_cEoiYCVJRuekVpYOvV1raA"
    }
  ]
}
```

To preview the updated configuration before persisting, add `?preview_only=true` to the request. The response returns the re-rendered configuration as a `200 OK` without saving any changes.

### Update a single template's values

Use the [Update a single template's values in a submission]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/updateSingleTemplateSubmission" >}}) API operation (`PUT /templates/{templateObjectID}/submissions/{submissionObjectID}`) to update the input values for one specific template within a submission, without changing any other template's values.

All other templates in the submission retain their stored values. Payloads, target objects, and `conf_path` are preserved. The full configuration is re-rendered using the merged values and re-published to the existing target(s).

This is useful when only one template's configuration needs to change — for example, updating a rate limiting zone name without resubmitting the full composition.

**Request body:**

```json
{
  "values": {
    "zone_name": "api_limit",
    "memory": "10m",
    "rate": "5r/s"
  }
}
```

**Successful response (202 Accepted):** Same shape as the full update — the submission `object_id` and updated target results.

To preview the change before persisting, add `?preview_only=true`. The response returns the re-rendered configuration as a `200 OK` without saving any changes.

### Delete a submission

Use the [Delete a Template Submission]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/deleteTemplateSubmission" >}}) API operation (`DELETE /templates/submissions/{submissionObjectID}`) to permanently remove a submission.

{{< call-out "caution" >}}
Deleting a submission is **irreversible** and removes all stored input values and payloads for that submission. The target staged config is not affected — only the submission record is deleted.
{{< /call-out >}}

**Successful response:** `204 No Content`

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
    "object_id": "tmplv_-uvR3F2TQGm18jnl7bpaGw",
    "values": {
      "backend_url": "http://example.com:8080"
    }
  },
  "augments": [
    {
      "object_id": "tmplv_rate_limit_zone",
      "target_context": "http"
    },
    {
      "object_id": "tmplv_upstream_definition",
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

When composing template submissions, arrange your augments array to match the required directive order for valid NGINX configuration.

## See also

- [Template Authoring Guide]({{< ref "author-templates.md" >}})
- [Add Service-Specific Locations]({{< ref "add-multiple-services.md" >}})
- [Save rendered config as staged config]({{< ref "save-as-staged-config.md" >}})
