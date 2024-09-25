1. Upload **nginx-repo.key** to **/etc/apk/cert.key** and **nginx-repo.crt** to **/etc/apk/cert.pem**. Make sure that files do not contain other certificates and keys: Alpine Linux does not support mixing client certificates for different repositories.

2. Install prerequisite packages:

    ```shell
    sudo apk add openssl ca-certificates
    ```

3. Put NGINX signing public key to directory `/etc/apk/keys`:

    ```shell
    sudo wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub
    ```