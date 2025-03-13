---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  secure API Gateways by applying an API key authentication policy.
docs: DOCS-1117
toc: true
weight: 400
title: API Key Authentication
type:
- concept
---

## Overview

{{< include "acm/how-to/policies-proxy-intro" >}}

---

## API Key Authentication

{{< warning >}} API key authentication is recommended for test environments only. For production environments, consider a more robust authentication method. {{< /warning >}}

Authentication & authorization policies allow a user to restrict access to their APIs by determining the caller's identity and access level. There are several API Gateway authentication/authorization policy types supported by API Connectivity Manager: API key authentication, basic authentication, OAuth2 JWT assertion, and OAuth2 token introspection. This guide focuses specifically on API key authentication.

An API key is usually a long, pseudo-random string included in the request header or request URL. It is a shared secret between the API client and the API gateway. The server allows the client to access data only after the client authenticates the API key.

API Connectivity Manager API owners can restrict access to their APIs with API keys. The API Proxy Policy can be configured to grant access to APIs only after verifying that the API Key is valid.

---

## Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with an [API Gateway]({{< relref "/nms/acm/getting-started/add-api-gateway" >}}).
- You have published one or more [API Gateways]({{< relref "/nms/acm/getting-started/publish-api-proxy" >}})

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

### How to Access the REST API

{{< include "acm/how-to/access-acm-api" >}}

---

## Create an API Key Authentication Policy

Take the steps in this section if you want to restrict access to APIs to clients with a valid API key. You can set up an API key authentication policy using either the web interface or the REST API.

{{<tabs name="add_api_key_policy">}}
{{%tab name="API"%}}

Send a POST request to add the API key authentication policy to the API Proxy.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


{{< note >}} To include sensitive data in Proxy `GET` requests, provide the query parameter `includes=sensitivedata`; otherwise, the response will have this data redacted. {{< /note >}}

```json
{
	"policies": {
		"apikey-authn": [
			{
				"action": {
					"apiKeyName": "apikey",
					"suppliedIn": "header",
					"credentialForward": false,
					"errorReturnConditions": {
						"notSupplied": {
							"returnCode": 401
						},
						"noMatch": {
							"returnCode": 403
						}
					}
				},
				"data": [
					{
						"clientID": "clientA",
						"apiKey": "<api key>"
					},
					{
						"clientID": "clientB"
					}
				]
			}
		]
	}
}
```


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                                                      | Type | Possible Values            | Description                                                                                                           | Required | Default value |
|------------------------------------------------------------|----------|----------------------------|-----------------------------------------------------------------------------------------------------------------------|----------|---------------|
| `apiKeyName`                                               | string   | Example: `clientAPIKey`    | The name of the header or query parameter where the API key will be located in the API request.                       | No       | `apikey`      |
| `suppliedIn`                                               | string   | One of `["HEADER","QUERY"]`| How the API key will be supplied by the consumer of the API via HTTP request.                                         | No       | `HEADER`      |
| `credentialForward`                                        | boolean  | `true/false`               | If the API key credential is proxy-forwarded to the backend service in the HTTP header or query parameters.           | No       | `False`       |
| `errorReturnConditions`<br>`.notSupplied`<br>`.returnCode` | int      | In range `400-599`         | The error code that is returned from the API Proxy when an invalid API key is supplied.                               | No       | `401`         |
| `errorReturnConditions`<br>`.noMatch`<br>`.returnCode`     | int      | In range `400-599`         | The error code that is returned from the API Proxy when an API key is not supplied.                                   | No       | `403`         |
| `data.clientID`                                            | string   | Example: `ClientA`         | Identifies the client who is holding the API Key.                                                                     | Yes      | N/A           |
| `data.apiKey`                                              | string   | Example: `<api key>` | The value of the API Key used to access the API. If an API Key is not provided, a random 32-byte key will be created. | No       | N/A           |

{{< /bootstrap-table >}}


{{%/tab%}}
{{%tab name="UI"%}}

1. In the API Connectivity Manager user interface, go to **Services > \{your workspace}**, where "your workspace" is the workspace that contains the API Proxy.
2. Select **Edit Proxy** from the **Actions** menu for the desired API Proxy.
3. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **API Key Authentication**.
4. Provide the **API Key name** if different from the default value `apikey` and if the key should be provided in the request **Header** or as a **Query** parameter.
5. Set custom error return code conditions if an API Key is **not supplied** or **does not match** a key configured for API access.
6. By default, NGINX will strip the API key from the request headers before forwarding the request to the backend service. To preserve the API key header, enable the toggle for **Forward credentials to backend service**.
7. Configure the associated **Client ID** and **API Key** for each client that requires API access. If an **API Key** is not provided, a random 32-byte key will be created. Repeat this process for all clients.
8. Select **Add** to apply the API key authentication policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}
{{</tabs>}}
