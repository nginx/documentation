---
description: ''
docs: DOCS-1395
doctypes:
- task
tags:
- docs
title: Create and manage data plane keys
toc: true
weight: 100
---

<style>
h2 {
  margin-top: 20px;
  padding-top: 20px;
}
</style>

## About data plane keys

Data plane keys are required for registering NGINX instances with the F5 NGINX One Console. These keys serve as secure tokens, ensuring that only authorized NGINX instances can connect to and communicate with  NGINX One. You have the flexibility to reuse a key with multiple instances, or to create a unique key for each instance.

{{<call-out "note" "Data plane key considerations" "fas fa-key" >}}
Data plane keys are displayed only once and cannot be retrieved later. Be sure to copy and store this key securely.

Data plane keys expire after one year. You can change this expiration date later by editing the key.

Revoking a data plane key disconnects all instances that were registered with that key.
{{</call-out>}}

## Create a new data plane key

To create a new key for connecting your NGINX instances to NGINX One, follow these steps:

1. On the left menu, select **Data Plane Keys**.
2. Select **Add Data Plane Key**.
3. Enter a name for your new key. Optionally, you can set an expiration date for the key. If you don't set a date, the key will automatically expire one year from today. The longest duration for a key is one year. You can change this expiration date later by editing the key.
4. Select **Generate**.
5. A confirmation screen will show your new data plane key. Be sure to copy and store this key securely. It is displayed *only once* and cannot be retrieved later.
6. Select **Close** to complete the process.

## Change the expiration date {#change-expiration-date}

To change the expiration date of a data plane key, follow these steps before the key expires. You cannot update the expiration date after the key has expired.

1. On the left menu, select **Data Plane Keys**.
2. Find the key you want to edit in the list.
3. Next to the key name, in the **Actions** column, select the ellipsis (three dots) and then select **Edit Key**.
4. Set a new expiration date for the key. The longest duration for a key is one year.
5. Select **Save**.

## Revoke a data plane key {#revoke-data-plane-key}

If you need to deactivate a data plane key before its expiration date, follow these steps. Once revoked, the key will no longer connect any NGINX instances to NGINX One. The key will still be visible in the console until you delete it.

1. On the left menu, select **Data Plane Keys**.
2. Find the key you want to revoke in the list.
3. Next to the key name, in the **Actions** column, select the ellipsis (three dots) and then select **Revoke**.
4. A confirmation dialog will appear. Select **Revoke** to confirm.


## Delete a data plane key

Before you can delete a key, it must be expired or revoked. You can revoke a key either through the NGINX One console, as explained above, or by using the REST API. Once deleted, all information about the data plane key is permanently removed.

1. On the left menu, select **Data Plane Keys**.
2. Find the key you want to revoke in the list of expired or revoked keys.
3. Next to the key name, select the check box. You can select multiple keys at the same time.
4. Select **Delete selected**.
