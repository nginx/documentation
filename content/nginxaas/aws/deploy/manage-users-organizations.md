---
title: Manage users and organizations
weight: 300
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/deploy/manage-users-organizations/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
---

{{< call-out class="important" title="Placeholder content" >}}
This page contains placeholder documentation for **NGINXaaS for AWS**. Workflows, screenshots, pricing, and UI text described here are illustrative only and do not represent a shipping product.
{{< /call-out >}}

## Overview

This document explains how to manage users and organizations in F5 NGINXaaS for AWS using the NGINXaaS console.

Before you start, ensure you understand the following concepts:

- **NGINXaaS Organization**: An NGINXaaS Organization is created when you subscribe to *F5 NGINXaaS for AWS* via the AWS Marketplace, as described in [prerequisites]({{< ref "/nginxaas/aws/deploy/prerequisites.md" >}}). You may create multiple NGINXaaS Organizations by signing up with different AWS accounts.
- **User**: NGINXaaS Users are granted access to all resources in the NGINXaaS Organization. User authentication is performed securely via AWS IAM Identity Center, requiring a matching identity. Individuals can be added as users to multiple NGINXaaS Organizations, and can switch between them using the steps documented below.
- **Authorized Domains**: The list of domains allowed to authenticate into the NGINXaaS Organization using AWS IAM Identity Center authentication.
   - This can be used to restrict access to identities within your AWS IAM Identity Center directory, or other known, trusted directories. For example, your AWS IAM Identity Center directory may have users created under the `example.com` domain. By setting the Authorized Domains in your NGINXaaS Organization to only allow `example.com`, users attempting to log in with the same email associated with an `alternative.net` IAM Identity Center directory would not be authenticated.
   - By default, an NGINXaaS Organization has an empty authorized domains list, which accepts matching users from any AWS IAM Identity Center directory.

## Add or edit a user

An existing NGINXaaS Organization user can add additional users following these steps:

1. Access the [NGINXaaS Console](https://console.nginxaas.net/).
1. Log in to the console with your AWS credentials.
1. Navigate to **Users** page on the left menu, then select **Add User**.
1. Enter the **Email** address for the user to be added. The email must match the individual's AWS IAM Identity Center user to be able to authenticate successfully.
1. Select **Create User** to save the changes.

The new user will appear in the list of users on the **Users** page. Their **Identity Domain** will remain empty until they log in for the first time.

## Modify organization settings

As an authenticated user, you may modify the authorized domains and name of an NGINXaaS Organization.


### Modify Authorized Domains

1. Select **Organization Details** under the **Settings** section on the left menu.
1. Select **Edit** in the **Authorized Domains** section.
1. To add a new authorized domain, select **Add Domain** and enter the new domain.
1. To remove an existing authorized domain, select the Recycle Bin button next to it.
1. Select **Update** to save changes.

{{< call-out class="note" >}}You cannot remove an authorized domain from the list if it matches an existing user's Identity Domain. To remove access from that domain you must first delete every NGINXaaS user that is associated with the domain.{{< /call-out >}}

### Modify the name of an organization

1. Select **Organization Details** under the **Settings** section on the left menu.
1. Select **Edit** in the **Organization Info** section.
1. Enter new name in **Organization Name** field, then select **Update** to save changes.

## Switch organizations

To switch to a different NGINXaaS Organization, select the profile symbol in the top right corner and choose **Switch Organization**. This opens a page showing the list of all the NGINXaaS Organizations that your AWS identity is linked to; select the organization you want to switch to.

## Delete a user

An authenticated user can delete other users (other than their own user account). Deletion is irreversible; the deleted user will no longer be able to access the NGINXaaS Organization.

To delete a user in an NGINXaaS Organization:

1. Select **Organization Details** under the **Settings** section on the left menu.
1. Select the ellipsis (three dots) menu next to the user you want to delete.
1. Select **Delete** in the menu. The deleted user will no longer appear in the **Users** page.

## What's next
[Add certificates using the NGINXaaS Console]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-console.md" >}})
