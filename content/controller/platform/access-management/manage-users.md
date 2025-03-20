---
description: Create and manage User resources.
docs: DOCS-784
title: Manage Users
toc: true
weight: 20
type:
- tutorial
---

## Overview

This topic explains how to create and manage User resources.

A User resource represents an F5 NGINX Controller User account. [Assign Roles to Users]({{< relref "/controller/platform/access-management/manage-roles.md" >}}) to define what actions Users can perform in NGINX Controller and what [Environment(s)]({{< relref "/controller/services/manage-environments.md" >}}) Users can access.

By default, all users have `READ` permissions for Analytics, Users, Roles, and Licenses. You can use the `/platform/roles` endpoint in the [NGINX Controller REST API]({{< relref "/controller/api/_index.md" >}}) to extend or narrow this default set of permissions.

### Create a User

Take the following steps to create a User:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Users**.
4. On the **Users** menu, select **Create User**.
5. Add a first name.
6. Add a last name.
7. Add an email address.
8. Add a password.
9. (Optional) Add one or more tags.
10. (Optional) Add one or more [Roles]({{< relref "/controller/platform/access-management/manage-roles.md" >}}). The Role specifies the user's permission level.

{{< note >}}
User account passwords for NGINX Controller must meet the following requirements:

- Must be between 8–64 characters. Special characters are allowed.
- Must contain at least 1 letter.
- Must contain at least 1 number.
- New passwords must be different from the last password.

Dictionary words, mangled dictionary words like `p4ssword`, or systematic passwords like `1234567a` are not allowed.

If your organization requires a different password policy, we recommend that you [configure external authentication using Active Directory]({{< relref "/controller/platform/access-management/manage-active-directory-auth-provider.md" >}}) for all users except the primary NGINX Controller admin user.
{{< /note >}}

### Edit or Delete a User

Take the following steps to edit or delete a User:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Users**.
4. To edit a User, choose the User from the list, then select **Edit** (pencil icon).
5. To delete a User, choose the User from the list, then select **Delete** (trash icon).

## What's Next

- [Create a Role or Role Group]({{< relref "/controller/platform/access-management/manage-roles.md" >}})
- [Create an Authentication Provider]({{< relref "/controller/platform/access-management/manage-active-directory-auth-provider.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
