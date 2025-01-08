---
description: Learn how you can use F5 NGINX Management Suite Instance Manager to configure
  NGINX App Protect WAF security policies.
docs: DOCS-992
doctypes:
- reference
tags:
- docs
title: NGINX App Protect WAF configuration management
toc: true
weight: 500
---

## Overview

F5 NGINX Management Suite Instance Manager provides configuration management for [NGINX App Protect WAF](https://www.nginx.com/products/nginx-app-protect/web-application-firewall/).

You can use NGINX App Protect WAF with Instance Manager to inspect incoming traffic, identify potential threats, and block malicious traffic. With Configuration Management for App Protect WAF, you can configure WAF security policies in a single location and push your configurations out to one, some, or all of your NGINX App Protect WAF instances.

### Features

- Manage NGINX App Protect WAF security configurations by using the NGINX Management Suite user interface or REST API
- Update Attack Signatures and Threat Campaign packages
- Compile security configurations into a binary bundle for consumption by NGINX App Protect WAF instances

## Architecture

As demonstrated in Figure 1, Instance Manager lets you manage security configurations for NGINX App Protect WAF. You can define security policies, upload attack signatures and threat campaign packages, and publish common configurations out to your NGINX App Protect WAF instances. Instance Manager can compile the security configuration into a bundle before pushing the configuration to the NGINX App Protect WAF data plane instances. The NGINX Management Suite Security Monitoring module provides data visualization for NGINX App Protect, so you can monitor, analyze, and refine your policies.

{{< img src="nim/app-sec-overview.png" caption="Figure 1. NGINX Management Suite with NGINX App Protect Architecture Overview" alt="A diagram showing the architecture of the NGINX Management Suite with NGINX App Protect solution" width="75%">}}

### Security Bundle Compilation {#security-bundle}

Instance Manager provides a compiler that can be configured to bundle the complete security configuration -- including JSON security policies, attack signatures, threat campaigns, and log profiles -- into a single binary in `.tgz` format. This bundle is then pushed out to each selected NGINX App Protect WAF instance.

Performing the security bundle compilation on Instance Manager (precompiled publication) instead of on the NGINX App Protect WAF instances provides the following benefits:

- Eliminates the need to provision system resources on NGINX App Protect WAF instances to perform compilation.
- The bundles produced by Instance Manager can be reused by multiple NGINX App Protect WAF instances, instead of each instance having to perform the compilation separately.

However, if you prefer to maintain policy compilation on the NGINX App Protect WAF instance, that is supported with the following limitation:

- Instance Manager does not publish JSON policies to the NGINX App Protect WAF instance. JSON policies referenced in an NGINX configuration must already exist on the NGINX App Protect WAF instance.

The example [`location`](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) context below enables NGINX App Protect WAF and tells NGINX where to find the compiled security bundle:

## Log Profile Compilation

Instance Manager can also be configured to compile log profiles when you install a new version of the WAF compiler. When you publish an NGINX configuration with the NGINX App Protect [`app_protect_security_log`](https://docs.nginx.com/nginx-app-protect/logging-overview/security-log/#app_protect_security_log) directive, Instance Manager publishes the compiled log profiles to the NGINX App Protect WAF instances when precompiled publication is enabled.

{{<important>}}
Instance Manager and Security Monitoring both use NGINX App Protect log profiles. The configuration requirements for each are different. When using Instance Manager configuration management, you must reference the log profile in your NGINX configuration using the `.tgz` file extension instead of `.json`.
{{</important>}}

## Security Management APIs

By using the Instance Manager REST API, you can automate configuration updates to be pushed out to all of your NGINX App Protect WAF instances. You can use the Instance Manager API to manage and deploy the following security configurations:

- security policies,
- log profiles,
- attack signatures, and
- threat campaigns.

Just as with changes made via the user interface, the Instance Manager compiler bundles all of the config updates into a single binary package that you can push out to your instances. Figure 2 shows an overview of the API endpoints available to support security policy configuration and publishing.

{{< img src="nim/app-sec-api-overview.png" caption="Figure 2. NGINX Management Suite with NGINX App Protect WAF Architecture Overview" alt="A diagram showing the architecture of the NGINX Management Suite with NGINX App Protect solution">}}

More information is available in the Instance Manager API documentation.

{{< include "nim/how-to-access-api-docs.md" >}}
