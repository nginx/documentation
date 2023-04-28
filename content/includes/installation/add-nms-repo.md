---
docs: "000"
---
Select the tab matching your Linux distribution, then follow the instructions to add the NGINX Management Suite repository.

<br>

{{<tabs name="install_repo">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. Add the NGINX Management Suite Yum repository:

   ```bash
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms.repo
   ```

   - RHEL 8:

      If you're installing on RHEL 8 and using the distro's NGINX, run the following commands to use the new version of NGINX (1.20 at the time of this update):

      ```bash
      sudo yum module disable nginx:1.14
      sudo yum module enable nginx:1.20
      ```

1. Add the [NGINX Signing Key](https://nginx.org/keys/nginx_signing.key) to the Yum repository:

    ```bash
    curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
    sudo rpmkeys --import /tmp/nginx_signing.key
    ```

1. (Optional) Alternatively, create a file called `/etc/yum.repos.d/nms.repo` and paste in the following configuration:

   ```text
   [nms]
   name=NGINX Management Suite
   baseurl=https://pkgs.nginx.com/nms/centos/$releasever/$basearch/
   sslclientcert=/etc/ssl/nginx/nginx-repo.crt
   sslclientkey=/etc/ssl/nginx/nginx-repo.key
   enabled=1
   ```

   - Amazon Linux 2:

      If you're installing on Amazon Linux 2, the `baseurl` should be: `baseurl=https://pkgs.nginx.com/nms/amzn2/$releasever/$basearch/`.

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. Add the NGINX Management Suite Apt repository:

   - Debian:

      ```bash
      printf "deb https://pkgs.nginx.com/nms/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
      sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
      ```

   - Ubuntu:

      ```bash
      printf "deb https://pkgs.nginx.com/nms/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
      sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
      ```

1. Add the [NGINX Signing Key](https://nginx.org/keys/nginx_signing.key) to Apt repository:

    ```bash
    wget -O /tmp/nginx_signing.key https://cs.nginx.com/static/keys/nginx_signing.key
    sudo apt-key add /tmp/nginx_signing.key
    ```

1. (Optional) As an alternative to downloading the `90pkgs-nginx` file from our website, you can upload the file's contents using any other means. The content of the file should match the following:

   ```bash
   Acquire::https::pkgs.nginx.com::Verify-Peer "true";
   Acquire::https::pkgs.nginx.com::Verify-Host "true";
   Acquire::https::pkgs.nginx.com::SslCert "/etc/ssl/nginx/nginx-repo.crt";
   Acquire::https::pkgs.nginx.com::SslKey "/etc/ssl/nginx/nginx-repo.key";
   ```

{{%/tab%}}
{{</tabs>}}
