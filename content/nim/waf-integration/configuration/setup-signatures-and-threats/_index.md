---
nd-docs: DOCS-335
title: Set up attack signatures, bot signatures, and threat campaigns
weight: 200
nd-landing-page: true
url: /nginx-instance-manager/waf-integration/configuration/setup-signatures-and-threats/
---

## Overview 

F5 WAF for NGINX protects your applications using predefined and regularly updated detection patterns:

- **Attack signatures**: Known threat patterns used to detect common vulnerabilities and exploits. These are included with F5 WAF for NGINX and updated frequently to reflect the latest security threats. See the [attack signatures documentation]({{< ref "/waf/policies/attack-signatures.md" >}}) for more information.

- **Threat campaigns**: Context-aware threat intelligence based on attack campaigns observed by F5 Threat Labs. These are updated even more frequently than attack signatures and require installation to take effect. Learn more in the [threat campaigns documentation]({{< ref "/waf/policies/threat-campaigns.md" >}}).

- **Bot signatures**: Detection patterns designed to identify and classify automated bot traffic. These signatures help distinguish between legitimate bots, such as search engine crawlers, and malicious ones that perform credential stuffing, scraping, or denial-of-service attacks. See the [bot signatures documentation]({{< ref "/waf/policies/bot-signatures.md" >}}) for more information.

To take advantage of the latest updates, you must upload the attack signature, bot signature, and threat campaign packages to NGINX Instance Manager.

You can either:

- Configure NGINX Instance Manager to automatically download new versions, or
- Manually download packages from MyF5 and upload them to NGINX Instance Manager using the REST API.

## In this section

{{<card-section showAsCards="true" >}}
  {{<card title="Automatically update security packages" titleUrl="automatic-download/" >}}
    Enable automatic updates in NGINX Instance Manager to keep F5 WAF for NGINX packages current.
  {{</card>}}
  {{<card title="Manually update security packages" titleUrl="manual-update/" >}}
    Manually download and upload F5 WAF for NGINX security packages to NGINX Instance Manager.
  {{</ card >}}
    {{<card title="Update Security Monitoring attack signature database" titleUrl="update-security-monitoring-signature-db/" >}}
    Keep your Security Monitoring dashboards accurate by updating the attack signature database in NGINX Instance Manager.
  {{</ card >}}
{{</card-section>}}  