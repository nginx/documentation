---
description: ''
nd-docs: DOCS-798
title: 'Overview: NGINX Instance Manager REST API'
toc: true
weight: 400
type:
- reference
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Introduction

NGINX Instance Manager provides a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) API that uses standard authentication methods, HTTP response codes, and verbs. You can use the API to manage both NGINX Instance Manager and the NGINX instances running on your systems.

## Object model

The NGINX Instance Manager REST API allows you to manage both NGINX Instance Manager and NGINX instances programmatically. The API provides the following features:

- View metrics and information about data plane host systems and NGINX instances.
- View and edit NGINX configurations.
- Save NGINX configurations for future deployment.
- Analyze saved and current configurations for syntactic errors.
- Publish configurations to NGINX instances.
- Scan the network to find unmanaged NGINX instances.
- Manage certificates.
- Create users, roles, and role permissions to manage RBAC.

## API reference documentation

{{< include "nim/how-to-access-api-docs.md" >}}

## Usage

You can use tools such as `curl` or [Postman](https://www.postman.com) to interact with the NGINX Instance Manager API.

You can find the NGINX Instance Manager API URLs in the following format: `https://<NMS_FQDN>/api/platform/<API_VERSION>`.

{{<note>}}When making API calls by using `curl`, Postman, or any other tool, include your [authentication](#authentication) information with each call. Also include a `-k` to bypass TLS/SSL verification.{{</note>}}

Alternatively, in the API Reference docs, you can also use the "Try it Out" function. Since you're already logged into the NGINX Instance Manager platform, the "Try it Out" function automatically includes authentication credentials.

To do so, take the steps below:

1. Select the endpoint and action that you want to send. For example: `POST /infrastructure/workspaces`.
2. Select the **Try it Out** button.
3. If the endpoint accepts parameters, replace the placeholder examples in the request body with your desired values.
4. Select the **Execute** button to send the request.
5. When the request completes, the response appears in the user interface.

## Authentication

To use the NGINX Instance Manager API, you need to use one of the following authentication methods:

- Basic authentication
- JSON Web Token (JWT)

### Basic authentication

{{< include "nim/admin-guide/auth/basic-auth-api-requests.md" >}}

### JSON Web Token

If your organization is using OIDC, you will be prompted to log in with your Identity Provider the first time you attempt to reach an API. After authenticating, you can request a JWT to use in subsequent API calls.

{{<note>}}The means of requesting a token varies according to the Identity Provider; if you're not sure which provider your organization uses, check with your system administrator or technical support team.{{</note>}}

Once you have a JWT, set it up as a "Bearer" <access token> using the "Authorization" request header field, as shown in the example below.

```shell
curl -X GET "https://<NIM_FQDN>/api/platform/<API_VERSION>/systems" -H "Authorization: Bearer <access token>"
```

{{< include "security/jwt-password-note.md" >}}

## Errors and response codes

NGINX Instance Manager uses standard HTTP response codes to indicate whether an API request succeeds or fails. Codes in the `2xx` range mean the request succeeded. Codes in the `400` range mean the request failed due to the reason(s) indicated in the response message. Common reasons for `4xx` responses are:

- Requests where required information is missing.
- Lack of or incorrect authentication credentials.
- Requests that refer to resources that do not exist or are in use by other resources.

**HTTP Status Codes**
{{< bootstrap-table "table table-striped table-bordered" >}}

| Response Code | Meaning                                                          |
|---------------|------------------------------------------------------------------|
| 200           | Success: The request was received.                               |
| 201           | Success: Created the requested resource.                         |
| 202           | Success: The request was accepted and configuration is in process.|
| 204           | Success: Deleted the requested resource.                         |
| 400           | Bad Request: Required information is missing or incorrectly formatted. |
| 401           | Unauthorized: You are not logged in or do not have permission to access the requested resource. |
| 404           | Not found: The requested resource does not exist.                |
| 409           | Conflict: The requested resource already exists or is referenced by another resource. |

{{< /bootstrap-table >}}

## Encoding

The NGINX Instance Manager API expects and returns JSON-formatted data by default.

All JSON data must be encoded using UTF-8. If you don't specify a media type in an API call, the API uses `application/json` by default.

## Pagination

Top-level NGINX Instance Manager API endpoints support fetching information about multiple resources ("lists"). These requests can return large data sets (for example, `GET /events` and `GET /instances`). You can control the size of the data set returned and navigate through pages by sending additional calls.

### Parameters

{{< bootstrap-table "table table-striped table-bordered" >}}

| Name       | Format   | Type  | Description                                                                                                                  | Default value |
|------------|----------|-------|------------------------------------------------------------------------------------------------------------------------------|---------------|
| page     | integer  | query | The page number to retrieve.                                                                                                 | `1`           |
| pageToken| string   | query | A transactional token used for pagination. The token ensures consistent query results across requests.                        | N/A           |
|  pageSize | integer  | query | The number of items returned per page. The maximum value is 100. If `pageSize=0`, pagination is disabled, and all results are returned. | `100`         |

{{< /bootstrap-table >}}

## Versioning

Each major version of the NGINX Instance Manager API is backward-compatible with previous releases of the same version. Any backward-incompatible changes result in a new major version.

The version is represented in the `<version>` part of the API URI.

For example, to use a v2 API, send requests to:

`https://<NIM>/api/platform/v2`

When a new version is required, we release it for the entire API. You won't see a mix of v1 and v2 objects in the same API.
