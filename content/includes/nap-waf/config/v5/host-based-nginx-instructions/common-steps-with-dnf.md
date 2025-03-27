Create the `/etc/ssl/nginx/` directory:

```shell
sudo mkdir -p /etc/ssl/nginx
```

Upload **nginx-repo.crt** and **nginx-repo.key** files to the `/etc/ssl/nginx/` directory.

Remove any previously downloaded NGINX repository files from `/etc/yum.repos.d`:

```shell
sudo rm /etc/yum.repos.d/nginx*.repo
sudo rm /etc/yum.repos.d/*app-protect*.repo
```

Install required dependencies:

```shell
sudo dnf install ca-certificates wget
```

Download the `dependencies.repo` file to `/etc/yum.repos.d`:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
```