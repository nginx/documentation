

NGINX App Protect WAF provides an IP Intelligence feature, which allows customizing the enforcement based on the source IP of the request to limit access from IP addresses with questionable reputation. Please note that:
- The IP intelligence feature is **disabled** by default and needs to be installed, enabled, and configured within the policy.
- To review the installation steps, please refer to the administration guide: [App Protect v4]({{< ref "/nap-waf/v4/admin-guide/install.md#Prerequisites" >}}) / [App Protect v5]({{< ref "/nap-waf/v5/admin-guide/install.md#Prerequisites" >}})
- The system must have an active Internet connection and a working DNS.
- If NGINX App Protect is behind a firewall, ensure external access to vector.brightcloud.com over port 443 - this is the IP Intelligence server used for data retrieval.
- If NGINX App Protect accesses the Internet through a forward proxy server, ensure that it is configured correctly [here](#ip-intelligence-forward-proxy-configuration).
  
Once installed, make sure to enable the feature in the two relevant sections of the policy:
1. By enabling the corresponding violation in the violation list: `"name": "VIOL_MALICIOUS_IP"` and assigning the appropriate `block` and `alarm` values to the violation.

2. By enabling the feature in the corresponding IP Intelligence JSON section: `"ip-intelligence": {"enabled": true}` and defining actions for the IP Intelligence categories listed below.

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
