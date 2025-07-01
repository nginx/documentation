---
title: Set up basic authentication
description: Learn how to manage user access in NGINX Instance Manager using basic authentication with NGINX as a front-end proxy. This guide covers first-time login, creating additional users, and setting passwords.
toc: true
weight: 10
type: how-to
product: NIM
nd-docs: DOCS-792
---

<style>
h2 {
  border-top: 1px solid #ccc;
  padding-top:20px;
}
</style>

## Overview

NGINX Instance Manager uses NGINX as a front-end proxy and for managing user access. By default, NGINX Instance Manager uses basic authentication, requiring you to send your username and password with each request to confirm your identity. When logging in for the first time, use the default `admin` account and password. After that, you can create additional user accounts. Instructions for adding users and setting passwords are provided below.

{{< call-out "warning" "Security consideration" >}} While convenient, basic authentication is less secure than other methods: credentials are sent as base64-encoded text, which is not a secure encryption method. If your data is intercepted, the encoding can be easily reversed. If you're using NGINX Plus for your front-end proxy, consider [switching to OpenID Connect (OIDC) for authentication]({{< ref "/nim/admin-guide/authentication/oidc/getting-started.md" >}}). For production environments, we strongly recommend OIDC.{{< /call-out >}}

## Default admin user

When you install NGINX Instance Manager, a default `admin` user is created with a randomly generated password that is shown in the installation output.

You can change the default `admin` password by running the provided script or by manually editing the `/etc/nms/nginx/.htpasswd` file. For instructions, see the [Set user passwords](#set-basic-passwords) section below.

The `admin` user is associated with an [admin role]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}) that grants full permissions for all modules and features. You can delete the `admin` user, but only after assigning the admin role to another user. The admin role cannot be deleted and must always be assigned to at least one user.

## Create new users {#create-users}

{{< note >}} Please note that the web interface does not support adding user passwords directly. Once you've created new users, refer to the following steps to [set user passwords](#set-basic-passwords).{{< /note >}}

To add users, take the following steps:

1. In a web browser, go to the FQDN for your NGINX Instance Manager host and log in.
1. Select the **Settings** (gear) icon in the upper-right corner.
1. On the left menu, select **Users**.
1. Select **Create**.
1. On the **Create User** form, enter the details for the user:

   - **Username**: A unique username to identify the user.
   - **Email**: The user's email address.
   - **First Name**: The user's first name.
   - **Last Name**: The user's last name.
   - **Description**: An optional brief description of the user.

1. In the **Roles** list, select one or more roles to assign to the user.

   Learn more about roles and how to create them in the [Getting started with RBAC]({{< ref "/nim/admin-guide/rbac/overview-rbac" >}}) topic.

1. (Required for Basic Auth) Add each user's username and password to the `/etc/nms/nginx/.htpasswd` file on the NGINX Instance Manager server. You can choose to run a script or make the changes manually. Refer to the [Set user passwords]({{< ref "/nim/admin-guide/authentication/basic-auth/set-up-basic-authentication.md#set-basic-passwords" >}}) topic for instructions.

{{< see-also >}} Refer to the [Provision users and groups with SCIM]({{< ref "/nim/admin-guide/authentication/oidc/scim-provisioning.md" >}}) topic for instructions on automating user and group creation using the SCIM API. {{< /see-also >}}


## Set user passwords {#set-basic-passwords}

{{< before-you-begin >}}
Before you can set users' passwords, ensure you have [created users](#create-users) in NGINX Instance Manager. Once you've created the users, you can use one of the following options to set their passwords.
{{< /before-you-begin >}}

### (Recommended) Use the provided script {#set-basic-passwords-script}

You can use the `basic_passwords.sh` script to add a user's encrypted password to the `/etc/nms/nginx/.htpasswd` file on the NGINX Instance Manager host.

{{<note>}}The `basic_passwords.sh` script requires the [OpenSSL](https://www.openssl.org) package. We strongly recommend **OpenSSL v1.1.1 or later**.{{</note>}}

To change a user's password with the `basic_passwords.sh` script:

1. Open an SSH connection to your NGINX Instance Manager host and log in.
2. Run the `basic_passwords.sh` script, providing the username you want to update and the desired password. Be sure to enclose the password in single quotation marks.

    ```bash
    sudo bash /etc/nms/scripts/basic_passwords.sh <username> '<desired password>'
    ```

    For example:

    ```bash
    sudo bash /etc/nms/scripts/basic_passwords.sh johndoe '<password>'
    ```

### Manually set user passwords {#manually-set-basic-passwords}

To manually set user passwords:

1. Open the `/etc/nms/nginx/.htpasswd` file on the NGINX Instance Manager host and add the username and password for each user.
2. Save the changes to the file.

{{< see-also >}}Refer to the documentation [Restricting access with HTTP basic auth]({{< ref "/nginx/admin-guide/security-controls/configuring-http-basic-authentication.md" >}}) for detailed instructions on working with the password file.{{< /see-also >}}

## Making API requests with basic authentication

{{< include "nim/admin-guide/auth/basic-auth-api-requests.md" >}}

## Ending your browser session

With basic authentication, NGINX Instance Manager does not have a "Log Out" button. To end your session, close the web browser you're using.

Closing the browser will void the authentication token or session cookie tied to your account. This step is essential for securing your account and preventing unauthorized access to NGINX Instance Manager.
