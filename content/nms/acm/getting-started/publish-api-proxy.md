---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  publish an API Proxy.
docs: DOCS-923
title: Publish an API Proxy
toc: true
weight: 300
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

In API Connectivity Manager, **Services** represent your Backend APIs.
**Proxies** represent the NGINX reverse proxy that routes traffic to your backend service and to the Developer Portal.
This guide provides instructions and examples for publishing an API and a Developer Portal by using the REST API.

### Before You Begin

You should complete the following Quick Start Guides before proceeding with the steps in this guide:

1. [Set Up an API Gateway Environment]({{< relref "./add-api-gateway" >}})
1. [Set Up a Developer Portal Environment]({{< ref "add-devportal" >}})

## Create a service workspace
Services workspaces is a logical grouping of APIs. A user can created multiple workspaces that match an organizational structure.

{{<tabs name="Add a Services Workspace">}}

{{%tab name="UI"%}}

1. Select the **Services** option on the left hand menu.
1. Select the **Create Workspace** button.
1. Enter a name.
1. (Optional) Provide a description of the workspace.
1. (Optional) Select the **Contact Information** check box to provide contact details.
1. Select the **Create** button.


{{%/tab%}}
{{%tab name="API"%}}



{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| POST| `/services/workspaces`|

{{</bootstrap-table>}}


```json
{
    "name": "{{proxyWorkspaceName}}",
    "metadata": {
        "description": "Petstore Team Workspace"
    },
    "contactDetails": {
        "adminEmail": "admin@example.com",
        "adminName": "I.M. Admin",
        "adminPhone": "555 123 1234"
    }
}
```

{{%/tab%}}
{{</tabs>}}





## Publish API Proxy without OpenAPI Spec {#set-up-api-proxy}

An API proxy connects the backend services to the API-Gateway.

{{<tabs name="Publish API Proxy without OpenAPI Spec">}}

{{%tab name="UI"%}}

After creating the workspace, you can select **Publish API Proxy** or open the previously created workspace.

On the Publish API Proxy window:
### Backend Service

1. Type a name for the backend service.
1. Type the **Service Target Hostname**; this can be an IP or FQDN.
1. For the **Service Target Transport Protocol**, if your backend service is using gRPC, then select gRPC.
1. Type the **Service Target Port**, or use the arrow buttons to increase or decrease the port number.

### API Proxy

1. Type a name for the API Proxy.
1. Select No in the **Use an OpenAPI spec** option.
1. Select the **Gateway Proxy Hostname from** the menu.
{{< note >}}If this field is disabled, check the job status of your environment on the infrastructure workspace page.{{<  /note >}}

### Ingress

1. Enter the Base Path that you wish to route traffic to.
1. Type the version of your API.
1. Select **Publish**.

### Confirm Setup

1. Open a terminal application.
1. Run the following command:

    ```curl
    curl -k -X GET "https://gateway-proxy-hostname/version/basepath"
    ```

1. If your proxy is set up correctly, you can send traffic.

{{< note >}}By default the ingress append rule is set to `PREFIX` so your request must be in the form of `version/basepath` {{< /note >}}





{{%/tab%}}
{{%tab name="API"%}}
After creating the service workspace, you can select **Publish API Proxy**, or you can follow these steps:


{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| POST | `/services/workspaces/{{proxyWorkspaceName}}/proxies`|

{{</bootstrap-table>}}




The basic configuration below creates an API Proxy to a backend service.

```json
{
    "name": "{{proxyName}}",
    "metadata": {
        "description": "Swagger Petstore Proxy"
    },
    "version": "v1",
    "proxyConfig": {
        "hostname": "{{environmentHostname}}",
        "ingress": {
            "basePath": "/v1"
        },
        "backends": [
            {
                "serviceName": "petstore-api-svc",
                "serviceTargets": [
                    {
                        "hostname": "petstore.example.com"
                    }
                ]
            }
        ]
    }
}
```

{{%/tab%}}
{{</tabs>}}



## Publish API Proxy with OpenAPI Spec {#publish-api-proxy-with-spec}
{{< include "acm/openapi-support" >}}

### Uploading an OAS Schema
OAS Schemas can be uploaded to API Connectivity Manager and stored for use as references for *Proxy* deployments.
The routes contained in the OAS Schema will be used to create the routes for your *Proxy*

### Creating a Proxy with an OAS
After you have uploaded your OAS Schema as an *API Doc*, you can then reference that *API Doc* in your *Proxy* deployments using the `specRef` parameter in the JSON payload.
Using the `specRef` will then associate that OAS Schema in API Connectivity Manager and allow API Connectivity Manager to create your routes from the information contained in the OAS Schema.

### Extended support for OAS in API Connectivity Manager
API Connectivity Manager now allows you to set up an API gateway using Open API Specification by supporting the creation of *Backends* (upstream servers) from the supplied OAS using an API Connectivity Manager specific *x-* extension in your OAS document.
API Connectivity Manager now also supports server URL templating in the global URL(s).

<details closed>
<summary>Example JSON</summary>

```json
"servers": [
  {
    "url": "https://{server}.example.com/api/{version}",
    "variables": {
      "version": {
        "default": "v1"
      },
      "server": {
        "default": "staging"
      }
    },
    "x-acm-append-rule": "NONE",
    "x-acm-strip-basepath": false,
    "x-acm-backends": [
      {
        "serviceName": "pets-backend",
        "serviceVersion": "pets-backend-v1",
        "serviceLabel": "default",
        "contextRoot": "/dev",
        "upstreams": [
          {
            "url": "https://gecho1.null.ie",
            "maxFails": 10,
            "maxConnections": 5,
            "failTimeout": "5s",
            "slowStart": "10s"
          },
          {
            "url": "https://gecho2.null.ie",
            "maxFails": 5,
            "maxConnections": 8,
            "failTimeout": "15s",
            "slowStart": "3s"
          },
          {
            "url": "https://gecho3.null.ie",
            "maxFails": 7,
            "maxConnections": 33,
            "failTimeout": "35s",
            "slowStart": "1s"
          }
        ]
      }
    ]
  }
],
```

</details>

&nbsp;


### Server URL Templating

```json
"servers": [
  {
    "url": "https://{server}.example.com/api/{version}",
    "variables": {
      "version": {
        "default": "v1"
      },
      "server": {
        "default": "staging"
      }
    },
```

In the above section, we can see how server URL templating will make substitutions with a matching value from the variables section of the server object in the specification.
Each placeholder in the URL *must* have a matching variable in the variables section or the validation will fail and return an error.

### Creating Backends
This section explains how to create a backend target for our API Gateway configuration, a Backend is a collection of upstream servers bundled under one "Service label".
An API Gateway can have multiple *Backends* which can each contain multiple upstream servers.

```json
"x-acm-backends": [
      {
        "serviceName": "pets-backend",
        "serviceVersion": "pets-backend-v1",
        "serviceLabel": "default",
        "contextRoot": "/dev",
        "upstreams": [
          {
            "url": "https://server.example.com",
            "maxFails": 10,
            "maxConnections": 5,
            "failTimeout": "5s",
            "slowStart": "10s"
          },
```

In the above example, we can see how to create a single *Backend* with a single upstream server.

{{<bootstrap-table "table">}}

| Variable       | Purpose                                                                                                                                                                                                                                   | Required | Default | Context  |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|----------|
| serviceName    | provides a human-readable identifier to the Backend                                                                                                                                                                                       | true     | none    | Backend  |
| serviceVersion | provides some version metadata should it be required                                                                                                                                                                                      | false    | none    | Backend  |
| serviceLabel   | provides a means to target this backend from this and other API Gateway deployments                                                                                                                                                       | true     | default | Backend  |
| contextRoot    | sets the service root path for the upstream servers, i.e. /dev would mean that all requests proxied to /api/v1 would be proxied to /dev/api/v1 on the upstream servers.                                                                   | false    | /       | Backend  |
| upstreams      | array of upstream servers, requires at least one server to be provided.                                                                                                                                                                   | true     | none    | Backend  |
| url            | the URL of the upstream server, a port should be provided if using non-standard scheme -> port mappings, i.e. http:80, https:443                                                                                                          | true     | none    | Upstream |
| maxFails       | sets the number of unsuccessful attempts to communicate with the server that should happen in the duration set by the `fail_timeout` parameter to consider the server unavailable for a duration also set by the `fail_timeout` parameter | false    | 0       | Upstream |
| maxConnections | limits the maximum `_number_` of simultaneous active connections to the proxied server                                                                                                                                                    | false    | 0       | Upstream |
| failTimeout    | sets the time during which the specified number of unsuccessful attempts to communicate with the server should happen to consider the server unavailable and the period of time the server will be considered unavailable.                | false    | 10s     | Upstream |
| slowStart      | sets the `_time during which the server will recover its weight from zero to a nominal value, when an unhealthy server becomes healthy, or when the server becomes available after being unavailable.           | false    | none    | Upstream |

{{</bootstrap-table>}}

All values supplied in the OAS Specification are only modifiable through the OAS Specification and not through the API or UI, this means that the OAS Specification is the source of truth for all values supplied within it.
If values are omitted from the OAS Schema then they may be added or modified via the API or UI.

### Proxy Basepath
It is possible to modify the basepath provided using two additional extensions:
`x-acm-append-rule` and `x-acm-strip-basepath`.

`x-acm-append-rule` is a legacy configuration option that was used to either prepend or append the version field from the `info` section to your API basepath, going forward the basepath should be added explicitly to the global server URL section in exactly the manner in which it is to be used, for example: <https://myserver.host.com/api/v1>

`x-acm-append-rule` defaults to `NONE` and the version field in the `info` section is only used as the document version metadata in favor of explicitly adding the version to the server URL. `x-acm-append-rule` should ONLY be used for legacy deployments that used a value other than `NONE`

`x-acm-strip-basepath` is a boolean value that denotes whether to strip the basepath from the request URI before proxying the request to the backend servers.

{{<bootstrap-table "table">}}

| Incoming URI          | basePath | stripBasepath | Context Root | Proxied URI            |
|-----------------------|----------|---------------|--------------|------------------------|
| /api/v1/customers     | /api/v1  | false         | /            | /api/v1/customers      |
| /api/v1/customers     | /api/v1  | true          | /            | /customers             |
| /api/v1/customers/123 | /api/v1  | true          | /            | /customers/123         |
| /api/v1/customers     | /api/v1  | false         | /prod        | /prod/api/v1/customers |
| /api/v1/customers     | /api/v1  | true          | /prod        | /prod/customers        |

{{</bootstrap-table>}}

- When you upload an OpenAPI spec, API Connectivity Manager automatically generates a name for the API Docs object using the following format:

`"info.title"-"info.version"`

- The string is "URL-ized", meaning any whitespace gets converted to dashes (`-`) and all letters are lowercase.
If we used the OpenAPI example [Petstore API](https://github.com/OAI/OpenAPI-Specification/blob/main/tests/v3.0/pass/petstore.yaml), the auto-generated name for the API Docs would be `petstore-v1`.

{{<tabs name="Publish API Proxy with OpenAPI Spec">}}

{{%tab name="UI"%}}

1. Enter a name for the backend service.
1. Type the **Service Target Hostname**; this can be an IP or FQDN.
1. In the **Service Target Transport Protocol** menu, select gRPC if your backend service uses gRPC.
1. Enter the *Service Target Port*, or use the arrow buttons to increase or decrease the port number.

### API Proxy

1. Enter a name for the API Proxy.
1. Select Yes in the **Use an OpenAPI spec** option.
1. Select the **Add API Spec** button.
1. Select the **Browse** button and select a YAML or JSON file.
1. After the file uploads you can either select or search for your API spec.
1. Select **Publish**.

### Ingress
Populated from API Specification and are read-only

### Confirm Setup

1. Open a terminal application.

1. Run the following command:

    ```curl
    curl -k -X GET "https://gateway-proxy-hostname/version/basepath"
    ```

{{< note >}} By default the ingress append rule is set to `NONE` when using an OAS Schema so your request must match the `basepath` you have supplied as part of your Global Server URL. {{< /note >}}

{{%/tab%}}
{{%tab name="API"%}}


{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| POST | `/services/workspaces/{{proxyWorkspaceName}}/api-docs`|
| POST | `/services/workspaces/{{proxyWorkspaceName}}/proxies`|

{{</bootstrap-table>}}


Take the steps below to add an API Proxy with an OpenAPI spec using either version 3.0.x or 3.1.

1. Send a POST request containing the OpenAPI spec for your API to the `api-docs` endpoint to upload it.

    ```json
    {
    "info": {
        "version": "1.0.0",
        "title": "Swagger Petstore",
        "license:" {
            "name": "MIT"
        }
    },
    "openapi": "3.0.0",
    "paths": {...}
    }
    ```

1. Send a POST request to the `proxies` endpoint to create a new API Proxy. In this example, `specRef` contains the name that API Connectivity Manager assigned to the API Docs object: `petstore-1`.

    ```json
    {
        "name": "{{proxyName}}",
        "metadata": {
            "description": "Swagger Petstore API"
        },
        "version": "v1",
        "specRef": "petstore-1",
        "proxyConfig": {
            "hostname": "{{environmentHostname}}",
            "ingress": {
                "basePath": "/v1"
            },
            "backends": [
                {
                    "serviceName": "petstore-api-svc",
                    "serviceTargets": [
                        {
                            "hostname": "petstore.example.com"
                        }
                    ]
                }
            ]
        }
    }
    ```

{{%/tab%}}
{{</tabs>}}

## Publish an API Doc to Developer Portal
Next, you can publish API Docs to your Developer Portal.

API Connectivity Manager uses the `portalConfig.hostname` setting to connect your Dev Portal Proxy to the Developer Portal.
You should define this field using the hostname that you assigned to the Developer Portal in the [Set Up a Developer Portal]({{< ref "add-devportal" >}}) guide.

{{<tabs name="Add a Developer Portal Proxy">}}


{{%tab name="UI"%}}

Refer to [Publish API Proxy with OpenAPI Spec](#publish-api-proxy-with-spec).

1. Select the **Also publish API to developer portal** option
1. Select the **Portal Proxy Hostname**.
1. (Optional) Enter a category if required.
1. Select **Publish**

Open the Developer Portal and you should see the API doc is now displayed on the page.

{{%/tab%}}
{{%tab name="API"%}}


{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| PUT | `/services/workspaces/{{proxyWorkspaceName}}/proxies/{{proxyName}}`|

{{</bootstrap-table>}}



The example below adds the Developer Portal to the same API Proxy that you created in the [previous section](#set-up-api-proxy).

```json
{
    "name": "{{proxyName}}",
    "specRef": "petstore-1",
    "version": "v1",
    "proxyConfig": {
        "hostname": "{{environmentHostname}}",
        "ingress": {
            "basePath": "/v1"
        },
        "backends": [
            {
                "serviceName": "petstore-api-svc",
                "serviceTargets": [
                    {
                        "hostname": "petstore.example.com"
                    }
                ]
            }
        ]
    },
    "portalConfig": {
        "hostname": "{{portalClusterHostname}}"
    }
}
```

{{%/tab%}}
{{</tabs>}}
