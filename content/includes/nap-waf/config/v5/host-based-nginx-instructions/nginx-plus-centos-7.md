1. Download the NGINX Plus repository file [nginx-plus-amazon2.repo](https://cs.nginx.com/static/files/nginx-plus-amazon2.repo) to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-amazon2.repo
    ```

2. Create NGINX App Protect WAF v5 repository file, named `/etc/yum.repos.d/app-protect-x-plus.repo` with the following contents:

    ```none
    [app-protect-x-plus]
    name=nginx-app-protect repo
    baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/7/$basearch/
    sslclientcert=/etc/ssl/nginx/nginx-repo.crt
    sslclientkey=/etc/ssl/nginx/nginx-repo.key
    gpgcheck=0
    enabled=1
    ```

3. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo yum install app-protect-module-plus
    ```