---
title: "Set up round-robin reverse proxy with an augment template"
date: 2024-03-12T16:01:58-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Enter a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["tutorial"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

<style>
  details {
    border: 1px dashed green;
    background-color: #f7f7f7;
    padding: 0px 15px 0px 15px;
  }
</style>


## Overview

## Create a new base template

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. From the Launchpad menu, choose **Instance Manager**.
3. On the left menu, select **Templates**.
4. Select **Create**.
5. Select **New**.
6. Give the template a name. For this tutorial, we'll call the base template *rr_base_template*.
7. Optionally, provide a description for the template. (For example *Round-Robin Base Template*)
8. Select **Draft** for the template status.
9. Select **Base** for the for type.
10. Select **Submit**.



### Add the base template files

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

### Add the base.tmpl file details

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

{{/* Augments targeting the main context are injected here */}}
{{ $input.ExecTemplateAugments "main" }}
events {
    worker_connections  1024;
}

http {
    {{/* Augments targeting the http context are injected here */}}
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

              {{/* Augments targeting the this $upstream are injected here */}}
              {{ $input.ExecTemplateAugments "http-upstream" $upstream }}
          }
    {{end}}

    {{ range $serverIndex, $server := $baseData.http.servers}}
        server {
            server_name {{$server.templateInput.serverNameInConfig}};
            {{ range $locationIndex, $location := $server.locations}}
                location {{$location.templateInput.locationMatchExpression}} {
                  {{/* Augments targeting the this $location are injected here */}}
                  {{ $input.ExecTemplateAugments "location" $location $server }}
                }
            {{end}}

            {{/* Augments targeting the this $server are injected here */}}
            {{ $input.ExecTemplateAugments "http-server" $server }}
        }
    {{end}}
}
```


### Add the http-server.json file details

1. Select **http-server.json**.
2. Copy and paste the following JSON schema into the **http-server.json** file editor.
3. Select **Save** (disk icon).

``` json
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
          "title": "Label",
          "type": "string",
          "description": "Enter a unique, case-sensitive alphanumeric label to identify the server. This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific server.",
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

``` json
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
          "title": "Label",
          "type": "string",
          "description": "Enter a unique, case-sensitive alphanumeric label to identify the upstream. This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific upstream.",
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

1. Select **location.json**.
2. Copy and paste the following JSON schema into the **location.json** file editor.
3. Select **Save** (disk icon).

``` json
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
          "title": "Label",
          "type": "string",
          "description": "Enter a unique, case-sensitive alphanumeric label to identify the location. This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific location.",
          "examples": [
            "Users Endpoint"
          ]
        },
       "locationMatchExpression": {
         "title": "Match Expression",
         "type": "string",
         "description": "The prefix to match request   paths by.",
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


## Create the augment template

1. On the **Templates > Overview** page, select **Create**.
2. Select **New**.
3. Give the template a name. For this tutorial, we'll call the augment template *rr_aug_loc_proxy*.
4. Optionally, provide a description for the template. For example, *Location Proxy Augment*.
5. Select **Draft** for the template status.
6. Select **Augment** for the for type.
7. Select **Submit**.

### Add the augment template files

1. On the **Template > Overview** page, select **Location Proxy Template**.
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

1. Select **location.tmpl**.
2. Copy and paste the following contents into the **location.tmpl** file editor.
3. Select **Save** (disk icon).

``` go
{{ $augmentData := .AugmentData.V1 }}
{{ $server := index .Args 1 }}
{{ $location := index .Args 0 }}
{{ $arguments := dict }}

{{/* Get the label for the location in the base template */}}
{{ $locationLabel := $location.templateInput.nameExpression | trim | lower }}

{{/* Check to see if we have nameExpression (label) for this location ID */}}
{{ range $args := $augmentData.location.templateInput.locations }}
  {{ $targetLabel := $args.targetLabel | trim | lower }}
  {{ if (eq $targetLabel $locationLabel) }}
    {{ $arguments = $args }}
    {{ break }}
  {{ end }}
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

``` json
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
          "description": "To configure each location, the 'Label' you enter below must correspond exactly to a 'Label' in the base template. This ensures the system can properly inject a reverse proxy directive targeting the specified upstream.",
          "items": {
            "type": "object",
            "properties": {
              "targetLabel": {
                "title": "Target Location Label",
                "type": "string",
                "description": "Enter the label for this configuration's target location. It must exactly match the 'Label' from a base template location to ensure the system correctly injects the augment inputs into the configuration.",
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

## Generate the template submission

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
   - Enter a case-sensitive, alphanumeric label for the server (for example, **main_server**). This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific server.
   - Enter a server name (for example, **example.com**).
   - Add a server location:
     - In the **Server Locations** pane, select **Add Server Location**.
     - Enter a unique, case-sensitive alphanumeric label to identify the location (for example, **users_proxy**). This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific location. We'll refer to this label when we configure the augment template inputs.
     - Enter a match expression. This is the prefix to match request paths by (for example, **/users**).
   - Select **Next**.
6. **Add HTTP Upstream(s)**:
   - On the **HTTP Upstreams** form, select **Add HTTP Upstreams**.
   - Enter a unique, case-sensitive alphanumeric label to identify the upstream (for example, **users_upstream**). This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific upstream.
   - Enter an HTTP upstream name (for example, **upstream_1**). We'll refer to this upstream name when we configure the augment template inputs.
   - Add an upstream server:
     - In the **Upstream Servers** pane, select **Add item**.
     - Enter the upstream server address (for example, **users1.example.com**)
     - Enter the upstream server port (for example, **80**).
   - Select **Next**.
7. **Add the rr_aug_loc_proxy inputs**.
   - In the **Reverse Proxy Augment > Locations** pane, select **Add item**.
   - Enter the label for the target location. This is the label that you specified in step 5 when adding the HTTP server location (for example, **users_proxy**). Make sure the labels exactly match.
   - Enter the upstream name. This is the name you specified in step 6 (for example, **upstream_1**). Make sure the names exactly match.
   - Select **Next**.
8. **Preview the config**:
 
    On the **Preview Config** page, the resulting config should similar to the following example:

    ```nginx
    config isn't generating
    ```

9. If the configuration looks correct, select **Publish** to deploy it.
