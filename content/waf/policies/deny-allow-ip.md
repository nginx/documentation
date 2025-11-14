---
# We use sentence case and present imperative tone
title: "Deny and Allow IP lists"
# Weights are assigned in increments of 100: determines sorting order
weight: 900
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This page describes the Deny and Allow IP lists feature of F5 WAF for NGINX.

This feature allows you to define IP addresses or ranges for which the traffic will always be allowed, denied or never logged , overriding other configuration settings.

1. **Always Allowed** (`"blockRequests": "never"`) - Requests from this IP range will be passed even if they have blocking violations.
2. **Always Denied** (`"blockRequests": "always"`) - Requests from this IP range will be always blocked even if they have no other blocking violations. The `VIOL_BLACKLISTED_IP` violation will be triggered in this case and its block flag must be set to `true` in order for the request to be actually blocked.
3. **Never Log** (`"neverLogRequests": true`) - Requests from this IP range will not be logged even if defined by logging configuration. This is independent of the other settings, so the same IP range can be both denied (or allowed) and yet never logged.

In this IPv4 example, the default configuration is used while enabling the deny list violation. The configuration section defines:

- An always allowed IP, 1.1.1.1
- An always denied IP, 2.2.2.2
- An always allowed range of IPs, 3.3.3.0/24
- An allowed range of IPs, 4.4.4.0/24, which should never log

```json
{
    "policy": {
        "name": "allow_deny",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_BLACKLISTED_IP",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "whitelist-ips": [
            {
                "blockRequests": "never",
                "neverLogRequests": false,
                "ipAddress": "1.1.1.1",
                "ipMask": "255.255.255.255"
            },
            {
                "blockRequests": "always",
                "ipAddress": "2.2.2.2",
                "ipMask": "255.255.255.255"
            },
            {
                "blockRequests": "never",
                "neverLogRequests": false,
                "ipAddress": "3.3.3.0",
                "ipMask": "255.255.255.0"
            },
            {
                "blockRequests": "never",
                "neverLogRequests": true,
                "ipAddress": "4.4.4.0",
                "ipMask": "255.255.255.0"
            }
        ]
    }
}
```

{{< call-out "note" >}}
The above configuration assumes the IP address represents the original requestor. 

It is common that the client address may instead represent a downstream proxy device as opposed to the original requestor's IP address. 

In this case, you may need to configure F5 WAF for NGINX to prefer the use of an `X-Forwarded-For` (or similar) header injected to the request by a downstream proxy in order to more accurately identify the *actual* originator of the request.

Read the [XFF trusted headers]({{< ref "/waf/policies/xff-headers.md" >}}) topic for information regarding settings required for this configuration.
{{< /call-out >}}

This next example uses IPv6 notation with a single address and an IP subnet with a 120-bit prefix.

The first address is a single IP address, identifiable by the mask which is all f's.  Since this is a default value, there is no need to specify the mask. 

The second address is a subnet of 120 bits (out of the 128 of an IPv6 address). The trailing 8 bits (128-120) must be **zero** in both the mask and the address itself.

```json
{
    "policy": {
        "name": "allow_deny",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_BLACKLISTED_IP",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "whitelist-ips": [
            {
                "ipAddress": "2023::4ef3",
                "ipMask": "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff",
                "blockRequests": "never"
            },
            {
                "ipAddress": "2034::2300",
                "ipMask": "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ff00",
                "blockRequests": "never"
            },
        ]
    }
}
```