---
docs: DOCS-822
title: Publish NGINX configs
toc: true
weight: 2
type:
- tutorial
---

## Overview

With F5 NGINX Instance Manager, you can easily edit and publish NGINX configurations to your NGINX and F5 NGINX Plus instances. As you edit your configurations, the NGINX config analyzer will automatically detect and highlight errors, ensuring accuracy and reliability.

---

## Before you begin

To complete the instructions in this guide, ensure:

- NGINX Instance Manager is installed, licensed, and running.
- You have one or more NGINX data plane instances.

{{< call-out "tip" "Interacting with the API">}} You can use tools such as `curl` or [Postman](https://www.postman.com) to interact with the Instance Manager REST API. The API URL follows the format `https://<NIM_FQDN>/api/nim/<API_VERSION>` and must include authentication information with each call. For more information about authentication options, refer to the [API Overview]({{< ref "/nim/fundamentals/api-overview.md" >}}).{{</call-out>}}

---

## Publishing to instances

### Publish config changes to instances {#publish-configs}

To edit an instance's configuration and publish the changes, follow these steps:

1. On the left menu, select **Instances**.
2. Select the instance you want to publish a configuration update to.
3. Select **Edit Config**.
4. Make your changes to the configuration files. The config analyzer will highlight any errors.
5. Select **Publish** to apply the changes and publish them to the instance.

### Publish configs with hash versioning (API only) {#publish-configs-instances-hash-versioning}

With the Instance Manager REST API, you can add a commit hash to NGINX configurations if you use version control, such as Git. This allows you to retrieve a configuration with a unique version identifier.

#### HTTP Request (POST)

To add a commit hash to a new or existing config using the REST API, send an HTTP `POST` or `PUT` request to the Configs endpoint.

- **Method**: `POST` or `PUT`
- **Endpoint**: `/systems/{systems_uid}/instances/{instance_uid}/config`

#### Parameters

When adding version control identifiers to a config, include the following parameters:

- **externalID** (optional): The commit hash, 1–150 characters. For example, `521747298a3790fde1710f3aa2d03b55020575aa`.
- **externalIdType** (optional): The type of commit used for the config update. Possible values are `git` or `other`. If `externalID` isn't specified, the type defaults to `other`.

#### Example JSON Request

```json
{
    "auxFiles": {
        "files": [],
        "rootDir": "/"
    },
    "configFiles": {
        "rootDir": "/etc/nginx",
        "files": [
            {
                "contents": "base64_encoded_contents",
                "name": "/etc/nginx/nginx.conf"
            }
        ]
    },
    "updateTime": "2023-02-22T17:10:02.677Z",
    "externalId": "521747298a3790fde1710f3aa2d03b55020575aa",
    "externalIdType": "git"
}
```

{{<call-out "important" "Commit information reset upon direct edits" >}} If you edit an NGINX configuration in the Instance Manager web interface or directly on the data plane, previous hashed commit information will be lost: `externalID` will revert to `null` and `externalIdType` will revert to `other` automatically. {{</call-out>}}

#### HTTP Request (GET)

To view the latest version of a configuration, send an HTTP `GET` request to the Systems endpoint.

- **Method**: `GET`
- **Endpoint**: `/systems/{systems_uid}/instances/{instance_uid}`

To view a specific configuration with a version-controlled hash, send an HTTP `GET` request to the Configs endpoint and specify the `externalID`.

- **Method**: `GET`
- **Endpoint**: `/systems/{systems_uid}/instances/{instance_uid}/config?externalId={hash}`

#### Example JSON Response

```json
{
  "build": {
    "nginxPlus": true,
    "release": "nginx-plus-r28",
    "version": "1.23.2"
  },
  "configPath": "/etc/nginx/nginx.conf",
  "configVersion": {
    "instanceGroup": {
      "createTime": "0001-01-01T00:00:00Z",
      "uid": "",
      "versionHash": ""
    },
    "versions": [
      {
        "createTime": "2023-02-28T19:54:58.735Z",
        "externalId": "521747298a3790fde1710f3aa2d03b55020575aa",
        "externalIdType": "git",
        "uid": "92a9dbfa-dc6a-5bf9-87dd-19405db0b9c0",
        "versionHash": "c0f7abbd9b9060c75985b943f3ec0cfc7e4b28cbf50c26bfd0b2141bb6c277a3"
      }
    ]
  }
}
```

---

## Publishing to instance groups {#publish-to-instance-groups}

### Publish config changes to instance groups

To publish a configuration file to an instance group:

1. On the left menu, select **Instance Groups**.
2. Select the instance group you want to publish the configuration to.
3. To add a new config:
    - Select **Add File**.
    - Add the path and filename of the new file.
    - Select **Create**.
    - On the file editor page, type or paste the contents of the new file. The config analyzer will highlight any errors.
4. To update an existing config, make your changes in the editor. The config analyzer will highlight any errors.
5. Select **Publish** to apply the changes and publish them to the instance group.

### Publish configs with hash versioning (API only) {#publish-configs-instance-groups-hash-versioning}

You can add a commit hash to NGINX configurations for instance groups using the Instance Manager REST API.

#### HTTP Request (POST)

To add a commit hash to a new or existing config for an instance group, send an HTTP `POST` or `PUT` request to the Configs endpoint.

- **Method**: `POST` or `PUT`
- **Endpoint**: `/instance-groups/{instanceGroupUID}/config`

#### Example JSON Request

```json
{
    "auxFiles": {
        "files": [],
        "rootDir": "/"
    },
    "configFiles": {
        "rootDir": "/etc/nginx",
        "files": [
            {
                "contents": "base64_encoded_contents",
                "name": "/etc/nginx/nginx.conf"
            }
        ]
    },
    "updateTime": "2023-02-22T17:10:02.677Z",
    "externalId": "8acf5aed9d2872b266d2f880cab23a4aa5791d1b",
    "externalIdType": "git"
}
```

#### HTTP Request (GET)

To view an instance group's config, send an HTTP `GET` request to the Instance Groups endpoint.

- **Method**: `GET`
- **Endpoint**: `/instance-groups/{instanceGroupUID}`

To view an instance group's config with a version-controlled hash, send an HTTP `GET` request to the Instance Groups endpoint and specify the `externalID`.

- **Method**: `GET`
- **Endpoint**: `/instance-groups/{instanceGroupUID}/config?externalId={commit_hash}`

#### Example JSON response

```json
{
  "build": {
    "nginxPlus": true,
    "release": "nginx-plus-r28",
    "version": "1.23.2"
  },
  "configPath": "/etc/nginx/nginx.conf",
  "configVersion": {
    "instanceGroup": {
      "createTime": "0001-01-01T00:00:00Z",
      "uid": "",
      "versionHash": ""
    },
    "versions": [
      {
        "createTime": "2023-02-28T19:54:58.735Z",
        "externalId": "8acf5aed9d2872b266d2f880cab23a4aa5791d1b",
        "externalIdType": "git",
        "uid": "92a9dbfa-dc6a-5bf9-87dd-19405db0b9c0",
        "versionHash": "c0f7abbd9b9060c75985b943f3ec0cfc7e4b28cbf50c26bfd0b2141bb6c277a3"
      }
    ]
  }
}
```

---

## Publishing staged configs

For complete instructions on publishing staged configurations, see the [Stage NGINX configs]({{< ref "/nim/nginx-configs/stage-configs.md#publish-staged-configs" >}}) guide.
