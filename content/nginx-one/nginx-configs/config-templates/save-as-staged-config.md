---
nd-docs: null
title: Save rendered config as staged config
toc: true
weight: 300
type:
- how-to
nd-product: NGINX One Console
---

# Overview

This guide explains how to save a [Submission]({{< ref "submit-templates.md#make-the-request" >}}) response as a new [Staged Config]({{< ref "/nginx-one/nginx-configs/staged-configs" >}}).

# How to save

The workflow involves two main steps:

1. **Submit templates for preview** - Use the [Submit Templates Guide]({{< ref "submit-templates.md" >}}) to render configuration
2. **Save as staged config** - Create a staged configuration object from the preview

## Step 1: Submit templates for preview

First, use the [Submit templates]({{< ref "submit-templates.md#make-the-request" >}}) API operation to preview the configuration.

## Step 2: Save as staged configuration

{{< call-out "tip" >}}
You can save an NGINX configuration preview as a staged config, even if it contains parse errors.
{{< /call-out >}}

Use the `config` object from the API response in step 1 to create a staged configuration.

### Make the request

Use the [Create a staged config]({{< ref "/nginx-one/api/api-reference-guide/#operation/createStagedConfig" >}}) API operation.

### Request body

Take the entire `config` object from the template submission response and wrap it in a `name` field.

**Required fields:**
- `name` - Descriptive name for the staged configuration
- `config` - The complete `config` object from the template submission response

**Optional fields:**
- `description` - Details about the configuration purpose or changes

Here's an example of what you need to include with the API request:

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

### Response format

**Successful response (201 Created):**

```json
{
  "name": "API Gateway",
  "object_id": "sc_lGsm5mn2SW2dWUe8CmOOOg"
}
```

## See also

- [Submit Templates Guide]({{< ref "submit-templates.md" >}})
- [Staged Configs]({{< ref "/nginx-one/nginx-configs/staged-configs" >}})


