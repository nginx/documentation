---
description: Create a Datadog Integration for F5 NGINX Controller.
docs: DOCS-564
title: Datadog Integration
weight: 30
---

## Datadog Integration Requirements

F5 NGINX Controller sends data to the Datadog API; NGINX Controller does not use an agent. Datadog requires that NGINX Controller present an access token with the data to authenticate the service.

1. Log into the [Datadog web interface](https://app.datadoghq.com/).
2. On the navigation menu, select **Integrations** > **APIs**.
3. Expand the **API Keys** pane.
4. If you already have a key available, you can use it. If you don't, or if you want to create [a different key](https://docs.datadoghq.com/account_management/api-app-keys/#using-multiple-api-keys), you can do so by [typing a key name and clicking **Create API key**](https://docs.datadoghq.com/account_management/api-app-keys/#add-a-key).
5. Copy and save the API key you want to use. **You'll configure NGINX Controller with this value later**.

{{< note >}} Datadog restricts the creation of API keys to Admin users. You may need to contact your administrator to get a new key.  {{< /note >}}

## Add a Datadog Integration

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
12. In the **API Key** box, add the [Datadog API Key]({{< ref "/controller/analytics/forwarders/forward-analytics-to-datadog.md#generate-datadog-api-token" >}}).
13. Select **Submit**.

