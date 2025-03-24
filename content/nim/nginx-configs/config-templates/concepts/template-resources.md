---
title: Template resource files
draft: false
description: ''
weight: 200
toc: true
docs: DOCS-1501
personas:
- devops
- netops
- secops
- support
type:
- reference
---

## Config Template, Schema, and README Files

F5 NGINX Instance Manager uses [Go templating](https://pkg.go.dev/text/template) and JSON schemas to create flexible and robust NGINX configuration templates. This allows users to efficiently customize and validate configurations without needing expert knowledge of NGINX syntax.

{{<call-out "tip" "Enhanced templating with Sprig">}}<i class="fas fa-code-branch"></i>
 Go templating in Instance Manager includes support for the [Sprig function library](https://masterminds.github.io/sprig/), offering a wide range of additional functions that can be used in templates for advanced operations like string manipulation, data conversion, mathematics, and more. {{</call-out>}}

This guide covers the following resource files for creating templates:

- **Config files** (`*.tmpl`), which are Go templates that define the NGINX configuration's structure and parameters.
- **Schema files** (`*.json`), which are JSON schemas specifing the rules for input validation and providing the structure for dynamic web forms.
- **README.md** files, which document the template's purpose, usage, and capabilities.

If you're creating templates from scratch, the following table lists the acceptable template and schama filenames to use:

{{<bootstrap-table "table table-responsive table-striped table-bordered">}}
| Config File            | Applicable&nbsp;Type(s) | Schema File(s)                                       | Purpose                                                                                                              |
|------------------------|--------------------|---------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **base.tmpl**            | base               | **main.json**<br>**http.json**<br>**http-server.json**<br>**http-upstream.json**<br>**location.json**<br>**stream.json**<br>**stream-server.json**<br>**stream-upstream.json**                                         | <p>Required for templates designated as base. The schema files are optional for templates that don't require user inputs.</p><p>The template file should include all directives needed to create a complete NGINX configuration, such as **main**, **http**, and **stream**. Also, it should have specific Go templating language commands to insert dynamic configuration details into the right sections or directive blocks.</p><p>Example for **main** directive block:<br>`{{ $input.ExecTemplateAugments "main" }}`</p>
| **main.tmpl**            | augment            | **main.json**                             | Contains configuration and schema inputs for the **main** directive block. The schema file is optional for templates that don't require user inputs. See the full [alphabetical list of directives](https://nginx.org/en/docs/dirindex.html)         |
| **http.tmpl**            | augment            | **http.json**                             | Contains configuration and schema inputs for the [HTTP directive](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) block. The schema file is optional for templates that don't require user inputs.|
| **http-server.tmpl**     | augment            | **http-server.json**                      | Contains configuration and schema inputs for the [HTTP server directive](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block. The schema file is optional for templates that don't require user inputs. |
| **http-upstream.tmpl**   | augment            | **http-upstream.json**                    | Contains configuration and schema inputs for the [HTTP upstream directive](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream) block. The schema file is optional for templates that don't require user inputs. |
| **location.tmpl**        | augment            | **location.json**                         | Contains configuration and schema inputs for the [HTTP server location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) directive block. The schema file is optional for templates that don't require user inputs. |
| **stream.tmpl**          | augment            | **stream.json**                           | Contains configuration and schema inputs for the [stream directive](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) block. The schema file is optional for templates that don't require user inputs. |
| **stream-server.tmpl**   | augment            | **stream-server.json**                    | Contains configuration and schema inputs for the [stream server directive](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#server) block. The schema file is optional for templates that don't require user inputs. |
| **stream&#8209;upstream.tmpl** | augment            | **stream&#8209;upstream.json**                  | Contains configuration and schema inputs for the [stream upstream directive](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#upstream) block. The schema file is optional for templates that don't require user inputs. |
| **README.md**            | base, augment      | n/a                                               | Provides documentation, usage instructions, and an overview of the template.                                        |
{{</bootstrap-table>}}

<br>

## Example: Enable OIDC with main.tmpl

This example shows how to enable OIDC authentication in NGINX using a config template and user input. This templated approach with JSON schema validation simplifies updating the NGINX configuration and reduces the risk of errors.

- **main.tmpl**

   A template file, **main.tmpl**, checks if OIDC (OpenID Connect) authentication should be enabled in the NGINX configuration based on user input. If the input enables OIDC, the template instructs NGINX to load the **ngx_http_js_module.so** module necessary for OIDC functionality.

   ``` go
   {{$input := .}}
   {{$baseData := .Data.V1}}
   {{$oidcEnabled := false}}

   {{if $baseData.main}}
       {{if $baseData.main.templateInput}}
           {{$oidc := index $baseData.main.templateInput "oidc"}}
           {{if $oidc}}
               {{$oidcEnabled = index $oidc "enabled"}}
           {{end}}
       {{end}}

       {{if eq $oidcEnabled true}}
           load_module modules/ngx_http_js_module.so;
       {{end}}
   {{end}}
   ```

- **main.json**

   A JSON schema file, **main.json**, validates user inputs for **main.tmpl**, ensuring that the **oidc** object's **enabled** property is correctly defined and used. The **templateInput** root property is required and will be validated when analyzing the template.

   ``` json
   {
     "$schema": "https://json-schema.org/draft/2020-12/schema",
     "type": "object",
     "title": "Main inputs",
     "properties": {
   	"templateInput": {
   	  "type": [
   		"object",
   		"null"
   	  ],
   	  "properties": {
   		"oidc": {
   		  "type": "object",
   		  "title": "OIDC Setting",
   		  "description": "Adds OIDC settings to main, http, http-server and location blocks. Use OIDC to enable single sign-on (SSO) to authenticate to your app.",
   		  "__docs": [
   			{
   			  "title": "OIDC specification",
   			  "link": "https://openid.net/specs/openid-connect-core-1_0.html"
   			}
   		  ],
   		  "properties": {
   			"enabled": {
   			  "title": "OIDC authentication enabled",
   			  "type": "boolean",
   			  "description": "Set this value to be true, if location(s) can be accessed only after authentication by the OIDC provider configured at the gateway. If no authentication is needed set this value to be false.",
   			  "examples": [
   				true
   			  ]
   			}
   		  },
   		  "required": [
   			"enabled"
   		  ]
   		}
   	  }
       }
     },
     "required": []
   }
   ```

  <br>

  An explanation of the JSON schema settings:

  - **Root property for `templateInput`**: The JSON schema defines a root property named `templateInput`. This property is necessary because it contains all the customizable parameters the user can provide for the template. The schema specifies that `templateInput` can be either an object (which holds configuration parameters) or null (indicating the absence of such parameters).

  - **OIDC object validation**: Within `templateInput`, there's a specific object named `oidc` meant to configure OIDC-related settings. The schema for the `oidc` object includes a boolean property named `enabled`. This property controls whether OIDC authentication is turned on (`true`) or off (`false`) for the NGINX configuration being generated.

  - **Input-validation for `oidc` object**: The `main.json` provides rules for validating the `oidc` object's inputs. For example, the `enabled` property within the `oidc` object must be a boolean. This ensures that the template receives correctly typed and structured data to generate the configuration correctly.

  - **Required properties**: The schema declares that within the `oidc` object, the `enabled` property is mandatory (`"required": ["enabled"]`). This means that any input provided for the `oidc` object must include a clear true/false value for `enabled`.

---

## Additional Templating Resources

{{< include "nim/templates/additional-templating-resources.md" >}}
