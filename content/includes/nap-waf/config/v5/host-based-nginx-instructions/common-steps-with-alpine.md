Move **nginx-repo.key** to **/etc/apk/cert.key** and **nginx-repo.crt** to **/etc/apk/cert.pem**. 

Make sure that files do not contain other certificates and keys: Alpine Linux does not support mixing client certificates for different repositories.

Install prerequisite packages:

```shell
sudo apk add openssl ca-certificates
```

Add the NGINX signing public key to the directory `/etc/apk/keys`:

```shell
sudo wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub
```