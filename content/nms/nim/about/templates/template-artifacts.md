---
title: "Template Resource Files"
date: 2024-03-19T12:23:28-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 200
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["reference"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

## Config Template, Schema, and README Files


The following table outlines the key template resource files involved in creating NGINX configurations using NGINX Instance Manager. Each resource plays a distinct role in the configuration process, ranging from defining the structure and behavior of the NGINX configuration to validating the input parameters provided by users. 

The table categorizes these resources into configuration files (identified by their **.tmpl** extension and specific types), associated schema files that establish rules for data validation, and auxiliary documentation through **README.md** files, which offer comprehensive guidance on template usage and functionality.

{{<bootstrap-table "table table-striped table-bordered">}}
| Config File            | Applicable&nbsp;Type(s) | Schema File(s)                                       | Purpose                                                                                                              |
|------------------------|--------------------|---------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **base.tmpl**            | base               | **main.json**<br>**http.json**<br>**http-server.json**<br>**http-upstream.json**<br>**location.json**<br>**stream.json**<br>**stream-server.json**<br>**stream-upstream.json**                                         | <p>Required for templates designated as base. The schema files are optional if no user inputs are needed.</p> <p>Includes all directives required to produce a full NGINX configuration (for example, **main**, **http**, and **stream**). Additionally, this file should incorporate specific Go templating language commands that allow for the dynamic insertion of configuration details into the appropriate sections or directive blocks.
| **main.tmpl**            | augment            | **main.json**                             | Contains configuration and schema inputs for the **main** directive block. The schema file is optional if no user inputs are needed. See the full [alphabetical list of directives](https://nginx.org/en/docs/dirindex.html)         |
| **http.tmpl**            | augment            | **http.json**                             | Contains configuration and schema inputs for the [HTTP directive](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) block. The schema file is optional if no user inputs are needed.|
| **http-server.tmpl**     | augment            | **http-server.json**                      | Contains configuration and schema inputs for the [HTTP server directive](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block. The schema file is optional if no user inputs are needed. |
| **http-upstream.tmpl**   | augment            | **http-upstream.json**                    | Contains configuration and schema inputs for the [HTTP upstream directive](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream) block. The schema file is optional if no user inputs are needed. |
| **location.tmpl**        | augment            | **location.json**                         | Contains configuration and schema inputs for the [HTTP server location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) directive block. The schema file is optional if no user inputs are needed. |
| **stream.tmpl**          | augment            | **stream.json**                           | Contains configuration and schema inputs for the [stream directive](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) block. The schema file is optional if no user inputs are needed. |
| **stream-server.tmpl**   | augment            | **stream-server.json**                    | Contains configuration and schema inputs for the [stream server directive](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#server) block. The schema file is optional if no user inputs are needed. |
| **stream&#8209;upstream.tmpl** | augment            | **stream&#8209;upstream.json**                  | Contains configuration and schema inputs for the [stream upstream directive](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#upstream) block. The schema file is optional if no user inputs are needed. |
| **README.md**            | base, augment      | n/a                                               | Provides documentation, usage instructions, and an overview of the template.                                        |
{{</bootstrap-table>}}

<br>

## Example: Enabling OIDC with templating and validation

This example shows how NGINX can be configured to use OIDC for authentication based on a template and validated user input. Using this setup, administrators can enable or disable OIDC authentication without having to dive too deep into NGINX configuration files. By using templating and schema validation, this approach simplifies configuration, making it more accessible and error-proof.

- **main.tmpl**

   In the following example, the **main.tmpl** template checks if OIDC (OpenID Connect) authentication should be enabled for the NGINX configuration based on the user's input. If the input specifies that OIDC is enabled, the template instructs NGINX to load a specific module (**ngx_http_js_module.so**) that's necessary for OIDC functionality.

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

   The following **main.json** acts as a blueprint for validating the structure and data types of user inputs provided to **main.tmpl**, with a particular emphasis on correctly configuring OIDC authentication by ensuring the enabled property within the "oidc" object is properly defined and used. The root property for **templateInput** is required and will be validated when analyzing a template.

   ``` json
   {
     "$schema": "https://json-schema.org/draft/2020-12/schema",
     "type": "object",
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

   An explanation of the JSON schema settings:

    - **Root property for `templateInput`**: The JSON schema defines a root property named `templateInput`. This property is necessary because it contains all the customizable parameters the user can provide for the template. The schema specifies that `templateInput` can be either an object (which holds configuration parameters) or null (indicating the absence of such parameters).

    - **OIDC object validation**: Within `templateInput`, there's a specific object named `oidc` meant to configure OIDC-related settings. The schema for the `oidc` object includes a boolean property named `enabled`. This property controls whether OIDC authentication is turned on (`true`) or off (`false`) for the NGINX configuration being generated.

    - **Input-validation for `oidc` object**: The `main.json` provides rules for validating the `oidc` object's inputs. For example, the `enabled` property within the `oidc` object must be a boolean. This ensures that the template receives correctly typed and structured data to generate the configuration correctly.

    - **Required properties**: The schema declares that within the `oidc` object, the `enabled` property is mandatory (`"required": ["enabled"]`). This means that any input provided for the `oidc` object must include a clear true/false value for `enabled`.
