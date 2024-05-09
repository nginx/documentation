---
title: "Set location proxy with an augment template"
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

{{< include "nim/templates/tutorial/reverse-proxy/base-template/base.md" >}}


### Add the http-server.json file details

1. Select **http-server.json**.
2. Copy and paste the following JSON schema into the **http-server.json** file editor.
3. Select **Save** (disk icon).

{{< include "nim/templates/tutorial/reverse-proxy/base-template/http-server.md" >}}



### Add the http-upstream.json file details

1. Select **http-upstream.json**.
2. Copy and paste the following JSON schema into the **http-upstream.json** file editor.
3. Select **Save** (disk icon).

{{< include "nim/templates/tutorial/reverse-proxy/base-template/http-upstream.md" >}}


### Add the location.json file details

1. Select **location.json**.
2. Copy and paste the following JSON schema into the **location.json** file editor.
3. Select **Save** (disk icon).

{{< include "nim/templates/tutorial/reverse-proxy/base-template/location.md" >}}


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

{{< include "nim/templates/tutorial/reverse-proxy/augment-template/location-template.md" >}}


### Add the location.json details

1. Select **location.json**.
2. Copy and paste the following contents into the **location.json** file editor.
3. Select **Save** (disk icon).

{{< include "nim/templates/tutorial/reverse-proxy/augment-template/location-json.md" >}}

## Generate the template submission

1. On the left navigation pane, select **Templates**.
2. Find **Round Robin Base Template** in the list of templates. In the **Actions** column, select the ellipsis (three dots), then select **Preview and Generate**.
3. **Select the publication target**:
   - Select whether you're publishing the configuration to an instance, instance group, existing saved config, or saving as a new staged config.
   - Then select the specific target from the list. Or, if you're saving as a new staged config, provide the staged config name.
   - Select **Next**.
4. **Select the augment template**:
   - On the **Choose Augments** form, select **Location Proxy Template**.
   - Select **Next**.
5. **Add HTTP Server(s)**:
   - On the **HTTP Servers** form, select **Add HTTP Servers**.
   - Enter a server name (for example, **foo.com**).
   - Enter a server ID (for example, **main_server**).
   - Add a server location:
     - In the **Server Locations** pane, select **Add Server Location**.
     - Enter a location name (for example, **/users**).
     - Enter a location ID (for example, **users_proxy**).
     - Select **Done**.
   - Select **Next**.
6. **Add HTTP Upstream(s)**:
   - On the **HTTP Upstreams** form, select **Add HTTP Upstreams**.
   - Enter an HTTP upstream name (for example, **upstream_1**).
   - Enter the upstream ID (for example, **users_upstream**).
   - Add an upstream server:
     - In the **Upstream Servers** pane, select **Add item**.
     - Enter the upstream server address (for example, **backend1.example.com**)
     - Enter the upstream server port (for example, **80**).
     - Select **Done**.
   - Select **Next**.
7. **Add Location Proxy Augment inputs**.
   - In the **Location Inputs > Location List** pane, select **Add item**.
   - Enter the location ID. 
     
     {{<note>}}**The location ID must match the HTTP Server location ID** specified in the base template (for example, use **users_proxy** as specified in step 5).{{</note>}}
   - Enter the upstream name.
     {{<note>}}**The upstream name must match the HTTP Upstream name** specified in the base template (for example, use **upstream_1** as specified in step 6).{{</note>}}
   - Select **Next**.
8. **Preview the config**:
 
    On the **Preview Config** page, the resulting config should similar to the following example:

    ```nginx
    # /******************************** !! IMPORTANT !! ********************************/
    #   This is a Template generated configuration. Updates should done through the Template
    #   Submissions workflow. Manual changes to this configuration can/will be overwritten.
    # __templateTag={"uid":"9f309d78-cb15-4371-9811-a334ba8adc98","file":"base.tmpl","name":"Round Robin Augment Template"}
    events {
    	worker_connections 1024;
    }
    http {
    	upstream upstream_1 {
    		server backend1.example.com:80;
    	}
    	server {
    		server_name foo.com;
    		location /users {
    			
    # <<< BEGIN DO-NOT-EDIT location augment templates >>>

    			# __templateTag={"uid":"0555cd49-2a15-46b3-b93b-3c287d23d872","file":"location.tmpl","name":"Location Proxy Augment"}
    			include /etc/nginx/augments/location/base_http-server1_loc1_9f309d78_0555cd49-2a15-46b3-b93b-3c287d23d872.conf;
    			
    # <<< END DO-NOT-EDIT location augment templates >>>

    		}
    	}
    }
    ```

9. If the configuration looks correct, select **Publish** to deploy it.
