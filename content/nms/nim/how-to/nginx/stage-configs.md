---
description: Learn how to pre-configure and stage NGINX configuration files with NGINX
  Management Suite Instance Manager for quick publishing to NGINX instances or instance
  groups.
docs: DOCS-1277
doctypes:
- task
tags:
- docs
title: Stage Configuration Files
toc: true
weight: 120
---

## Overview

With Instance Manager, you can easily pre-configure and stage NGINX configuration files, so you can quickly publish them to individual NGINX instances or instance groups whenever you're ready.

{{<see-also>}}For instructions on creating and working with instance groups, refer to the topic [Working with instance groups]({{< relref "/nms/nim/how-to/instances/manage-instance-groups.md" >}}).{{</see-also>}}

---

## Before You Begin

To complete the instructions in this guide, you need the following:

- Instance Manager is installed, licensed, and running.

---
## Stage an Instance's Config

To stage an NGINX instance's configuration for publication to other instances or instance groups, follow these steps:

1. {{< include "nim/webui-nim-login.md" >}}
2. On the left menu, select Instances.
3. On the Instances Overview page, select an instance in the list that has the configuration you want to stage.
4. Select **Edit Config**.
5. Make your desired changes to the instance's config files. The config analyzer will let you know if there are any errors.
6. To stage your changes so you can publish them later, select **Save as** and provide a name for the staged config.
7. Select **Save**.
8. To view the staged config, select **Staged Configs** on the left menu. The staged config should appear in the list.

---

## Create a New Staged Config

Follow these steps to create a new staged configuration:

1. {{< include "nim/webui-nim-login.md" >}}
2. On the left menu, select **Staged Configs**.
3. Select **Create**.
4. On the Create Config form, complete the necessary fields:

   - **Config name**: Give the staged config a name.
   - **Config files root directory**: specify the root directory where configuration files can be written to and read from. The default is `/etc/nginx/`.
   - **Aux files root directory**: specify the root directory where auxiliary files can be written to and read from. The default is `/etc/nginx`.

5. Select **Create**.
6. On the Overview page, select the staged config you just created.
7. Select **Add File**.
8. Specify the file path and file name. For example, `/etc/nginx/conf.d/default.conf`.
9. Select **Create**.
1. Type or paste the contents of the file in the configuration editor.
2. Repeat steps 6–9 to add other files.
3. Select **Save** when you're done.

---

## Update a Staged Configuration

To update a staged configuration:

1. {{< include "nim/webui-nim-login.md" >}}
1. On the left menu, select **Staged Configs**.
1. From the list of staged configs, select one you want to update.
1. Edit the staged configuration files as needed. The config analyzer will let you know if there are any errors.
1. Select **Save** to save the configuration.

---

## Publish Staged Configurations

{{< include "nim/how-to/publish-staged-configs.md" >}}

---

## Add Hash Versioning to Staged Configs (API Only) {#hash-versioning-staged-configs}

With the Instance Manager REST API, you can add a commit hash to NGINX configurations if you use version control, such as Git. This will allow you to retrieve a configuration with a unique version identifier.

{{<see-also>}}{{< include "nim/how-to-access-nim-api.md" >}}{{</see-also>}}

<br>

{{<tabs name="hash-versioning">}}

{{%tab name="POST"%}}

To add a commit hash to a new or staged staged config using the REST API, send an HTTP `POST` or `PUT` request to the Configs endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint   |
|--------|------------|
| `POST` or `PUT` | `/configs` |

{{</bootstrap-table>}}


<br>

{{<comment>}}Add param table here{{</comment>}}

{{< include "nim/how-to/version-control/version-control-api-params.md" >}}

<br>

<details open>
<summary>JSON request</summary>

```json
{
  "configName": "test-staged",
  "configFiles": {
  "rootDir": "/etc/nginx",
  "files": [
      {
      "contents": "ZXZlbnRzIHt9Cmh0dHAgeyAgCiAgICBzZXJ2ZXIgeyAgCiAgICAgICAgbGlzdGVuIDgwOyAgCiAgICAgICAgc2VydmVyX25hbWUgXzsKCiAgICAgICAgcmV0dXJuIDIwMCAiSGVsbG8iOyAgCiAgICB9ICAKfQ==",
      "name": "/etc/nginx/nginx.conf"
      }
  ]
  },
  "auxFiles":
  {
      "rootDir": "/etc/nginx/aux",
      "files": []
  },
  "externalId": "8acf5aed9d2872b266d2f880cab23a4aa5791d1b",
  "externalIdType": "git"
}
```

</summary>
</details>

This JSON defines an NGINX configuration with the following settings:

- Specifies the configuration name and root directory for auxiliary and configuration files.
- Lists the configuration files with their contents and name; contents are base64 encoded,
- Specifies an external ID and type as version control identifiers.

{{<important>}}{{<include "nim/how-to/version-control/warning-edit-config-reverts-hashed-commit.md" >}}{{</important>}}

{{%/tab%}}

{{%tab name="GET"%}}

To view a staged config, send an HTTP `GET` request to the Configs endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                |
|--------|-------------------------|
| `GET`  | `/configs/{config_uid}` |

{{</bootstrap-table>}}


<br>

To view a staged config with a version-controlled hash, send an HTTP `GET` request to the Configs endpoint and specify the `externalID`.


{{<bootstrap-table "table">}}

| Method | Endpoint                            |
|--------|-------------------------------------|
| `GET`  | `/configs/{config_uid}?externalId={commit_hash}` |

{{</bootstrap-table>}}


<details open>
<summary>JSON response</summary>

```json
{
  "configName": "test-staged",
  "createTime": "2023-02-28T20:12:15.677Z",
  "externalId": "8acf5aed9d2872b266d2f880cab23a4aa5791d1b",
  "externalIdType": "git",
  "uid": "3693045a-5c4b-4fce-8929-ef362a29211b",
  "updateTime": "2023-02-28T20:12:15.677Z",
  "auxFiles": {
    "files": [],
    "rootDir": "/etc/nginx/aux"
  },
  "configFiles": {
    "files": [
      {
        "contents": "ZXZlbnRzIHt9Cmh0dHAgeyAgCiAgICBzZXJ2ZXIgeyAgCiAgICAgICAgbGlzdGVuIDgwOyAgCiAgICAgICAgc2VydmVyX25hbWUgXzsKCiAgICAgICAgcmV0dXJuIDIwMCAiSGVsbG8iOyAgCiAgICB9ICAKfQ==",
        "name": "/etc/nginx/nginx.conf"
      }
    ],
    "rootDir": "/etc/nginx"
  }
}
```

</details>

{{%/tab%}}

{{</tabs>}}

---

## What's Next

- [Publish Configuration Files]({{< relref "/nms/nim/how-to/nginx/publish-configs.md" >}})
