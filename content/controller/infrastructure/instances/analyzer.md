---
description: View graphs and system reports for your Instances.
nd-docs: DOCS-772
title: View Performance Reports for Your Instances
toc: true
weight: 60
type:
- how-to
---

## Overview

Use the **Analyzer** page in the F5 NGINX Controller **Infrastructure** section to see reports for your NGINX Plus instances.

## View Reports for NGINX Plus Instances

The NGINX Controller Agent parses NGINX configuration files and transmits them to the backend component for further analysis. This is where NGINX Controller offers configuration recommendations to help improve the performance, reliability, and security of your applications. With well-thought-out and detailed recommendations, you'll know exactly where the problem is, why it is a problem, and how to fix it.

To access the **Analyzer** page, take the following steps:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Infrastructure**.
3. On the **Infrastructure** menu, select **Instances** > **Analyzer**.

When viewing the **Analyzer Overview** page, select a system from the **Systems** pane to see the associated report.

{{< call-out "note" >}} The Analyzer can only show reports for NGINX instances found by the NGINX Controller Agent. If an instance is missing, check that it is [configured correctly for discovery by the Agent]({{< ref "/controller/support/troubleshooting-controller.md" >}}).{{< /call-out >}}

The following information is provided when a report is run against an NGINX config structure:

- Build
  - Path to NGINX config files(s)
  - Whether the parser failed or not, and the results of `nginx -t`
      {{< call-out "note" >}} Periodic NGINX configuration syntax checking with `nginx -t` is disabled by default. To enable this setting, select the **Enable periodic "nginx -t"** box on the [Default Agent Settings]({{< ref "/controller/admin-guides/config-agent/configure-the-agent.md#default-agent-settings" >}}) page.{{< /call-out >}}
  - Last-modified info
  - 3rd party modules found
  - Breakdown of the key configuration elements (servers, locations, upstreams)
  - Breakdown of IPv4/IPv6 usage
- Security
  - Any security advisories that apply to this version of NGINX
- Virtual servers
  - Breakdown of the virtual host configuration (think `apachectl -S`)
- SSL
  - OpenSSL version information
  - Breakdown of the number of SSL or HTTP/2 servers configured
  - Information about the configured SSL certificates
  - Warnings about common SSL configuration errors
- Static analysis
  - Various suggestions about configuration structure
  - Typical configuration gotchas highlighted
  - Common advice about proxy configurations
  - Suggestions about simplifying rewrites for certain use cases
  - Key security measures (for example, -stub_status- is unprotected)
  - Typical errors in configuring locations, especially with -regex-

To parse SSL certificate metadata, the NGINX Controller Agent uses standard `openssl(1)` functions. SSL certificates are parsed and analyzed by default. To change this setting, clear the **Analyze SSL certificates** box on the [**Agent Settings**]({{< ref "/controller/admin-guides/config-agent/configure-the-agent.md#default-agent-settings" >}}) page.

Static analysis will only include information about specific issues with the NGINX configuration if those are found in your NGINX setup.

## Troubleshooting

If the **Infrastructure** > **Analyzer** tab doesn't display information, it may be because the current user doesn't belong to one of the [built-in roles]({{< ref "/controller/platform/access-management/manage-roles.md" >}}) and the `/reports/` endpoint hasn't been enabled for a custom role.

To enable the `/reports/` endpoint for a custom role, send a POST request to the Roles [API endpoint]({{< ref "/controller/api/_index.md" >}}) similar to the following:

```json
{
  "desiredState": {
    "permissions": [
      {
        "access": "READ",
        "path": "/reports/"
      }
    ]
  },
  "metadata": {
    "kind": "role",
    "name": "analyzer-reports"
  }
}
```

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
