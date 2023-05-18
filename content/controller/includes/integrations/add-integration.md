Take the following steps to create an Integration:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Integrations**.
4. On the **Integrations** menu, select the **Create Integration** quick action.
5. Add a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. (Optional) Add tags.
9. Select the Integration type.
    
- `AWS_INTEGRATION` for AWS
- `GENERIC_INTEGRATION` for Datadog, Splunk and Syslog

10. Type the service endpoint URL.

- For AWS the endopoint is optional.
- For Datadog add the API endpoint for your Datadog region. For example, `https://api.datadoghq.com/api/v1/series` for metrics or `https://http-intake.logs.datadoghq.com/v1/input` for events.
- For Splunk add the Splunk collector URL.
- Syslog's URL can be provided in two formats:
     - `tcp://hostname[:port]` for unencrypted TCP connections (example: `tcp://192.168.0.1:601`).
     - `tcp+tls://hostname[:port]` for encrypted TCP connections with TLS (example: `tcp+tls://192.168.0.1:6514`)

11.  Select the  **Credential Type**:

- For AWS select `AWS_ACCESS_KEY`.
- For Datadog and Splunk select `API_KEY`.
- For Syslog in select `UNAUTHENTICATED`.
  
12.  Add the credentials.
- For AWS, add the [access key ID](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html). and the [secret access key ID](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html). 
- For Datadog, in the **API Key** box, add the [Datadog API Key]({{< relref "/analytics/forwarders/forward-analytics-to-datadog.md#generate-datadog-api-token" >}}).
- For Splunk,  in the **API Key** box, add the [Splunk token value]({{< relref "/analytics/forwarders/forward-analytics-to-splunk.md#set-up-splunk-to-monitor-data" >}}).


13.  Select **Submit**.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-352 -->