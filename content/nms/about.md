---
title: About
description: F5 NGINX Management Suite brings together advanced features into a single
  platform, making it easy for organizations to configure, monitor, and troubleshoot
  NGINX instances; manage and govern APIs; optimize load balancing for apps; and enhance
  overall security.
weight: 10
toc: true
type: concept
docs: DOCS-905
---

Explore the topics below to find out what the F5 NGINX Management Suite modules have to offer.

---

## Instance Manager {#instance-manager}

[NGINX Instance Manager]({{< relref "/nim/">}}) allows you to configure, scale, and manage NGINX Open Source and NGINX Plus instances at scale. Instance Manager provides a [REST API]({{< relref "/nim/fundamentals/api-overview">}}) and web-based graphical user interface (GUI) for managing NGINX instances across multiple servers, making it easier to configure, monitor, and troubleshoot NGINX deployments.

Instance Manager can be used to manage instances running on-premises, in the cloud, or in hybrid environments, and it supports the deployment of NGINX instances on a variety of operating systems and container platforms.

Instance Manager also includes advanced features like health checks, rolling updates, and configuration backups, which help to ensure the reliability and security of NGINX deployments.

### Instance Manager Key Features

Instance Manager provides the following features:

- [View metrics and information]({{< relref "/nim/monitoring/view-events-metrics">}}) about data plane host systems and NGINX instances
- [View, edit, and publish NGINX configurations]({{< relref "/nim/nginx-configs/publish-configs">}})
- [Save NGINX configurations]({{< relref "/nim/nginx-configs/publish-configs#stage-config">}}) for future deployment
- [Analyze NGINX configurations]({{< relref "/nim/nginx-configs/publish-configs">}}) for syntactic errors before publishing them
- [Scan the network]({{< relref "/nim/nginx-instances/scan-instances#scan-ui">}}) to find unmanaged NGINX instances.
- [Manage certificates]({{< relref "/nim/nginx-instances/manage-certificates">}})
- [Create users, roles, and role permissions]({{< relref "/nim/admin-guide/rbac/overview-rbac">}}) for role-based access control

---

## Security Monitoring {#security-monitoring}

Security Monitoring allows you to monitor NGINX App Protect WAF with analytics dashboards and security log details to get protection insights for analyzing possible threats or areas for tuning policies.

### Security Monitoring Key Features

The Security Monitoring module provides the following features:

- Informative dashboards that provide valuable protection insights
- In-depth security log details to help with analyzing possible threats and making policy decisions

---

## What's Next?

- [Review the Technical Specifications]({{< relref "/nim/fundamentals/tech-specs.md">}})
- [Install NGINX Management Suite]({{< relref "/nim/deploy/_index.md">}})
