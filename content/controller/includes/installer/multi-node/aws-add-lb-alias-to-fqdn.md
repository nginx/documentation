You must add the hostname or IP address for the load balancer as a CNAME or A record for the domain that's used as the Fully Qualified Domain Name (FQDN) for NGINX Controller.

To get the hostname or IP address for the load balancer using the [NGINX Controller REST API]({{< relref "api/_index.md" >}}), send a GET request to the `/platform/global` endpoint.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-297 -->