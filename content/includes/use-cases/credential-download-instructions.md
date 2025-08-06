---
files:
- content/nginx/admin-guide/installing-nginx/installing-nginx-docker.md
- content/nic/installation/nic-images/registry-download.md
---

In order to obtain a container image, you will need the JSON Web Token file or SSL certificate and private key files provided with your NGINX Plus subscription. 

These files grant access to the package repository from which the script will download the NGINX Plus package:

{{< tabs name="product_keys" >}}

{{% tab name="JSON Web Token" %}}

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

{{% /tab %}}

{{% tab name="SSL" %}}

{{< include "licensing-and-reporting/download-certificates-from-myf5.md" >}}

{{% /tab %}}

{{< /tabs >}}