1. Set up the apk repository for mainline nginx packages:

    ```shell
    printf "%s%s%s\n" \
    "http://nginx.org/packages/mainline/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | sudo tee -a /etc/apk/repositories
    ```

2. Add the NGINX App Protect WAF v5 apk repository:

    ```shell
    printf "https://pkgs.nginx.com/app-protect-x-oss/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```