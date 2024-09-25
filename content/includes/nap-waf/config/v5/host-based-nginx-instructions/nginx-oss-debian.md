1. Add the NGINX Open Source repository:

    ```shell
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" | \
    sudo tee /etc/apt/sources.list.d/nginx.list
    ```

2. Set up repository pinning to prefer our packages over distribution-provided ones:

    ```shell
    echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | \
    sudo tee /etc/apt/preferences.d/99nginx
    ```

3. Add the NGINX App Protect WAF v5 repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/app-protect-x-oss/debian `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
    ```
