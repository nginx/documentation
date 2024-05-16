---
description: NGINX Management Suite API Connectivity Manager lets you secure APIs
  with OpenAPI Spec (OAS) security schemes. This tutorial provides step-by-step instructions
  for setting up basic authentication and API key authentication security schemes
  to secure your APIs and control access to authorized users or applications.
docs: DOCS-1246
doctypes:
- tutorial
tags:
- docs
title: OAS Security Schemes
toc: true
weight: 200
---

## Overview

The OpenAPI Specification (OAS) allows you to specify authentication and authorization requirements, or security schemes, for your APIs, ensuring that only authorized users or applications can access them. These security schemes are applied globally, meaning they are enforced for all APIs within the OAS.

{{<note>}}When configuring security schemes, keep in mind that path-level security requirements will not be applied and are ignored.{{</note>}}

Listed below are the OAS security schemes that API Connectivity Manager supports.


{{< bootstrap-table "table table-striped table-bordered" >}}

| OAS&nbsp;Authorization&nbsp;Schemes | ACM&nbsp;Supported&nbsp;Schemes |
|---|---|
| Basic Authentication | <i class="fa-solid fa-check" style="color: green"></i> Supported <br><br>APIs with this scheme expect credentials to be included in the HTTP Authorization request header. |
| API Key Authentication | <i class="fa-solid fa-check" style="color: green"></i> Supported <br><br>The API Key security scheme uses a unique API key to authenticate requests. With this scheme, the API expects the API key to be passed as a query parameter or header in the HTTP request. |
| OAuth2 JWT Assertion | <i class="fa-solid fa-ban" style="color: red"></i> Not supported|
| OAuth2 Token Introspection |<i class="fa-solid fa-ban" style="color: red"></i> Not supported |

{{< /bootstrap-table >}}



---

## Before You Begin

To complete the instructions in this guide, you need the following:

1. API Connectivity Manager is installed, licensed, and running
2. One or more Infra and Service workspaces
3. One or more Environments

---

## Basic Authentication Security Scheme

Basic Authentication is a security scheme that is commonly used to authenticate HTTP requests. The request contains a header field in the form of `Authorization: Basic <credentials>`, where `<credentials>` is the Base64-encoded username and password joined by a single colon.

With Basic Authentication, API owners can restrict access to their APIs by requiring usernames and passwords; API access is granted only after a username and password are validated.

{{<call-out "important" "Security Consideration" >}}We recommend using Basic Authentication only over encrypted channels such as HTTPS in order to minimize security risks.{{</call-out>}}

### Basic Authentication Scheme Definition


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                                           | Type | Required      | Valid Value(s)                                                                                                                                                                           | Description | Default |
|-------------------------------------------------|----------|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|
| `type`                  | `string`  | True   | `http` | The type of the security scheme.       | `N/A`  |
| `description`         | `string`   | False | Of type `string` | A short description for the security scheme. CommonMark syntax can be used for rich text representation.      | `N/A`    |
| `scheme`       | `string`   | True  | `basic` | The name of the HTTP Authorization scheme to be used in the Authorization header as defined in [RFC7235](https://datatracker.ietf.org/doc/html/rfc7235). | `N/A` |
| `x-credentialForward`| `bool` | False | one of `[true, false]` | This field defines whether the basic authentication credential is proxy-forwarded to the backend service in the HTTP request Authorization header. | `false` |
| `x-errorReturnConditions.`<br>`notSupplied.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when `basicAuth` is not supplied. | `401` |
| `x-errorReturnConditions.`<br>`noMatch.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when invalid `basicAuth` is supplied . | `403` |
| `x-labels.targetPolicyName` | `string` | False | Of type `string` | The required target policy name set in policy `metadata.labels.targetPolicyName`. | `default` |


{{< /bootstrap-table >}}



### Configure Basic Authentication Scheme

To configure a basic authentication scheme, take the following steps:

1. Create an API spec with the basic security scheme configured. In the following example, take a look at how `ExampleBasicAuth` is configured in `component.securitySchemes`.

   ```bash
   POST https://{{NMS-FQDN}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/api-docs
   ```

   <details>
   <summary>Example POST/PUT JSON request: Create Basic Authentication API Spec</summary>

   {{< include "acm/tutorials/security-scheme-json-blobs/basic-security-apispec.md" >}}

   </details>


2. Create a proxy with `specRef` referencing the spec from step 1. Since the referenced spec uses Basic Authentication, you need to include the necessary basic authentication credentials within the body of the POST/PUT request.

   ```bash
   POST https://{{NMS-FQDN}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/proxies
   ```

   <details>
   <summary>Example POST/PUT JSON request: Create Proxy referencing OAS spec with Basic Authentication scheme</summary>

   {{< include "acm/tutorials/security-scheme-json-blobs/basic-auth-post-proxy.md" >}}

   </details>

   Verify the GET request for the proxy. In the JSON response, you should see `policies.basic-authn` configured in the `proxyConfig` section.

   ```bash
   GET https://{{NMS-FQDN}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/proxies/petstore-proxy?hostname={{environmentHostname}}&version=v1&includes=sensitivedata
   ```

   <details>
   <summary>Example GET JSON response: Proxy with basic-authn policy configured</summary>

   {{< include "acm/tutorials/security-scheme-json-blobs/basic-auth-get-proxy.md" >}}

   </details>

3. Pass traffic to the endpoints. The following example sends a request through a proxy to the Pet Store server, using Basic Authentication. A successful request will return a `200` status response.

   ```bash
   curl -X GET -u user1:secret -H "Content-Type: application/json"  http://54.188.248.124/api/v3/pet/4

   {"id":4,"category":{"id":1,"name":"{{$$randomFirstName}}"},"name":"Steve","photoUrls":["http://placeimg.com/640/480/cats"],"tags":[{"id":0,"name":"string"}],"status":"available"}
   ```

   In contrast, if the request lacks proper authentication, the response is "Unauthorized" with a status code of `401`

   ```bash
   curl -X GET -H "Content-Type: application/json" http://54.188.248.124/v1/pet

   {
       "message": "Unauthorized",
       "status": "401"
   }
   ```

---

## API Key Authentication Security Scheme

The API Key Authentication security scheme uses a unique API key to authenticate requests. The API key is usually a long, randomly generated string provided to the client by the API owner. To access the API, the client must include this key as a query parameter or in the request header. The API owner can use this key to identify the client and authorize access to the API.

### API Key Scheme Definition


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                                           | Type | Required      | Valid Value(s)                                                                                                                                                                           | Description | Default |
|-------------------------------------------------|----------|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|
| `type`                  | `string`  | True   | `apiKey` | The type of the security scheme.       | `N/A`  |
| `description`         | `string`   | False | Of type `string` | A short description for the security scheme. CommonMark syntax can be used for rich text representation.      | `N/A`    |
| `name`       | `string`   | False  | <p>Of type `string`, if `in` is set to `header`. <br><br> The `name` must not contain underscores. This is also enforced in API Connectivity Manager for the API key authentication policy.</p> | The name of the header or query parameter to be used. | `apiKey` |
| `in` | `string`  | False   | one of `["header", "query"]` | The location of the API key. | `header` |
| `x-credentialForward`| `bool` | False | one of `[true, false]` | This field defines whether the `apiKey` credential is proxy-forwarded to the backend service in the HTTP request header. | `false` |
| `x-errorReturnConditions.`<br>`notSupplied.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when `apiKey` is not supplied. | `401` |
| `x-errorReturnConditions.`<br>`noMatch.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when an invalid `apiKey` is supplied . | `403` |
| `x-labels.targetPolicyName` | `string` | False | Of type `string` | The required target policy name set in policy `metadata.labels.targetPolicyName`. | `default` |


{{< /bootstrap-table >}}


### Configure API Key Authentication Scheme

To configure the API Key Authentication security scheme, take the following steps:

1. Create an API spec with the `apiKey` security scheme configured. In the following example, take a look at how `ExampleApiKeyAuth` is configured in `component.securitySchemes`.

   ```bash
   POST https://{{NMS-FQDN}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/api-docs
   ```

   <details>
   <summary>Example POST/PUT JSON request: Create API Key Authentication API Spec</summary>

   {{< include "acm/tutorials/security-scheme-json-blobs/apikey-auth-spec.md" >}}

   </details>

2. Create a proxy with `specRef` referencing the spec from step 1. See the following example for how your proxy request body should look with `apikey-authn` configured on the policy.

   Note, since the referenced spec uses the API Key Authentication security scheme, you need to include the required API key within the POST/PUT request body.

   ```bash
   POST https://{{NMS-FQDN}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/proxies
   ```

   <details>
   <summary>Example POST/PUT JSON request: Create Proxy referencing OAS spec with API Key Authentication scheme</summary>

   {{< include "acm/tutorials/security-scheme-json-blobs/apikey-auth-post-proxy.md" >}}

   </details>

   Verify the GET request for the proxy. In the JSON response, you should see `policies.apikey-authn` in the `proxyConfig` section.

   ```bash
   GET https://{{NMS-FQDN}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/proxies/petstore-proxy?hostname={{environmentHostname}}&version=v1&includes=sensitivedata
   ```

   <details>
   <summary>Example GET JSON response: Proxy with apikey-authn policy configured</summary>

   {{< include "acm/tutorials/security-scheme-json-blobs/apikey-auth-get-proxy.md" >}}

   </details>

   ```bash
   curl -X GET -H "apiKey:testapikey1234" -H "Content-Type: application/json"  http://54.188.248.124/api/v3/pet/4
   {"id":4,"category":{"id":1,"name":"{{$$randomFirstName}}"},"name":"Steve","photoUrls":["http://placeimg.com/640/480/cats"],"tags":[{"id":0,"name":"string"}],"status":"available"}
   ```

   If the request lacks proper authentication, the response is "Unauthorized" with a status code of `401`

   ```bash
   curl -X GET -H "Content-Type: application/json" http://54.188.248.124/v1/pet
   {
       "message": "Unauthorized",
       "status": "401"
   }
   ```
