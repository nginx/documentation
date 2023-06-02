---
docs: 000
---

You can use the `basic_passwords.sh` script to add a user's encrypted password to the `/etc/nms/nginx/.htpasswd` file on the NGINX Management Suite server. 

{{<note>}}The `basic_passwords.sh` script requires the [OpenSSL](https://www.openssl.org) package. We strongly recommend **OpenSSL v1.1.1 or later**.{{</note>}}

To change a user's password with the `basic_passwords.sh` script:

1. Open an SSH connection to your NGINX Management Suite host and log in.
2. Run the `basic_passwords.sh` script, providing the username you want to update and the desired password. Make sure to enclose the password in single quotation marks.

    ```bash
    sudo bash /etc/nms/scripts/basic_passwords.sh <username> '<desired password>'
    ```

    For example:

    ```bash
    sudo bash /etc/nms/scripts/basic_passwords.sh johndoe 'jelly22fi$h'
    ```
