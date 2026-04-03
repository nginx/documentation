---
title: F5 WAF for NGINX security monitoring
description: Monitor security events and review WAF dashboards to assess threats
weight: 425
url: /nginx-one-console/waf-security-dashboard
---

Use the Security Monitoring module in NGINX One Console to monitor data from F5 WAF for NGINX instances. Review the security dashboards to assess potential threats and identify opportunities to fine-tune your policies.

## Dashboard metrics overview

The security dashboard displays key metrics to help you understand attack patterns and threats. Here's an overview of the main metrics:

- **Attack Counts** - Track the number of attacks with percentage change comparisons against previous periods
- **Violation Types** - View violations grouped by category (e.g., Protocol Compliance) to understand threat patterns
- **Signatures** - See specific signatures triggered within each violation type across multiple events
- **Event Details** - Access Support IDs, raw request data, triggered signatures, and contextual metadata (Original IP, X-Forwarded-For, Violation Context)
- **Global Filters** - Apply filters by time period, policy, and attack type to instantly update all dashboard widgets
