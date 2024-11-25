1. Create the `/etc/ssl/nginx` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

1. Upload the **nginx-repo.crt** and **nginx-repo.key** files to the `/etc/ssl/nginx/` directory.

1. Remove any previously downloaded NGINX repository files from `/etc/yum.repos.d`:

    ```shell
    sudo rm /etc/yum.repos.d/nginx*.repo
    sudo rm /etc/yum.repos.d/*app-protect*.repo
    ```

1. Install the required dependencies:

    ```shell
    sudo dnf install ca-certificates wget
    ```

1. Download the `dependencies.repo` file to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.amazonlinux2023.repo
    ```
