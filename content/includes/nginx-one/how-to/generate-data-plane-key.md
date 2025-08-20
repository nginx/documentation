---
docs:
files:
  - content/nginx-one/secure-your-fleet/set-up-security-alerts.md
  - content/nginx-one/getting-started.md
  - content/nginx-one/ngf/add-nic.md
  - content/nginx-one/ngf/add-ngf-helm.md
  - content/nginx-one/ngf/add-ngf-manifests.md
---

A data plane key is a security token that ensures only trusted NGINX instances can register and communicate with NGINX One.

To generate a data plane key, select **Manage > Instances > Add Instance**:

- **For a new key:** In the **Add Instance** pane, select **Generate Data Plane Key**.
- **To reuse an existing key:** If you already have a data plane key and want to use it again, select **Use existing key**. Then, enter the key's value in the **Data Plane Key** box.

{{<call-out "caution" "Data plane key guidelines" "fas fa-key" >}}
Data plane keys are displayed only once and cannot be retrieved later. Be sure to copy and store this key securely.

Data plane keys expire after one year. You can change this expiration date later by [editing the key]({{< ref "nginx-one/connect-instances/create-manage-data-plane-keys.md#change-expiration-date" >}}). If you [revoke a data plane key]({{< ref "nginx-one/connect-instances/create-manage-data-plane-keys.md#revoke-data-plane-key" >}}) you disconnect all instances registered with that key.
{{</call-out>}}

For more options associated with data plane keys, see [Create and manage data plane keys]({{< ref "/nginx-one/connect-instances/create-manage-data-plane-keys.md" >}}).
