On the **Create App Component** *Security* page:

{{< note >}} The following Security settings are applicable only to Web components. {{< /note >}}

1. (Optional) Select **Enable Web Application Firewall (WAF)** to watch for or block suspicious requests or attacks.
1. (Optional) Select **Monitor Only** to allow traffic to pass without being rejected. Security events are still generated and metrics are still collected. Refer to [About App Security Analytics]({{< relref "/analytics/view-app-security-analytics.md#overview" >}}) for more information.
1. (Optional) the signature(s) that you want the WAF to ignore. You can specify multiple signatures as a comma-separated list.
1. Select **Next**.

{{< see-also >}}
Refer to the [Secure Your Apps]({{< relref "/app-delivery/security/_index.md" >}}) topics to learn more about WAF and the default protections provided by NGINX App Protect.
{{< /see-also >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-495 -->