---
nd-docs: DOCS-1476
nd-product: NAZURE
nd-files:
- content/nginxaas-azure/billing/overview.md
- content/nginxaas-azure/quickstart/scaling.md
---

An NGINX Capacity Unit (NCU) quantifies the capacity of an NGINX instance based on the underlying compute resources. This abstraction allows you to specify the desired capacity in NCUs without having to consider the regional hardware differences.

An NGINX Capacity Unit consists of the following parameters:

* CPU: an NCU provides 20 [Azure Compute Units](https://learn.microsoft.com/en-us/azure/virtual-machines/acu) (ACUs)
* Bandwidth: an NCU provides 2.2 Mbps of network throughput
* Concurrent connections: an NCU provides 3000 concurrent connections. This performance is not guaranteed when F5 WAF for NGINX is used with NGINXaaS
