NGINX Controller sends data to the Datadog API; NGINX Controller does not use an agent. Datadog requires that NGINX Controller present an access token with the data to authenticate the service.

1. Log into the [Datadog web interface](https://app.datadoghq.com/).
2. On the navigation menu, select **Integrations** > **APIs**.
3. Expand the **API Keys** pane.
4. If you already have a key available, you can use it. If you don't, or if you want to create [a different key](https://docs.datadoghq.com/account_management/api-app-keys/#using-multiple-api-keys), you can do so by [typing a key name and clicking **Create API key**](https://docs.datadoghq.com/account_management/api-app-keys/#add-a-key).
5. Copy and save the API key you want to use. **You'll configure NGINX Controller with this value later**.

{{< note >}} Datadog restricts the creation of API keys to Admin users. You may need to contact your administrator to get a new key.  {{< /note >}}
  
<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-553 -->