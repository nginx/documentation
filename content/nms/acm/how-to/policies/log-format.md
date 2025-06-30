---
description: As an Infrastructure Administrator, use this guide to implement a standard
  log format for all environments hosting APIs.
nd-docs: DOCS-1127
toc: true
weight: 700
title: Log Format
type:
- how-to
- reference
---

## Overview

{{< include "acm/how-to/policies-intro" >}}

---

## About the Policy

The Log Format policy enables Infrastructure Admins to set the format for access logs. Detailed access logs are generated in either JSON (default) or Syslog format and are applied to new environments automatically. This policy can be customized to filter log content, adjust log severity levels, and designate log destinations.

### Intended Audience

{{< include "acm/how-to/policies/infra-admin-persona.md">}}

---

## Workflow for Applying Policy

To apply the policy or make changes to it, here's what you need to do:

- [Edit an existing environment or create a new one]({{< ref "/nms/acm/how-to/infrastructure/manage-api-infrastructure.md#add-environment" >}}).
- Check the advanced settings for the environment to see if the policy has been applied.
- Edit the policy to make changes for each environment. Save and publish the changes.

---

## Policy Settings {#policy-settings}

The following table lists the configurable settings and their default values for the policy.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                                        | Type    | Possible Values                                                                                        | <div style="width:400px">Description</div>                                                                                                                                                               | Required | Default value                                                |
|----------------------------------------------|-------------|--------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|--------------------------------------------------------------|
| `type`                                       | string      | One of:<br>`[JSON,`<br>`NATIVE]`                                                                       | The access logs can be created in either JSON or native NGINX log format (Syslog).                                                                                                                       | Yes      | `JSON`                                                       |
| `logFormat.include`                          | string/enum | One or more of:<br>`["BASIC",`<br>`"INGRESS",`<br>`"BACKEND",`<br>`"RESPONSE"]`                        | Specifies what information should be logged.                                                                                                                                                             | No       | `["BASIC",`<br>`"INGRESS",`<br>`"BACKEND",`<br>`"RESPONSE"]` |
| `logFormat.variables`                        | string/enum | `List of values`                                                                                       | Only variables included in this array will be logged; everything else will be hidden.                                                                                                                    | No       | `Empty list []`                                              |
| `errorLogSeverity`                           | string      | One of:<br>`[DEBUG,`<br>`INFO,`<br>`NOTICE,`<br>`WARN,`<br>`ERROR,`<br>`CRIT,`<br>`ALERT,`<br>`EMERG]` | The minimum severity level of errors that will be logged.                                                                                                                                                | No       | `WARN`                                                       |
| `logDestination.type`                        | string/enum | One of:<br>`["FILE",`<br>`"SYSLOG"]`                                                                   | The destination for the log output, either a file or syslog.                                                                                                                                             | Yes      | `FILE`                                                       |
| `logDestination.`<br>`accessLogFileLocation` | string      | `/var/log/nginx`                                                                                       | The directory in which the access log file will be saved. The directory can be any valid UNIX filepath, with relative paths being relative to the default NGINX configuration directory (`/etc/nginx/`). | Yes      | `/var/log/nginx`                                             |
| `logDestination.`<br>`errorLogFileLocation`  | string      | `/var/log/nginx`                                                                                       | The directory in which the error log file will be saved. This directory can be any valid UNIX filepath, with relative paths being relative to the default NGINX configuration directory (`/etc/nginx/`). | No       | `/var/log/nginx`                                             |
| `enablePrettyPrint`                          | boolean     | `true`,<br>`false`                                                                                     | This setting adds whitespace and indentation to make JSON logs more easily readable for humans. This setting is applicable only when the `type` is set to `JSON`.                                        | No       | `false`                                                      |

{{< /bootstrap-table >}}


---

## Applying the Policy

In API Connectivity Manager, when an Infrastructure Administrator creates an environment, the following log format policy is applied by default:

- Logs are in JSON format
- Logs are written to file
- Logs are saved to `/var/log/nginx`

If these default options don't meet your requirements, you can customize the policy to suit your specific needs. Refer to the [Policy Settings](#policy-settings) section for the configurable options.

<br>

{{<tabs name="add_log_format_policy">}}
{{%tab name="API"%}}

<br>

{{<see-also>}}{{< include "acm/how-to/access-acm-api.md" >}}{{</see-also>}}

To add the Log Format policy using the REST API, send an HTTP `POST` request to the Environments endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| `POST` | `/infrastructure/workspaces/{workspace}/environments/{environment}` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

```json
{
  "policies": {
    "log-format": [
      {
        "action": {
          "enablePrettyPrint": false,
          "errorLogSeverity": "WARN",
          "logDestination": {
            "type": "FILE",
            "accessLogFileLocation": "/var/log/nginx/",
            "errorLogFileLocation": "/var/log/nginx/"
          },
          "logFormat": {
            "include": [
              "BASIC",
              "INGRESS",
              "BACKEND",
              "RESPONSE"
            ],
            "variables": []
          },
          "type": "JSON"
        }
      }
    ]
  }
}
```

This JSON example defines the log format policy for an environment: the error log severity level is set to `WARN`; the log file location is `/var/log/nginx/`; and the log format includes `BASIC`, `INGRESS`, `BACKEND`, and `RESPONSE` information without any variables specified to limit what is logged. The pretty print feature is disabled, and the log type is set to `JSON`.

</details>

{{%/tab%}}
{{%tab name="UI"%}}

<br>

To add the Log Format policy using the web interface:

1. In a web browser, go to the FQDN for your F5 NGINX Management Suite host and log in. Then, from the Launchpad menu, select **API Connectivity Manager**.
2. On the left menu, select **Infrastructure**.
3. On the *Workspaces* page, select a workspace in the list to which you'll add an environment.
4. Select **Add** to add the environment.
5. On the *Create Environment* form, complete the necessary fields:

   - **Name**: Enter a name for the environment.
   - **Description**: Describe the environment in a few words.
   - **Type**: Select whether this is a production environment or not.
   - **API Gateways**: Enter the API Gateway's name and hostname.

6. Select **Create**.
7. On the *Environment Created* confirmation page, select **Go to \<environment name>**.
8. In the *API Gateways* list, select the **Actions** menu (represented by an ellipsis, `...`). Then select **Edit Advanced Config**.
9. On the left menu, select **Global Policies**.
10. In the list of Global Policies, the Log Format policy should be enabled by default. To edit the policy, select the ellipsis icon (`...`), then select **Edit Policy**.
11. Customize the policy settings to suit your requirements. Refer to the [Policy Settings](#policy-settings) section for an overview of the available options and their possible configurations.
12. Select **Save** to save the changes.
13. Select **Save and Submit** to publish the policy changes to the environment.

{{%/tab%}}
{{</tabs>}}
