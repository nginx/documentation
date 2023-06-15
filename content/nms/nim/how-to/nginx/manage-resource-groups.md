---
title: "Working with Resource Groups"
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to use NGINX Management Suite Instance Manager to create Resource Groups, which you can use to manage multiple resources (Systems, Instance Groups, etc.) as a single permission object."
# Assign weights in increments of 100
weight: 610
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1200"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["infrastructure", "Resource Groups", "rbac"]
doctypes: ["tutorial"]
journeys: ["using"]
personas: ["devops", "netops", "secops"]
versions: []
authors: []
aliases:
- /nim/how-to/manage-resource-groups/
---

{{< custom-styles >}}
{{< shortversions "2.12.0" "latest" "nimvers" >}}

## Overview

Resource Groups allow you to manage RBAC permissions for multiple resources in Instance Manager as a single entity. While Instance Groups are similar to a cluster, as all instances must share the same config, the same is not true with Resource Groups. Resource Groups are exclusively an RBAC tool to allow managing a large number of resources as a single item.

---

## Before You Begin

To complete the instructions in this guide, you need the following:

- An installed version of [Instance Manager]({{< relref "/nms/installation/vm-bare-metal/_index.md" >}})
- One or more NGINX data plane instances
- Knowledge of the Resource Group API

{{<see-also>}}

{{< include "nim/how-to-access-api-docs.md" >}}

{{</see-also>}}

---

## Default Systems Set

All systems get added to a default Resource Group when registered. You can use this to set base-level permissions for all new systems that get added to Instance Manager before you add the system to a more specific set.

---

## Create Resource Groups {#add-resource-groups}

{{< see-also >}}{{< include "nim/how-to-access-nim-api.md" >}}{{< /see-also>}}

To create a Resource Group using the REST API, send an HTTP `POST` request to the Resource Groups endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `POST` | `/platform/v1/resource-groups` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

<details open>
<summary>JSON request</summary>

```json
{
  "resources": [
    {
      "module": "Instance Manager",
      "name": "my system",
      "object": "Systems",
      "uid": "9bad47e6-5ed4-4522-96c0-6f507c2e7198"    
    }
  ],
  "description": "set description",
  "name": "set-1"
}
```

---

## Add Resources to Resource Groups

You can assign resources (e.g. Systems) to Resource Groups in the following ways:

- (Preferred) Directly add the System to the Resource Group with the Direct Add API.
- Alternatively, you can use the Update Resource Group API `PUT /api/platform/v1/resource-groups/{resourceGroupUid}`, but this method requires passing all systems that belong in the set with the call.

<br>

{{<tabs name="add-resources-to-resource-group">}}

{{%tab name="Direct Add API"%}}

### Use the Direct Add API

The direct add method does not require you to build the entire list of all resources you want in a Resource Group every time you want to add a new system.

To add an instance to a Resource Group with the Direct Add API, send an HTTP `POST` request to the Resource Groups endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `POST` | `/api/platform/v1/resource-groups/{resourceGroupUid}/resources` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

<details open>
<summary>JSON request</summary>

```json
{
    "module": "Instance Manager",
    "name": "my system",
    "object": "Systems",
    "uid": "1ac1e001-f8af-463a-b6fd-3bfb2fc94542"
}
```

{{%/tab%}}

{{%tab name="Update the Resource Group"%}}

### Updating the Entire Resource Group

To add one ore more resources to a Resource Group by updating the Resource Group:

1. Get the JSON for the existing Resource Group:

   `GET /api/platform/v1/resource-groups/{resourceGroupUid}`

2. Manually add the new resource(s) to the `resources` list in the JSON.
3. Update the Resource Group with the updated JSON: 

   `PUT /api/platform/v1/resource-groups/{resourceGroupUid}`

{{%/tab%}}
{{</tabs>}}

---

## Remove Resources from Resource Groups

To remove a resource from a Resource Group using the REST API, send an HTTP `DELETE` request to the Resource Groups endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `DELETE` | `/platform/v1/resource-groups/{resourceGroupUid}/resources/{resourceUid}?moduleName=Instance Manager` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

---

## Delete Resource Groups

To delete a Resource Group using the REST API, send an HTTP `DELETE` request to the Resource Groups endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `DELETE` | `/platform/v1/resource-groups/{resourceGroupUid}` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

---

## View List of Resource Groups

To view the list of Resource Groups (omitting resources detail) using the REST API, send an HTTP `GET` request to the Resource Groups endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `GET` | `/platform/v1/resource-groups?showDetails=false` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

To view the list of Resource Groups (including resources detail) using the REST API, send an HTTP `GET` request to the Resource Groups endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `GET` | `/platform/v1/resource-groups?showDetails=true` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

---

## View Resources in a Resource Group

To view the instances in a Resource Group using the REST API, send an HTTP `GET` request to the Resource Groups endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `GET` | `/platform/v1/resource-groups/{resourceGroupUid}` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}