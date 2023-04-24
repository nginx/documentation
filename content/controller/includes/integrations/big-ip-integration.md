Create an integration to let NGINX Controller communicate with your BIG-IP cluster:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Integrations**.
4. On the **Integrations** menu, select **Create Integration**.
5. Give your integration a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. (Optional) Add tags.
9. In the **Integration Type** list, select `GENERIC_INTEGRATION`.
10. In the **Endpoint URI** box, add the endpoint for your BIG-IP system, for example, `https://192.0.2.0:8443`. For clusters that comprise multiple BIG-IP instances, you can specify the [floating self IP address](https://techdocs.f5.com/en-us/bigip-14-1-0/big-ip-tmos-routing-administration-14-1-0/self-ip-addresses.html) for your BIG-IP cluster.
11. In the **Credential Type** list, select `USER_PASS`.
12. Add the username and password to use to log into your BIP-IP cluster. This account must have permission to create and delete partitions on BIG-IP.
13. Select **Submit**.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-749 -->