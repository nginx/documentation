1. Add the NGINX Plus repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/nginx-plus.list
    ```

2. Add the NGINX App Protect WAF v5 repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/app-protect-x-plus/debian `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
    ```