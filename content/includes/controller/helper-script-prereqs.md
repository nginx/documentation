You can use the NGINX Controller `helper.sh prereqs` command to install the required system packages and Docker CE.

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
| `base`  | Install the required Linux utilities. |
| `docker` | Install Docker CE. |
| `nfs` | Install NFS system packages. |

To install all of the NGINX Controller prerequisites for your system at the same time, take the following steps:

1. Download the NGINX Controller installer package from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads).

1. Extract the installer package files:

    ```bash
    tar xzf controller-installer-<version>.tar.gz
    ```

1. Run the helper script with the `prereqs` option:

    ```bash
    cd controller-installer
    ./helper.sh prereqs
    ```

{{< call-out "note" >}}
After you've installed NGINX Controller, you can install any of the prerequisites by running the following command:

  ```bash
/opt/nginx-controller/helper.sh prereqs [base|docker|nfs]
```

{{< /call-out >}}
<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-278 -->
