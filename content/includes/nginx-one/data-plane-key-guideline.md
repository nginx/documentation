---
files:
  - content/nginx-one/nginx-configs/config-sync-group/manage-config-sync-groups.md
  - content/nginx-one/getting-started.md
---

{{<call-out "caution" "Data plane key guidelines" "fas fa-key" >}}
Data plane keys are displayed only once and cannot be retrieved later. When you create a data plane key,copy and store this key securely.

Data plane keys expire after one year. You can change this expiration date by [editing the key]({{< ref "nginx-one/connect-instances/create-manage-data-plane-keys.md#change-expiration-date" >}}).

Your NGINX instances stay connected as long as the data plane key is active. If:

- You [revoke a data plane key]({{< ref "nginx-one/connect-instances/create-manage-data-plane-keys.md#revoke-data-plane-key" >}}) 
- A data plane key expires

That disconnects all instances that were registered with that key.
{{</call-out>}}
