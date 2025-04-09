---
title: Round-robin reverse proxy with an augment template
draft: false
description: Learn how to set up a round-robin reverse proxy using NGINX Instance
  Manager with base and augment templates.
weight: 100
toc: true
docs: DOCS-1655
type:
- tutorial
---

## Overview

This tutorial guides you through setting up a round-robin reverse proxy using base and augment templates in NGINX Instance Manager. It's intended for network administrators and developers familiar with basic NGINX configurations.

Using templates, especially augment templates, provides significant advantages. Augment templates allow you to modify and extend configurations without altering the base template, making it easier to manage and update settings. This approach enhances modularity, enabling specific teams to control parts of the configuration while maintaining overall system integrity. For instance, using an augment template for round-robin reverse proxy settings allows you to efficiently distribute incoming traffic across multiple servers, enhancing load balancing and reliability. [Role-Based Access Control (RBAC) for templates and template submissions]({{< ref "/nim/nginx-configs/config-templates/how-to/rbac-config-templates-and-submissions.md" >}}) ensures that only authorized users can make changes, promoting security and efficiency. This means that while administrators can manage the base configuration, development teams can independently manage specific proxy settings, improving collaboration and streamlining operations.

By the end, you'll be able to:

- Create and configure a base template.
- Create and configure an augment template to extend the functionality of the base template.
- Deploy these templates to manage traffic efficiently within your NGINX environment.

---

## Background

F5 NGINX Instance Manager simplifies the management of NGINX configurations across a wide network. Using templates, administrators can ensure consistent configurations while easily customizing individual settings with augment templates.

---

## Before you start

Before you start the tutorial, you should:

- [Install NGINX Instance Manager 2.16 or later]({{< ref "/nim/deploy/" >}}). If you're using an earlier version, you'll need to upgrade to access the features needed for this tutorial.
- Have administrative access to NGINX Instance Manager.
- Understand basic concepts of web servers and reverse proxies.
- Have basic knowledge of [Go templates](https://pkg.go.dev/text/template), [JSON schema](https://json-schema.org), and the [NGINX configuration syntax](https://nginx.org/en/docs/beginners_guide.html).

---

## Create the base template

In this section, you'll learn how to create a [base config template]({{< ref "nim/nginx-configs/config-templates/concepts/config-templates.md" >}}).

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. From the Launchpad menu, choose **Instance Manager**.
3. On the left menu, select **Templates**.
4. Select **Create**.
5. Select **New**.
6. Give the template a name. For this tutorial, we'll call the base template **rr_base_template**.
7. Optionally, provide a description for the template. (For example, **Round-Robin Base Template**)
8. Select **Draft** for the template status.
9. Select **Base** for the template type.
10. Select **Submit**.

### Add the base template files

Here, you'll add the necessary Go template and JSON schema files to your base template.

1. On the **Template > Overview** page, select **rr_base_template**.
2. Add the config template file:
   - Select **Add File**.
   - Select **Config File**, then select **base.tmpl**.
   - Select **Add**.
3. Add the schema files:
   - Select **Add File**.
   - Select **Schema File**, then select each of the following: **http-server.json**, **http-upstream**, and **location.json**.
   - Select **Add**.

Your base template should now include the following files:

{{<img src="/nim/templates/round-robin-base-template-files.png" alt="List of template files including base.tmpl, http-server.json, http-upstream.json, and location.json" width="300" height="auto">}}

### Add the base.tmpl file details {#base-tmpl}

This snippet defines the structure of the final NGINX configuration file. It uses [Go's text/template](https://pkg.go.dev/text/template) module to dynamically add input into the NGINX configuration. You can identify where augment templates will be inserted by looking for lines like:

{{<call-out "tip" "Augment template injection point" "fas fa-code-branch" >}}
``` go
{{ $input.ExecTemplateAugments "main" }}
```
{{</call-out>}}

The word "main" can be replaced with other augment injection points, such as "http-server" or "http-upstream."

1. In the template file list, select **base.tmpl**.
2. Copy and paste the following Go template into the **base.tmpl** file editor.
3. Select **Save** (disk icon).

``` go
{{/*
    A simple base template that provides augment injection points for
    the main context, the http context, upstreams, servers, and locations.
*/}}
{{ $input := .}}
{{ $baseData := .Data.V1}}

{{/* Inject augments targeting the main context here */}}
{{ $input.ExecTemplateAugments "main" }}
events {
    worker_connections  1024;
}

http {
    {{/* Inject augments targeting the http context here */}}
    {{ $input.ExecTemplateAugments "http" }}
    {{ range $upstreamIndex, $upstream := $baseData.http.upstreams }}
          upstream {{$upstream.templateInput.nameInConfig}} {
              {{$upstreamTemplateInput := $upstream.templateInput}}
              {{range $serverIndex, $upstreamServer := $upstreamTemplateInput.servers}}
                  {{$port := ""}}
                  {{if $upstreamServer.port}}
                      {{$port = (printf ":%0.f" $upstreamServer.port)}}
                  {{end}}
                  server {{$upstreamServer.address}}{{$port}};
              {{end}}

              {{/* Inject augments targeting this $upstream here */}}
              {{ $input.ExecTemplateAugments "http-upstream" $upstream }}
          }
    {{end}}

    {{ range $serverIndex, $server := $baseData.http.servers}}
        server {
            server_name {{$server.templateInput.serverNameInConfig}};
            {{ range $locationIndex, $location := $server.locations}}
                location {{$location.templateInput.locationMatchExpression}} {
                  {{/* Inject augments targeting this $location here */}}
                  {{ $input.ExecTemplateAugments "location" $location $server }}
                }
            {{end}}

            {{/* Inject augments targeting this $server here */}}
            {{ $input.ExecTemplateAugments "http-server" $server }}
        }
    {{end}}
}
```

### Add the http-server.json file details

This snippet uses the [JSON Schema](https://json-schema.org/) specification to define fields for generating a user interface and serving as the data structure for inputs injected into the template.

To understand how this template connects to the [base template you just added](#base-tmpl), look for the `serverNameInConfig` reference in the code. This reference links the JSON schema fields to the configuration settings defined in the base template.

1. Select **http-server.json**.
2. Copy and paste the following JSON schema into the **http-server.json** file editor.
3. Select **Save** (disk icon).

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "HTTP Servers",
  "type": "object",
  "properties": {
    "templateInput": {
      "type": [
        "object",
        "null"
      ],
      "properties": {
        "serverName": {
          "title": "Server Label",
          "type": "string",
          "description": "Enter a unique label for the server. This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific server.",
          "examples": [
            "Example Server"
          ]
        },
        "serverNameInConfig": {
          "title": "Name",
          "type": "string",
          "description": "The name of the HTTP server. This value is used when matching incoming requests to the correct server.",
          "examples": [
            "example.com"
          ]
        }
      },
      "required": [
        "serverName",
        "serverNameInConfig"
      ]
    }
  },
  "required": []
}
```

### Add the http-upstream.json file details

1. Select **http-upstream.json**.
2. Copy and paste the following JSON schema into the **http-upstream.json** file editor.
3. Select **Save** (disk icon).

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "HTTP Upstreams",
  "type": "object",
  "properties": {
    "templateInput": {
      "type": [
        "object",
        "null"
      ],
      "properties": {
        "name": {
          "title": "Upstream Label",
          "type": "string",
          "description": "Enter a unique label for the upstream. This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific upstream.",
          "examples": [
            "Users Service"
          ]
        },
        "nameInConfig": {
          "title": "Name",
          "type": "string",

          "examples": [
            "users_backend"
          ]
        },
        "servers": {
          "type": "array",
          "title": "Upstream Servers",
          "items": {
            "type": "object",
            "properties": {
              "address": {
                "title": "Upstream server address",
                "type": "string",
                "description": "Specifies the address for the upstream server.",
                "examples": [
                  "users1.example.com",
                  "192.0.0.1"
                ]
              },
              "port": {
                "type": "integer",
                "title": "Port",
                "description": "Specifies the port for the upstream server.",
                "minimum": 1,
                "maximum": 65535,
                "examples": [
                  80
                ]
              }
            },
            "required": [
              "address"
            ]
          }
        }
      },
      "required": [
        "name",
        "servers",
        "nameInConfig"
      ]
    }
  },
  "required": []
}
```

### Add the location.json file details

The schema defined in **location.json** is used to create a user interface for defining multiple location blocks. To understand how this works with the template data, look at the [base.tmpl](#base-tmpl) file and find the section that begins with:

> ``` go
> {{ range $locationIndex, $location := $server.locations}}
> ```

Since only one augment will be defined, it's important to link the input from the augment template to a specific location block among the many defined by the user. Duplicate location blocks are generally not useful. To achieve this, the `nameExpression` field in this schema serves as the key element, connecting the content from the augment template to a specific location block. You will see this used in the **location.tmpl** file of the augment template in a later step.

1. Select **location.json**.
2. Copy and paste the following JSON schema into the **location.json** file editor.
3. Select **Save** (disk icon).

```json
{
 "$schema": "https://json-schema.org/draft/2020-12/schema",
 "title": "Locations",
 "type": "object",
 "properties": {
   "templateInput": {
     "type": [
       "object",
       "null"
     ],
     "properties": {
        "nameExpression": {
          "title": "Location Label",
          "type": "string",
          "description": "Enter a unique label for the location. This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific location.",
          "examples": [
            "Users Endpoint"
          ]
        },
       "locationMatchExpression": {
         "title": "Match Expression",
         "type": "string",
         "description": "The prefix to match request paths by.",
         "examples": [
           "/users"
         ]
       }
     },
     "required": [
       "nameExpression",
       "locationMatchExpression"
     ]
   }
 },
 "required": []
}
```

---

## Create the augment template

This section shows how to create an augment template that specifies additional configuration details not covered by the base template.

To create the augment template, take the following steps:

1. On the **Templates > Overview** page, select **Create**.
2. Select **New**.
3. Give the template a name. For this tutorial, we'll call the augment template **rr_aug_loc_proxy**.
4. Optionally, provide a description for the template. For example, **Round-Robin Location Proxy Augment**.
5. Select **Draft** for the template status.
6. Select **Augment** for the template type.
7. Select **Submit**.

### Add the augment template files

Here, you'll add the necessary Go template and JSON schema files to your augment template.

1. On the **Template > Overview** page, select **rr_aug_loc_proxy**.
2. Add the config template file:
   - Select **Add File**.
   - Select **Config File**, then select **location.tmpl**.
   - Select **Add**.
3. Add the schema files:
   - Select **Add File**.
   - Select **Schema File**, then select **location.json**.
   - Select **Add**.

Your augment template should now include the following files:

{{<img src="/nim/templates/round-robin-augment-template-files.png" alt="List of template files including base.tmpl, http-server.json, http-upstream.json, and location.json" width="300" height="auto">}}

### Add the location.tmpl details

This template determines which location block&mdash;among those defined by the template user in the NGINX Instance Manager web interface&mdash;should receive the specific configuration content. The essential part of the template that will appear in the final NGINX configuration is the line:

> ``` go
> proxy_pass http://{{ $arguments.upstreamName }};
> ```

The first part of the template checks the location's label, `nameExpression`, and matches it with the data provided by the user to the augment template. It then assigns this data to `$arguments`, which is used to generate the final configuration snippet. This snippet is then injected only into the targeted location block.

1. Select **location.tmpl**.
2. Copy and paste the following contents into the **location.tmpl** file editor.
3. Select **Save** (disk icon).

``` go
{{ $augmentData := .AugmentData.V1 }}
{{ $server := index .Args 1 }}
{{ $location := index .Args 0 }}
{{ $arguments := dict }}

{{/* Get the location label from the base template */}}
{{ $locationLabel := $location.templateInput.nameExpression | trim | lower }}

{{/* Check if there is a nameExpression (label) for this location ID */}}
{{ range $args := $augmentData.location.templateInput.locations }}
  {{ $targetLabel := $args.targetLabel | trim | lower }}
  {{ if (eq $targetLabel $locationLabel) }}
    {{ $arguments = $args }}
    {{ break }}
  {{ end

 }}
{{ end }}

{{/* If augment arguments related to this location were found, perform templating */}}
{{ if not (empty $arguments) }}
  proxy_pass http://{{ $arguments.upstreamName }};
{{ end }}
```

### Add the location.json details

1. Select **location.json**.
2. Copy and paste the following contents into the **location.json** file editor.
3. Select **Save** (disk icon).

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "Reverse Proxy Augment",
  "type": "object",
  "properties": {
    "templateInput": {
      "type": [
        "object",
        "null"
      ],
      "properties": {
        "locations": {
          "type": "array",
          "title": "Locations",
          "description": "To configure each location, the 'Label' you enter below must exactly match a 'Label' in the base template. This ensures the system can properly inject a reverse proxy directive targeting the specified upstream.",
          "items": {
            "type": "object",
            "properties": {
              "targetLabel": {
                "title": "Target Location Label",
                "type": "string",
                "description": "Enter the label for this configuration's target location. It must exactly match the 'Location Label' from a base template location to ensure the system correctly injects the augment inputs into the configuration.",
                "examples": [
                  "Main Location"
                ]
              },
              "upstreamName": {
                "type": "string",
                "title": "Upstream Name",
                "description": "Name of the target upstream. Must match exactly.",
                "examples": [
                  "upstream_1"
                ]
              }
            },
            "required": ["targetId", "upstreamName"]
          }
        }
      },
      "required": ["locations"]
    }
  },
  "required": []
}
```

---

## Generate and deploy the configuration {#generate-and-deploy-config}

Lastly, generate and deploy your configuration.

1. On the left navigation pane, select **Templates**.
2. Find **rr_base_template** in the list of templates. In the **Actions** column, select the ellipsis (three dots), then select **Preview and Generate**.
3. **Select the publication target**:
   - Select whether you're publishing the configuration to an instance, instance group, existing saved config, or saving as a new staged config.
   - Then select the specific target from the list. Or, if you're saving as a new staged config, provide the staged config name.
   - Select **Next**.
4. **Select the augment template**:
   - On the **Choose Augments** form, select **rr_aug_loc_proxy**.
   - Select **Next**.
5. **Add HTTP Server(s)**:
   - On the **HTTP Servers** form, select **Add HTTP Servers**.
   - Enter a unique label for the server (for example, **Round Robin Proxy**). This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific server.
   - Enter a server name (for example, **example.com**).
   - Add a server location:
     - In the **Server Locations** pane, select **Add Server Locations**.
     - Enter a unique label for the location (for example, **Users Endpoint**). This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific location. We'll refer to this label when we configure the augment template inputs.
     - Enter a match expression. This is the prefix to match request paths by (for example, **/users**).
   - Select **Next**.
6. **Add HTTP Upstream(s)**:

   In NGINX, an *upstream* refers to a group of servers that handle client requests. They are typically used for load balancing.

   - On the **HTTP Upstreams** form, select **Add HTTP Upstreams**.
   - Enter a unique label for the upstream (for example, **Users Service**). This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific upstream.
   - Enter an HTTP upstream name (for example, **users_backend**). We'll refer to this upstream name when we configure the augment template inputs.
   - Add an upstream server:
     - In the **Upstream Servers** pane, select **Add item**.
     - Enter the upstream server address (for example, **192.0.0.1**)
     - Enter the upstream server port (for example, **80**).
   - Select **Next**.
7. **Add the rr_aug_loc_proxy inputs**.
   - In the **Reverse Proxy Augment > Locations** pane, select **Add item**.
   - Enter the label for the target location. This is the label that you specified in step 5 when adding the HTTP server location (for example, **Users Endpoint**). Make sure the labels match exactly to correctly apply the augment templates.
   - Enter the upstream name. This is the name you specified in step 6 (for example, **users_backend**). Make sure the names match exactly.
   - Select **Next**.
8. **Preview the config**:

    On the **Preview Config** page, the resulting config should look similar to the following example:

    ```nginx
    # /******************************** !! IMPORTANT !! ********************************/
    #   This is a Template generated configuration. Updates should done through the Template
    #   Submissions workflow. Manual changes to this configuration can/will be overwritten.
    # __templateTag={"uid":"3c4f0137-058f-4275-a8e2-1a1077ae8e8c","file":"base.tmpl","name":"rr_base_template"}
    events {
    	worker_connections 1024;
    }
    http {
    	upstream users_backend {
    		server 192.0.0.1:80;
    	}
    	server {
    		server_name example.com;
    		location /users {

    # <<< BEGIN DO-NOT-EDIT location augment templates >>>

    			# __templateTag={"uid":"8c903bd1-c11f-4820-8f0b-d12418a41bad","file":"location.tmpl","name":"rr_aug_loc_proxy"}
    			include /etc/nginx/augments/location/base_http-server1_loc1_3c4f0137_8c903bd1-c11f-4820-8f0b-d12418a41bad.conf;

    # <<< END DO-NOT-EDIT location augment templates >>>

    		}
    	}
    }
    ```

9. If the configuration looks correct, select **Publish** to deploy it, or select **Save** if you're targeting a staged configuration.

---

## Verification steps

If you targeted an NGINX instance or instance group:

1. Open a secure connection to your instance(s) and log in.
2. Open the NGINX config (**/etc/nginx/nginx.conf**) with a text editor. The configuration file should match the config output you [previewed and generated in the previous section](#generate-and-deploy-config).
3. Next, look for a new file under */etc/nginx/augments/location/* directory with a name similar to **base_http-server1_loc1_[unique-id].conf**, where **[unique-id]** is a unique identifier string. Open this file in a text editor.
The contents should include the **proxy_pass** directive:

    ``` nginx
    proxy_pass http://users_backend;
    ```

<br>

If you targeted a staged config:

1. On the left menu, select **Staged Configs**.
2. Choose the name of the staged configuration you saved.
3. In the file viewer, select **nginx.conf**. The configuration file should match the config output you [previewed and generated in the previous section](#generate-and-deploy-config).
4. Then, look for a file in the */etc/nginx/augments/location/* directory with a name similar to **base_http-server1_loc1_[unique-id].conf**, where **[unique-id]** is a unique identifier string. The contents should include the **proxy_pass** directive:

    ``` nginx
    proxy_pass http://users_backend;
    ```

---

## References

- [Understanding Config Templates]({{< ref "/nim/nginx-configs/config-templates/concepts/config-templates.md" >}})
- [About Augment Templates]({{< ref "/nim/nginx-configs/config-templates/concepts/augment-templates.md" >}})
- [Manage NGINX Configs with Config Templates]({{< ref "/nim/nginx-configs/config-templates/how-to/manage-nginx-configs-with-templates.md" >}})
- [RBAC for Templates and Template Submissions]({{< ref "/nim/nginx-configs/config-templates/how-to/rbac-config-templates-and-submissions.md" >}})
