---
docs: DOCS-1329
---

If you edit an NGINX configuration in the Instance Manager web interface or directly on the data plane, the previous hashed commit information will lost: the `externalID` will revert to `null` and `externalIdType` will revert to `other` automatically. The same result will occur if you don't specify the `externalId` when making updates using the REST API.
