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

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1053 -->