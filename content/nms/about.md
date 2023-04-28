---
date: "2021-06-08T12:00:00-07:00"
doctypes:
- reference
- troubleshooting
draft: false
title: About
description: Learn about NGINX Management Suite.
toc: true
weight: 50
docs: "DOCS-905"
doctypes: ["concept"]
---

NGINX Management Suite is a family of management plane solutions that enable governance of the NGINX data plane to easily scale, secure, and monitor applications and APIs. It consists of several modules:

## Instance Manager (NIM):

The [NIM module]({{< relref "nim/">}}) allows you to configure, scale, and manage NGINX Open Source and NGINX Plus instances. 

The NIM module was initially developed as a [REST API]({{< relref "/nim/about/api-overview">}}) that uses standard authentication methods, HTTP response codes, and verbs. The NIM REST API allows you to access all of the NIM features, manage NIM objects and the NMS platform programmatically, view metrics, edit configurations, manage certificates, create users, and more. 

The NIM features available through NGINX Management System's web interface are built on top of this REST API.

### Instance Manager Key Features

The NIM module provides the following features:

- [View metrics and information]({{< relref "/nim/how-to/view-events-metrics">}}) about data plane host systems and NGINX instances
- [View, edit, and publish NGINX configurations]({{< relref "/nim/how-to/nginx/publish-configs">}})
- [Save NGINX configurations]({{< relref "/nim/how-to/nginx/publish-configs#stage-config">}}) for future deployment
- [Analyze NGINX configurations]({{< relref "/nim/how-to/nginx/publish-configs">}}) for syntactic errors before publishing them
- [Scan the network]({{< relref "/nim/how-to/nginx/scan-instances#scan-ui">}}) to find unmanaged NGINX instances.
- [Manage certificates]({{< relref "/nim/how-to/nginx/manage-certificates">}})
- [Create users, roles, and role permissions]({{< relref "/admin-guides/access-control/set-up-rbac">}}) for role-based access control

## API Connectivity Manager (ACM): 

The [ACM module]({{< relref "acm/">}}) enables self-service and automation of API delivery. ACM allows you to deploy, configure, secure, monitor, and govern API gateways at scale. 

The ACM module provides a [REST API]({{< relref "/acm/about/api-overview">}}) that uses standard authentication methods, HTTP response codes, and verbs.

You can use the API Connectivity Manager API to connect, secure, and govern your APIs. In addition, ACM lets you separate infrastructure lifecycle management from the API lifecycle, allowing your IT/Ops teams and application developers to work independently.

### API Connectivity Manager Key Features

The ACM module provides the following features:

- [Create and manage isolated workspaces]({{< relref "/acm/how-to/infrastructure/manage-api-infrastructure.md#create-a-workspace">}})
- [Create and manage API infrastructure]({{< relref "/acm/how-to/infrastructure/manage-api-infrastructure.md#add-an-environment">}}) in isolated workspaces
- [Enforce uniform security policies]({{< relref "acm/how-to/policies/tls-policies.md" >}}) across workspaces using global policies
- [Create Developer Portals]({{< relref "acm/how-to/infrastructure/publish-developer-portal.md" >}}) with custom color themes, logos, and favicons
- [Onboard APIs to an API Gateway]({{< relref "acm/how-to/infrastructure/publish-developer-portal.md#add-an-api-doc" >}}) and [publish API documentation]({{< relref "acm/how-to/infrastructure/publish-developer-portal.md#publish-the-api-documentation-and-api-proxy" >}}) to the Developer Portal
- [Apply policies to API proxies]({{< relref "acm/how-to/policies/manage-policies.md#configure-proxy-policies" >}}) to provide custom quality of service for individual applications
- [Issue API keys]({{< relref "/acm/how-to/infrastructure/enable-sso-devportal" >}}) or basic authentication credentials for access to the API

## App Delivery Manager (ADM):

The [ADM]({{< relref "adm/">}}) module is built on top of the NGINX Management Suite (NMS) platform and sits alongside the Instance Manager (NIM) module. As such, uses many of the features that are included with NIM, such as [authentication]({{< relref "admin-guides/access-control/configure-authentication.md" >}}), [Role-Based Access Control (RBAC)]({{< relref "admin-guides/access-control/set-up-rbac.md" >}}), [instance groups]({{< relref "nim/how-to/nginx/manage-instance-groups.md" >}}), and [certificate management]({{< relref "nim/how-to/nginx/manage-certificates.md" >}}).

### App Delivery Manager Key Features

The ADM module provides an abstraction over the NGINX configuration, allowing individual teams to deploy their custom apps independently. ADM hides the complexities of the NGINX configuration through a simple high-level API abstraction of the NGINX contexts and common directives. We refer to this abstraction as the app-centric view of the configuration.

This app-centric view addresses the following concerns:

* **Complexity**: Managing, maintaining, validating, and applying large sets of individual configurations from different sources.
* **Fragility:** Teams can validate and test configurations before placing them into production, making it easier to fail fast and ensuring that production user traffic keeps flowing.
* **Safety:** Various business units can be given fine-grain ownership over configuration elements, when necessary.
* **Self-Service:** By isolating app teams from one another, you can allow each team to independently deploy and update the configuration for their apps without requiring intervention. This removes artificial gates that previously prevented teams from quickly delivering their updated apps and allows for the integration of the CI/CD process into their development workflow.

This is all done behind a simple API abstraction provided by ADM. For teams that need more control of the NGINX configuration or access to the rich set of directives and dynamic modules, the ADM service provides a template facility to expand the API and the resulting possibilities for the NGINX configuration.

## Security Monitoring

The [Security Monitoring module]({{< relref "security/">}}) allows you to monitor NGINX App Protect WAF with analytics dashboards and security log details to get protection insights for analyzing possible threats or areas for tuning policies.

### Security Monitoring Key Features

The Security Monitoring module provides the following features:

- Informative dashboards that provide valuable protection insights
- In-depth security log details to help with analyzing possible threats and making policy decisions

## What's Next?

- [Review the Technical Specifications]({{< relref "/overview/tech-specs">}})
- [Install NGINX Management Suite]({{< relref "installation/on-prem/_index.md">}})
