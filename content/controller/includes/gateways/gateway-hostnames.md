On the **Gateways** > **Create Gateway** > **Hostnames** page:

1. Specify the hostname of the gateway using the following URI format. Include the protocol and port (if non-standard):

   - `http://<fqdn>`
   - `https//<fqdn>`
   - `http://<fqdn>:<port>`
   - `https://<fqdn>:<port>`
   - `tcp[+tls]://<fqdn>:<port>`
   - `udp://<fqdn>:<port>`

1. (Optional) Select a name match method. The default is `EXACT`.
1. (Optional) In the **Cert Reference** list, select a certificate that you want the Gateway to reference or select **Create New** to add a certificate.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-502 -->