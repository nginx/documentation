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
    border: 1px solid #ccc;
    background-color: #f1f1f1;
    padding: 10px 20px 10px 20px;
  }
</style>


## Overview

This tutorial will guide you through using NGINX Instance Manager's templating features so you can manage and apply configurations across multiple NGINX instances.

By the end of this tutorial, you will learn how to:

1. Create the {rr_base_template} base template as a starting point for configuring NGINX instances.
2. Create the {rr_aug_loc_proxy} augment template to customize location blocks within your NGINX configuration, directing traffic to specified upstream servers and refining request handling.
3. Understand the interplay between base and augment templates, and how they collectively form a dynamic and flexible configuration system.
4. Apply template-driven configurations to real-world scenarios, streamlining your workflows and ensuring consistency across your environment.

This tutorial assumes a basic understanding of NGINX configuration directives and principles. With the provided step-by-step instructions, sample configurations, and explanatory notes, you'll learn how to use templating for more effective NGINX management.

**Example Use Case**

Use an augment template to specify the upstream server locations for round-robin load balancing.

---

Feel free to adjust the wording to better fit the style and tone of your existing documentation. Once the overview is aligned with your vision, we can proceed to the next sections, or I can assist with any revisions needed here.

A base template makes all of the specified NGINX directive blocks accessible to users when modifying template submissions. This might be okay if you want people to make changes without being restricted. However, if you want only designated individuals or teams to edit specific HTTP servers or locations, perhaps as part of a self-service workflow, you can use augment templates to portion out (segment) parts of the NGINX config and role-based access control (RBAC) to assign permissions.

An administrator has defined the upstream location in the base template. However, now we want to break the upstream location out of the base template so a specific team, like SRE, can edit these settings themselves. By breaking the location out of the base template, we're able add additional control over how can access it. In short, a base template makes all of the NGINX directive blocks accessible if there's no need for access control. However, if you want to restrict certain server or location blocs, you can create augments for those blocks and limit access with RBAC.


## Step 1: Clone the F5 Global Base template

To begin, make a clone of the F5 Global base template to work with.

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. From the Launchpad menu, choose **Instance Manager**.
3. In the left navigation pane, select **Templates > Overview**.
4. Select the **F5 Global Default Base** template.
5. Select **Save As** and enter a name for the cloned template. In this example, we'll call the cloned template **HTTP Upstream Base Template**.

## Step 2: Make the cloned template editable

Because the F5 Global Default Base template's state is **Ready for Use**, any clones made of that template will have the same state. We want to make modifications to our cloned template, **HTTP Upstream Base Template**, so we need to make that template editable.

To edit the metadata details for a template:

1. On the **Templates > Overview** page, locate **HTTP Upstream Base Template**. In the **Actions** column, select the ellipsis (three dots), then choose **Edit**.
2. In the **Description** box, enter a new description for the template. For example, "Round-robin base template."
3. Select **Draft** for the state.
4. Select **Submit**.

## Step 3: Pare down the base template

The HTTP Upstream Base Template at this point includes more details than we require. For the purposes of this tutorial, we only want to create the HTTP upstreams, HTTP upstream servers with their ports, and leave the ExecTemplateAugments to injecting an augment template. This means we can remove extraneous settings like the advanced metrics module and stream block. 

1. On the **Templates > Overview** page, select **HTTP Upstream Base Template**. This displays the templates files and their contents.
2. Select **base.tmpl**.
3. Copy and paste the following contents into the base.tmpl file, then select **Save** (disk icon).

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

   <br>

   <details open>
   <summary>The differences between Round-Robin Base Template and F5 Global Default Base Template</summary>

   The following image shows what's been removed from the F5 Global Default Base Template to create the pared-down Round-Robin Base Template.

   {{<img src="/nim/templates/round-robin-base-template-diff.png" alt="API Connectivity Manager architecture" >}}
   </details>

Remaining template lets you:

- Create the upstreams.
- Create the upstream servers with their port
- And leave the ExecTemplateAugments, which is the injectable for augment templates.


## Step 4: Remove unneeded template and JSON file

Since the base template has been paired down, we can remove the unrelated JSON schemas that carried over from cloning the F5 Global Default Base template.

To delete the unneeded JSON schemas:

1. On the **Templates > Overview** page, select **HTTP Upstream Base Template**.
2. Select each of the following JSON schemas one-at-a-time, click **Delete** (trash can), and confirm the deletion:

   - **stream-server.json**
   - **stream-upstream.json**
   - **main.json**

After you've deleted the unneeded JSON schemas, the **HTTP Upstream Base Template** should include just these files:

- base.tmpl
- http-server.json
- http-upstream.json
- location.json

## Step : Add upstream, server, and location IDs to JSON schemas

Do this to give the base template "hooks" to inject the augments


**http-upstream.json**

``` json {linenos=table,hl_lines=["20-27"]}
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

**http-server.json**

``` json {linenos=table,hl_lines=["20-28"]}
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

**location.json**

``` json {linenos=table,hl_lines=["20-28"]}
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

## Step : Create the augment template

1. On the Config Templates "Overview" page, select **Create**.
2. In the **Create Template** dialog:
    - Select **New** to start a fresh template.
    - Enter a unique and descriptive name for your template in the **Name** field. In this example, we'll call the template **HTTP Upstream Augment Template**.
    - (Optional) Provide a description in the **Description** field to give more context about the template's purpose or usage.
    - Select **Draft** for the template state. This indicates that the template is still under development, editable, and not finalized for use.
    - Select **Augment** for the template type. Specify the 
3. Click **Submit** to create the template.

## Step : Add the augment template files

Now, we'll add the following files to the augment template: **location.tmpl**, **location.json**, and **meta.json**. The contents for these files are provided below for you to copy and paste.

1. On the **Templates > Overview** page, locate the newly created *HTTP Upstream Augment Template* template. In the **Actions** column, select the ellipsis (three dots), then choose **Edit Template Files**.
2. In the config editor, select **Add file**.
3. Choose the type of file you want to add to the template. Depending on the file type, you'll be presented with a list of file options to choose from.
4. Select the file names you want to add to your template.
5. After selecting all the necessary files, click **Add** to include them in the template.
6. The selected files will now appear in the template's directory structure on the left side of the editor. Select a file to edit its contents in the editing pane.
8. Make your changes and select **Save** to update the template with your configurations.

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
3. In the left navigation pane, select **Templates > Overview**.

---

## Additional Templating Resources

{{< include "nim/templates/additional-templating-resources.md" >}}
