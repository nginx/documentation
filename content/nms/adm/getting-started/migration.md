---
title: Migration From NGINX Controller ADC 3.x
description: Learn how to migrate from Application Delivery Controller 3.x to the NGINX Management Suite App Delivery Manager module.
weight: 200
draft: true
toc: false
tags: ["docs"]
docs: "DOCS-1151"
---


To provide more control over the NGINX configuration and allow the full use of all NGINX directives, the 4.x API has been vastly reduced and redesigned to include a template concept. As such, the 4.x API supported by the App Delivery Manager is not directly backward compatible with the 3.x API supported by the Application Delivery Controller (ADC). The template concept provides a more NGINX-native view and more precise control over the configuration. As a result, there is no automated upgrade path from the 3.x version to the 4.x version. However, since 4.x supports the same features, we have provided a migration guide you can use to transition to the new product.

## Migrate from Controller ADC 3.x to App Delivery Manager 4.0

1. Install App Delivery Manager 4.0 on a dedicated server (do not install App Delivery Manager 4.0 on the same server running ADC 3.x)
2. Perform a full backup of the ADC 3.x deployment.
{{<comment>}} 3. TBD {{</comment>}}
