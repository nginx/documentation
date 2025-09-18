---
title: Create or upload using the NGINXaaS Console
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/getting-started/nginx-configuration/nginx-configuration-portal/
type:
- how-to
---

You can apply an NGINX configuration to your F5 NGINXaaS for Google Cloud (NGINXaaS) deployment using the NGINXaaS Console.

## Prerequisites

- If you haven't done it yet, follow the steps in the [Prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites/" >}}) topic to subscribe to the NGINXaaS for Google Cloud offer in the Google Cloud Marketplace.

## Access the NGINXaaS Console

- Browse to the [NGINXaaS Console](https://console.nginxaas.net/).
- Log in to the console with your Google credentials.

## Create or import an NGINX configuration

{{< include "/nginxaas-google/create-or-import-nginx-config.md" >}}

## Update an NGINX configuration

1. On the left menu, select **Configurations**.
1. On the list of configurations, select the ellipses (three dots) icon next to the configuration you want to update.
1. Select **Edit**.
1. Update the "Name" and "Description" fields as needed and select **Next**.
1. Select the file you want to update in the file tree.
1. Modify the configuration file(s) as needed and select **Next**.
1. Review the changes using the "Inline" or "Side-by-side"  views and select **Save**.

You will see a notification confirming that the configuration was updated successfully.

## Delete NGINX configuration Files

1. On the left menu, select **Configurations**.
1. On the list of configurations, select the ellipses (three dots) icon next to the configuration you want to delete.
1. Select **Delete**.
1. Confirm that you want to delete the configuration.

## What's next
[Monitor your deployment]({{< ref "/nginxaas-google/monitoring/enable-monitoring.md" >}})