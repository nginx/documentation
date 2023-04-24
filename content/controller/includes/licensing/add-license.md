To add a license to NGINX Controller, take the following steps:

1. Go to `https://<FQDN>/platform/license`, where \<FQDN\> is the fully qualified domain name for your NGINX Controller server.
1. In the **Upload a license** section of the page, select an upload option:

    - **Upload license file** -- Locate and select your license file in the file explorer.
    - **Paste your Association Token or license file** -- Paste your customer Association Token or the contents of your NGINX Controller license file. These are available on the [MyF5 Customer Portal](https://account.f5.com/myf5).

1. Select **Save license**.

> **See also**: To add a license using the [NGINX Controller REST API]({{< relref "api/_index.md" >}}), send a PUT request to the `/platform/license` endpoint. Provide your CAT or NGINX Controller license as a base64-encoded string in the JSON request body.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-750 -->