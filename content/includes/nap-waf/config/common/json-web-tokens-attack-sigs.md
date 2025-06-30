---
nd-docs: "DOCS-1602"
---

Attack signatures are detected within the JSON values of the token, i.e. the header and claims parts, but not on the digital signature part of the token. The detection of signatures, and specifically which signatures are recognized, depends on the configuration entity within the Policy. Typically, this configuration entity is the Authorization HTTP header or else, the header or parameter entity configured as the location of the token in the access profile.

If the request doesn't align with a URL associated with an Access Profile, an attempt is made to parse the "bearer" type Authorization header, but no violations are raised, except for Base64. More information can be found below:

1. Token parsed successfully - No violations are detected when enforced on URL with or without access profile.

2. There are more or less than two dots in the token - `VIOL_ACCESS_MALFORMED` is detected when enforced on URL with access profile.

3. Base64 decoding failure - `VIOL_ACCESS_MALFORMED` is detected when enforced on URL with access profile. `VIOL_PARAMETER_BASE64` is detected when enforced with access profile.

4. JSON parsing failure - `VIOL_ACCESS_MALFORMED` is detected when enforced on URL with access profile.