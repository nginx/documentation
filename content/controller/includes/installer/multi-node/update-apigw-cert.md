Take the following steps to update the API Gateway SSL certificate:

1. Open the NGINX Controller web interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Cluster**.
1. On the **Cluster** overview page, in the **Cluster Configuration** section, select the edit icon (pencil).
1. Select the **Update API Gateway SSL Certificate** toggle.
1. Select an option for updating the cert:

    - **Paste**: Paste the cert and key contents in the boxes.
    - **File**: Browse for and upload the cert and key files.

1. Select **Save**.

{{< see-also >}}
To update the API Gateway SSL certificate and key using the [NGINX Controller REST API]({{< relref "api/_index.md" >}}), send a PATCH request to the `/platform/global` endpoint.
{{< /see-also >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-308 -->