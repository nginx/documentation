To change the FQDN for NGINX Controller using the web interface, take the following steps:

1. Open the NGINX Controller web interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Cluster**.
1. On the Cluster overview page, in the **Cluster Configuration** section, select the edit icon (pencil).
1. In the FQDN box, type the new FQDN that you want to use. If you've [set a floating IP](#set-the-floating-ip), use that value for the FQDN.
1. Select the **Update API Gateway SSL Certificate** toggle.
1. Select an option for updating the API Gateway cert:

    - **Paste**: Paste the cert and key contents in the respective boxes.
    - **File**: Browse for and upload the cert and key files.

1. Select **Save**. The cluster services will restart. During this time, the web interface will be briefly unavailable.
1. Follow the steps to [update the FQDN for Controller Agents](#update-the-fqdn-for-controller-agents).

{{< see-also >}}
To change the FQDN for NGINX Controller using the [NGINX Controller REST API]({{< relref "api/_index.md" >}}), send a PATCH request to the `/platform/global` endpoint.
{{< /see-also >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-299 -->