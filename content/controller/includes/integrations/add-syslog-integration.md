Take the following steps to create an Integration for syslog:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Integrations**.
4. On the **Integrations** menu, select the **Create Integration** quick action.
5. Add a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. (Optional) Add tags.
9. In the **Integration Type** list, select `GENERIC_INTEGRATION`.
10. In the **Endpoint URI** box, add the TCP endpoint for your syslog.
    Syslog's URL can be provided in two formats:
     - `tcp://hostname[:port]` for unencrypted TCP connections (example: `tcp://192.168.0.1:601`).
     - `tcp+tls://hostname[:port]` for encrypted TCP connections with TLS (example: `tcp+tls://192.168.0.1:6514`)
11. In the **Credential Type** list, select `UNAUTHENTICATED`.
13. Select **Submit**.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-552 -->