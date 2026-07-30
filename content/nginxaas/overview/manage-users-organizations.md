---
title: Manage users and organizations
weight: 300
toc: true
f5-docs: DOCS-000
url: /nginxaas/overview/manage-users-organizations/
f5-content-type: how-to
f5-product: F5 NGINXaaS
---

## Overview

This document explains how to manage users and organizations in F5 NGINXaaS using the NGINXaaS console.

Before you start, ensure you understand the following concepts:

- **NGINXaaS Organization**: An NGINXaaS Organization can be created at any time, to host your NGINXaaS resources for your team or business unit. The organization must be linked to an active cloud marketplace subscription in order to manage and utilize NGINXaaS deployments in that cloud.
- **User**: NGINXaaS Users are granted access to all resources in the NGINXaaS Organization. User authentication is performed securely via your allowed identity provider(s), requiring a matching identity. Individuals can be added as users to multiple NGINXaaS Organizations, and can switch between them using the steps documented below.
- **Authorized Domains**: The list of domains allowed to authenticate into the NGINXaaS Organization using Google authentication.
   - This can be used to restrict access to Google identities within your Google Cloud Organization or Google Workspace, or other known, trusted Workspaces. For example, your Google Cloud Organization may have users created under the `example.com` domain. By setting the Authorized Domains in your NGINXaaS Organization to only allow `example.com`, users attempting to log in with the same email associated with `alternative.net` Google Workspace would not be authenticated.
   - By default, an NGINXaaS Organization has an empty authorized domains list, which accepts matching users from any Google Workspace.

## Create an organization

An NGINXaaS Organization holds your team's NGINX configurations, certificates, and users.

- **Logging in for the first time**: Access the [NGINXaaS Console](https://console.nginxaas.net/) and log in with your identity provider. If you are not already a member of an existing organization, you will be prompted to create a new organization. Enter the **Organization Name** and select **Submit**.
- **When already logged in**: In the [NGINXaaS Console](https://console.nginxaas.net/), select your profile icon in the top right corner and choose **Switch Organization**. Select **Add Organization**, enter the **Organization Name**, and choose **Create and Select** to create and switch to the new organization.

{{< call-out class="note" >}}
You can create NGINX configurations and upload SSL/TLS certificates within an organization without a cloud subscription. If you want to create an NGINXaaS deployment, please subscribe to your preferred cloud provider(s) in the cloud marketplace.
{{< /call-out >}}

## Add or edit a user

An existing NGINXaaS Organization user can add additional users following these steps:

1. Access the [NGINXaaS Console](https://console.nginxaas.net/).
1. Log in to the console with your identity provider.
1. Navigate to the **Users** page on the left menu, then select **Add User**.
1. Enter the **Email** address for the user to be added.
1. Select **Create User** to save the changes.

The new user will appear in the list of users on the **Users** page. The next time they log in, they will be able to access this NGINXaaS Organization.

## Modify organization settings

As an authenticated user, you may modify the authorized domains and name of an NGINXaaS Organization.

### Modify Authorized Domains

1. Select **Organization Details** under the **Settings** section on the left menu.
1. Select **Edit** in the **Authorized Domains** section.
1. To add a new authorized domain, select **Add Domain** and enter the new domain.
1. To remove an existing authorized domain, select the Recycle Bin button next to it.
1. Select **Update** to save changes.

{{< call-out class="note" >}}You cannot remove an authorized domain from the list if it matches an existing user's Google Identity Domain. To remove access from that domain you must first delete every NGINXaaS user that is associated with the domain.{{< /call-out >}}

### Modify the name of an organization

1. Select **Organization Details** under the **Settings** section on the left menu.
1. Select **Edit** in the **Organization Info** section.
1. Enter new name in the **Organization Name** field, then select **Update** to save changes.

## Switch organizations

To switch to a different NGINXaaS Organization (or to create a new organization), select the profile symbol in the top right corner and choose **Switch Organization**. This opens a page showing the list of all NGINXaaS Organizations linked to your user identity. Select the organization you want to switch to, or select **Add Organization** to set up a new one.

## Delete a user

An authenticated user can delete other users, but not their own user. Deletion is irreversible; the deleted user will no longer be able to access the NGINXaaS Organization.

To delete a user in an NGINXaaS Organization:

1. Select **Organization Details** under the **Settings** section on the left menu.
1. Select the ellipsis (three dots) menu next to the user you want to delete.
1. Select **Delete** in the menu. The deleted user will no longer appear in the **Users** page.

## What's next

[Add an NGINX configuration using the NGINXaaS Console]({{< ref "/nginxaas/overview/nginx-configuration/nginx-configuration-console.md" >}})
