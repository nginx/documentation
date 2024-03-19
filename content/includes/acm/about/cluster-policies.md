---
docs: DOCS-1284
---

The following table shows the available Cluster Policies you can use when creating a new cluster.

<br>

**Legend:**

- <i class="fa-solid fa-check"></i> = Supported
- <i class="fa-solid fa-circle-check center"></i> = Applied by default

{{<bootstrap-table "table table-striped table-bordered">}}

| Policy&nbsp;Name                                                  | HTTP Environment                                | gRPC Environment                                | Applied&nbsp;On | Description                                                                                                                                                                                                                                                                                                                                                                                        |
|-------------------------------------------------------------------|-------------------------------------------------|-------------------------------------------------|-----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Cluster Wide Config Setting]({{< relref "/nms/acm/how-to/policies/cluster-wide-config.md" >}})                                             | <i class="fa-solid fa-circle-check center"></i> | <i class="fa-solid fa-circle-check center"></i> | inbound        | Fine tune the settings to speed up data processing and improve the performance of the API proxy for large number of connections. When applied, the settings are applicable to all the instances in a proxy cluster. If the proxy cluster is shared between environments, the changes made in any environment will be reflected in all the other environments.                                                                                                                                                                                                                                                                                               |
| [Cluster Zone Sync]({{< relref "/nms/acm/how-to/policies/cluster-zone-sync.md" >}})  | <i class="fa-solid fa-check"></i> | <i class="fa-solid fa-check"></i> | inbound        | Enables runtime state sharing between the instances belonging to a proxy cluster. Options configured through this policy affect other policies such as rate limit and OIDC. This policy is applied to all the instances in a proxy cluster. If the proxy cluster is shared between environments, any changes made to this policy will affect all the other environments.                                                                                                          |

{{</bootstrap-table>}}
