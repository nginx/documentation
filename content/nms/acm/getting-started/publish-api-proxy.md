---
title: "Publish an API Gateway and Developer Portal"
date: 2022-07-15T10:23:41-06:00
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to use NGINX Management Suite API Connectivity Manager to publish an API Proxy with a Developer Portal."
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

## Add a Services Workspace

First, create a Services Workspace. This is a team space where you can manage the API's lifecycle.

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

## Set Up an API Proxy {#set-up-api-proxy}

Next, add an API Proxy.  

The API Proxy connects your backend API service to the API Gateway using the `proxyConfig.hostname` setting. 
You should define this field using the hostname that you assigned to the API Gateway in the [Set Up an API Gateway]({{< relref "add-api-gateway" >}}) guide.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method      | Endpoint |
|-------------|----------|
| POST | `/services/workspaces/{{proxyWorkspaceName}}/proxies`| 
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

### API Proxy without OpenAPI Spec

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

### API Proxy with OpenAPI Spec

{{< include "acm/openapi-support" >}}

When you upload an OpenAPI spec, API Connectivity Manager automatically generates a name for the API Docs object using the following format:
    
`"info.title"-"info.version"`

The string is "URL-ized", meaning any whitespace gets converted to dashes (`-`) and all letters are lowercase.
If we used the OpenAPI example [Petstore API](https://github.com/OAI/OpenAPI-Specification/blob/main/examples/v3.0/petstore.yaml), the auto-generated name for the API Docs would be `petstore-v1`.

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

## Add a Dev Portal Proxy

Next, you can add a Dev Portal Proxy to publish your API and documentation to the Developer Portal.  

API Connectivity Manager uses the `portalConfig.hostname` setting to connect your Dev Portal Proxy to the Developer Portal. 
You should define this field using the hostname that you assigned to the Developer Portal in the [Set Up a Developer Portal]({{< relref "add-devportal" >}}) guide.

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

## What's Next

Congratulations! You have reached the end of the Quick Start series.
We recommend taking a deeper dive into the following topics:

- [Manage TLS Policies]({{< relref "/nms/acm/how-to/policies/tls-policies.md" >}}): Learn how to apply global policies to secure traffic to your Developer Portal; between your API Proxies and backend services; and between the management plane and Developer Portal hosts.
- [Customize Developer Portals]({{< relref "/nms/acm/how-to/infrastructure/customize-devportal.md" >}}): Learn how to customize Developer Portals using the API Connectivity Manager user interface.
- [Policies Overview]({{< relref "/nms/acm/about/policies-overview" >}}): Learn more about the policies you can use to enforce global security or customize your backend services.
