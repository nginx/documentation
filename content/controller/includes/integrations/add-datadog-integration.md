Take the following steps to create an Integration for Datadog:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Integrations**.
4. On the **Integrations** menu, select the **Create Integration** quick action.
5. Add a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. (Optional) Add tags.
9. In the **Integration Type** list, select `GENERIC_INTEGRATION`.
10. In the **Endpoint URI** box, add the API endpoint for your Datadog region. For example, `https://api.datadoghq.com/api/v1/series` for metrics or `https://http-intake.logs.datadoghq.com/v1/input` for events.
11. In the **Credential Type** list, select `API_KEY`.
12. In the **API Key** box, add the [Datadog API Key]({{< relref "/analytics/forwarders/forward-analytics-to-datadog.md#generate-datadog-api-token" >}}).
13. Select **Submit**.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-549 -->