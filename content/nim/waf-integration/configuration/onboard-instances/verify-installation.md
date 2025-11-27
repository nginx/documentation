---
title: Verify instance onboarding
description: Verify that F5 WAF for NGINX instances are connected and reporting to NGINX Instance Manager.
toc: true
weight: 300
nd-content-type: how-to
nd-product: NIMNGR
nd-docs:
---

{{< call-out "note" "Before you begin" >}}
- [Install NGINX Agent]({{< ref "/nim/waf-integration/configuration/onboard-instances/install-nginx-agent.md" >}})
- [Configure NGINX Agent]({{< ref "/nim/waf-integration/configuration/onboard-instances/configure-nginx-agent.md" >}})
{{< /call-out >}}

After installing and configuring NGINX Agent, verify that your F5 WAF for NGINX instances appear in NGINX Instance Manager.

{{<tabs name="agent-verify">}}

{{%tab name="Web interface"%}}

You can view your F5 WAF for NGINX instances in the Instance Manager web interface. Follow these steps to confirm that NGINX Agent is installed and reporting data correctly.

1. {{< include "nim/webui-nim-login.md" >}}
1. In the left menu, select **Instances**.
1. Confirm that each instance lists an F5 WAF for NGINX version in the **F5 WAF** column.
1. Select an instance and scroll to the **F5 WAF Details** section to verify its status and build information.

{{%/tab%}}

{{%tab name="API"%}}

{{< call-out "note" >}}{{< include "nim/how-to-access-nim-api.md" >}}{{< /call-out>}}

Use the REST API to check version and status details for F5 WAF for NGINX.

{{<bootstrap-table "table">}}

| Method | Endpoint                     |
|--------|------------------------------|
| GET    | `/api/platform/v1/instances` |
| GET    | `/api/platform/v1/systems`   |

{{</bootstrap-table>}}

- Send a `GET` request to `/api/platform/v1/systems` to check version information.

    **Example response:**

    ```json
    {
      "count": 3,
      "items": [
        {
          "appProtect": {
            "attackSignatureVersion": "2022.11.16",
            "status": "active",
            "threatCampaignVersion": "2022.11.15",
            "version": "build-3.954.0"
          }
        }
      ]
    }
    ```

- Send a `GET` request to `/api/platform/v1/instances` to check how many instances have F5 WAF for NGINX installed.

    **Example response:**

    ```json
    {
      "count": 3,
      "items": [
        [...]
      ],
      "nginxAppProtectWAFCount": 2,
      "nginxPlusCount": 3
    }
    ```

{{%/tab%}}
{{</tabs>}}