---
title: Manage users and organizations
weight: 300
toc: true
nd-docs: DOCS-664
url: /nginxaas/google/getting-started/manage-users-organizations/
nd-content-type: how-to
nd-product: NGOOGL
---

## Overview

This document explains how to manage users and organizations in F5 NGINXaaS for Google Cloud using the NGINXaaS console.

Before you start, ensure you understand the following concepts:

- **NGINXaaS Organization**: An NGINXaaS Organization is created when you subscribe to *F5 NGINXaaS for Google Cloud* via the Google Cloud Marketplace, as described in [prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites.md" >}}). You may create multiple NGINXaaS Organizations by signing up with different GCP billing accounts.
- **User**: NGINXaaS Users are granted access to all resources in the NGINXaaS Organization. User authentication is performed securely via Google Cloud, requiring a matching identity. Individuals can be added as users to multiple NGINXaaS Organizations, and can switch between them using the steps documented below.
- **Authorized Domains**: The list of domains allowed to authenticate into the NGINXaaS Organization using Google authentication.
   - This can be used to restrict access to Google identities within your Google Cloud Organization or Google Workspace, or other known, trusted Workspaces. For example, your Google Cloud Organization may have users created under the `example.com` domain. By setting the Authorized Domains in your NGINXaaS Organization to only allow `example.com`, users attempting to log in with the same email associated with `alternative.net` Google Workspace would not be authenticated.
   - By default, an NGINXaaS Organization has an empty authorized domains list, which accepts matching users from any Google Workspace.

## Add or edit a user

An existing NGINXaaS Organization user can add additional users following these steps:

1. Access the [NGINXaaS Console](https://console.nginxaas.net/).
1. Log in to the console with your Google credentials.
1. Navigate to **Users** page on the left menu, then select **Add User**.
1. Enter the **Email** address for the user to be added. The email must match the individual's Google User to be able to authenticate successfully.
1. Select **Create User** to save the changes.

The new user will appear in the list of users on the **Users** page. Their **Google Identity Domain** will remain empty until they log in for the first time.

## Modify organization settings

As an authenticated user, you may modify the authorized domains and name of an NGINXaaS Organization.


### Modify Authorized Domains

1. Select **Organization Details** under the **Settings** section on the left menu.
1. Select **Edit** in the **Authorized Domains** section.
1. To add a new authorized domain, select **Add Domain** and enter the new domain.
1. To remove an existing authorized domain, select the Recycle Bin button next to it.
1. Select **Update** to save changes.

{{< call-out "note" >}}You cannot remove an authorized domain from the list if it matches an existing user's Google Identity Domain. To remove access from that domain you must first delete every NGINXaaS user that is associated with the domain.{{< /call-out >}}

### Modify the name of an organization

1. Select **Organization Details** under the **Settings** section on the left menu.
1. Select **Edit** in the **Organization Info** section.
1. Enter new name in **Organization Name** field, then select **Update** to save changes.

## Switch organizations

To switch to a different NGINXaaS Organization, select the profile symbol in the top right corner and choose **Switch Organization**. This opens a page showing the list of all the NGINXaaS Organizations that your Google Identity is linked to; select the organization you want to switch to.

## Delete a user

An authenticated user can delete other users (other than their own user account). Deletion is irreversible; the deleted user will no longer be able to access the NGINXaaS Organization.

To delete a user in an NGINXaaS Organization:

1. Select **Organization Details** under the **Settings** section on the left menu.
1. Select the ellipsis (three dots) menu next to the user you want to delete.
1. Select **Delete** in the menu. The deleted user will no longer appear in the **Users** page.

## What's next
[Add certificates using the NGINXaaS Console]({{< ref "/nginxaas-google/getting-started/ssl-tls-certificates/ssl-tls-certificates-console.md" >}})
