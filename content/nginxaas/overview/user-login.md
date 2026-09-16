---
title: User login
weight: 350
toc: true
f5-docs: DOCS-000
url: /nginxaas/overview/user-login/
f5-product: F5 NGINXaaS
f5-content-type: how-to
f5-keywords: "login,authentication"
f5-summary: >
    Use this guide to sign up to NGINXaaS using an email address and password. The guide includes instructions on how to reset a password and how to grant admin consent for users of an Entra tenant to use the F5 Social Login Entra app.
f5-audience: operator
---

## Overview

NGINXaaS authenticates users through three login methods:

- Microsoft social login
- Google social login
- Email and password

If a user signs in through Microsoft social or Google social, they interact with [Google authentication](https://docs.cloud.google.com/architecture/identity/overview-google-authentication) or the [Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/v2-overview) to establish their identity. Alternatively, the user can register a email address and password directly with our service.

## Sign up with email and password

If a user wishes to register with an email address and password, they must follow these steps:

1. Select **Sign In** on the main console page.
1. On the login page, select **Sign up** in the email address input form.
1. Enter a valid email address and select **Continue**.
1. Check your email account for a six-digit verification code.
1. Enter the verification code in the browser.
1. Choose a password and select **Continue**.
1. Authenticate with our service using the email and password you have chosen.

## Password reset

If you want to reset your password, follow these steps:

1. Select **Sign In** on the main console page.
1. On the login page, enter email address and select **Continue**.
1. On the password entry page, select **Reset password**.
1. On the next page, confirm the email address and select **Continue**.
1. Check your email account for a six-digit verification code.
1. Enter the verification code in the browser.
1. Enter a new password and then select **Reset password**.
1. Use the new password to authenticate with our service.

## Password standards

A valid password must contain:

- At least 14 characters
- No more than 2 identical characters in a row
- At least one special character (!@#$%^&*)
- At least one lower case character (a-z), one upper case character (A-Z) and one number (0-9)

## Entra configuration for Microsoft social login

Depending on the configuration of an Entra tenant, administrators may need to follow these steps before users can log in with F5's Entra app and the Microsoft identity platform.

1. Sign in to the service on the main console page
1. Select **Continue with Microsoft**
1. After signing in with Microsoft, on the **Permissions requested** prompt for the **F5 - Inc Social Login** Entra app, select **Accept**
1. At this point, you can abort the login to NGINXaaS if you wish
1. Go to the Azure portal and go to **Entra** -> **Enterprise Applications**
1. Select the **F5 Inc - Social Login** Entra app
1. Under **Permissions**, select **Grant admin consent**
1. Users of your Entra tenant should now be able to use Microsoft social login to authenticate with NGINXaaS

See [Entra guidance on granting admin consent](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/grant-admin-consent?pivots=portal) for further details.

- The app ID (client ID) of the **F5 Inc - Social Login** Entra app is `4aef7a9d-810c-4746-8a6a-6c5d43e4e5f2`.
- The tenant ID is `dd3dfd2f-6a3b-40d1-9be0-bf8327d81c50`.
- The app requires the following Microsoft Graph API permissions: `email`, `openid`, `profile` and `User.Read`.