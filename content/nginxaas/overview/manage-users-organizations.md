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
- **User**: NGINXaaS Users are granted access to all resources in the NGINXaaS Organization. User authentication is performed securely via your allowed login method(s), requiring a matching identity.
   - Individuals can be added as users to multiple NGINXaaS Organizations, and can switch between them using the steps documented below.
   - Note that once a user has gained access to an NGINXaaS Organization through a particular login method, they must continue to use that login method to gain access to that NGINXaaS Organization. If the same human user authenticates through two different login methods, the resulting user identities are distinct from the perspective of NGINXaaS.

- **Authentication settings**: Authentication settings are specific to the enabled login method.
   - **Login Methods**: NGINXaaS authenticates users through Microsoft social login or Google social login. The NGINXaaS Organization can be configured to allow either or both of these login methods. By default, both login methods are enabled.
   - **Google Authorized Domains**: If Google social login is enabled, authorized users can configure the list of domains with which users must be associated.
      - This can be used to restrict access to Google identities within your Google Cloud Organization or Google Workspace, or other known, trusted Workspaces. For example, your Google Cloud Organization may have users created under the `example.com` domain. By setting the Authorized Domains in your NGINXaaS Organization to only allow `example.com`, users attempting to log in with the same email associated with `alternative.net` Google Workspace would not be authenticated.
      - By default, an NGINXaaS Organization has an empty authorized domains list, which accepts matching users from any Google Workspace.
   - **Microsoft Authorized Tenants**: If Microsoft social login is enabled, authorized users can configure the list of Azure tenant IDs to which users must belong.
      - For example, all team members seeking to gain access to your NGINXaaS Organization have an Entra identity within a particular Azure tenant. You can add the Azure tenant ID to the list of Microsoft Authorized Tenants. This will restrict anyone with an Entra identity outside that Azure tenant from accessing your NGINXaaS Organization.
      - By default, users of all Azure tenants will be allowed to match with the new user entries you add to your organization.

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

## Modify an organization's Authentication Settings

1. Select **Organization Details** under the **Settings** section on the left menu.
1. Select **Edit** in the **Authentication Settings** section.
1. Tick the login methods that you wish to enable.
1. To add a new Google authorized domain, select **Add Domain** and enter the new domain.
1. To remove an existing Google authorized domain, select the Recycle Bin button next to it.
1. To add a new Authorized Microsoft tenant, select **Add Tenant ID** and enter the Azure tenant ID.
1. To remove an existing Authorized Microsoft tenant, select the Recycle Bin button next to it.
1. Select **Update** to save changes.

{{< call-out class="note" >}}You cannot remove a Google authorized domain or an Authorized Microsoft tenant from an organization's authentication settings if the action will lock out existing users of the organization. To modify the authentication settings you must first delete every NGINXaaS user that is associated with the Google authorized domain or Authorized Microft tenant that you wish to exclude.{{< /call-out >}}

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
