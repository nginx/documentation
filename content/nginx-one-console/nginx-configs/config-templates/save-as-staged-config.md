---
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: NGINX One Console
title: Save rendered config as staged config
toc: true
weight: 300
---

# Overview

This guide explains how to save a rendered NGINX configuration as a [Staged Config]({{< ref "/nginx-one-console/nginx-configs/staged-configs" >}}) using the Templates API.

There are two approaches:

- **[Direct submission](#direct-submission-recommended)** (recommended) — Submit templates with `preview_only=false` (the default). The API renders the configuration and automatically creates or updates a staged config in a single step. A persistent submission object is created to track the composition and allow future updates.
- **[Preview then save](#preview-then-save-alternative)** (alternative) — Submit templates with `preview_only=true` to get the rendered configuration for review, then manually call the staged config API to save it. No submission object is created.

Use the direct submission approach unless you specifically need to inspect or modify the rendered output before saving.

## Direct submission (recommended)

The direct approach renders the configuration and creates or updates the staged config in one API call, and stores a persistent submission that can be retrieved and re-used.

### Create a new staged config

Use the [Submit Templates]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/submitTemplates" >}}) API operation with `preview_only=false` (or omit the parameter — `false` is the default). Omit `target_object_ids` from the request body to create a new staged config automatically.

**Required fields:**

- `conf_path` - The absolute path for the NGINX configuration file
- `base_template` - The base template version and input values
- `augments` - Ordered list of augment templates (can be empty)
- `description` - A description for the submission

**Example request body:**

```json
{
  "conf_path": "/etc/nginx/nginx.conf",
  "description": "API Gateway reverse proxy",
  "base_template": {
    "object_id": "tmplv_-uvR3F2TQGm18jnl7bpaGw",
    "values": {
      "backend_url": "http://api-service:8080"
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

The `object_id` (`tmplsm_...`) is your **submission ID**. Save this value to retrieve, update, or delete the submission in the future. The `target_object_id` is the ID of the newly created staged config.

### Update an existing staged config

Include `target_object_ids` in the request body with the ID of an existing staged config. The API renders and publishes the configuration to that target.

```json
{
  "conf_path": "/etc/nginx/nginx.conf",
  "description": "API Gateway - updated backend",
  "base_template": {
    "object_id": "tmplv_-uvR3F2TQGm18jnl7bpaGw",
    "values": {
      "backend_url": "http://api-service-v2:8080"
    }
  },
  "augments": [],
  "target_object_ids": ["sc_cEoiYCVJRuekVpYOvV1raA"]
}
```

### Update a saved submission

Once a submission exists, use the [Update a Template Submission]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/updateTemplateSubmission" >}}) or [Update a single template's values]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/updateSingleTemplateSubmission" >}}) operations to re-render and re-publish to the same target(s) without specifying the target again. See [Manage template submissions]({{< ref "submit-templates.md#manage-template-submissions" >}}) for details.

## Preview then save (alternative)

Use this approach when you need to review or modify the rendered NGINX configuration before committing it as a staged config. This two-step workflow does not create a persistent submission object.

{{< call-out class="tip" >}}
You can save an NGINX configuration preview as a staged config, even if it contains parse errors.
{{< /call-out >}}

### Step 1: Submit templates for preview

Use the [Submit Templates]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/submitTemplates" >}}) API operation with `?preview_only=true`. This renders the full configuration and returns it in the response without creating any submission or publishing to any target.

**Example request URL:** `POST /api/v1/namespaces/{namespace}/templates/submissions?preview_only=true`

**Example request body:**

```json
{
  "conf_path": "/etc/nginx/nginx.conf",
  "base_template": {
    "object_id": "tmplv_-uvR3F2TQGm18jnl7bpaGw",
    "values": {
      "backend_url": "http://api-service:8080"
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
    }
  ]
}
```

**Example preview response (200 OK):**

```json
{
  "config": {
    "aux": [],
    "conf_path": "/etc/nginx/nginx.conf",
    "config_version": "17qlLiPmAqIWhhYxmVieE9mC5t92e+/7gIvz0GFRj/E=",
    "configs": [
      {
        "name": "/etc/nginx",
        "files": [
          {
            "name": "nginx.conf",
            "contents": "<base64_encoded_content>",
            "mtime": "0001-01-01T00:00:00Z",
            "size": 371
          }
        ]
      },
      {
        "name": "/etc/nginx/conf.d/augments",
        "files": [
          {
            "name": "cors-headers.tmpl.4aaf36d4a643.conf",
            "contents": "<base64_encoded_content>",
            "mtime": "0001-01-01T00:00:00Z",
            "size": 159
          },
          {
            "name": "health-check.tmpl.78346de4dae4.conf",
            "contents": "<base64_encoded_content>",
            "mtime": "0001-01-01T00:00:00Z",
            "size": 109
          }
        ]
      }
    ]
  },
  "errors": null
}
```

Review the rendered configuration. If you see parse errors in the `errors` array, refer to [Template Limitations]({{< ref "author-templates.md#template-limitations" >}}) for guidance.

### Step 2: Save as staged configuration

Use the `config` object from the preview response to create a staged configuration.

Use the [Create a staged config]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/createStagedConfig" >}}) API operation.

Take the entire `config` object from the preview response and wrap it with a `name` field.

**Required fields:**
- `name` - Descriptive name for the staged configuration
- `config` - The complete `config` object from the preview response

**Optional fields:**
- `description` - Details about the configuration purpose or changes

**Example request body:**

```json
{
  "name": "API Gateway",
  "description": "Reverse proxy configuration with CORS headers and health check endpoint",
  "config": {
    "aux": [],
    "conf_path": "/etc/nginx/nginx.conf",
    "config_version": "17qlLiPmAqIWhhYxmVieE9mC5t92e+/7gIvz0GFRj/E=",
    "configs": [
      {
        "name": "/etc/nginx",
        "files": [
          {
            "name": "nginx.conf",
            "contents": "<base64_encoded_content>",
            "mtime": "0001-01-01T00:00:00Z",
            "size": 371
          }
        ]
      },
      {
        "name": "/etc/nginx/conf.d/augments",
        "files": [
          {
            "name": "cors-headers.tmpl.4aaf36d4a643.conf",
            "contents": "<base64_encoded_content>",
            "mtime": "0001-01-01T00:00:00Z",
            "size": 159
          },
          {
            "name": "health-check.tmpl.78346de4dae4.conf",
            "contents": "<base64_encoded_content>",
            "mtime": "0001-01-01T00:00:00Z",
            "size": 109
          }
        ]
      }
    ]
  }
}
```

**Successful response (201 Created):**

```json
{
  "name": "API Gateway",
  "object_id": "sc_lGsm5mn2SW2dWUe8CmOOOg"
}
```

## See also

- [Submit Templates Guide]({{< ref "submit-templates.md" >}})
- [Staged Configs]({{< ref "/nginx-one-console/nginx-configs/staged-configs" >}})
