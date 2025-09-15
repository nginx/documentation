---
title: Manage users and accounts
weight: 300
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/getting-started/manage-users-accounts/
type:
- how-to
---

## Overview

This document explains how to manage users and accounts in F5 NGINXaaS for Google Cloud using the NGINXaaS console.

Before you start, ensure you understand the following concepts:

- **NGINXaaS Account**: Represents a Google Cloud procurement with an active Marketplace NGINXaaS subscription, linked to a billing account. To create an account, see the signup documentation in [prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites.md" >}}).
- **User**: A user is anyone who has access to an NGINXaaS Account through their Google Identity. The same Google Identity can be added to multiple NGINXaaS Accounts, but it is treated as a different user in each account.
- **Authorized Domains**: The list of Google Identity domains (for example, "example.com") allowed to access an NGINXaaS Account using Google authentication.
   - By default, an NGINXaaS Account has an empty authorized domains field, which means that anyone can log in to the account, if added as a user.
   - Configuring this field allows you to control which organizations (based on their email domains) are allowed to log in to the NGINXaaS Account. This restricts access to only users from trusted companies or groups, and prevents unauthorized domains from accessing resources in the account.
   - When updating authorized domains, you cannot make an update if it would prevent any existing user from logging in. This ensures that no current users are accidentally locked out of the account.

## Add or edit a user

An existing NGINXaaS Account user can additional users following these steps:

1. Access the [NGINXaaS Console](https://console.nginxaas.net/).
1. Log in to the console with your Google credentials.
1. Navigate to **Users** page on the left menu, then select **Add User**.
1. Enter the **Name** and **Email** for the user to be added.
1. Select **Create User** to save the changes.

The new user will appear in the list of users on the **Users** page. Their **Google Identity Domain** will remain empty until they log in for the first time.

### Edit a user

1. Select **Users** under the **Settings** section on the left menu.
1. Select the ellipsis (three dots) menu for the user you want to update.
1. Select **Edit**.
1. Update the user details; currently only the username can be changed.
1. Select **Update** to confirm the changes.

## Modify account settings

As an authenticated user, you may modify the authorized domains and name of an NGINXaaS Account.


### Modify Authorized Domains

1. Select **Account Details** under the **Settings** section on the left menu.
1. Select **Edit** in the **Authorized Domains** section.
1. To add a new authorized domain, select **Add Domain** and enter the new domain.
1. To remove an existing authorized domain, select the Recycle Bin button next to it.
1. Select **Update** to save changes.

### Modify the name of an accoun

1. Select **Account Details** under the **Settings** section on the left menu.
2. Select **Edit** in the **Account Info** section.
3. Enter new name in **Account Name** field, then select **Update** to save changes.

## Switch accounts

To switch to a different NGINXaaS Account, select the profile symbol in the top right corner and choose **Switch Account**. This opens a page showing the list of all the NGINXaas Accounts that your Google Identity is linked to; select the account you want to switch to.

## Delete a user

An authenticated user can delete other users (other than their own user account). Deletion is irreversible; the deleted user will no longer be able to access the NGINXaaS Account.

To delete a user in an NGINXaaS Account:

1. Select **Account Details** under the **Settings** section on the left menu.
1. Select the ellipsis (three dots) menu next to the user you want to delete.
1. Select **Delete** in the menu. The deleted user will no longer appear in the **Users** page.
