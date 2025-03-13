---
description: Create and Manage Identity Providers.
docs: DOCS-571
title: Manage Identity Providers
toc: true
weight: 140
type:
- tutorial
---

## Overview

The **Identity Providers** page lets you create and manage Identity Providers to control access to your services (APIs for API Management module deployments, and Apps for App Delivery module deployments).

{{< tip >}}
If you prefer, you can use the F5 NGINX Controller API to create and manage Identity Providers. See the [NGINX Controller API reference guide]({{< relref "/controller/api/_index.md" >}}) (**Security > Identity Providers**) for details.
{{< /tip >}}

## Before You Begin

{{< important >}}

You must set up NGINX Plus to use the `njs` module to use API key authentication.

{{< /important >}}

### Set up NGINX Plus Instances to Secure API Keys

When using API keys for authentication, the API key is written to the NGINX Plus config as cryptographically-protected hashes.

To use API key authentication for any element of NGINX Controller, you must install the `njs` module on all NGINX Plus instances.

If you do not install the `njs` module and use API key authentication, whether for API Management or elsewhere, the system may experience errors that are not reported in the user interface.

> See the [NGINX Admin Guide](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/) for `njs` installation instructions.

## Add an Identity Provider

Take the following steps to create an Identity Provider:

1. Open the NGINX Controller user interface and log in.

2. Select the NGINX Controller menu icon, then select **Services**.

3. On the **Services** menu, select **Identity Providers**.

4. On the **Identity Provider** page, select **Create an Identity Provider**.

5. Provide a name.

6. Select an Environment, or to [Create an Environment]({{< relref "/controller/services/manage-environments.md" >}}), select **Create New**.

7. Select the option to use an **API key** or a **JWT** (JSON Web Token).

    a. **API Key**:

      - Select **Import** to upload a `.csv` file containing Client names and keys.

        **--OR--**

      - Select **Create a Client** and provide a name for the Client. You can use the system-generated key or provide one of your own.

        {{< note >}}
Keys must be between 8 and 256 characters and alphanumeric.

- Hyphens '-' and underscores '_' are allowed.
- Other special characters are not allowed.
        {{< /note >}}

    b. **JWT**:

      Create a new JWT Client Group by choosing one of the following options:

  - Paste the contents of a `.jwk` file into the text box

  - Provide the URL of the `.jwk` file's location. NGINX Controller fetches the URL, caches it, and refreshes the cache every 12 hours. If the cache cannot be refreshed, the previous version of the `.jwk` is used.

8. Select **Create**.

## Remove an Identity Provider

1. Open the NGINX Controller user interface and log in.

2. Select the NGINX Controller menu icon, then select **Services**.

3. On the **Services** menu, select **Identity Providers**.

4. On the **Identity Provider** page, select the Identity Provider name to edit it.

5. Select the **Remove** link.

6. When prompted, confirm that you want to remove the provider.


{{< versions "3.0" "3.18" "ctrlvers" >}}
{{< versions "3.22" "latest" "adcvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
