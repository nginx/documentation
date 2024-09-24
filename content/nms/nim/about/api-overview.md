---
description: This topic gives an overview of the Instance Manager API.
docs: DOCS-798
doctypes:
- reference
tags:
- docs
title: API Overview
toc: true
weight: 200
---

{{< shortversions "2.0.0" "latest" "nimvers" >}}

F5 NGINX develops products like NGINX Unit, NGINX Instance Manager, and NGINX App Protect WAF.



## Introduction

NGINX Management Suite Instance Manager provides a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) API that uses standard authentication methods, HTTP response codes, and verbs.

## Object Model

The NGINX Instance Manager REST API allows you to manage Instance Manager objects and the NGINX Management Suite platform programmatically. The Instance Manager API provides the following features:

- View metrics and information about data plane host systems and NGINX instances.
- View and edit NGINX configurations.
- Save NGINX configurations for future deployment.
- Analyze saved and current configurations for syntactic errors.
- Publish configurations to NGINX instances.
- Scan the network to find unmanaged NGINX instances.
- Manage certificates.
- Create users, roles, and role permissions to manage RBAC.

## API Reference Documentation

{{< include "nim/how-to-access-api-docs.md" >}}

## Usage

You can use tools such as `curl` or [Postman](https://www.postman.com) to interact with the NGINX Instance Manager API.
You can find The NGINX Instance Manager API URLs in the following format: `https://<NMS_FQDN>/api/platform/<API_VERSION>`.

{{<note>}}When making API calls by using `curl`, Postman, or any other tool, include your [authentication](#authentication) information with each call. Also include a `-k` to bypass TLS/SSL verification.{{</note>}}

Alternatively, in the API Reference docs, you can also use the "Try it Out" function. Since you're already logged into the NGINX Management Suite platform, the "Try it Out" function automatically includes authentication credentials.

To do so, take the steps below:

1. Select the endpoint and action that you want to send. For example: `POST /infrastructure/workspaces`.
1. Select the **Try it Out** button.
1. If the endpoint accepts parameters, replace the placeholder examples in the request body with your desired values.
1. Select the **Execute** button to send the request.
1. When the request completes, the response appears in the user interface.

## Authentication

To use the Instance Manager API, you need to use one of the following authentication methods:

- Basic authentication
- JSON Web Token (JWT)


### Basic Authentication

{{< include "admin-guides/auth/basic-auth/basic-auth-api-requests.md" >}}


### JSON Web Token

If your organization is using OIDC, you will be prompted to log in with your Identity Provider the first time you attempt to reach an API. After authenticating, you can request a JWT to use in subsequent API calls.

{{<note>}}The means of requesting a token varies according to the Identity Provider; if you're not sure which provider your organization uses, check with your system administrator or technical support team. {{</note>}}

Once you have a JWT, set it up as a "Bearer" <access token> using the "Authorization" request header field, as shown in the example below.

```shell
curl -X GET "https://<NMS_FQDN>/api/platform/<API_VERSION>/systems" -H "Authorization: Bearer <access token>"
```

{{< include "security/jwt-password-note.md" >}}

## Errors and Response Codes

Instance Manager uses standard HTTP response codes to indicate whether an API request succeeds or fails. Codes in the `2xx` range mean the request succeeded. Codes in the `400` range mean the request failed due to the reason(s) indicated in the response message. Common reasons for `4xx` responses are:

- requests where required information is missing;
- lack of or incorrect authentication credentials; and
- requests that refer to resources that do not exist or are in use by other resources.

**HTTP Status Codes**
{{< bootstrap-table "table table-striped table-bordered" >}}

| Response Code | Meaning |
|---------------|---------|
| 200           | Success: The request was received. |
| 201           | Success: Created the requested resource. |
| 202           | Success: The request was accepted and configuration is in process. |
| 204           | Success: Deleted the requested resource. |
| 400           | Bad Request: Required information is missing or incorrectly formatted. |
| 401           | Unauthorized: You are not logged in or do not have permission to access the requested resource. |
| 404           | Not found: The requested resource does not exist. |
| 409           | Conflict: The requested resource already exists or is referenced by another resource. |

{{< /bootstrap-table >}}

## Encoding

All Instance Manager API endpoints expect and return JSON-formatted data by default.

All JSON-formatted data is expected to be encoded using UTF-8. If you do not specify a specific media type in an API call, then the API defaults to `application/json`.

## Pagination

Top-level Instance Manager API endpoints support fetching information about multiple resources ("lists"). Such requests may return large data sets (for example, `GET /events` and `GET /instances`). In these cases, you can define the size of the data set returned for each call and navigate amongst the pages of data by sending subsequent calls.

### Parameters

{{< bootstrap-table "table table-striped table-bordered" >}}

| Name| Format| Type| Description | Default value|
|:---|---|---|--------|--------|
|`page`|integer|query| page number | `1`|
|`pageToken`|string|query|Transactional token used for pagination.<br/>The token ensures consistency of the query results across requests for various pages of data. It provides a snapshot of the database contents from the time at which the query was received.<br/>If `pageToken` is not provided with a page request, a token is automatically generated and will be returned in the response metadata. You should include the token in subsequent requests for pages in the query results.<br/><br/>Sending a query without a pageToken refreshes the query results.|N/A |
|`pageSize`|integer|query|Defines the number of returned items per page.<br/><br/>The maximum value is 100. If the value is greater, it is automatically scaled down to 100.<br/><br/>If `pageSize=0`, pagination is disabled and the full dataset will be returned in the response. <br/>The response size is limited to 10,000 results. If the number of results exceeds 10,000 a warning is returned.|`100`|

{{< /bootstrap-table >}}

## Versioning

Each major version of the Instance Manager API is backward-compatible with the previous releases in that version.
The introduction of backward-incompatible changes to the Instance Manager API constitutes a major version change.
This will be represented in the `<version>` section of the API URI.

For example, to use a v2 API, you would send requests to `https://<NMS_FQDN>/api/platform/v2`.

When any Instance Manager component requires a version change, we will release a new version of the entire API. You will not see a mix of v1 and v2 objects in the same API.
