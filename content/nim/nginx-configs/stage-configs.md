---
docs: DOCS-1277
title: Stage NGINX configs
toc: true
weight: 1
type:
- how-to
---

## Overview

With F5 NGINX Instance Manager, you can easily pre-configure and stage NGINX configuration files, so you can quickly publish them to individual NGINX instances or instance groups whenever you're ready.

## Before you begin

To complete the instructions in this guide, ensure:

- NGINX Instance Manager is installed, licensed, and running.

{{<call-out "tip" "Interacting with the API" >}} You can use tools such as `curl` or [Postman](https://www.postman.com) to interact with the Instance Manager REST API. The API URL follows the format `https://<NIM_FQDN>/api/nim/<API_VERSION>` and must include authentication information with each call. For more information about authentication options, refer to the [API Overview]({{< ref "/nim/fundamentals/api-overview.md" >}}). {{</call-out>}}

---

## Stage an instance's config

To stage an NGINX instance's configuration for publication to other instances or instance groups, follow these steps:

1. On the left menu, select **Instances**.
2. On the Instances Overview page, select an instance in the list that has the configuration you want to stage.
3. Select **Edit Config**.
4. Make your desired changes to the instance's config files. The config analyzer will let you know if there are any errors.
5. To stage your changes so you can publish them later, select **Save as** and provide a name for the staged config.
6. Select **Save**.
7. To view the staged config, select **Staged Configs** on the left menu. The staged config should appear in the list.

---

## Create a new staged config

Follow these steps to create a new staged configuration:

1. On the left menu, select **Staged Configs**.
2. Select **Create**.
3. On the Create Config form, complete the necessary fields:
   - **Config name**: Give the staged config a name.
   - **Config files root directory**: Specify the root directory where configuration files can be written to and read from. The default is `/etc/nginx/`.
   - **Aux files root directory**: Specify the root directory where auxiliary files can be written to and read from. The default is `/etc/nginx/aux`.
4. Select **Create**.
5. On the Overview page, select the staged config you just created.
6. Select **Add File**.
7. Specify the file path and file name. For example, `/etc/nginx/conf.d/default.conf`.
8. Select **Create**.
9. Type or paste the contents of the file in the configuration editor.
10. Repeat steps 6–9 to add other files.
11. Select **Save** when you're done.

---

## Update a staged configuration

To update a staged configuration:

1. On the left menu, select **Staged Configs**.
2. From the list of staged configs, select one you want to update.
3. Edit the staged configuration files as needed. The config analyzer will let you know if there are any errors.
4. Select **Save** to save the configuration.

---

## Publishing staged configs {#publish-staged-configs}

To publish a staged configuration to an NGINX instance or instance group:

1. On the left menu, select **Staged Configs**.
2. From the list of staged configs, select the one you want to publish.
3. Select **Publish to**.
4. Select the NGINX instance or instance group to publish the staged config to.
5. Select **Publish**.

### Publish configs with hash versioning (API only) {#hash-versioning-staged-configs}

With the Instance Manager REST API, you can add a commit hash to NGINX configurations if you use version control, such as Git. This allows you to retrieve a configuration with a unique version identifier.

#### HTTP request (POST)

To add a commit hash to a new or staged config using the REST API, send an HTTP `POST` or `PUT` request to the Configs endpoint.

- **Method**: `POST` or `PUT`
- **Endpoint**: `/configs`

#### Parameters

When adding version control identifiers to a config, include the following parameters:

- **externalID** (optional): The commit hash, 1–150 characters. For example, `521747298a3790fde1710f3aa2d03b55020575aa`.
- **externalIdType** (optional): The type of commit used for the config update. Possible values are `git` or `other`. If `externalID` isn't specified, the type defaults to `other`.

#### Example JSON request

```json
{
  "configName": "test-staged",
  "configFiles": {
    "rootDir": "/etc/nginx",
    "files": [
      {
        "contents": "base64_encoded_contents",
        "name": "/etc/nginx/nginx.conf"
      }
    ]
  },
  "auxFiles": {
    "rootDir": "/etc/nginx/aux",
    "files": []
  },
  "externalId": "8acf5aed9d2872b266d2f880cab23a4aa5791d1b",
  "externalIdType": "git"
}
```

{{<call-out "important" "Commit information reset upon direct edits" >}} If you edit an NGINX configuration in the Instance Manager web interface or directly on the data plane, previous hashed commit information will be lost: `externalID` will revert to `null` and `externalIdType` will revert to `other` automatically.{{</call-out>}}

#### HTTP request (GET)

To view a staged config, send an HTTP `GET` request to the Configs endpoint.

- **Method**: `GET`
- **Endpoint**: `/configs/{config_uid}`

To view a staged config with a version-controlled hash, send an HTTP `GET` request to the Configs endpoint and specify the `externalID`.

- **Method**: `GET`
- **Endpoint**: `/configs/{config_uid}?externalId={commit_hash}`

#### Example JSON response

```json
{
  "configName": "test-staged",
  "configFiles": {
    "rootDir": "/etc/nginx",
    "files": [
      {
        "contents": "base64_encoded_contents",
        "name": "/etc/nginx/nginx.conf"
      }
    ]
  },
  "auxFiles": {
    "rootDir": "/etc/nginx/aux",
    "files": []
  },
  "externalId": "8acf5aed9d2872b266d2f880cab23a4aa5791d1b",
  "externalIdType": "git"
}
```
