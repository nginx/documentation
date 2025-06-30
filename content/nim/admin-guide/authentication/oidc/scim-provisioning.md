---
nd-docs: DOCS-918
title: Provision users and groups using SCIM
toc: true
weight: 500
type:
- how-to
---

## Overview

Starting with NGINX Instance Manager 2.3, you can use SCIM 2.0 (System for Cross-domain Identity Management) to provision, update, or deprovision users and user groups through an open API for managing identities.

## Access SCIM APIs

NGINX Instance Manager enforces RBAC for the SCIM APIs through the `USER-MANAGEMENT` feature. To have full access, users must be assigned to a role with `Create`, `Read`, `Update`, and `Delete` permissions.

### SCIM Endpoints

The SCIM endpoints listed below follow the specifications outlined in the [SCIM Endpoints and HTTP Methods](https://datatracker.ietf.org/doc/html/rfc7644#section-3.2).

#### Available Endpoints

- **`/api/scim/v2/Users` (POST):** Adds a new IDP user.
- **`/api/scim/v2/Users` (GET):** Retrieves all IDP users. Pagination parameters are supported according to the SCIM standard, and you can filter by `userName`.
- **`/api/scim/v2/Users/{userID}` (PUT):** Updates an existing IDP user.
- **`/api/scim/v2/Users/{userID}` (DELETE):** Deletes an existing IDP user.
- **`/api/scim/v2/Groups` (POST):** Adds a new user group.
- **`/api/scim/v2/Groups` (GET):** Retrieves all IDP groups. Pagination parameters are supported according to the SCIM standard.
- **`/api/scim/v2/Groups/{groupID}` (PUT):** Updates an existing user group.
- **`/api/scim/v2/Groups/{groupID}` (DELETE):** Deletes an existing user group.

## Request and response schemas

Requests and responses follow the schema format defined in [Resource Schema Representation](https://datatracker.ietf.org/doc/html/rfc7643#section-8.7.1).

### Create user

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

### Create group

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

{{< important >}}After creating a group with SCIM, you need to [assign roles to the group]({{< ref "/nim/admin-guide/rbac/assign-roles.md" >}}) in NGINX Instance Manager so the group has permissions associated with it.{{< /important >}}

## Update users created with SCIM

To update users created with SCIM, you need to use the SCIM API or update the users directly in your identity provider (IdP). You can't use the NGINX Instance Manager web interface to edit user details from an identity provider.
