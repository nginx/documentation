---
description: ""
docs: DOCS-1394
doctypes:
  - reference
tags:
  - docs
title: Changelog
toc: true
weight: 99999
---

<style>
h2 {
  position: relative;
  margin-bottom: 10px;
  padding-bottom: 10px;
  border-bottom: 1px solid #ddd; /* A very light line */
}

/* Adds space above all h2 elements except the first one */
.content h2:not(:first-of-type) {
  margin-top: 50px; /* Adjust this value to create the desired space */
}

.content h3 {
  margin-top: 25px; /* Space before the h3 */
  margin-bottom: 10px; /* Space after the h3 */
}

</style>

Stay up-to-date with what's new and improved in the F5 NGINX One Console.

## January 20, 2025

### Revert a configuration

Using the NGINX One Console you can now:

- See a history of changes to the configuration on an instance or a Config Sync Group, as well as the content of the previous five configs published to that object
- Review the differences between the current and other saved configurations
- Revert to older configurations as needed

### AI Assistant

In the F5 NGINX One Console, you can now select lines from your configuration files, and then select **Explain with AI**. The NGINX One AI Assistant explains those lines based on the official NGINX documentation.

## November 7, 2024

### Certificates

From the NGINX One Console you can now:

- Monitor all certificates configured for use by your connected NGINX Instances.
- Ensure that your certificates are current and correct.
- Manage your certificates from a central location. This can help you simplify operations and remotely update, rotate, and deploy those certificates.

For more information, see the full documentation on how you can [Manage Certificates]({{< relref "/nginx-one/how-to/certificates/manage-certificates.md" >}}).

## August 22, 2024

### Config Sync Groups

Config Sync Groups are now available in the F5 NGINX One Console. This feature allows you to manage and synchronize NGINX configurations across multiple instances as a single entity, ensuring consistency and simplifying the management of your NGINX environment.

For more information, see the full documentation on [Managing Config Sync Groups]({{< relref "/nginx-one/how-to/config-sync-groups/manage-config-sync-groups.md" >}}).

## August 8, 2024

### Instance object cleanup

NGINX Instance objects that have been `unavailable` for a set period will be automatically cleaned up (deleted). By default, this period is 24 hours from the time the NGINX Instance object was last updated. An administrator can change or disable the cleanup process in the "Instance Settings" under Settings. Events will be generated for NGINX Instances that have been automatically cleaned up. See "Events" for a list of NGINX Instances that have been deleted automatically.

## June 11, 2024

### View NGINX security vulnerabilities (CVEs)

You can now view NGINX CVEs on the **Security** page. The listed CVEs affect official releases of NGINX Open Source and NGINX Plus.

Select the link for each CVE to see the details, including the CVE's publish date, severity, description, and the affected NGINX products and instances.

## May 29, 2024

### Edit NGINX configurations

You can now make configuration changes to your NGINX instances. For more details, see [View and edit NGINX configurations]({{< relref "/nginx-one/how-to/nginx-configs/view-edit-nginx-configurations.md" >}}).

## May 28, 2024

### Improved data plane key and NGINX instance navigation

We've updated the **Instance Details** and **Data Plane Keys** pages to make it easier to go between keys and registered instances.

- On the **Instance Details** page, you can now find a link to the instance's data plane key. Select the "Data Plane Key" link to view important details like status, expiration, and other registered instances.
- The **Data Plane Keys** page now includes links to more information about each data plane key.

## February 28, 2024

### Breaking change

- API responses now use "object_id" instead of "uuid". For example, **key_1mp6W5pqRxSZJugJN-yA8g**. We've introduced specific prefixes for different types of objects:
  - Use **key\_** for data-plane keys.
  - Use **inst\_** for NGINX instances.
  - Use **nc\_** for NGINX configurations.
- Likewise, we've updated the JSON key from **uuid** to **object_id** in response objects.

## February 6, 2024

### Welcome to the NGINX One EA preview

We're thrilled to introduce NGINX One, an exciting addition to our suite of NGINX products. Designed with efficiency and ease of use in mind, NGINX One offers an innovative approach to managing your NGINX instances.

To help you get started, take a look at the [Getting Started Guide]({{< relref "/nginx-one/getting-started.md" >}}). This guide will walk you through the initial setup and key features so you can start using NGINX One right away.
