---
docs: "DOCS-1071"
---

The NGINX Management Suite gateway supports the following Linux distributions:

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table table-striped table-bordered">}}
| Distribution                                | Version                                                                                                      | Architecture               | Instance Manager                                    | API Connectivity Manager                            | NGINX App Protect  |
|---------------------------------------------|----------------------------------------------------------------------------------------------------------------|----------------------------|------------------------------------------------------|------------------------------------------------------|---------------------|
| Amazon Linux                                | 2 LTS                                                                                                          | x86_64                     | Supported                                            | Supported                                           | <i class="fa-solid fa-ban" style="color: red"></i> Not supported       |
| CentOS                                      | 7.4 and later in the 7.x family                                                                                | x86_64                     | Supported                                            | Supported                                           | Supported           |
| Debian                                      | 10 (<i class="fa-solid fa-exclamation-triangle" style="color: orange"></i> Deprecated, see modules)<hr>11<hr>12 | x86_64<hr>x86_64<hr>x86_64  | Supported (up to 2.13)<hr>Supported<hr>Supported on 2.13+     | Supported (up to 1.9.0)<hr>Supported<hr>Supported on 1.9.0+   | <i class="fa-solid fa-ban" style="color: red"></i> Not supported<hr>Supported<hr><i class="fa-solid fa-ban" style="color: red"></i> Not supported |
| Oracle Linux                                | 7.4 and later in the 7.x family<hr>8.0 and later in the 8.0.x family                                           | x86_64<hr>x86_64            | Supported<hr>Supported on 2.6.0+                    | Supported<hr>Supported on 1.3.0+                   | Supported<hr>Supported |
| RHEL                                        | 7.4 and later in the 7.x family<hr>8.x and later in the 8.x family<hr>9.x and later in the 9.x family          | x86_64<hr>x86_64<hr>x86_64  | Supported<hr>Supported<hr>Supported on 2.6.0+       | Supported<hr>Supported<hr>Supported on 1.3.0+      | Supported<hr>Supported<hr><i class="fa-solid fa-ban" style="color: red"></i> Not supported |
| Ubuntu                                      | 18.04 (<i class="fa-solid fa-exclamation-triangle" style="color: orange"></i> Deprecated, see modules)<hr>20.04<hr>22.04 | x86_64<hr>x86_64<hr>x86_64  | Supported (up to 2.13)<hr>Supported<hr>Supported on 2.3.0+ | Supported (up to 1.9.0)<hr>Supported<hr>Supported  | Supported (up to 4.5)<hr>Supported<hr><i class="fa-solid fa-ban" style="color: red"></i> Not supported |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}