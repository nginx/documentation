---
nd-docs: "DOCS-1554"
---

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Setting | JSON Property in Policy | Support in NGINX App Protect WAF | Value in Default Profile |
| ---| ---| ---| --- |
|Signature Sets | signature-sets | All available sets. | See signature set list below |
|Signatures | signatures | "Enabled" flag can be modified. | All signatures in the included sets are enabled. |
|Auto-Added signature accuracy | minimumAccuracyForAutoAddedSignatures | Editable | Medium |
{{</bootstrap-table>}}