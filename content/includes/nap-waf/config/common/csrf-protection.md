---
nd-docs: "DOCS-1590"
---

CSRF (Cross-Site Request Forgery) is an attack vector in which the victim user that visits a sensitive site such as a bank account, is lured to click on a malicious link attempting a fraudulent operation on that sensitive site. The link may be sent over email or in a hidden frame in another site. F5 WAF for NGINX provides protection against CSRF attacks by validating the Origin header for AJAX POST requests (default configuration).

##### CSRF Configuration

There are several settings that can be configured to enable CSRF protection, some are global while others are specific. Following is a list of all the settings that can be configured to enable or customize the CSRF settings:
1. In the `csrf-protection` section, enable CSRF protection. This is a global configuration option and applies to all policy elements.
2. Enable the CSRF violation `VIOL_CSRF` in the violations section (the violation is already enabled in `Alarm` mode in the base template). This is a global configuration option and applies to all policy elements.
3. In the `csrf-urls` section, the user can define method and URL configurations. By default, the wildcard URL `*` with the `POST` method is configured to enforce Origin validation. The default configuration can be deleted to allow for customized configuration for specific methods and URLs.
4. In the `urls` section, you can enable CSRF protection for specific URLs, and define a list of acceptable origins. If the wildcard URL `*` is selected, the configuration becomes global for all URLs. Otherwise, the configuration is applicable only to the specified URL.
5. In the `host-names` section, you can add a list of the domains that are to be accepted when comparing the origin to the hostnames. The user can enable or disable the inclusion of subdomains. This is a global configuration option and applies to all policy elements.

Please note that:
- Both `VIOL_CSRF` and `csrf-protection` settings need to be enabled for CSRF protection to be active. Disabling either setting will disable CSRF protection altogether.
- Configuring `urls` is required only if there are external origins that have to be allowed.
- `host-names` are internal, owned by the application and used by clients to reach it. The `crossDomainAllowedOrigin` in the `urls` are external domains, from other applications, that we wish to allow as origins.

##### CSRF Enforcement

If CSRF is enabled in the violation section and in the `csrf-protection` settings, when receiving a request to a URL that matches one of the `csrf-urls` and all its conditions: method and parameters (if applicable there), then the following conditions must be met:

1. Origin header must exist in the request.
2. The domain name from the Origin header must match any of the following criteria:
   * The Host header in the same request.
   * One of the hostnames in the policy.
   * One of the allowed origins in the matching URL entity in the policy.

If the first condition is not met, the validation will fail with the message "Origin header validation failed: Origin is absent". If the second condition fails to match any of the items, the validation will fail with the message "Origin header validation failed: Origin is not allowed".

##### CSRF Configuration Examples

In the following example, CSRF Protection is enabled globally (in `Block` mode) with no customization:

```json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "csrf_default",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_CSRF",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "csrf-protection": {
            "enabled": true
        }
    }
}
```

In the following example, the policy is configured with the following items:
- Enable CSRF Protection globally (in `Block` mode).
- Delete the default wildcard CSRF URL and define a new custom one.
- Define a policy-wide hostname domain without its subdomains.

```json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "example_2",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_CSRF",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "csrf-protection": {
            "enabled": true
        },
        "csrf-urls": [
            {
                "$action": "delete",
                "method": "POST",
                "url": "*"
            },
            {
                "enforcementAction": "verify-origin",
                "method": "POST",
                "url": "/operation.aspx"
            }
        ],
        "host-names": [
            {
                "name": "example.com",
                "includeSubdomains": false
            }
        ]
    }
}
```

In the following example, the policy is configured with the following items:
- Enable CSRF Protection globally (violation already in `Alarm` mode in the default policy).
- Delete the default wildcard CSRF URL and define a new custom one.
- Define a policy-wide hostname domain with subdomains.
- Add a custom URL "myurl" where CSRF enforcement is enabled, and define a custom origin for this URL.

```json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "example_3",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "csrf-protection": {
            "enabled": true
        },
        "csrf-urls": [
            {
                "$action": "delete",
                "method": "POST",
                "url": "*"
            },
            {
                "enforcementAction": "verify-origin",
                "method": "POST",
                "url": "/csrfurl"
            }
        ],
        "host-names": [
            {
                "name": "example.com",
                "includeSubdomains": true
            }
        ],
        "urls": [
            {
                "name": "/myurl",
                "html5CrossOriginRequestsEnforcement": {
                    "enforcementMode": "enforce",
                    "crossDomainAllowedOrigin": [
                        {
                            "includeSubDomains": false,
                            "originName": "foo.com",
                            "originPort": "all",
                            "originProtocol": "http/https"
                        }
                    ]
                }
            }
        ]
    }
}
```