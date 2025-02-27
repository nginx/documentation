---
docs: "DOCS-1476"
---

An NGINX Capacity Unit (NCU) quantifies the capacity of an NGINX instance based on the underlying compute resources. This abstraction allows you to specify the desired capacity in NCUs without having to consider the regional hardware differences.

An NGINX Capacity Unit consists of the following parameters:

* CPU: an NCU provides 20 [Azure Compute Units](https://learn.microsoft.com/en-us/azure/virtual-machines/acu) (ACUs)
* Bandwidth: an NCU provides 60 Mbps of network throughput
* Concurrent connections: an NCU provides 400 concurrent connections. This performance is not guaranteed when NGINX App Protect WAF is used with NGINXaaS
