---
nd-docs: DOCS-000
title: Author templates
toc: true
weight: 10
type:
- how-to
---

# Overview

This guide explains how to write NGINX configuration templates for NGINX One Console, including Go template syntax, schema definitions, and platform-specific features.

## General terms

{{<bootstrap-table "table table-striped table-bordered">}}
| Term        | Definition |
|-------------|-------------|
| **Template** | A reusable NGINX configuration file written using Go template syntax that can accept variables for customization. Templates can be either base templates (complete configurations) or augment templates (modular additions). Templates must use the `.tmpl` file extension and are imported into NGINX One Console for use in submissions. |
| **Base Template** | A template that defines the complete structure of an NGINX configuration file, including top-level directives and main configuration hierarchy. Contains directives like `user`, `worker_processes`, and `events` blocks. Renders to the main NGINX configuration file path. Only one base template can be used per submission. |
| **Augment Template** | A template that adds functionality to base templates. Contains NGINX directives for specific contexts (like headers or location blocks). Gets inserted at extension points in base templates and renders to separate files in `/etc/nginx/conf.d/augments/`. Multiple augments can be used in a single submission. |
| **Child Augment** | An augment nested within another augment, creating hierarchical configurations. Child augments render only within their parent augment's output and are specified in the `child_augments` property during submission. |
| **Context Path** | A path notation representing the hierarchical structure of NGINX configuration blocks (e.g., `http`, `http/server`, `http/server/location`). Used to specify where augments can be inserted in base templates via `augment_includes` and where augments target during submission via `target_context`. |
| **Extension Point** | A placeholder in a template using `{{ augment_includes "context_path" . }}` that marks where augment content can be inserted during rendering. Base templates use extension points to enable modular composition with augments. |
| **Schema** | A JSON Schema Draft 7 file (YAML or JSON format) that defines template variables, their types, descriptions, and validation rules. Required for templates that use variables. Schema properties become available as template variables via dot notation. |
| **Template Submission** | The process of composing base and augment templates with values to render a complete NGINX configuration. Submissions are currently preview-only and generate rendered configurations that can be saved as Staged Configs. |
| **Template Variable** | A placeholder in a template (e.g., `{{ .backend_url }}`) that gets replaced with user-provided values during rendering. All variables must be defined in the template's schema and provided during submission if marked as required. |
{{</bootstrap-table>}}

## Template types

NGINX One supports two template types that serve different purposes. Understanding which type to use is critical since the system does not validate template type during import. You must correctly identify the type based on your template's content.

### Base templates

Base templates define the complete structure of an NGINX configuration file, including top-level directives and the main configuration hierarchy.

**Characteristics:**
- Contains top-level NGINX directives (`user`, `worker_processes`, `events`)
- Defines the main configuration structure (`http`, `stream`, `events` blocks)
- Renders to the main NGINX configuration file path (e.g., `/etc/nginx/nginx.conf`)
- Only one base template can be used per [Submission]({{< ref "submit-templates.md" >}})

**Rule of Thumb:** If your template looks like a complete `nginx.conf` file with an `events {}` block and top-level directives, it's a base template.

**Example Structure:**
```nginx
user nginx;
worker_processes auto;

events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        location / {
            proxy_pass http://backend:8080;
        }
    }
}
```

### Augment templates

Augment templates add functionality to existing configuration structures. They contain NGINX directives that fit within specific contexts.

**Characteristics:**
- Contains context-specific directives (location blocks, headers, upstream definitions)
- Gets inserted at extension points in base templates
- Renders to separate files in `/etc/nginx/conf.d/augments/`
- Multiple augments can be used in a single submission

**Rule of Thumb:** If your template contains only directives that would normally go inside an NGINX block (like inside `http`, `server`, or `location`), it's an augment template.

**Example:**
```nginx
add_header 'Access-Control-Allow-Origin' '*' always;
add_header 'Access-Control-Allow-Methods' 'GET, POST' always;
```

### Type declaration during import

When [Importing]({{< ref "import-templates.md#ready-to-import" >}}) templates, you must explicitly declare the type.

## Go template syntax

NGINX One templates use Go's built-in template engine. For complete Go template syntax, please refer to the [official Go template documentation](https://pkg.go.dev/text/template).

**NGINX One Console Specifics:**
- Standard Go template syntax is fully supported
- Custom functions are documented in [Making Templates Extensible](#making-templates-extensible)
- [Sprig Functions](https://masterminds.github.io/sprig/) are NOT supported

### Validation timing

Template syntax is validated during [Import]({{< ref "import-templates.md" >}}). NGINX directive syntax is validated when configurations are rendered during [Submission]({{< ref "submit-templates.md" >}}) preview.

{{< call-out "note" >}}
When any unsupported template syntax is used, you will see a validation error during the import operation
{{< /call-out >}}

### Template design best practices

**Keep templates focused:**
- Each template should have a single, clear purpose
- Keep conditional logic simple
- Use variables for configuration, not behavior changes

**Use descriptive variable names:**
```nginx
# Good
proxy_pass {{ .backend_url }};
server_name {{ .primary_domain }};

# Avoid
proxy_pass {{ .url }};
server_name {{ .name }};
```

## Schema definitions

Templates that use variables must include schema files for validation and UI generation. Schemas use JSON Schema Draft 7 format and can be written in YAML or JSON.

### Schema requirements

- Schema files are optional only if the template has no variables
- If variables are used in the template, schema file is required
- All variables used in the template must be defined in the schema
- Use required array to specify variables that must be provided during submission
- Variables not in the required array are optional; if not provided, they render as empty strings

{{< call-out "important" >}}
All variables used in your template must be explicitly provided during submission if they are in the `required` array. Optional variables (not in `required`) will render as empty strings if not provided - ensure your template handles this appropriately using Go template conditionals if needed.
{{< /call-out >}}

### Basic schema structure

```yaml
$schema: "http://json-schema.org/draft-07/schema#"
type: object
properties:
  # Variable definitions
required:
  # Required variables
additionalProperties: false # Disallow properties not defined in schema
```

The `additionalProperties: false` setting ensures strict validation. Only variables explicitly defined in properties can be provided by the user. This catches typos and configuration errors early.

### Schema-to-template mapping

Variables defined in your schema become available in your template through Go's template syntax using dot (`.`) notation.

**How it works:**
1. Each property in your schema's `properties` section becomes a template variable
2. Access variables in templates using `{{ .property_name }}`. If `property_name` has nested properties, you can access them using further dot notation, like `{{ .property_name.nested_property_name }}`.
3. The `.` represents the data object containing all schema-defined variables

**Example:**

**schema.yaml:**
```yaml
$schema: "http://json-schema.org/draft-07/schema#"
type: object
properties:
  backend_url:
    type: string
    description: "Backend server URL"
  listen_port:
    type: integer
    description: "Port number"
required:
  - backend_url
  - listen_port
additionalProperties: false
```

In your template:

```text
server {
    listen {{ .listen_port }};
    location / {
        proxy_pass {{ .backend_url }};
    }
}
```

During [Submission]({{< ref "submit-templates.md" >}}), users provide values for these variables, which are then inserted into the template during rendering.

{{< call-out "important" >}}
- Every variable used in your template must be defined in the schema
- All variables used in templates must be provided during submission
{{< /call-out >}}

### Variable Types

**String:**
```yaml
properties:
  backend_url:
    type: string
    description: "Backend server URL"
```

**Integer:**
```yaml
properties:
  listen_port:
    type: integer
    description: "Port number"
```

**Boolean:**
```yaml
properties:
  enable_ssl:
    type: boolean
    description: "Enable SSL/TLS"
```

**Array:**
```yaml
properties:
  server_names:
    type: array
    description: "List of server names"
    items:
      type: string
```

### Schema design best practices

**Provide clear descriptions:**
```yaml
backend_url:
  type: string
  description: "Backend server URL (e.g., http://api-service:8080)"
listen_port:
  type: integer
  description: "Port number (1-65535)"
```

**Use snake_case for variable names:**
```yaml
properties:
  server_names:
    type: array
    description: "List of server names"
    items:
      type: string
```

## Base template example

Here's a complete, self-contained base template that requires no augmentation. This template is complete and ready to use. It includes all necessary configuration for a reverse proxy with load balancing, health checks, and proxy settings. Users provide values for variables during submission, and the template renders a fully functional NGINX configuration.

**reverse-proxy.tmpl:**
```nginx
user nginx;
worker_processes {{ .worker_processes }};

events {
    worker_connections {{ .worker_connections }};
}

http {
    # Logging
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    
    # Basic settings
    sendfile on;
    tcp_nopush on;
    keepalive_timeout 65;
    
    # Upstream backend
    upstream backend {
    {{- range .upstream_servers }}
        server {{ . }};
    {{- end }}
    }
    
    # Main server
    server {
        listen {{ .listen_port }};
        server_name{{ range .server_names }} {{ . }}{{ end }};
        
        # Health check endpoint
        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
        
        # Proxy to backend
        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            
            proxy_connect_timeout {{ .proxy_timeout }};
            proxy_read_timeout {{ .proxy_timeout }};
        }
    }
}
```

**schema.yaml:**
```yaml
$schema: "http://json-schema.org/draft-07/schema#"
type: object
properties:
  worker_processes:
    type: integer
    description: "Number of worker processes"
  worker_connections:
    type: integer
    description: "Worker connections limit"
  listen_port:
    type: integer
    description: "Port to listen on"
  server_names:
    type: array
    description: "Server domain names"
    items:
      type: string
  upstream_servers:
    type: array
    description: "Backend server addresses (host:port)"
    items:
      type: string
  proxy_timeout:
    type: string
    description: "Proxy timeout value"
required:
  - worker_processes
  - worker_connections
  - listen_port
  - server_names
  - upstream_servers
  - proxy_timeout
additionalProperties: false
```

## Making templates extensible

If you want to allow others to extend your base template with additional functionality, you can add extension points using the `augment_includes` custom function.

**You don't need extensibility if:**
- Creating a single-purpose, self-contained configuration
- All behavior is controlled through template variables

**You need extensibility if:**
- Building a template system that others can enhance
- Want to enable optional features (CORS, rate limiting, auth) without bloating the base
- Creating reusable templates with plug-in architecture

**When in doubt:** Start without extension points. You can always create a new version of your template with extension points added later. It's easier to add extensibility than to remove it once others depend on it.

### `augment_includes` Custom Function

**Syntax:**
```nginx
{{ augment_includes "context_path" . }}
```

**Parameters:**
1. `"context_path"` (string) - The NGINX context where augments can be inserted
2. `.` (required) - Content for an augment template file must always be provided

### Config templates contexts

Contexts define hierarchy within NGINX configuration where augments can be inserted. NGINX One Console uses a path notation to represent the hierarchical structure of NGINX configuration blocks. This notation maps directly to NGINX's directive contexts.

```text
# NGINX Configuration
                                # main (root level)
http {                          # http
    upstream backend { }        # http/upstream
    
    server {                    # http/server
        location / { }          # http/server/location
    }
}

stream {                        # stream
    upstream backend { }        # stream/upstream
    
    server { }                  # stream/server
}
```

**Available Template Context Paths:**
- `main` - Main (root) level
- `http` - HTTP block level
- `http/server` - Server block within HTTP
- `http/server/location` - Location block within server
- `http/upstream` - Upstream block within HTTP
- `stream` - Stream block level
- `stream/server` - Server block within stream
- `stream/upstream` - Upstream block within stream

**Context Hierarchy:**
```
main (root)
├── http
│   ├── upstream
│   └── server
│       └── location
└── stream
    ├── upstream
    └── server
```

**Why This Matters:**
When NGINX directive documentation says a directive is valid in "http, server, location" contexts, you would specify `allowed_in_contexts: ["http", "http/server", "http/server/location"]` using path notation. The slash separators (`/`) represent the nesting hierarchy in your actual NGINX configuration.

### Modifying the base template

Here's how to add extension points to the simple base template from the previous section:

**reverse-proxy.tmpl** (with augmentation support):
```nginx
user nginx;
worker_processes {{ .worker_processes }};

events {
    worker_connections {{ .worker_connections }};
}

http {
    # Logging
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    
    # Basic settings
    sendfile on;
    tcp_nopush on;
    keepalive_timeout 65;
    
    # HTTP-level augments (rate limiting zones, upstream blocks, etc.)
    {{ augment_includes "http" . }}
    
    # Upstream backend
    upstream backend {
    {{- range .upstream_servers }}
        server {{ . }};
    {{- end }}
    }
    
    # Main server
    server {
        listen {{ .listen_port }};
        server_name{{ range .server_names }} {{ . }}{{ end }};
        
        # Server-level augments (SSL config, logging, error pages, etc.)
        {{ augment_includes "http/server" . }}
        
        # Health check endpoint
        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
        
        # Proxy to backend
        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            
            proxy_connect_timeout {{ .proxy_timeout }};
            proxy_read_timeout {{ .proxy_timeout }};
            
            # Location-level augments (CORS, auth, caching, etc.)
            {{ augment_includes "http/server/location" . }}
        }
    }
}
```

**What Changed:**
- Added `{{ augment_includes "http" . }}` in the http block for HTTP-level extensions
- Added `{{ augment_includes "http/server" . }}` in the server block for server-level extensions
- Added `{{ augment_includes "http/server/location" . }}` in the location block for location-level extensions
- Schema remains unchanged - extension points don't require schema modifications

**Extension Points Provided:**
- `http` - For rate limiting zones, additional upstream blocks, global HTTP settings
- `http/server` - For SSL configuration, custom logging, error pages
- `http/server/location` - For CORS headers, authentication, caching policies

### Extension point best practices

**Document extension points:**
```nginx
# Allow custom location-level configurations (CORS, auth, caching)
{{ augment_includes "http/server/location" . }}
```

**Strategic placement:**
- Place `augment_includes` where functionality commonly varies
- Consider NGINX directive ordering (order matters for some directives)
- Don't add extension points "just in case" - add them for known use cases

**Always pass the dot:**
```nginx
# ✅ Correct
{{ augment_includes "http/server" . }}

# ❌ Wrong - will cause errors
{{ augment_includes "http/server" }}
```

## Writing augment templates

Once a base template provides extension points, you can write augment templates that target those contexts.

### Determining allowed contexts

When writing an augment template, you must identify which NGINX contexts your directives are valid in. This determines where the augment can be inserted. 

This is a required input while [Importing Templates]({{< ref "import-templates.md" >}}) augment templates in Nginx One Console using the `allowed_in_contexts` parameter.

**Why This Matters :**

The contexts you specify constrain where users can place your augment during submission. Your choice affects flexibility and correctness:

- Specific contexts (e.g., ["http/server/location"]) - Ensures proper placement for endpoint-specific features like CORS headers, but limits where users can apply it. Essentially making this too restrictive.
- Multiple contexts (e.g., ["http", "http/server", "http/server/location"]) - Gives users flexibility to place the augment at different levels, but requires your directives to be valid in all those contexts. Essentially making this too permissive.

Best practice is to specify all contexts where your directives are technically valid according to NGINX documentation, then let users decide the appropriate level during submission.

Check the [NGINX directive documentation](https://nginx.org/en/docs/dirindex.html) for each directive you use. Each directive page specifies its valid contexts (e.g., "Context: http, server, location").

### Context determination rules

#### Single context

If your directives are only valid in one context, specify only that context:
```nginx
# Only valid in http block
limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
```
Allowed contexts: `["http"]`

#### Multiple valid contexts

If your directives work in multiple contexts, list all valid ones:
```nginx
# Valid in http, server, and location blocks
add_header X-Custom-Header "value";
```
Allowed contexts: `["http", "http/server", "http/server/location"]`

### How augments are rendered

When submitted together, augment content is inserted at matching `augment_includes` context paths in the base template.

For complete details on the submission and rendering process, see [Understanding Rendering Order]({{< ref "submit-templates.md#understanding-rendering-order" >}}).

### Complete augment examples

Refer to [NGINX directive index](https://nginx.org/en/docs/dirindex.html) for all directives used in the examples below.

**CORS Headers:**

NGINX docs show `add_header` directive is valid in `http`, `server`, or `location` contexts.

**cors-headers.tmpl:**
```nginx
add_header 'Access-Control-Allow-Origin' '{{ .cors_allowed_origins }}' always;
add_header 'Access-Control-Allow-Methods' '{{ .cors_allowed_methods }}' always;
add_header 'Access-Control-Allow-Headers' '{{ .cors_allowed_headers }}' always;
```

**schema.yaml:**
```yaml
$schema: "http://json-schema.org/draft-07/schema#"
type: object
properties:
  cors_allowed_origins:
    type: string
    description: "Allowed origins for CORS"
  cors_allowed_methods:
    type: string
    description: "Allowed HTTP methods"
  cors_allowed_headers:
    type: string
    description: "Allowed headers"
required:
  - cors_allowed_origins
  - cors_allowed_methods
  - cors_allowed_headers
additionalProperties: false
```

**Import with:** `allowed_in_contexts: ["http", "http/server", "http/server/location"]`

---

**Rate Limiting Zone:**

NGINX docs show `limit_req_zone` is valid in `http` context only.

**rate-limit-zone.tmpl:**
```nginx
limit_req_zone $binary_remote_addr zone={{ .zone_name }}:{{ .zone_memory }} rate={{ .rate_limit }};
```

**schema.yaml:**
```yaml
$schema: "http://json-schema.org/draft-07/schema#"
type: object
properties:
  zone_name:
    type: string
    description: "Rate limit zone name"
  zone_memory:
    type: string
    description: "Memory size for zone"
  rate_limit:
    type: string
    description: "Rate limit (e.g., 10r/s)"
required:
  - zone_name
  - zone_memory
  - rate_limit
additionalProperties: false
```

**Import with:** `allowed_in_contexts: ["http"]`

---

**Server Block:**

NGINX docs show `server` blocks appear in `http` or `stream` contexts.

**server-block.tmpl:**
```nginx
server {
    listen {{ .listen_port }};
    server_name{{ range .server_names }} {{ . }}{{ end }};
    
    {{ augment_includes "http/server/location" . }}
}
```

**schema.yaml:**
```yaml
$schema: "http://json-schema.org/draft-07/schema#"
type: object
properties:
  listen_port:
    type: integer
    description: "Port to listen on"
  server_names:
    type: array
    description: "Server domain names"
    items:
      type: string
required:
  - listen_port
  - server_names
additionalProperties: false
```

**Import with:** `allowed_in_contexts: ["http", "stream"]`

## Template Limitations

- Template files must use the `.tmpl` file extension
- Templates cannot reference external files - all configuration must be contained within the template content
- External file references (such as `include /etc/nginx/mime.types`) are not supported

## See also

- [Import Templates]({{< ref "import-templates.md" >}})
- [Submit Templates Guide]({{< ref "submit-templates.md" >}})

