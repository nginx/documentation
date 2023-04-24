Take the following steps to create an integration for OpenTelemetry Collector:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Integrations**.
4. On the **Integrations** menu, select **Create Integration**.
5. Add a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. (Optional) Add tags.
9. In the **Integration Type** list, select `GENERIC_INTEGRATION`.
10. In the **Endpoint URI** box, add the one of HTTP, HTTPS, gRPC or gRPC+TLS endpoint for your OpenTelemetry Collector. This is the same address that's configured in the OpenTelemetry Collector config in the receivers section. See the [example config]({{< relref "platform/integrations/otlp-integration.md#example-configuration-for-opentelemetry-collector" >}}):
- HTTP endpoint should be `http://collector_ip:4319`
- HTTPS endpoint should be `https://collector_ip:4318`
- gRPC endpoint should be `tcp://collector_ip:4419`
- gRPC with TLS endpoint should be `tcp+tls://collector_ip:4418`
11. In the **Credential Type** list, select `UNAUTHENTICATED` (at this time we do not support any authentication methods).
12. Select **Submit**.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-550 -->