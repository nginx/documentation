---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  secure API Gateways by applying a basic authentication policy.
nd-docs: DOCS-1118
toc: true
weight: 450
title: Basic Authentication
type:
- concept
---

## Overview

{{< include "acm/how-to/policies-proxy-intro" >}}

---

## Basic Authentication

{{< call-out "warning" >}} Basic authentication is recommended for test environments only. For production environments, consider a more robust authentication method. {{< /call-out >}}

Authentication & authorization policies allow a user to restrict access to their APIs by determining the caller's identity and access level. There are several API Gateway authentication/authorization policy types supported by API Connectivity Manager: API key authentication, basic authentication, OAuth2 JWT assertion, and OAuth2 token introspection. This guide focuses specifically on basic authentication.

Basic authentication is a method for HTTP users to provide a username and password when making an API request. In basic HTTP authentication, a request contains a header field in the form of `Authorization: Basic <credentials>`, where credentials is the Base64 encoding of username and password joined by a single colon.

API Connectivity Manager API owners can restrict access to their APIs with usernames and passwords. The API Proxy Policy can be configured to grant access to APIs only after verifying that the username and password are valid.

---

## Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with an [API Gateway]({{< ref "/nms/acm/getting-started/add-api-gateway" >}}).
- You have published one or more [API Gateways]({{< ref "/nms/acm/getting-started/publish-api-proxy" >}})

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

### How to Access the REST API

{{< include "acm/how-to/access-acm-api" >}}

---

## Create a Basic Authentication Policy

Take the steps in this section if you want to restrict access to APIs to clients with a valid username and password. You can set up a basic authentication policy using either the web interface or the REST API.

{{<tabs name="add_basic_auth_policy">}}
{{%tab name="API"%}}

Send a `POST` request to add the basic authentication policy to the API Proxy.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


{{< call-out "note" >}} To include sensitive data in Proxy `GET` requests, provide the query parameter `includes=sensitivedata`; otherwise, the response will have this data redacted. {{< /call-out >}}

```json
{
	"policies": {
		"basic-authn": [
			{
				"action": {
					"credentialForward": false,
					"errorReturnConditions": {
						"notSupplied": {
							"returnCode": 401
						}
					}
				},
				"data": [
					{
						"clientID": "ClientA",
						"username": "UserA",
						"password": "secret123"
					}
				]
			}
		]
	}
}
```


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                                                      | Type | Possible Values      | Description                                                                                          | Required | Default value |
|------------------------------------------------------------|----------|----------------------|------------------------------------------------------------------------------------------------------|----------|---------------|
| `credentialForward`                                        | boolean  | `true/false`         | If the basic auth credentials are proxy-forwarded to the backend service in the HTTP header.         | No       | `False`       |
| `errorReturnConditions`<br>`.notSupplied`<br>`.returnCode` | int      | In range `400-599`   | The error code that is returned from the API Proxy when invalid basic auth credentials are supplied. | No       | `401`         |
| `data.clientID`                                            | string   | Example: `ClientA`   | Identifies the client who is holding the basic authentication credentials.                           | Yes      | N/A           |
| `data.username`                                            | string   | Example: `UserA`     | The value of the client's password.                                                                  | Yes      | N/A           |
| `data.password`                                            | string   | Example: `secret123` | The value of the client's username.                                                                  | Yes      | N/A           |

{{< /bootstrap-table >}}


{{%/tab%}}
{{%tab name="UI"%}}

1. In the API Connectivity Manager user interface, go to **Services > \{your workspace}**, where "your workspace" is the workspace that contains the API Proxy.
2. Select **Edit Proxy** from the **Actions** menu for the desired API Proxy.
3. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **Basic Authentication**.
4. By default, NGINX will strip the basic authentication credentials from the request headers before forwarding the request to the backend service. To preserve the credentials, enable the toggle for **Forward credential**.
5. Set custom error return code conditions if basic authentication credentials are **not supplied**.
6. Configure the associated **Client ID**, **Username**, and **Password** for each client that requires API access.
7. Select **Add** to apply the basic authentication policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}
{{</tabs>}}
