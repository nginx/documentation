---
nd-docs: null
title: Import templates
toc: true
weight: 100
type:
- how-to
nd-product: NGINX One Console
---

## Overview

This guide explains how to work with configuration templates in NGINX One Console.

In this guide, you will learn how to:

- Import base and augment templates into NGINX One Console
- Submit templates with values for preview rendering
- Review the rendered configuration and any validation errors
- Save the configuration as a new Staged Config in NGINX One Console

## Before you start

Make sure you have the following:

- Access to the NGINX One Console in your organization. See [Before you begin]({{< ref "/nginx-one/getting-started.md#before-you-begin" >}}) in the Get started guide.  
- API credentials for the Templates API. See [Authenticate with the API]({{< ref "/nginx-one/api/authentication.md" >}}).  
- The `tar` command installed.  
- The **absolute path** to your NGINX configuration file (for example, `/etc/nginx/nginx.conf`). This path is required when submitting templates for preview.  

## Create template archives

This section provides step-by-step instructions to create template archives. You can import these archives into NGINX One Console with the Templates API.

### Archive structure requirements

Each template archive must contain:

- **Exactly one `.tmpl` file** (required) - contains your NGINX configuration template
- **One `schema.yaml` or `schema.json` file** (optional) - required only if your template uses variables. For more information, see [Schema Definitions]({{< ref "author-templates.md#schema-definitions" >}})
- **No other files** - additional files will be ignored or cause import failure

```text
<archive-name>.tar.gz
│
├── <template-file>.tmpl
└── <schema-file>.yaml
```

### Naming conventions

Use the following convention for archive and template file names:

#### Archive names

Name your archives to clearly reflect their specific use case:

**Good Examples:**
- `load-balancer-base.tar.gz` - Base template for load balancing
- `reverse-proxy-base.tar.gz` - Base template for reverse proxy
- `cors-headers.tar.gz` - Augment for Cross-Origin Resource Sharing (CORS) header configuration
- `ssl-termination.tar.gz` - Augment for SSL/TLS termination
- `rate-limiting-http.tar.gz` - Rate limiting for HTTP context
- `rate-limiting-location.tar.gz` - Rate limiting for location context

**Avoid Generic Names:**
- `template.tar.gz`
- `config.tar.gz`
- `nginx.tar.gz`

#### Template file names

**Base Templates:**
- The `.tmpl` filename extension doesn't affect the rendered output
- Content always renders to the main NGINX config path specified during submission
- Use descriptive names like `reverse-proxy.tmpl`

**Augment Templates:**
- The `.tmpl` filename becomes part of the rendered config filename. For example, filename as `cors-headers.tmpl` will render as `/etc/nginx/conf.d/augments/cors-headers.{hash}.conf`.
- Use clear, descriptive names that indicate the augment's purpose

### Step-by-Step archive creation

Before creating template archives, see the [Template Authoring Guide]({{< ref "author-templates.md" >}}) for guidance on:
- Choosing between base and augment template types
- Using Go template syntax
- Defining schema files for template variables
- Creating extensible templates with `augment_includes` Go custom function

#### 1. Create template directory structure

Create a dedicated directory for each template to ensure clean archives:

```bash
# Create your template workspace
mkdir -p templates/reverse-proxy-base
cd templates/reverse-proxy-base
```

#### 2. Add template files

Create your template and schema files in the directory:

```bash
# Create template file
cat > reverse-proxy.tmpl << 'EOF'
user nginx;
worker_processes auto;

events {
    worker_connections 1048;
}

http {
    server {
        listen 80;
        server_name _;
        
        location / {
            proxy_pass {{ .backend_url }};
            proxy_set_header Host $host;
        }
    }
}
EOF

# Create schema file (only if template uses variables)
cat > schema.yaml << 'EOF'
$schema: "http://json-schema.org/draft-07/schema#"
type: object
properties:
  backend_url:
    type: string
    description: "Backend server URL"
required:
  - backend_url
additionalProperties: false
EOF
```

#### 3. Create the archive

{{< call-out "important" "Important" >}}
Always create archives from within the template directory to ensure files are at the root level.
{{< /call-out >}}

```bash
# Create archive with files at root level
tar -czf ../reverse-proxy-base.tar.gz *

# Verify archive contents (should show files at root, no directories)
tar -tzf ../reverse-proxy-base.tar.gz
```

#### 4. Verify Archive Structure

Before importing, verify your archive structure:

```bash
# Check archive contents
tar -tzf reverse-proxy-base.tar.gz

# Extract to temporary location for verification
mkdir -p /tmp/verify-archive
tar -xzf reverse-proxy-base.tar.gz -C /tmp/verify-archive
ls -la /tmp/verify-archive/
```

**Expected contents of the compressed archive:**

``` text
reverse-proxy.tmpl
schema.yaml

### Complete example workflow

Here's a complete example creating multiple related templates:

```bash
# Create workspace
mkdir -p templates && cd templates

# Create base template
mkdir reverse-proxy-base && cd reverse-proxy-base
cat > reverse-proxy.tmpl << 'EOF'
user nginx;
worker_processes auto;

events {
    worker_connections 1048;
}

http {
    {{ augment_includes "http" . }}
    
    server {
        listen 80;
        server_name _;
        
        {{ augment_includes "http/server" . }}
        
        location / {
            proxy_pass {{ .backend_url }};
            {{ augment_includes "http/server/location" . }}
        }
    }
}
EOF

cat > schema.yaml << 'EOF'
$schema: "http://json-schema.org/draft-07/schema#"
type: object
properties:
  backend_url:
    type: string
    description: "Backend server URL"
required:
  - backend_url
additionalProperties: false
EOF

tar -czf ../reverse-proxy-base.tar.gz *
cd ..

# Create CORS augment template
mkdir cors-headers && cd cors-headers
cat > cors-headers.tmpl << 'EOF'
add_header 'Access-Control-Allow-Origin' '{{ .cors_allowed_origins }}' always;
add_header 'Access-Control-Allow-Methods' '{{ .cors_allowed_methods }}' always;
EOF

cat > schema.yaml << 'EOF'
$schema: "http://json-schema.org/draft-07/schema#"
type: object
properties:
  cors_allowed_origins:
    type: string
    default: "*"
  cors_allowed_methods:
    type: string
    default: "GET, POST, PUT, DELETE, OPTIONS"
required:
  - cors_allowed_origins
  - cors_allowed_methods
additionalProperties: false
EOF

tar -czf ../cors-headers.tar.gz *
cd ..

# Create augment without variables
mkdir health-check && cd health-check
cat > health-check.tmpl << 'EOF'
location /health {
    access_log off;
    return 200 "healthy\n";
    add_header Content-Type text/plain;
}
EOF
# No schema.yaml needed - template has no variables

tar -czf ../health-check.tar.gz *
cd ..

# Final structure
ls -la *.tar.gz
```

### Tips

1. **Do not create nested directories in archives**
   ```bash
   # Avoid - nested directory structure is not supported
   tar -czf template.tar.gz template-dir/
   
   # Correct - keep files at root level
   cd template-dir && tar -czf ../template.tar.gz *
   ```

2. **Do not include unnecessary files**
   ```bash
   # Avoid - hidden files, backups or other file extensions will be ignored
   tar -czf template.tar.gz *~ .* *.bak *.tmpl schema.yaml
   
   # Correct - only include required files
   tar -czf template.tar.gz *.tmpl schema.yaml
   ```

3. **Include a schema for templates with variables**
    - If your `.tmpl` file contains `{{ .variable }}`, you must include a schema file.
    - The import is rejected without a valid schema.

4. **Do not include multiple template files in one archive**
    - Each archive must contain exactly one `.tmpl` file
    - Create separate archives for related templates

### Ready to import

After creating the archives, import them using the [Import a template API]({{< ref "/nginx-one/api/api-reference-guide/#operation/importTemplate" >}}) operation.

#### Required API parameters

In addition to your template archive, the import API requires several parameters. Read the API specification for full details, but the key parameters include:

**name** (required):
- A unique name for the template within your organization. For clarity, use the same name as the archive (without the extension), for example, `reverse-proxy-base`, `cors-headers`, or `health-check`.

**type** (required):
- `base` - For main NGINX configuration templates
- `augment` - For templates that extend base configurations

**For Augment Templates Only**:
- **allowed_in_contexts** - Specify which contexts this augment can be included in (for example, `http`, `http/server`, or `http/server/location`). Knowing where an augment fits in the NGINX configuration structure is crucial for integration. See the [Template Authoring Guide]({{< ref "author-templates.md" >}}) for details on contexts and designing augments that integrate with base templates.

#### Import validation

During import, the system will validate:
- Archive structure (one .tmpl file, optional schema)
- Template syntax
- Schema validity (if provided)
- Variable references match schema definitions

{{< call-out "important" "Important" >}}
The `allowed_in_contexts` parameter is required to import augment templates. The import process checks that this parameter is included, but it doesn’t confirm whether the contexts are valid for your template’s NGINX directives. Context validation happens during template submission. Ensure your specified contexts match where your NGINX directives are allowed to appear to avoid submission errors.
{{< /call-out >}}

### Response format

#### Successful response (200 OK)

If the import succeeds, you'll receive a response like this:

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
  "name": "reverse-proxy-base",
  "object_id": "tmpl_0rQSkSNSTamthLQVtSZb1g",
  "type": "base"
}
```

```json
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
}
```

```json
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
}
```

## See also

- [Template Authoring Guide]({{< ref "author-templates.md" >}})
- [Submit Templates Guide]({{< ref "submit-templates.md" >}})

