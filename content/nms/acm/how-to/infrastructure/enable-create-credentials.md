---
description: Follow the steps in this guide to allow users to create credentials as
  a self-service workflow on the Developer Portal.
nd-docs: DOCS-947
title: Enable Creating Credentials on the Developer Portal
toc: true
weight: 400
type:
- how-to
---

{{< raw-html >}}
<style>
    h2 {
        margin-top: 30px;
        margin-bottom: 10px;
    }
    h3 {
        margin-top: 30px;
        margin-bottom: 10px;
        font-weight: 300;
        font-size: 1.75em;
    }
    h4 {
        margin-top: 30px;
        font-size: 20px;
    }
    hr {
        margin-top: 40px;
        margin-bottom: 20px;
    }
</style>
{{< /raw-html >}}
## Overview

API Connectivity manager supports public API workflows. Public APIs are open for anyone to consume by requesting resource credentials. Resource credentials can be managed on the Developer Portal for public APIs secured with APIKey or Basic Authentication. Consumers have to log in to the Developer Portal to create credentials. Once created, credentials can be used to access APIs. Users can also use the credentials to test APIs on the Developer Portal with the **Try It Out** feature.

### Before You Begin

To complete the steps in this guide, you need to the following:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more environments with [API Gateway]({{< ref "/nms/acm/getting-started/add-api-gateway" >}}) or [Dev Portal]({{< ref "/nms/acm/getting-started/add-devportal" >}}) clusters.

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

---

## Self-Managed Credentials Workflow

On the Developer Portal, logged-in users can create credentials for public APIs. Since this workflow is available only for logged-in users, the OIDC policy must be applied on the Developer Portal to enable SSO with an IDP of choice. In addition, the API proxies should be secured with either Basic Authentication or APIKey authentication policy.

The process for setting up end-to-end credentials is as follows:

- Enable the Credentials endpoint on the API Connectivity Manager host
- Enable SSO on the Developer Portal with an OIDC policy
- Publish the API Proxy and secure it by adding an APIKey or Basic Authentication policy

Afterward, the API consumer can create credentials on the Developer Portal by performing the following:

- API consumer logs in to developer portal, creates org, app, and credentials for the API.
- Test the API with the **Try It Out** option and the newly created credentials.

### Enable Create Credentials Endpoint

As mTLS is not enabled by default, the Credentials endpoint is disabled initially. You must enable the Credentials endpoint on the API Connectivity Manager host to use the Developer Portal credentials workflow.

{{< call-out "important" >}}mTLS is essential to secure communication between API Connectivity Manager and the Developer Portal.{{< /call-out >}}

To enable the Credentials endpoint on the API Connectivity Manager host, take the following steps:

1. Make sure mTLS server and client certificates have been configured for Devportal to F5 NGINX Management Suite by following these [instructions]({{< ref "/nms/acm/how-to/devportals/installation/install-dev-portal.md#secure-communication-from-the-developer-portal-to-nginx-management-suite-host-with-mtls" >}}) to add your server certs, CA file and enforce mTLS.

1. Open an SSH connection into the API Connectivity Manager host and log in.

1. Enable the Credentials endpoint:

   Open `/etc/nms/nginx/locations/nms-acm.conf` for editing and uncomment the location block.

    ``` yaml
    # Deployment of resource credentials from the devportal
    # Uncomment this block when using devportal. Authentication is disabled
    # for this location. This location block will mutually
    # verify the client trying to access the credentials API.
    location = /api/v1/devportal/credentials {
            # OIDC authentication (uncomment to disable)
            #auth_jwt off;
            auth_basic off;
            error_page 401 /401_certs.json;
            if ($ssl_client_verify != SUCCESS) {
              return 401;
            }
            proxy_pass http://acm-api-service/api/acm/v1/devportal/credentials;
    }
    ```

1. Save the changes.

1. Reload NGINX on the API Connectivity Manager host:

    ```bash
    sudo nginx -s reload
    ```

### Enable SSO on the Developer Portal

1. Follow the instructions to [enable single sign-on (SSO) for the Developer Portal]({{< ref "/nms/acm/how-to/infrastructure/enable-sso-devportal.md" >}}) with an OIDC policy.

### Publish and Secure the API Proxy

A link to **Edit Advanced Configurations** is displayed upon publishing the API Proxy. If you want to add policies, this is where to do that.

To add an APIKey Authentication policy:

1. Select **Policies** in the advanced section of the menu.
2. Select **Add Policy** for the APIKey Authentication policy, then complete the required information in the form.
3. (Optional) To quickly test the setup, you can create a test credential. Add a credential by selecting **Add APIKey** and specifying **Client ID** and **APIKey**.
4. Select **Add Policy**.
5. Select **Save and Publish**.

#### Add a CORS Policy

Depending on the domain, you might need to add a CORS policy to the API proxy in order to use the **Try It Out** feature on the Developer Portal.

To add a CORS policy:

1. Select the **Policies** menu item in the advanced section of the menu.
2. Select **Add Policy** for the CORS policy. then complete the required information in the form.
3. Add the header used in the APIKey policy above to the **OPTIONS** request.
4. Select **Add Policy**.
5. Select **Save and Publish**.

### Create Credentials

Log in to the Developer Portal as an API Consumer. Use the **Create Credentials** option to create credentials for the API.

{{< call-out "important" >}}

  To avoid misuse, the API Consumer may create only one APIKey per API.

{{< /call-out >}}

### Try It Out on the Developer Portal

Once the credentials have been created and are available, you can use the **Try It Out** feature on the Developer Portal to test the API using the newly created credentials.
