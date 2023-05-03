---
title: "Working with Instance Sets"
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to use NGINX Management Suite Instance Manager to create Instance Sets, which you can use to group multiple NGINX instances as permission object."
# Assign weights in increments of 100
weight: 610
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1200"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["infrastructure", "Instance Sets", "rbac"]
doctypes: ["tutorial"]
journeys: ["using"]
personas: ["devops", "netops", "secops"]
versions: []
authors: []
aliases:
- /nim/how-to/manage-instance-sets/
---

{{< custom-styles >}}
{{< shortversions "2.10.0" "latest" "nimvers" >}}

## Overview

You can easily manage RBAC permissions for multiple NGINX instances as a single entity by creating an Instance Set in Instance Manager and adding NGINX instances. While Instance Groups are similar to a cluster, as all instances must share the same config, the same is not true with Instance Sets. Instance sets are exclusively an RBAC tool to allow managing a large number of instances as a single item.

---

## Before You Begin

To complete the instructions in this guide, you need the following:

- An installed version of [Instance Manager]({{< relref "/nms/admin-guides/installation/on-prem/install-guide.md" >}})
- One or more NGINX data plane instances
- Knowledge of the Instance Set API

{{<see-also>}}

{{< include "nim/how-to-access-api-docs.md" >}}

{{</see-also>}}

---

## Default Set

All instances get added to a default Instance Set when registered. You can use this to set base-level permissions for all new instances that get added to Instance Manager before you add the instance to a more specific set.

---

## Create Instance Sets {#add-instance-sets}

{{< see-also >}}{{< include "nim/how-to-access-nim-api.md" >}}{{< /see-also>}}

To create an Instance Set using the REST API, send an HTTP `POST` request to the Instance Sets endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `POST` | `/platform/v1/instance-sets` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

<details open>
<summary>JSON request</summary>

```json
{
  "instances": [
    {
      "uid": "9bad47e6-5ed4-4522-96c0-6f507c2e7198",
      "value": "my instance"
    }
  ],
  "name": "set-1"
}
```

---

## Add Instances to Instance Sets

You can assign NGINX instances to instance sets in the following ways:

- (Preferred) Directly add the Instance to the Instance Set with the Direct Add API.
- Alternatively, you can use the Update Instance Set API `PUT /api/platform/v1/instance-sets/{instSetUid}`, but this method requires passing all instances that belong in the set with the call.

<br>

{{<tabs name="add-instance-to-set">}}

{{%tab name="Direct Add API"%}}

### Use the Direct Add API

The direct add method does not require you to build the entire list of all instances you want in an Instance Set every time you want to add a new instance.

To add an instance to an Instance Set with the Direct Add API, send an HTTP `POST` request to the Instance Sets endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `POST` | `/platform/v1/instance-sets/{instSetUid}/instances/` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

<details open>
<summary>JSON request</summary>

```json
{
  "uid": "9bad47e6-5ed4-4522-96c0-6f507c2e7198",
  "value": "my instance"
}
```

{{%/tab%}}

{{%tab name="Update the Instance Set"%}}

### Updating the Entire Instance Set

To add an instance to an Instance Set by updating the Instance Set:

1. Get the JSON for the existing Instance Set:

   `GET /api/platform/v1/instance-sets/{instSetUid}`

2. Manually add the new instance to the `instances` list in the JSON.
3. Update the Instance Set with the updated JSON: 

   `PUT /api/platform/v1/instance-sets/{instSetUid}`

{{%/tab%}}
{{</tabs>}}

---

## Remove Instances from Instance Sets

To remove an instance from an Instance Set using the REST API, send an HTTP `DELETE` request to the Instance Sets endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `DELETE` | `/platform/v1/instance-sets/{instSetUid}/instances/{instUid}` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

---

## Delete Instance Sets

To delete an Instance Set using the REST API, send an HTTP `DELETE` request to the Instance Sets endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `DELETE` | `/platform/v1/instance-sets/{instSetUid}` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

---

## View List of Instance Sets

To view the list of Instance Sets using the REST API, send an HTTP `GET` request to the Instance Sets endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `GET` | `/platform/v1/instance-sets/` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}


---

## View Instances in an Instance Set

To view the instances in an Instance Set using the REST API, send an HTTP `GET` request to the Instance Sets endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `GET` | `/platform/v1/instance-sets/{instSetUid}/instances/` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}