---
description: Learn how to manage user access in F5 NGINX Management Suite using basic
  authentication with NGINX as a front-end proxy. This guide covers first-time login,
  creating additional users, and setting passwords.
docs: DOCS-792
doctypes:
- tutorial
tags:
- docs
title: Set Up Basic Authentication
toc: true
weight: 10
---

<style>
h2 {
  border-top: 1px solid #ccc;
  padding-top:20px;
}
</style>

## Overview

F5 NGINX Management Suite uses NGINX as a front-end proxy and for user access. By default, NGINX Management Suite uses basic authentication, which means you need to send your username and password with each request to confirm your identity. When logging in to NGINX Management Suite for the first time, use the default `admin` account and password. After that, you can create additional user accounts. Adding users and setting passwords are explained below.

{{< call-out "warning" "Security Consideration" >}} While convenient, basic authentication is less secure than other methods: credentials are sent as base64-encoded text, which is not secure encryption. If your data gets intercepted, the encoding is easily reversible. If you use NGINX Plus for your front-end proxy, consider [switching to OpenID Connect (OIDC) for authentication]({{< relref "nms/admin-guides/authentication/oidc/getting-started-oidc.md" >}}). For production environments, we strongly recommend OIDC.{{< /call-out >}}

## Default Admin User

When you install NGINX Management Suite, a default `admin` user is created with a randomly generated password that's displayed in the installation output.

You can change the default `admin` password by running the script that's provided or manually editing the `/etc/nms/nginx/.htpasswd` file. For instructions, see the [Set User Passwords](#set-basic-passwords) section below.

The `admin` user is associated with an [admin role]({{< relref "nms/admin-guides/rbac/rbac-getting-started.md" >}}) that grants full permissions for all modules and features. You can delete the `admin` user, but only after assigning the admin role to another user. The admin role cannot be deleted and must be assigned to at least one user.

## Create New Users {#create-users}

{{< include "admin-guides/auth/add-users.md" >}}

## Set User Passwords {#set-basic-passwords}

{{< before-you-begin >}}
Before you can set users' passwords, you need to [create users](#create-users) in NGINX Management Suite. Once you've created the users, select from the following options to set their passwords.
{{< /before-you-begin >}}

### (Recommended) Use the Provided Script {#set-basic-passwords-script}

You can use the `basic_passwords.sh` script to add a user's encrypted password to the `/etc/nms/nginx/.htpasswd` file on the NGINX Management Suite server.

{{<note>}}The `basic_passwords.sh` script requires the [OpenSSL](https://www.openssl.org) package. We strongly recommend **OpenSSL v1.1.1 or later**.{{</note>}}

To change a user's password with the `basic_passwords.sh` script:

1. Open an SSH connection to your NGINX Management Suite host and log in.
2. Run the `basic_passwords.sh` script, providing the username you want to update and the desired password. Make sure to enclose the password in single quotation marks.

    ```bash
    sudo bash /etc/nms/scripts/basic_passwords.sh <username> '<desired password>'
    ```

    For example:

    ```bash
    sudo bash /etc/nms/scripts/basic_passwords.sh johndoe 'jelly22fi$h'
    ```

### Manually Set User Passwords {#manually-set-basic-passwords}

To manually set user passwords:

1. Open the `/etc/nms/nginx/.htpasswd` file on the NGINX Management Suite host and add the username and password for each user.
2. Save the changes to the file.

{{< see-also >}}Refer to the documentation [Restricting Access with HTTP Basic Auth]({{< relref "/nginx/admin-guide/security-controls/configuring-http-basic-authentication.md" >}}) for detailed instructions on working with the password file.{{< /see-also >}}


## Making API Requests with Basic Authentication

{{< include "admin-guides/auth/basic-auth/basic-auth-api-requests.md" >}}

## Ending Your Browser Session

With basic authentication, NGINX Management Suite doesn't offer a "Log Out" button. To end your session, just close the web browser you're using.

When you close the browser, it voids the authentication token or session cookie tied to your account. This step is crucial for securing your account and blocking unauthorized access to NGINX Management Suite.
