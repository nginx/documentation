---
categories:
- installation
- security
date: "2021-12-21T12:00:00-07:00"
description: ''
doctypes:
- tutorial
draft: false
journeys:
- getting started
- using
personas:
- devops
- netops
- secops
- support
tags:
- docs
title: Set Up Basic Authentication
toc: true
versions: []
weight: 10
docs: "DOCS-792"
aliases:
- /nginx-instance-manager/admin-guide/authentication/
- /nginx-instance-manager/admin-guides/access-control/configure-authentication/
- /nim/admin-guide/authentication/

---

{{<custom-styles>}}

<style>
h2 {
  border-top: 1px solid #ccc;
  padding-top:20px;
}
</style>

{{< warning >}}
Basic authentication is not recommended for production environments due to its inherent security limitations. Consider using [OpenID Connect (OIDC)]({{< relref "/nms/admin-guides/authentication/_index.md" >}}) or another secure authentication method instead.
{{< /warning >}}

## Overview

The NGINX Management Suite platform uses NGINX as a front-end proxy and for user access management. By default, NGINX Management Suite employs basic authentication, which involves sending the username and password with each request. However, if NGINX Plus is installed as the front-end proxy, you can [enable OpenID Connect (OIDC) authentication]({{< relref "/nms/admin-guides/authentication/oidc/_index.md" >}}). We highly recommend using OIDC authentication in production environments due to its superior security over basic authentication. Regardless of your authentication preference, to access the NGINX Management Suite REST API or web interface for the first time, you need to log in using basic authentication with the default `admin`, which is created during installation.


## Default Admin User

When you install NGINX Management Suite, a default `admin` user is created with a randomly generated password that's displayed in the installation output.

You can change the default `admin` password by running the script that's provided or manually editing the `/etc/nms/nginx/.htpasswd` file. For instructions, see the [Set User Passwords](#set-basic-passwords) section below.

The `admin` user is associated with an [admin role]() that grants full permissions for all modules and features. You can delete the `admin` user, but only after assigning the admin role to another user. The admin role cannot be deleted and must be assigned to at least one user.

## Create New Users {#create-users}

{{< include "admin-guides/auth/add-users.md" >}}

## Set User Passwords {#set-basic-passwords}

{{< before-you-begin >}}
Before you can set users' passwords, you need to [create users](#create-users) in NGINX Management Suite. Once you've created the users, select from the following options to set their passwords.
{{< /before-you-begin >}}

### (Recommended) Use the Provided Script {#set-basic-passwords-script}

{{< include "admin-guides/auth/set-user-passwords-script.md" >}}

### Manually Set User Passwords {#manually-set-basic-passwords}

{{< include "admin-guides/auth/set-user-password-manually.md" >}}


## Using the API

{{< include "admin-guides/auth/basic-auth/basic-auth-api-requests.md" >}}

## Clearing Credentials

Due to the way Basic Authentication works, there is no explicit "Log Out" button in the NGINX Management Suite web interface. To end your authenticated session, simply close the web browser you are using.

By closing the browser, you will invalidate the authentication token or session cookie associated with your credentials. This important step helps maintain the security of your account and prevents unauthorized access to NGINX Management Suite.
