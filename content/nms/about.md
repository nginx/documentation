---
description: NGINX Management Suite brings together advanced features into a single
  platform, making it easy for organizations to configure, monitor, and troubleshoot
  NGINX instances; manage and govern APIs; optimize load balancing for apps; and enhance
  overall security.
docs: DOCS-905
doctypes:
- concept
title: About
toc: true
weight: 10
---

Explore the topics below to find out what the NGINX Management Suite modules have to offer.

---

## Instance Manager {#instance-manager}

[Instance Manager]({{< relref "/nms/nim/">}}) allows you to configure, scale, and manage NGINX Open Source and NGINX Plus instances.

The Instance Manager module was initially developed as a [REST API]({{< relref "/nms/nim/about/api-overview">}}) that uses standard authentication methods, HTTP response codes, and verbs. The Instance Manager REST API allows you to access all of the module's features, manage Instance Manager objects and the NGINX Management Suite platform programmatically, view metrics, edit configurations, manage certificates, create users, and more.

The Instance Manager features available through NGINX Management Suite's web interface are built on top of this REST API.

### Instance Manager Key Features

Instance Manager provides the following features:

- [View metrics and information]({{< relref "/nms/nim/how-to/view-events-metrics">}}) about data plane host systems and NGINX instances
- [View, edit, and publish NGINX configurations]({{< relref "/nms/nim/how-to/nginx/publish-configs">}})
- [Save NGINX configurations]({{< relref "/nms/nim/how-to/nginx/publish-configs#stage-config">}}) for future deployment
- [Analyze NGINX configurations]({{< relref "/nms/nim/how-to/nginx/publish-configs">}}) for syntactic errors before publishing them
- [Scan the network]({{< relref "/nms/nim/how-to/nginx/scan-instances#scan-ui">}}) to find unmanaged NGINX instances.
- [Manage certificates]({{< relref "/nms/nim/how-to/nginx/manage-certificates">}})
- [Create users, roles, and role permissions]({{< relref "/nms/admin-guides/rbac/rbac-getting-started">}}) for role-based access control

---

## Security Monitoring {#security-monitoring}

[Security Monitoring]({{< relref "/nms/security/">}}) allows you to monitor NGINX App Protect WAF with analytics dashboards and security log details to get protection insights for analyzing possible threats or areas for tuning policies.

### Security Monitoring Key Features

The Security Monitoring module provides the following features:

- Informative dashboards that provide valuable protection insights
- In-depth security log details to help with analyzing possible threats and making policy decisions

---

## What's Next?

- [Review the Technical Specifications]({{< relref "/nms/tech-specs.md">}})
- [Install NGINX Management Suite]({{< relref "/nms/installation/vm-bare-metal/_index.md">}})
