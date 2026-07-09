---
title: Create or upload using the NGINXaaS Console
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/deploy/nginx-configuration/nginx-configuration-console/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
---

{{< call-out class="important" title="Placeholder content" >}}
This page contains placeholder documentation for **NGINXaaS for AWS**. Workflows, screenshots, pricing, and UI text described here are illustrative only and do not represent a shipping product.
{{< /call-out >}}

You can apply an NGINX configuration to your F5 NGINXaaS for AWS deployment using the NGINXaaS Console.

## Prerequisites

- If you haven't done it yet, follow the steps in the [Prerequisites]({{< ref "/nginxaas/aws/deploy/prerequisites/" >}}) topic to subscribe to the NGINXaaS for AWS offer in the AWS Marketplace.

## Access the NGINXaaS Console

{{< include "/nginxaas/aws/access-console.md" >}}

## Create or import an NGINX configuration

{{< include "/nginxaas/aws/create-or-import-nginx-config.md" >}}

## Update an NGINX configuration

{{< include "/nginxaas/aws/update-nginx-config.md" >}}

## Delete NGINX configuration Files

1. On the left menu, select **Configurations**.
1. On the list of configurations, select the ellipses (three dots) icon next to the configuration you want to delete.
1. Select **Delete**.
1. Confirm that you want to delete the configuration.

## What's next
[Monitor your deployment]({{< ref "/nginxaas/aws/monitoring/enable-monitoring.md" >}})
