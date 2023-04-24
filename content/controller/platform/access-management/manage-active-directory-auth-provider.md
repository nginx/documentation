---
authors: []
categories:
- platform management
- security
date: "2020-10-26T15:32:41-06:00"
description: Set up Active Directory authentication for NGINX Controller using OIDC with Azure Active Directory or LDAP, LDAPs, and StartTLS with Windows Active Directory.
docs: DOCS-782
doctypes:
- tutorial
draft: false
journeys:
- using
menu:
  docs:
    parent: Access Management
personas:
- netops
- secops
roles:
- admin
tags:
- docs
title: Configure Active Directory Integration
toc: true
weight: 10
---

## Overview

By completing the steps in this guide, you will learn how to add an Active Directory (AD) integration to NGINX Controller. NGINX Controller supports the following AD types and protocols:

- Azure Active Directory: OpenID Connect (OIDC) over HTTPS;
- Windows Active Directory: unencrypted LDAP, LDAPS, and StartTLS.

## Before You Begin

Before proceeding with this guide, complete the steps in the appropriate prerequisites section for the type of Active Directory integration that you want to create.

### Azure Active Directory {#azure-prerequisites}

To configure an auth provider in Azure Active Directory using OIDC over HTTPS, complete the following prerequisites.

1. Create an Azure Active Directory Tenant and App Registration.

   Refer to the Microsoft Azure AD Quick Start Guide for instructions: 
   - [Set up Azure Active Directory Tenant](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-create-new-tenant)
   - [Register App](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)

1. Record your tenant ID, as well as the Client ID and Client Secret(s) for your App. Keep them handy, you will need this information to set up the Azure AD Auth Provider in NGINX Controller.

    {{< important >}}Microsoft Azure will only display the Client Secret once, during the App Registration process. Be sure to keep this information somewhere safe so you can refer to it later.{{< /important >}}

1. Add the following application permissions to the App Registration's "Microsoft Graph" API:

    - Group.ReadAll
    - GroupMember.ReadAll
    - User.Read
    - User.ReadAll

    {{< tip >}}These permissions require approval from the Azure admin. {{< /tip >}}

1. Make sure that you can contact Azure Active Directory from the host on which you are running NGINX Controller.

### Windows Server Active Directory {#windows-prerequisites}

To configure an auth provider in Active Directory over LDAP, LDAPS, or StartTLS, complete the following prerequisites.

1. Install Active Directory Domain Forest.
   Refer to the Microsoft Windows Server documentation for instructions: [Install Windows Server Active Directory Forest (Level 200)](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-a-new-windows-server-2012-active-directory-forest--level-200-)

1. Enable LDAP over SSL.

    In order to use a secure means of communication like LDAPS or StartTLS, you need to enable LDAP over SSL with a certification authority. Refer to the following Microsoft user guides for instructions:

    <div data-proofer-ignore>

    - [LDAP over SSL (LDAPS) Certificate](https://social.technet.microsoft.com/wiki/contents/articles/2980.ldap-over-ssl-ldaps-certificate.aspx)
    - [Enable LDAP over SSL with a third-party certification authority](https://docs.microsoft.com/en-us/troubleshoot/windows-server/identity/enable-ldap-over-ssl-3rd-certification-authority)
    </div>

1. Make sure that you can connect to your Windows Active Directory server from the host on which you are running NGINX Controller.

## Create an Authentication Provider

Take the steps below to create a new Authentication Provider by using the NGINX Controller user interface.

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Auth Providers**.
1. On the **Auth Providers** menu, select the **Create Auth Provider** quick action.
1. Select the desired type of authentication provider in the **Authentication Provider Type** list. 
1. Next, proceed to the appropriate section for the type of Authentication Provider you selected:

   - [Azure Active Directory](#setup-azure-ad)
   - [Windows Active Directory](#setup-windows-ad)
   
## Set up an Azure Active Directory Auth Provider {#set-up-azure-ad}

{{< fa "arrow-circle-right" >}} **Introduced in NGINX Controller ADC v3.22**

In the previous section, you selected **Azure Active Directory** from the **Authentication Provider Type** list. Next, you'll set up the Auth Provider so it can connect to Azure Active Directory (AD).

1. Add a name for the Auth Provider.

    {{< important >}}This name is a permanent setting that cannot be changed.{{< /important >}}

    This is the name that your users will be able to select as the authentication provider when logging in to NGINX Controller. Be sure the name you provide is accurate and easy to identify. 

1. (Optional) Add a display name. This will be displayed in the NGINX Controller user interface.
1. (Optional) Add a description.
1. Select **Next**.

### Set up OpenID Connect

On the Auth Provider *OIDC Config* page, provide the following settings:

1. Provider URI: This is the authority URL that authorizes access to the OpenID Connect (OIDC) metadata document. NGINX Controller forwards authentication requests to this URL. This URL contains the `{tenant}` that you created earlier.

   Refer to the [Microsoft Azure AD OIDC documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-protocols-oidc#fetch-the-openid-connect-metadata-document) for more information about the OIDC responses.

   For example, the following Provider URI would allow users from the specified Azure Active Directory (AD) tenant to log in to NGINX Controller:

    ```lang-none
    "https://login.microsoftonline.com/12345678-90ab-cdef-1234-567890abcdef/v2.0"
    ```

1. Client ID: This is the client ID from your Azure AD App Registration.

1. Client Secret: This is the secret that you created with your Azure AD App Registration.

1. Scopes: This defines the permissions the Auth Provider requests from Azure. 

    The default scopes are:

    ```lang-none
    openID,email,profile
    ```

    Any custom scopes should follow the same comma-separated format as the example above.

1. Select **Next**.

### Set up Azure Active Directory Groups {#set-up-azure-groups}

On the NGINX Controller Auth Provider *Group Setup* page, provide the following information:

1. (Optional) Poll interval: This is the interval at which NGINX Controller fetches updated information, including the Groups list, from Azure Active Directory (AD). 

    - The value must be defined in seconds.
    - The minimum allowed value is 300 seconds (5 minutes).
    - The default value is 3600 seconds (1 hour).

    {{< important >}}
Consider how you want to set this field carefully.  
While deletions in Azure AD are reflected in NGINX Controller immediately, changes such as group permission updates or user reassignments are not. This means that, when using the default poll interval, it could take up to an hour for changes in Azure AD to be reflected in NGINX Controller.
    {{< /important >}}

1. (Optional) Cache timeout: This is the time, in seconds, to wait before considering the AD Groups list to be outdated, or, "stale". 

    - This value should be double the poll interval. 
    - The minimum allowed value is 600 seconds (10 minutes).
    - The default value is 7200 seconds (2 hours).

1. (Optional) Honor stale Azure Active Directory groups: This setting determines whether NGINX Controller will allow or deny login requests from users in stale AD groups.

    - `ENABLE` - Honor stale Azure AD groups.
    - `DISABLE` (default) - Do not honor stale Azure AD groups.

1. (Optional) Group search filter: This is the search filter that you want to use to return group results. 

    - This value **must be enclosed in parentheses**. 
    - The allowed syntax for the filters can be found in the [Microsoft documentation](https://docs.microsoft.com/en-us/graph/query-parameters#filter-parameter).
    - The default behavior is to return the first 100 groups. 
    - You need to set up Groups if you want to use NGINX Controller role-based access control (RBAC). 

1. Select **Next** to review and record the NGINX Controller API call that sets up the Azure AD auth provider. 
1. Select **Submit** to create the Auth Provider. The NGINX Controller UI will display a redirect URI when the Auth Provider setup is complete.  
1. Copy the redirect URI and add it to your Azure App Registration.
   Refer to the Microsoft Azure AD Quick Start guide for instructions: [Add a Redirect URI](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app#add-a-redirect-uri).

### Set Up Role-Based Access Control with Azure AD {#set-up-rbac-azure-ad}

In order to use role-based access control (RBAC) with Azure Active Directory (AD), you need to map groups from the Azure AD tenant to NGINX Controller RBAC roles. 

{{< important >}}
You should complete this step immediately after creating the Azure AD authentication provider, before any other changes can be made.
{{< /important >}}

1. If you haven't already done so, [create the Role(s) and Role group]({{< relref "manage-roles" >}}) that you want to map the Azure AD permissions to. 
1. On the **Platform** menu in the NGINX Controller user interface, select **Auth Providers**, then select the Auth Provider that contains the Azure AD configuration.
1. Set up the Auth Provider *Group Mappings*:

    - Provide the name of the Azure AD Group that you want to use.

      {{< tip >}}The Group filter determines which Groups are available for this setting. Be sure the Group that you want to add is included by your group filter. {{< /tip >}}

    - (Optional) Provide the **Case Sensitive** setting:

        - `ENABLE`:  match the case of the external group name exactly.
        - DISABLE` (default): the match should be case-insensitive.

    - Select the name of the NGINX Controller role group that you want to map the Azure AD group to.

    - Select **Next** to review and record the NGINX Controller API call that sets up the Azure AD Group mappings. 
    - Select **Submit** to complete the RBAC setup.

## Set up a Windows Active Directory Auth Provider {#set-up-windows-ad}

In the previous section, you selected **Active Directory** from the **Authentication Provider Type** list. Next, you'll set up the Auth Provider so it can connect the Windows Active Directory (AD).

1. Add a name for the Auth Provider.

    {{< important >}}This name is a permanent setting that cannot be changed.{{< /important >}}

    This is the name that your users will be able to select as the authentication provider when logging in to NGINX Controller. Be sure the name you provide is accurate and easy to identify. 

1. (Optional) Add a display name. This will be displayed in the NGINX Controller user interface.
1. (Optional) Add a description.
1. Select the username format:

    - `User Domain`: follows the format `DOMAIN\username`
    - `UPN` (User Principle Name): uses the standard email format, for example `username@domain.com`

1. Specify the login domain.

    The login domain applies to usernames that don't have a domain specified (for example, if a user logs in as "nedflanders", as opposed to `EVERGREEN\nedflanders` or `nedflanders@evergreen.ter`). 

1. Select **Next**.

### Set up the Active Directory Connection

On the Auth Provider *Connection* page, provide the following settings:

1. The LDAP domain to authenticate against as a domain-component. 
    
    - NGINX Controller can bind to **one domain** for each configured Active Directory (AD) Authentication Provider. 
    - **This field cannot be updated**.

    For example:

    ```lang-none
    DC=mydomain,DC=example,DC=com
    ```  

1. Add the connection URI.

    For example:

    ```lang-none
    ldap://dc1.mydomain.com
    ```

    -Or-

    ```lang-none
    ldaps://dc2.mydomain2.com
    ```

1. In the **SSL Parameters** list, select the SSL connection mode.  
    NGINX Controller supports the following options for  connections from NGINX Controller to the Active Directory server:

    - `PLAIN_TEXT` (Not secured) - Unencrypted connection. Does not require SSL certificates.

      {{< warning >}}
Use this mode only if you accept the risks associated with using unencrypted LDAP. Data travels "as is," without encryption, and can be spied upon by passive attackers. Not recommended for production environments.
      {{< /warning >}}

    - `REQUIRE` (Default) - Require an SSL connection. NGINX Controller trusts the certificate that the Active Directory server provides, and no certificate authority (CA) is required. **Unencrypted connections will fail**.

    - `VERIFY_CA`(Most secure) - **Recommended for production environments**. Verify the certificate authority of the Active Directory connection. The server is verified by checking the certificate chain up to the root certificate stored on the client.

1. (Optional) Add the certificate to use for verification.  
    
    - If you generated a self-signed certificate for Active Directory Certificate Services, or if the certificate wasn't issued by a certificate authority, then you must add the certificate to use for verification.
    - You can either paste the certificate into the **Certificate** form or upload the file.

1. Select **Next**.

### Set Up the Active Directory User Binding {#set-up-ad-user-binding}

On the Auth Provider *User Binding* page, provide the following settings that will allow NGINX Controller to authenticate to the Active Directory (AD.

1. Authentication type: The type of authentication to use to connect to the Active Directory (AD).
1. Bind username: This is a username that will be used to access the AD. 
    For example, `domain\example.user` or `example.user@mydomain`. 

    {{< tip >}}
You can use either format. This setting isn't governed by the username format that you defined on the Auth Provider *Connection* page.
    {{< /tip >}}
1. Bind user password: The password for the user account that will be used to connect to the AD.
1. Select **Next**.

### Set up Active Directory Groups {#set-up-windows-ad-groups}

On the NGINX Controller Auth Provider *Group Setup* page, provide the following information:

1. (Optional) Poll interval: This is the interval at which NGINX Controller fetches updated information, including the Groups list, from the Active Directory (AD). 

    - The value must be defined in seconds.
    - The minimum allowed value is 300 seconds (5 minutes).
    - The default value is 3600 seconds (1 hour).

    {{< important >}}
Consider how you want to set this field carefully.  
While deletions in the AD are reflected in NGINX Controller immediately, changes such as group permissions updates or user reassignments are not. This means that, when using the default poll interval, it could take up to an hour for changes to the AD to be reflected in NGINX Controller.
    {{< /important >}}

1. (Optional) Cache timeout: This is the time, in seconds, to wait before considering the AD Groups list to be outdated, or, "stale". 

    - This value should be double the poll interval. 
    - The minimum allowed value is 600 seconds (10 minutes).
    - The default value is 7200 seconds (2 hours).

1. (Optional) Honor stale Active Directory groups: This setting determines whether NGINX Controller will allow or deny login requests from users in stale AD groups.

    - `ENABLE` - Honor stale AD groups.
    - `DISABLE` (default) - Do not honor stale AD groups.

1. (Optional) Group search filter: This is the search filter that you want to use to return group results within a root domain. This value **must be enclosed in parentheses**. 
    
    Examples:
    - Search all groups under the base domain: 

      ```lang-none
      (objectClass=group)
      ```

    - Match more than one attribute using the ampersand symbol (`&`):

      ```lang-none
      (&(objectClass=group)(CN=devops))
      ```

      In the above example, the `&` means that we want to search for `objectClass=group` **AND** `CN=devops`. You can compound as many clauses as you need.

    - Match one or more attributes use the pipe symbol (`|`):

      ```lang-none
      (&(objectClass=group)(|(CN=devops)(CN=quality_assurance))
      ```

      In the above example, the `|` means that we want to search for `CN=devops` **OR** `CN=quality_assurance`.

    - Match wildcards using the asterisk symbol (`*`):

      ```lang-none
      (&(objectClass=group)(CN=*Engineering*))
      ```

      In this example, we've combined the `&` with a wildcard (`*`) to search for results in 
 `objectClass=group` **AND** for CN that includes the word 'Engineering'.

    - Exclude entities using the exclamation point '!':

      ```lang-none
      (&(objectClass=group)(&(ou:dn:=Seattle)(!(ou:dn:=Fremont))))
      ```

      In this example, we want to find all Seattle groups **except** those with a Fremont OU component.

1. Add a group member attribute, **without parentheses**. This LDAP attribute identifies a user as a member of an Active Directory group.

    For example:

    ```lang-none
    memberOf
    ```

1. Select **Next**.

### Set up Role-Based Access Control with Active Directory {#set-up-windows-ad-rbac}

In order to use role-based access control (RBAC) with Active Directory (AD), you need to map groups from the AD to NGINX Controller RBAC roles. 

1. If you haven't already done so, [create the Role(s) and Role group]({{< relref "manage-roles" >}}) that you want to map the AD permissions to. 
1. On the **Platform** menu in the NGINX Controller user interface, select **Auth Providers**, then select the Auth Provider that contains the AD integration.
1. Add the name of the external AD group that you want to map to.

    For example:

    ```lang-none
    CN=devops,OU=Distribution Lists,OU=Groups
    ```

1. (Optional) Specify the **Case Sensitive** setting:

    1. `ENABLE`:  match the case of the external group name exactly.
    1. `DISABLE` (default): the match should be case-insensitive.

1. Select the name of the NGINX Controller Role group that you want to map to.
1. Select **Next** to review and record the NGINX Controller API call that sets up the AD integration. 
1. Select **Submit** to create the Authentication Provider.

## Manage an Existing Authentication Provider {#manage-auth-provider}

{{< include "auth-providers/view-edit-delete-auth-provider.md" >}}

## Troubleshooting

{{< include "auth-providers/troubleshooting-active-directory-auth-provider.md" >}}

{{< versions "3.6" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
