To install NGINX Plus as a data plane for NGINX Controller, you need to have the NGINX repository key and certificate files.

{{< deprecated >}}Using the helper.sh script to download your NGINX Plus certificate and key bundle is deprecated in in NGINX Controller v3.9.{{< /deprecated >}}

{{< see-also >}}If you're running NGINX Controller v3.10+, you can use the REST API to [Download the NGINX Plus Cert and Key Bundle]({{< relref "admin-guides/install/get-n-plus-cert-and-key.md" >}}). {{< /see-also >}}&nbsp;

If you're running NGINX Controller 3.9 or earlier, use the `helper.sh` script to extract the NGINX repository key and certificate files:

```bash
/opt/nginx-controller/helper.sh repository-cred [-c|--cert <file name>] [-k|--key <file name>]
```

{{< important >}}

Make sure that you've [uploaded your license in NGINX Controller]({{< relref "licensing-controller.md" >}}) first before running the `helper.sh repository-cred` command to extract the repository files.

{{< /important >}}

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
| `-c` \| `--cert`  | Creates a certificate called `<file name>`. The default file name is `nginx-repo.crt` in the current directory.|
| `-k` \| `--key`  | Creates a key called `<file name>`. The default file name is `nginx-repo.key` in the current directory. |
<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-274 -->
