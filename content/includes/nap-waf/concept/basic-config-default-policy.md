---
nd-docs: DOCS-000
---

The base template is the common starting point to any policy you write. The default policy just reflects that template without any further modifications, thus we use the terms **base template** and **default policy** interchangeably. The default policy appears as follows

```json
{
    "policy" : {
        "name": "app_protect_default_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" }
    }
}
```

The default policy enforces violations by **Violation Rating**, the App Protect computed assessment of the risk of the request based on the triggered violations.

- 0: No violation
- 1-2: False positive
- 3: Needs examination
- 4-5: Threat

The default policy enables most of the violations and signature sets with Alarm turned ON, but not Block. These violations and signatures, when detected in a request, affect the violation rating. By default, if the violation rating is calculated to be malicious (4-5) the request will be blocked by the `VIOL_RATING_THREAT` violation. This is true even if the other violations and signatures detected in that request had the Block flag turned OFF. It is the `VIOL_RATING_THREAT` violation having the Block flag turned ON that caused the blocking, but indirectly the combination of all the other violations and signatures in Alarm caused the request to be blocked. By default, other requests which have a lower violation rating are not blocked, except for some specific violations described below. This is to minimize false positives. However, you can change the default behavior. For example, if you want to add blocking on a violation rating of 3 as well, enable blocking for the `VIOL_RATING_NEED_EXAMINATION` violation.

The following violations and signature sets have a low chance of being false positives and are, therefore, configured by default to block the request regardless of its Violation Rating:
- High accuracy attack signatures
- Threat campaigns
- Malformed request: unparsable header, malformed cookie and malformed body (JSON or XML).
