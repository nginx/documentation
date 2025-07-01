---
nd-docs: "DOCS-1604"
---

It is possible to define IP addresses or ranges for which the traffic will always be allowed or denied or never logged despite the rest of the configuration settings in the policy.

1. **Always Allowed** (`"blockRequests": "never"`) - requests from this IP range will be passed even if they have blocking violations.
2. **Always Denied** (`"blockRequests": "always"`) - requests from this IP range will be always blocked even if they have no other blocking violations. The `VIOL_BLACKLISTED_IP` violation will be triggered in this case and its block flag must be set to `true` in order for the request to be actually blocked.
3. **Never Log** (`"neverLogRequests": true`) - requests from this IP range will not be logged even if they were supposed to be in the logging configuration. Note this is independent of the other setting, so the same IP range can be both denied (or allowed) and yet never logged.

In this IPv4 example, we use the default configuration while enabling the deny list violation. In the configuration section, we define:

- An always allowed IP 1.1.1.1
- An always denied IP 2.2.2.2
- An always allowed range of IPs 3.3.3.0/24
- An allowed range of IPs 4.4.4.0/24 which should never log

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

{{< note >}}
The above configuration assumes the IP address represents the original requestor. However, it is also common that the client address may instead represent a downstream proxy device as opposed to the original requestor's IP address. In this case, you may need to configure NGINX App Protect WAF to prefer the use of an `X-Forwarded-For` (or similar) header injected to the request by a downstream proxy in order to more accurately identify the *actual* originator of the request. [See the XFF Headers and Trust](#xff-headers-and-trust) for information regarding the additional settings required for this configuration.
{{< /note >}}


Here's an example of IPv6 notation with a single address and an IP subnet with a 120-bit prefix:

The first address is a single IP address, because the mask is all f's. Since this is a default value, there is no need to specify the mask in this case. The second address is a subnet of 120 bits (out of the 128 of an IPv6 address). The trailing 8 bits (128-120) must be **zero** in both the mask and the address itself.

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