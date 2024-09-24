---
description: This topic explains what SCIM support is available for automating the
  management of user identity lifecycles.
docs: DOCS-918
doctypes:
- task
tags:
- docs
title: Provision Users and Groups with SCIM
toc: true
weight: 500
---

<style>
h2 {
  border-top: 1px solid #ccc;
  padding-top:20px;
}
</style>

{{< shortversions "2.3.0" "latest" "nimvers" >}}

## Overview

With Instance Manager 2.3 or later, you can provision, update, or deprovision users and user groups using SCIM 2.0. SCIM, short for "System for Cross-domain Identity Management" is an open API for managing identities.

## Access SCIM APIs

Instance Manager enforces RBAC for the SCIM APIs through the `USER-MANAGEMENT` feature. To have full access, users must be assigned to a role with `Create`, `Read`, `Update`, and `Delete` permissions.

{{< see-also >}}
A **feature** is a grouping of functionality in Instance Manager. A **role** definition is a collection of permissions for one or more features.

For more information about features and roles, see the [Set Up RBAC]({{< relref "/nms/admin-guides/rbac/rbac-getting-started.md" >}}) topic.
{{< /see-also >}}

### SCIM Endpoints

The SCIM endpoints listed below follow the specification outlined in the [SCIM Endpoints and HTTP Methods](https://datatracker.ietf.org/doc/html/rfc7644#section-3.2).

<br>

<details open>
 <summary>List of Available Endpoints</summary>

<br>

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

| Endpoint | Method | Description |
| --- | --- | ----------- |
| `/api/scim/v2/Users` | POST | Adds a new IDP User. |
| `/api/scim/v2/Users` | GET | Gets all the IDP Users. Pagination params are supported as per SCIM standard. Filter param by `userName` is available.|
| `/api/scim/v2/Users/{userID}` | PUT | Updates an existing IDP User. |
| `/api/scim/v2/Users/{userID}` | DELETE | Deletes an existing IDP User. |
| `/api/scim/v2/Groups` | POST | Adds a new User Group. |
| `/api/scim/v2/Users` | GET | Gets all the IDP Groups. Pagination params are supported as per SCIM standard. |
| `/api/scim/v2/Groups/{groupID}` | PUT | Updates an existing User Group. |
| `/api/scim/v2/Groups/{groupID}` | DELETE | Deletes an existing User Group. |

{{</bootstrap-table>}}
</details>

## Request and Response Schemas

Requests and responses follow the schema format defined in [Resource Schema Representation](https://datatracker.ietf.org/doc/html/rfc7643#section-8.7.1).

### Create User

To create a user, send a **POST** request similar to the following example to the `/api/scim/v2/Users` endpoint:

#### Request

```json
{
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:User"
  ],
  "externalId": "idpuser@mydomain.ctrl",
  "userName": "idpuser@mydomain.ctrl",
  "name": {
    "formatted": "Example IDP User",
    "familyName": "Example",
    "givenName": "SSO"
  }
}
```

#### Response

```json
{
  "emails": [
    {
      "value": "idpuser@mydomain.ctrl"
    }
  ],
  "externalId": "idpuser@mydomain.ctrl",
  "id": "dc898740-4e9c-41a4-912c-1f3a20edf66e",
  "meta": {
    "created": "2022-06-17T21:03:37.138Z",
    "lastModified": "2022-06-17T21:03:37.138Z",
    "location": "/api/scim/v2/Users/dc898740-4e9c-41a4-912c-1f3a20edf66e",
    "resourceType": "User"
  },
  "name": {
    "familyName": "Example",
    "givenName": "SSO"
  },
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:User"
  ],
  "userName": "idpuser@mydomain.ctrl"
}
```

<br>

### Create Group

To create a group, send a **POST** request similar to the following example to the `/api/scim/v2/Groups` endpoint:

#### Request

In this request, `User` is assigned as a member.

```json
{
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:Group"
  ],
  "displayName": "Example Group",
  "externalId": "7fcb12f4-af71-4f7d-a987-6c1a91cb838a",
  "members": [
    {
      "type": "User",
      "value": "dc898740-4e9c-41a4-912c-1f3a20edf66e"
    }
  ]
}
```

#### Response

```json
{
  "displayName": "Example Group",
  "externalId": "7fcb12f4-af71-4f7d-a987-6c1a91cb838a",
  "id": "e023964d-8a63-44f8-aa85-51ffa6aaa8f1",
  "members": [
    {
      "type": "User",
      "value": "dc898740-4e9c-41a4-912c-1f3a20edf66e"
    }
  ],
  "meta": {
    "created": "2022-06-17T21:06:46.774Z",
    "lastModified": "2022-06-17T21:06:46.774Z",
    "location": "/api/scim/v2/Groups/e023964d-8a63-44f8-aa85-51ffa6aaa8f1",
    "resourceType": "Group"
  },
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:Group"
  ]
}
```

{{< important >}}After creating a group with SCIM, you need to [assign roles to the group]({{< relref "/nms/admin-guides/rbac/rbac-getting-started#create-group" >}}) in Instance Manager so the group has permissions associated with it.{{< /important >}}

## Update Users Created with SCIM

To update users created with SCIM, you need to use the SCIM API or update the users directly in your identity provider (IdP). You can't use the F5 NGINX Manager web interface to edit user details from an identity provider.
