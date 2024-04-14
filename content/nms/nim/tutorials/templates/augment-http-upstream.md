---
title: "Set upstreams with an augment template"
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


## Overview

A base template makes all of the specified NGINX directive blocks accessible to users when modifying template submissions. This might be okay if you want people to make changes without being restricted. However, if you want only designated individuals or teams to edit specific HTTP servers or locations, perhaps as part of a self-service workflow, you can use augment templates to portion out (segment) parts of the NGINX config and role-based access control (RBAC) to assign permissions.

An administrator has defined the upstream location in the base template. However, now we want to break the upstream location out of the base template so a specific team, like SRI, can edit these settings themselves. By breaking the location out of the base template, we're able add additional control over how can access it. In short, a base template makes all of the NGINX directive blocks accessible if there's no need for access control. However, if you want to restrict certain server or location blocs, you can create augments for those blocks and limit access with RBAC.

Limitation: can't augment an augment. If you have an augment and want to update it, you have to update the augment directly. You can't create an augment to update an augment.

## Step 1: Clone the F5 Global Base template

To begin, make a clone of the F5 Global base template to work with.

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. From the Launchpad menu, choose **Instance Manager**.
3. In the left navigation pane, select **Templates > Overview**.
4. Select the **F5 Global Default Base** template.
5. Select **Save As** and enter a name for the cloned template. In this example, we'll call the cloned template *Upstream Augment Template*.

## Step 2: Make the cloned template editable

Because the F5 Global Default Base template's state is **Ready for Use**, any clones made of that template will have the same state. We want to make modifications to our cloned template, **Upstream Augment Template**, so we need to make that template editable.

To edit the metadata details for a template:

1. On the **Templates > Overview** page, locate **Upstream Augment Template**. In the **Actions** column, select the ellipsis (three dots), then choose **Edit**.
2. In the **Description** box, enter a new description for the template. For example, "Round-robin base template."
3. Select **Draft** for the state.
4. Select **Submit**.

## Step 3: Pare down the base template

The Upstream Augment Template at this point includes more details than we require. For the purposes of this tutorial, we only want to create the HTTP upstreams, HTTP upstream servers with their ports, and leave the ExecTemplateAugments to injecting an augment template. This means we can remove extraneous settings like the advanced metrics module and stream block. 

1. On the **Templates > Overview** page, select **Upstream Augment Template**. This displays the templates files and their contents.
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

1. On the **Templates > Overview** page, select **Upstream Augment Template**.
2. Select each of the following JSON schemas one-at-a-time, click **Delete** (trash can), and confirm the deletion:

   - **stream-server.json**
   - **stream-upstream.json**
   - **main.json**

After you've deleted the unneeded JSON schemas, the **Upstream Augment Template** should include just these files:

- base.tmpl
- http-server.json
- http-upstream.json
- location.json

## Step : Create the augment template

1. On the **Templates > Overview** page, select **Upstream Augment Template**.


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


## Import template

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. From the Launchpad menu, choose **Instance Manager**.
3. In the left navigation pane, select **Templates > Overview**.

---

## Additional resources

{{< include "/nim/templates/additional-resources-links.md" >}}