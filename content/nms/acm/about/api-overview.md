---
description: This topic gives an overview of the F5 NGINX Management Suite API Connectivity
  Manager API.
docs: DOCS-929
title: API Overview
toc: true
weight: 300
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Introduction

API Connectivity Manager provides a [RESTful](https://en.wikipedia.org/wiki/Representational_state_transfer) API that uses standard authentication methods, HTTP response codes, and verbs.

## Object Model

You can use the API Connectivity Manager API to connect, secure, and govern your APIs. In addition, API Connectivity Manager lets you separate infrastructure lifecycle management from the API lifecycle, giving your IT/Ops teams and application developers the ability to work independently.

The API Connectivity Manager API provides the following features:

- Create and manage isolated Workspaces for business units, development teams, and so on, so each team can develop and deploy at its own pace without affecting other teams.
- Create and manage API infrastructure in isolated workspaces.
- Enforce uniform security policies across all workspaces by applying global policies.
- Create Developer Portals that align with your brand, with custom color themes, logos, and favicons.
- Onboard your APIs to an API Gateway and publish your API documentation to the Developer Portal.
- Let teams apply policies to their API proxies to provide custom quality of service for individual applications.
- Onboard API documentation by uploading an OpenAPI spec.
- Publish your API docs to a Dev Portal while keeping your API's backend service private.
- Let users issue API keys or basic authentication credentials for access to your API.
- Send API calls by using the Developer Portal's API Reference documentation.

## API Reference Documentation

You can view the API Connectivity Manager API Reference documentation in the F5 NGINX Management Suite user interface.
To access the API Docs, take the steps below:

1. Log in to the NGINX Management Suite user interface.
2. From the Launchpad, select the **Docs** card.
3. Select **API Connectivity Manager** from the **Docs** list in the sidebar. The API Connectivity Manager API Reference documentation will then display.

## Authentication

API Connectivity Manager supports authentication by using basic authentication or a JSON Web Token (JWT). You can get a JWT by logging in with an OpenID Connect (OIDC) Identity Provider.

For more information about the available authentication options for NGINX Management Suite, refer to [Set Up Authentication]({{< relref "/nim/admin-guide/authentication/basic-auth/set-up-basic-authentication.md" >}}).

### Basic Authentication

You can make API requests with basic auth by sending the base64-encoded credentials as a "Basic" token in the "Authorization" request header, as shown in the example below.

```shell
curl -X GET "https://<NMS_FQDN>/api/acm/<API_VERSION>/workspaces/infrastructure" -H "Authorization: Basic YWRtaW..."
```

{{<warning>}}Even when encoded, basic authentication is not secure. The use of basic auth is not recommended for production environments.{{</warning>}}

### JSON Web Token

If your organization is using OIDC, you will be prompted to log in with your Identity Provider the first time you attempt to reach an API. After authenticating, you can request a JWT to use in subsequent API calls.

{{<note>}}
<br />

- The means of requesting a token varies according to the Identity Provider; if you're not sure which provider your organization uses, check with your system administrator or technical support team.
- Automated CI/CD workflows are not supported when using OIDC authentication.
{{</note>}}

The JWT should be sent as a "Bearer" token in the "Authorization" request header, as shown in the example below.

```shell
curl -X GET "https://<NMS_FQDN>/api/acm/<API_VERSION>/workspaces/infrastructure" -H "Authorization: Bearer <access token>"
```

## Usage

### Command-line

You can use tools such as `curl` or [Postman](https://www.postman.com) to interact with the API Connectivity Manager REST API.
The API URL follows the format `https://<NMS_FQDN>/api/acm/<API_VERSION>`.

{{<note>}}When making API calls by using `curl`, Postman, or any other tool, you will need to provide your authentication information with each call. {{</note>}}

### User Interface

You can also use the "Try it Out" function in the API Reference docs to send a call to the API Connectivity Manager API. You do not have to provide a means of authentication when sending API calls via the API Documentation UI because you are already logged in to the NGINX Management Suite platform.

To do so, take the steps below:

1. Select the endpoint and action that you want to send. For example: `POST /infrastructure/workspaces`.
2. Select the **Try it Out** button.
3. If the endpoint accepts parameters, replace the placeholder examples in the request body with your desired values.
4. Select the **Execute** button to send the request.
5. When the request completes, the response appears in the UI.

## Errors and Response Codes

API Connectivity Manager uses standard HTTP response codes to indicate whether an API request succeeds or fails. Codes in the `2xx` range mean the request succeeded. Codes in the `400` range mean the request failed due to the reason(s) indicated in the response message. Common reasons for `4xx` responses are:

- requests where required information is missing;
- lack of or incorrect authentication credentials; and
- requests that refer to resources that do not exist or are in use by other resources.

**HTTP Status Codes**
{{< bootstrap-table "table table-striped table-bordered" >}}

| Response Code | Meaning |
|---------------|---------|
| 200      | Success: The request was received. |
| 201      | Success: Created the requested resource. |
| 202      | Success: The request was accepted and configuration is in process. |
| 204      | Success: Deleted the requested resource. |
| 400      | Bad Request: Required information is missing or incorrectly formatted. |
| 401      | Unauthorized: You are not logged in or do not have permission to access the requested resource. |
| 404      | Not found: The requested resource does not exist. |
| 409      | Conflict: The requested resource already exists or is referenced by another resource. |

{{< /bootstrap-table >}}

## Encoding

All API Connectivity Manager API endpoints expect and return JSON-formatted data by default.
All JSON-formatted data is expected to be encoded using UTF-8. If you do not specify a media type when sending an API call, then the API defaults to `application/json`.

## Pagination

Top-level API Connectivity Manager API endpoints support fetching information about multiple resources ("lists"). Such requests may return large data sets (for example, `GET /services/workspaces/{workspaceName}/proxies` and `GET /services/workspaces/{workspaceName}/proxies/{proxyName}/jobs`). For these endpoints, you can define the size of the data set returned for each call and navigate amongst the pages of data when sending subsequent calls.

### Parameters

{{< bootstrap-table "table table-striped table-bordered" >}}

| Name| Format| Type| Description | Default value|
|:---|---|---|--------|--------|
|`page`|integer|query| page number | `1`|
|`pageToken`|string|query|Transactional token used for pagination.<br/>The token ensures consistency of the query results across requests for various pages of data. It provides a snapshot of the database contents from the time at which the query was received.<br/>If `pageToken` is not provided with a page request, a token is automatically generated and will be returned in the response metadata. You should include the token in subsequent requests for pages in the query results.<br/><br/>Sending a query without a pageToken refreshes the query results.|N/A |
|`pageSize`|integer|query|Defines the number of returned items per page.<br/><br/>The maximum value is 100. If the value is greater, it is automatically scaled down to 100.<br/><br/>If `pageSize=0`, pagination is disabled and the full dataset will be returned in the response. <br/>The response size is limited to 10,000 results. If the number of results exceeds 10,000 a warning is returned.|`100`|

{{< /bootstrap-table >}}

## Versioning

Each major version of the API Connectivity Manager API is backward-compatible with the previous releases in that version.
The introduction of backward-incompatible changes to the API Connectivity Manager API constitutes a major version change.
This will be represented in the `<API_VERSION>` section of the API URI.

For example, to use a v2 API, you would send requests to `https://<NMS_FQDN>/api/acm/v2`.
