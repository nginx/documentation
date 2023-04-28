---
title: Migration From NGINX Controller ADC 3.x
description: Learn how to migrate from Application Delivery Controller 3.x to the App Delivery Manager Module.
weight: 200
draft: false
toc: false
tags: ["docs"]
docs: "DOCS-1151"
---

To provide more control over the NGINX configuration and allow the full use of all the NGINX directives, the 4.x API has been vastly reduced and redesigned to include a template concept.  As such, the 4.x API supported by the App Delivery Manager (ADM) is not directly backward compatible with the 3.x API supported by the Application Delivery Controller (ADC).  The template concept provides a more nginx-native view of the configuration and more precise control over the configuration, as requested by many users.  As a result, there is no automated upgrade path from the 3.x version to the 4.x version.  However, since 4.x supports the same features, we have provided a migration guide that you can use to transition to the new product.

### Steps to Migrate from Controller ADC 3.x to App Delivery Manager module 4.0

1. Install ADM 4.0 on a dedicated server (do not install ADM 4.0 on the same server running ADC 3.x)
2. Perform a full backup of the ADC 3.x deployment.
{{<comment>}} 3. TBD {{</comment>}}
