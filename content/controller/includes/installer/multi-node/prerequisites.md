Things you'll need before installing NGINX Controller as a resilient cluster:

- Three hosts on which you can install NGINX Controller to create a cluster
- The `controller-installer-<version>.tar.gz` package, which you can get from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads). You need to upload and extract this tarball **on each host**.
- A license file for NGINX Controller
- A tool to send API requests, such as Postman or curl
- An external volume for the config database

  When installing NGINX Controller, you can choose to have NGINX Controller install and manage a self-hosted -- also known as "embedded" -- [PostgreSQL](https://www.postgresql.org/) database for you; this is the recommended implementation. Alternatively, you can [install your own PostgreSQL database for the config database]({{< relref "/admin-guides/install/install-nginx-controller.md#postgresql-optional" >}}), which you manage; this is sometimes referred to as an "external config database" because it is externally managed by you. Regardless of whether you use an embedded or an externally managed config database, the config database must be on an external volume for resilient clusters.

- An external volume for the analytics database

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-305 -->