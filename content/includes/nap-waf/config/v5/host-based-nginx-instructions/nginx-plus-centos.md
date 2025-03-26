Create NGINX App Protect WAF v5 repository file, named `/etc/yum.repos.d/app-protect-x-plus.repo` with the following contents:

```none
[app-protect-x-plus]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/8/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the NGINX App Protect WAF v5 package:

```shell
sudo dnf install app-protect-module-plus
```