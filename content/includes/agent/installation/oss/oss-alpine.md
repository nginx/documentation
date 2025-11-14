---
files:
   - content/agent/install-upgrade/install-from-oss-repo.md
   - content/nginx-one/agent/install-upgrade/install-from-oss-repo.md
---

1. Install the prerequisites:

   ```shell
   sudo apk add openssl curl ca-certificates
   ```

1. To set up the apk repository for `nginx-agent` packages, run the following command:

   ```shell
   printf "%s%s%s\n" \
      "http://packages.nginx.org/nginx-agent/alpine/v" \
      `grep -o -E '^[0-9]+\.[0-9]+' /etc/alpine-release` \
      "/main" \
      | sudo tee -a /etc/apk/repositories
   ```

1. Next, import an official NGINX signing key so apk can verify the package's
authenticity. Fetch the key:

   ```shell
   curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub
   ```

1. Verify that downloaded file contains the proper key:

   ```shell
   openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout
   ```

   The output should contain the following modulus:

   ```
   Public-Key: (2048 bit)
   Modulus:
      00:fe:14:f6:0a:1a:b8:86:19:fe:cd:ab:02:9f:58:
      2f:37:70:15:74:d6:06:9b:81:55:90:99:96:cc:70:
      5c:de:5b:e8:4c:b2:0c:47:5b:a8:a2:98:3d:11:b1:
      f6:7d:a0:46:df:24:23:c6:d0:24:52:67:ba:69:ab:
      9a:4a:6a:66:2c:db:e1:09:f1:0d:b2:b0:e1:47:1f:
      0a:46:ac:0d:82:f3:3c:8d:02:ce:08:43:19:d9:64:
      86:c4:4e:07:12:c0:5b:43:ba:7d:17:8a:a3:f0:3d:
      98:32:b9:75:66:f4:f0:1b:2d:94:5b:7c:1c:e6:f3:
      04:7f:dd:25:b2:82:a6:41:04:b7:50:93:94:c4:7c:
      34:7e:12:7c:bf:33:54:55:47:8c:42:94:40:8e:34:
      5f:54:04:1d:9e:8c:57:48:d4:b0:f8:e4:03:db:3f:
      68:6c:37:fa:62:14:1c:94:d6:de:f2:2b:68:29:17:
      24:6d:f7:b5:b3:18:79:fd:31:5e:7f:4c:be:c0:99:
      13:cc:e2:97:2b:dc:96:9c:9a:d0:a7:c5:77:82:67:
      c9:cb:a9:e7:68:4a:e1:c5:ba:1c:32:0e:79:40:6e:
      ef:08:d7:a3:b9:5d:1a:df:ce:1a:c7:44:91:4c:d4:
      99:c8:88:69:b3:66:2e:b3:06:f1:f4:22:d7:f2:5f:
      ab:6d
   Exponent: 65537 (0x10001)
   ```

1. Finally, move the key to apk trusted keys storage:

   ```shell
   sudo mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/
   ```

1. To install `nginx-agent`, run the following command:

   ```shell
   sudo apk add nginx-agent
   ```