---
nd-docs: "DOCS-1563"
---

The Detect Base64 feature allows NGINX App Protect WAF to detect whether values in string fields in gRPC payload are Base64 encoded. When a value is detected as Base64 encoded NGINX App Protect WAF will enforce the configured signatures on the decoded value __and__ on the original value.

This feature is disabled by default and can be enabled by setting `decodeStringValuesAsBase64` to `enabled`.

This has to be used with care because Protocol Buffer protocol is supposed to carry binary fields of "bytes" type and, thus, trying to decode strings as Base64 may lead to false positives. Using Base64-encoded strings for binary data is usually not a good practice but, if the protected app still does that, then enable Base64 detection.

```json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "valid_string_encoding_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "idl-files": [
            {
                "fileName": "valid_string.proto",
                "link": "file:///tmp/grpc/valid_string.proto"
            }
        ],
        "grpc-profiles": [
            {
                "name": "base64_decode_strings",
                "description": "My first profile",
                "idlFiles": [
                    {
                        "idlFile": {
                            "fileName": "valid_string.proto"
                        }
                    }],
                "decodeStringValuesAsBase64": "enabled"
            }
        ]
    }
}
```