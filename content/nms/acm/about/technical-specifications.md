---
title: "Technical Specifications"
weight: 200
docs: "DOCS-000"
---

## Supported Linux Distributions

API Connectivity Manager supports the following Linux distributions:

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
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
{{< raw-html>}}</div>{{</raw-html>}}

{{< call-out "note" "API Connectivity Manager" >}}Make sure you review the [supported distributions for the Developer Portal]({{< relref "/tech-specs.md#dev-portal-supported-distributions" >}}) host before installing the API Connectivity Manager module. There is a slight difference between the supported distributions in that list and this one.
{{< /call-out >}}

## Supported NGINX Versions

{{< include "tech-specs/acm-supported-nginx.md" >}}