---
title: Introduction
weight: 100
---

[App Delivery Manager]({{< relref "/nms/adm/">}}) is built on top of the NGINX Management Suite platform and sits alongside the Instance Manager module. As such, uses many of the features that are included with the Instance Manager module, such as [authentication]({{< relref "/nms/admin-guides/authentication/basic-authentication.md" >}}), [Role-Based Access Control (RBAC)]({{< relref "/nms/admin-guides/rbac/rbac-getting-started.md" >}}), [instance groups]({{< relref "/nms/nim/how-to/nginx/manage-instance-groups.md" >}}), and [certificate management]({{< relref "/nms/nim/how-to/nginx/manage-certificates.md" >}}).

## App Delivery Manager Key Features

The App Delivery Manager module provides an abstraction over the NGINX configuration, allowing individual teams to deploy their custom apps independently. App Delivery Manager hides the complexities of the NGINX configuration through a simple high-level API abstraction of the NGINX contexts and common directives. We refer to this abstraction as the app-centric view of the configuration.

This app-centric view addresses the following concerns:

* **Complexity**: Managing, maintaining, validating, and applying large sets of individual configurations from different sources.
* **Fragility:** Teams can validate and test configurations before placing them into production, making it easier to fail fast and ensuring that production user traffic keeps flowing.
* **Safety:** Various business units can be given fine-grain ownership over configuration elements, when necessary.
* **Self-Service:** By isolating app teams from one another, you can allow each team to independently deploy and update the configuration for their apps without requiring intervention. This removes artificial gates that previously prevented teams from quickly delivering their updated apps and allows for the integration of the CI/CD process into their development workflow.

This is all done behind a simple API abstraction provided by App Delivery Manager. For teams that need more control of the NGINX configuration or access to the rich set of directives and dynamic modules, the App Delivery Manager service provides a template facility to expand the API and the resulting possibilities for the NGINX configuration.