---
nd-docs: DOCS-1050
nd-files:
- content/nim/license/add-license-offline.md
- content/nim/license/report-usage-offline.md
- content/nim/nginx-instances/manage-certificates.md
- content/nim/waf-integration/configuration/manage-waf-configurations/edit-waf-configuration.md
- content/nim/waf-integration/configuration/manage-waf-configurations/onboard-custom-security-policies.md
- content/nim/waf-integration/configuration/onboard-instances/verify-installation.md
- content/nim/waf-integration/policies-and-logs/_index.md
- content/nim/waf-integration/policies-and-logs/log-profiles/create-log-profile.md
- content/nim/waf-integration/policies-and-logs/log-profiles/delete-log-profile.md
- content/nim/waf-integration/policies-and-logs/log-profiles/update-log-profile.md
- content/nim/waf-integration/policies-and-logs/publish/check-publication-status.md
- content/nim/waf-integration/policies-and-logs/publish/publish-to-instances.md
---

Use tools such as `curl` or [Postman](https://www.postman.com) to send requests to the NGINX Instance Manager REST API.
The API base URL is `https://<NIM-FQDN>/api/[nim|platform]/<API_VERSION>`.  
All requests require authentication. For details on authentication methods, see the [API overview]({{< ref "/nim/fundamentals/api-overview.md" >}}).
