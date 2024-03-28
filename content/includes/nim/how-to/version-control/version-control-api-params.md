---
docs: DOCS-1328
---

The following table lists the parameters to include when adding version control identifiers to a config:


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field            | Type   | Possible&nbsp;Values                                                                                | <div style="width:400px">Description<div>                                                                                                                                  | Required | Default&nbsp;value |
|------------------|--------|-----------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|--------------------|
| `externalID`     | string | <p>Commit hash, 1–150 characters<p></p>For example, `521747298a3790fde1710f3aa2d03b55020575aa`.</p> | <p>The commit hash.</p>                                                                                                                                                    | No       | `null`             |
| `externalIdType` | string | `git`,<br>`other`                                                                                   | <p>The type of commit that was used for the config update.</p> <p>If the `externalID` isn't specified, the `externalIdType` reverts automatically to `other`.<p> | No       | `other`            |

{{< /bootstrap-table >}}

