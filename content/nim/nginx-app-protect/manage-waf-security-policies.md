---
title: Manage WAF Security Policies and Security Log Profiles
description: Learn how to use F5 NGINX Management Suite Instance Manager to manage NGINX
  App Protect WAF security policies and security log profiles.
weight: 200
toc: true
type: how-to
product: NIM
docs: DOCS-1105
---

## Overview

F5 NGINX Management Suite Instance Manager provides the ability to manage the configuration of NGINX App Protect WAF instances either by the user interface or the REST API. This includes editing, updating, and deploying security policies, log profiles, attack signatures, and threat campaigns to individual instances and/or instance groups.

In Instance Manager v2.14.0 and later, you can compile a security policy, attack signatures, and threat campaigns into a security policy bundle. A security policy bundle consists of the security policy, the attack signatures, and threat campaigns for a particular version of NGINX App Protect WAF, and additional supporting files that make it possible for NGINX App Protect WAF to use the bundle. Because the security policy bundle is pre-compiled, the configuration gets applied faster than when you individually reference the security policy, attack signature, and threat campaign files.

{{<note>}}
The following capabilities are only available via the Instance Manager REST API:

- Update security policies
- Create, read, and update security policy bundles
- Create, read, update, and delete Security Log Profiles
- Publish security policies, security log profiles, attack signatures, and/or threat campaigns to instances and instance groups
{{</note>}}

---

## Before You Begin

Complete the following prerequisites before proceeding with this guide:

- [Set Up App Protect WAF Configuration Management]({{< ref "setup-waf-config-management" >}})
- Verify that your user account has the [necessary permissions]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}) to access the Instance Manager REST API:

  - **Module**: Instance Manager
  - **Feature**: Instance Management
  - **Access**: `READ`
  - **Feature**: Security Policies
  - **Access**: `READ`, `CREATE`, `UPDATE`, `DELETE`

The following are required to use support policy bundles:

- You must have `UPDATE` permissions for the security policies specified in the request.
- The correct `nms-nap-compiler` packages for the NGINX App Protect WAF version you're using are [installed on Instance Manager]({{< ref "/nim/nginx-app-protect/setup-waf-config-management.md#install-the-waf-compiler" >}}).
- The attack signatures and threat campaigns that you want to use are [installed on Instance Manager]({{< ref "/nim/nginx-app-protect/setup-waf-config-management.md#set-up-attack-signatures-and-threat-campaigns" >}}).

### How to Access the Web Interface

To access the web interface, go to the FQDN for your NGINX Instance Manager host in a web browser and log in. Once you're logged in, select "Instance Manager" from the Launchpad menu.

### How to Access the REST API

{{< include "nim/how-to-access-nim-api.md" >}}

---

## Create a Security Policy {#create-security-policy}

{{<tabs name="create-security-policy">}}

{{%tab name="web interface"%}}

<br>

To create a security policy using the Instance Manager web interface:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in. Then, from the Launchpad menu, select **Instance Manager**.
2. On the left menu, select **App Protect**.
3. On the *Security Policies* page, select **Create**.
4. On the *Create Policy* page, fill out the necessary fields:

   - **Name**: Provide a name for the policy.
   - **Description**: (Optional) Add a short description for the policy.
   - **Enter Policy**: Type or paste the policy in JSON format into the form provided. The editor will validate the JSON for accuracy.

      For more information about creating custom policies, refer to the [NGINX App Protect WAF Declarative Policy](https://docs.nginx.com/nginx-app-protect/declarative-policy/policy/) guide and the [Policy Authoring and Tuning](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#policy-authoring-and-tuning) section of the config guide.

5. Select **Save**.

{{%/tab%}}

{{%tab name="API"%}}

To upload a new security policy, send an HTTP `POST` request to the Security Policies API endpoint.

{{<important>}}Before sending a security policy to Instance Manager, you need to encode it using `base64`. Submitting a policy in its original JSON format will result in an error.{{</important>}}

<br>


{{<bootstrap-table "table">}}

| Method | Endpoint                             |
|--------|--------------------------------------|
| POST   | `/api/platform/v1/security/policies` |

{{</bootstrap-table>}}


For example:

```shell
curl -X POST https://{{NMS_FQDN}}/api/platform/v1/security/policies \
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
    "uid": "21daa130-4ba4-442b-bc4e-ab294af123e5"
  },
  "selfLink": {
    "rel": "/api/platform/v1/services/environments/prod"
  }
}
```

{{%/tab%}}

{{</tabs>}}

---

## Update a Security Policy

To update a security policy, send an HTTP `POST` request to the Security Policies API endpoint, `/api/platform/v1/security/policies`.

You can use the optional `isNewRevision` parameter to indicate whether the updated policy is a new version of an existing policy.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                |
|--------|---------------------------------------------------------|
| POST   | `/api/platform/v1/security/policies?isNewRevision=true` |
| PUT    | `/api/platform/v1/security/policies/{system_id_string}` |

{{</bootstrap-table>}}


For example:

```shell
curl -X POST https://{{NMS_FQDN}}/api/platform/v1/security/policies?isNewRevision=true \
    -H "Authorization: Bearer <access token>" \
    -d @update-xss-policy.json
```

You can update a specific policy by sending an HTTP `PUT` request to the Security Policies API endpoint that includes the policy's unique identifier (UID).

To find the UID, send an HTTP `GET` request to the Security Policies API endpoint. This returns a list of all Security Policies that contains the unique identifier for each policy.

Include the UID for the security policy in your `PUT` request to update the policy. Once the policy update is accepted, the WAF compiler will create a new, updated bundle.

For example:

```shell
curl -X PUT https://{{NMS_FQDN}}/api/platform/v1/security/policies/23139e0a-4ac8-49f9-b7a0-0577b42c70c7 \
    -H "Authorization: Bearer <access token>" \
    --Content-Type application/json -d @update-xss-policy.json
```

After you have pushed an updated security policy, you can [publish it](#publish-policy) to selected instances or instance groups.

---

## Delete a Security Policy

{{<tabs name="delete-security-policy">}}

{{%tab name="web interface"%}}

<br>

To delete a security policy using the Instance Manager web interface:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in. Then, from the Launchpad menu, select **Instance Manager**.
2. On the left menu, select **App Protect**.
3. On the *Security Policies* page, select the **Actions** menu (represented by an ellipsis, **...**) for the policy you want to delete. Select **Delete** to remove the policy.

{{%/tab%}}

{{%tab name="API"%}}

To delete a security policy, send an HTTP `DELETE` request to the Security Policies API endpoint that includes the unique identifier for the policy that you want to delete.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                   |
|--------|------------------------------------------------------------|
| DELETE | `/api/platform/v1/security/policies/{security-policy-uid}` |

{{</bootstrap-table>}}


For example:

```shell
curl -X DELETE https://{{NMS_FQDN}}/api/platform/v1/security/policies/23139e0a-4ac8-49f9-b7a0-0577b42c70c7 \
    -H "Authorization: Bearer <access token>"
```

{{%/tab%}}

{{</tabs>}}

{{%comment%}}TO DO: Add sections for managing attack signatures and threat campaigns{{%/comment%}}

---

## Create Security Policy Bundles {#create-security-policy-bundles}

To create security policy bundles, send an HTTP `POST` request to the Security Policies Bundles API endpoint. The specified security policies you'd like to compile into security policy bundles must already exist in Instance Manager.

### Required Fields

- `appProtectWAFVersion`: The version of NGINX App Protect WAF being used.
- `policyName`: The name of security policy to include in the bundle. This must reference an existing security policy; refer to the [Create a Security Policy](#create-security-policy) section above for instructions.

### Notes

- If you do not specify a value for the `attackSignatureVersionDateTime` and/or `threatCampaignVersionDateTime` fields, the latest version of each will be used by default. You can also explicitly state that you want to use the most recent version by specifying the keyword `latest` as the value.
- If the `policyUID` field is not defined, the latest version of the specified security policy will be used. This field **does not allow** use of the keyword `latest`.

{{<bootstrap-table "table">}}

| Method | Endpoint                             |
|--------|--------------------------------------|
| POST   | `/api/platform/v1/security/policies/bundles` |

{{</bootstrap-table>}}

For example:

```shell
curl -X POST https://{{NMS_FQDN}}/api/platform/v1/security/policies/bundles \
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
      "policyUID": "29d86fe8-612a-5c69-895a-04fc5b9849a6",
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
        "policyUID": "29d86fe8-612a-5c69-895a-04fc5b9849a6",
        "attackSignatureVersionDateTime": "2023.06.20",
        "threatCampaignVersionDateTime": "2023.07.18",
        "uid": "dceb8254-9a90-4e77-87ac-73070f821412"
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
        "policyName": "defautl-enforcement",
        "policyUID": "04fc5b9849a6-612a-5c69-895a-29d86fe8",
        "attackSignatureVersionDateTime": "2023.08.10",
        "threatCampaignVersionDateTime": "2023.08.09",
        "uid": "trs35lv2-9a90-4e77-87ac-ythn4967"
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
        "policyUID": "849a604fc5b9-612a-5c69-895a-86f29de8",
        "attackSignatureVersionDateTime": "2023.08.10",
        "threatCampaignVersionDateTime": "2023.08.09",
        "uid": "nbu844lz-9a90-4e77-87ac-zze8861d"
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

## List Security Policy Bundles {#list-security-policy-bundles}

To list security policy bundles, send an HTTP `GET` request to the Security Policies Bundles API endpoint.

{{<note>}}The list will only contain the security policy bundles that you have "READ" permissions for in Instance Manager.{{</note>}}

You can filter the results by using the following query parameters:

- `includeBundleContent`: Boolean indicating whether to include the security policy bundle content for each bundle when getting a list of bundles or not. If not provided, defaults to `false`. Please note that the content returned is `base64 encoded`.
- `policyName`: String used to filter the list of security policy bundles; only security policy bundles that have the specified security policy name will be returned. If not provided, it will not filter based on `policyName`.
- `policyUID`: String used to filter the list of security policy bundles; only security policy bundles that have the specified security policy UID will be returned. If not provided, it will not filter based on `policyUID`.
- `startTime`: The security policy bundle's "modified time" has to be equal to or greater than this time value. If no value is supplied, it defaults to 24 hours from the current time. `startTime` has to be less than `endTime`.
- `endTime`: Indicates the time that the security policy bundles modified time has to be less than. If no value is supplied, it defaults to current time. `endTime` has to be greater than `startTime`.

<br>


{{<bootstrap-table "table">}}

| Method | Endpoint                             |
|--------|--------------------------------------|
| GET    | `/api/platform/v1/security/policies/bundles` |

{{</bootstrap-table>}}


For example:

```shell
curl -X GET https://{{NMS_FQDN}}/api/platform/v1/security/policies/bundles \
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
        "policyUID": "29d86fe8-612a-5c69-895a-04fc5b9849a6",
        "attackSignatureVersionDateTime": "2023.06.20",
        "threatCampaignVersionDateTime": "2023.07.18",
        "uid": "dceb8254-9a90-4e77-87ac-73070f821412"
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
        "policyUID": "04fc5b9849a6-612a-5c69-895a-29d86fe8",
        "attackSignatureVersionDateTime": "2023.08.10",
        "threatCampaignVersionDateTime": "2023.08.09",
        "uid": "trs35lv2-9a90-4e77-87ac-ythn4967"
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
        "policyUID": "849a604fc5b9-612a-5c69-895a-86f29de8",
        "attackSignatureVersionDateTime": "2023.08.10",
        "threatCampaignVersionDateTime": "2023.08.09",
        "uid": "nbu844lz-9a90-4e77-87ac-zze8861d"
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

## Get a Security Policy Bundle {#get-security-policy-bundle}

To get a specific security policy bundle, send an HTTP `GET` request to the Security Policies Bundles API endpoint that contains the security policy UID and security policy bundle UID in the path.

{{<note>}}You must have "READ" permission for the security policy bundle to be able to retrieve information about a bundle by using the REST API.{{</note>}}

<br>


{{<bootstrap-table "table">}}

| Method | Endpoint                             |
|--------|--------------------------------------|
| GET    | `/api/platform/v1/security/policies/{security-policy-uid}/bundles/{security-policy-bundle-uid}` |

{{</bootstrap-table>}}


For example:

```shell
curl -X GET https://{{NMS_FQDN}}/api/platform/v1/security/policies/29d86fe8-612a-5c69-895a-04fc5b9849a6/bundles/trs35lv2-9a90-4e77-87ac-ythn4967 \
    -H "Authorization: Bearer <access token>"
```

The JSON response, shown in the example below, includes a `content` field that is base64 encoded. After you retrieve the information from the API, you will need to base64 decode the content field. You can include this in your API call, as shown in the following example cURL request:

```bash
curl -X GET "https://{NMS_FQDN}/api/platform/v1/security/policies/{security-policy-uid}/bundles/{security-policy-bundle-uid}" -H "Authorization: Bearer xxxxx.yyyyy.zzzzz" | jq -r '.content' | base64 -d > security-policy-bundle.tgz
```

<details open>
<summary>JSON Response</summary>

```json
{
  "metadata": {
    "created": "2023-10-04T23:19:58.502Z",
    "modified": "2023-10-04T23:19:58.502Z",
    "appProtectWAFVersion": "4.457.0",
    "policyUID": "29d86fe8-612a-5c69-895a-04fc5b9849a6",
    "attackSignatureVersionDateTime": "2023.08.10",
    "threatCampaignVersionDateTime": "2023.08.09",
    "uid": "trs35lv2-9a90-4e77-87ac-ythn4967"
  },
  "content": "ZXZlbnRzIHt9Cmh0dHAgeyAgCiAgICBzZXJ2ZXIgeyAgCiAgICAgICAgbGlzdGVuIDgwOyAgCiAgICAgICAgc2VydmVyX25hbWUgXzsKCiAgICAgICAgcmV0dXJuIDIwMCAiSGVsbG8iOyAgCiAgICB9ICAKfQ==",
  "compilationStatus": {
    "status": "compiled",
    "message": ""
  }
}
```

---

## Create a Security Log Profile {#create-security-log-profile}

Send an HTTP `POST` request to the Security Log Profiles API endpoint to upload a new security log profile.

{{<important>}}Before sending a security log profile to Instance Manager, you need to encode it using `base64`. Submitting a log profile in its original JSON format will result in an error.{{</important>}}

<br>


{{<bootstrap-table "table">}}

| Method | Endpoint                             |
|--------|--------------------------------------|
| POST   | `/api/platform/v1/security/logprofiles` |

{{</bootstrap-table>}}


For example:

```shell
curl -X POST https://{{NMS_FQDN}}/api/platform/v1/security/logprofiles \
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
    "uid": "54c35ad7-e082-4dc5-bb5d-2640a17d5620"
  },
  "selfLink": {
    "rel": "/api/platform/v1/security/logprofiles/54c35ad7-e082-4dc5-bb5d-2640a17d5620"
  }
}
```

---

## Update a Security Log Profile

To update a security log profile, send an HTTP `POST` request to the Security Log Profiles API endpoint, `/api/platform/v1/security/logprofiles`.

You can use the optional `isNewRevision` parameter to indicate whether the updated log profile is a new version of an existing log profile.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                |
|--------|---------------------------------------------------------|
| POST   | `/api/platform/v1/security/logprofiles?isNewRevision=true` |
| PUT    | `/api/platform/v1/security/logprofiles/{security-log-profile-uid}` |

{{</bootstrap-table>}}


For example:

```shell
curl -X POST https://{{NMS_FQDN}}/api/platform/v1/security/logprofiles?isNewRevision=true \
    -H "Authorization: Bearer <access token>" \
    -d @update-default-log.json
```

You can update a specific log profile by sending an HTTP `PUT` request to the Security Log Profiles API endpoint that includes the log profile's unique identifier (UID).

To find the UID, send an HTTP `GET` request to the Security Log Profiles API endpoint. This returns a list of all Security Log Profiles that contains the unique identifier for each log profile.

Include the UID for the security log profile in your `PUT` request to update the log profile.

For example:

```shell
curl -X PUT https://{{NMS_FQDN}}/api/platform/v1/security/logprofiles/23139e0a-4ac8-49f9-b7a0-0577b42c70c7 \
    -H "Authorization: Bearer <access token>" \
    --Content-Type application/json -d @update-default-log.json
```

After you have pushed an updated security log profile, you can [publish it](#publish-policy) to selected instances or instance groups.

---

## Delete a Security Log Profile

To delete a security log profile, send an HTTP `DELETE` request to the Security Log Profiles API endpoint that includes the unique identifier for the log profile that you want to delete.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                   |
|--------|------------------------------------------------------------|
| DELETE | `/api/platform/v1/security/logprofiles/{security-log-profile-uid}` |

{{</bootstrap-table>}}


For example:

```shell
curl -X DELETE https://{{NMS_FQDN}}/api/platform/v1/security/logprofiles/23139e0a-4ac8-49f9-b7a0-0577b42c70c7 \
    -H "Authorization: Bearer <access token>"
```

---

## Publish Updates to Instances {#publish-policy}

The Publish API lets you distribute security policies, security log profiles, attack signatures, and/or threat campaigns to instances and instance groups.

{{<tip>}}Use this endpoint *after* you've added or updated security policies, security log profiles, attack signatures, and/or threat campaigns.{{</tip>}}


{{<bootstrap-table "table">}}

| Method | Endpoint                            |
|--------|-------------------------------------|
| POST   | `/api/platform/v1/security/publish` |

{{</bootstrap-table>}}


When making a request to the Publish API, make sure to include all the necessary information for your specific use case:

- Instance and/or Instance Group UID(s) to push the bundle to
- Threat Campaign version and UID
- Attack Signature version and UID
- Security Policy UID(s)
- Security Log Profile UID(s)

For example:

```shell
curl -X PUT https://{{NMS_FQDN}}/api/platform/v1/security/publish -H "Authorization: Bearer <access token>"
```

<details open>
<summary>JSON Request</summary>

```json
{
  "publications": [
    {
      "attackSignatureLibrary": {
        "uid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "versionDateTime": "2022.10.02"
      },
      "instanceGroups": [
        "3fa85f64-5717-4562-b3fc-2c963f66afa6"
      ],
      "instances": [
        "3fa85f64-5717-4562-b3fc-2c963f66afa6"
      ],
      "logProfileContent": {
        "name": "default-log",
        "uid": "ffdbda39-88be-420a-b673-19d4183b7e4c"
      },
      "policyContent": {
        "name": "default-enforcement",
        "uid": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
      },
      "threatCampaign": {
        "uid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "versionDateTime": "2022.10.01"
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

## Check Security Policy and Security Log Profile Publication Status
When publishing an NGINX configuration that references a security policy and secuity log profile, the Instance Manager REST APIs can provide further details about the status of the configuration publications. To access this information, use the Instance Manager API endpoints and method as indicated.

To retrieve the details for the different configuration publication statuses for a particular security policy, send an HTTP `GET` request to the Security Deployments Associations API endpoint, providing the name of the security policy.

| Method | Endpoint                                                                    |
|--------|-----------------------------------------------------------------------------|
| GET    | `/api/platform/v1/security/deployments/associations/{security-policy-name}` |

You can locate the configuration publication status in the response within the field `lastDeploymentDetails` for instances and instance groups:

- `lastDeploymentDetails` (for an instance): associations -> instance -> lastDeploymentDetails
- `lastDeploymentDetails` (for an instance in an instance group): associations -> instanceGroup -> instances -> lastDeploymentDetails

The example below shows a call to the `security deployments associations` endpoint and the corresponding JSON response containing successful deployments.

```shell
curl -X GET "https://{NGINX-INSTANCE-MANAGER-FQDN}/api/platform/v1/security/deployments/associations/ignore-xss" -H "Authorization: Bearer <access token>"
```

<details close>
<summary>JSON Response</summary>

```json
{
  "associations": [
    {
      "attackSignatureLibrary": {
        "uid": "c69460cc-6b59-4813-8d9c-76e4a6c56b4b",
        "versionDateTime": "2023.02.16"
      },
      "instance": {
        "hostName": "ip-172-16-0-99",
        "lastDeploymentDetails": {
          "createTime": "2023-04-11T21:36:11.519174534Z",
          "details": {
            "failure": [],
            "pending": [],
            "success": [
              {
                "name": "ip-172-16-0-99"
              }
            ]
          },
          "id": "19cf5ed4-29d6-4139-b5f5-308c0d0ebb13",
          "message": "Instance config successfully published to",
          "status": "successful",
          "updateTime": "2023-04-11T21:36:14.008108979Z"
        },
        "systemUid": "0435a5de-41c1-3754-b2e8-9d9fe946bafe",
        "uid": "29d86fe8-612a-5c69-895a-04fc5b9849a6"
      },
      "instanceGroup": {
        "displayName": "inst_group_1",
        "instances": [
          {
            "hostName": "hostname1",
            "systemUid": "49d143c2-f556-4cd7-8658-76fff54fb861",
            "uid": "c8e15dcf-c504-4b7f-b52d-def7b8fd2f64",
            "lastDeploymentDetails": {
              "createTime": "2023-04-11T21:36:11.519174534Z",
              "details": {
                "failure": [],
                "pending": [],
                "success": [
                  {
                    "name": "ip-172-16-0-99"
                  }
                ]
              },
              "id": "19cf5ed4-29d6-4139-b5f5-308c0d0ebb13",
              "message": "Instance config successfully published to",
              "status": "successful",
              "updateTime": "2023-04-11T21:36:14.008108979Z"
            },
          },
          {
            "hostName": "hostname2",
            "systemUid": "88a99ab0-15bb-4719-9107-daf5007c33f7",
            "uid": "ed7e9173-794f-41af-80d9-4ed37d593247",
            "lastDeploymentDetails": {
              "createTime": "2023-04-11T21:36:11.519174534Z",
              "details": {
                "failure": [],
                "pending": [],
                "success": [
                  {
                    "name": "ip-172-16-0-99"
                  }
                ]
              },
              "id": "19cf5ed4-29d6-4139-b5f5-308c0d0ebb13",
              "message": "Instance config successfully published to",
              "status": "successful",
              "updateTime": "2023-04-11T21:36:14.008108979Z"
            },
          }
        ],
        "uid": "51f8addc-c0e9-438b-b0b6-3e4f1aa8202d"
      },
      "policyUid": "9991f237-d9c7-47b7-98aa-faa836838f38",
      "policyVersionDateTime": "2023-04-11T21:18:19.183Z",
      "threatCampaign": {
        "uid": "eab683fe-c2f1-4910-a88c-8bfbc6363164",
        "versionDateTime": "2023.02.15"
      }
    }
  ]
}
```

</details>

To retrieve the details for the different configuration publication statuses for a particular security log profile, send an HTTP `GET` request to the Security Deployments Associations API endpoint, providing the name of the security log profile.

| Method | Endpoint                                                                    |
|--------|-----------------------------------------------------------------------------|
| GET    | `/api/platform/v1/security/deployments/logprofiles/associations/{security-log-profile-name}` |

You can locate the configuration publication status in the response within the field `lastDeploymentDetails` for instances and instance groups:

- `lastDeploymentDetails` (for an instance): associations -> instance -> lastDeploymentDetails
- `lastDeploymentDetails` (for an instance in an instance group): associations -> instanceGroup -> instances -> lastDeploymentDetails

The example below shows a call to the `security deployments associations` endpoint and the corresponding JSON response containing successful deployments.

```shell
curl -X GET "https://{NGINX-INSTANCE-MANAGER-FQDN}/api/platform/v1/security/deployments/logprofiles/associations/default-log" -H "Authorization: Bearer <access token>"
```

<details close>
<summary>JSON Response</summary>

```json
{
  "associations": [
    {
      "instance": {
        "hostName": "",
        "systemUid": "",
        "uid": ""
      },
      "instanceGroup": {
        "displayName": "ig1",
        "instances": [
          {
            "hostName": "ip-172-16-0-142",
            "systemUid": "1d1f03ff-02de-32c5-8dfd-902658aada4c",
            "uid": "18d074e6-3868-51ba-9999-b7466a936815"
          }
        ],
        "lastDeploymentDetails": {
          "createTime": "2023-07-05T23:01:06.679136973Z",
          "details": {
            "failure": [],
            "pending": [],
            "success": [
              {
                "name": "ip-172-16-0-142"
              }
            ]
          },
          "id": "9bfc9db7-877d-4e8e-a43d-9660a6cd11cc",
          "message": "Instance Group config successfully published to ig1",
          "status": "successful",
          "updateTime": "2023-07-05T23:01:06.790802157Z"
        },
        "uid": "0df0386e-82f7-4efc-863e-5d7cfbc3f7df"
      },
      "logProfileUid": "b680f7c3-6fc0-4c6b-889a-3025580c7fcb",
      "logProfileVersionDateTime": "2023-07-05T22:08:47.371Z"
    },
    {
      "instance": {
        "hostName": "ip-172-16-0-5",
        "lastDeploymentDetails": {
          "createTime": "2023-07-05T21:45:08.698646791Z",
          "details": {
            "failure": [],
            "pending": [],
            "success": [
              {
                "name": "ip-172-16-0-5"
              }
            ]
          },
          "id": "73cf670a-738a-4a74-b3fb-ac9771e89814",
          "message": "Instance config successfully published to",
          "status": "successful",
          "updateTime": "2023-07-05T21:45:08.698646791Z"
        },
        "systemUid": "0afe5ac2-43aa-36c8-bcdc-7f88cdd35ab2",
        "uid": "9bb4e2ef-3746-5d79-b526-e545fad27e90"
      },
      "instanceGroup": {
        "displayName": "",
        "instances": [],
        "uid": ""
      },
      "logProfileUid": "bb3badb2-f8f5-4b95-9428-877fc208e2f1",
      "logProfileVersionDateTime": "2023-07-03T21:46:17.006Z"
    }
  ]
}
```

</details>

To retrieve the configuration publication status details for a particular instance, send an HTTP `GET` request to the Instances API endpoint, providing the unique system and instance identifiers.

| Method | Endpoint                                                        |
|--------|-----------------------------------------------------------------|
| GET    | `/api/platform/v1/systems/{system-uid}/instances/{instance-id}` |

You can locate the configuration publication status in the the response within the `lastDeploymentDetails` field, which contains additional fields that provide more context around the status.

The example below shows a call to the `instances` endpoint and the corresponding JSON response containing a compiler related error message.

```shell
curl -X GET "https://{NGINX-INSTANCE-MANAGER-FQDN}/api/platform/v1/systems/b9df6377-2c4f-3266-a64a-e064b0371c73/instances/5663cf4e-a0c7-50c8-b93c-16fd11a0f00b" -H "Authorization: Bearer <access token>"
```

<details close>
<summary>JSON Response</summary>

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
        "createTime": "2023-01-14T10:48:46.319Z",
        "uid": "5663cf4e-a0c7-50c8-b93c-16fd11a0f00b",
        "versionHash": "922e9d40fa6d4dd3a4b721295b8ecd95f73402644cb8d234f9f4f862b8a56bfc"
      }
    ]
  },
  "displayName": "ip-192-0-2-27",
  "links": [
    {
      "rel": "/api/platform/v1/systems/b9df6377-2c4f-3266-a64a-e064b0371c73",
      "name": "system"
    },
    {
      "rel": "/api/platform/v1/systems/b9df6377-2c4f-3266-a64a-e064b0371c73/instances/5663cf4e-a0c7-50c8-b93c-16fd11a0f00b",
      "name": "self"
    },
    {
      "rel": "/api/platform/v1/systems/instances/deployments/b31c6ab1-4a46-4c81-a065-204575145e8e",
      "name": "deployment"
    }
  ],
  "processPath": "/usr/sbin/nginx",
  "registrationTime": "2023-01-14T10:12:31.000Z",
  "startTime": "2023-01-14T10:09:43Z",
  "status": {
    "lastStatusReport": "2023-01-14T11:11:49.323495017Z",
    "state": "online"
  },
  "uid": "5663cf4e-a0c7-50c8-b93c-16fd11a0f00b",
  "version": "1.23.2",
  "appProtect": {
    "attackSignatureVersion": "Available after publishing Attack Signatures from Instance Manager",
    "status": "active",
    "threatCampaignVersion": "Available after publishing Threat Campaigns from Instance Manager",
    "version": "4.2.0"
  },
  "configureArgs": [
    ...
  ],
  "lastDeploymentDetails": {
    "createTime": "2023-01-14T11:10:25.096812852Z",
    "details": {
      "error": "{\"instance:b9df6377-2c4f-3266-a64a-e064b0371c73\":\"failed building config payload: policy compilation failed for deployment b31c6ab1-4a46-4c81-a065-204575145e8e due to integrations service error: the specified compiler (4.2.0) is missing, please install it and try again.\"}",
      "failure": [
        {
          "failMessage": "failed building config payload: policy compilation failed for deployment b31c6ab1-4a46-4c81-a065-204575145e8e due to integrations service error: the specified compiler (4.2.0) is missing, please install it and try again.",
          "name": "ip-192-0-2-27"
        }
      ],
      "pending": [],
      "success": []
    },
    "id": "b31c6ab1-4a46-4c81-a065-204575145e8e",
    "message": "Instance config failed to publish to",
    "status": "failed",
    "updateTime": "2023-01-14T11:10:25.175145693Z"
  },
  "loadableModules": [
    ...
  ],
  "packages": [
    ...
  ],
  "processId": "10345",
  "ssl": {
    "built": null,
    "runtime": null
  }
}
```

</details>

When you use the Publish API (`/security/publish`) to [publish a security policy and security log profile](#publish-policy), Instance Manager creates a deployment ID for the request. To view the status of the update, or to check for any errors, use the endpoint and method shown below and reference the deployment ID.

| Method | Endpoint                                                         |
|--------|------------------------------------------------------------------|
| GET    | `/api/platform/v1/systems/instances/deployments/{deployment-id}` |

You can locate the configuration publication status in the the response within the `details` field, which contains additional fields that provide more context around the status.

The example below shows a call to the `deployments` endpoint and the corresponding JSON response containing a compiler error message.

```shell
curl -X GET --url "https://{NGINX-INSTANCE-MANAGER-FQDN}/api/platform/v1/systems/instances/deployments/d38a8e5d-2312-4046-a60f-a30a4aea1fbb" \
    -H "Authorization: Bearer <access token>"
```

<details open>
<summary>JSON Response</summary>

```json
{
  "createTime": "2023-01-14T04:35:47.566082799Z",
  "details": {
    "error": "{\"instance:8a2092aa-5612-370d-bff0-5d7521e206d6\":\"failed building config payload: policy bundle compilation failed for d38a8e5d-2312-4046-a60f-a30a4aea1fbb, integrations service returned the following error: missing the specified compiler (4.2.0) please install it and try again\"}",
    "failure": [
      {
        "failMessage": "failed building config payload: policy bundle compilation failed for d38a8e5d-2312-4046-a60f-a30a4aea1fbb, integrations service returned the following error: missing the specified compiler (4.2.0) please install it and try again",
        "name": "ip-192-0-2-243"
      }
    ],
    "pending": [],
    "success": []
  },
  "id": "d38a8e5d-2312-4046-a60f-a30a4aea1fbb",
  "message": "Instance config failed to publish to",
  "status": "failed",
  "updateTime": "2023-01-14T04:35:47.566082799Z"
}
```

</details>
