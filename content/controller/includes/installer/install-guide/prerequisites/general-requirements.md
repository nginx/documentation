Before installing NGINX Controller, review the following prerequisites.

{{< important >}}
NGINX Controller should be deployed on a secure, internal network only. We strongly recommend against exposing the NGINX Controller API to the internet.
{{< /important >}}

Things you'll need before installing NGINX Controller:

* The `controller-installer-<version>.tar.gz` package, downloaded from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads);

* A license file for NGINX Controller, accessible via the [MyF5 Customer Portal](https://account.f5.com/myf5);

* A dedicated environment (bare metal, VM, or cloud-hosted instance) on which to install NGINX Controller. For the supported Operating Systems and recommended specifications, see the [NGINX Controller Technical Specifications]({{< relref "admin-guides/install/nginx-controller-tech-specs" >}}) guide;

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-288 -->