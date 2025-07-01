---
nd-docs: "DOCS-1609"
---

When `app_protect_custom_log_attribute` is assigned to a particular location/server/http context, it will appear in the `json_log` field as a new JSON property called "customLogAttributes" at the top level. The property will not appear if no `app_protect_custom_log_attribute` directive was assigned.

Attributes at the http level applies to all servers and locations unless a specific server or location overrides the same key with a different value. Same goes for the server level and all locations under it. In the below example, the "environment" attribute will appear in logs of all locations under that server.

Security logging example in json_log:

```json
""customLogAttribute"":[{""name"":""component"",""value"":""comp1""},{""name"":""gateway"",""value"":""gway1""}]}"
```