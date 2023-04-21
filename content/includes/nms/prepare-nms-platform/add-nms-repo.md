1. Add the NGINX Management Suite repository:

     - CentOS, RHEL, RPM-Based

          ```bash
          sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms.repo
          ```

          - RHEL 8:

          If you're installing on RHEL 8 and using the distro's NGINX, run the following commands to use the latest version of NGINX.
          You can find the latest released version on [nginx.org](https://nginx.org/en/download.html). 

            ```bash
            sudo yum module disable nginx:1.14
            sudo yum module enable nginx:1.22.1
            ```

     - Debian

          ```bash
          printf "deb https://pkgs.nginx.com/nms/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
          sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
          ```

     - Ubuntu

          ```bash
          printf "deb https://pkgs.nginx.com/nms/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
          sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
          ```

1. Add the [NGINX Signing Key](https://nginx.org/keys/nginx_signing.key) to the repository:

     - CentOS, RHEL, RPM-Based

          ```bash
          curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
          sudo rpmkeys --import /tmp/nginx_signing.key
          ```

     - Debian, Ubuntu, Deb-Based

          ```bash
          wget -O /tmp/nginx_signing.key https://cs.nginx.com/static/keys/nginx_signing.key
          sudo apt-key add /tmp/nginx_signing.key
          ```
