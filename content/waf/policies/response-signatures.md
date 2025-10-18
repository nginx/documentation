---
title: Response signatures
weight: 1850
toc: true
nd-content-type: reference
nd-product: NAP-WAF
nd-docs: DOCS-000
---

This page describes the response signatures feature of F5 WAF for NGINX.

Response signatures are signatures detected in HTTP responses: [Attack signatures]({{< ref "/waf/policies/attack-signatures.md" >}}) are detected in HTTP requests.

You may also want to view the [Allowed methods]({{< ref "/waf/policies/allowed-methods.md" >}}) topic.

## Response codes

F5 WAF for NGINX can be configured to selectively allow response codes while blocking all others.

The `allowedResponseCodes` attribute is used to define which response codes are allowed as part of a comma-sepated list in the `general` block.

The following example enables the response status codes violation in blocking mode. 

```json
{
    "policy": {
        "name": "allowed_response",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_HTTP_RESPONSE_STATUS",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "general": {
            "allowedResponseCodes": [
                400,
                401,
                403,
                404,
                502,
                499
            ]
        }
    }
}
```

## Restricted response length

F5 WAF for NGINX can define a limit to the amount of bytes that will be inspected in a response. This feature is disabled by default, with a default length of 20,000 bytes when enabled.

Restrictions on known signatures will be enforced by policies independently of response length.

To enable this, set the `responseCheck` parameter to `true`. Add the `responseCheckLength` attribute to set an alternative length to the default value.

The response length checked refers to the number of uncompressed bytes in the response body. 

Usually F5 WAF for NGINX will buffer only that part of the response saving memory and CPU, but in some conditions the whole response may have to be buffered, such as when the response body is compressed.

The following example enables the `responseCheck` parameter with `responseCheckLength` set to `1000`, signifying that only the initial 1000 bytes of the response body should be inspected.

It is nested within a [filetypes]({{< ref "/waf/policies/response-signatures.md" >}}) block.

```json {hl_lines=[9, 13, 14]}
{
    "policy": {
        "name": "response_signatures_block",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "filetypes": [
           {
            "name": "*",
            "type": "wildcard",
            "responseCheck": true,
		    "responseCheckLength": 1000
           }
        ],
            "signature-sets": [
          {
                "name": "All Response Signatures",
                "block": true,
                "alarm": true
           }
        ]
    }
}
```
