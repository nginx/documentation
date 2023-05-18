Install NGINX Controller on a dedicated node that **does not** already have Kubernetes configured. NGINX Controller does not support pre-configured Kubernetes implementations at this time. The installer for NGINX Controller will install and configure Kubernetes for you.

{{< important >}}Before installing NGINX Controller, you must **disable swap on the host**; this is required by Kubernetes in order for the kubelet to work properly. Refer to your Linux distribution documentation for specific instructions for disabling swap for your system. For more information about this requirement, see the AskF5 knowledge base article [K82655201](https://support.f5.com/csp/article/K82655201) and the [kubeadm installation guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin) in the Kubernetes documentation.{{< /important >}}

{{< caution >}}**For RHEL 8 deployments**, complete the additional prerequisite steps in the [Installing NGINX on RHEL 8]({{< relref "/admin-guides/install/install-nginx-controller-rhel-8.md" >}}) guide before installing NGINX Controller. RHEL 8 support is a **beta** feature.{{< /caution >}}

To install NGINX Controller, take the following steps:

1. Download the NGINX Controller installer package from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads).
1. Extract the installer package files:

    ```bash
    tar xzf controller-installer-<version>.tar.gz
    ```

1. Run the installation script:

    ```bash
    cd controller-installer
    ./install.sh
    ```

1. When prompted to use an embedded config DB, type `y`.

1. The installation script walks through a series of steps and asks for the following inputs:

    - **Config database volume type**: Specify the type of volume to use to store the config database: local, NFS, or AWS. We recommend choosing `local` for demo and trial purposes.

      {{< see-also >}}Refer to the [NGINX Controller Technical Specifications Guide]({{< relref "/admin-guides/install/nginx-controller-tech-specs.md#local-or-external-storage" >}}) for more information about the volume options and requirements.{{< /see-also >}}

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
    - **FQDN**: Fully qualified domain name (FQDN) -- a resolvable domain name for the NGINX Controller server. You can use the FQDN to access the NGINX Controller web interface. 
      Additionally, the FQDN is used by Controller Agents when connecting to NGINX Controller.
    - **SSL/TLS certificates**: Type `y` to generate and use self-signed certs for running NGINX Controller over HTTPS, or type `n` to provide your own certs.

        {{< important >}}
If you provide your own SSL/TLS certificates, you'll need a complete certificate chain file, with the intermediate CA cert appended to the server cert; the server certificate must appear **before** the chained certificates in the combined file.
        {{< /important >}}

1. Log in to NGINX Controller at `https://<Controller-FQDN>/login`. Use the admin email address and password that you provided during the installation process.

1. Once NGINX Controller is installed, you may safely delete the installer package that you downloaded and extracted.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-330 -->