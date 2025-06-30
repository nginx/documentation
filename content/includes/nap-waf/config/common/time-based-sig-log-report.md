---
nd-docs: DOCS-1494
---

Time-based Signature will be logged and reported in the Security log without blocking the request as discussed in the above section.

Security log will have the following new fields under the enforcementState:
-	The Violation Rating if there was no staging - `ratingIncludingViolationsInStaging`
-	The `stagingCertificationDatetime` from the policy
-	The specific staging state of the signature
-	The `lastUpdateTime` of the signature - for the user to be able to determine why the signature was (or was not) in staging.

```json
json_log="{""id"":""7103271131347005954"",""violations"":[{""enforcementState"":{""isBlocked"":true,""isAlarmed"":true,""isInStaging"":false,""isLearned"":false,""isLikelyFalsePositive"":false},""violation"":{""name"":""VIOL_ATTACK_SIGNATURE""},""signature"":{""name"":""XSS script tag (Parameter)"",""signatureId"":200000098,""accuracy"":""high"",""risk"":""high"",""hasCve"":false,""stagingCertificationDatetime"":""2024-01-01T00:00:00Z"",""lastUpdateTime"":""2023-11-02T19:36:54Z""},""snippet"":{""buffer"":""cGFyYW09PHNjcmlwdA=="",""offset"":6,""length"":7},""policyEntity"":{""parameters"":[{""name"":""*"",""level"":""global"",""type"":""wildcard""}]},""observedEntity"":{""name"":""cGFyYW0="",""value"":""PHNjcmlwdA=="",""location"":""query""}},{""enforcementState"":{""isBlocked"":false,""isAlarmed"":true,""isLearned"":false},""violation"":{""name"":""VIOL_PARAMETER_VALUE_METACHAR""},""policyEntity"":{""parameters"":[{""name"":""*"",""level"":""global"",""type"":""wildcard""}]},""observedEntity"":{""name"":""cGFyYW0="",""value"":""PHNjcmlwdA=="",""location"":""query""},""metachar"":""0x3c"",""charsetType"":""parameter-value""},{""enforcementState"":{""isBlocked"":false},""violation"":{""name"":""VIOL_HTTP_PROTOCOL""},""policyEntity"":{""blocking-settings"":{""http-protocols"":{""description"":""Host header contains IP address""}}}},{""enforcementState"":{""isBlocked"":true},""violation"":{""name"":""VIOL_RATING_THREAT""}},{""enforcementState"":{""isBlocked"":false},""violation"":{""name"":""VIOL_BOT_CLIENT""}}],""enforcementAction"":""block"",""method"":""GET"",""clientPort"":6026,""clientIp"":""10.42.0.1"",""host"":""nginx-78b84c446f-flw6h"",""responseCode"":0,""serverIp"":""0.0.0.0"",""serverPort"":80,""requestStatus"":""blocked"",""url"":""L2luZGV4LnBocA=="",""virtualServerName"":""24-localhost:1-/"",""enforcementState"":{""isBlocked"":true,""isAlarmed"":true,""rating"":4,""attackType"":[{""name"":""Non-browser Client""},{""name"":""Abuse of Functionality""},{""name"":""Cross Site Scripting (XSS)""},{""name"":""Other Application Activity""},{""name"":""HTTP Parser Attack""}],""ratingIncludingViolationsInStaging"":4,""stagingCertificationDatetime"":""2024-01-01T00:00:00Z""},""requestDatetime"":""2023-12-27T14:22:29Z""
```
