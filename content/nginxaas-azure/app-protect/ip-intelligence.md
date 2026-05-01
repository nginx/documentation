---
title: IP Intelligence
weight: 350
toc: true
url: /nginxaas/azure/app-protect/ip-intelligence/
nd-content-type: concept
nd-product: NAZURE
---

## Overview

F5 WAF for NGINX includes an IP Intelligence feature that allows you to customize enforcement based on the source IP address of a request. Using IP Intelligence, you can block or log requests from IP addresses associated with known threat categories such as botnets, scanners, and phishing proxies.

IP Intelligence is available on NGINXaaS for Azure deployments with the **Standard v3** [plan]({{< ref "/nginxaas-azure/billing/overview.md/#standard-v3-plan" >}}).

{{< call-out "note" >}} IP Intelligence does not require an additional license. F5's existing license with the BrightCloud threat intelligence provider covers all NGINXaaS deployments. The IP address database is automatically updated every 60 minutes. {{< /call-out >}}

## Threat categories

IP Intelligence classifies IP addresses into the following threat categories. You can individually configure each category to block, alarm, or allow traffic.

{{< table >}}
| Category             | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| Anonymous Proxy      | IP addresses associated with anonymous proxy services                       |
| BotNets              | IP addresses that are part of known botnet networks                         |
| Cloud-based Services | IP addresses from cloud providers often used for automated attacks          |
| Denial of Service    | IP addresses associated with denial-of-service attacks                      |
| Infected Sources     | IP addresses from hosts known to be compromised                             |
| Mobile Threats       | IP addresses associated with malicious mobile applications                  |
| Phishing Proxies     | IP addresses used as proxies for phishing campaigns                         |
| Scanners             | IP addresses associated with network and vulnerability scanners             |
| Spam Sources         | IP addresses identified as sources of spam                                  |
| Tor Proxies          | IP addresses of known Tor exit nodes                                        |
| Web Attacks          | IP addresses associated with web-based attacks                              |
| Windows Exploits     | IP addresses associated with Windows-specific exploits                      |
{{< /table >}}

Since the threat database is continuously updated, enforcement may change over time. IP addresses may be added, removed, or moved between categories based on their reported activity.

## Add IP Intelligence to a WAF policy

To use IP Intelligence, you must add the `ip-intelligence` section to a [custom WAF policy]({{< ref "/nginxaas-azure/app-protect/configure-waf.md#custom-policies" >}}). No additional setup or enablement steps are required.

Your WAF policy needs two additions:

1. The `VIOL_MALICIOUS_IP` violation in `blocking-settings`.
2. The `ip-intelligence` section with the desired threat categories.

### Example policy

The following policy turns on IP Intelligence with all categories set to block and alarm.

```json
{
  "policy": {
    "name": "ip_intelligence_policy",
    "template": {
      "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
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
        { "category": "Anonymous Proxy", "alarm": true, "block": true },
        { "category": "BotNets", "alarm": true, "block": true },
        { "category": "Cloud-based Services", "alarm": true, "block": true },
        { "category": "Denial of Service", "alarm": true, "block": true },
        { "category": "Infected Sources", "alarm": true, "block": true },
        { "category": "Mobile Threats", "alarm": true, "block": true },
        { "category": "Phishing Proxies", "alarm": true, "block": true },
        { "category": "Scanners", "alarm": true, "block": true },
        { "category": "Spam Sources", "alarm": true, "block": true },
        { "category": "Tor Proxies", "alarm": true, "block": true },
        { "category": "Web Attacks", "alarm": true, "block": true },
        { "category": "Windows Exploits", "alarm": true, "block": true }
      ]
    }
  }
}
```

- `"block": true` rejects requests from matching IP addresses.
- `"alarm": true` logs matching requests in the security logs.

You can customize each category independently — for example, blocking botnets while only alarming on scanners.

You can reference this policy in your NGINX configuration using the `app_protect_policy_file` directive, as described in [Configure F5 WAF for NGINX]({{< ref "/nginxaas-azure/app-protect/configure-waf.md" >}}).

For the full policy configuration reference, see the official [IP Intelligence documentation](https://docs.nginx.com/waf/policies/ip-intelligence/#configure-policies-for-ip-intelligence).

