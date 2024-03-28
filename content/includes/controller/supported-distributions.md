---
docs: DOCS-323
---

NGINX Controller, the NGINX Controller Agent, and the NGINX Controller Application Security Add-on support the following distributions and architectures.

{{< see-also >}}Refer to the [NGINX Plus Technical Specifications](https://docs.nginx.com/nginx/technical-specs/) guide for the distributions that NGINX Plus supports.{{< /see-also >}}

{{< bootstrap-table "table table-striped table-bordered" >}}

|Distribution<br>and Version|NGINX Controller <br> (Control Plane)|Agent <br> (Data Plane)|ADC App. Sec.<br>(Data Plane)|APIM Adv. Sec.<br>(Data Plane)|Notes|
|--- |--- |--- |--- |--- |--- |
|Amazon Linux<br>2<br>(x86_64)| Not supported|v3.0+ |Not supported|Not supported| |
|Amazon Linux<br>2017.09+<br>(x86_64)| Not supported |v3.0+|Not supported |Not supported| |
|CentOS<br>6.5+<br>(x86_64)| Not supported |v3.0+| Not supported |Not supported| &#8226; CentOS 6.5 and later versions in the CentOS 6 family are partially supported. <br> &#8226; This distribution does not support <a href="#avrd">AVRD</a>.|
|CentOS<br>7.4+<br>(x86_64)|v3.0+|v3.0+ | v3.12+ |v3.19+| &#8226; CentOS 7.4 and later versions in the CentOS 7 family are supported.|
|Debian<br>8<br>(x86_64)| Not supported |v3.0–3.21|Not supported|Not supported|&#8226; This distribution does not support <a href="#avrd">AVRD</a>.|
|Debian<br>9<br>(x86_64)|v3.0+|v3.0–3.21 | v3.12+ |v3.19+ | |
|Debian<br>10<br>(x86_64)| Not supported |v3.17+ | v3.17+ |v3.19+| See the [NGINX Plus Admin Guide](https://docs.nginx.com/nginx/) for requirements for Debian 10. |
|Red Hat Enterprise Linux<br>6.5+| Not supported |v3.0+| Not supported | Not supported| &#8226; RHEL 6.5 and later versions in the RHEL 6 family are partially supported.|
|Red Hat Enterprise Linux<br>7.4+<br>(x86_64)|v3.5+|v3.5+ | v3.12+|v3.19+| &#8226; RHEL 7.4 and later versions in the RHEL 7 family are supported.<br>&#8226; SELinux may interfere with NGINX Controller installation and operation. If you do enable SELinux, it must use permissive mode. Use of enforcing mode is not supported. |
|Red Hat Enterprise Linux<br>8.0+<br>(x86_64)|v3.22+|v3.22+ | v3.22+| Not supported | &#8226; RHEL 8.0 and later versions in the RHEL 8 family are supported. <br>&#8226; SELinux may interfere with NGINX Controller installation and operation. If you do enable SELinux, it must use permissive mode. Use of enforcing mode is not supported. |
|Ubuntu<br>18.04 LTS<br>(x86_64)|v3.0+|v3.0+ |v3.13+|v3.19+| |
|Ubuntu<br>20.04 LTS<br>(x86_64)|v3.20+|v3.12+|v3.16.1+|v3.19+| |

{{< /bootstrap-table >}}


<a name="avrd"></a>

#### Analytics, Visibility, and Reporting Daemon (AVRD)

NGINX Controller v3.1 and later use an Analytics, Visibility, and Reporting daemon (AVRD) to aggregate and report app-centric metrics, which you can use to track and check the health of your apps. To learn more about these metrics, see the [NGINX Metrics Catalog]({{< relref "/controller/analytics/catalogs/metrics.md" >}}) topic.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-323 -->