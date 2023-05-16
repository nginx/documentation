---
title: "Enable Single Sign-On for Developer Portal"
date: 2021-12-21T12:00:00-07:00
description: "Learn how to enable Single Sign-On for Developer Portal."
# Assign weights in increments of 100
weight: 400
toc: true
tags: [ "docs" ]
docs: "DOCS-928"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["API Connectivity Manager", "policies", "OIDC", "developer portal"]
doctypes: ["task"]
docs: 
aliases:
- /acm/how-to/setup-oidc-devportal/

---

<style>
    h2 {
        margin-top: 30px;
    }
    h3 {
        margin-top: 30px;
    }
    h4 {
        font-weight: bold;
        margin-top: 30px;
    }
    hr {
        margin-top: 40px; margin-bottom: 40px;
    }

</style>

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

Single sign-on (SSO) can be enabled on the Developer Portal to secure access to the portal and to allow authenticated API consumers to manage resource credentials. Logged-in consumers can then self-manage resource credentials for the APIs. 

Single sign-on is enabled by applying an OpenID Connect (OIDC) policy on the Developer Portal. The OIDC policy sets up the portal proxy to act as a relying party to authenticate users with the OIDC provider.

### Before You Begin

Complete the following prerequisites before proceeding with this guide:

- ACM is installed, licensed, and running. See [ACM Install Guide]({{< relref "/nms/installation/vm-bare-metal/_index.md" >}}).
- You have one or more Environments with [API Gateways]({{< relref "/nms/acm/getting-started/add-api-gateway" >}}) or [Developer Portals]({{< relref "/nms/acm/getting-started/add-devportal" >}}).

### Terminology

The following terminology is used in this topic:

{{<bootstrap-table "table table-striped table-bordered">}}
| Term                     | Description                                                                                                                                                                                                                                                                                                                  |
|--------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AuthCode                 | Authorization Code.                                                                                                                                                                                                                                                                                                          |
| IDP                      | Identity Provider stores and verifies a user's identity as a service.                                                                                                                                                                                                                                                        |
| IDP Authorization Server | The IDP Authorization Server authenticates and issues access tokens to users.                                                                                                                                                                                                                                                |
| OAuth                    | OAuth is an open-standard authorization protocol.                                                                                                                                                                                                                                                                            |
| OIDC                     | OpenID Connect is an authentication protocol that adds an identity verification layer.                                                                                                                                                                                                                                       |
| PKCE                     | Proof Key for Code Exchange. When public clients request Access Tokens, some additional security concerns are posed that are not mitigated by the Authorization Code Flow alone. PKCE needs the clients app to provide proof to the authorization server, to verify that the authorization code belongs to the clients' app. |
| URI                      | Uniform Resource Indicator. It is a unique character sequence which distinguishes one resource from another.                                                                                                                                                                                                                 |
{{</bootstrap-table>}}

### Supported OIDC Identity Providers

API Connectivity Manager supports the following identity providers:

- Keycloak
- Okta
- Azure AD

Refer to the NGINX Plus [Single Sign-On](https://docs.nginx.com/nginx/deployment-guides/single-sign-on/) deployment guides to learn how to configure NGINX Plus for use with these identity providers. The guides describe where to find the information from the identity provider that you will need to provide when setting up OIDC in ACM.

## Set up OIDC Policy

{{< include "acm/how-to/setup-oidc.md" >}}

Single sign-on (SSO) is enabled on the Developer Portal after configuring the OIDC policy. Application developers can log in through the configured centralized identity provider (IDP). After a successful login, they can create resource credentials for the available APIs.

## Known Limitation with the policy

The OIDC policy does not yet support custom DNS for resolution. Only external DNS resolution is supported.
