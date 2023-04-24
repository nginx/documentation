You can create a support package for NGINX Controller that you can use to diagnose issues. 

{{< note >}}
You will need to provide a support package if you open a ticket with NGINX Support via the [MyF5 Customer Portal](https://account.f5.com/myf5).
{{< /note >}}&nbsp;

```bash
/opt/nginx-controller/helper.sh supportpkg [-o|--output <file name>] [-s|--skip-db-dump] [-t|--timeseries-dump <hours>]
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
| `-o` \| `--output`  | Save the support package file to `<file name>`. |
| `-s` \| `--skip-db-dump` | Don't include the database dump in the support package. |
| `-t` \| `--timeseries-dump <hours>` | Include the last `<n hours>` of timeseries data in the support package (default 12 hours). |

Take the following steps to create a support package:

1. Open a secure shell (SSH) connection to the NGINX Controller host and log in as an administrator.

1. Run the `helper.sh` utility with the `supportpkg` option:

    ```bash
    /opt/nginx-controller/helper.sh supportpkg
    ```

    The support package is saved to:

    `/var/tmp/supportpkg-<timestamp>.tar.gz`

    For example:

    `/var/tmp/supportpkg-20200127T063000PST.tar.gz`

1. Run the following command on the machine where you want to download the support package to:

    ``` bash
    scp <username>@<controller-host-ip>:/var/tmp/supportpkg-<timestamp>.tar.gz /local/path
    ```
<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-273 -->
