---
f5-product: NGINX Ingress Controller
f5-files:
- content/nic/changelog/_index.md
- content/nic/install/waf-helm.md
- content/nic/integrations/app-protect-waf-v5/installation.md
- content/nic/technical-specifications.md
---

NGINX Ingress Controller supports the following versions of [F5 WAF for NGINX](https://docs.nginx.com/waf/):

{{< table >}}

| NIC Version         | NAP-WAF Version | Config Manager | Enforcer |
| ------------------- | --------------- | -------------- | -------- |
| {{< nic-version >}} | 37.0+{{< appprotect-compiler-version>}}       | {{< nic-waf-release-version >}}          | {{< nic-waf-release-version >}}   |
| 5.4.3               | 37.0+5.635.1    | 5.13.1         | 5.13.1   |
| 5.3.4               | 35+5.527.0      | 5.11.2         | 5.11.2   |
| 5.2.1               | 35+5.527.0      | 5.9.0          | 5.9.0    |
| 5.1.1               | 35+5.498        | 5.8.0          | 5.8.0    |
| 5.0.0               | 34+5.342        | 5.6.0          | 5.6.0    |
| 4.0.1               | 33+5.264        | 5.5.0          | 5.5.0    |
| 3.7.2               | 32+5.1          | 5.3.0          | 5.3.0    |
| 3.6.2               | 32+5.48         | 5.2.0          | 5.2.0    |

{{< /table >}}
