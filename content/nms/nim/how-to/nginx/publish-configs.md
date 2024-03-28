---
description: Learn how to edit and publish NGINX configuration files using NGINX Management
  Suite Instance Manager.
docs: DOCS-822
doctypes:
- tutorial
tags:
- docs
title: Publish NGINX Configs
toc: true
weight: 200
---

## Overview

With Instance Manager, you can easily edit and publish NGINX configurations to your NGINX and NGINX Plus instances. As you edit your configurations, the NGINX config analyzer will automatically detect and highlight errors, ensuring accuracy and reliability.

---

## Before You Begin

To complete the instructions in this guide, you need the following:

- Instance Manager is installed, licensed, and running
- One or more NGINX data plane instances

---

## Publishing to Instances

### Publish Config Changes to Instances {#publish-configs}

To edit an instance's configuration and publish the changes, follow these steps:

1. {{< include "nim/webui-nim-login.md" >}}
2. On the left menu, select **Instances**.
3. Choose the instance from the list that you want to publish a configuration to.
4. Select **Edit Config**.
5. Edit the configuration files to make your desired changes. The config analyzer will let you know if there are any errors.
6. Select **Publish** to apply the changes and publish them to the instance.

### Publish Configs with Hash Versioning (API Only) {#publish-configs-instances-hash-versioning}

With the Instance Manager REST API, you can add a commit hash to NGINX configurations if you use version control, such as Git. This will allow you to retrieve a configuration with a unique version identifier.

{{<see-also>}}{{< include "nim/how-to-access-nim-api.md" >}}{{</see-also>}}

<br>

{{<tabs name="hash-versioning">}}

{{%tab name="POST"%}}

To add a commit hash to a new or existing config using the REST API, send an HTTP `POST` or `PUT` request to the Configs endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint   |
|--------|------------|
| `POST` or `PUT` | `/systems/{systems_uid}/instances/{instance_uid}/config` |

{{</bootstrap-table>}}


<br>

{{<comment>}}Add param table here{{</comment>}}

{{< include "nim/how-to/version-control/version-control-api-params.md" >}}

<br>

<details open>
<summary>JSON request</summary>

{{< include "nim/how-to/version-control/json-request-post-externalId.md" >}}

</summary>
</details>

{{%/tab%}}

{{%tab name="GET"%}}

To view the latest version of a configuration, send an HTTP `GET` request to the Systems endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                |
|--------|-------------------------|
| `GET`  | `/systems/{systems_uid}/instances/{instance_uid}` |

{{</bootstrap-table>}}


<br>

To view a specific configuration with a version-controlled hash, send an HTTP `GET` request to the Configs endpoint and specify the `externalID`.


{{<bootstrap-table "table">}}

| Method | Endpoint                            |
|--------|-------------------------------------|
| `GET`  | `/systems/{systems_uid}/instances/{instance_uid}/config?externalId=` |

{{</bootstrap-table>}}


<details open>
<summary>JSON response</summary>

{{< include "nim/how-to/version-control/json-response-get-externalId.md" >}}

</details>

{{%/tab%}}

{{</tabs>}}

---

## Publishing to Instance Groups

### Publish Config Changes to Instance Groups

{{< include "nim/how-to/publish-to-instance-group.md" >}}

### Publish Configs with Hash Versioning (API Only) {#publish-configs-instance-groups-hash-versioning}

{{< include "nim/how-to/version-control/instance-group-hash-version-config.md" >}}

---

## Publishing Staged Configs

{{<see-also>}}
To learn how to add and make changes to staged configuration files, please refer to the [Stage Configuration Files]({{< relref "/nms/nim/how-to/nginx/stage-configs.md" >}}) topic.
{{</see-also>}}

{{< include "nim/how-to/publish-staged-configs.md" >}}
