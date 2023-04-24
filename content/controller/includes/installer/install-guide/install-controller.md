Install NGINX Controller on a dedicated node that **does not** already have Kubernetes configured. NGINX Controller does not support pre-configured Kubernetes implementations at this time. The installer for NGINX Controller will install and configure Kubernetes for you.

{{< important >}}Before installing NGINX Controller, you must **disable swap on the host**; this is required by Kubernetes in order for the kubelet to work properly. Refer to your Linux distribution documentation for specific instructions for disabling swap for your system. For more information about this requirement, see the AskF5 knowledge base article [K82655201](https://support.f5.com/csp/article/K82655201) and the [kubeadm installation guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin) in the Kubernetes documentation.{{< /important >}}

{{< caution >}}**For RHEL 8 deployments**, complete the additional prerequisite steps in the [Installing NGINX on RHEL 8]({{< relref "/admin-guides/install/install-nginx-controller-rhel-8.md" >}}) guide before installing NGINX Controller. RHEL 8 support is a **beta** feature.{{< /caution >}}

To install NGINX Controller, take the following steps:

1. Download the NGINX Controller installer package from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads).
1. Extract the installer package files:

    ```bash
    tar xzf controller-installer-<version>.tar.gz
    ```

1. Run the install script:

    ```bash
    cd controller-installer
    ./install.sh
    ```

    {{< important >}}Installing NGINX Controller as `root` is **not supported** on multi-node clusters. Instead, create a user with `sudo` permission for installing and performing all operations with NGINX Controller. Further, NGINX Controller scripts should also run with this dedicated user; scripts shouldn't be run as `sudo`, `sudo su`, or as the `root` user directly.{{< /important >}}

    {{< note >}}If an HTTPS proxy is configured for the whole system, you should disable the proxy for the IP address and hostname of the host that you're running the NGINX Controller install script on.
    For example, run the command `export NO_PROXY=<current_ip>,<current_hostname>`. {{< /note >}}

    The installation script walks through a series of steps and asks for the following input:

    - **Config database configuration**. Specify whether to use an embedded, self-hosted PostgreSQL database for the config database, or if you want to provide your own external PostgreSQL database. If you choose to provide your own database, make sure you've reviewed the [PostgreSQL prerequisites](#postgresql-optional).
    - **Config database volume type**: Specify the type of volume to use to store the config database: local, NFS, or AWS. We recommend choosing `local` only for demo and trial purposes.

      {{< see-also >}}Refer to the [NGINX Controller Technical Specifications Guide]({{< relref "admin-guides/install/nginx-controller-tech-specs.md#local-or-external-storage" >}}) for more information about the volume options and requirements.{{< /see-also >}}

    - **Analytics database volume type**: Specify the type of volume to use to store the analytics database: local, NFS, or AWS. We recommend choosing `local` for demo and trial purposes.
    - **EULA**: Read the end-user license agreement. Type either `y` to accept or `n` to exit.
    - **SMTP**
      - **SMTP Host**: Provide the host name or IP address of an SMTP server. This is used to send password recovery emails. For trial purposes, if you don't need to receive these communications, you can enter a value of "example.com" or something similar.
      - **SMTP Port**: The port of the SMTP server.
      - **SMTP Authentication**: Select `y` or `n` to authenticate when connecting to the SMTP server.
      - **Use TLS for SMTP Communication**: Select `y` or `n` to use SSL for SMTP server connections.
      - **Do not reply email address**: The sender's email address. For example, `donotreply@example.com`.
    - **Admin**
      - **First name**: The first name for the initial admin user.
      - **Last name**: The last name for the initial admin user.
      - **Email address**: The contact email address for the initial admin user.
      - **Password**: The initial admin's password. Passwords must be 6-64 characters long and must include letters and digits.
    - **FQDN**: Fully qualified domain name (FQDN) -- a resolvable domain name for the NGINX Controller server. The FQDN is used by Controller Agents when connecting to NGINX Controller.
    {{< note >}}We recommend setting the FQDN to a internal address when possible, to avoid exposing the traffic between the Agent and NGINX Controller. This also reduces the external traffic in cloud environments. {{< /note >}}
    - **SSL/TLS certificates**: Type `y` to generate and use self-signed certs for running NGINX Controller over HTTPS, or type `n` to provide your own certs.

        {{< important >}}If you provide your own SSL/TLS certificates, you'll need a complete certificate chain file, with the intermediate CA cert appended to the server cert; the server certificate must appear **before** the chained certificates in the combined file. If the certificate contains a wildcard Common Name (CN=*.example.com) it must also contain a Subject Alternate Name (SAN=nginx-controller.example.com). {{< /important >}}

1. Log in to the NGINX Controller browser interface by navigating to the DNS, FQDN, or IP address of the NGINX Controller host, for example, `https://<Controller-FQDN>/login`. Use the admin email address and password that you provided during the installation process.

1. Once the NGINX Controller installation has completed, you may safely delete the installer package that you downloaded and extracted.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-285 -->