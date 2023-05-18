The data that NGINX Controller collects can be divided into two categories:

- **System metrics**: Data collected from the NGINX Plus API, the NGINX log files, and NGINX process state.
- **Traffic metrics**: Data related to processed traffic, with the ability to distinguish the Application, API endpoint, or Environment that traffic is directed through.

{{< note >}}
The key difference between system and traffic metrics is that traffic metrics are pre-aggregated for each time period.
{{< /note >}}

Metrics are published at a regular interval of 60 or 30 seconds for system and traffic metrics, respectively.

This topic gives an overview of the traffic metrics. Also known as "app-centric" metrics, traffic metrics contain information that lets you easily identify the App to which the data applies.

{{< see-also >}}
Refer to [View traffic metrics]({{< relref "analytics/metrics/view-traffic-metrics.md" >}}) for instructions on how to view traffic metrics using the [NGINX Controller REST API]({{< relref "api/_index.md" >}}).
{{< /see-also >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-543 -->