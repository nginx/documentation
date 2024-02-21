---
title: "Introduction"
weight: 100
docs: "DOCS-1385"
---

[API Connectivity Manager]({{< relref "/nms/acm/">}}) enables self-service and automation of API delivery. API Connectivity Manager allows you to deploy, configure, secure, monitor, and govern API gateways at scale. 

The API Connectivity Manager module provides a [REST API]({{< relref "/nms/acm/about/api-overview">}}) that uses standard authentication methods, HTTP response codes, and verbs.

You can use the API Connectivity Manager API to connect, secure, and govern your APIs. In addition, API Connectivity Manager lets you separate infrastructure lifecycle management from the API lifecycle, allowing your IT/Ops teams and application developers to work independently.

## API Connectivity Manager Key Features

The API Connectivity Manager module provides the following features:

- [Create and manage isolated workspaces]({{< relref "/nms/acm/how-to/infrastructure/manage-api-infrastructure.md#create-a-workspace">}})
- [Create and manage API infrastructure]({{< relref "/nms/acm/how-to/infrastructure/manage-api-infrastructure.md#add-an-environment">}}) in isolated workspaces
- [Enforce uniform security policies]({{< relref "/nms/acm/how-to/policies/tls-policies.md" >}}) across workspaces using global policies
- [Create Developer Portals]({{< relref "/nms/acm/how-to/infrastructure/publish-developer-portal.md" >}}) with custom color themes, logos, and favicons
- [Onboard APIs to an API Gateway]({{< relref "/nms/acm/how-to/infrastructure/publish-developer-portal.md#add-an-api-doc" >}}) and [publish API documentation]({{< relref "/nms/acm/how-to/infrastructure/publish-developer-portal.md#publish-the-api-documentation-and-api-proxy" >}}) to the Developer Portal
- [Apply policies to API proxies]({{< relref "/nms/acm/how-to/policies/manage-policies.md#configure-proxy-policies" >}}) to provide custom quality of service for individual applications
- [Issue API keys]({{< relref "/nms/acm/how-to/infrastructure/enable-sso-devportal" >}}) or basic authentication credentials for access to the API

## Supported NGINX Versions

API Connectivity Manager supports the following NGINX versions:

{{<bootstrap-table "table table-striped table-bordered">}}
| Module                                      | Version                        | NGINX OSS                  | NGINX Plus         |
|---------------------------------------------|--------------------------------|----------------------------|--------------------|
| API Connectivity Manager - Management Plane | 1.9.0 and later<hr>1.4.0-1.8.0<hr>1.0.0–1.3.1 | 1.18–1.25.1<hr>1.18–1.25.1<hr>1.18–1.21.6 | R24–R30<hr>R24–R29<hr>R24–R27 |
| API Connectivity Manager - Data Plane and Dev Portal | 1.9.0 and later<hr>1.7.0-1.8.0<hr>1.4.0-1.6.0<hr>1.0.0–1.3.1 | <i class="fa-solid fa-ban" style="color: red"></i> Not supported<hr><i class="fa-solid fa-ban" style="color: red"></i> Not supported<hr><i class="fa-solid fa-ban" style="color: red"></i> Not supported<hr><i class="fa-solid fa-ban" style="color: red"></i> Not supported | R26–R30<hr>R26–R29<hr>R24–R28<hr>R21–R27 | 4.0.0 | 
{{</bootstrap-table>}}