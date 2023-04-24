Use the `helper.sh` script to change the SMTP address; port; TLS; sender; and optionally, the username and password.

``` bash
/opt/nginx-controller/helper.sh configsmtp <address> <port> <tls> <from> [auth] [username] [password]
```

For example:

``` bash
/opt/nginx-controller/helper.sh configsmtp 192.0.2.0 25 false noreply@nginx.test true user1 password1
```

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Options  | Description |
|----------|-------------|
| `address`  | The host name or IP address of the SMTP server. |
| `port`     | The port of the SMTP server. |
| `tls`      | `true` or `false`. Set to `true` to require SSL for connections to the SMTP server. |
| `from`     | Sender's email address. |
| `auth`     | `true` or `false`. Set to `true` to authenticate when connecting to the SMTP server. |
| `username` | The username to use for access to the SMTP server. |
| `password` | The password to use for access to the SMTP server. |

&nbsp;

### Environment Variables

We strongly recommend that you use environment variables, especially for passwords, to prevent exposing sensitive information in system processes (for example, `ps`, `top`) and the bash history.

You use these SMTP environment variables with NGINX Controller:

| Environment Variables  | Description |
|----------|-------------|
| `CTR_SMTP_HOST` | The host name or IP address of the SMTP server. |
| `CTR_SMTP_PORT` | The port of the SMTP server.
| `CTR_SMTP_TLS` |  `true` or `false`; Set to `true` to require SSL for connections to the SMTP server. |
| `CTR_SMTP_FROM` | Sender's email address. |
| `CTR_SMTP_AUTH` | `true` or `false`; Set to `true` to authenticate when connecting to the SMTP server. |
| `CTR_SMTP_USER` | The username to use for access to the SMTP server. |
| `CTR_SMTP_PASS` | The password to use for access to the SMTP server. |

For example:

``` bash
CTR_SMTP_HOST=192.0.2.0 \
CTR_SMTP_PORT=25 \
CTR_SMTP_TLS=false \
CTR_SMTP_FROM=noreply@nginx.test \
CTR_SMTP_AUTH=true CTR_SMTP_USER=user1 CTR_SMTP_PASS=password1 \
/opt/nginx-controller/helper.sh configsmtp
```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-282 -->
