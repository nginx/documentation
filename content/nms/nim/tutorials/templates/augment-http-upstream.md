---
title: "Set round-robin upstreams with an augment template"
date: 2024-03-12T16:01:58-07:00
# Change draft status to false to publish doc
draft: true
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
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
3. On the left navigation pane, select **Templates**.
4. Select **Create**.
5. Select **New**.
6. Give the template a name. For this tutorial, we'll call the base template *Round Robin Base Template*.
7. Optionally, provide a description for the template.
8. Select **Draft** for the template status.
9. Select **Base** for the for type.
10. Select **Submit**.



### Add the base template files

1. On the **Template > Overview** page, select **Round Robin Base Template**.
2. Add the config template file:
   - Select **Add File**.
   - Select **Config File > based.tmpl**.
   - Select **Add**.
3. Add the schema files:
   - Select **Add File**.
   - Select **Schema File > http-server.json, http-upstream, location.json**.
   - Select **Add**.

Your base template should now include the following files:

{{<img src="/nim/templates/round-robin-base-template-files.png" alt="List of template files including base.tmpl, http-server.json, http-upstream.json, and location.json" width="300" height="auto">}}

### Add the base.tmpl file details

1. In the template file list, select **base.tmpl**.
2. Copy and paste the following contents into the **base.tmpl** file editor.

   ``` go
   {{/*
       This is the simple base template that is composed after Main, Http and Stream
       blocks are rendered. Injectables for L1 augments are included.
   */}}
   {{ $input := .}}
   {{ $baseData := .Data.V1}}

   {{/* L1 execute main.tmpl for all enabled use cases */}}
   {{ $input.ExecTemplateAugments "main" }}
   events {
       worker_connections  1024;
   }

   http {
       {{/* L1 execute http.tmpl for all enabled use cases */}}
       {{ $input.ExecTemplateAugments "http" }}
       {{ range $upstreamIndex, $upstream := $baseData.http.upstreams }}
             upstream {{$upstream.templateInput.name}} {
                 {{$upstreamTemplateInput := $upstream.templateInput}}
                 {{range $serverIndex, $upstreamServer := $upstreamTemplateInput.servers}}
                     {{$port := ""}}
                     {{if $upstreamServer.port}}
                         {{$port = (printf ":%0.f" $upstreamServer.port)}}
                     {{end}}
                     server {{$upstreamServer.address}}{{$port}};
                 {{end}}

                 {{/* L1 execute http-upstream.tmpl for all enabled use cases for the $upstream */}}
                 {{ $input.ExecTemplateAugments "http-upstream" $upstream }}
             }
       {{end}}

       {{ range $serverIndex, $server := $baseData.http.servers}}
           server {
               server_name {{$server.templateInput.serverName}};
               {{ range $locationIndex, $location := $server.locations}}
                   location {{$location.templateInput.nameExpression}} {
                     {{/* L1 execute location.tmpl for all enabled use cases for the $location */}}
                     {{$input.ExecTemplateAugments "location" $server $location}}
                   }
               {{end}}

               {{/* L1 executes http-server.tmpl for all enabled use cases for the $server */}}
               {{ $input.ExecTemplateAugments "http-server" $server }}
           }
       {{end}}
   }
   ```

3. Select **Save** (disk icon).

<details>
<summary><i class="fas fa-code-compare"></i> Compare the Round Robin Base template with the F5 Global Default Base template.</summary>

This screenshot shows the differences between the [F5 Global Default Base template]({{< relref "nms/nim/about/templates/default-base-template.md" >}}) and the Round Robin Base template. You can see which sections were kept and which were removed in the Round Robin Base template.

{{<img src="/nim/templates/round-robin-base-template-diff.png" alt="Screenshot showing the configuration differences between the F5 Global Default Base template and the Round Robin Base template for an NGINX setup. This image highlights the removed sections in the Round Robin Base template by showing a side-by-side comparison with the Global Default Base template." width="auto" height="auto">}}
</details>

### Add the http-server.json file details

1. Select **http-server.json**.
2. Copy and paste the following contents into the **http-server.json** file editor.

    ``` json
    {
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "title": "HTTP Server Inputs",
      "type": "object",
      "properties": {
        "templateInput": {
          "type": [
            "object",
            "null"
          ],
          "properties": {
            "serverName": {
              "title": "Server name",
              "type": "string",
              "description": "Specifies the name for the http server.",
              "examples": [
                "foo.com"
              ]
            },
            "id": {
              "title": "Server ID",
              "type": "string",
              "description": "Case sensitive alphanumeric id used for specifying augment placement.",
              "examples": [
                "main_server"
              ]
            }
          },
          "required": [
            "serverName",
            "id"
          ]
        }
      },
      "required": []
    }
    ```

3. Select **Save** (disk icon).


### Add the http-upstream.json file details

1. Select **http-upstream.json**.
2. Copy and paste the following contents into the **http-upstream.json** file editor.

    ``` json
    {
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "title": "HTTP Upstream Inputs",
      "type": "object",
      "properties": {
        "templateInput": {
          "type": [
            "object",
            "null"
          ],
          "properties": {
            "name": {
              "title": "HTTP Upstream name",
              "type": "string",
              "description": "Specifies the name for the http upstream.",
              "examples": [
                "upstream-1"
              ]
            },
            "id": {
              "title": "Upstream ID",
              "type": "string",
              "description": "Case sensitive alphanumeric id used for specifying augment placement.",
              "examples": [
                "main_upstream"
              ]
            },
            "servers": {
              "type": "array",
              "title": "Upstream servers",
              "items": {
                "type": "object",
                "properties": {
                  "address": {
                    "title": "Upstream server address",
                    "type": "string",
                    "description": "Specifies the address for the upstream server.",
                    "examples": [
                      "backend1.example.com",
                      "192.0.0.1"
                    ]
                  },
                  "port": {
                    "type": "integer",
                    "title": "Upstream server port",
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
            "id"
          ]
        }
      },
      "required": []
    }
    ```

3. Select **Save** (disk icon).

### Add the location.json file details

1. Select **location.json**.
2. Copy and paste the following contents into the **location.json** file editor.

     ``` json
    {
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "title": "Location Inputs",
      "type": "object",
      "properties": {
        "templateInput": {
          "type": [
            "object",
            "null"
          ],
          "properties": {
            "nameExpression": {
              "title": "Location Name",
              "type": "string",
              "description": "Specifies the location's name expression.",
              "examples": [
                "/status"
              ]
            },
            "id": {
              "title": "Location ID",
              "type": "string",
              "description": "Case sensitive alphanumeric id used for specifying augment placement.",
              "examples": [
                "main_location"
              ]
            }
          },
          "required": [
            "nameExpression",
            "id"
          ]
        }
      },
      "required": []
    }
    ```

3. Select **Save** (disk icon).

## Create the augment template

1. On the **Templates > Overview** page, select **Create**.
2. Select **New**.
3. Give the template a name. For this tutorial, we'll call the augment template *Location Proxy Augment*.
4. Optionally, provide a description for the template.
5. Select **Draft** for the template status.
6. Select **Augment** for the for type.
7. Select **Submit**.

### Add the augment template files

1. On the **Template > Overview** page, select **Location Proxy Template**.
2. Add the config template file:
   - Select **Add File**.
   - Select **Config File > **location.tmpl**
   - Select **Add**.
3. Add the schema files:
   - Select **Add File**.
   - Select **Schema File > location.json, meta.json**.
   - Select **Add**.

Your augment template should now include the following files:

{{<img src="/nim/templates/round-robin-augment-template-files.png" alt="List of template files including base.tmpl, http-server.json, http-upstream.json, and location.json" width="300" height="auto">}}

### Add the location.tmpl details

1. Select **location.tmpl**.
2. Copy and paste the following contents into the **location.tmpl** file editor.

    ``` go
    {{$augmentData := .AugmentData.V1}}
    {{$server := index .Args 0}}
    {{$location := index .Args 1}}
    {{$locationId := "" }}

    {{if and $location $location.templateInput}}
      {{$locationId = $location.templateInput.id}}
    {{end}}

    {{/* Check to see if we have upstreamName for this location ID */}}
    {{range $args := $augmentData.location.templateInput.locations}}
      {{if (eq $args.targetId $locationId)}}
        proxy_pass http://{{$args.upstreamName}};
        {{break}}
      {{end}}
    {{end}}
    ```

3. Select **Save** (disk icon).

### Add the location.json details

1. Select **location.json**.
2. Copy and paste the following contents into the **location.json** file editor.

    ``` json
    {
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "title": "Location Inputs",
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
              "title": "Location List",
              "items": {
                "type": "object",
                "properties": {
                  "targetId": {
                    "title": "Location ID",
                    "type": "string",
                    "description": "Case sensitive alphanumeric id used for specifying augment placement.",
                    "examples": [
                      "main_location"
                    ]
                  },
                  "upstreamName": {
                    "type": "string",
                    "title": "Upstream Name",
                    "description": "Name of the target upstream. Must match exactly.",
                    "examples": [
                      "upstream-1"
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

3. Select **Save** (disk icon).

## Generate the template submission

1. On the left navigation pane, select **Templates**.
2. Find **Round Robin Base Template** in the list of templates. In the **Actions** column, select the ellipsis (three dots), then select **Preview and Generate**.
3. Select the publication target:
   - Select whether you're publishing the configuration to an instance, instance group, existing saved config, or saving as a new staged config.
   - Then select the specific target instance, instance group, staged config. Or, if you're saving as a new staged config, provide the staged config name.
   - Select **Next**.
4. Include the *Location Proxy Template*:
   - On the **Choose Augments** form, select **Location Proxy Template**.
   - Select **Next**.
5. Add HTTP Server(s):
   - On the **HTTP Servers** form, select **Add HTTP Servers**.
   - Provide a server name.
   - Provide a server ID.
   - Select **Next**.
6. Add Location Proxy Template location inputs:
   - On the **Location Proxy Template** form, specify the following:
   - Provide a location ID.
   - Provide an upstream name.
   - Select **Next**.
7. 
---

Now, we'll add the following files to the augment template: **location.tmpl**, **location.json**, and **meta.json**. The contents for these files are provided below for you to copy and paste.

1. On the **Templates > Overview** page, locate the newly created *HTTP Upstream Augment Template* template. In the **Actions** column, select the ellipsis (three dots), then choose **Edit Template Files**.
2. In the config editor, select **Add file**.
3. Choose the type of file you want to add to the template. Depending on the file type, you'll be presented with a list of file options to choose from.
4. Select the file names you want to add to your template.
5. After selecting all the necessary files, click **Add** to include them in the template.
6. The selected files will now appear in the template's directory structure on the left side of the editor. Select a file to edit its contents in the editing pane.
7. Make your changes and select **Save** to update the template with your configurations.

**location.tmpl**

``` go
{{$augmentData := .AugmentData.V1}}
{{$server := index .Args 0}}
{{$location := index .Args 1}}
{{$locationId := "" }}

{{if and $location $location.templateInput}}
  {{$locationId = $location.templateInput.id}}
{{end}}

{{/* Check to see if we have upstreamName for this location id */}}
{{range $args := $augmentData.location.templateInput.locations}}
  {{if (eq $args.targetId $locationId)}}
    proxy_pass http://{{$args.upstreamName}};
    {{break}}
  {{end}}
{{end}}
```

<br>

**location.json**

``` json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "Location Inputs",
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
          "title": "Location List",
          "items": {
            "type": "object",
            "properties": {
              "targetId": {
                "title": "Location Id",
                "type": "string",
                "description": "Case sensitive alphanumeric id used for specifying augment placement.",
                "examples": [
                  "main_location"
                ]
              },
              "upstreamName": {
                "type": "string",
                "title": "Upstream Name",
                "description": "Name of the target upstream. Must match exactly.",
                "examples": [
                  "upstream-1"
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

<br>

**meta.json**

``` json
{
  "meta_version_num": 1,
  "name": "rr_aug_loc_proxy",
  "description": "Tutorial augment template for location example",    
  "type": "augment",
  "uid": "6b48bb57-b2ca-40c7-a296-b1c11e3cf3d9"
}
```

## Step : Generate the NGINX config

To preview, generate, and submit a config from a template:

1. On the **Templates > Overview** page, locate the  created *HTTP Upstream Augment Template* template. select the ellipsis (three dots) in the **Actions** column, then select **Preview and Generate**.
2. Complete the forms on the **Preview and Generate Config** dialog in sequence, selecting **Next** to move forward:
    - **Choose Publish Options**: Specify where to publish the template by selecting either:
      - **Publish to an Instance**: To apply the configuration to a single NGINX instance.
      - **Publish to an Instance Group**: To apply the configuration to multiple instances managed as an instance group.
      - **Save to a Staged Config**: To stage the configuration for future deployment.
      - **Save as a New Staged Config**: To create a brand new staged configuration for later use.
    - **Augments** (Optional): Include any augment templates needed to enhance a base configuration with additional features.
    - **Base and Augment Inputs**: Enter the required configuration inputs for the chosen templates.
    - **Preview Config**: Use the filename dropdown to review the output for each configuration.
3. After verifying the configurations, select **Publish**. If you've published to an instance or instance group, the template submission will tracked on the **Template Submissions** page.
4. Once the submission is accepted and confirmed, select **Close and Exit**.


## Import template

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. From the Launchpad menu, choose **Instance Manager**.
3. On the left navigation pane, select **Templates > Overview**.

---

## Additional Templating Resources

{{< include "nim/templates/additional-templating-resources.md" >}}
