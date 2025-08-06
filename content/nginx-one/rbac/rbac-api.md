---
title: "Set up custom roles with API groups"
weight: 500
toc: true
type: reference
product: NGINX One
nd-docs: DOCS-000
---

Beyond the [Default roles]({{< ref "/nginx-one/rbac/roles.md" >}}) for NGINX One Console access, you can create [custom roles](https://docs.cloud.f5.com/docs-v2/administration/how-tos/user-mgmt/roles#custom-roles) with more precisely defined access permissions.
You can assign custom roles to users or service accounts.

You can associate these roles with specific [namespaces](https://docs.cloud.f5.com/docs-v2/multi-cloud-app-connect/how-to/app-security/service-policy), to help facilitate the principle of least privilege across your tenant.
For this use-case, we include a list of API groups that you can use to specify permissions for custom roles with more granular access controls to NGINX One Console APIs.

## F5 API groups for NGINX One

The following table lists the available API groups that you can use to construct a Role. These are narrowly scoped API groups that align with all the features and functionality within the NGINX One Console. These groups can help you create custom roles tailored to your specific needs.

{{< call-out "note" >}}If you create custom roles using these API groups, users may not have access to all capabilities of the browser web portal.{{< /call-out >}}

| API Group Name                          | Level of Access | Description                                                                                                                   |
|-----------------------------------------|-----------------|-------------------------------------------------------------------------------------------------------------------------------|
| f5xc-nginx-one-application-monitor      | Read            | View all features and data.                                                                                                |
| f5xc-nginx-one-application-settings     | Write           | View and update settings.                                                                                                |
| f5xc-nginx-one-application-write        | Write           | View and edit all features except settings.                                                                         |
| f5xc-nginx-one-custom-all-instances-metric-read    | Read            | View metrics for all Instances. Required to see the Overview dashboard.                                                  |
| f5xc-nginx-one-custom-instance-list                 | Read            | View list of all Instances. Also view summarized information such as certificate status and CVEs.                                            |
| f5xc-nginx-one-custom-all-instances-manage          | Write           | View and delete all Instances.                                                                                                |
| f5xc-nginx-one-custom-instance-manage               | Write           | View and edit Instance details.                                                                        |
| f5xc-nginx-one-custom-instance-read                 | Read            | View Instance and configuration details.                                                                        |
| f5xc-nginx-one-custom-certificate-manage            | Write           | View TLS/SSL certificate details. Create, update, and delete any managed certificates.                                    |
| f5xc-nginx-one-custom-certificate-read              | Read            | View TLS/SSL certificates.                                                                                    |
| f5xc-nginx-one-custom-all-certificates-manage       | Write           | View all TLS/SSL certificates. Delete managed certificates.                                               |
| f5xc-nginx-one-custom-data-plane-key-manage         | Write           | View, create, update, and delete any Data Plane Keys. Note: The actual Data Plane Key is shown _only_ when created. |
| f5xc-nginx-one-custom-data-plane-key-read           | Read            | View Data Plane Key Details. Note: The actual Data Plane Key is shown _only_ when created.                      |
| f5xc-nginx-one-custom-all-data-plane-keys-manage     | Write           | View and delete Data Plane Keys.                                                                         |
| f5xc-nginx-one-custom-cve-read                 | Read            | View NGINX CVEs.                                                                                                  |
| f5xc-nginx-one-custom-config-sync-group-manage     | Write           | View, create, update, and delete Config Sync Groups.                                                                      |
| f5xc-nginx-one-custom-config-sync-group-read       | Read            | View Config Sync Groups with details.                                                                                |
| f5xc-nginx-one-custom-all-config-sync-groups-manage | Write           | View and delete Config Sync Groups.                                                                           |
| f5xc-nginx-one-custom-settings-manage               | Write           | View and update NGINX One Console Settings.                                                                               |
| f5xc-nginx-one-custom-settings-read                 | Read            | View NGINX One Console Settings.                                                                                          |
| f5xc-nginx-one-custom-event-read                   | Read            | View NGINX One Events.                                                                                                    |
| f5xc-nginx-one-custom-ai-assistant                  | Write           | Interact with the F5 AI Assistant.                                                                                     |
| f5xc-nginx-one-custom-staged-config-manage         | Write           | View, create, update, and delete Staged Configs.                                                                          |
| f5xc-nginx-one-custom-staged-config-read           | Read            | View Staged Configs.                                                                                                      |
