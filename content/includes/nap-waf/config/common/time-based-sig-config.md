---
nd-docs: DOCS-1491
---

A new property known as `stagingCertificationDatetime` is added to `signature-settings` section. All signatures that were created or modified in a signature update that is later than that time are in staging while all the rest are enforced and not in staging.

The `stagingCertificationDatetime` property will contain `ISO 8601` date-time format. It has effect only if `performStaging` is set to true. It is **optional** and its absence means that all signatures are placed in the staging environment, assuming the `performStaging` setting is set to true.

See below policy for more details.
```json
{
     "policy" : {
        "applicationLanguage" : "utf-8",
        "description" : "Nginx Policy",
        "enforcementMode" : "blocking",
        "fullPath" : "/Common/my_test_nginx_policy",
        "name" : "my_test_nginx_policy",
        "performStaging" : true,
        "signature-settings" : {
           "stagingCertificationDatetime": "2023-06-13T14:53:24Z",
           "signatureStaging": true
        },
        "template" : {
           "name" : "POLICY_TEMPLATE_NGINX_BASE"
        },
        "type" : "security"
    }
   }
```