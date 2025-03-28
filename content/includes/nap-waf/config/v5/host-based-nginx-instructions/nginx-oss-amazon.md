Create the file named `/etc/yum.repos.d/nginx.repo` with the following contents:

```none
[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/amzn/2023/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
```

Create the NGINX App Protect WAF v5 repository file, named `/etc/yum.repos.d/app-protect-x-oss.repo` with the following contents:

```none
[app-protect-x-oss]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-oss/amzn/2023/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the NGINX App Protect WAF v5 package.

```shell
sudo dnf install app-protect-module-oss
```