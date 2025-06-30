---
description: Learn how to use F5 NGINX Instance Manager to set up and manage NGINX App Protect WAF security policies.
nd-docs: DOCS-992
title: "How WAF policy management works"
toc: true
weight: 100
type:
- reference
---

## Overview

F5 NGINX Instance Manager helps you manage [NGINX App Protect WAF](https://www.nginx.com/products/nginx-app-protect/web-application-firewall/) security configurations.

Use NGINX Instance Manager with NGINX App Protect WAF to inspect incoming traffic, detect threats, and block malicious requests. You can define policies in one place and push them to some or all of your NGINX App Protect WAF instances.

### Key features

- Manage WAF policies using the NGINX Instance Manager web interface or REST API
- Update attack signature and threat campaign packages
- Compile WAF configurations into a binary bundle for deployment

## Architecture

NGINX Instance Manager lets you define and manage security policies, upload signature packages, and push configurations to your NGINX App Protect WAF instances. It can also compile your security configuration into a bundle before publishing it to the data plane.

The **Security Monitoring** module shows real-time data from NGINX App Protect WAF so you can track traffic, spot anomalies, and fine-tune policies.

{{< img src="nim/app-sec-overview.png" caption="Figure 1. NGINX Instance Manager with NGINX App Protect architecture overview" alt="Architecture diagram showing NGINX Instance Manager and Security Monitoring in the control plane pushing security bundles to NGINX App Protect WAF instances in the data plane" >}}

### Security bundle compilation {#security-bundle}

NGINX Instance Manager includes a compiler that packages your complete WAF configuration — security policies, attack signatures, threat campaigns, and log profiles — into a single `.tgz` file. It then pushes this bundle to the selected NGINX App Protect WAF instances.

**Why precompile with NGINX Instance Manager?**

- Saves system resources on WAF instances
- Lets you reuse the same bundle across multiple instances

If you choose to compile policies on the WAF instance instead, that works too—but with this limitation:

- NGINX Instance Manager won’t publish `.json` policies to the WAF instance. These policies must already exist on the instance and be referenced in the NGINX config.

Example [`location`](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) block to enable WAF and point to the bundle:

```nginx
location / {
    app_protect_enable on;
    app_protect_policy_file /etc/app_protect/policies/policy_bundle.tgz;
}
```

## Log profile compilation

You can also configure NGINX Instance Manager to compile log profiles when you install a new version of the compiler. When publishing NGINX configs that include the [`app_protect_security_log`](https://docs.nginx.com/nginx-app-protect/logging-overview/security-log/#app_protect_security_log) directive, NGINX Instance Manager pushes the compiled log profile to your WAF instances (when precompiled publication is turned on).

{{<important>}}
NGINX Instance Manager and Security Monitoring both use log profiles, but their configurations are different. If you're using configuration management in NGINX Instance Manager, you must reference the log profile with the `.tgz` file extension, not `.json`.
{{</important>}}

## Security management APIs

Use the NGINX Instance Manager REST API to automate updates across your NGINX App Protect WAF instances. You can use the API to manage:

- Security policies
- Log profiles
- Attack signatures
- Threat campaigns

Just like with the web interface, the compiler creates a binary bundle with your updates that you can push to your WAF instances.

{{< img src="nim/app-sec-api-overview.png" caption="Figure 2. NGINX Instance Manager with NGINX App Protect WAF architecture overview" alt="Diagram showing how the NGINX Instance Manager REST API is used to create policies, upload signatures and campaigns, and publish compiled security bundles to NGINX App Protect WAF instances">}}

For full details, see the API documentation:

{{< include "nim/how-to-access-api-docs.md" >}}
