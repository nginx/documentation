Add the NGINX Plus apk repository to `/etc/apk/repositories` file:

```shell
printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
```

Add the NGINX App Protect WAF v5 repository:

```shell
printf "https://pkgs.nginx.com/app-protect-x-plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
```

Install the NGINX App Protect WAF v5 package:

```shell
sudo apk add app-protect-module-plus
```