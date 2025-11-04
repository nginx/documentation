---
files:
   - content/agent/tech-specs.md
   - content/nginx-one/agent/overview/tech-specs.md
---

NGINX Agent is designed to operate efficiently on any system that meets the standard
hardware requirements for running NGINX itself. This ensures compatibility, stability,
and performance aligned with the NGINX core platform:

### Supported distributions

{{<bootstrap-table "table table-striped table-bordered">}}
| Distribution                        | Supported on Agent                                                                                         |
|-------------------------------------|------------------------------------------------------------------------------------------------------------|
| AlmaLinux                           | 8 (x86_64, aarch64) <br> 9 (x86_64, aarch64) <br> 10 (x86_64, aarch64) **(new)**                           |
| Alpine Linux                        | 3.19 (x86_64, aarch64) <br> 3.20 (x86_64, aarch64) <br> 3.21 (x86_64, aarch64) <br> 3.22 (x86_64, aarch64) |
| Amazon Linux                        | 2023 (x86_64, aarch64)                                                                                     |                       
| Amazon Linux 2                      | LTS (x86_64, aarch64)                                                                                      |                       
| CentOS                              | **Not supported**                                                                                          |                     
| Debian                              | 11 (x86_64, aarch64) <br> 12 (x86_64, aarch64)                                                             |
| FreeBSD                             | **Not supported**                                                                                          |
| Oracle Linux                        | 8.1+ (x86_64, aarch64) <br> 9 (x86_64) <br> 10 (x86_64) **(new)**                                          |
| Red Hat Enterprise Linux (RHEL)     | 8.1+ (x86_64, aarch64) <br> 9.0+ (x86_64, aarch64) <br> 10.0+ (x86_64, aarch64) **(new)**                  |
| Rocky Linux                         | 8 (x86_64, aarch64) <br> 9 (x86_64, aarch64)    <br> 10 (x86_64, aarch64) **(new)**                        |
| SUSE Linux Enterprise Server (SLES) | 15 SP2+ (x86_64)                                                                                           |
| Ubuntu                              | 22.04 LTS (x86_64, aarch64) <br> 24.04 LTS (x86_64, aarch64) <br> 25.04 LTS (x86_64, aarch64) **(new)**    |
{{</bootstrap-table>}}

To see the detailed technical specifications for NGINX Plus, refer to the official
[NGINX Plus documentation]({{< ref "/nginx/technical-specs.md" >}}).

### Supported telemetry

NGINX Agent runs with an embedded OpenTelemetry Collector that provides the following telemetry:

{{<bootstrap-table "table table-striped table-bordered">}}
| Product               | Metrics | Logs | Traces |
|-----------------------|---------|------|--------|
| **NGINX Open Source** | Yes     | No   | No     |
| **NGINX Plus**        | Yes     | No   | No     |
| **NGINX App Protect** | No      | Yes  | No     |
| **NGINX Agent**       | No      | No   | No     |
{{</bootstrap-table>}}

### Recommended hardware

For recommended hardware, see the
[Sizing guide for deploying NGINX Plus on bare metal servers](https://www.f5.com/pdf/deployment-guide/Sizing-Guide-for-Deploying-NGINX-Plus-on-Bare-Metal-Servers-2019-11-09.pdf).