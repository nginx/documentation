### Prerequisites

{{< include "nms/prepare-nms-platform/nms-prereqs.md" >}}

### Install NGINX

{{< include "nms/prepare-nms-platform/install-nginx.md" >}}

### Install ClickHouse {#install-clickhouse}

{{< include "nms/prepare-nms-platform/install-clickhouse.md" >}}

### (Optional) Install and Configure Vault {#install-vault}

{{< include "nms/prepare-nms-platform/configure-vault.md" >}}

### Add NGINX Management Suite Repo {#add-nms-repo}

To install NGINX Management Suite, you need to add the official NGINX repo to pull the packages from. Which repo you need to add -- Yum or Apt -- depends on your Linux distribution.

#### Add `.crt` and `.key` files to `etc/ssl/nginx`

{{< include "nms/prepare-nms-platform/place-cert-key-files.md" >}}

#### Add NGINX Management Suite Repo to Yum or Apt {#add-yum-apt}

Select the tab matching your distribution type, then follow the instructions to add the NGINX Management Suite repo.

<br>

{{<tabs name="install_repo">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

{{< include "nms/prepare-nms-platform/add-nms-yum-repo.md" >}}

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

{{< include "nms/prepare-nms-platform/add-nms-apt-repo.md" >}}

{{%/tab%}}
{{</tabs>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1054 -->