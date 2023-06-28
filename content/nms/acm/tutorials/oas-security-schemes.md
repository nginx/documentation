---
title: "OAS Security Schemes"
date: 2023-06-22T18:20:41+01:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to configure security schemes in OAS for NGINX Management Suite API Connectivity Manager."
# Assign weights in increments of 100
weight: 200
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

{{<custom-styles>}}

## Overview

This tutorial walks you through setting up the security schemes in OpenAPI Specification using NGINX Management Suite API Connectivity Manager.

---

## What is a Security Scheme?

The security scheme in OAS is a way to specify how an API should be secured, including how requests are authenticated and authorized. It allows API owners to define the security requirements for their API and communicate them to API consumers. There are several API Gateway authentication/authorization schemes types that can be confired in the OAS : API key authentication, basic authentication, OAuth2 JWT assertion, and OAuth2 token introspection.

## ACM Supported Scheme Types & Requirements

Currently, in Application Connectivity Manager (ACM) security schemes are available at the global level i.e. the security scheme will be applied to all the APIs in the OAS. There are two types of supported schemes user can configure: HTTP-Basic and the API Key.

In the following section we will go through both of them.

Basic: With this scheme, the API expects credentials to be included in the Authorization header of the HTTP request.

API Key: The API Key security scheme is used to authenticate requests using a unique API key. With this scheme, the API expects the API key to be included as a query parameter or header in the HTTP request.

By specifying the appropriate security scheme and its properties in the OAS, ACM API owners can ensure that their API is secure and only accessible to authorized users or applications.

If a user configures path level security requirements, they will be ignored and not applied (until supported in ACM).

## Before You Begin

To complete the instructions in this guide, you need the following:

1. API Connectivity Manager is installed, licensed, and running
2. One or more Infra and Service workspaces
3. One or more Environments

## API Key Authentication Security Scheme

The API Key security scheme is used to authenticate requests using a unique API key. The API key is usually a long, randomly generated string that is provided to the client by the API owner. The client must include the API key as a query parameter or header in the HTTP request. The API owner can use this key to identify the client and authorize access to the API.
In the following section let's see step by step to configure the API Key Authentication Security Scheme


Below table illustrates the Scheme Definition

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{< bootstrap-table "table table-striped table-bordered" >}}
| Field                                           | Type | Required      | Valid Value(s)                                                                                                                                                                           | Description | Default |
|-------------------------------------------------|----------|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|
| `type`                  | `string`  | True   | `apiKey` | The type of the security scheme.       | `N/A`  |
| `description`         | `string`   | False | Of type `string` | A short description for security scheme. CommonMark syntax MAY be used for rich text representation.      | `N/A`    |
| `name`       | `string`   | False  | <p>Of type `string`, if `in` is set to `header`, name must not contain underscores. This is also enforced in ACM for API key authentication policy.</p> | The name of the header or query parameter to be used. | `apiKey` |
| `in` | `string`  | False   | one of `["header", "query"]` | The location of the API key. | `header` |
| `x-credentialForward`| `bool` | False | one of `[true, false]` | This field defines whether the `apiKey` credential is going to be proxy forwarded to backend service - in the HTTP header. | `false` |
| `x-errorReturnConditions.notSupplied.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when `apiKey` is not supplied. | `401` |
| `x-errorReturnConditions.noMatch.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when invalid `apiKey` is supplied . | `403` |
| `x-labels.targetPolicyName` | `string` | False | Of type `string` | The required target policy name set in policy `metadata.labels.targetPolicyName`. | `default` |


{{< /bootstrap-table >}}
{{< raw-html>}}</div>{{</raw-html>}}

Step - 1: Create an apispec with the apikey security scheme configured. In the following apispec example check the `component securitySchemes` section `ExampleApiKeyAuth` is configured. 

```shell
POST https://{{controller_ip}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/api-docs
```

 <details Apikeyauth apispec>
   <summary> Api key auth apispec</summary>

{{< include "acm/tutorials/security-scheme-json-blobs/apikey-auth-spec.md" >}}

   </details>

Step - 2: Create a proxy referring to the above spec on the `specRef`. Check below on how your proxy request body would look like with `apikey-authn` configured on the policy. 

When an API Key security scheme is provided in an OAS that is referenced in a proxy POST/PUT request if the user wants to set up valid API keys they need to provide these in the proxy POST/PUT request body. Below is an example to supplement the example OAS scheme above.

```shell
POST https://{{controller_ip}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/proxies
```

<details Proxy Request referring to apiauth spec>
   <summary> Proxy Request referring to apiauth spec</summary>

{{< include "acm/tutorials/security-scheme-json-blobs/apikey-auth-post-proxy.md" >}}

   </details>

Below is the example of what proxy config looks like after GET request when OAS has been applied with security scheme

```shell
GET https://{{controller_ip}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/proxies/petstore-proxy?hostname={{environmentHostname}}&version=v1&includes=sensitivedata
```
<details Proxy Request referring to apiauth spec>
   <summary>GET Proxy Request</summary>

{{< include "acm/tutorials/security-scheme-json-blobs/apikey-auth-get-proxy.md" >}}

   </details>

```bash
curl -X GET -H "apiKey:testapikey1234" -H "Content-Type: application/json"  http://54.188.248.124/api/v3/pet/4
{"id":4,"category":{"id":1,"name":"{{$$randomFirstName}}"},"name":"Steve","photoUrls":["http://placeimg.com/640/480/cats"],"tags":[{"id":0,"name":"string"}],"status":"available"}
```

```shell
curl -X GET -H "Content-Type: application/json" http://54.188.248.124/v1/pet
{
    "message": "Unauthorized",
    "status": "401"
}
```

## Basic Authentication Security Scheme
Basic Authentication is a security scheme that is commonly used to authenticate HTTP requests. The request contains a header field in the form of Authorization: Basic <credentials>, where credentials is the Base64 encoding of username and password joined by a single colon.

ACM API owners can restrict access to their APIs with usernames and passwords. This scheme can be configured to grant access to APIs only after verifying that the username and password are valid.

To mitigate any security risks, it is recommended to use Basic Authentication only over encrypted channels such as HTTPS.

Security Scheme Definition

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{< bootstrap-table "table table-striped table-bordered" >}}
| Field                                           | Type | Required      | Valid Value(s)                                                                                                                                                                           | Description | Default |
|-------------------------------------------------|----------|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|
| `type`                  | `string`  | True   | `http` | The type of the security scheme.       | `N/A`  |
| `description`         | `string`   | False | Of type `string` | A short description for security scheme. CommonMark syntax MAY be used for rich text representation.      | `N/A`    |
| `scheme`       | `string`   | True  | `basic` | The name of the HTTP Authorization scheme to be used in the Authorization header as defined in RFC7235. | `N/A` |
| `x-credentialForward`| `bool` | False | one of `[true, false]` | This field defines whether the basic auth credential is going to be proxy forwarded to backend service in the HTTP request Authorization header. | `false` |
| `x-errorReturnConditions.notSupplied.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when `basicAuth` is not supplied. | `401` |
| `x-errorReturnConditions.noMatch.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when invalid `basicAuth` is supplied . | `403` |
| `x-labels.targetPolicyName` | `string` | False | Of type `string` | The required target policy name set in policy `metadata.labels.targetPolicyName`. | `default` |


{{< /bootstrap-table >}}
{{< raw-html>}}</div>{{</raw-html>}}

## Steps to configure Basic security scheme 

Step - 1: Create an apispec with the basic security scheme configured. In the following apispec example check the `component securitySchemes` section `ExampleBasicAuth` is configured.

```shell
POST https://{{controller_ip}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/api-docs
```

<details Basic auth apispec>
   <summary> Basic auth apispec JSON request</summary>

{{< include "acm/tutorials/security-scheme-json-blobs/basic-security-apispec.md" >}}

   </details>


Step - 2: Creating a proxy referencing the OAS scheme above. When a http basic security scheme is provided in an OAS that is referenced in a proxy POST/PUT request if the user wants to set up valid basic auth credentials they need to provide these in the proxy POST/PUT request body.

```shell
POST https://{{controller_ip}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/proxies
```

<details JSON Request with basic auth referencing the oas>
   <summary> JSON Request with basic auth referencing the oas</summary>

{{< include "acm/tutorials/security-scheme-json-blobs/basic-auth-post-proxy.md" >}}

   </details>

Verify the GET request for the proxy, you should see the output with basic auth policy in the proxy config.

```shell
GET https://{{controller_ip}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/proxies/petstore-proxy?hostname={{environmentHostname}}&version=v1&includes=sensitivedata
```

<details GET Proxy details with basic auth referncing the oas with basic auth security scheme>
   <summary> GET Proxy details with basic auth referncing the oas with basic auth security scheme</summary>

{{< include "acm/tutorials/security-scheme-json-blobs/basic-auth-get-proxy.md" >}}

   </details>

Step - 3: Passing traffic to the endpoints. Below is the cURL example of request to proxy with basic auth to the Pet Store server
It would result in a successful operation with the 200 status

```shell

curl -X GET -u user1:secret -H "Content-Type: application/json"  http://54.188.248.124/api/v3/pet/4

{"id":4,"category":{"id":1,"name":"{{$$randomFirstName}}"},"name":"Steve","photoUrls":["http://placeimg.com/640/480/cats"],"tags":[{"id":0,"name":"string"}],"status":"available"}
```
```shell
curl -X GET -H "Content-Type: application/json" http://54.188.248.124/v1/pet

{
    "message": "Unauthorized",
    "status": "401"
}
```





