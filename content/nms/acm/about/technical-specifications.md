---
nd-docs: DOCS-1470
title: Technical Specifications
weight: 200
---

### Dependencies with Instance Manager

{{< include "tech-specs/acm-nim-dependencies.md" >}}

{{< important >}} If you're [installing API Connectivity Manager in an offline environment]({{< ref "/nim/disconnected/offline-install-guide.md#install-acm-offline" >}}) and the minimum required version of Instance Manager is not installed, the API Connectivity Manager installer will exit. You'll need to [install Instance Manager manually]({{< ref "/nim/disconnected/offline-install-guide.md#install-nim-offline" >}}) before installing API Connectivity Manager.{{< /important >}}

### API Connectivity Manager Supported NGINX Versions {#acm-supported-nginx}

{{< include "tech-specs/acm-supported-nginx.md" >}}

### Developer Portal Supported Distributions {#dev-portal-supported-distributions}

{{< include "tech-specs/acm-dev-portal-supported-distros.md" >}}

---

## Supported Linux Distributions

{{< call-out "note" "API Connectivity Manager" >}}Make sure you review the [supported distributions for the Developer Portal](#dev-portal-supported-distributions) host before installing the API Connectivity Manager module. There is a slight difference between the supported distributions in that list and this one.
{{< /call-out >}}

API Connectivity Manager supports the following Linux distributions:


{{<bootstrap-table "table table-striped table-bordered">}}

| Distribution                                | Version                                                                                                      | Architecture               | Instance Manager                                    | API Connectivity Manager                            |
|---------------------------------------------|----------------------------------------------------------------------------------------------------------------|----------------------------|------------------------------------------------------|------------------------------------------------------|
| Amazon Linux                                | 2 LTS                                                                                                          | x86_64                     | Supported                                            | Supported |
| CentOS                                      | 7.4 and later in the 7.x family                                                                                | x86_64                     | Supported                                            | Supported |
| Debian                                      | 11<hr>12 | x86_64<hr>x86_64  | Supported<hr>Supported on 2.13+     |   Supported<hr><i class="fa-solid fa-ban" style="color: red"></i> Not supported   |
| Oracle Linux                                | 7.4 and later in the 7.x family<hr>8.0 and later in the 8.0.x family                                           | x86_64<hr>x86_64            | Supported<hr>Supported on 2.6.0+                    | Supported<hr>Supported on 1.3.0+ |
| RHEL                                        | 7.4 and later in the 7.x family<hr>8.x and later in the 8.x family<hr>9.x and later in the 9.x family          | x86_64<hr>x86_64<hr>x86_64  | Supported<hr>Supported<hr>Supported on 2.6.0+       | Supported<hr>Supported<hr>Supported on 1.3.0+      |
| Ubuntu                                      | 20.04<hr>22.04 | x86_64<hr>x86_64  | Supported<hr>Supported on 2.3.0+ | Supported<hr>Supported  |

{{</bootstrap-table>}}




## Supported NGINX Versions

{{< include "tech-specs/acm-supported-nginx.md" >}}
