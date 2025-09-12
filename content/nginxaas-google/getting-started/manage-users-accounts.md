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

Before starting, the following concepts are important to understand:

- **NGINXaaS Accounts**: Represents a Google Cloud procurement with an active NGINXaaS Marketplace subscription, linked to a billing account. To create an account, see the signup documentation in [prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites.md" >}}).
- **Users**: A user is anyone who has access to an NGINXaaS Account through their Google Identity. The same Google Identity can be added to multiple NGINXaaS Accounts, but it is treated as a different user in each account. 

## Add or edit a user

As an existing user of an NGINXaaS Account, you can add a new user as follows:
1. Log into the [NGINXaaS console](https://console.nginxaas.net/) with your Google credentials. 
2. Navigate to **Users** page on the left bar, and select **Add User**.
3. Enter **Name** and **Email** for the user to be added.
4. Save changes by selecting **Create User**. The new user will appear in the list of users on the **Users** page. Their **Google Identity Domain** will remain empty until they log in for the first time.

To edit a user:
1. Navigiate to **Users** page under the **Settings** menu in the left bar.
2. Select the options menu located in the last column next to the user you want to update.
3. Select **Edit** to open up form for updating user details, which currently only supports username change.
4. Enter the new username in the form, save changes by selecting **Update**. 

## Modify account settings

As an authenticated user, you may modify the authorized domains and name of an NGINXaaS Account.

**Authorized Domains** is the list of Google Identity domains (e.g., example.com) allowed to access an NGINXaaS Account using Google authentication.By default, an NGINXaaS Account has an empty authorized domains field, which means that anyone can log in to the account if added as a user. Setting this field allows you to control which organizations (based on their email domains) are allowed to log in to the NGINXaaS Account. This restricts access to only users from trusted companies or groups, and prevents unauthorized domains from accessing resources in the account. When updating authorized domains, you cannot make an update if it would prevent any existing user from logging in. This ensures that no current users are accidentally locked out of the account. 

To modify **Authorized Domains**: 
1. Navigate to the **Account Details** page under the **Settings** menu in the left bar. 
2. Select **Edit** in the **Authorized Domains** section.
3. To add a new authorized domain, select **Add Domain** and enter the new domain. 
4. To remove an existing authorized domain, select the trash symbol next to it. 
6. Save changes by selecting **Update**.

To modify the name of an account:
1. Navigate to **Account Details** page under the **Settings** menu in the left bar. 
2. Select **Edit** in the **Account Info** section.
3. Enter new name in **Account Name** field, save changes by selecting **Update**. 

## Switch accounts
To switch to a different NGINXaaS Account, select the profile symbol in the top right corner and choose **Switch Account**. This opens a page showing the list of all NGINXaas Accounts that your Google Identity is linked to, where you may select an account to switch to. 

## Delete a user
An authenticated user is able to delete other users, while they are not permitted to delete themselves. Deletion is irreversible, and the deleted user will no longer be able to access the NGINXaaS Account. 

To delete a user in an NGINXaaS Account:
1. Navigate to **Users** page under the **Settings** menu in the left bar.
2. Choose user to delete by selecting the options menu in the last column. 
3. Select **Delete** in the options menu. The deleted user will no longer appear in the **Users** page. 
