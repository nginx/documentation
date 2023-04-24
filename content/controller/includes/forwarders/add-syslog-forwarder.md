Take the following steps to create a Forwarder for Splunk:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Data Forwarders**.
4. On the **Data Forwarders** menu, select the **Create Data Forwarder** quick action.
5. Add a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. Select your **Integration Reference** from the dropdown menu or select **Create New** to create a new Integration.
9.  In the **Collector Type** list, select `SYSLOG`.
10. In the **Source** list, select the type of data to forward: `events`. NGINX Controller can forward only `EVENTS` data to syslog.
11. In the **Output Format** list, select `SYSLOG`.
12. The **Selector** field consists of the following query parameters (optional):
  - `filter`: The conditions to use to refine the metrics or events data.
  - Example usage: `"filter=type='security violation' AND app='my-app'"`
13. (Optional) Add additional **Streams** as required using the **Add Stream** button.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-548 -->