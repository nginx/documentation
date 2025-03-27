Create the `/etc/ssl/nginx/` directory:

```shell
sudo mkdir -p /etc/ssl/nginx
```

Upload **nginx-repo.crt** and **nginx-repo.key** files to the `/etc/ssl/nginx/` directory.

Remove any previous NGINX repository and apt configuration files:

```shell
sudo rm /etc/apt/sources.list.d/nginx*.list
sudo rm /etc/apt/sources.list.d/*app-protect*.list
sudo rm /etc/apt/apt.conf.d/90pkgs-nginx
```

Install prerequisite packages:

```shell
sudo apt-get update && sudo apt-get install apt-transport-https lsb-release ca-certificates wget gnupg2 ubuntu-keyring
```

Download and add the NGINX signing key:

```shell
wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | \
sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
```

Download the apt configuration to `/etc/apt/apt.conf.d`:

```shell
sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
```

Verify that the downloaded file contains the proper key:

```shell
gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
```

The output should contain the full fingerprint `573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62` as follows:

```none
pub   rsa2048 2011-08-19 [SC] [expires: 2027-05-24]
        573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
uid                      nginx signing key <signing-key@nginx.com>
```

If the fingerprint is different, remove the file.
