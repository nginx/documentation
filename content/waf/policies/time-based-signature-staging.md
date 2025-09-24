---
title: Time-based signature staging
weight: 1950
toc: true
nd-content-type: reference
nd-product: NAP-WAF
nd-docs: DOCS-000
---

When new attack signatures are introduced in an F5 WAF for NGINX policy, they are first tested in a staging environment before being promoted to production.

In many cases, it’s difficult to replicate real traffic accurately in staging. This makes genuine attack detection harder, increases the risk of false positives, and can potentially leave the application exposed. To address this, you can deploy new signatures in **staging mode**.

### Certification time

The **Certification Time** policy property defines the point in time when signatures have been tested, approved, and certified.

This feature uses the modification time of each signature to determine whether it should be staged or enforced.

### Types of signatures

{{< table >}}
| Type of Signature      | Description                                                                 |
| ---------------------- | --------------------------------------------------------------------------- |
| **Staging Signatures** | All signatures in the policy created or modified *after* the certification time. |
| **Enforced Signatures**| All signatures in the policy created or modified *before* or *exactly at* the certification time. |
{{< /table >}}

## Latest signature certification time

The **Latest Signature Certification Time** is the timestamp (in ISO date-time format) when the signatures in the policy are considered **trusted** by the user. This value separates **enforced signatures** from **signatures in staging**.

- If this value is not defined and the staging flag is enabled, all signatures in the policy are in staging.
- If a signature was added to the policy but was created and last modified **before** the certification date-time, it will **not** be in staging.

### New signatures

A signature is considered **new** if it was introduced by a recent signature update applied to the policy.

{{< call-out "note" >}} Signatures added later by including a new signature set are **not** considered new unless they were added in the most recent signature update. These signatures will not be in staging.{{< /call-out >}}

## New policy

When a new policy is deployed, the user may prefer to have all its signatures placed in the staging environment.
To support this, the `performStaging` flag can be set to `true` at the signature settings level.

## Signature update

After applying a signature update (whether F5-provided or user-defined), if the update creation time is later than the previous update applied to the policy (that is, the signatures are **upgraded**, not downgraded), then:

- All signatures affected by the update (created or modified) are automatically put in **staging**, since their modification time is newer than the current **stagingCertificationDatetime**.
- Signatures that were **not affected** by the update will remain enforced and not be in staging.

## Configuration

### Staging certification date-time

A new property, `stagingCertificationDatetime`, is available in the `signature-settings` section.

- All signatures created or modified in a signature update **after** this time are placed in **staging**.
- All other signatures are **enforced** and not in staging.

The `stagingCertificationDatetime` property:
- Must be in **ISO 8601 date-time** format.
- Takes effect only if `performStaging` is set to `true`.
- Is **optional**. If absent, and `performStaging` is set to `true`, then all signatures are placed in the staging environment.

See the policy example below for more details:

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

## Enforcing modified signatures after testing

All signatures are considered to be in staging if their creation or modification time is later than the `stagingCertificationDatetime`.

- A signature in staging will be reported in the security log but will **not** block the request and will **not** raise the Violation Rating (threat score).
- The **potential Violation Rating** (what the score would have been if the signatures were enforced) is also reported.

### Moving signatures out of staging

After reviewing the logs and confirming that the new or modified signatures do not cause false positives, you should enforce them.

To do this:
1. Set the `stagingCertificationDatetime` to the timestamp of the **latest signature update**.
2. This moves all the signatures out of staging.
3. When you install a new signature update in the future, all new or modified signatures in that update will automatically be placed in staging.

{{< call-out "important" >}}
Do **not** set the `stagingCertificationDatetime` to the current time (when you finish reviewing).
- A future signature update might have been created **before** that time.
- If so, modified signatures from that update would be older than the `stagingCertificationDatetime`, and they would **not** be staged as expected.
{{< /call-out >}}

## Logging and reporting

Time-based signatures are logged and reported in the security log without blocking the request, as described in the section above.

The security log includes the following new fields under the `enforcementState`:

- `ratingIncludingViolationsInStaging` – The Violation Rating if there were no signatures in staging.
- `stagingCertificationDatetime` – The certification date-time value from the policy.
- **Signature staging state** – The specific staging state of the signature.
- `lastUpdateTime` – The last modification time of the signature, allowing the user to determine why the signature was (or was not) in staging.

```json
json_log="{""id"":""7103271131347005954"",""violations"":[{""enforcementState"":{""isBlocked"":true,""isAlarmed"":true,""isInStaging"":false,""isLearned"":false,""isLikelyFalsePositive"":false},""violation"":{""name"":""VIOL_ATTACK_SIGNATURE""},""signature"":{""name"":""XSS script tag (Parameter)"",""signatureId"":200000098,""accuracy"":""high"",""risk"":""high"",""hasCve"":false,""stagingCertificationDatetime"":""2024-01-01T00:00:00Z"",""lastUpdateTime"":""2023-11-02T19:36:54Z""},""snippet"":{""buffer"":""cGFyYW09PHNjcmlwdA=="",""offset"":6,""length"":7},""policyEntity"":{""parameters"":[{""name"":""*"",""level"":""global"",""type"":""wildcard""}]},""observedEntity"":{""name"":""cGFyYW0="",""value"":""PHNjcmlwdA=="",""location"":""query""}},{""enforcementState"":{""isBlocked"":false,""isAlarmed"":true,""isLearned"":false},""violation"":{""name"":""VIOL_PARAMETER_VALUE_METACHAR""},""policyEntity"":{""parameters"":[{""name"":""*"",""level"":""global"",""type"":""wildcard""}]},""observedEntity"":{""name"":""cGFyYW0="",""value"":""PHNjcmlwdA=="",""location"":""query""},""metachar"":""0x3c"",""charsetType"":""parameter-value""},{""enforcementState"":{""isBlocked"":false},""violation"":{""name"":""VIOL_HTTP_PROTOCOL""},""policyEntity"":{""blocking-settings"":{""http-protocols"":{""description"":""Host header contains IP address""}}}},{""enforcementState"":{""isBlocked"":true},""violation"":{""name"":""VIOL_RATING_THREAT""}},{""enforcementState"":{""isBlocked"":false},""violation"":{""name"":""VIOL_BOT_CLIENT""}}],""enforcementAction"":""block"",""method"":""GET"",""clientPort"":6026,""clientIp"":""10.42.0.1"",""host"":""nginx-78b84c446f-flw6h"",""responseCode"":0,""serverIp"":""0.0.0.0"",""serverPort"":80,""requestStatus"":""blocked"",""url"":""L2luZGV4LnBocA=="",""virtualServerName"":""24-localhost:1-/"",""enforcementState"":{""isBlocked"":true,""isAlarmed"":true,""rating"":4,""attackType"":[{""name"":""Non-browser Client""},{""name"":""Abuse of Functionality""},{""name"":""Cross Site Scripting (XSS)""},{""name"":""Other Application Activity""},{""name"":""HTTP Parser Attack""}],""ratingIncludingViolationsInStaging"":4,""stagingCertificationDatetime"":""2024-01-01T00:00:00Z""},""requestDatetime"":""2023-12-27T14:22:29Z""
```
