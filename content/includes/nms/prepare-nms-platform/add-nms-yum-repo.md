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
