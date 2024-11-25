---
docs: DOCS-1322
---

Run the following command to upgrade the NGINX instance deployment:

- Replace `<path-to-your-values.yaml>` with the path to the [values.yaml file you created]({{< relref "/nim/deploy/kubernetes/deploy-using-helm.md#configure-chart" >}}).
- Replace `YourPassword123#` with a secure password that contains a combination of uppercase and lowercase letters, numbers, and special characters.

    {{< important >}}Make sure to copy and save the password for future reference. Only the encrypted password is stored in Kubernetes. There's no way to recover or reset a lost password.{{< /important >}}

- (Optional) Replace `<nms-chart-version>` with the desired version; see the table below for the available versions. Alternatively, you can omit this flag to install the latest version.

```bash
helm upgrade -n nms --set nms-hybrid.adminPasswordHash=$(openssl passwd -6 'YourPassword123#') nms nginx-stable/nms -f <path-to-your-values.yaml> [--version <nms-chart-version>] --wait
```

This command upgrades an existing Helm chart deployment named `nms` with a new version of the chart located in the `nginx-stable/nms` repository. It also sets the value of the `nms-hybrid.adminPasswordHash` to the hashed version of the provided password and uses a `values.yaml` file located at the provided path.
