---
docs:
---

{{<call-out "important" "Setting a custom ClickHouse password" "fas fa-exclamation-triangle" >}}When installing ClickHouse, you can set a password or leave it blank (default is an empty string). If you set a password, make sure to update the **/etc/nms/nms.conf** file with it after installing NGINX Instance Manager. Otherwise, NGINX Instance Manager won't start. For more information on customizing ClickHouse settings, refer to the [Configure ClickHouse]({{< relref "/nim/system-configuration/configure-clickhouse.md" >}}) topic. {{</call-out>}}
