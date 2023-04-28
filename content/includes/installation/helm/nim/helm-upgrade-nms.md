Run the following command to upgrade the NGINX Management Suite deployment:

```shell
helm upgrade -n nms --set nms-hybrid.adminPasswordHash=$(openssl passwd -6 'YourPassword123#') nms nginx-stable/nms -f <path-to-your-values.yaml> [--version <desired-version>] --wait
```

This command upgrades an existing Helm chart deployment named `nms` with a new version of the chart located in the `nginx-stable/nms` repository. It also sets the value of the `nms-hybrid.adminPasswordHash` to the hashed version of the provided password and uses a `values.yaml` file located at the provided path.
