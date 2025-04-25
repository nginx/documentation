---
title: Manage and deploy WAF policies and log profiles
description: Learn how to use F5 NGINX Instance Manager to manage NGINX App Protect WAF security policies and security log profiles.
weight: 300
toc: true
type: how-to
product: NIM
docs: DOCS-1105
---

## Overview

F5 NGINX Instance Manager lets you manage NGINX App Protect WAF configurations using either the web interface or REST API. You can edit, update, and deploy security policies, log profiles, attack signatures, and threat campaigns to individual instances or instance groups.

You can compile a security policy, attack signatures, and threat campaigns into a security policy bundle. The bundle includes all necessary components for a specific NGINX App Protect WAF version. Precompiling the bundle improves performance by avoiding separate compilation of each component during deployment.

{{<note>}}
The following capabilities are available only through the Instance Manager REST API:

- Update security policies
- Create, read, and update security policy bundles
- Create, read, update, and delete security log profiles
- Publish security policies, log profiles, attack signatures, and threat campaigns to instances and instance groups
{{</note>}}

---

## Before you begin

Before continuing, complete the following steps:

- [Set up App Protect WAF configuration management]({{< ref "setup-waf-config-management" >}})
- Make sure your user account has the [required permissions]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}) to access the REST API:

  - **Module**: Instance Manager  
  - **Feature**: Instance Management → `READ`  
  - **Feature**: Security Policies → `READ`, `CREATE`, `UPDATE`, `DELETE`

To use policy bundles, you also need to:

- Have `UPDATE` permissions for each referenced security policy  
- [Install the correct `nms-nap-compiler` package]({{< ref "/nim/nginx-app-protect/setup-waf-config-management.md#install-the-waf-compiler" >}}) for your App Protect WAF version  
- [Install the required attack signatures and threat campaigns]({{< ref "/nim/nginx-app-protect/setup-waf-config-management.md#set-up-attack-signatures-and-threat-campaigns" >}})

### Access the web interface

To access the web interface, open a browser and go to the fully qualified domain name (FQDN) of your NGINX Instance Manager. Log in, then select **Instance Manager** from the Launchpad.

### Access the REST API

{{< include "nim/how-to-access-nim-api.md" >}}

---

## Create a security policy {#create-security-policy}

{{<tabs name="create-security-policy">}}

{{%tab name="web interface"%}}

To create a security policy using the NGINX Instance Manager web interface:

1. In your browser, go to the FQDN for your NGINX Instance Manager host and log in.  
2. From the Launchpad menu, select **Instance Manager**.  
3. In the left menu, select **App Protect**.  
4. On the *Security Policies* page, select **Create**.  
5. On the *Create Policy* page, enter the required information:
   - **Name**: Enter a name for the policy.  
   - **Description**: (Optional) Add a brief description.  
   - **Enter Policy**: Paste or type the JSON-formatted policy into the editor. The interface automatically validates the JSON.

    For help writing custom policies, see the [NGINX App Protect WAF Declarative Policy guide](https://docs.nginx.com/nginx-app-protect/declarative-policy/policy/) and the [Policy Authoring and Tuning section](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#policy-authoring-and-tuning) in the configuration guide.

6. Select **Save**.

{{%/tab%}}

{{%tab name="API"%}}

To upload a new security policy using the REST API, send a `POST` request to the Security Policies API endpoint.

You must encode the JSON policy using `base64`. If you send the policy in plain JSON, the request will fail.

{{<bootstrap-table "table">}}

| Method | Endpoint                             |
|--------|--------------------------------------|
| POST   | `/api/platform/v1/security/policies` |

{{</bootstrap-table>}}


For example:

```shell
curl -X POST https://{{NIM_FQDN}}/api/platform/v1/security/policies \
    -H "Authorization: Bearer <access token>" \
    -d @ignore-xss-example.json
```

<details open>
<summary>JSON Request</summary>

```json
{
  "metadata": {
    "name": "ignore-cross-site-scripting",
    "displayName": "Ignore cross-site scripting",
    "description": "Ignore cross-site scripting is a security policy that intentionally ignores cross site scripting."
  },
  "content": "ewoJInBvbGljeSI6IHsKCQkibmFtZSI6ICJzaW1wbGUtYmxvY2tpbmctcG9saWN5IiwKCQkic2lnbmF0dXJlcyI6IFsKCQkJewoJCQkJInNpZ25hdHVyZUlkIjogMjAwMDAxODM0LAoJCQkJImVuYWJsZWQiOiBmYWxzZQoJCQl9CgkJXSwKCQkidGVtcGxhdGUiOiB7CgkJCSJuYW1lIjogIlBPTElDWV9URU1QTEFURV9OR0lOWF9CQVNFIgoJCX0sCgkJImFwcGxpY2F0aW9uTGFuZ3VhZ2UiOiAidXRmLTgiLAoJCSJlbmZvcmNlbWVudE1vZGUiOiAiYmxvY2tpbmciCgl9Cn0="
}
```

</details>

<details open>
<summary>JSON Response</summary>

```json
{
  "metadata": {
    "created": "2022-04-10T23:19:58.502Z",
    "description": "string",
    "displayName": "Ignore cross-site scripting",
    "modified": "2022-04-12T23:19:58.502Z",
    "name": "ignore-cross-site-scripting",
    "revisionTimestamp": "2022-04-12T23:19:58.502Z",
    "uid": "<policy-uid>"
  },
  "selfLink": {
    "rel": "/api/platform/v1/services/environments/prod"
  }
}
```

{{%/tab%}}

{{</tabs>}}

---

## Update a security policy


To update a security policy, send a `POST` or `PUT` request to the Security Policies API.

- Use `POST` with the `isNewRevision=true` parameter to add a new version of an existing policy.
- Use `PUT` with the policy UID to overwrite the existing version.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                |
|--------|---------------------------------------------------------|
| POST   | `/api/platform/v1/security/policies?isNewRevision=true` |
| PUT    | `/api/platform/v1/security/policies/{system_id_string}` |

{{</bootstrap-table>}}


To use `POST`, include the policy metadata and content in your request:

```shell
curl -X POST https://{{NIM_FQDN}}/api/platform/v1/security/policies?isNewRevision=true \
    -H "Authorization: Bearer <access token>" \
    -d @update-xss-policy.json
```

To use PUT, first retrieve the policy’s unique identifier (UID). You can do this by sending a GET request to the policies endpoint:

```shell
curl -X GET https://{{NIM_FQDN}}/api/platform/v1/security/policies \
    -H "Authorization: Bearer <access token>"
```

Then include the UID in your PUT request:

```shell
curl -X PUT https://{{NIM_FQDN}}/api/platform/v1/security/policies/<policy-uid> \
    -H "Authorization: Bearer <access token>" \
    --Content-Type application/json \
    -d @update-xss-policy.json
```

After updating the policy, you can [publish it](#publish-policy) to selected instances or instance groups.

---

## Delete a security policy

{{<tabs name="delete-security-policy">}}

{{%tab name="web interface"%}}

<br>

To delete a security policy using the NGINX Instance Manager web interface:

1. In your browser, go to the FQDN for your NGINX Instance Manager host and log in.  
2. From the Launchpad menu, select **Instance Manager**.  
3. In the left menu, select **App Protect**.  
4. On the *Security Policies* page, find the policy you want to delete.
5. Select the **Actions** menu (**...**) and choose **Delete**.


{{%/tab%}}

{{%tab name="API"%}}

To delete a security policy using the REST API:

1. Retrieve the UID for the policy by sending a `GET` request to the policies endpoint:

    ```shell
    curl -X GET https://{{NIM_FQDN}}/api/platform/v1/security/policies \
        -H "Authorization: Bearer <access token>"
    ```

2. Send a `DELETE` request using the policy UID:


{{<bootstrap-table "table">}}

| Method | Endpoint                                                   |
|--------|------------------------------------------------------------|
| DELETE | `/api/platform/v1/security/policies/{security-policy-uid}` |

{{</bootstrap-table>}}


Example:

```shell
curl -X DELETE https://{{NIM_FQDN}}/api/platform/v1/security/policies/<policy-uid> \
    -H "Authorization: Bearer <access token>"
```

{{%/tab%}}

{{</tabs>}}

---

## Create security policy bundles {#create-security-policy-bundles}


To create a security policy bundle, send a `POST` request to the Security Policy Bundles API. The policies you want to include in the bundle must already exist in NGINX Instance Manager.

Each bundle includes:

- A security policy
- Attack signatures
- Threat campaigns
- A version of NGINX App Protect WAF
- Supporting files required to compile and deploy the bundle

### Required fields

- `appProtectWAFVersion`: The version of NGINX App Protect WAF to target.
- `policyName`: The name of the policy to include. Must reference an existing policy.
- `policyUID`: Optional. If omitted, the latest revision of the specified policy is used. This field does **not** accept the keyword `latest`.

If you don’t include `attackSignatureVersionDateTime` or `threatCampaignVersionDateTime`, the latest versions are used by default. You can also set them explicitly by using `"latest"` as the value.


{{<bootstrap-table "table">}}

| Method | Endpoint                                     |
|--------|----------------------------------------------|
| POST   | `/api/platform/v1/security/policies/bundles` |

{{</bootstrap-table>}}

Example:

```shell
curl -X POST https://{{NIM_FQDN}}/api/platform/v1/security/policies/bundles \
    -H "Authorization: Bearer <access token>" \
    -d @security-policy-bundles.json
```

<details open>
<summary>JSON Request</summary>

```json
{
  "bundles": [{
      "appProtectWAFVersion": "4.457.0",
      "policyName": "default-enforcement",
      "policyUID": "<policy-uid>",
      "attackSignatureVersionDateTime": "2023.06.20",
      "threatCampaignVersionDateTime": "2023.07.18"
    },
    {
      "appProtectWAFVersion": "4.279.0",
      "policyName": "default-enforcement",
      "attackSignatureVersionDateTime": "latest",
      "threatCampaignVersionDateTime": "latest"
    },
    {
      "appProtectWAFVersion": "4.457.0",
      "policyName": "ignore-xss"
    }
  ]
}
```

</details>

<details open>
<summary>JSON Response</summary>

```json
{
  "items": [{
      "metadata": {
        "created": "2023-10-04T23:19:58.502Z",
        "modified": "2023-10-04T23:19:58.502Z",
        "appProtectWAFVersion": "4.457.0",
        "policyName": "default-enforcement",
        "policyUID": "<policy-uid>",
        "attackSignatureVersionDateTime": "2023.06.20",
        "threatCampaignVersionDateTime": "2023.07.18",
        "uid": "<bundle-uid>"
      },
      "content": "",
      "compilationStatus": {
        "status": "compiling",
        "message": ""
      }
    },
    {
      "metadata": {
        "created": "2023-10-04T23:19:58.502Z",
        "modified": "2023-10-04T23:19:58.502Z",
        "appProtectWAFVersion": "4.279.0",
        "policyName": "default-enforcement",
        "policyUID": "<policy-uid>",
        "attackSignatureVersionDateTime": "2023.08.10",
        "threatCampaignVersionDateTime": "2023.08.09",
        "uid": "<bundle-uid>"
      },
      "content": "",
      "compilationStatus": {
        "status": "compiling",
        "message": ""
      }
    },
    {
      "metadata": {
        "created": "2023-10-04T23:19:58.502Z",
        "modified": "2023-10-04T23:19:58.502Z",
        "appProtectWAFVersion": "4.457.0",
        "policyName": "ignore-xss",
        "policyUID": "<policy-uid>",
        "attackSignatureVersionDateTime": "2023.08.10",
        "threatCampaignVersionDateTime": "2023.08.09",
        "uid": "<bundle-uid>"
      },
      "content": "",
      "compilationStatus": {
        "status": "compiling",
        "message": ""
      }
    }
  ]
}
```

---

## List security policy bundles {#list-security-policy-bundles}

To list all security policy bundles, send a `GET` request to the Security Policy Bundles API.

You’ll only see bundles you have `"READ"` permissions for.

You can use the following query parameters to filter results:

- `includeBundleContent`: Whether to include base64-encoded content in the response. Defaults to `false`.
- `policyName`: Return only bundles that match this policy name.
- `policyUID`: Return only bundles that match this policy UID.
- `startTime`: Return only bundles modified at or after this time.
- `endTime`: Return only bundles modified before this time.

If no time range is provided, the API defaults to showing bundles modified in the past 24 hours.


{{<bootstrap-table "table">}}

| Method | Endpoint                                     |
|--------|----------------------------------------------|
| GET    | `/api/platform/v1/security/policies/bundles` |

{{</bootstrap-table>}}


Example:

```shell
curl -X GET https://{{NIM_FQDN}}/api/platform/v1/security/policies/bundles \
    -H "Authorization: Bearer <access token>"
```

<details open>
<summary>JSON Response</summary>

```json
{
  "items": [{
      "metadata": {
        "created": "2023-10-04T23:19:58.502Z",
        "modified": "2023-10-04T23:19:58.502Z",
        "appProtectWAFVersion": "4.457.0",
        "policyName": "default-enforcement",
        "policyUID": "<policy-uid>",
        "attackSignatureVersionDateTime": "2023.06.20",
        "threatCampaignVersionDateTime": "2023.07.18",
        "uid": "<bundle-uid>"
      },
      "content": "",
      "compilationStatus": {
        "status": "compiled",
        "message": ""
      }
    },
    {
      "metadata": {
        "created": "2023-10-04T23:19:58.502Z",
        "modified": "2023-10-04T23:19:58.502Z",
        "appProtectWAFVersion": "4.279.0",
        "policyName": "defautl-enforcement",
        "policyUID": "<policy-uid>",
        "attackSignatureVersionDateTime": "2023.08.10",
        "threatCampaignVersionDateTime": "2023.08.09",
        "uid": "<bundle-uid>"
      },
      "content": "",
      "compilationStatus": {
        "status": "compiled",
        "message": ""
      }
    },
    {
      "metadata": {
        "created": "2023-10-04T23:19:58.502Z",
        "modified": "2023-10-04T23:19:58.502Z",
        "appProtectWAFVersion": "4.457.0",
        "policyName": "ignore-xss",
        "policyUID": "<policy-uid>",
        "attackSignatureVersionDateTime": "2023.08.10",
        "threatCampaignVersionDateTime": "2023.08.09",
        "uid": "<bundle-uid>"
      },
      "content": "",
      "compilationStatus": {
        "status": "compiling",
        "message": ""
      }
    }
  ]
}
```

---

## Get a security policy bundle {#get-security-policy-bundle}

To retrieve a specific security policy bundle, send a `GET` request to the Security Policy Bundles API using the policy UID and bundle UID in the URL path.

You must have `"READ"` permission for the bundle to retrieve it.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                                                        |
|--------|-------------------------------------------------------------------------------------------------|
| GET    | `/api/platform/v1/security/policies/{security-policy-uid}/bundles/{security-policy-bundle-uid}` |

{{</bootstrap-table>}}

Example:

```shell
curl -X GET https://{{NIM_FQDN}}/api/platform/v1/security/policies/<policy-uid>/bundles/<bundle-uid> \
    -H "Authorization: Bearer <access token>"
```

The response includes a content field that contains the bundle in base64 format. To use it, you’ll need to decode the content and save it as a `.tgz` file.

Example:

```bash
curl -X GET "https://{{NIM_FQDN}}/api/platform/v1/security/policies/<policy-uid>/bundles/<bundle-uid>" \
    -H "Authorization: Bearer <access token>" | jq -r '.content' | base64 -d > security-policy-bundle.tgz
```

<details open>
<summary>JSON Response</summary>

```json
{
  "metadata": {
    "created": "2023-10-04T23:19:58.502Z",
    "modified": "2023-10-04T23:19:58.502Z",
    "appProtectWAFVersion": "4.457.0",
    "policyUID": "<policy-uid>",
    "attackSignatureVersionDateTime": "2023.08.10",
    "threatCampaignVersionDateTime": "2023.08.09",
    "uid": "<bundle-uid>"
  },
  "content": "ZXZlbnRzIHt9Cmh0dHAgeyAgCiAgICBzZXJ2ZXIgeyAgCiAgICAgICAgbGlzdGVuIDgwOyAgCiAgICAgICAgc2VydmVyX25hbWUgXzsKCiAgICAgICAgcmV0dXJuIDIwMCAiSGVsbG8iOyAgCiAgICB9ICAKfQ==",
  "compilationStatus": {
    "status": "compiled",
    "message": ""
  }
}
```

---

## Create a security log profile {#create-security-log-profile}

To upload a new security log profile, send a `POST` request to the Security Log Profiles API endpoint.

You must encode the log profile in `base64` before sending it. If you send plain JSON, the request will fail.

{{<bootstrap-table "table">}}

| Method | Endpoint                                |
|--------|-----------------------------------------|
| POST   | `/api/platform/v1/security/logprofiles` |

{{</bootstrap-table>}}


Example:

```shell
curl -X POST https://{{NIM_FQDN}}/api/platform/v1/security/logprofiles \
    -H "Authorization: Bearer <access token>" \
    -d @default-log-example.json
```

<details open>
<summary>JSON Request</summary>

```json
{
  "metadata": {
    "name": "default-log-example"
  },
  "content": "Cgl7CgkJImZpbHRlciI6IHsKCQkJInJlcXVlc3RfdHlwZSI6ICJpbGxlZ2FsIgoJCX0sCgkJImNvbnRlbnQiOiB7CgkJCSJmb3JtYXQiOiAiZGVmYXVsdCIsCgkJCSJtYXhfcmVxdWVzdF9zaXplIjogImFueSIsCgkJCSJtYXhfbWVzc2FnZV9zaXplIjogIjVrIgoJCX0KCX0="
}
```

</details>

<details open>
<summary>JSON Response</summary>

```json
{
  "metadata": {
    "created": "2023-07-05T22:09:19.634358096Z",
    "externalIdType": "",
    "modified": "2023-07-05T22:09:19.634358096Z",
    "name": "default-log-example",
    "revisionTimestamp": "2023-07-05T22:09:19.634358096Z",
    "uid": "<log-profile-uid>"
  },
  "selfLink": {
    "rel": "/api/platform/v1/security/logprofiles/<log-profile-uid>"
  }
}
```

---

## Update a security log profile {#update-security-log-profile}

To update a security log profile, you can either:

- Use `POST` with the `isNewRevision=true` parameter to add a new version.
- Use `PUT` with the log profile UID to overwrite the existing version.

{{<bootstrap-table "table">}}

| Method | Endpoint                                                           |
|--------|--------------------------------------------------------------------|
| POST   | `/api/platform/v1/security/logprofiles?isNewRevision=true`         |
| PUT    | `/api/platform/v1/security/logprofiles/{security-log-profile-uid}` |

{{</bootstrap-table>}}


To create a new revision:

```shell
curl -X POST https://{{NIM_FQDN}}/api/platform/v1/security/logprofiles?isNewRevision=true \
    -H "Authorization: Bearer <access token>" \
    -d @update-default-log.json
```

To overwrite an existing security log profile:

1. Retrieve the profile’s UID:

    ```shell
    curl -X PUT https://{{NIM_FQDN}}/api/platform/v1/security/logprofiles/<log-profile-uid> \
      -H "Authorization: Bearer <access token>" \
      --Content-Type application/json \
      -d @update-log-profile.json
    ```

2. Use the UID in your PUT request:
   
    ```shell
    curl -X PUT https://{{NIM_FQDN}}/api/platform/v1/security/logprofiles/<log-profile-uid> \
      -H "Authorization: Bearer <access token>" \
      --Content-Type application/json \
      -d @update-log-profile.json
      ```

After updating the security log profile, you can [publish it](#publish-policy) to specific instances or instance groups.

---

## Delete a security log profile {#delete-security-log-profile}

To delete a security log profile, send a `DELETE` request to the Security Log Profiles API using the profile’s UID.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                           |
|--------|--------------------------------------------------------------------|
| DELETE | `/api/platform/v1/security/logprofiles/{security-log-profile-uid}` |

{{</bootstrap-table>}}


1. Retrieve the UID:

    ```shell
    curl -X GET https://{{NIM_FQDN}}/api/platform/v1/security/logprofiles \
        -H "Authorization: Bearer <access token>"
    ```

2. Send the delete request:

    ```shell
    curl -X DELETE https://{{NIM_FQDN}}/api/platform/v1/security/logprofiles/<log-profile-uid> \
        -H "Authorization: Bearer <access token>"
    ```

---

## Publish updates to instances {#publish-policy}

Use the Publish API to push security policies, log profiles, attack signatures, and threat campaigns to NGINX instances or instance groups.

Call this endpoint *after* you've created or updated the resources you want to deploy.


{{<bootstrap-table "table">}}

| Method | Endpoint                            |
|--------|-------------------------------------|
| POST   | `/api/platform/v1/security/publish` |

{{</bootstrap-table>}}


Include the following information in your request, depending on what you're publishing:

- Instance and instance group UIDs
- Policy UID and name
- Log profile UID and name
- Attack signature library UID and version
- Threat campaign UID and version

Example:

```shell
curl -X POST https://{{NIM_FQDN}}/api/platform/v1/security/publish \
    -H "Authorization: Bearer <access token>" \
    -d @publish-request.json
```

<details open>
<summary>JSON Request</summary>

```json
{
  "publications": [
    {
      "instances": [
        "<instance-uid>"
      ],
      "instanceGroups": [
        "<instance-group-uid>"
      ],
      "policyContent": {
        "name": "example-policy",
        "uid": "<policy-uid>"
      },
      "logProfileContent": {
        "name": "example-log-profile",
        "uid": "<log-profile-uid>"
      },
      "attackSignatureLibrary": {
        "uid": "<signature-library-uid>",
        "versionDateTime": "2023.10.02"
      },
      "threatCampaign": {
        "uid": "<campaign-uid>",
        "versionDateTime": "2023.10.01"
      }
    }
  ]
}
```

</details>

<details open>
<summary>JSON Response</summary>

```json
{
  "deployments": [
    {
      "deploymentUID": "ddc781ca-15d6-46c9-86ea-e7bdb91e8dec",
      "links": {
        "rel": "/api/platform/v1/security/deployments/ddc781ca-15d6-46c9-86ea-e7bdb91e8dec"
      },
      "result": "Publish security content request Accepted"
    }
  ]
}
```

</details>

---

## Check security policy and security log profile publication status {#check-publication-status}

After publishing updates, you can check deployment status using the NGINX Instance Manager REST API.

Use the following endpoints to verify whether the configuration updates were successfully deployed to instances or instance groups.

### Check publication status for a security policy

To view deployment status for a specific policy, send a `GET` request to the Security Deployments Associations API using the policy name.

{{<bootstrap-table "table">}}

| Method | Endpoint                                                           |
|--------|--------------------------------------------------------------------|
| GET    | `/api/platform/v1/security/deployments/associations/{policy-name}` |

{{</bootstrap-table>}}

Example:

```shell
curl -X GET "https://{{NIM_FQDN}}/api/platform/v1/security/deployments/associations/ignore-xss" \
    -H "Authorization: Bearer <access token>"
```

In the response, look for the `lastDeploymentDetails` field under instance or `instanceGroup.instances`.


### Check publication status for a security log profile

{{<bootstrap-table "table">}}

| Method | Endpoint                                                                            |
|--------|-------------------------------------------------------------------------------------|
| GET    | `/api/platform/v1/security/deployments/logprofiles/associations/{log-profile-name}` |

{{</bootstrap-table>}}

Example:

```shell
curl -X GET "https://{{NIM_FQDN}}/api/platform/v1/security/deployments/logprofiles/associations/default-log" \
    -H "Authorization: Bearer <access token>"
```

The response also contains `lastDeploymentDetails` for each instance or group.

### Check status for a specific instance

You can also view the deployment status for a specific instance by providing the system UID and instance UID.

{{<bootstrap-table "table">}}

| Method | Endpoint                                                         |
|--------|------------------------------------------------------------------|
| GET    | `/api/platform/v1/systems/{system-uid}/instances/{instance-uid}` |

{{</bootstrap-table>}}

Example:

```shell
curl -X GET "https://{{NIM_FQDN}}/api/platform/v1/systems/<system-uid>/instances/<instance-uid>" \
    -H "Authorization: Bearer <access token>"
```

In the response, look for the `lastDeploymentDetails` field, which shows the deployment status and any related errors.

### Check deployment result by deployment ID

When you use the Publish API to [publish security content](#publish-policy), NGINX Instance Manager creates a deployment ID for the request. You can use this ID to check the result of the publication.

{{<bootstrap-table "table">}}

| Method | Endpoint                                                         |
|--------|------------------------------------------------------------------|
| GET    | `/api/platform/v1/systems/instances/deployments/{deployment-id}` |

{{</bootstrap-table>}}

Example:

```shell
curl -X GET "https://{{NIM_FQDN}}/api/platform/v1/systems/instances/deployments/<deployment-id>" \
    -H "Authorization: Bearer <access token>"
```

The response includes the full deployment status, success or failure details, and any compiler error messages.
