---
title: "Publish an API Proxy"
date: 2022-07-15T10:23:41-06:00
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to use NGINX Management Suite API Connectivity Manager to publish an API Proxy."
# Assign weights in increments of 100
weight: 300
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-923"

---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

In API Connectivity Manager, **Services** represent your Backend APIs. 
**Proxies** represent the NGINX reverse proxy that routes traffic to your backend service and to the Developer Portal.
This guide provides instructions and examples for publishing an API and a Developer Portal by using the REST API. 

### Before You Begin

You should complete the following Quick Start Guides before proceeding with the steps in this guide:

1. [Set Up an API Gateway Environment]({{< relref "add-api-gateway" >}}) 
1. [Set Up a Developer Portal Environment]({{< relref "add-devportal" >}})

## Create a service workspace
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

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}

{{<bootstrap-table "table">}}
| Method      | Endpoint |
|-------------|----------|
| POST| `/services/workspaces`| 
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

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


{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}

[comment]: <> (-------------------------Temp divider-----------------------------------)

## Publish API Proxy without OpenAPI Spec {#set-up-api-proxy}
{{<tabs name="Publish API Proxy without OpenAPI Spec">}}

{{%tab name="UI"%}}

After creating the workspace, you have the option to select the Publish API Proxy button or open the previously created workspace.
and click the Publish to Proxy button.

On the Publish API Proxy window:
##### **Backend Service**
1. Type a name for the backend service.
1. Type the **Service Target Hostname**; this can be an IP or FQDN.
1. For the **Service Target Transport Protocol**, if your backend service is using gRPC, then select gRPC.
1.  Type the **Service Target Port**, or use the arrow buttons to increase or decrease the port number.

##### **API Proxy**
1. Type a name for the API Proxy.
1. Select No in the **Use an OpenAPI spec** option.
1. Select the **Gateway Proxy Hostname from** the menu.
{{< note >}}If this field is disabled, check the job status of your environment on the infrastructure workspace page.{{<  /note >}}

##### **Ingress**
1. Enter the Base Path that you wish to route traffic to.
1. Type the version of your API.
1. Select the **Publish** button.

##### **Confirm Setup**
1. Open a terminal application.
1. Run the following command:
    ```curl
    curl -k -X GET "https://gateway-proxy-hostname/version/basepath"
    ```
    _Note:_ By default the ingress append rule is set to `PREFIX` so your request must be in the form of
`version/basepath`
    
1. If your proxy is set up correctly, you can send traffic.




{{%/tab%}}
{{%tab name="API"%}}
After creating the service workspace, you can select **Publish API Proxy**, or you can follow these steps:

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method      | Endpoint |
|-------------|----------|
| POST | `/services/workspaces/{{proxyWorkspaceName}}/proxies`| 
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}



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

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}

## Publish API Proxy with OpenAPI Spec {#publish-api-proxy-with-spec}
{{< include "acm/openapi-support" >}}

- When you upload an OpenAPI spec, API Connectivity Manager automatically generates a name for the API Docs object using the following format:
    
`"info.title"-"info.version"`

- The string is "URL-ized", meaning any whitespace gets converted to dashes (`-`) and all letters are lowercase.
If we used the OpenAPI example [Petstore API](https://github.com/OAI/OpenAPI-Specification/blob/main/examples/v3.0/petstore.yaml), the auto-generated name for the API Docs would be `petstore-v1`.

{{<tabs name="Publish API Proxy with OpenAPI Spec">}}

{{%tab name="UI"%}}

1. Enter a name for the backend service.
1. Type the **Service Target Hostname**; this can be an IP or FQDN.
1. In the **Service Target Transport Protocol** menu, select gRPC if your backend service uses gRPC.
1. Enter the *Service Target Port*, or use the arrow buttons to increase or decrease the port number.

##### **API Proxy**
1. Enter a name for the API Proxy.
1. Select Yes in the **Use an OpenAPI spec** option.
1. Select the **Add API Spec** button.
1. Select the **Browse** button and select a YAML or JSON file.
1. After the file uploads you can either select or search for your API spec.
1. Select the **Publish** button

##### **Ingress**
Populated from API Specification and are read-only

##### **Confirm Setup**
1. Open a terminal application
2.  Execute the following command
    ```curl
    curl -k -X GET "https://gateway-proxy-hostname/version/basepath"
    ```
    _Note:_ By default the ingress append rule is set to `PREFIX` so your request must be in the form of
`version/basepath`

{{%/tab%}}
{{%tab name="API"%}}

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method      | Endpoint |
|-------------|----------|
| POST | `/services/workspaces/{{proxyWorkspaceName}}/api-docs`| 
| POST | `/services/workspaces/{{proxyWorkspaceName}}/proxies`| 
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

Take the steps below to add an API Proxy with an OpenAPI spec.

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
You should define this field using the hostname that you assigned to the Developer Portal in the [Set Up a Developer Portal]({{< relref "add-devportal" >}}) guide.

{{<tabs name="Add a Developer Portal Proxy">}}


{{%tab name="UI"%}}

Refer to [Publish API Proxy with OpenAPI Spec](#publish-api-proxy-with-spec).
1. Select the Also publish API to developer portal option
2. Select the Portal Proxy Hostname
2. Enter a category if required, but this is optional
3. Click the publish button

Open the Developer Portal and you should see the API doc is now displayed on the page.

{{%/tab%}}
{{%tab name="API"%}}

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method      | Endpoint |
|-------------|----------|
| PUT | `/services/workspaces/{{proxyWorkspaceName}}/proxies/{{proxyName}}`| 
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}


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