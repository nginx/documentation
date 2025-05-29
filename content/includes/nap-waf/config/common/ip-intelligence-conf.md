


As of NAP version 4.15.0 (for NAP V4 deployments), and NAP version 5.7.0 (for NAP V5 deployments), NGINX App Protect WAF includes a new feature named IP Intelligence. This features allows customizing the enforcement based on the source IP of the request to limit access from IP addresses with questionable reputation. Please note that:
- The IP intelligence feature is disabled by default and needs to be explicitly enabled and configured in the policy.
- The package `app-protect-ip-intelligence` needs to be installed (for NAP V4 deployments), or the IP Intelligence image deployed (for NAP V5 deployments), before configuring and using the feature. This package installs the client that downloads and updates the database required for enforcing IP Intelligence.

After installing the package or image, enable the feature in the following two places in the policy:
1. By enabling the corresponding violation in the violation list: `"name": "VIOL_MALICIOUS_IP"` and assigning the required `block` and `alarm` values to the violation.

2. By enabling the featue in the corresponding IP Intelligence JSON section: `"ip-intelligence": {"enabled": true}` and define actions for the IP Intelligence categories listed below.

An example policy where both elements are enabled, and all the IP intelligence categories are configured to `block` and `alarm` can be found here:

```json
{
    "policy": {
        "name": "ip_intelligency_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "caseInsensitive": false,
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_MALICIOUS_IP",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "ip-intelligence": {
            "enabled": true,
            "ipIntelligenceCategories": [
                {
                    "category": "Anonymous Proxy",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "BotNets",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Cloud-based Services",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Denial of Service",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Infected Sources",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Mobile Threats",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Phishing Proxies",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Scanners",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Spam Sources",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Tor Proxies",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Web Attacks",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Windows Exploits",
                    "alarm": true,
                    "block": true
                }
            ]
        }
    }
}
```
This policy will basically block `"block": true` all IP addresses that are part of any threat category and add a log entry `"alarm": true` for the transaction.

The IP address database is managed by an external provider and is constantly updated (every 1 minute by default). The database also categorizes IP addresses into one or more threat categories. These are the same categories that can be configured individually in the IP intelligence section:
- Anonymous Proxy
- BotNets
- Cloud-based Services
- Denial of Service
- Infected Sources
- Mobile Threats
- Phishing Proxies
- Scanners
- Spam Sources
- Tor Proxies
- Web Attacks
- Windows Exploits

Note that since the IP address database is constantly updated, IP address enforcement is also expected to change. IP Addresses may be added, removed, or moved from one category to another based on the reported activity of the IP address.
