---
docs: DOCS-1071
files:
- content/nim/fundamentals/tech-specs.md
---

The following table lists the Linux distributions supported by NGINX Instance Manager and NGINX App Protect:

{{<bootstrap-table "table table-striped table-bordered">}}

| Distribution    | Version                                | Architecture     | NGINX Instance Manager Support                          | NGINX App Protect Support                          |
|-----------------|----------------------------------------|------------------|---------------------------------------------------|----------------------------------------------------|
| Amazon Linux    | 2 LTS                                  | x86_64           | Supported                                         | **Support discontinued as of 2.18.0**                                          |
| CentOS          | 7.4 and later in the 7.x family        | x86_64           | **Support discontinued as of 2.17.0**             | Supported                                          |
| Debian          | 11<hr>12                               | x86_64<hr>x86_64 | Supported<hr>Supported on 2.13.0+                 | Supported<hr>Supported                             |
| Oracle Linux    | 7.4 and later in the 7.x family<hr>8.0 and later in the 8.x family | x86_64<hr>x86_64 | Supported<hr>Supported on 2.6.0+                 | Supported<hr>Supported                             |
| RHEL            | 7.4 and later in the 7.x family<hr>8.x and later in the 8.x family<hr>9.x and later in the 9.x family | x86_64<hr>x86_64<hr>x86_64 | **Support discontinued as of 2.17.0**<hr>Supported<hr>Supported on 2.6.0+ | Supported<hr>Supported<hr>Supported |
| Ubuntu          | 20.04<hr>22.04<hr>24.04                | x86_64<hr>x86_64<hr>x86_64 | Supported<hr>Supported on 2.3.0+<hr>Supported on 2.18.0+                 | Supported<hr>Supported<hr>Supported                             |

{{</bootstrap-table>}}



