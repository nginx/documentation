---
docs: DOCS-1327
---

With the Instance Manager REST API, you can add a commit hash to NGINX configurations if you use version control, such as Git. This will allow you to retrieve a configuration with a unique version identifier.

{{<see-also>}}{{< include "nim/how-to-access-nim-api.md" >}}{{</see-also>}}

<br>

{{<tabs name="hash-versioning-instance-group-config">}}

{{%tab name="POST"%}}

To add a commit hash to a new or existing config using the REST API, send an HTTP `POST` or `PUT` request to the Configs endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint   |
|--------|------------|
| `POST` or `PUT` | `/instance-groups/{instanceGroupUID}/config` |

{{</bootstrap-table>}}


<br>

{{<comment>}}Add param table here{{</comment>}}

{{< include "nim/how-to/version-control/version-control-api-params.md" >}}

<br>

<details open>
<summary>JSON request</summary>

{{< include "nim/how-to/version-control/json-request-post-externalId.md" >}}

</summary>
</details>

{{%/tab%}}

{{%tab name="GET"%}}

To view an instance group's config, send an HTTP `GET` request to the Instance Groups endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                |
|--------|-------------------------|
| `GET`  | `/instance-groups/{instanceGroupUID}` |

{{</bootstrap-table>}}


<br>

To view an instance group's config with a version-controlled hash, send an HTTP `GET` request to the Instance Groups endpoint and specify the `externalID`.


{{<bootstrap-table "table">}}

| Method | Endpoint                            |
|--------|-------------------------------------|
| `GET`  | `/instance-groups/{instanceGroupUID}/config?externalId={commit_hash}` |

{{</bootstrap-table>}}


<details open>
<summary>JSON response</summary>

{{< include "nim/how-to/version-control/json-response-get-externalId.md" >}}

</details>

{{%/tab%}}

{{</tabs>}}
