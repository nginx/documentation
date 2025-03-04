---
title: "Custom roles and API groups"
weight: 500
toc: true
type: reference
product: NGINX One
docs: DOCS-000
---

Beyond [Default roles]({{< relref "/nginx-one/rbac/roles.md" >}}), you may need to set up custom roles. For convenience, we include a list of API groups that you could use to specify permissions for custom roles.

These are not NGINX One APIs.

## F5 API groups for NGINX One

The following table lists the **[F5 XC roles](https://docs.cloud.f5.com/docs-v2/administration/how-tos/user-mgmt/roles)** that you can use. These are narrowly scoped API Groups that align with all the features and functionality within the NGINX One Console. These groups can help you create custom roles tailored to your specific needs.

{{< note >}}If you create custom roles using the more granular API Groups, users may not have access until you add the corresponding API Groups to their roles.{{< /note >}}

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
| f5xc-nginx-one-custom-certificate-manage            | Write           | View TSL/SSL certificate details. Create, update, and delete any managed certificates.                                    |
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
| f5xc-nginx-one-custom-ai-assistant                  | Write           | Interact with the NGINX One AI Assistant.                                                                                     |
| f5xc-nginx-one-custom-staged-config-manage         | Write           | View, create, update, and delete Staged Configs.                                                                          |
| f5xc-nginx-one-custom-staged-config-read           | Read            | View Staged Configs.                                                                                                      |
