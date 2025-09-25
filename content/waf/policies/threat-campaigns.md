---
title: "Threat campaigns"
weight: 2000
toc: true
nd-content-type: reference
nd-product: NAP-WAF
nd-docs: DOCS-000
---

Threat campaigns is a threat intelligence feature included in an F5 WAF for NGINX subscription. The feature provides frequent update feeds containing contextual information about active attack campaigns currently being observed by F5 Threat Labs that F5 WAF for NGINX can protect against. For example, without threat campaign updates F5 WAF for NGINX (and any WAF in general) may detect an attack pattern in a web application form parameter, but it cannot correlate the individual incident as part of a broader and more sophisticated campaign. Threat campaigns provide highly specific, contextual information about current attack activity, which makes false positives virtually non-existent.

Just like attack signatures, the threat campaign patterns (`app-protect-attack-signatures` and `app-protect-threat-campaigns`) are installed as dependencies of the main `app-protect` package. These two dependencies should be [updated regularly]({{< ref "/waf/install/update-signatures.md" >}}) to ensure you have the latest security updates. Because threat campaigns change quickly, updates are issued far more frequently than attack signatures. For the most effective protection, you should install these updates as soon as they are released.

The default policy enables the mechanism with all available threat campaigns and blocks requests when one is detected. Since the risk of false positives is very low, there is no need to enable or disable specific threat campaigns. Instead, you can disable the entire mechanism or configure it to alarm only instead of blocking. This is controlled by modifying the properties of the threat campaign violation (`VIOL_THREAT_CAMPAIGN`).

In the following example, both alarm and blocking are disabled.

```json
{
   "policy": {
       "name": "policy_name",
       "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
       "applicationLanguage": "utf-8",
       "enforcementMode": "blocking",
       "blocking-settings": {
           "violations": [
               {
                   "name": "VIOL_THREAT_CAMPAIGN",
                   "alarm": false,
                   "block": false
               }
           ]
       }
   }
}
```
