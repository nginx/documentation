---
nd-docs: "DOCS-1560"
---

An error message "`app_protect_custom_log_attribute` directive is invalid" will be displayed in the Security Log if the below conditions are met:

1. If the `app_protect_custom_log_attribute` exceeds the maximum number of 10 directives
2. If the `app_protect_custom_log_attribute` exceeds the maximum name length of 64 chars
3. If the `app_protect_custom_log_attribute` exceeds the maximum value of 64 chars

Error message example:

```shell
app_protect_custom_log_attribute directive is invalid. Number of app_protect_custom_log_attribute directives exceeds maximum
```