---
nd-docs: DOCS-566
title: Splunk Integration
weight: 40
---

## Splunk Integration Requirements

(Optional) If you want to forward metrics and you haven't already created a Splunk Index for metrics, take the steps below to add one. You can do the same for events, although you could also use the existing, default "main" index.

1. Open the Splunk web interface and log in.
2. Select **Settings**, then select **Indexes**.
3. Select **New Index**.
4. Add a Name.
5. For the *Index Data Type*, select **Metrics** or **Events**.
6. Select **Save**.


### Set up Splunk to Monitor Data

1. Open the Splunk web interface and log in.
2. On the Explore Splunk Enterprise menu, select **Add Data**.
3. Select **Monitor** as the data method.
4. On the Add Data *Select Source* page, select **HTTP Event Collector**.
5. Add a Name.
6. Add a Description.
7. Select **Next**.
8. On the Add Data *Input Settings* page, select one or more of the available Splunk Indexes with the appropriate *Index Data Type*.
9. Select **Review**.
10. On the summary page, copy and save the token value. **You'll configure F5 NGINX Controller with this value later**.

## Add a Splunk Integration

Take the following steps to create an Integration for Splunk:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Integrations**.
4. On the **Integrations** menu, select the **Create Integration** quick action.
5. Add a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. (Optional) Add tags.
9. In the **Integration Type** list, select `GENERIC_INTEGRATION`.
10. In the **Endpoint URI** box, add the Splunk collector URL.
11. In the **Credential Type** list, select `API_KEY`.
12. In the **API Key** box, add the [Splunk token value]({{< ref "/controller/analytics/forwarders/forward-analytics-to-splunk.md#set-up-splunk-to-monitor-data" >}}).
13. Select **Submit**.
