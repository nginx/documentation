Download the NGINX Plus repository file [plus-amazonlinux2023.repo](https://cs.nginx.com/static/files/plus-amazonlinux2023.repo) to `/etc/yum.repos.d`:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-amazonlinux2023.repo
```

Create F5 WAF for NGINX v5 repository file, named `/etc/yum.repos.d/app-protect-x-plus.repo` with the following contents:

```none
[app-protect-x-plus]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-plus/amzn/2023/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX v5 package:

```shell
sudo dnf install app-protect-module-plus
```