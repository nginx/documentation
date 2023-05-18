Take the following steps to create a Forwarder for Datadog:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Data Forwarders**.
4. On the **Data Forwarders** menu, select the **Create Data Forwarder** quick action.
5. Add a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. Select your **Integration Reference** from the dropdown menu or select **Create New** to create a new Integration.
9. In the **Collector Type** list, select `DATADOG`.
10. In the **Source** list, select the type of data to forward: `metrics` or `events`.
11. In the **Output Format** list, select `DATADOG`.
12. The **Selector** field consists of the following query parameters (optional):

- `names` (inapplicable for `EVENTS`): The list of metrics names that you want to forward.
- `excluded_names` (inapplicable for `EVENTS`): The list of metric names that you don't want to forward.
- `filter`: The conditions to use to refine the metrics or events data.
- Example usage when selecting metrics: `"names=nginx.*&excluded_names=nginx.upstream.*filter=app='myapp'"`
- Example usage when selecting events: `"filter=type='security violation' AND app='my-app'"`

13. (Optional) Add additional **Streams** as required using the **Add Stream** button.
    
{{< important >}}

Each metric will be prefixed with a common namespace -- such as "nginx-controller" -- before it is sent to Datadog. This prefix is used by Datadog only and is not applied to any of the internal NGINX Controller metrics. Refer to the [metrics catalog]({{< relref "/analytics/catalogs/metrics.md" >}}) for the full list of valid metric names.

For events, the "nginx-controller" namespace is added to the ["ddsource" key](https://docs.datadoghq.com/api/v1/logs/#send-logs).

{{< /important >}}

NGINX Controller events are sent to Datadog as logs and NGINX Controller dimensions are sent as tags. The Forwarder converts the dimension data to comply with the Datadog [tags format](https://docs.datadoghq.com/getting_started/tagging/#defining-tags) prior to forwarding it. In some cases, the original dimension value may be transformed to fit the tag requirements. This includes replacing comma characters (`,`) with semicolons (`;`) to ensure that Datadog will properly handle the incoming payload.

{{< see-also >}}

See the [NGINX Controller Metrics]({{< relref "/analytics/metrics/_index.md" >}}) docs for more information.

{{< /see-also >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-545 -->