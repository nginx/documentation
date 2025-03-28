Create the file named `/etc/yum.repos.d/nginx.repo` with the following contents:

```none
[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
```

Create NGINX App Protect WAF v5 repository file, named `/etc/yum.repos.d/app-protect-x-oss.repo` with the following contents:

```none
[app-protect-x-oss]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-oss/centos/7/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the NGINX App Protect WAF v5 package.

```shell
sudo yum install app-protect-module-oss
```

When prompted to accept the GPG key, verify that the fingerprint matches `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`, and if so, accept it.
