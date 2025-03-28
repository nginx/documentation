Add the NGINX Plus repository:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-plus.list
```

Add the NGINX App Protect WAF v5 repository:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect-x-plus/ubuntu `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
```

Install the NGINX App Protect WAF v5 package:

```shell
sudo apt-get update
sudo apt-get install app-protect-module-plus
```